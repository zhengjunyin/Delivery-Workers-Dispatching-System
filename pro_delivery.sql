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

 Date: 04/05/2026 02:53:22
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
INSERT INTO `activity` VALUES (2, 'Dispatcher Technical Operation Competency Activity', 'The dispatching system is our operational \"tool\". Proficient use of shortcut keys, quick information retrieval, and flexible application of monitoring tools can greatly improve work efficiency and accuracy.', 'http://127.0.0.1:9090/web/download/0bf4c1a6f9d84bb9afa4c23b70cc5909.png', '1-101', '<h1 style=\"text-align: start;\">Activity Content</h1><h2 style=\"text-align: start;\">Skill Module 1: Shortcut Key Speed Competition</h2><p>Participants compete in groups in a shortcut key blind operation contest. See who can complete the most dispatching instructions within 3 minutes. Awards include the Rookie Speed Award and Speed Master Award.</p><h2 style=\"text-align: start;\">Skill Module 2: Multi-Screen Coordination Practice</h2><p>Simulate real dispatching scenarios to master efficient multi-screen operation: viewing maps on the left screen, assigning orders on the right screen, and monitoring real-time messages on the middle screen.</p><h2 style=\"text-align: start;\">Skill Module 3: Data Retrieval Expert</h2><p>Practice quickly locating key data from massive orders and delivery staff information, and proficiently generate reports with one click.</p>', 1, '2026-01-01', '2027-12-01');
INSERT INTO `activity` VALUES (3, 'Activities on Dispatchers\' Communication and Coordination Competence', 'Dispatching is not only professional expertise, but also an art of communication. Delivering precise instructions, properly resolving customer complaints, and collaborating efficiently across departments are essential qualities for every dispatcher.', 'http://127.0.0.1:9090/web/download/0b399b4fd38644879f4000e809be6f37.png', '1-101', '<h1 style=\"text-align: start;\">Activity Content</h1><h3 style=\"text-align: start;\">Scenario 1: Emergency Order Communication Simulation</h3><p>Participants pair up to play the roles of dispatcher and delivery staff. They simulate the scenario of adding urgent orders during peak hours to practice delivering clear instructions and making quick confirmations.</p><h3 style=\"text-align: start;\">Scenario 2: Customer Complaint Handling Drill</h3><p>Faced with simulated customer complaints in an emotional state, dispatchers practice listening, empathy, emotional soothing and problem-solving communication skills, and receive on-site feedback and professional guidance.</p><h3 style=\"text-align: start;\">Scenario 3: Cross-Department Collaboration Roundtable</h3><p>Invite representatives from warehousing, customer service and technical departments. Participants simulate typical coordination scenarios such as inconsistent order information and system failures, so as to improve the ability of efficient communication and work closed-loop handling across departments.</p>', 1, '2025-12-01', '2026-12-01');
INSERT INTO `activity` VALUES (6, 'Activities on Dispatchers\' Cognitive and Decision-Making Competence', ' Dispatcher work demands fast and accurate decision-making. This challenge simulates real scheduling scenarios, refining dispatchers\' capabilities in rapid analysis, route optimization and priority judgment through fun competitions.', 'http://127.0.0.1:9090/web/download/93c230eb2cc14510b03fd00585c0bef6.png', '1-101', '<p style=\"text-align: start;\"><br></p><h2><strong>Event Content</strong></h2><h3><strong>Level 1: Map Quick Memorization Challenge</strong></h3><p>Memorize key nodes of the city map within the time limit, then answer questions involving the shortest routes, congested road sections and traffic restriction zones. This round assesses participants’ spatial memory and quick response ability.</p><h3><strong>Level 2: Multi-order Scheduling Simulation</strong></h3><p>The system randomly generates various orders, including urgent orders, bulky item orders and fresh food orders. Participants are required to complete reasonable order allocation within 5 minutes. The system will automatically score performance based on three criteria: minimum total travel distance, optimal timeliness and balanced workload.</p><h3><strong>Level 3: Emergency Incident Response</strong></h3><p>Simulate unexpected situations during delivery such as temporary traffic control, vehicle breakdown and customer address modification. Participants shall adjust the original scheduling plan in a timely manner, and work out alternative routes as well as standardized communication responses.</p>', 0, '2025-11-03', '2026-11-01');

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
INSERT INTO `article` VALUES (1, 'Basic Regulations for Delivery Personnel', '2025-11-01 17:33:53', 'http://127.0.0.1:9090/web/download/2376e38605254f37ae6ca94e4b2a6ce7.png', '<h2><strong>Article 1: Pre-Assignment Certification</strong></h2><p><span style=\"font-family: 宋体;\">All delivery personnel must complete real-name authentication before starting work. Orders may only be accepted after passing the review and receiving the ID badge and vehicle-mounted delivery equipment. Facial recognition verification must be completed upon the first daily login.</span></p><h2><strong>Article 2: Dress Code</strong></h2><p><span style=\"font-family: 宋体;\">During task execution, the uniform must be worn and kept clean and tidy. The ID badge shall be worn in the prescribed position. Informal attire such as slippers or vests is strictly prohibited during operations.</span></p><h2><strong>Article 3: Vehicle Safety</strong></h2><p><span style=\"font-family: 宋体;\">Delivery vehicles are a key focus of safety management. The use of modified vehicles or those with potential faults is strictly prohibited. Safety devices such as brakes and lights must be inspected at the prescribed frequency. Dangerous behaviors such as operating communication devices or smoking while driving are strictly prohibited.</span></p><h2><strong>Article 4: Cargo and Equipment Management</strong></h2><p><span style=\"font-family: 宋体;\">Cargo packaging must be kept intact and clean. Fresh and food-related goods must be transported using specialized temperature control equipment. Placing personal items in the cargo storage area is strictly prohibited. Vehicle-mounted equipment must undergo cleaning treatment upon completion of delivery tasks.</span></p><h2><strong>Article 5: Traffic Safety</strong></h2><p><span style=\"font-family: 宋体;\">Traffic regulations must be observed throughout the journey. Running red lights, driving against traffic, and speeding are strictly prohibited. In residential areas and narrow road sections, speed must be reduced, attention paid to pedestrian safety, and unnecessary honking avoided.</span></p><h2><strong>Article 6: Cargo Protection</strong></h2><p><span style=\"font-family: 宋体;\">Delivery equipment and customer cargo must be handled with care. Loading and unloading shall be conducted properly, with goods handled gently. Damaged cargo must be reported immediately and compensation made according to regulations. Unauthorized opening, inspection, or exchange of customer cargo is strictly prohibited.</span></p><h2><strong>Article 7: Route Execution</strong></h2><p><span style=\"font-family: 宋体;\">Tasks shall be executed according to the system-planned route. Unauthorized deviation from the route or alteration of the delivery sequence is not permitted. Special circumstances must be reported to and approved by the dispatch center. Arrival at pickup points and delivery destinations must be completed within the prescribed timeframe.</span></p><h2><strong>Article 8: Handover Standards</strong></h2><p><span style=\"font-family: 宋体;\">When handing over to customers, the ID badge must be presented proactively, and standardized service language shall be used. Orders requiring customer signature must complete the signature process on-site. When a customer cannot be reached in time, the matter shall be handled according to established procedures.</span></p><h2><strong>Article 9: Prohibited Conduct</strong></h2><p><span style=\"font-family: 宋体;\">Accepting orders outside the platform without authorization is prohibited. Soliciting extra fees from customers is not permitted. Unauthorized posting of advertisements or conducting other commercial promotion activities in delivery areas or on vehicles is not allowed.</span></p>', '');
INSERT INTO `article` VALUES (2, 'Delivery Rider Work Regulations', '2025-11-01 17:33:58', 'http://127.0.0.1:9090/web/download/7461c8a354dc4542bb308747ab82d488.png', '<p style=\"text-align: start;\"><br></p><h2><strong>Chapter 1: Pre-Assignment Standards</strong></h2><p><span style=\"font-family: 宋体;\">Article 1: Qualification Requirements</span></p><p><span style=\"font-family: 宋体;\">- Hold valid identification, health certificate, and the prescribed freight driving license.</span></p><p><span style=\"font-family: 宋体;\">- Pass the platform\'s safety training and assessment.</span></p><p><span style=\"font-family: 宋体;\">- Have no criminal record and no major traffic violation record.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 2: Equipment Preparation</span></p><p><span style=\"font-family: 宋体;\">- Pre-departure Inspection: Truck condition (brakes, lights, tires), energy supply equipment, cargo securing devices, seals, and locks.</span></p><p><span style=\"font-family: 宋体;\">- Essential Items: Communication device and charger, cold-weather clothing, emergency medical kit, basic repair tools, backup route map.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 3: System Operations</span></p><p><span style=\"font-family: 宋体;\">- Log in to the delivery app to sign in and confirm the planned route before departure.</span></p><p><span style=\"font-family: 宋体;\">- Keep the positioning function enabled throughout transport to ensure real-time location accuracy.</span></p><p><span style=\"font-family: 宋体;\">- Update the electronic waybill status promptly when crossing borders.</span></p><h2><strong>Chapter 2: Delivery Operations</strong></h2><p><span style=\"font-family: 宋体;\">Article 4: Loading Process</span></p><p><span style=\"font-family: 宋体;\">- Arrive at the loading point within the prescribed time, and verify the piece count, product name, and destination against the documents.</span></p><p><span style=\"font-family: 宋体;\">- Inspect the external condition and securing of the cargo; immediately take photos and confirm on-site if any damage is found.</span></p><p><span style=\"font-family: 宋体;\">- Complete the sealing or locking of the vehicle after supervising the loading, then scan documents for confirmation.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 5: During Transport</span></p><p><span style=\"font-family: 宋体;\">- Strictly follow the planned route; report any necessary deviations.</span></p><p><span style=\"font-family: 宋体;\">- Check the cargo securing status and seal integrity at the prescribed frequency.</span></p><p><span style=\"font-family: 宋体;\">- Review order status updates at set times daily; report delays within a reasonable advance period.</span></p><p><span style=\"font-family: 宋体;\">- Stop for rest according to the prescribed duration; fatigued driving is strictly prohibited.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 6: Delivery and Handover</span></p><p><span style=\"font-family: 宋体;\">- Contact the consignee within a reasonable time before arrival to confirm the exact unloading location.</span></p><p><span style=\"font-family: 宋体;\">- Verify the consignee\'s identity and check the seal integrity together on-site.</span></p><p><span style=\"font-family: 宋体;\">- Guide the consignee in checking the cargo, and complete the in-app signature or electronic signature for confirmation.</span></p><p><span style=\"font-family: 宋体;\">- Follow the dispatch center\'s instructions if the consignee refuses delivery or cannot be contacted.</span></p><h2><strong>Chapter 3: Service Standards</strong></h2><p><span style=\"font-family: 宋体;\">Article 7: Appearance and Grooming</span></p><p><span style=\"font-family: 宋体;\">- Wear a clean and tidy uniform; wear the ID badge in the prescribed position.</span></p><p><span style=\"font-family: 宋体;\">- Maintain basic personal hygiene, and remain polite and courteous.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 8: Communication Standards</span></p><p><span style=\"font-family: 宋体;\">- Proactively greet using the local common language, stating your affiliated platform and order number.</span></p><p><span style=\"font-family: 宋体;\">- Remain calm when faced with complaints, avoid arguments, and report immediately to the dispatch center.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 9: Handling of Special Situations</span></p><p><span style=\"font-family: 宋体;\">- Address Change: Immediately contact the dispatch center and follow new instructions.</span></p><p><span style=\"font-family: 宋体;\">- Severe Weather or Road Closure: Prioritize personal and cargo safety; report the delay reason promptly.</span></p><p><span style=\"font-family: 宋体;\">- Vehicle Breakdown: Activate hazard lights, place a warning marker at the prescribed distance, contact rescue services, and report to the platform.</span></p><h2><strong>Chapter 4: Safety Discipline</strong></h2><p><span style=\"font-family: 宋体;\">Article 10: Traffic Safety</span></p><p><span style=\"font-family: 宋体;\">- Strictly comply with road speed limits; do not exceed the prescribed speed.</span></p><p><span style=\"font-family: 宋体;\">- Fasten the seat belt at all times; handheld operation of communication devices while driving is prohibited.</span></p><p><span style=\"font-family: 宋体;\">- Significantly reduce speed during severe weather or hazardous road conditions, and stop and wait if necessary.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 11: Cargo Safety</span></p><p><span style=\"font-family: 宋体;\">- Park overnight only in supervised parking areas.</span></p><p><span style=\"font-family: 宋体;\">- Lock doors and windows and confirm seals are intact when leaving the vehicle.</span></p><p><span style=\"font-family: 宋体;\">- Immediately alert the local police and report to the platform if suspicious circumstances are detected.</span></p><p><span style=\"font-family: 宋体;\"> </span></p><p><span style=\"font-family: 宋体;\">Article 12: Health and Safety</span></p><p><span style=\"font-family: 宋体;\">- Comply with the prescribed maximum daily driving hours; after continuous driving for the stated limit, rest for the stipulated duration.</span></p><p><span style=\"font-family: 宋体;\">- Take seasonal protective measures; keep the corresponding supplies in the vehicle.</span></p><p><span style=\"font-family: 宋体;\">- Immediately cease driving if feeling unwell, seek medical attention nearby, and report.</span></p><h2><strong>Chapter 5: Supplementary Provisions</strong></h2><p><span style=\"font-family: 宋体;\">Article 13 This code takes effect on the date of issuance. All long-haul delivery personnel must strictly comply.</span></p><p><span style=\"font-family: 宋体;\">Article 14 Violations of this code shall be handled in accordance with the relevant reward and punishment regulations.</span></p><p><span style=\"font-family: 宋体;\">Article 15 The right to interpret this code rests with the Dispatch Center.</span></p><p><br></p>', '');
INSERT INTO `article` VALUES (3, 'Dispatcher Work Code', '2025-11-01 17:34:02', 'http://127.0.0.1:9090/web/download/f7d8aae7bc3a4084bfd8047687598aa5.png', '<h2><strong>I. Basic Requirements</strong></h2><p style=\"text-align: left;\">1. Arrive at work on time and check equipment in advance. </p><p style=\"text-align: left;\">2. Keep formal attire neat and wear employee ID badge. </p><p style=\"text-align: left;\">3. Maintain a tidy and orderly workbench. </p><p style=\"text-align: left;\">4. Strictly refrain from disclosing the privacy of customers and delivery riders.</p><h2><strong>II. Scheduling Rules </strong></h2><p style=\"text-align: left;\">1. Urgent orders: Assign within 1 minute, arrange the fastest delivery rider. </p><p style=\"text-align: left;\">2. Large goods orders: Assign within 2 minutes, arrange riders with physical strength and cargo vehicles. </p><p style=\"text-align: left;\">3. Fresh food orders: Assign within 1.5 minutes, arrange riders equipped with thermal insulation boxes. </p><p style=\"text-align: left;\">4. Regular orders: Assign within 3 minutes, ensure balanced order volume for all riders. </p><p style=\"text-align: left;\">5. Reserved orders: Confirm 1 hour in advance, arrange the most reliable riders. </p><h2><strong>III. Exception Handling</strong></h2><p style=\"text-align: left;\">1. Major issues (accidents, serious complaints): Report to the supervisor immediately. </p><p style=\"text-align: left;\">2. Medium issues (2-hour overtime delivery, goods damage): Complete handling within 30 minutes. </p><p style=\"text-align: left;\">3. Minor issues (failed contact, unreasonable route deviation): Resolve within 1 hour. </p><p style=\"text-align: left;\">4. All exceptions must be recorded properly.</p><h2><strong>IV. Communication Norms</strong></h2><p style=\"text-align: left;\">1. With delivery riders: Give clear instructions and maintain a respectful tone. </p><p style=\"text-align: left;\">2. With customers: Take initiative to inform and explain with patience. </p><p style=\"text-align: left;\">3. With colleagues: Complete handover timely and help each other. </p><p style=\"text-align: left;\">4. In emergency situations: Ensure safety first, then handle order matters.</p><h2><strong> V. Data Security</strong></h2><p style=\"text-align: left;\">1. Do not disclose any private and confidential information. </p><p style=\"text-align: left;\">2. Change passwords every month and lock the screen when leaving the seat. </p><p style=\"text-align: left;\">3. Do not alter internal data or install irrelevant unofficial software. </p><p style=\"text-align: left;\">4. Report any hidden risks and problems immediately once found<span style=\"font-family: 宋体;\">.</span></p><p> </p>', '');

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
INSERT INTO `banner` VALUES (1, 'Seasoned Expert', 'http://127.0.0.1:9090/web/download/aa77519f6d124c26b8362cce0847b9b3.png', 9);
INSERT INTO `banner` VALUES (2, 'Precision On-Time Delivery', 'http://127.0.0.1:9090/web/download/0bf3d8ac174c431fbe558473739be6aa.png', 2);
INSERT INTO `banner` VALUES (3, 'Delivery Range: 10 Global Loops', 'http://127.0.0.1:9090/web/download/12ad6898c7e94656a122fabf2baec1a7.png', 7);
INSERT INTO `banner` VALUES (4, 'Customer Satisfaction: 4.8 Stars', 'http://127.0.0.1:9090/web/download/946ac189f0cb4ca1ad813821511da1ee.png', 4);

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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '评论管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (8, '1', 1, '2025-07-17 19:24:04', NULL, NULL, 5);
INSERT INTO `comment` VALUES (15, '2', 1, '2025-07-21 17:11:50', NULL, 14, 2);
INSERT INTO `comment` VALUES (16, '2', 1, '2025-07-21 17:12:01', 15, 14, 2);
INSERT INTO `comment` VALUES (19, '3', 1, '2025-07-21 17:24:04', NULL, 17, 2);
INSERT INTO `comment` VALUES (20, '8', 1, '2025-07-21 17:24:12', 19, 17, 2);
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
INSERT INTO `delivery` VALUES (2, 'Lily', '', '', '+375297654321', 1, 'http://127.0.0.1:9090/web/download/fc997e9bcc8847c09ac0179e19036a2e.png', '4.7', '2020-09-18', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (3, 'Jack', '', '', '+375331122334', 2, 'http://127.0.0.1:9090/web/download/767d97c4532b41698c3822a84ac19e50.png', '4.9', '2024-06-06', 1, 0, '<p><br></p>');
INSERT INTO `delivery` VALUES (4, 'Amy', '', '', '+375334455667', 3, 'http://127.0.0.1:9090/web/download/3582f07ddf7c4cd49d25f13aa6676841.png', '4.9', '2024-04-19', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (5, 'Max', '', '', '+375447788990', 3, 'http://127.0.0.1:9090/web/download/ff9d5efbba8e4c3fae959555e939586f.png', '4.9', '2023-12-22', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (6, 'Mia', '', '', '+375440011223', 4, 'http://127.0.0.1:9090/web/download/c7ed93ee2bfe4933b211cab811f94e2d.png', '4.6', '2023-07-01', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (7, 'Leo', '', '', '+375293344556', 5, 'http://127.0.0.1:9090/web/download/606b2141caae45b0bf232d61f2a1669c.png', '4.5', '2025-03-14', 1, 2, '<p><br></p>');
INSERT INTO `delivery` VALUES (9, 'Tyler', NULL, NULL, '+37529124567', 1, 'http://127.0.0.1:9090/web/download/53cbe01c4b4f4b80a5f4339f2d269f27.png', '4.8', '2024-05-17', 1, 1, '<p><br></p>');
INSERT INTO `delivery` VALUES (10, 'text', NULL, NULL, '+375111111112', 2, 'http://127.0.0.1:9090/web/download/bfa8ebd4e9954d6e9e7bf37f6ccd0ae2.png', '5', '2026-01-30', 0, 1, '');

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
INSERT INTO `sys_admin` VALUES (1, 'admin', 'admin', 'admin', 'http://127.0.0.1:9090/web/download/6cd4ca56469d4ee9b9d9898d11d3b9fc.png', 'admin@email.com', '+375111111111');

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
INSERT INTO `sys_user` VALUES (1, '111', '111', 'user1', 'http://127.0.0.1:9090/web/download/2066d2ca545c410f91d0f81a22da45d3.png', '895666596@gmail.com', '+375222222222');

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '工作记录' ROW_FORMAT = Dynamic;

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
INSERT INTO `workrecord` VALUES (16, 2, 1, '2026-01-30', '2026-02-01', '2026-05-04 02:43:14', 'Finished');
INSERT INTO `workrecord` VALUES (17, 3, 1, '2026-05-04', '2026-05-05', NULL, 'At work');

SET FOREIGN_KEY_CHECKS = 1;
