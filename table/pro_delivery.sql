/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80040
 Source Host           : localhost:3306
 Source Schema         : pro_delivery

 Target Server Type    : MySQL
 Target Server Version : 80040
 File Encoding         : 65001

 Date: 30/01/2026 23:19:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '简介',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '活动封面',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '活动地点',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '活动详情',
  `status` tinyint NULL DEFAULT NULL COMMENT '状态',
  `start_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开始时间',
  `end_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '活动管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES (2, '调度员技术操作能力活动：系统高手进阶营', '调度系统是我们作战的“武器”，熟练使用快捷键、快速检索信息、灵活运用监控工具，能极大提升工作效率与准确性。本次活动以“练代学”为宗旨，不设门槛、不计考核，旨在帮助大家挖掘系统隐藏功能、交流操作技巧、共同提升操作流畅度。无论你是新手还是老手，都欢迎来交流你的独家秘籍！所有希望提升系统操作效率的调度员（自由参与，不限层级）', 'http://127.0.0.1:9090/web/download/0bf4c1a6f9d84bb9afa4c23b70cc5909.png', '1-101', '<p><br></p><h3 style=\"text-align: start;\"><strong>活动内容：</strong></h3><h4 style=\"text-align: start;\"><strong>技能模块一：快捷键极速比拼</strong></h4><p style=\"text-align: start;\">分组进行快捷键盲打比赛，比拼谁在3分钟内完成最多调度指令。设有“极速新人奖”与“快手之王奖”。</p><h4 style=\"text-align: start;\"><strong>技能模块二：多屏协同实战</strong></h4><p style=\"text-align: start;\">模拟真实调度场景，练习左屏看地图、右屏派订单、中间屏盯消息的高效协同操作。</p><h4 style=\"text-align: start;\"><strong>技能模块三：数据检索达人</strong></h4><p style=\"text-align: start;\">训练在海量订单与配送员信息中快速定位目标数据，并完成报表一键生成。</p>', 1, '2026-01-01', '2027-12-01');
INSERT INTO `activity` VALUES (3, '调度员沟通协调能力活动：情景对话工作坊', '调度不仅是技术活，更是沟通艺术。如何一句话让配送员听懂指令？如何在客户投诉时稳住局面？如何与跨部门同事高效协作？本次活动通过真实情景还原、角色扮演与专业教练指导，打造一个安全、开放的表达与倾听场域。不评分、不录像，只为共同成长。全体调度员与部分自愿参与的配送员代表（自愿组合，自由报名）', 'http://127.0.0.1:9090/web/download/0b399b4fd38644879f4000e809be6f37.png', '1-101', '<p><br></p><h3 style=\"text-align: start;\"><strong>活动内容：</strong></h3><h4 style=\"text-align: start;\"><strong>情景一：紧急订单沟通模拟</strong></h4><p style=\"text-align: start;\">参与者两两一组，分别扮演调度员与配送员，处理高峰期紧急加单场景，练习清晰指令与快速确认。</p><h4 style=\"text-align: start;\"><strong>情景二：客户投诉应对演练</strong></h4><p style=\"text-align: start;\">面对模拟客户的愤怒投诉，调度员需练习倾听、共情、安抚与解决话术，现场接受反馈与指导。</p><h4 style=\"text-align: start;\"><strong>情景三：跨部门协作圆桌</strong></h4><p style=\"text-align: start;\">邀请仓储、客服、技术部门代表，共同模拟订单信息不一致、系统故障等协同场景，练习高效闭环沟通。</p>', 1, '2025-12-01', '2026-12-01');
INSERT INTO `activity` VALUES (6, '调度员的认知与决策能力活动：路径规划挑战赛', '在日常调度工作中，我们常常需要在极短时间内做出最优决策。本次挑战赛旨在模拟真实调度场景，通过游戏化方式锻炼调度员的快速分析、路径优化和优先级判断能力。我们相信，在轻松有趣的氛围中锻炼技能，能让调度员在面对实际订单压力时更加从容自信。活动完全自愿，期待大家在挑战中发现自己的潜力。', 'http://127.0.0.1:9090/web/download/93c230eb2cc14510b03fd00585c0bef6.png', '1-101', '<h3 style=\"text-align: start;\"><strong>活动内容：</strong></h3><h4 style=\"text-align: start;\"><strong>第一关：地图速记挑战</strong></h4><p style=\"text-align: start;\">在限定时间内记忆城市地图的关键节点，随后回答关于最短路径、拥堵路段、限行区域等问题。考验空间记忆与快速反应能力。</p><h4 style=\"text-align: start;\"><strong>第二关：多订单调度模拟</strong></h4><p style=\"text-align: start;\">系统随机生成一批订单（含急单、大件单、生鲜单等），参与者需在5分钟内完成所有订单的合理分配，系统根据“总路程最短、时效最优、负载均衡”三大维度自动评分。</p><h4 style=\"text-align: start;\"><strong>第三关：突发干扰应对</strong></h4><p style=\"text-align: start;\">模拟配送途中突发交通管制、车辆故障、客户改地址等情景，参与者需即时调整原有方案，并给出备用路线与沟通话术。</p>', 0, '2025-11-03', '2025-11-07');

