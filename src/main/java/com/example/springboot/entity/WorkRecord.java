package com.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;



/**
 * <p>
 * 实体类
 * </p>
 */

@Data
@TableName(value = "workRecord")
public class WorkRecord {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer deliveryId;

    private Integer userId;

    private String date;

    private String endDate;

    private String backTime;

    private String status;


}
