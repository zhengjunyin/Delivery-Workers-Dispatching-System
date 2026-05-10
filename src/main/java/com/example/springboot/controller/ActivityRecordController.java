package com.example.springboot.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.ActivityRecord;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IActivityRecordService;
import com.example.springboot.utils.PhoneUtils;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/activityRecord")
public class ActivityRecordController {

    @Resource
    private IActivityRecordService activityRecordService;

    @GetMapping("/count")
    public Result count() {
        Account account = SecurityUtils.currentUser();
        LambdaQueryWrapper<ActivityRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ActivityRecord::getUserId, account.getId());
        return Result.success(activityRecordService.list(wrapper));
    }

    @PostMapping
    public Result save(@RequestBody ActivityRecord activityRecord) {
        Account account = SecurityUtils.currentUser();
        activityRecord.setPhone(PhoneUtils.normalizeRequiredBelarusPhone(activityRecord.getPhone()));
        if (activityRecord.getId() == null) {
            activityRecord.setUserId(account.getId());
            activityRecord.setStatus("Not checked in");
        } else {
            ActivityRecord existing = requireExisting(activityRecord.getId());
            SecurityUtils.requireOwnerOrAdmin(existing.getUserId());
            if (!SecurityUtils.isAdmin(account)) {
                activityRecord.setUserId(existing.getUserId());
                activityRecord.setStatus(existing.getStatus());
                activityRecord.setTime(existing.getTime());
            }
        }
        return Result.success(activityRecordService.saveOrUpdate(activityRecord));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        ActivityRecord existing = requireExisting(id);
        SecurityUtils.requireOwnerOrAdmin(existing.getUserId());
        return Result.success(activityRecordService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        return Result.success(activityRecordService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        SecurityUtils.requireAdmin();
        return Result.success(activityRecordService.list());
    }

    @GetMapping("/join/{id}")
    public Result join(@PathVariable Integer id) {
        SecurityUtils.requireAdmin();
        ActivityRecord activityRecord = requireExisting(id);
        activityRecord.setStatus("Joined");
        activityRecord.setTime(DateUtil.now());
        activityRecordService.updateById(activityRecord);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        ActivityRecord record = requireExisting(id);
        SecurityUtils.requireOwnerOrAdmin(record.getUserId());
        return Result.success(record);
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {

        LambdaQueryWrapper<ActivityRecord> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(ActivityRecord::getId);

        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(ActivityRecord::getItemId, keyword);
        }

        Account account = SecurityUtils.currentUser();
        if (!SecurityUtils.isAdmin(account)) {
            queryWrapper.eq(ActivityRecord::getUserId, account.getId());
        }

        return Result.success(activityRecordService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    private ActivityRecord requireExisting(Integer id) {
        ActivityRecord existing = activityRecordService.getById(id);
        if (existing == null) {
            throw new ServiceException(Constants.CODE_404, "Activity record not found");
        }
        return existing;
    }
}
