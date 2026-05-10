package com.example.springboot.controller;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IAdminService;
import com.example.springboot.service.IUserService;
import com.example.springboot.utils.SecurityUtils;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.Set;

@RestController
@RequestMapping("/web")
public class WebController {

    private static final Path FILE_UPLOAD_PATH =
            Path.of(System.getProperty("user.dir"), "files").toAbsolutePath().normalize();
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS =
            Set.of("jpg", "jpeg", "png", "gif", "webp");
    private static final long MAX_UPLOAD_SIZE = 10L * 1024 * 1024;

    @Value("${ip}")
    String ip;

    @Value("${server.port}")
    String port;

    @Resource
    private IUserService userService;
    @Resource
    private IAdminService adminService;

    @PostMapping("/login")
    public Result login(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getUsername())
                || StrUtil.isBlank(account.getPassword())
                || StrUtil.isBlank(account.getRole())) {
            return Result.error(Constants.CODE_400, "Invalid parameters");
        }

        if (StrUtil.equals(account.getRole(), SecurityUtils.ROLE_USER)) {
            account = userService.login(account);
        } else if (StrUtil.equals(account.getRole(), SecurityUtils.ROLE_ADMIN)) {
            account = adminService.login(account);
        } else {
            return Result.error(Constants.CODE_400, "Invalid role");
        }

        return Result.success(account);
    }

    @PostMapping("/register")
    public Result register(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getUsername())
                || StrUtil.isBlank(account.getPassword())
                || StrUtil.isBlank(account.getRole())) {
            return Result.error(Constants.CODE_400, "Invalid parameters");
        }

        if (StrUtil.equals(account.getRole(), SecurityUtils.ROLE_ADMIN)) {
            return Result.error(Constants.CODE_403, "Admin accounts can only be created by an administrator");
        }
        if (StrUtil.equals(account.getRole(), SecurityUtils.ROLE_USER)) {
            userService.register(account);
        } else {
            return Result.error(Constants.CODE_400, "Invalid role");
        }

        return Result.success();
    }

    @PostMapping("/password")
    public Result updatePassword(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getPassword()) || StrUtil.isBlank(account.getNewPassword())) {
            return Result.error(Constants.CODE_400, "Invalid parameters");
        }
        Account one = SecurityUtils.currentUser();
        account.setUsername(one.getUsername());

        if (StrUtil.equals(one.getRole(), SecurityUtils.ROLE_USER)) {
            userService.updatePassword(account);
        } else if (StrUtil.equals(one.getRole(), SecurityUtils.ROLE_ADMIN)) {
            adminService.updatePassword(account);
        }

        return Result.success();
    }

    @GetMapping("/userInfo")
    public Result userInfo() {
        Account account = SecurityUtils.currentUser();

        if (StrUtil.equals(account.getRole(), SecurityUtils.ROLE_USER)) {
            return Result.success(SecurityUtils.clearPassword(userService.getById(account.getId())));
        }
        if (StrUtil.equals(account.getRole(), SecurityUtils.ROLE_ADMIN)) {
            return Result.success(SecurityUtils.clearPassword(adminService.getById(account.getId())));
        }

        return Result.error(Constants.CODE_605, "Failed to get user information");
    }

    @PostMapping("/upload")
    public String upload(@RequestParam MultipartFile file) throws IOException {
        SecurityUtils.currentUser();
        if (file == null || file.isEmpty()) {
            throw new ServiceException(Constants.CODE_400, "File is empty");
        }
        if (file.getSize() > MAX_UPLOAD_SIZE) {
            throw new ServiceException(Constants.CODE_400, "File is too large");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = extensionOf(originalFilename);
        if (!ALLOWED_IMAGE_EXTENSIONS.contains(extension)) {
            throw new ServiceException(Constants.CODE_400, "Unsupported file type");
        }

        String contentType = file.getContentType();
        if (StrUtil.isNotBlank(contentType) && !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
            throw new ServiceException(Constants.CODE_400, "Unsupported file type");
        }

        Files.createDirectories(FILE_UPLOAD_PATH);
        String fileUUID = IdUtil.fastSimpleUUID() + StrUtil.DOT + extension;
        Path uploadFile = FILE_UPLOAD_PATH.resolve(fileUUID).normalize();
        if (!uploadFile.startsWith(FILE_UPLOAD_PATH)) {
            throw new ServiceException(Constants.CODE_400, "Invalid file path");
        }
        Files.copy(file.getInputStream(), uploadFile, StandardCopyOption.REPLACE_EXISTING);
        return "http://" + ip + ":" + port + "/web/download/" + fileUUID;
    }

    @GetMapping("/download/{fileUUID}")
    public void download(@PathVariable String fileUUID, HttpServletResponse response) throws IOException {
        String safeName = Path.of(fileUUID).getFileName().toString();
        if (!safeName.equals(fileUUID)) {
            throw new ServiceException(Constants.CODE_400, "Invalid file path");
        }

        Path uploadFile = FILE_UPLOAD_PATH.resolve(safeName).normalize();
        if (!uploadFile.startsWith(FILE_UPLOAD_PATH) || !Files.isRegularFile(uploadFile)) {
            throw new ServiceException(Constants.CODE_404, "File not found");
        }

        String contentType = Files.probeContentType(uploadFile);
        response.setContentType(StrUtil.isBlank(contentType) ? "application/octet-stream" : contentType);
        response.addHeader("Content-Disposition", "inline;filename="
                + URLEncoder.encode(safeName, StandardCharsets.UTF_8));

        try (ServletOutputStream os = response.getOutputStream()) {
            Files.copy(uploadFile, os);
            os.flush();
        }
    }

    private String extensionOf(String filename) {
        if (StrUtil.isBlank(filename) || filename.contains("/") || filename.contains("\\")) {
            throw new ServiceException(Constants.CODE_400, "Invalid file name");
        }
        int index = filename.lastIndexOf('.');
        if (index < 0 || index == filename.length() - 1) {
            throw new ServiceException(Constants.CODE_400, "Invalid file name");
        }
        return filename.substring(index + 1).toLowerCase(Locale.ROOT);
    }
}
