# 🛵配送骑手调度管理系统

<div align="center">

![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-brightgreen)
![Vue.js](https://img.shields.io/badge/Vue.js-3.x-4FC08D)
![Vite](https://img.shields.io/badge/Vite-4.x-646CFF)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1)
![License](https://img.shields.io/badge/license-MIT-blue)

一个基于 **Spring Boot + Vue.js** 的轻量级智能配送调度管理系统，适用于外卖、物流等即时配送场景的订单分配与骑手调度。

</div>

---

## ✨ 项目简介

**Delivery-Workers-Dispatching-System** 是一个面向实时配送场景的调度管理系统。通过管理订单信息、骑手状态和路径规划，旨在提高配送效率并优化人力资源调度。

本系统采用前后端分离架构，前端使用 Vue 3 + Vite 构建，后端基于 Spring Boot + MyBatis 开发，数据库使用 MySQL，并提供了完整的数据库初始化脚本和表结构设计文档。项目结构清晰，功能模块完善，可作为计算机专业课程设计、毕业设计，或小型配送企业调度管理系统的参考实现。

---

## 📸 界面预览

<div align="center">

> 部分功能截图（存放于 `files/` 目录下）
<img width="1920" height="869" alt="1c1d155e601d24c9c49ab53e09f01db6" src="https://github.com/user-attachments/assets/7c4fc46e-22b0-4f44-9656-e1f6e21ee95f" />
<img width="1920" height="869" alt="6ebc7468358b955a249cd073f2f5a7d3" src="https://github.com/user-attachments/assets/18bce436-7448-4c21-8a3d-c5eeddde8a59" /> 
</div>

---

## 🚀 功能模块

### 后端 API 模块
- **订单管理** – 订单创建、查询、状态流转（待接单 → 配送中 → 已完成）
- **骑手管理** – 骑手信息维护、在线状态、实时位置模拟
- **智能调度** – 基于距离/繁忙度的自动派单策略
- **用户管理** – 系统用户、管理员的增删改查与权限控制
- **活动/公告** – 平台活动发布与用户参与记录
- **评论管理** – 订单评价与回复

### 前端页面
- 管理员工作台（数据总览、图表）
- 订单列表与详情
- 骑手列表与轨迹查看
- 用户管理界面
- 活动与公告管理
- 个人中心与登录注册

---

## 🏗️ 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 前端 | Vue 3 + Vite | 组件化开发，快速构建 |
| 状态管理 | Pinia / Vuex | *(视项目具体引用)* |
| UI 框架 | Element Plus | 高效美观的组件库 |
| 后端 | Spring Boot 3.x | 简化配置，快速开发 |
| ORM | MyBatis / MyBatis-Plus | 灵活的数据访问层 |
| 数据库 | MySQL 8.0 | 关系型数据库 |
| 工具库 | Lombok, Hutool | 减少模板代码 |
| 构建工具 | Maven (后端) / Yarn (前端) | 依赖管理与打包 |

---

## 📁 项目结构

```
Delivery-Workers-Dispatching-System/
├── src/                          # 后端 Java 源码
│   ├── main/java/com/xxx/
│   │   ├── controller/           # 控制器层（REST API）
│   │   ├── service/              # 业务逻辑层
│   │   ├── mapper/               # MyBatis Mapper 接口
│   │   ├── entity/               # 数据库实体类
│   │   ├── config/               # Spring Boot 配置类
│   │   ├── common/               # 通用常量、工具类
│   │   └── exception/            # 全局异常处理
│   └── main/resources/
│       ├── application.yml       # 主配置文件
│       └── mapper/               # MyBatis XML 映射文件
├── vue/                          # 前端项目目录
│   ├── src/
│   │   ├── views/                # 页面视图组件
│   │   ├── components/           # 公共组件
│   │   ├── router/               # 路由配置
│   │   ├── store/                # 状态管理
│   │   ├── utils/                # 前端工具函数
│   │   ├── i18n/                 # 国际化（若存在）
│   │   └── style/                # 全局样式
│   ├── package.json
│   └── vite.config.js
├── table/                        # 数据库表结构设计（Excel）
├── files/                        # 项目截图等静态资源
├── pro_delivery.sql              # 数据库初始化脚本
└── pom.xml                       # Maven 项目对象模型
```

---

## 🔧 环境要求

- **JDK** 17 或以上  
- **Node.js** 16+  
- **MySQL** 8.0+  
- **Maven** 3.6+  
- **Yarn** (推荐) 或 npm  

---

## 📦 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/lsyaizyl/Delivery-Workers-Dispatching-System.git
cd Delivery-Workers-Dispatching-System
```

### 2. 数据库初始化

- 创建 MySQL 数据库（例如 `delivery_system`）
- 执行根目录下的 `pro_delivery.sql` 脚本导入表结构及初始数据

```sql
CREATE DATABASE delivery_system DEFAULT CHARACTER SET utf8mb4;
USE delivery_system;
SOURCE pro_delivery.sql;
```

- 打开 `src/main/resources/application.yml`，修改数据库连接信息：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/delivery_system?useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password
```

### 3. 启动后端

```bash
# 在项目根目录下执行
mvn clean install
mvn spring-boot:run
```

后端默认运行在 `http://localhost:8080`，可以通过 `src/main/resources/application.yml` 修改端口。

### 4. 启动前端

```bash
cd vue
yarn install    # 或 npm install
yarn dev        # 或 npm run dev
```

前端开发服务器默认运行在 `http://localhost:5173`，并在 `.env.development` 中配置后端 API 代理地址（如有需要）。

---

## 📚 API 文档

项目未集成 Swagger，但可通过浏览器开发者工具或 Postman 访问后端 REST 接口。  
主要 API 前缀通常为 `/api`，具体端点详见 `controller` 包中的 `@RequestMapping` 注解。

未来可集成 **Knife4j** 或 **SpringDoc** 自动生成接口文档。

---

## 🙌 贡献指南

欢迎提交 Issue 和 Pull Request 共同完善本项目。  
步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交修改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

---

## 📄 许可证

本项目基于 **MIT License** 开源，详情请参阅仓库根目录下的 LICENSE 文件（若已包含）或随意使用。

---
