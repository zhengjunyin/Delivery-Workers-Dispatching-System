package com.example.springboot.controller;


import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.example.springboot.common.Result;
import com.example.springboot.entity.Delivery;
import com.example.springboot.entity.WorkRecord;
import com.example.springboot.entity.Type;
import com.example.springboot.service.IDeliveryService;
import com.example.springboot.service.IWorkRecordService;
import com.example.springboot.service.ITypeService;
import com.example.springboot.utils.SecurityUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/echarts")
public class EchartsController {


    @Resource
    private IDeliveryService deliveryService;
    @Resource
    private ITypeService typeService;
    @Resource
    private IWorkRecordService workRecordService;


    @GetMapping("/count1")
    public Result count1(){
        SecurityUtils.requireAdmin();

        List<Type> typeList = typeService.list();
        List<Delivery> deliveryList = deliveryService.list();

        JSONArray array = new JSONArray();
        for (Type type : typeList) {
            int num = 0;
            for (Delivery delivery : deliveryList) {
                if (Objects.equals(delivery.getTypeId(), type.getId())){
                    num++;
                }
            }
            JSONObject object = new JSONObject();
            object.set("name", type.getName());
            object.set("value",num);
            array.add(object);
        }
        return Result.success(array);
    }

    @GetMapping("/count2")
    public Result count2(){
        SecurityUtils.requireAdmin();

        List<WorkRecord> workRecordList = workRecordService.list();
        List<Delivery> deliveryList = deliveryService.list();
        JSONArray array = new JSONArray();

        for (Delivery delivery : deliveryList) {
            int num = 0;
            for (WorkRecord workRecord : workRecordList) {
                if (Objects.equals(delivery.getId(), workRecord.getDeliveryId())){
                    num++;
                }
            }
            JSONObject object = new JSONObject();
            object.set("name", delivery.getName());
            object.set("value",num);
            array.add(object);
        }

        return Result.success(array);
    }


}
