package com.example.springboot.controller;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Delivery;
import com.example.springboot.entity.Collect;
import com.example.springboot.service.IDeliveryService;
import com.example.springboot.service.ICollectService;
import com.example.springboot.utils.PhoneUtils;
import com.example.springboot.utils.SecurityUtils;
import com.example.springboot.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * <p>
 * 前端控制器
 * </p>
 */
@RestController
@RequestMapping("/delivery")
public class DeliveryController {

    @Resource
    private IDeliveryService deliveryService;

    @Resource
    private ICollectService collectService;

    @PostMapping
    public Result save(@RequestBody Delivery delivery) {
        SecurityUtils.requireAdmin();
        delivery.setIsbn(PhoneUtils.normalizeOptionalBelarusPhone(delivery.getIsbn()));
        return Result.success(deliveryService.saveOrUpdate(delivery));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        SecurityUtils.requireAdmin();
        return Result.success(deliveryService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        SecurityUtils.requireAdmin();
        return Result.success(deliveryService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {
        return Result.success(deliveryService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(deliveryService.getById(id));
    }

    @GetMapping("/front/page")
    public Result FrontPage(@RequestParam(defaultValue = "") String keyword,
                            @RequestParam Integer typeId,
                            @RequestParam Integer pageNum,
                            @RequestParam Integer pageSize) {
        LambdaQueryWrapper<Delivery> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StrUtil.isNotEmpty(keyword), Delivery::getName,keyword);
        queryWrapper.eq(typeId!=0, Delivery::getTypeId,typeId);
        queryWrapper.eq(Delivery::getStatus,true);
        return Result.success(deliveryService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    @GetMapping("/collect/page")
    public Result findCollectPage(@RequestParam(defaultValue = "") String keyword,
                                  @RequestParam Integer pageNum,
                                  @RequestParam Integer pageSize) {

        LambdaQueryWrapper<Collect> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Collect::getUserId, TokenUtils.getCurrentUser().getId());
        List<Integer> ids = collectService.list(wrapper).stream().map(Collect::getItemId).collect(Collectors.toList());
        if (CollectionUtil.isEmpty(ids)) return Result.success(collectService.page(new Page<>(),wrapper));

        LambdaQueryWrapper<Delivery> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Delivery::getId);

        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Delivery::getName, keyword);
        }

        queryWrapper.in(Delivery::getId,ids);

        return Result.success(deliveryService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }


    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String keyword) {

        LambdaQueryWrapper<Delivery> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByDesc(Delivery::getId);


        if (StrUtil.isNotBlank(keyword)) {
            queryWrapper.like(Delivery::getName, keyword);
        }

        return Result.success(deliveryService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

}