-- ----------------------------
-- Table structure for activityrecord
-- ----------------------------
DROP TABLE IF EXISTS `activityrecord`;
CREATE TABLE `activityrecord`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `item_id` int NULL DEFAULT NULL COMMENT '活动id',
  `user_id` int NULL DEFAULT NULL COMMENT '用户id',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '参与打卡时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '报名人姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '报名人联系电话',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '活动参与管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activityrecord
-- ----------------------------
INSERT INTO `activityrecord` VALUES (6, 3, 1, NULL, '', 'Tom', '+375291234567');
INSERT INTO `activityrecord` VALUES (7, 3, 3, NULL, '', '222', '222');
INSERT INTO `activityrecord` VALUES (8, 3, 1, NULL, '', 'jeff', '1');

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '简述说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, '配送员基本规定', '2025-11-01 17:33:53', 'http://127.0.0.1:9090/web/download/0652b5756b4248c1bb25f758881184d2.webp', '<p style=\"text-align: start;\"><strong>第一条</strong> 所有配送员上岗前必须完成实名认证，通过系统审核并领取工牌、配送装备后方可接单。每日首次登录需完成人脸识别验证。</p><p style=\"text-align: start;\"><strong>第二条</strong> 配送员执行任务期间必须穿着统一工服，保持服装整洁，佩戴工牌。严禁穿着拖鞋、背心等不正式服装进行配送服务。</p><p style=\"text-align: start;\"><strong>第三条</strong> 配送车辆为工作安全重点管理对象，严禁使用改装、故障车辆；必须定期检查刹车、灯光等安全装置；严禁在配送途中吸烟、接打电话等危险行为。</p><p style=\"text-align: start;\"><strong>第四条</strong> 保持货物包装完整清洁，生鲜、食品类货物必须使用专用保温箱；严禁在配送箱内放置个人物品；每日配送结束后需清洁消毒配送装备。</p><p style=\"text-align: start;\"><strong>第五条</strong> 配送过程中遵守交通规则，禁止闯红灯、逆行、超速行驶；小区内配送需减速慢行，注意行人安全；不得鸣笛扰民。</p><p style=\"text-align: start;\"><strong>第六条</strong> 爱护配送设备及客户货物，轻拿轻放，规范装卸；货物损坏需立即上报并按价赔偿；严禁私自拆看、调换客户货物。</p><p style=\"text-align: start;\"><strong>第七条</strong> 按系统规划路线执行配送任务，不得无故偏离路线或擅自更改配送顺序；特殊情况需报备调度中心批准；准时到达取货点和配送点。</p><p style=\"text-align: start;\"><strong>第八条</strong> 与客户交接时主动出示工牌，使用规范服务用语；需客户签收的订单必须现场完成签收流程；客户不在时按规范流程处理。</p><p style=\"text-align: start;\"><strong>第九条</strong> 禁止私自承接平台外订单，不得向客户索取额外费用；不得在配送区域内张贴广告或进行其他商业推广活动。</p><p style=\"text-align: start;\"><strong>第十条</strong> 为保障配送服务质量，提升客户满意度，请所有配送员严格遵守以上规定；欢迎对配送流程提出改进建议，违规行为将按《配送员奖惩办法》处理。</p>', '');
INSERT INTO `article` VALUES (2, '配送员工作守则', '2025-11-01 17:33:58', 'http://127.0.0.1:9090/web/download/e24989f60d344f99adf62d22e060df1a.png', '<p><br></p><p><br></p><h2 style=\"text-align: start;\"><strong>第一章 上岗规范</strong></h2><p style=\"text-align: start;\"><strong>第一条 资质要求</strong></p><ul><li style=\"text-align: start;\">持有有效身份证、健康证、驾驶证（如需）</li><li style=\"text-align: start;\">通过平台安全培训及考核</li><li style=\"text-align: start;\">无犯罪记录及重大交通违章记录</li></ul><p style=\"text-align: start;\"><strong>第二条 装备准备</strong></p><ul><li style=\"text-align: start;\">每日检查：配送车辆、充电设备、保温箱、工服工牌</li><li style=\"text-align: start;\">必备物品：手机、充电宝、雨具、零钱袋</li><li style=\"text-align: start;\">防疫要求：口罩、消毒液、手套（按需）</li></ul><p style=\"text-align: start;\"><strong>第三条 系统操作</strong></p><ul><li style=\"text-align: start;\">准时登录配送APP完成签到</li><li style=\"text-align: start;\">及时更新在线/忙碌/休息状态</li><li style=\"text-align: start;\">保持定位功能开启，确保位置准确</li></ul><h2 style=\"text-align: start;\"><strong>第二章 配送操作</strong></h2><p style=\"text-align: start;\"><strong>第四条 取货流程</strong></p><ul><li style=\"text-align: start;\">准时到达取货点，超时10分钟需报备</li><li style=\"text-align: start;\">核对订单信息：收货人、地址、货物数量</li><li style=\"text-align: start;\">检查货物包装，发现问题当场确认</li><li style=\"text-align: start;\">扫描货物条码完成取货确认</li></ul><p style=\"text-align: start;\"><strong>第五条 配送途中</strong></p><ul><li style=\"text-align: start;\">遵循导航路线，特殊情况需报备改道</li><li style=\"text-align: start;\">保持货物平稳，特殊货物（易碎、液体）单独放置</li><li style=\"text-align: start;\">每30分钟查看一次订单状态更新</li><li style=\"text-align: start;\">预估无法准时送达需提前15分钟报备</li></ul><p style=\"text-align: start;\"><strong>第六条 送达交接</strong></p><ul><li style=\"text-align: start;\">提前5分钟联系客户确认送达</li><li style=\"text-align: start;\">送货上门需敲门/按铃三声等待</li><li style=\"text-align: start;\">当面核对货物，指导客户验货</li><li style=\"text-align: start;\">使用APP完成签收拍照或电子签字</li></ul><h2 style=\"text-align: start;\"><strong>第三章 服务标准</strong></h2><p style=\"text-align: start;\"><strong>第七条 仪容仪表</strong></p><ul><li style=\"text-align: start;\">工服整洁无污损，工牌佩戴在左胸</li><li style=\"text-align: start;\">保持个人卫生，无异味</li><li style=\"text-align: start;\">微笑服务，目光交流，态度亲切</li></ul><p style=\"text-align: start;\"><strong>第八条 沟通规范</strong></p><ul><li style=\"text-align: start;\">使用标准服务用语：“您好，XX配送”“请签收”“谢谢”</li><li style=\"text-align: start;\">电话沟通先自报身份，语言简洁清晰</li><li style=\"text-align: start;\">处理投诉保持冷静，不争辩，立即上报</li></ul><p style=\"text-align: start;\"><strong>第九条 特殊情况处理</strong></p><ul><li style=\"text-align: start;\">客户修改地址：联系调度中心重新计费</li><li style=\"text-align: start;\">客户拒收：了解原因，货物带回指定仓库</li><li style=\"text-align: start;\">联系不上客户：等待10分钟，按流程操作</li></ul><h2 style=\"text-align: start;\"><strong>第四章 安全纪律</strong></h2><p style=\"text-align: start;\"><strong>第十条 交通安全</strong></p><ul><li style=\"text-align: start;\">电动车时速不超过25公里/小时</li><li style=\"text-align: start;\">骑行佩戴头盔，不接打电话</li><li style=\"text-align: start;\">恶劣天气需减速50%行驶</li></ul><p style=\"text-align: start;\"><strong>第十一条 货物安全</strong></p><ul><li style=\"text-align: start;\">人不离车，车不离货（短暂离开需锁车）</li><li style=\"text-align: start;\">高档货物配送需全程关注</li><li style=\"text-align: start;\">遇可疑情况立即报警并上报</li></ul><p style=\"text-align: start;\"><strong>第十二条 健康安全</strong></p><ul><li style=\"text-align: start;\">连续工作4小时需休息20分钟</li><li style=\"text-align: start;\">身体不适立即停止工作就医</li><li style=\"text-align: start;\">高温/严寒天气做好防护措施</li></ul><h2 style=\"text-align: start;\"><strong>第五章 附则</strong></h2><p style=\"text-align: start;\"><strong>第十三条</strong> 本守则自发布之日起执行，所有配送员必须严格遵守。</p><p style=\"text-align: start;\"><strong>第十四条</strong> 违反守则将依据《配送员奖惩办法》进行处理。</p><p style=\"text-align: start;\"><strong>第十五条</strong> 本守则解释权归智能配送调度中心所有。</p><p><br></p>', '');
INSERT INTO `article` VALUES (3, '调度员工作守则', '2025-11-01 17:34:02', 'http://127.0.0.1:9090/web/download/b6323797fe6f4a38baa503e2b8c53369.jpeg', '<h2><strong>一、基本要求</strong></h2><ol><li>按时到岗，提前检查设备</li><li>着装整洁，佩戴工牌</li><li>保持工作台面有序</li><li>严禁泄露客户与配送员隐私</li></ol><h2><strong>二、调度准则</strong></h2><ol><li>急单：1分钟内分配，找最快配送员</li><li>大件：2分钟内分配，找有力气有货车的</li><li>生鲜：1.5分钟内分配，找有保温箱的</li><li>普通单：3分钟内分配，保持大家活均衡</li><li>预约单：提前1小时确认，找最靠谱的</li></ol><h2><strong>三、异常处理</strong></h2><ol><li>大事（事故、严重投诉）：立即报主管</li><li>中事（超时2小时、货损）：30分钟内处理</li><li>小事（联系不上、路线偏）：1小时内解决</li><li>所有异常都要记录</li></ol><h2><strong>四、沟通规矩</strong></h2><ol><li>对配送员：指令清晰，语气尊重</li><li>对客户：主动告知，耐心解释</li><li>对同事：及时交接，互相帮忙</li><li>紧急情况：先保安全，再管订单</li></ol><h2><strong>五、数据安全</strong></h2><ol><li>不泄露任何隐私信息</li><li>密码每月换，离开就锁屏</li><li>不改数据，不装杂软件</li><li>发现问题马上报告</li></ol>', '');

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '说明',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `delivery_id` int NULL DEFAULT NULL COMMENT '关联配送员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, '经验最老，哪里都熟', 'http://127.0.0.1:9090/web/download/aa77519f6d124c26b8362cce0847b9b3.png', 9);
INSERT INTO `banner` VALUES (2, '精准送达', 'http://127.0.0.1:9090/web/download/0bf3d8ac174c431fbe558473739be6aa.png', 2);
INSERT INTO `banner` VALUES (3, '配送里程可绕地球50圈', 'http://127.0.0.1:9090/web/download/12ad6898c7e94656a122fabf2baec1a7.png', 7);
INSERT INTO `banner` VALUES (4, '客户满意度4.8星', 'http://127.0.0.1:9090/web/download/946ac189f0cb4ca1ad813821511da1ee.png', 4);

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
  `user_id` int NULL DEFAULT NULL COMMENT '评论人id',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评论时间',
  `pid` int NULL DEFAULT NULL COMMENT '父id',
  `origin_id` int NULL DEFAULT NULL COMMENT '最上级评论id',
  `item_id` int NULL DEFAULT NULL COMMENT '关联id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '评论管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (8, '1', 1, '2025-07-17 19:24:04', NULL, NULL, 5);
