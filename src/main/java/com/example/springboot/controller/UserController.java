package com.example.springboot.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.User;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IUserService;
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
@RequestMapping("/user")
public class UserController {

    @Resource
    private IUserService userService;

    @PostMapping
    public Result save(@RequestBody User user) {
        prepareSave(user);
        return Result.success(userService.saveOrUpdate(user));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        SecurityUtils.requireAdmin();
        return Result.success(userService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        return Result.success(userService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        SecurityUtils.requireAdmin();
        List<User> list = userService.list();
        SecurityUtils.clearPasswords(list);
        return Result.success(list);
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        Account account = SecurityUtils.currentUser();
        if (!SecurityUtils.isAdmin(account) && !id.equals(account.getId())) {
            throw new ServiceException(Constants.CODE_403, "No permission");
        }
        return Result.success(SecurityUtils.clearPassword(userService.getById(id)));
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        SecurityUtils.requireAdmin();

        LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(User::getId);

        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(User::getNickname, keyword);
        }

        Page<User> page = userService.page(new Page<>(pageNum, pageSize), queryWrapper);
        SecurityUtils.clearPasswords(page.getRecords());
        return Result.success(page);
    }

    private void prepareSave(User user) {
        if (user == null) {
            throw new ServiceException(Constants.CODE_400, "Invalid parameters");
        }
        user.setPhone(PhoneUtils.normalizeOptionalBelarusPhone(user.getPhone()));
        Account account = SecurityUtils.currentUser();
        if (!SecurityUtils.isAdmin(account)) {
            if (user.getId() == null || !user.getId().equals(account.getId())) {
                throw new ServiceException(Constants.CODE_403, "No permission");
            }
            User existing = userService.getById(user.getId());
            if (existing == null) {
                throw new ServiceException(Constants.CODE_404, "User not found");
            }
            user.setUsername(existing.getUsername());
            user.setPassword(existing.getPassword());
            return;
        }

        if (StrUtil.isBlank(user.getPassword())) {
            if (user.getId() == null) {
                throw new ServiceException(Constants.CODE_400, "Password is required");
            }
            User existing = userService.getById(user.getId());
            if (existing == null) {
                throw new ServiceException(Constants.CODE_404, "User not found");
            }
            user.setPassword(existing.getPassword());
            return;
        }
        if (!PasswordUtils.isHashed(user.getPassword())) {
            user.setPassword(PasswordUtils.hash(user.getPassword()));
        }
    }
}
