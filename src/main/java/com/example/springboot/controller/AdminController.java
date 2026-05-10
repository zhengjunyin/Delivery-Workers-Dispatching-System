package com.example.springboot.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Admin;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IAdminService;
import com.example.springboot.utils.PasswordUtils;
import com.example.springboot.utils.PhoneUtils;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 前端控制器
 * </p>
 */
@RestController
@RequestMapping("/admin")
public class AdminController {

    @Resource
    private IAdminService adminService;

    @PostMapping
    public Result save(@RequestBody Admin admin) {
        SecurityUtils.requireAdmin();
        preparePassword(admin);
        return Result.success(adminService.saveOrUpdate(admin));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        SecurityUtils.requireAdmin();
        return Result.success(adminService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        return Result.success(adminService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        SecurityUtils.requireAdmin();
        List<Admin> list = adminService.list();
        SecurityUtils.clearPasswords(list);
        return Result.success(list);
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        SecurityUtils.requireAdmin();
        return Result.success(SecurityUtils.clearPassword(adminService.getById(id)));
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        SecurityUtils.requireAdmin();

        LambdaQueryWrapper<Admin> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Admin::getId);

        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Admin::getNickname, keyword);
        }

        Page<Admin> page = adminService.page(new Page<>(pageNum, pageSize), queryWrapper);
        SecurityUtils.clearPasswords(page.getRecords());
        return Result.success(page);
    }

    private void preparePassword(Admin admin) {
        if (admin == null) {
            throw new ServiceException(Constants.CODE_400, "Invalid parameters");
        }
        admin.setPhone(PhoneUtils.normalizeOptionalBelarusPhone(admin.getPhone()));
        if (StrUtil.isBlank(admin.getPassword())) {
            if (admin.getId() == null) {
                throw new ServiceException(Constants.CODE_400, "Password is required");
            }
            Admin existing = adminService.getById(admin.getId());
            if (existing == null) {
                throw new ServiceException(Constants.CODE_404, "Admin not found");
            }
            admin.setPassword(existing.getPassword());
            return;
        }
        if (!PasswordUtils.isHashed(admin.getPassword())) {
            admin.setPassword(PasswordUtils.hash(admin.getPassword()));
        }
    }
}
