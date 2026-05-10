package com.example.springboot.controller;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Constants;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Account;
import com.example.springboot.entity.Delivery;
import com.example.springboot.entity.WorkRecord;
import com.example.springboot.exception.ServiceException;
import com.example.springboot.service.IDeliveryService;
import com.example.springboot.service.IWorkRecordService;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/workRecord")
public class WorkRecordController {

    @Resource
    private IWorkRecordService workRecordService;
    @Resource
    private IDeliveryService deliveryService;

    @GetMapping("/count")
    public Result count() {
        Account account = SecurityUtils.currentUser();
        LambdaQueryWrapper<WorkRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WorkRecord::getUserId, account.getId());
        return Result.success(workRecordService.list(wrapper));
    }

    @PostMapping
    public Result save(@RequestBody WorkRecord workRecord) {
        Account account = SecurityUtils.currentUser();
        LocalDate endDate = LocalDate.parse(workRecord.getEndDate());
        LocalDate today = LocalDate.now();

        if (endDate.isBefore(today)) {
            return Result.error("605", "Estimated completion time is earlier than current time, failed.");
        }

        Delivery delivery = deliveryService.getById(workRecord.getDeliveryId());
        if (delivery == null || !Boolean.TRUE.equals(delivery.getStatus())) {
            return Result.error("605", "Delivery staff is unavailable.");
        }
        if (delivery.getNum() == null || delivery.getNum() <= 0) {
            return Result.error("605", "No available delivery staff quota.");
        }
        delivery.setNum(delivery.getNum() - 1);
        deliveryService.updateById(delivery);

        workRecord.setId(null);
        workRecord.setDate(DateUtil.today());
        workRecord.setStatus("At work");
        workRecord.setUserId(account.getId());

        return Result.success(workRecordService.save(workRecord));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        WorkRecord existing = requireExisting(id);
        SecurityUtils.requireOwnerOrAdmin(existing.getUserId());
        return Result.success(workRecordService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        return Result.success(workRecordService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        SecurityUtils.requireAdmin();
        return Result.success(workRecordService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        WorkRecord record = requireExisting(id);
        SecurityUtils.requireOwnerOrAdmin(record.getUserId());
        return Result.success(record);
    }

    @GetMapping("/back/{id}")
    public Result back(@PathVariable Integer id) {
        SecurityUtils.requireAdmin();
        WorkRecord workRecord = requireExisting(id);
        if (!StrUtil.equals(workRecord.getStatus(), "Finished")) {
            workRecord.setStatus("Finished");
            workRecord.setBackTime(DateUtil.now());
            workRecordService.updateById(workRecord);

            Delivery delivery = deliveryService.getById(workRecord.getDeliveryId());
            if (delivery != null) {
                delivery.setNum((delivery.getNum() == null ? 0 : delivery.getNum()) + 1);
                deliveryService.updateById(delivery);
            }
        }
        return Result.success();
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {
        LambdaQueryWrapper<Delivery> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StrUtil.isNotBlank(keyword), Delivery::getName, keyword);
        List<Integer> ids = deliveryService.list(wrapper).stream()
                .map(Delivery::getId)
                .collect(Collectors.toList());
        if (CollectionUtil.isEmpty(ids)) {
            return Result.success(new Page<WorkRecord>(pageNum, pageSize));
        }

        LambdaQueryWrapper<WorkRecord> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(WorkRecord::getId);
        queryWrapper.in(WorkRecord::getDeliveryId, ids);

        Account account = SecurityUtils.currentUser();
        if (!SecurityUtils.isAdmin(account)) {
            queryWrapper.eq(WorkRecord::getUserId, account.getId());
        }
        return Result.success(workRecordService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    private WorkRecord requireExisting(Integer id) {
        WorkRecord existing = workRecordService.getById(id);
        if (existing == null) {
            throw new ServiceException(Constants.CODE_404, "Work record not found");
        }
        return existing;
    }
}