INSERT INTO `comment` VALUES (15, '如果你有想法，可以找我呢', 1, '2025-07-21 17:11:50', NULL, 14, 2);
INSERT INTO `comment` VALUES (16, '我的微信号是xxx', 1, '2025-07-21 17:12:01', 15, 14, 2);
INSERT INTO `comment` VALUES (19, '真的超级推荐', 1, '2025-07-21 17:24:04', NULL, 17, 2);
INSERT INTO `comment` VALUES (20, '真的超级无敌推荐', 1, '2025-07-21 17:24:12', 19, 17, 2);
INSERT INTO `comment` VALUES (22, '789', 1, '2025-07-21 19:19:29', NULL, 21, 2);
INSERT INTO `comment` VALUES (23, '123', 1, '2025-07-21 19:19:32', 22, 21, 2);
INSERT INTO `comment` VALUES (24, 'nice', 1, '2026-01-17 21:41:53', NULL, NULL, 4);
INSERT INTO `comment` VALUES (25, 'best', 1, '2026-01-29 18:12:10', NULL, NULL, 3);
INSERT INTO `comment` VALUES (26, 'test', 1, '2026-01-29 18:13:55', NULL, NULL, 9);

-- ----------------------------
-- Table structure for delivery
-- ----------------------------
DROP TABLE IF EXISTS `delivery`;
CREATE TABLE `delivery`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作者',
  `press` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出版社',
  `isbn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国际标准书号',
  `type_id` int NULL DEFAULT NULL COMMENT '所属分类',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '简介',
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出版日期',
  `status` tinyint NULL DEFAULT NULL COMMENT '图书状态',
  `num` int NULL DEFAULT NULL COMMENT '库存',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '详情描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '配送员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of delivery
-- ----------------------------
INSERT INTO `delivery` VALUES (2, 'Lily', '', '', '+375297654321', 1, 'http://127.0.0.1:9090/web/download/fc997e9bcc8847c09ac0179e19036a2e.png', '4.7', '2020-09-18', 1, 0, '<p><br></p>');
INSERT INTO `delivery` VALUES (3, 'Jack', '', '', '+375331122334', 2, 'http://127.0.0.1:9090/web/download/767d97c4532b41698c3822a84ac19e50.png', '4.9', '2024-06-06', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (4, 'Amy', '', '', '+375334455667', 3, 'http://127.0.0.1:9090/web/download/3582f07ddf7c4cd49d25f13aa6676841.png', '4.9', '2024-04-19', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (5, 'Max', '', '', '+375447788990', 3, 'http://127.0.0.1:9090/web/download/ff9d5efbba8e4c3fae959555e939586f.png', '4.9', '2023-12-22', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (6, 'Mia', '', '', '+375440011223', 4, 'http://127.0.0.1:9090/web/download/c7ed93ee2bfe4933b211cab811f94e2d.png', '4.6', '2023-07-01', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (7, 'Leo', '', '', '+375293344556', 5, 'http://127.0.0.1:9090/web/download/606b2141caae45b0bf232d61f2a1669c.png', '4.5', '2025-03-14', 1, 2, '<p><br></p>');
INSERT INTO `delivery` VALUES (9, 'Tyler', NULL, NULL, '+37529124567', 1, 'http://127.0.0.1:9090/web/download/53cbe01c4b4f4b80a5f4339f2d269f27.png', '4.8', '2024-05-17', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (10, '1', NULL, NULL, '1', 2, 'http://127.0.0.1:9090/web/download/bfa8ebd4e9954d6e9e7bf37f6ccd0ae2.png', '1', '2026-01-30', 0, 1, '');

-- ----------------------------
-- Table structure for sys_admin
-- ----------------------------
DROP TABLE IF EXISTS `sys_admin`;
CREATE TABLE `sys_admin`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_admin
-- ----------------------------
INSERT INTO `sys_admin` VALUES (1, 'admin', 'admin', 'admin', 'http://127.0.0.1:9090/web/download/6cd4ca56469d4ee9b9d9898d11d3b9fc.png', 'admin@email.com', '18888888888');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, '111', '111', 'user1', 'http://127.0.0.1:9090/web/download/2066d2ca545c410f91d0f81a22da45d3.png', '895666596@gmail.com', '18888888888');

-- ----------------------------
-- Table structure for type
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '区域管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type
-- ----------------------------
INSERT INTO `type` VALUES (1, 'Area A');
INSERT INTO `type` VALUES (2, 'Area B');
INSERT INTO `type` VALUES (3, 'Area C');
INSERT INTO `type` VALUES (4, 'Area D');
INSERT INTO `type` VALUES (5, 'Area E');

-- ----------------------------
-- Table structure for workrecord
-- ----------------------------
DROP TABLE IF EXISTS `workrecord`;
CREATE TABLE `workrecord`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `delivery_id` int NULL DEFAULT NULL COMMENT '配送员id',
  `user_id` int NULL DEFAULT NULL COMMENT '调度员id',
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外出日期',
  `end_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预计完成时间',
  `back_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '实际完成时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '工作记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workrecord
-- ----------------------------
INSERT INTO `workrecord` VALUES (1, 7, 1, '2025-07-17', '2025-07-26', '2026-01-17 23:44:59', 'Finished');
INSERT INTO `workrecord` VALUES (2, 2, 1, '2025-07-18', '2025-07-19', '2025-07-18 14:10:46', 'Finished');
INSERT INTO `workrecord` VALUES (3, 2, 1, '2025-07-21', '2025-07-21', '2025-07-21 17:16:14', 'Finished');
INSERT INTO `workrecord` VALUES (4, 2, 1, '2025-07-21', '2025-07-22', '2025-07-21 17:16:20', 'Finished');
INSERT INTO `workrecord` VALUES (5, 2, 1, '2025-07-21', '2025-07-21', '2025-07-21 19:23:58', 'Finished');
INSERT INTO `workrecord` VALUES (6, 2, 1, '2025-07-21', '2025-07-22', '2025-07-21 19:23:58', 'Finished');
INSERT INTO `workrecord` VALUES (7, 1, 1, '2026-01-17', '2026-01-17', '2026-01-17 20:11:26', 'Finished');
INSERT INTO `workrecord` VALUES (8, 2, 1, '2026-01-17', '2026-01-31', '2026-01-17 21:24:33', 'Finished');
INSERT INTO `workrecord` VALUES (10, 3, 1, '2026-01-17', '2026-01-28', '2026-01-17 23:53:12', 'Finished');
INSERT INTO `workrecord` VALUES (11, 5, 1, '2026-01-17', '2026-01-19', '2026-01-18 18:00:49', 'Finished');
INSERT INTO `workrecord` VALUES (14, 6, 1, '2026-01-29', '2026-01-31', '2026-01-30 18:08:03', 'Finished');
INSERT INTO `workrecord` VALUES (15, 10, 1, '2026-01-29', '2026-01-31', '2026-01-29 18:29:57', 'Finished');
INSERT INTO `workrecord` VALUES (16, 2, 1, '2026-01-30', '2026-02-01', NULL, 'At work');

SET FOREIGN_KEY_CHECKS = 1;
