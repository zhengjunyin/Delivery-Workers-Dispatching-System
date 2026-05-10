package com.example.springboot.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Collect;
import com.example.springboot.service.ICollectService;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/collect")
public class CollectController {

    @Resource
    private ICollectService collectService;

    @PostMapping
    public Result save(@RequestBody Collect collect) {
        Account currentUser = SecurityUtils.currentUser();
        LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Collect::getUserId, currentUser.getId());
        wrapper.eq(Collect::getItemId, collect.getItemId());
        if (collectService.count(wrapper) > 0) {
            return Result.error("605", "Already collected");
        }
        collect.setId(null);
        collect.setUserId(currentUser.getId());
        collectService.save(collect);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        Account currentUser = SecurityUtils.currentUser();
        LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Collect::getUserId, currentUser.getId());
        wrapper.eq(Collect::getItemId, id);
        collectService.remove(wrapper);
        return Result.success();
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        return Result.success(collectService.removeByIds(ids));
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        Account currentUser = SecurityUtils.currentUser();
        LambdaQueryWrapper<Collect> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Collect::getId);
        if (!SecurityUtils.isAdmin(currentUser)) {
            queryWrapper.eq(Collect::getUserId, currentUser.getId());
        }
        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Collect::getUserId, keyword);
        }

        return Result.success(collectService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }
}
