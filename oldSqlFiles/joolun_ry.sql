/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : joolun_ry

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 14/04/2026 11:02:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for door_lock
-- ----------------------------
DROP TABLE IF EXISTS `door_lock`;
CREATE TABLE `door_lock`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '门锁id',
  `yard_sn` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '园区sn（第三方）',
  `door_guid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '门禁id（第三方）',
  `door_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '门禁名称（第三方）',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `province_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '省名',
  `city_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '市名',
  `county_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '区名',
  `detail_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '详情地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '门锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of door_lock
-- ----------------------------
INSERT INTO `door_lock` VALUES (1, '786537017627385856', '5068416139942690838', '测试', '0', '2025-05-29 10:47:46', '2025-05-29 14:03:18', NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for door_lock_history
-- ----------------------------
DROP TABLE IF EXISTS `door_lock_history`;
CREATE TABLE `door_lock_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '门锁id',
  `yard_sn` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '园区sn（第三方）',
  `door_guid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '门禁id（第三方）',
  `operation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作记录(open：远程开门 reboot：重启)',
  `response` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '第三方接口响应',
  `detail_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '详情地址',
  `open_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户标识',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '门锁操作历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of door_lock_history
-- ----------------------------
INSERT INTO `door_lock_history` VALUES (1, '786537017627385856', '5068416139942690838', 'open', '400', NULL, 'o_2jP6zd9W79TNucHkuemFrpFaPg', '2025-06-24 16:00:22', '2025-06-24 16:00:22');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'goods_spu', '商品表', NULL, NULL, 'GoodsSpu', 'crud', '', 'com.joolun.system', 'system', 'spu', '商品', 'joolun', '0', '/', NULL, 'admin', '2025-03-19 14:31:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (2, 'spu_try_on_img_url', '商品试戴图片表', NULL, NULL, 'SpuTryOnImgUrl', 'crud', '', 'com.joolun.system', 'system', 'url', '商品试戴图片', 'joolun', '0', '/', NULL, 'admin', '2025-04-10 13:33:18', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (3, 'try_on_glass_img_url', '试戴眼镜图片地址表', NULL, NULL, 'TryOnGlassImgUrl', 'crud', '', 'com.joolun.system', 'system', 'url', '试戴眼镜图片地址', 'joolun', '0', '/', NULL, 'admin', '2025-04-10 13:33:30', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (4, 'goods_spu_banners', '轮播图表', NULL, NULL, 'GoodsSpuBanners', 'crud', 'element-plus', 'com.joolun.mall', 'system', 'banners', '轮播图', 'guihuyu', '0', '/', '{}', 'admin', '2025-04-10 15:17:35', '', '2025-04-10 15:18:17', NULL);
INSERT INTO `gen_table` VALUES (5, 'order_logistics_info', '物流信息查询表', NULL, NULL, 'OrderLogisticsInfo', 'crud', '', 'com.joolun.system', 'system', 'info', '物流信息查询', 'joolun', '0', '/', NULL, 'admin', '2025-04-11 14:04:49', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (6, 'door_lock', '门锁表', NULL, NULL, 'DoorLock', 'crud', '', 'com.joolun.system', 'system', 'lock', '门锁', 'joolun', '0', '/', NULL, 'admin', '2025-05-24 09:18:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (7, 'door_lock_history', '门锁操作历史表', NULL, NULL, 'DoorLockHistory', 'crud', 'element-plus', 'com.joolun.mall', 'mall', 'history', '门锁操作历史', 'joolun', '0', '/', '{}', 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'id', 'PK', 'varchar(32)', 'String', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (2, 1, 'spu_code', 'spu编码', 'varchar(32)', 'String', 'spuCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (3, 1, 'name', 'spu名字', 'varchar(200)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (4, 1, 'sell_point', '卖点', 'varchar(500)', 'String', 'sellPoint', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (5, 1, 'description', '描述', 'text', 'String', 'description', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (6, 1, 'category_first', '一级分类ID', 'varchar(32)', 'String', 'categoryFirst', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (7, 1, 'category_second', '二级分类ID', 'varchar(32)', 'String', 'categorySecond', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (8, 1, 'tag', '标签', 'varchar(255)', 'String', 'tag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (9, 1, 'pic_urls', '商品图片', 'varchar(1024)', 'String', 'picUrls', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 9, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (10, 1, 'shelf', '是否上架（1是 0否）', 'char(2)', 'String', 'shelf', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (11, 1, 'sort', '排序字段', 'int(11)', 'Long', 'sort', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (12, 1, 'sales_price', '销售价格', 'decimal(10,2)', 'BigDecimal', 'salesPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (13, 1, 'market_price', '市场价', 'decimal(10,2)', 'BigDecimal', 'marketPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (14, 1, 'cost_price', '成本价', 'decimal(10,2)', 'BigDecimal', 'costPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (15, 1, 'stock', '库存', 'int(11)', 'Long', 'stock', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (16, 1, 'sale_num', '销量', 'int(11)', 'Long', 'saleNum', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (17, 1, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (18, 1, 'update_time', '最后更新时间', 'timestamp', 'Date', 'updateTime', '0', '0', '1', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (19, 1, 'del_flag', '逻辑删除标记（0：显示；1：隐藏）', 'char(2)', 'String', 'delFlag', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'input', '', 19, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (20, 1, 'version', '版本号', 'int(11)', 'Long', 'version', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2025-03-19 14:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (21, 2, 'id', '主键ID', 'varchar(32)', 'String', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-10 13:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (22, 2, 'img_url', '图片地址', 'varchar(255)', 'String', 'imgUrl', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-10 13:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (23, 2, 'goods_spu_id', '商品SPU ID', 'varchar(32)', 'String', 'goodsSpuId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-10 13:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (24, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 4, 'admin', '2025-04-10 13:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (25, 2, 'update_time', '最后更新时间', 'timestamp', 'Date', 'updateTime', '0', '0', '1', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2025-04-10 13:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (26, 2, 'del_flag', '逻辑删除标记（0：显示；1：隐藏）', 'char(1)', 'String', 'delFlag', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-04-10 13:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (27, 3, 'id', '主键ID', 'varchar(32)', 'String', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (28, 3, 'wx_user_id', '微信用户ID', 'varchar(32)', 'String', 'wxUserId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (29, 3, 'img_url', '图片地址', 'varchar(255)', 'String', 'imgUrl', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (30, 3, 'goods_spu_id', '商品SPU ID', 'varchar(32)', 'String', 'goodsSpuId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (31, 3, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (32, 3, 'update_time', '最后更新时间', 'timestamp', 'Date', 'updateTime', '0', '0', '1', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 6, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (33, 3, 'del_flag', '逻辑删除标记（0：显示；1：隐藏）', 'char(1)', 'String', 'delFlag', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'input', '', 7, 'admin', '2025-04-10 13:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (34, 4, 'id', 'ID', 'int(20)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-10 15:17:35', '', '2025-04-10 15:18:17');
INSERT INTO `gen_table_column` VALUES (35, 4, 'goods_spu_id', '商品SPU ID', 'varchar(32)', 'String', 'goodsSpuId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-10 15:17:35', '', '2025-04-10 15:18:17');
INSERT INTO `gen_table_column` VALUES (36, 4, 'banner_img_url', '图片', 'varchar(255)', 'String', 'bannerImgUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-04-10 15:17:35', '', '2025-04-10 15:18:17');
INSERT INTO `gen_table_column` VALUES (37, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 4, 'admin', '2025-04-10 15:17:35', '', '2025-04-10 15:18:17');
INSERT INTO `gen_table_column` VALUES (38, 4, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2025-04-10 15:17:35', '', '2025-04-10 15:18:17');
INSERT INTO `gen_table_column` VALUES (39, 5, 'id', 'PK', 'varchar(32)', 'String', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (40, 5, 'logistics_id', '物流id', 'varchar(32)', 'String', 'logisticsId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (41, 5, 'status', '物流状态 1在途中，2派件中，3已签收，4派送失败，5揽收，6退回，7转单，8疑难，9退签，10待清关，11清关中，12已清关，13清关异常', 'char(2)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 3, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (42, 5, 'name', '物流名称', 'varchar(255)', 'String', 'name', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (43, 5, 'com', '快递公司代码', 'varchar(255)', 'String', 'com', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (44, 5, 'number', '快递单号', 'varchar(255)', 'String', 'number', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (45, 5, 'logo', '快递公司logo', 'varchar(255)', 'String', 'logo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (46, 5, 'list', '快递信息', 'varchar(2000)', 'String', 'list', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 8, 'admin', '2025-04-11 14:04:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (47, 6, 'id', '门锁id', 'bigint(32)', 'Long', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (48, 6, 'yard_sn', '园区sn（第三方）', 'varchar(36)', 'String', 'yardSn', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (49, 6, 'door_guid', '门禁id（第三方）', 'varchar(36)', 'String', 'doorGuid', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (50, 6, 'door_name', '门禁名称（第三方）', 'varchar(255)', 'String', 'doorName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (51, 6, 'del_flag', '逻辑删除标记（0：显示；1：隐藏）', 'char(2)', 'String', 'delFlag', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'input', '', 5, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (52, 6, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 6, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (53, 6, 'update_time', '最后更新时间', 'timestamp', 'Date', 'updateTime', '0', '0', '1', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (54, 6, 'province_name', '省名', 'varchar(50)', 'String', 'provinceName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (55, 6, 'city_name', '市名', 'varchar(50)', 'String', 'cityName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (56, 6, 'county_name', '区名', 'varchar(50)', 'String', 'countyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (57, 6, 'detail_info', '详情地址', 'varchar(255)', 'String', 'detailInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-05-24 09:18:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (58, 7, 'id', '门锁id', 'bigint(32)', 'Long', 'id', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (59, 7, 'yard_sn', '园区sn（第三方）', 'varchar(36)', 'String', 'yardSn', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (60, 7, 'door_guid', '门禁id（第三方）', 'varchar(36)', 'String', 'doorGuid', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (61, 7, 'operation', '操作记录(open：远程开门 reboot：重启)', 'varchar(255)', 'String', 'operation', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (62, 7, 'response', '第三方接口响应', 'varchar(255)', 'String', 'response', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (63, 7, 'detail_info', '详情地址', 'varchar(255)', 'String', 'detailInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (64, 7, 'open_id', '用户标识', 'varchar(64)', 'String', 'openId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (65, 7, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');
INSERT INTO `gen_table_column` VALUES (66, 7, 'update_time', '最后更新时间', 'timestamp', 'Date', 'updateTime', '0', '0', '1', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-05-24 09:18:10', '', '2025-05-24 09:27:22');

-- ----------------------------
-- Table structure for goods_category
-- ----------------------------
DROP TABLE IF EXISTS `goods_category`;
CREATE TABLE `goods_category`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `enable` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '（1：开启；0：关闭）',
  `parent_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '父分类编号',
  `name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '描述',
  `pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '图片',
  `sort` smallint NULL DEFAULT NULL COMMENT '排序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_category
-- ----------------------------
INSERT INTO `goods_category` VALUES ('1900362375073705986', '1', '0', '镜框', '', '/profile/upload/2025/04/02/O1CN01kFoUtK27ezMftJV2n_!!2213854717823-0-cib_20250402160607A001.jpg', 1, '2025-03-14 09:44:31', '2025-03-14 09:44:31', '0');
INSERT INTO `goods_category` VALUES ('1900364456392208385', '1', '1900362375073705986', '军达', '军达，显白，放大你的眼', '/profile/upload/2025/04/02/O1CN01a248j423ffZy7Wy5R_!!2212057487283-0-cib_20250402160623A002.jpg', 1, '2025-03-14 09:52:48', '2025-03-19 09:00:55', '0');
INSERT INTO `goods_category` VALUES ('1900364702459441153', '1', '1900362375073705986', '科迪讯', '款式多，库存多，发货迅速', '/profile/upload/2025/04/02/O1CN01aDLmEj250Z4n2wWGK_!!2209559537464-0-cib_20250402160638A003.jpg', 2, '2025-03-14 09:53:46', '2025-03-14 09:53:46', '0');
INSERT INTO `goods_category` VALUES ('1900364881426198529', '1', '1900362375073705986', '仟伊', '高级感十足', '/profile/upload/2025/04/02/O1CN01YzjaWa1xPk5BrPYfI_!!2212781886436-0-cib_20250402160649A004.jpg', 3, '2025-03-14 09:54:29', '2025-03-14 09:54:29', '0');
INSERT INTO `goods_category` VALUES ('1910138691179040769', '1', '0', '镜片', '', '/profile/upload/2025/04/10/9208511322_708216336_20250410091206A001.jpg', 2, '2025-04-10 09:12:07', '2025-04-10 09:12:07', '0');
INSERT INTO `goods_category` VALUES ('1910138691179041236', '1', '1910138691179040769', '视特耐', '', '/profile/upload/2025/04/10/O1CN01Eq9Q1T1Yar7kkYjcp_!!3044073076-0-cib_20250410091520A002.jpg', 1, '2025-04-10 09:14:30', '2025-04-10 09:15:06', '0');
INSERT INTO `goods_category` VALUES ('1910139821145509890', '1', '1910138691179040769', '蔡司', '', '/profile/upload/2025/04/10/蔡司_20250410103353A004.jpg', 2, '2025-04-10 09:16:36', '2025-04-10 09:16:36', '0');
INSERT INTO `goods_category` VALUES ('1910139977504968706', '1', '1910138691179040769', '凯米', '', '/profile/upload/2025/04/10/O1CN01hAKK232LM7YodZFG1_!!1856649677-0-cib_20250410091712A004.jpg', 3, '2025-04-10 09:17:13', '2025-04-10 09:17:13', '0');
INSERT INTO `goods_category` VALUES ('1910147834342289410', '1', '1910138691179040769', '明月', '', '/profile/upload/2025/04/10/明月_20250410094825A001.jpg', 4, '2025-04-10 09:48:27', '2025-04-10 09:48:27', '0');

-- ----------------------------
-- Table structure for goods_spu
-- ----------------------------
DROP TABLE IF EXISTS `goods_spu`;
CREATE TABLE `goods_spu`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `spu_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'spu编码',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT 'spu名字',
  `sell_point` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT '卖点',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '描述',
  `category_first` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '一级分类ID',
  `category_second` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '二级分类ID',
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '标签',
  `pic_urls` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `shelf` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '是否上架（1是 0否）',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序字段',
  `sales_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售价格',
  `market_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '市场价',
  `cost_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '成本价',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `sale_num` int NULL DEFAULT 0 COMMENT '销量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `version` int NULL DEFAULT 0 COMMENT '版本号',
  PRIMARY KEY (`id`) USING BTREE,
  FULLTEXT INDEX `idx_fulltext_search`(`name`, `sell_point`, `description`, `tag`) WITH PARSER `ngram`
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_spu
-- ----------------------------
INSERT INTO `goods_spu` VALUES ('1900363838747389953', '', '军达-冰蓝色镜框', '好看', '噶安徽就卡死爱迪生\n', '1900362375073705986', '1900364456392208385', '国产,进口', '[\"/profile/upload/2025/04/16/bls_20250416185945A029.jpg\"]', '1', 0, 0.01, 0.01, 9.00, 946, 28, '2025-03-14 09:50:20', '2025-03-19 09:41:26', '0', 131);
INSERT INTO `goods_spu` VALUES ('1900378351710318593', '2312', '金色', '高端大气', '<p>噶安徽就卡死爱迪生的两个角色公司开了个看</p><p>安徽卡号</p><p>司法考试计划阿萨分类\n</p>', '1900362375073705986', '1900364456392208385', '国产', '[\"/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg\"]', '1', 0, 0.01, 12.00, 10.00, 489, 27, '2025-03-14 10:48:01', '2025-03-19 09:41:27', '0', 37);
INSERT INTO `goods_spu` VALUES ('1900378673224691713', '2122', '简约椭圆', '时尚高颜值', 'asdzx', '1900362375073705986', '1900364456392208385', '进口', '[\"/profile/upload/2025/04/14/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250414084955A009.jpg\"]', '1', 0, 0.01, 12.00, 10.00, 699, 22, '2025-03-14 10:49:17', '2025-03-19 11:05:33', '0', 18);
INSERT INTO `goods_spu` VALUES ('1900379604263710721', '2124', '优雅精致纯钛架', '纯钛，斯文典雅，万搭', 'zxczx', '1900362375073705986', '1900364456392208385', '进口', '[\"/profile/upload/2025/04/16/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250416194940A002.jpg\"]', '1', 0, 0.01, 18.00, 13.00, 2499, 123, '2025-03-14 10:52:59', '2025-03-19 11:05:33', '0', 15);
INSERT INTO `goods_spu` VALUES ('1900382455924862977', '', '星耀黑银', '高级感', '<p> asda</p>', '1900362375073705986', '1900364881426198529', '进口', '[\"/profile/upload/2025/04/02/2_20250402162503A010.jpg\"]', '1', 0, 0.01, 14.00, 10.00, 6, 26, '2025-03-14 11:04:19', '2025-03-19 11:05:33', '0', 10);
INSERT INTO `goods_spu` VALUES ('1900382773244932098', '', '巴黎灰岛', '神秘', '<p>mnhsd</p>', '1900362375073705986', '1900364881426198529', '国产', '[\"/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg\"]', '1', 0, 0.01, 15.00, 11.00, 9, 29, '2025-03-14 11:05:35', '2025-03-19 09:41:31', '0', 8);
INSERT INTO `goods_spu` VALUES ('1900383214020145154', '', '方框男生镜框', '细腻质感，立体轮廓', '123132', '1900362375073705986', '1900364702459441153', '国产', '[\"/dev-api/profile/upload/2025/04/02/O1CN01aDLmEj250Z4n2wWGK_!!2209559537464-0-cib_20250402162529A012.jpg\"]', '1', 0, 50.00, 22.00, 15.00, 99, 129, '2025-03-14 11:07:20', '2025-03-19 09:41:32', '0', 4);
INSERT INTO `goods_spu` VALUES ('1900383473018417154', '111', '全框', '轻便，耐摔', '<p>hyh</p>', '1900362375073705986', '1900364702459441153', '全框', '[\"/profile/upload/2025/04/02/O1CN01AVDr61250ZBTE7nQD_!!2209559537464-0-cib_20250402162542A013.jpg\"]', '1', 0, 0.01, 18.00, 13.00, 148, 66, '2025-03-14 11:08:22', '2025-03-19 11:05:22', '0', 6);
INSERT INTO `goods_spu` VALUES ('1900384263716024321', '112', '商务男士半框', '高品质，轻奢高尚', '<p>jih</p>', '1900362375073705986', '1900364702459441153', '半框,进口', '[\"/profile/upload/2025/04/02/O1CN01YzjaWa1xPk5BrPYfI_!!2212781886436-0-cib_20250402162556A014.jpg\"]', '1', 0, 0.01, 34.00, 17.00, 199, 204, '2025-03-14 11:11:30', '2025-03-24 13:18:39', '0', 2);
INSERT INTO `goods_spu` VALUES ('1900384575709327362', '113', '潮色金属半框', '真空IP电镀', '&lt;!DOCTYPE html&gt;&lt;html lang=\"en\"&gt;&lt;head&gt;    &lt;meta charset=\"UTF-8\"&gt;    &lt;meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"&gt;    &lt;title&gt;商品介绍&lt;/title&gt;    &lt;style&gt;        body {            font-family: Arial, sans-serif;            line-height: 1.6;            margin: 0;            padding: 0;            background-color: #f4f4f4;        }        .container {            width: 80%;            margin: auto;            overflow: hidden;        }        .product-intro {            background: #fff;            padding: 20px;            margin-top: 20px;            border-radius: 5px;            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);        }        .product-intro h1 {            color: #333;        }        .product-intro img {            max-width: 100%;            height: auto;            margin-bottom: 20px;        }        .product-intro p {            margin-bottom: 10px;        }        .product-intro ul {            margin: 0;            padding: 0;            list-style: none;        }        .product-intro ul li {            margin-bottom: 10px;            padding-left: 20px;            position: relative;        }        .product-intro ul li::before {            content: \"•\";            position: absolute;            left: 0;            color: #ff6347;            font-size: 20px;        }        .product-intro .price {            font-size: 24px;            color: #ff6347;            margin-top: 20px;        }        .product-intro .btn {            display: inline-block;            background: #ff6347;            color: #fff;            padding: 10px 20px;            text-decoration: none;            border-radius: 5px;            margin-top: 20px;        }        .product-intro .btn:hover {            background: #e0533e;        }    &lt;/style&gt;&lt;/head&gt;&lt;body&gt;    &lt;div class=\"container\"&gt;        &lt;div class=\"product-intro\"&gt;            &lt;h1&gt;智能手表&lt;/h1&gt;            &lt;img src=\"https://via.placeholder.com/500x300\" alt=\"智能手表\"&gt;            &lt;p&gt;这是一款功能强大的智能手表，适合追求时尚与科技的您。&lt;/p&gt;            &lt;ul&gt;                &lt;li&gt;高清触摸屏，操作流畅便捷&lt;/li&gt;                &lt;li&gt;多种运动模式，满足您的运动需求&lt;/li&gt;                &lt;li&gt;健康监测功能，实时关注您的身体状况&lt;/li&gt;                &lt;li&gt;长续航电池，让您无需频繁充电&lt;/li&gt;            &lt;/ul&gt;            &lt;div class=\"price\"&gt;￥999.00&lt;/div&gt;                  &lt;/div&gt;    &lt;/div&gt;&lt;/body&gt;&lt;/html&gt;', '1900362375073705986', '1900364702459441153', '进口,全框', '[\"/dev-api/profile/upload/2025/04/02/O1CN01zd7cxa250ZGppw10H_!!2209559537464-0-cib_20250402162609A015.jpg\"]', '1', 0, 10.00, 28.00, 16.00, 189, 142, '2025-03-14 11:12:44', '2025-03-24 13:18:58', '0', 7);
INSERT INTO `goods_spu` VALUES ('1910142888230309889', '1231321', '蔡司', '进口', '<p>国际大品牌</p>', '1910138691179040769', '1910139821145509890', '进口,树脂', '[\"/profile/upload/2025/04/10/cs1_20250410103456A005.jpg\"]', '1', 0, 0.01, 12.00, 7.00, 99994, 4, '2025-04-10 09:28:47', '2025-04-10 09:28:47', '0', 9);
INSERT INTO `goods_spu` VALUES ('1910148048591532034', '', '明月', '超亮高清超薄非球面防蓝光定制近视高度配眼镜片', '耐磨，易清洁', '1910138691179040769', '1910147834342289410', '树脂', '[\"/profile/upload/2025/04/10/明月_20250410102247A003.jpg\"]', '1', 0, 0.01, 9.00, 6.00, 9998, 0, '2025-04-10 09:49:18', '2025-04-16 18:10:11', '0', 5);

-- ----------------------------
-- Table structure for goods_spu_banners
-- ----------------------------
DROP TABLE IF EXISTS `goods_spu_banners`;
CREATE TABLE `goods_spu_banners`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_spu_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL,
  `banner_img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '轮播图表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goods_spu_banners
-- ----------------------------
INSERT INTO `goods_spu_banners` VALUES (2, '1900384263716024321', '/profile/upload/2025/04/14/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250414102400A019.jpg', '2025-04-13 16:46:40', '2025-04-14 10:24:01');
INSERT INTO `goods_spu_banners` VALUES (4, '1900378351710318593', '/profile/upload/2025/04/14/bls_20250414103725A022.jpg', '2025-04-13 17:02:57', '2025-04-14 10:37:27');
INSERT INTO `goods_spu_banners` VALUES (5, '1910142888230309889', '/profile/upload/2025/04/14/bls_20250414103824A023.jpg', '2025-04-13 17:03:49', '2025-04-14 10:38:25');

-- ----------------------------
-- Table structure for optometry_data
-- ----------------------------
DROP TABLE IF EXISTS `optometry_data`;
CREATE TABLE `optometry_data`  (
  `optometry_id` bigint NOT NULL AUTO_INCREMENT COMMENT '眼镜验光ID',
  `optometry_records_id` bigint NULL DEFAULT NULL COMMENT '验光记录ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `spherical_mirror` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '球镜数据',
  `cylindrical_mirror` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '柱镜数据',
  `position_of_axis` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '轴位数据',
  `addend` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ADD数据',
  `distance_of_pupil` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '瞳距数据',
  `horizontal_prism` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '水平棱镜数据',
  `vertical_prism` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '垂直棱镜数据',
  `type` int NOT NULL COMMENT '分类数据（1=电脑验光仪，2=查片仪，3=验光头，4=最终配镜）',
  `near_far` int NULL DEFAULT NULL COMMENT '远近数据（0=远，1=近）',
  `left_right_eyes` int NOT NULL COMMENT '左右眼数据（0=左眼，1=右眼）',
  PRIMARY KEY (`optometry_id`) USING BTREE,
  INDEX `optometry_records_id`(`optometry_records_id` ASC) USING BTREE,
  CONSTRAINT `optometry_data_ibfk_1` FOREIGN KEY (`optometry_records_id`) REFERENCES `optometry_records` (`optometry_records_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '眼镜验光数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of optometry_data
-- ----------------------------

-- ----------------------------
-- Table structure for optometry_records
-- ----------------------------
DROP TABLE IF EXISTS `optometry_records`;
CREATE TABLE `optometry_records`  (
  `optometry_records_id` bigint NOT NULL AUTO_INCREMENT COMMENT '验光记录ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `customer_id` bigint NULL DEFAULT NULL COMMENT '顾客ID',
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '顾客姓名',
  `optometrist_id` bigint NOT NULL COMMENT '验光师ID',
  `optometrist_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '验光师姓名',
  `store_id` bigint NOT NULL COMMENT '门店ID',
  `store_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店名称',
  `store_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店电话',
  PRIMARY KEY (`optometry_records_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '验光记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of optometry_records
-- ----------------------------

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户id',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '订单单号',
  `payment_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '支付方式1、货到付款；2、在线支付',
  `is_pay` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否支付0、未支付 1、已支付',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '订单名',
  `status` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '订单状态1、待发货 2、待收货 3、确认收货/已完成 5、已关闭',
  `freight_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '运费金额',
  `sales_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售金额',
  `payment_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额（销售金额+运费金额）',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '付款时间',
  `delivery_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `receiver_time` datetime NULL DEFAULT NULL COMMENT '收货时间',
  `closing_time` datetime NULL DEFAULT NULL COMMENT '成交时间',
  `user_message` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '买家留言',
  `transaction_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '支付交易ID',
  `logistics_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '物流id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_info
-- ----------------------------
INSERT INTO `order_info` VALUES ('1354094503631306753', '0', '2021-01-26 23:51:02', '2021-01-26 23:51:02', '1352572935968165889', '1354094503576731648', '2', '0', NULL, '5', 0.00, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_info` VALUES ('1354469715404148737', '0', '2021-01-28 00:41:59', '2021-01-28 00:41:59', '1352168072700571649', '1354469713115086848', '2', '0', 'iPhone12白色', '5', 0.00, 4999.00, 4999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1354469714800168962', NULL);
INSERT INTO `order_info` VALUES ('1354474070446510081', '0', '2021-01-28 00:59:17', '2021-01-28 00:59:17', '1354473059078176770', '1354474068199342080', '2', '0', 'iPhone12白色', '5', 0.00, 4999.00, 4999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1354474069813170178', NULL);
INSERT INTO `order_info` VALUES ('1354620399822884865', '0', '2021-01-28 10:40:45', '2021-01-28 10:40:45', '1354473059078176770', '1354620397982580736', '2', '0', 'iPhone12白色', '5', 0.00, 4999.00, 4999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1354620399231488001', NULL);
INSERT INTO `order_info` VALUES ('1354795347837304834', '0', '2021-01-28 22:15:56', '2021-01-28 22:15:55', '1354473059078176770', '1354795346135351296', '2', '0', 'iPhone12白色', '5', 0.00, 4999.00, 4999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1354795347308822530', NULL);
INSERT INTO `order_info` VALUES ('1354797185856794625', '0', '2021-01-28 22:23:14', '2021-01-28 22:23:13', '1354473059078176770', '1354797183827705856', '2', '0', 'iPhone12白色', '5', 0.00, 4999.00, 4999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1354797185185705985', NULL);
INSERT INTO `order_info` VALUES ('1354797794534137858', '0', '2021-01-28 22:25:39', '2021-01-28 22:25:39', '1354473059078176770', '1354797792530268160', '2', '0', 'iPhone12白色', '5', 0.00, 4999.00, 4999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1354797793913380865', NULL);
INSERT INTO `order_info` VALUES ('1354798824059609090', '0', '2021-01-28 22:29:45', '2021-01-28 22:29:44', '1354473059078176770', '1354798822391283712', '2', '1', 'iPhone12白色', '3', 0.00, 0.01, 0.01, '2021-01-28 22:30:01', '2021-01-28 23:16:51', '2021-01-28 23:17:41', NULL, NULL, '4200000797202101287152815447', '1354798823514349569', NULL);
INSERT INTO `order_info` VALUES ('1354798971141267457', '0', '2021-01-28 22:30:20', '2021-01-28 22:30:19', '1354473059078176770', '1354798969477136384', '2', '1', 'iPhone12白色', '3', 0.00, 0.01, 0.01, '2021-01-28 22:32:33', '2021-01-28 23:10:49', '2021-01-28 23:16:19', NULL, NULL, '4200000808202101285235202004', '1354798970596007937', NULL);
INSERT INTO `order_info` VALUES ('1355417350676951041', '0', '2021-01-30 15:27:33', '2021-01-30 15:27:33', '1355406809988345857', '1355417348219076608', '2', '0', '【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38', NULL, 0.00, 0.20, 0.20, NULL, NULL, NULL, NULL, NULL, NULL, '1355417349930364930', NULL);
INSERT INTO `order_info` VALUES ('1355418768053907457', '0', '2021-01-30 15:33:11', '2021-01-30 15:33:11', '1355406809988345857', '1355418765948354560', '2', '0', 'Apple iPhone', NULL, 0.00, 6000.00, 6000.00, NULL, NULL, NULL, NULL, NULL, NULL, '1355418767420567554', NULL);
INSERT INTO `order_info` VALUES ('1355426472587714562', '0', '2021-01-30 16:03:48', '2021-01-30 16:03:48', '1355406809988345857', '1355426470679281664', '2', '1', '【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38', '1', 0.00, 0.10, 0.10, '2021-01-30 16:04:20', NULL, NULL, NULL, NULL, '4200000801202101302811163830', '1355426471975346177', NULL);
INSERT INTO `order_info` VALUES ('1357673549756682241', '0', '2021-02-05 20:52:53', '2021-02-05 20:52:52', '1354473059078176770', '1357673547845074944', '2', '0', 'iPhone 12 Pro', '5', 0.00, 8499.00, 8499.00, NULL, NULL, NULL, NULL, NULL, NULL, '1357673549135925250', NULL);
INSERT INTO `order_info` VALUES ('1632993114357575681', '0', '2023-03-07 14:34:33', '2023-03-07 14:34:32', '1354473059078176770', '1632993114207551488', '2', '0', 'HUAWEI P40 Pro+', '5', 0.00, 0.98, 0.98, NULL, NULL, NULL, NULL, NULL, NULL, '1632993114324021250', NULL);
INSERT INTO `order_info` VALUES ('1632994752065449985', '0', '2023-03-07 14:41:03', '2023-03-07 14:41:03', '1354473059078176770', '1632994751923879936', '2', '0', 'HUAWEI P40 Pro+', '5', 0.00, 0.10, 0.10, NULL, NULL, NULL, NULL, NULL, NULL, '1632994752031895553', NULL);
INSERT INTO `order_info` VALUES ('1632995133256437763', '0', '2023-03-07 14:42:34', '2023-03-07 14:42:34', '1354473059078176770', '1632995133102227456', '2', '1', 'HUAWEI P40 Pro+', '5', 0.00, 0.10, 0.10, '2023-03-07 14:42:56', '2023-03-07 14:59:46', NULL, NULL, NULL, '4200001772202303073968832224', '1632995133256437762', NULL);
INSERT INTO `order_info` VALUES ('1645623820711706626', '0', '2023-04-11 11:04:28', '2023-04-11 11:04:27', '1354473059078176770', '1645623820574261248', '2', '0', 'Apple iPhone 13 Pro', '5', 0.00, 8999.00, 8999.00, NULL, NULL, NULL, NULL, NULL, NULL, '1645623820711706625', NULL);
INSERT INTO `order_info` VALUES ('1645635415705706497', '0', '2023-04-11 11:50:32', '2023-04-11 11:50:32', '1354473059078176770', '1645635415513759744', '2', '1', 'HUAWEI P40 Pro+', '5', 0.00, 0.10, 0.10, '2023-04-11 11:50:49', NULL, NULL, NULL, NULL, '4200001784202304119379049641', '1645635415605043201', NULL);
INSERT INTO `order_info` VALUES ('1901559589749952513', '0', '2025-03-17 17:01:50', '2025-03-17 17:01:50', '1900425114278260738', '1901559589581619200', '2', '0', '优雅精致纯钛架', NULL, 0.00, 25.00, 25.00, NULL, NULL, NULL, NULL, NULL, NULL, '1901559589724786690', NULL);
INSERT INTO `order_info` VALUES ('1909241965190647810', '0', '2025-04-07 21:48:51', '2025-04-07 21:48:51', '1907278202958839809', '1909241965120061440', '2', '0', '军达-冰蓝色镜框', NULL, 20.00, 10.00, 30.00, NULL, NULL, NULL, NULL, '', NULL, '1909241965169676289', NULL);
INSERT INTO `order_info` VALUES ('1909246795489546241', '0', '2025-04-07 22:08:03', '2025-04-07 22:08:02', '1907278202958839809', '1909246795452514304', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909246795485351937', NULL);
INSERT INTO `order_info` VALUES ('1909248649824899074', '0', '2025-04-07 22:15:25', '2025-04-07 22:15:24', '1907278202958839809', '1909248649792061440', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909248649824899073', NULL);
INSERT INTO `order_info` VALUES ('1909403939903967234', '0', '2025-04-08 08:32:29', '2025-04-08 08:32:28', '1907278202958839809', '1909403939862740992', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909403939895578626', NULL);
INSERT INTO `order_info` VALUES ('1909407615208984578', '0', '2025-04-08 08:47:05', '2025-04-08 08:47:05', '1907278202958839809', '1909407615176146944', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909407615204790273', NULL);
INSERT INTO `order_info` VALUES ('1909412235268395010', '0', '2025-04-08 09:05:27', '2025-04-08 09:05:26', '1907278202958839809', '1909412235231363072', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909412235260006402', NULL);
INSERT INTO `order_info` VALUES ('1909412914326212610', '0', '2025-04-08 09:08:09', '2025-04-08 09:08:08', '1907278202958839809', '1909412914284986368', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909412914313629697', NULL);
INSERT INTO `order_info` VALUES ('1909415386277023745', '0', '2025-04-08 09:17:58', '2025-04-08 09:17:57', '1907278202958839809', '1909415386231603200', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909415386264440833', NULL);
INSERT INTO `order_info` VALUES ('1909415645183021058', '0', '2025-04-08 09:19:00', '2025-04-08 09:18:59', '1907278202958839809', '1909415645133406208', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 10.00, 10.00, NULL, NULL, NULL, NULL, '', NULL, '1909415645174632449', NULL);
INSERT INTO `order_info` VALUES ('1909416095475109889', '0', '2025-04-08 09:20:47', '2025-04-08 09:20:47', '1907278202958839809', '1909416095438077952', '2', '0', '金色', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909416095470915585', NULL);
INSERT INTO `order_info` VALUES ('1909416766563749890', '0', '2025-04-08 09:23:27', '2025-04-08 09:23:27', '1907278202958839809', '1909416766526717952', '2', '0', '金色', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909416766555361282', NULL);
INSERT INTO `order_info` VALUES ('1909416858419007490', '0', '2025-04-08 09:23:49', '2025-04-08 09:23:48', '1907278202958839809', '1909416858377781248', '2', '0', '优雅精致纯钛架', NULL, 0.00, 15.00, 15.00, NULL, NULL, NULL, NULL, '', NULL, '1909416858410618881', NULL);
INSERT INTO `order_info` VALUES ('1909417103785791490', '0', '2025-04-08 09:24:47', '2025-04-08 09:24:47', '1907278202958839809', '1909417103748759552', '2', '0', '金色', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909417103777402882', NULL);
INSERT INTO `order_info` VALUES ('1909417386402189313', '0', '2025-04-08 09:25:55', '2025-04-08 09:25:54', '1907278202958839809', '1909417386365157376', '2', '0', '金色', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909417386397995010', NULL);
INSERT INTO `order_info` VALUES ('1909420850138124289', '0', '2025-04-08 09:39:41', '2025-04-08 09:39:40', '1907278202958839809', '1909420850105286656', '2', '0', '简约椭圆', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909420850133929986', NULL);
INSERT INTO `order_info` VALUES ('1909421506592837633', '0', '2025-04-08 09:42:17', '2025-04-08 09:42:17', '1907278202958839809', '1909421506555805696', '2', '0', '简约椭圆', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909421506588643330', NULL);
INSERT INTO `order_info` VALUES ('1909422767266402306', '0', '2025-04-08 09:47:18', '2025-04-08 09:47:17', '1907278202958839809', '1909422767233564672', '2', '0', '简约椭圆', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909422767262208002', NULL);
INSERT INTO `order_info` VALUES ('1909422804138528770', '0', '2025-04-08 09:47:27', '2025-04-08 09:47:26', '1907278202958839809', '1909422804097302528', '2', '0', '优雅精致纯钛架', NULL, 0.00, 15.00, 15.00, NULL, NULL, NULL, NULL, '', NULL, '1909422804100780034', NULL);
INSERT INTO `order_info` VALUES ('1909422943930486785', '0', '2025-04-08 09:48:00', '2025-04-08 09:47:59', '1907278202958839809', '1909422943893454848', '2', '0', '巴黎灰岛', NULL, 0.00, 13.00, 13.00, NULL, NULL, NULL, NULL, '', NULL, '1909422943926292481', NULL);
INSERT INTO `order_info` VALUES ('1909423759051526146', '0', '2025-04-08 09:51:14', '2025-04-08 09:51:14', '1907278202958839809', '1909423759014494208', '2', '0', '星耀黑银', NULL, 0.00, 13.00, 13.00, NULL, NULL, NULL, NULL, '', NULL, '1909423759043137537', NULL);
INSERT INTO `order_info` VALUES ('1909424048865349633', '0', '2025-04-08 09:52:23', '2025-04-08 09:52:23', '1907278202958839809', '1909424048828317696', '2', '0', '巴黎灰岛', NULL, 0.00, 13.00, 13.00, NULL, NULL, NULL, NULL, '', NULL, '1909424048861155330', NULL);
INSERT INTO `order_info` VALUES ('1909427697490386945', '0', '2025-04-08 10:06:53', '2025-04-08 10:06:53', '1907278202958839809', '1909427696736141312', '2', '0', '优雅精致纯钛架', NULL, 0.00, 15.00, 15.00, NULL, NULL, NULL, NULL, '', NULL, '1909427696873824257', NULL);
INSERT INTO `order_info` VALUES ('1909428445636780034', '0', '2025-04-08 10:09:52', '2025-04-08 10:09:51', '1907278202958839809', '1909428445578788864', '2', '0', '优雅精致纯钛架', NULL, 0.00, 15.00, 15.00, NULL, NULL, NULL, NULL, '', NULL, '1909428445624197122', NULL);
INSERT INTO `order_info` VALUES ('1909430786809192449', '0', '2025-04-08 10:19:10', '2025-04-08 10:19:09', '1907278202958839809', '1909430786705063936', '2', '0', '优雅精致纯钛架', NULL, 0.00, 15.00, 15.00, NULL, NULL, NULL, NULL, '', NULL, '1909430786779832322', NULL);
INSERT INTO `order_info` VALUES ('1909433413735284738', '0', '2025-04-08 10:29:36', '2025-04-08 10:29:36', '1907278202958839809', '1909433412876238848', '2', '0', '星耀黑银', NULL, 0.00, 13.00, 13.00, NULL, NULL, NULL, NULL, '', NULL, '1909433413085167618', NULL);
INSERT INTO `order_info` VALUES ('1909435201062510593', '0', '2025-04-08 10:36:42', '2025-04-08 10:36:42', '1907278202958839809', '1909435200211779584', '2', '0', '巴黎灰岛', NULL, 0.00, 13.00, 13.00, NULL, NULL, NULL, NULL, '', NULL, '1909435200454336514', NULL);
INSERT INTO `order_info` VALUES ('1909450699514912771', '0', '2025-04-08 11:38:17', '2025-04-08 11:38:17', '1907278202958839809', '1909450699503042560', '2', '0', '金色', NULL, 0.00, 11.00, 11.00, NULL, NULL, NULL, NULL, '', NULL, '1909450699514912770', NULL);
INSERT INTO `order_info` VALUES ('1909474273558581251', '0', '2025-04-08 13:11:58', '2025-04-08 13:11:57', '1907278202958839809', '1909474273555120128', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909474273558581250', NULL);
INSERT INTO `order_info` VALUES ('1909475366304763905', '0', '2025-04-08 13:16:18', '2025-04-08 13:16:18', '1907278202958839809', '1909475365487640576', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909475365642063873', NULL);
INSERT INTO `order_info` VALUES ('1909486529088376834', '0', '2025-04-08 14:00:40', '2025-04-08 14:00:39', '1907278202958839809', '1909486528946503680', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909486529054822402', NULL);
INSERT INTO `order_info` VALUES ('1909489014892994561', '0', '2025-04-08 14:10:32', '2025-04-08 14:10:32', '1907278202958839809', '1909489014038069248', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909489014234488833', NULL);
INSERT INTO `order_info` VALUES ('1909494718420819970', '0', '2025-04-08 14:33:12', '2025-04-08 14:33:12', '1907278202958839809', '1909494718350229504', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909494718404042753', NULL);
INSERT INTO `order_info` VALUES ('1909496224767287297', '0', '2025-04-08 14:39:11', '2025-04-08 14:39:11', '1907278202958839809', '1909496223887261696', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909496224092004353', NULL);
INSERT INTO `order_info` VALUES ('1909496404400939010', '0', '2025-04-08 14:39:54', '2025-04-08 14:39:54', '1907278202958839809', '1909496404334608384', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909496404379967489', NULL);
INSERT INTO `order_info` VALUES ('1909497426477326338', '0', '2025-04-08 14:43:58', '2025-04-08 14:43:57', '1907278202958839809', '1909497426461327360', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909497426477326337', NULL);
INSERT INTO `order_info` VALUES ('1909498542254465026', '0', '2025-04-08 14:48:24', '2025-04-08 14:48:23', '1907278202958839809', '1909498542200717312', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909498542241882113', NULL);
INSERT INTO `order_info` VALUES ('1909498944274309122', '0', '2025-04-08 14:50:00', '2025-04-08 14:49:59', '1907278202958839809', '1909498944191201280', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909498944274309121', NULL);
INSERT INTO `order_info` VALUES ('1909499415986786306', '0', '2025-04-08 14:51:52', '2025-04-08 14:51:52', '1907278202958839809', '1909499415010213888', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909499415227617281', NULL);
INSERT INTO `order_info` VALUES ('1909499520152326146', '0', '2025-04-08 14:52:17', '2025-04-08 14:52:17', '1907278202958839809', '1909499520085917696', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909499520135548929', NULL);
INSERT INTO `order_info` VALUES ('1909499813401284610', '0', '2025-04-08 14:53:27', '2025-04-08 14:53:26', '1907278202958839809', '1909499813326487552', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909499813392896002', NULL);
INSERT INTO `order_info` VALUES ('1909500103953305602', '0', '2025-04-08 14:54:36', '2025-04-08 14:54:36', '1907278202958839809', '1909500103878508544', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909500103936528385', NULL);
INSERT INTO `order_info` VALUES ('1909500164317728770', '0', '2025-04-08 14:54:51', '2025-04-08 14:54:50', '1907278202958839809', '1909500164259708928', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909500164305145858', NULL);
INSERT INTO `order_info` VALUES ('1909500257099927555', '0', '2025-04-08 14:55:13', '2025-04-08 14:55:12', '1907278202958839809', '1909500257046102016', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909500257099927554', NULL);
INSERT INTO `order_info` VALUES ('1909500297096810498', '0', '2025-04-08 14:55:22', '2025-04-08 14:55:22', '1907278202958839809', '1909500297034596352', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909500297084227585', NULL);
INSERT INTO `order_info` VALUES ('1909500317724397571', '0', '2025-04-08 14:55:27', '2025-04-08 14:55:27', '1907278202958839809', '1909500317729292288', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909500317724397570', NULL);
INSERT INTO `order_info` VALUES ('1909504734561390594', '0', '2025-04-08 15:13:00', '2025-04-08 15:13:00', '1907278202958839809', '1909504734499176448', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909504734536224769', NULL);
INSERT INTO `order_info` VALUES ('1909513503307542530', '0', '2025-04-08 15:47:51', '2025-04-08 15:47:50', '1907278202958839809', '1909513502523916288', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909513502690979842', NULL);
INSERT INTO `order_info` VALUES ('1909514804070236161', '0', '2025-04-08 15:53:01', '2025-04-08 15:53:01', '1907278202958839809', '1909514803227918336', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909514803415924737', NULL);
INSERT INTO `order_info` VALUES ('1909519340210044929', '0', '2025-04-08 16:11:02', '2025-04-08 16:11:02', '1907278202958839809', '1909519339397054464', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909519339568316417', NULL);
INSERT INTO `order_info` VALUES ('1909520686996852738', '0', '2025-04-08 16:16:23', '2025-04-08 16:16:23', '1907278202958839809', '1909520686154514432', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909520686392872961', NULL);
INSERT INTO `order_info` VALUES ('1909525358532894721', '0', '2025-04-08 16:34:57', '2025-04-08 16:34:57', '1907278202958839809', '1909525357266993152', '2', '1', '金色', '3', 0.00, 0.01, 0.01, '2025-04-08 16:35:06', '2025-04-08 16:49:32', '2025-04-09 13:40:07', NULL, '', '4200002712202504081271157962', '1909525357522067457', NULL);
INSERT INTO `order_info` VALUES ('1909529369805856769', '0', '2025-04-08 16:50:54', '2025-04-08 16:50:53', '1907278202958839809', '1909529369743720448', '2', '1', '全框', '1', 0.00, 0.01, 0.01, '2025-04-08 16:51:03', NULL, NULL, NULL, '', '4200002674202504081387000100', '1909529369793273857', NULL);
INSERT INTO `order_info` VALUES ('1909537018857480193', '0', '2025-04-08 17:21:17', '2025-04-08 17:21:17', '1907278202958839809', '1909537017880903680', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.06, 0.06, NULL, NULL, NULL, NULL, '', NULL, '1909537018232528897', NULL);
INSERT INTO `order_info` VALUES ('1909537232091701250', '0', '2025-04-08 17:22:08', '2025-04-08 17:22:08', '1907278202958839809', '1909537232000122880', '2', '1', '军达-冰蓝色镜框', '1', 0.00, 0.02, 0.02, '2025-04-08 17:22:20', NULL, NULL, NULL, '', '4200002674202504089165881729', '1909537232079118338', NULL);
INSERT INTO `order_info` VALUES ('1909539063148666881', '0', '2025-04-08 17:29:25', '2025-04-08 17:29:24', '1907278202958839809', '1909539063090642944', '2', '1', '军达-冰蓝色镜框', '2', 0.00, 0.01, 0.01, '2025-04-08 17:29:49', '2025-04-10 11:35:23', NULL, NULL, '', '4200002692202504086168330809', '1909539063131889666', NULL);
INSERT INTO `order_info` VALUES ('1909540322941427713', '0', '2025-04-08 17:34:25', '2025-04-08 17:34:25', '1907278202958839809', '1909540322904375296', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909540322933039105', NULL);
INSERT INTO `order_info` VALUES ('1909540512003874818', '0', '2025-04-08 17:35:10', '2025-04-08 17:35:10', '1907278202958839809', '1909540511966822400', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909540511999680513', NULL);
INSERT INTO `order_info` VALUES ('1909540681504088065', '0', '2025-04-08 17:35:51', '2025-04-08 17:35:50', '1907278202958839809', '1909540681458647040', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909540681491505154', NULL);
INSERT INTO `order_info` VALUES ('1909779974680043523', '0', '2025-04-09 09:26:43', '2025-04-09 09:26:42', '1907278202958839809', '1909779974655574016', '2', '1', '军达-冰蓝色镜框', '1', 0.00, 0.01, 0.01, '2025-04-09 09:26:55', NULL, NULL, NULL, '', '4200002628202504096084114289', '1909779974680043522', NULL);
INSERT INTO `order_info` VALUES ('1909780068674396162', '0', '2025-04-09 09:27:05', '2025-04-09 09:27:05', '1907278202958839809', '1909780068645732352', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 09:27:27', '2025-04-09 14:29:54', '2025-04-09 14:30:07', NULL, '', '4200002630202504093227258183', '1909780068674396161', NULL);
INSERT INTO `order_info` VALUES ('1909782134645940226', '0', '2025-04-09 09:35:18', '2025-04-09 09:35:17', '1907278202958839809', '1909782134617276416', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 09:35:33', '2025-04-09 14:00:42', '2025-04-09 14:01:06', NULL, '', '4200002682202504091759271656', '1909782134637551618', NULL);
INSERT INTO `order_info` VALUES ('1909783564563865601', '0', '2025-04-09 09:40:59', '2025-04-09 09:40:58', '1907278202958839809', '1909783564531007488', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909783564555476993', NULL);
INSERT INTO `order_info` VALUES ('1909783615403024386', '0', '2025-04-09 09:41:11', '2025-04-09 09:41:10', '1907278202958839809', '1909783615365971968', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 09:41:43', '2025-04-09 13:59:40', '2025-04-09 13:59:53', NULL, NULL, '4200002620202504099483941877', '1909783615394635778', NULL);
INSERT INTO `order_info` VALUES ('1909785338817372162', '0', '2025-04-09 09:48:02', '2025-04-09 09:48:01', '1907278202958839809', '1909785338784514048', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 09:48:20', '2025-04-09 13:54:58', '2025-04-09 13:55:15', NULL, NULL, '4200002686202504094056795850', '1909785338808983554', NULL);
INSERT INTO `order_info` VALUES ('1909786875585191938', '0', '2025-04-09 09:54:08', '2025-04-09 09:54:07', '1907278202958839809', '1909786875548139520', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 09:54:53', '2025-04-09 13:54:06', '2025-04-09 13:54:22', NULL, NULL, '4200002698202504097268188162', '1909786875576803329', NULL);
INSERT INTO `order_info` VALUES ('1909787108289372163', '0', '2025-04-09 09:55:03', '2025-04-09 09:55:03', '1907278202958839809', '1909787108281679872', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 09:55:21', '2025-04-09 13:49:38', '2025-04-09 13:52:19', NULL, NULL, '4200002711202504096686523641', '1909787108289372162', NULL);
INSERT INTO `order_info` VALUES ('1909787615628189697', '0', '2025-04-09 09:57:04', '2025-04-09 09:57:04', '1907278202958839809', '1909787615595331584', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909787615619801090', NULL);
INSERT INTO `order_info` VALUES ('1909787659500609538', '0', '2025-04-09 09:57:15', '2025-04-09 09:57:14', '1907278202958839809', '1909787659467751424', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909787659496415233', NULL);
INSERT INTO `order_info` VALUES ('1909787723182727169', '0', '2025-04-09 09:57:30', '2025-04-09 09:57:30', '1907278202958839809', '1909787723149869056', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909787723174338561', NULL);
INSERT INTO `order_info` VALUES ('1909787789817634818', '0', '2025-04-09 09:57:46', '2025-04-09 09:57:45', '1907278202958839809', '1909787789788971008', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909787789813440514', NULL);
INSERT INTO `order_info` VALUES ('1909788402357985281', '0', '2025-04-09 10:00:12', '2025-04-09 10:00:11', '1907278202958839809', '1909788402320932864', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909788402349596673', NULL);
INSERT INTO `order_info` VALUES ('1909788462323949570', '0', '2025-04-09 10:00:26', '2025-04-09 10:00:26', '1907278202958839809', '1909788462295285760', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909788462315560962', NULL);
INSERT INTO `order_info` VALUES ('1909788600450768898', '0', '2025-04-09 10:00:59', '2025-04-09 10:00:59', '1907278202958839809', '1909788600417910784', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 10:01:14', '2025-04-09 13:22:19', '2025-04-09 13:39:19', NULL, NULL, '4200002676202504091569583798', '1909788600446574594', NULL);
INSERT INTO `order_info` VALUES ('1909795012060995585', '0', '2025-04-09 10:26:28', '2025-04-09 10:26:27', '1907300228113170433', '1909795012032331776', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909795012056801282', NULL);
INSERT INTO `order_info` VALUES ('1909795453993836546', '0', '2025-04-09 10:28:13', '2025-04-09 10:28:13', '1907300228113170433', '1909795453965172736', '2', '0', '方框男生镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909795453989642242', NULL);
INSERT INTO `order_info` VALUES ('1909808979487547394', '0', '2025-04-09 11:21:58', '2025-04-09 11:21:57', '1907300228113170433', '1909808979429556224', '2', '0', '星耀黑银', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909808979487547393', NULL);
INSERT INTO `order_info` VALUES ('1909833404836515841', '0', '2025-04-09 12:59:01', '2025-04-09 12:59:01', '1907278202958839809', '1909833403990016000', '2', '0', '金色', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909833404203175937', NULL);
INSERT INTO `order_info` VALUES ('1909855580075626497', '0', '2025-04-09 14:27:08', '2025-04-09 14:27:08', '1907278202958839809', '1909855580021850112', '2', '1', '军达-冰蓝色镜框', '5', 0.00, 0.02, 0.02, '2025-04-09 14:27:18', '2025-04-09 14:28:10', '2025-04-09 14:28:22', NULL, NULL, '4200002631202504098714567216', '1909855580046266370', NULL);
INSERT INTO `order_info` VALUES ('1909895314843947010', '0', '2025-04-09 17:05:02', '2025-04-09 17:05:01', '1907278202958839809', '1909895314014208000', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, '', NULL, '1909895314218995713', NULL);
INSERT INTO `order_info` VALUES ('1909900840394870786', '0', '2025-04-09 17:26:59', '2025-04-09 17:26:59', '1907278202958839809', '1909900840357855232', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1909900840390676482', NULL);
INSERT INTO `order_info` VALUES ('1909900926017392642', '0', '2025-04-09 17:27:20', '2025-04-09 17:27:19', '1907278202958839809', '1909900925959405568', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.02, 0.02, NULL, NULL, NULL, NULL, NULL, NULL, '1909900926009004033', NULL);
INSERT INTO `order_info` VALUES ('1909903067750649859', '0', '2025-04-09 17:35:50', '2025-04-09 17:35:50', '1907278202958839809', '1909903067713634304', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.01, 0.01, '2025-04-09 17:35:58', '2025-04-09 17:36:28', '2025-04-09 17:36:39', NULL, NULL, '4200002672202504094073277424', '1909903067750649858', NULL);
INSERT INTO `order_info` VALUES ('1910136255261495298', '0', '2025-04-10 09:02:27', '2025-04-10 09:02:26', '1910132627566022658', '1910136255199313920', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.02, 0.02, NULL, NULL, NULL, NULL, NULL, NULL, '1910136255253106689', NULL);
INSERT INTO `order_info` VALUES ('1910137141643759618', '0', '2025-04-10 09:05:58', '2025-04-10 09:05:57', '1910132627566022658', '1910137141564801024', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.02, 0.02, NULL, NULL, NULL, NULL, NULL, NULL, '1910137141639565313', NULL);
INSERT INTO `order_info` VALUES ('1910137346141245442', '0', '2025-04-10 09:06:47', '2025-04-10 09:06:46', '1910132627566022658', '1910137346041315328', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.05, 0.05, NULL, NULL, NULL, NULL, NULL, NULL, '1910137346137051137', NULL);
INSERT INTO `order_info` VALUES ('1910159377826066434', '0', '2025-04-10 10:34:19', '2025-04-10 10:34:19', '1907278202958839809', '1910159377747148800', '2', '1', '军达-冰蓝色镜框', '2', 0.00, 0.01, 0.01, '2025-04-10 10:41:29', '2025-04-13 09:05:32', NULL, NULL, NULL, '4200002679202504103431093068', '1910159377826066433', NULL);
INSERT INTO `order_info` VALUES ('1910195232242528257', '0', '2025-04-10 12:56:48', '2025-04-10 12:56:47', '1910132627566022658', '1910195231299469312', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.03, 0.03, NULL, NULL, NULL, NULL, NULL, NULL, '1910195231621771266', NULL);
INSERT INTO `order_info` VALUES ('1910198873116450817', '0', '2025-04-10 13:11:16', '2025-04-10 13:11:15', '1910132627566022658', '1910198872181833728', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910198872252424193', NULL);
INSERT INTO `order_info` VALUES ('1910199595979579393', '0', '2025-04-10 13:14:08', '2025-04-10 13:14:08', '1907278202958839809', '1910199595925766144', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910199595966996482', NULL);
INSERT INTO `order_info` VALUES ('1910211045791948801', '0', '2025-04-10 13:59:38', '2025-04-10 13:59:37', '1907278202958839809', '1910211045012537344', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910211045158608897', NULL);
INSERT INTO `order_info` VALUES ('1910215993258729474', '0', '2025-04-10 14:19:18', '2025-04-10 14:19:17', '1907278202958839809', '1910215993217515520', '2', '0', '金色', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910215993250340866', NULL);
INSERT INTO `order_info` VALUES ('1910227636529205250', '0', '2025-04-10 15:05:33', '2025-04-10 15:05:33', '1910132627566022658', '1910227635686866944', '2', '0', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910227635774230530', NULL);
INSERT INTO `order_info` VALUES ('1910241347767750658', '0', '2025-04-10 16:00:03', '2025-04-10 16:00:02', '1910240925996929026', '1910241347701309440', '2', '1', '蔡司', '3', 0.00, 0.02, 0.02, '2025-04-10 16:00:17', '2025-04-10 16:01:10', '2025-04-10 16:01:35', NULL, NULL, '4200002688202504108161903377', '1910241347767750657', NULL);
INSERT INTO `order_info` VALUES ('1910244440274227201', '0', '2025-04-10 16:12:20', '2025-04-10 16:12:19', '1910132627566022658', '1910244440211980288', '2', '1', '军达-冰蓝色镜框', '3', 0.00, 0.02, 0.02, '2025-04-10 16:12:32', '2025-04-10 16:12:55', '2025-04-10 16:13:10', NULL, NULL, '4200002670202504104578377547', '1910244440261644289', NULL);
INSERT INTO `order_info` VALUES ('1910264316111998977', '0', '2025-04-10 17:31:19', '2025-04-10 17:31:18', '1907278202958839809', '1910264316058140672', '2', '0', '优雅精致纯钛架', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910264316099416066', NULL);
INSERT INTO `order_info` VALUES ('1910296232953499651', '0', '2025-04-10 19:38:08', '2025-04-10 19:38:08', '1910132627566022658', '1910296232941584384', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.02, 0.02, NULL, NULL, NULL, NULL, NULL, NULL, '1910296232953499650', NULL);
INSERT INTO `order_info` VALUES ('1910492258448560130', '0', '2025-04-11 08:37:04', '2025-04-11 08:37:04', '1907278202958839809', '1910492258440839168', '2', '0', '金色', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910492258448560129', NULL);
INSERT INTO `order_info` VALUES ('1910495149527781379', '0', '2025-04-11 08:48:34', '2025-04-11 08:48:33', '1907278202958839809', '1910495149515866112', '2', '0', '金色', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1910495149527781378', NULL);
INSERT INTO `order_info` VALUES ('1911253766967152642', '0', '2025-04-13 11:03:02', '2025-04-13 11:03:02', '1907278202958839809', '1911253766905004032', '2', '0', '简约椭圆', NULL, 0.00, 0.01, 0.01, NULL, NULL, NULL, NULL, NULL, NULL, '1911253766941986818', NULL);
INSERT INTO `order_info` VALUES ('1911289364826312705', '0', '2025-04-13 13:24:29', '2025-04-13 13:24:29', '1910132627566022658', '1911289364789329920', '2', '1', '金色', '5', 0.00, 0.01, 0.01, '2025-04-13 13:24:36', '2025-04-13 13:25:21', '2025-04-13 13:25:48', NULL, NULL, '4200002620202504131278005317', '1911289364813729793', NULL);
INSERT INTO `order_info` VALUES ('1911289865781399554', '0', '2025-04-13 13:26:29', '2025-04-13 13:26:28', '1910132627566022658', '1911289865736028160', '2', '1', '军达-冰蓝色镜框', '5', 0.00, 0.02, 0.02, '2025-04-13 13:26:39', '2025-04-13 13:27:27', '2025-04-13 13:27:42', NULL, NULL, '4200002676202504132418863205', '1911289865773010945', NULL);
INSERT INTO `order_info` VALUES ('1911290482100817922', '0', '2025-04-13 13:28:56', '2025-04-13 13:28:55', '1910132627566022658', '1911290482068029440', '2', '1', '金色', '5', 0.00, 0.01, 0.01, '2025-04-13 13:29:02', '2025-04-13 13:29:42', '2025-04-13 13:29:48', NULL, NULL, '4200002627202504139401870405', '1911290482096623617', NULL);
INSERT INTO `order_info` VALUES ('1911290970108088321', '0', '2025-04-13 13:30:52', '2025-04-13 13:30:52', '1907278202958839809', '1911290970075299840', '2', '1', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, '2025-04-13 13:31:03', '2025-04-13 13:31:30', '2025-04-13 13:31:41', NULL, NULL, '4200002671202504132864283598', '1911290970099699714', NULL);
INSERT INTO `order_info` VALUES ('1911291366809554946', '0', '2025-04-13 13:32:27', '2025-04-13 13:32:26', '1907278202958839809', '1911291366759989248', '2', '1', '金色', '1', 0.00, 0.01, 0.01, '2025-04-13 13:32:37', NULL, NULL, NULL, NULL, '4200002705202504135824942294', '1911291366801166338', NULL);
INSERT INTO `order_info` VALUES ('1911294114305167362', '0', '2025-04-13 13:43:22', '2025-04-13 13:43:21', '1907278202958839809', '1911294114276573184', '2', '1', '金色', '1', 0.00, 0.01, 0.01, '2025-04-13 13:43:36', NULL, NULL, NULL, NULL, '4200002671202504138611603719', '1911294114296778753', NULL);
INSERT INTO `order_info` VALUES ('1912392808375021570', '0', '2025-04-16 14:29:11', '2025-04-16 14:29:10', '1912392421513392129', '1912392808300281856', '2', '0', '军达-冰蓝色镜框', NULL, 0.00, 0.02, 0.02, NULL, NULL, NULL, NULL, NULL, NULL, '1912392808366632962', NULL);
INSERT INTO `order_info` VALUES ('1914997890295898114', '0', '2025-04-23 19:00:51', '2025-04-23 19:00:50', '1910132627566022658', '1914997890195914752', '2', '1', '军达-冰蓝色镜框', '5', 0.00, 0.01, 0.01, '2025-04-23 19:01:06', '2025-04-23 19:02:40', '2025-04-23 19:03:18', NULL, NULL, '4200002625202504230411747807', '1914997890253955074', NULL);

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `order_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '订单编号',
  `spu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '商品Id',
  `spu_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '商品名',
  `pic_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '图片',
  `quantity` int NOT NULL COMMENT '商品数量',
  `sales_price` decimal(10, 2) NOT NULL COMMENT '购买单价',
  `freight_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '运费金额',
  `payment_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付金额（购买单价*商品数量+运费金额）',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  `status` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '状态0：正常；1：退款中；2:拒绝退款；3：同意退款',
  `is_refund` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '是否退款0:否 1：是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '订单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES ('1354469716075237378', '0', '2021-01-28 00:41:59', '2021-01-28 00:41:59', '1354469715404148737', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 4999.00, 0.00, 4999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354474071088238594', '0', '2021-01-28 00:59:18', '2021-01-28 00:59:18', '1354474070446510081', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 4999.00, 0.00, 4999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354620400435253249', '0', '2021-01-28 10:40:45', '2021-01-28 10:40:45', '1354620399822884865', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 4999.00, 0.00, 4999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354795348378370049', '0', '2021-01-28 22:15:55', '2021-01-28 22:15:55', '1354795347837304834', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 4999.00, 0.00, 4999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354797186527883265', '0', '2021-01-28 22:23:14', '2021-01-28 22:23:14', '1354797185856794625', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 4999.00, 0.00, 4999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354797795180060673', '0', '2021-01-28 22:25:39', '2021-01-28 22:25:39', '1354797794534137858', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 4999.00, 0.00, 4999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354798824613257217', '0', '2021-01-28 22:29:44', '2021-01-28 22:29:44', '1354798824059609090', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1354798971694915585', '0', '2021-01-28 22:30:19', '2021-01-28 22:30:19', '1354798971141267457', '1353738731164561410', 'iPhone12白色', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1355417351444508674', '0', '2021-01-30 15:27:33', '2021-01-30 15:27:33', '1355417350676951041', '1355412081553190914', '【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/aed00a45-1598-490d-9ea9-b35c386ae6b3.png', 2, 0.10, 0.00, 0.20, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1355418768758550529', '0', '2021-01-30 15:33:11', '2021-01-30 15:33:11', '1355418768053907457', '1353738731164561410', 'Apple iPhone', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/10952adc-cad0-4c53-8762-9906d1dde220.jpg', 1, 6000.00, 0.00, 6000.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1355418868545236994', '0', '2021-01-30 15:33:35', '2021-01-30 15:33:35', '1355418867987394561', '1355412081553190914', '【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/aed00a45-1598-490d-9ea9-b35c386ae6b3.png', 1, 0.10, 0.00, 0.10, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1355426473221054466', '0', '2021-01-30 16:03:48', '2021-01-30 16:03:48', '1355426472587714562', '1355412081553190914', '【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/aed00a45-1598-490d-9ea9-b35c386ae6b3.png', 1, 0.10, 0.00, 0.10, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1357673550390022145', '0', '2021-02-05 20:52:52', '2021-02-05 20:52:52', '1357673549756682241', '1353738731164561410', 'iPhone 12 Pro', 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-4.png', 1, 8499.00, 0.00, 8499.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1632993114403713025', '0', '2023-03-07 14:34:32', '2023-03-07 14:34:32', '1632993114357575681', '1355412081553190914', 'HUAWEI P40 Pro+', 'https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png', 1, 0.98, 0.00, 0.98, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1632994752065449986', '0', '2023-03-07 14:41:03', '2023-03-07 14:41:03', '1632994752065449985', '1355412081553190914', 'HUAWEI P40 Pro+', 'https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png', 1, 0.10, 0.00, 0.10, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1632995133310963713', '0', '2023-03-07 14:42:34', '2023-03-07 14:42:34', '1632995133256437763', '1355412081553190914', 'HUAWEI P40 Pro+', 'https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png', 1, 0.10, 0.00, 0.10, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1645623820762038274', '0', '2023-04-11 11:04:27', '2023-04-11 11:04:27', '1645623820711706626', '1442505794278191105', 'Apple iPhone 13 Pro', 'https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/132.png', 1, 8999.00, 0.00, 8999.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1645635415768621058', '0', '2023-04-11 11:50:32', '2023-04-11 11:50:32', '1645635415705706497', '1355412081553190914', 'HUAWEI P40 Pro+', 'https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png', 1, 0.10, 0.00, 0.10, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1901559589796089858', '0', '2025-03-17 17:01:50', '2025-03-17 17:01:50', '1901559589749952513', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/03/14/O1CN01ZBFYzw23ffZvicJET_!!2212057487283-0-cib_20250314105135A008.jpg', 1, 15.00, 0.00, 15.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1901559589804478466', '0', '2025-03-17 17:01:50', '2025-03-17 17:01:50', '1901559589749952513', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/03/14/O1CN01a248j423ffZy7Wy5R_!!2212057487283-0-cib_20250314094937A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909241965253562370', '0', '2025-04-07 21:48:51', '2025-04-07 21:48:51', '1909241965190647810', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 20.00, 30.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909246795497934849', '0', '2025-04-07 22:08:02', '2025-04-07 22:08:02', '1909246795489546241', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909248649837481985', '0', '2025-04-07 22:15:24', '2025-04-07 22:15:24', '1909248649824899074', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909403939916550146', '0', '2025-04-08 08:32:28', '2025-04-08 08:32:28', '1909403939903967234', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909407615217373185', '0', '2025-04-08 08:47:05', '2025-04-08 08:47:05', '1909407615208984578', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909412235348086786', '0', '2025-04-08 09:05:26', '2025-04-08 09:05:26', '1909412235268395010', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909412914334601217', '0', '2025-04-08 09:08:08', '2025-04-08 09:08:08', '1909412914326212610', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909415386285412353', '0', '2025-04-08 09:17:57', '2025-04-08 09:17:57', '1909415386277023745', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909415645191409666', '0', '2025-04-08 09:18:59', '2025-04-08 09:18:59', '1909415645183021058', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 10.00, 0.00, 10.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909416095483498498', '0', '2025-04-08 09:20:47', '2025-04-08 09:20:47', '1909416095475109889', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909416766572138497', '0', '2025-04-08 09:23:27', '2025-04-08 09:23:27', '1909416766563749890', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909416858427396098', '0', '2025-04-08 09:23:48', '2025-04-08 09:23:48', '1909416858419007490', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg', 1, 15.00, 0.00, 15.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909417103794180097', '0', '2025-04-08 09:24:47', '2025-04-08 09:24:47', '1909417103785791490', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909417386410577921', '0', '2025-04-08 09:25:54', '2025-04-08 09:25:54', '1909417386402189313', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909420850146512897', '0', '2025-04-08 09:39:40', '2025-04-08 09:39:40', '1909420850138124289', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909421506601226242', '0', '2025-04-08 09:42:17', '2025-04-08 09:42:17', '1909421506592837633', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909422767274790913', '0', '2025-04-08 09:47:17', '2025-04-08 09:47:17', '1909422767266402306', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909422804146917377', '0', '2025-04-08 09:47:26', '2025-04-08 09:47:26', '1909422804138528770', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg', 1, 15.00, 0.00, 15.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909422943938875394', '0', '2025-04-08 09:47:59', '2025-04-08 09:47:59', '1909422943930486785', '1900382773244932098', '巴黎灰岛', '/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg', 1, 13.00, 0.00, 13.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909423759059914753', '0', '2025-04-08 09:51:14', '2025-04-08 09:51:14', '1909423759051526146', '1900382455924862977', '星耀黑银', '/profile/upload/2025/04/02/2_20250402162503A010.jpg', 1, 13.00, 0.00, 13.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909424048873738241', '0', '2025-04-08 09:52:23', '2025-04-08 09:52:23', '1909424048865349633', '1900382773244932098', '巴黎灰岛', '/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg', 1, 13.00, 0.00, 13.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909427697578467329', '0', '2025-04-08 10:06:53', '2025-04-08 10:06:53', '1909427697490386945', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg', 1, 15.00, 0.00, 15.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909428445636780035', '0', '2025-04-08 10:09:51', '2025-04-08 10:09:51', '1909428445636780034', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg', 1, 15.00, 0.00, 15.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909430786838552577', '0', '2025-04-08 10:19:09', '2025-04-08 10:19:09', '1909430786809192449', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg', 1, 15.00, 0.00, 15.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909433413789810690', '0', '2025-04-08 10:29:36', '2025-04-08 10:29:36', '1909433413735284738', '1900382455924862977', '星耀黑银', '/profile/upload/2025/04/02/2_20250402162503A010.jpg', 1, 13.00, 0.00, 13.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909435201129619458', '0', '2025-04-08 10:36:42', '2025-04-08 10:36:42', '1909435201062510593', '1900382773244932098', '巴黎灰岛', '/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg', 1, 13.00, 0.00, 13.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909450699514912772', '0', '2025-04-08 11:38:17', '2025-04-08 11:38:17', '1909450699514912771', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 11.00, 0.00, 11.00, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909474273625690113', '0', '2025-04-08 13:11:57', '2025-04-08 13:11:57', '1909474273558581251', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909475366413815809', '0', '2025-04-08 13:16:18', '2025-04-08 13:16:18', '1909475366304763905', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909486529109348354', '0', '2025-04-08 14:00:39', '2025-04-08 14:00:39', '1909486529088376834', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909489014951714817', '0', '2025-04-08 14:10:32', '2025-04-08 14:10:32', '1909489014892994561', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909494718433402882', '0', '2025-04-08 14:33:12', '2025-04-08 14:33:12', '1909494718420819970', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909496224838590465', '0', '2025-04-08 14:39:11', '2025-04-08 14:39:11', '1909496224767287297', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909496404417716225', '0', '2025-04-08 14:39:54', '2025-04-08 14:39:54', '1909496404400939010', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909497426477326339', '0', '2025-04-08 14:43:57', '2025-04-08 14:43:57', '1909497426477326338', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909498542267047938', '0', '2025-04-08 14:48:23', '2025-04-08 14:48:23', '1909498542254465026', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909498944274309123', '0', '2025-04-08 14:49:59', '2025-04-08 14:49:59', '1909498944274309122', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909499416121004034', '0', '2025-04-08 14:51:52', '2025-04-08 14:51:52', '1909499415986786306', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909499520164909057', '0', '2025-04-08 14:52:17', '2025-04-08 14:52:17', '1909499520152326146', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909499813413867522', '0', '2025-04-08 14:53:26', '2025-04-08 14:53:26', '1909499813401284610', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909500103953305603', '0', '2025-04-08 14:54:36', '2025-04-08 14:54:36', '1909500103953305602', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909500164334505985', '0', '2025-04-08 14:54:50', '2025-04-08 14:54:50', '1909500164317728770', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909500257099927556', '0', '2025-04-08 14:55:12', '2025-04-08 14:55:12', '1909500257099927555', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909500297105199106', '0', '2025-04-08 14:55:22', '2025-04-08 14:55:22', '1909500297096810498', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909500317808283650', '0', '2025-04-08 14:55:27', '2025-04-08 14:55:27', '1909500317724397571', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909504734573973506', '0', '2025-04-08 15:13:00', '2025-04-08 15:13:00', '1909504734561390594', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909513503374651394', '0', '2025-04-08 15:47:50', '2025-04-08 15:47:50', '1909513503307542530', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909514804175093761', '0', '2025-04-08 15:53:01', '2025-04-08 15:53:01', '1909514804070236161', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909519340256182273', '0', '2025-04-08 16:11:02', '2025-04-08 16:11:02', '1909519340210044929', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909520687072350209', '0', '2025-04-08 16:16:23', '2025-04-08 16:16:23', '1909520686996852738', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909525358717444098', '0', '2025-04-08 16:34:57', '2025-04-08 16:34:57', '1909525358532894721', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909529369818439681', '0', '2025-04-08 16:50:53', '2025-04-08 16:50:53', '1909529369805856769', '1900383473018417154', '全框', '/profile/upload/2025/04/02/O1CN01AVDr61250ZBTE7nQD_!!2209559537464-0-cib_20250402162542A013.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909537018916200449', '0', '2025-04-08 17:21:17', '2025-04-08 17:21:17', '1909537018857480193', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 2, 0.01, 0.00, 0.02, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909537018916200450', '0', '2025-04-08 17:21:17', '2025-04-08 17:21:17', '1909537018857480193', '1900382455924862977', '星耀黑银', '/profile/upload/2025/04/02/2_20250402162503A010.jpg', 2, 0.01, 0.00, 0.02, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909537018916200451', '0', '2025-04-08 17:21:17', '2025-04-08 17:21:17', '1909537018857480193', '1900382773244932098', '巴黎灰岛', '/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909537018916200452', '0', '2025-04-08 17:21:17', '2025-04-08 17:21:17', '1909537018857480193', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909537232104284162', '0', '2025-04-08 17:22:08', '2025-04-08 17:22:08', '1909537232091701250', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909537232104284163', '0', '2025-04-08 17:22:08', '2025-04-08 17:22:08', '1909537232091701250', '1900382455924862977', '星耀黑银', '/profile/upload/2025/04/02/2_20250402162503A010.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909539063157055490', '0', '2025-04-08 17:29:24', '2025-04-08 17:29:24', '1909539063148666881', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909540322949816321', '0', '2025-04-08 17:34:25', '2025-04-08 17:34:25', '1909540322941427713', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909540512003874819', '0', '2025-04-08 17:35:10', '2025-04-08 17:35:10', '1909540512003874818', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909540681512476674', '0', '2025-04-08 17:35:50', '2025-04-08 17:35:50', '1909540681504088065', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909779974680043524', '0', '2025-04-09 09:26:42', '2025-04-09 09:26:42', '1909779974680043523', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909780068686979074', '0', '2025-04-09 09:27:05', '2025-04-09 09:27:05', '1909780068674396162', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909782134645940227', '0', '2025-04-09 09:35:17', '2025-04-09 09:35:17', '1909782134645940226', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909783564568059906', '0', '2025-04-09 09:40:58', '2025-04-09 09:40:58', '1909783564563865601', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909783615403024387', '0', '2025-04-09 09:41:10', '2025-04-09 09:41:10', '1909783615403024386', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909785338821566465', '0', '2025-04-09 09:48:01', '2025-04-09 09:48:01', '1909785338817372162', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909786875585191939', '0', '2025-04-09 09:54:07', '2025-04-09 09:54:07', '1909786875585191938', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909787108289372164', '0', '2025-04-09 09:55:03', '2025-04-09 09:55:03', '1909787108289372163', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909787615632384002', '0', '2025-04-09 09:57:04', '2025-04-09 09:57:04', '1909787615628189697', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909787659508998146', '0', '2025-04-09 09:57:14', '2025-04-09 09:57:14', '1909787659500609538', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909787723191115777', '0', '2025-04-09 09:57:30', '2025-04-09 09:57:30', '1909787723182727169', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909787789830217730', '0', '2025-04-09 09:57:45', '2025-04-09 09:57:45', '1909787789817634818', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909788402366373889', '0', '2025-04-09 10:00:11', '2025-04-09 10:00:11', '1909788402357985281', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909788462323949571', '0', '2025-04-09 10:00:26', '2025-04-09 10:00:26', '1909788462323949570', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909788600454963201', '0', '2025-04-09 10:00:59', '2025-04-09 10:00:59', '1909788600450768898', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '0');
INSERT INTO `order_item` VALUES ('1909795012069384194', '0', '2025-04-09 10:26:27', '2025-04-09 10:26:27', '1909795012060995585', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909795454002225154', '0', '2025-04-09 10:28:13', '2025-04-09 10:28:13', '1909795453993836546', '1900383214020145154', '方框男生镜框', '/profile/upload/2025/04/02/O1CN01aDLmEj250Z4n2wWGK_!!2209559537464-0-cib_20250402162529A012.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909808979546267649', '0', '2025-04-09 11:21:57', '2025-04-09 11:21:57', '1909808979487547394', '1900382455924862977', '星耀黑银', '/profile/upload/2025/04/02/2_20250402162503A010.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909833404882653186', '0', '2025-04-09 12:59:01', '2025-04-09 12:59:01', '1909833404836515841', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909855580084015106', '0', '2025-04-09 14:27:08', '2025-04-09 16:34:15', '1909855580075626497', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1909855580088209410', '0', '2025-04-09 14:27:08', '2025-04-09 16:33:58', '1909855580075626497', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1909895314902667265', '0', '2025-04-09 17:05:01', '2025-04-09 17:05:01', '1909895314843947010', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909900840403259394', '0', '2025-04-09 17:26:59', '2025-04-09 17:26:59', '1909900840394870786', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909900926025781249', '0', '2025-04-09 17:27:19', '2025-04-09 17:27:19', '1909900926017392642', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909900926025781250', '0', '2025-04-09 17:27:19', '2025-04-09 17:27:19', '1909900926017392642', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1909903067750649860', '0', '2025-04-09 17:35:50', '2025-04-09 17:35:50', '1909903067750649859', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '2', '0');
INSERT INTO `order_item` VALUES ('1910136255269883906', '0', '2025-04-10 09:02:26', '2025-04-10 09:02:26', '1910136255261495298', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910136255269883907', '0', '2025-04-10 09:02:26', '2025-04-10 09:02:26', '1910136255261495298', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137141652148225', '0', '2025-04-10 09:05:57', '2025-04-10 09:05:57', '1910137141643759618', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137141652148226', '0', '2025-04-10 09:05:57', '2025-04-10 09:05:57', '1910137141643759618', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137346149634050', '0', '2025-04-10 09:06:46', '2025-04-10 09:06:46', '1910137346141245442', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137346149634051', '0', '2025-04-10 09:06:46', '2025-04-10 09:06:46', '1910137346141245442', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137346149634052', '0', '2025-04-10 09:06:46', '2025-04-10 09:06:46', '1910137346141245442', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137346149634053', '0', '2025-04-10 09:06:46', '2025-04-10 09:06:46', '1910137346141245442', '1900382455924862977', '星耀黑银', '/profile/upload/2025/04/02/2_20250402162503A010.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910137346149634054', '0', '2025-04-10 09:06:46', '2025-04-10 09:06:46', '1910137346141245442', '1900382773244932098', '巴黎灰岛', '/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910159377901563906', '0', '2025-04-10 10:34:19', '2025-04-10 10:34:19', '1910159377826066434', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910195232280276993', '0', '2025-04-10 12:56:47', '2025-04-10 12:56:47', '1910195232242528257', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910195232280276994', '0', '2025-04-10 12:56:47', '2025-04-10 12:56:47', '1910195232242528257', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910195232280276995', '0', '2025-04-10 12:56:47', '2025-04-10 12:56:47', '1910195232242528257', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910198873175171074', '0', '2025-04-10 13:11:15', '2025-04-10 13:11:15', '1910198873116450817', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910199595992162306', '0', '2025-04-10 13:14:08', '2025-04-10 13:14:08', '1910199595979579393', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910211045838086145', '0', '2025-04-10 13:59:37', '2025-04-10 13:59:37', '1910211045791948801', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910215993267118082', '0', '2025-04-10 14:19:17', '2025-04-10 14:19:17', '1910215993258729474', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910227636562759681', '0', '2025-04-10 15:05:33', '2025-04-10 15:05:33', '1910227636529205250', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910241347813888001', '0', '2025-04-10 16:00:02', '2025-04-10 16:00:02', '1910241347767750658', '1910142888230309889', '蔡司', '/profile/upload/2025/04/10/cs1_20250410103456A005.jpg', 2, 0.01, 0.00, 0.02, NULL, '3', '0');
INSERT INTO `order_item` VALUES ('1910244440278421505', '0', '2025-04-10 16:12:19', '2025-04-10 16:12:19', '1910244440274227201', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '1', '0');
INSERT INTO `order_item` VALUES ('1910244440278421506', '0', '2025-04-10 16:12:19', '2025-04-10 16:12:19', '1910244440274227201', '1910142888230309889', '蔡司', '/profile/upload/2025/04/10/cs1_20250410103456A005.jpg', 1, 0.01, 0.00, 0.01, NULL, '1', '0');
INSERT INTO `order_item` VALUES ('1910264316111998978', '0', '2025-04-10 17:31:18', '2025-04-10 17:31:18', '1910264316111998977', '1900379604263710721', '优雅精致纯钛架', '/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910296232953499652', '0', '2025-04-10 19:38:08', '2025-04-10 19:38:08', '1910296232953499651', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910296232953499653', '0', '2025-04-10 19:38:08', '2025-04-10 19:38:08', '1910296232953499651', '1910148048591532034', '明月', '/profile/upload/2025/04/10/明月_20250410102247A003.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910492258448560131', '0', '2025-04-11 08:37:04', '2025-04-11 08:37:04', '1910492258448560130', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1910495149527781380', '0', '2025-04-11 08:48:33', '2025-04-11 08:48:33', '1910495149527781379', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1911253767046844418', '0', '2025-04-13 11:03:02', '2025-04-13 11:03:02', '1911253766967152642', '1900378673224691713', '简约椭圆', '/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1911289364834701313', '0', '2025-04-13 13:24:29', '2025-04-13 13:24:29', '1911289364826312705', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1911289865785593857', '0', '2025-04-13 13:26:28', '2025-04-13 13:26:28', '1911289865781399554', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1911289865789788162', '0', '2025-04-13 13:26:28', '2025-04-13 13:26:28', '1911289865781399554', '1910142888230309889', '蔡司', '/profile/upload/2025/04/10/cs1_20250410103456A005.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1911290482109206529', '0', '2025-04-13 13:28:55', '2025-04-13 13:28:55', '1911290482100817922', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1911290970112282625', '0', '2025-04-13 13:30:52', '2025-04-13 13:30:52', '1911290970108088321', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');
INSERT INTO `order_item` VALUES ('1911291366817943554', '0', '2025-04-13 13:32:26', '2025-04-13 13:32:26', '1911291366809554946', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1911294114313555970', '0', '2025-04-13 13:43:21', '2025-04-13 13:43:21', '1911294114305167362', '1900378351710318593', '金色', '/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1912392808601513985', '0', '2025-04-16 14:29:10', '2025-04-16 14:29:10', '1912392808375021570', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1912392808601513986', '0', '2025-04-16 14:29:10', '2025-04-16 14:29:10', '1912392808375021570', '1910142888230309889', '蔡司', '/profile/upload/2025/04/10/cs1_20250410103456A005.jpg', 1, 0.01, 0.00, 0.01, NULL, '0', '0');
INSERT INTO `order_item` VALUES ('1914997890400755713', '0', '2025-04-23 19:00:50', '2025-04-23 19:00:50', '1914997890295898114', '1900363838747389953', '军达-冰蓝色镜框', '/profile/upload/2025/04/16/bls_20250416185945A029.jpg', 1, 0.01, 0.00, 0.01, NULL, '3', '1');

-- ----------------------------
-- Table structure for order_logistics
-- ----------------------------
DROP TABLE IF EXISTS `order_logistics`;
CREATE TABLE `order_logistics`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `postal_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '邮编',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '收货人名字',
  `tel_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '电话号码',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '详细地址',
  `logistics` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '物流商家',
  `logistics_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '物流单号',
  `status` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '快递单当前状态，包括-1错误，0在途，1揽收，2疑难，3签收，4退签，5派件，6退回，7转投?等7个状态',
  `is_check` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '签收标记（0：未签收；1：已签收）',
  `message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '相关信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '订单物流表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_logistics
-- ----------------------------
INSERT INTO `order_logistics` VALUES ('1354469714800168962', '0', '2021-01-28 00:41:59', '2021-01-28 00:41:59', NULL, '张三', '18602513214', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354474069813170178', '0', '2021-01-28 00:59:17', '2021-01-28 00:59:17', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354620399231488001', '0', '2021-01-28 10:40:45', '2021-01-28 10:40:45', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354795347308822530', '0', '2021-01-28 22:15:55', '2021-01-28 22:15:55', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354797185185705985', '0', '2021-01-28 22:23:13', '2021-01-28 22:23:13', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354797793913380865', '0', '2021-01-28 22:25:38', '2021-01-28 22:25:38', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354798823514349569', '0', '2021-01-28 22:29:44', '2021-01-28 22:29:44', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', 'yunda', '48466513213213165', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1354798970596007937', '0', '2021-01-28 22:30:19', '2021-01-28 22:30:19', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1355417349930364930', '0', '2021-01-30 15:27:33', '2021-01-30 15:27:33', NULL, '张三', '15580802543', '北京市北京市东城区大冲地铁口', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1355418767420567554', '0', '2021-01-30 15:33:11', '2021-01-30 15:33:11', NULL, '张三', '15580802543', '北京市北京市东城区大冲地铁口', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1355418867316305921', '0', '2021-01-30 15:33:35', '2021-01-30 15:33:35', NULL, '张三', '15580802543', '北京市北京市东城区大冲地铁口', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1355426471975346177', '0', '2021-01-30 16:03:48', '2021-01-30 16:03:48', NULL, '张三', '15580802543', '北京市北京市东城区大冲地铁口', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1357673549135925250', '0', '2021-02-05 20:52:52', '2021-02-05 20:52:52', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1632993114324021250', '0', '2023-03-07 14:34:32', '2023-03-07 14:34:32', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1632994752031895553', '0', '2023-03-07 14:41:03', '2023-03-07 14:41:03', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1632995133256437762', '0', '2023-03-07 14:42:34', '2023-03-07 14:42:34', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', 'huitongkuaidi', '566985565255', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1645623820711706625', '0', '2023-04-11 11:04:27', '2023-04-11 11:04:27', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1645635415605043201', '0', '2023-04-11 11:50:32', '2023-04-11 11:50:32', NULL, '张三', '18563265321', '广东省广州市海珠区新港中路397号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1901559589724786690', '0', '2025-03-17 17:01:50', '2025-03-17 17:01:50', NULL, '桂花鱼', '13313124523', '江苏省苏州市昆山市前进中路345号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909241965169676289', '0', '2025-04-07 21:48:51', '2025-04-07 21:48:51', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909246795485351937', '0', '2025-04-07 22:08:02', '2025-04-07 22:08:02', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909248649824899073', '0', '2025-04-07 22:15:24', '2025-04-07 22:15:24', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909403939895578626', '0', '2025-04-08 08:32:28', '2025-04-08 08:32:28', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909407615204790273', '0', '2025-04-08 08:47:05', '2025-04-08 08:47:05', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909412235260006402', '0', '2025-04-08 09:05:26', '2025-04-08 09:05:26', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909412914313629697', '0', '2025-04-08 09:08:08', '2025-04-08 09:08:08', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909415386264440833', '0', '2025-04-08 09:17:57', '2025-04-08 09:17:57', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909415645174632449', '0', '2025-04-08 09:18:59', '2025-04-08 09:18:59', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909416095470915585', '0', '2025-04-08 09:20:47', '2025-04-08 09:20:47', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909416766555361282', '0', '2025-04-08 09:23:27', '2025-04-08 09:23:27', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909416858410618881', '0', '2025-04-08 09:23:48', '2025-04-08 09:23:48', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909417103777402882', '0', '2025-04-08 09:24:47', '2025-04-08 09:24:47', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909417386397995010', '0', '2025-04-08 09:25:54', '2025-04-08 09:25:54', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909420850133929986', '0', '2025-04-08 09:39:40', '2025-04-08 09:39:40', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909421506588643330', '0', '2025-04-08 09:42:17', '2025-04-08 09:42:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909422767262208002', '0', '2025-04-08 09:47:17', '2025-04-08 09:47:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909422804100780034', '0', '2025-04-08 09:47:26', '2025-04-08 09:47:26', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909422943926292481', '0', '2025-04-08 09:47:59', '2025-04-08 09:47:59', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909423759043137537', '0', '2025-04-08 09:51:14', '2025-04-08 09:51:14', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909424048861155330', '0', '2025-04-08 09:52:23', '2025-04-08 09:52:23', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909427696873824257', '0', '2025-04-08 10:06:53', '2025-04-08 10:06:53', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909428445624197122', '0', '2025-04-08 10:09:51', '2025-04-08 10:09:51', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909430786779832322', '0', '2025-04-08 10:19:09', '2025-04-08 10:19:09', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909433413085167618', '0', '2025-04-08 10:29:36', '2025-04-08 10:29:36', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909435200454336514', '0', '2025-04-08 10:36:42', '2025-04-08 10:36:42', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909450699514912770', '0', '2025-04-08 11:38:17', '2025-04-08 11:38:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909474273558581250', '0', '2025-04-08 13:11:57', '2025-04-08 13:11:57', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909475365642063873', '0', '2025-04-08 13:16:18', '2025-04-08 13:16:18', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909486529054822402', '0', '2025-04-08 14:00:39', '2025-04-08 14:00:39', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909489014234488833', '0', '2025-04-08 14:10:32', '2025-04-08 14:10:32', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909494718404042753', '0', '2025-04-08 14:33:12', '2025-04-08 14:33:12', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909496224092004353', '0', '2025-04-08 14:39:11', '2025-04-08 14:39:11', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909496404379967489', '0', '2025-04-08 14:39:54', '2025-04-08 14:39:54', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909497426477326337', '0', '2025-04-08 14:43:57', '2025-04-08 14:43:57', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909498542241882113', '0', '2025-04-08 14:48:23', '2025-04-08 14:48:23', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909498944274309121', '0', '2025-04-08 14:49:59', '2025-04-08 14:49:59', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909499415227617281', '0', '2025-04-08 14:51:52', '2025-04-08 14:51:52', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909499520135548929', '0', '2025-04-08 14:52:17', '2025-04-08 14:52:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909499813392896002', '0', '2025-04-08 14:53:26', '2025-04-08 14:53:26', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909500103936528385', '0', '2025-04-08 14:54:36', '2025-04-08 14:54:36', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909500164305145858', '0', '2025-04-08 14:54:50', '2025-04-08 14:54:50', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909500257099927554', '0', '2025-04-08 14:55:12', '2025-04-08 14:55:12', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909500297084227585', '0', '2025-04-08 14:55:22', '2025-04-08 14:55:22', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909500317724397570', '0', '2025-04-08 14:55:27', '2025-04-08 14:55:27', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909504734536224769', '0', '2025-04-08 15:13:00', '2025-04-08 15:13:00', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909513502690979842', '0', '2025-04-08 15:47:50', '2025-04-08 15:47:50', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909514803415924737', '0', '2025-04-08 15:53:01', '2025-04-08 15:53:01', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909519339568316417', '0', '2025-04-08 16:11:02', '2025-04-08 16:11:02', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909520686392872961', '0', '2025-04-08 16:16:23', '2025-04-08 16:16:23', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909525357522067457', '0', '2025-04-08 16:34:57', '2025-04-08 16:34:57', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', 'dasda', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909529369793273857', '0', '2025-04-08 16:50:53', '2025-04-08 16:50:53', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909537018232528897', '0', '2025-04-08 17:21:17', '2025-04-08 17:21:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909537232079118338', '0', '2025-04-08 17:22:08', '2025-04-08 17:22:08', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909539063131889666', '0', '2025-04-08 17:29:24', '2025-04-11 13:00:02', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'huitongkuaidi', 'YT8736186768458', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909540322933039105', '0', '2025-04-08 17:34:25', '2025-04-08 17:34:25', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909540511999680513', '0', '2025-04-08 17:35:10', '2025-04-08 17:35:10', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909540681491505154', '0', '2025-04-08 17:35:50', '2025-04-08 17:35:50', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909779974680043522', '0', '2025-04-09 09:26:42', '2025-04-09 09:26:42', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909780068674396161', '0', '2025-04-09 09:27:05', '2025-04-09 09:27:05', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '6666666666', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909782134637551618', '0', '2025-04-09 09:35:17', '2025-04-09 09:35:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '6666666666', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909783564555476993', '0', '2025-04-09 09:40:58', '2025-04-09 09:40:58', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909783615394635778', '0', '2025-04-09 09:41:10', '2025-04-09 09:41:10', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '555555', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909785338808983554', '0', '2025-04-09 09:48:01', '2025-04-09 09:48:01', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '44444444', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909786875576803329', '0', '2025-04-09 09:54:07', '2025-04-09 09:54:07', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '333333333', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909787108289372162', '0', '2025-04-09 09:55:03', '2025-04-09 09:55:03', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '2222222222222', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909787615619801090', '0', '2025-04-09 09:57:04', '2025-04-09 09:57:04', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909787659496415233', '0', '2025-04-09 09:57:14', '2025-04-09 09:57:14', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909787723174338561', '0', '2025-04-09 09:57:30', '2025-04-09 09:57:30', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909787789813440514', '0', '2025-04-09 09:57:45', '2025-04-09 09:57:45', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909788402349596673', '0', '2025-04-09 10:00:11', '2025-04-09 10:00:11', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909788462315560962', '0', '2025-04-09 10:00:26', '2025-04-09 10:00:26', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909788600446574594', '0', '2025-04-09 10:00:59', '2025-04-09 10:00:59', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '11111111111111111111111111111', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909795012056801282', '0', '2025-04-09 10:26:27', '2025-04-09 10:26:27', NULL, '规划风格化', '18333333333', '北京市北京市东城区234325', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909795453989642242', '0', '2025-04-09 10:28:13', '2025-04-09 10:28:13', NULL, '规划风格化', '18333333333', '北京市北京市东城区234325', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909808979487547393', '0', '2025-04-09 11:21:57', '2025-04-09 11:21:57', NULL, '规划风格化', '18333333333', '北京市北京市东城区234325', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909833404203175937', '0', '2025-04-09 12:59:01', '2025-04-09 12:59:01', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909855580046266370', '0', '2025-04-09 14:27:08', '2025-04-09 14:27:08', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '6666666666', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909895314218995713', '0', '2025-04-09 17:05:01', '2025-04-09 17:05:01', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909900840390676482', '0', '2025-04-09 17:26:59', '2025-04-09 17:26:59', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909900926009004033', '0', '2025-04-09 17:27:19', '2025-04-09 17:27:19', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1909903067750649858', '0', '2025-04-09 17:35:50', '2025-04-09 17:35:50', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '123', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910136255253106689', '0', '2025-04-10 09:02:26', '2025-04-10 09:02:26', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910137141639565313', '0', '2025-04-10 09:05:57', '2025-04-10 09:05:57', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910137346137051137', '0', '2025-04-10 09:06:46', '2025-04-10 09:06:46', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910159377826066433', '0', '2025-04-10 10:34:19', '2025-04-10 10:34:19', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '1111223543535346', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910195231621771266', '0', '2025-04-10 12:56:47', '2025-04-10 12:56:47', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910198872252424193', '0', '2025-04-10 13:11:15', '2025-04-10 13:11:15', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910199595966996482', '0', '2025-04-10 13:14:08', '2025-04-10 13:14:08', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910211045158608897', '0', '2025-04-10 13:59:37', '2025-04-10 13:59:37', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910215993250340866', '0', '2025-04-10 14:19:17', '2025-04-10 14:19:17', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910227635774230530', '0', '2025-04-10 15:05:33', '2025-04-10 15:05:33', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910241347767750657', '0', '2025-04-10 16:00:02', '2025-04-10 16:00:02', NULL, 'zhang', '1', '天津市市辖区河东区dd', 'tiantian', '123', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910244440261644289', '0', '2025-04-10 16:12:19', '2025-04-10 16:12:19', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', 'tiantian', '123512', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910264316099416066', '0', '2025-04-10 17:31:18', '2025-04-10 17:31:18', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910296232953499650', '0', '2025-04-10 19:38:08', '2025-04-10 19:38:08', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910492258448560129', '0', '2025-04-11 08:37:04', '2025-04-11 08:37:04', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1910495149527781378', '0', '2025-04-11 08:48:33', '2025-04-11 08:48:33', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911253766941986818', '0', '2025-04-13 11:03:02', '2025-04-13 11:03:02', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911289364813729793', '0', '2025-04-13 13:24:29', '2025-04-13 13:24:29', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', 'yunda', '464300338874911', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911289865773010945', '0', '2025-04-13 13:26:28', '2025-04-13 13:26:28', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', 'yunda', '464300338874911', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911290482096623617', '0', '2025-04-13 13:28:55', '2025-04-13 13:28:55', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', 'yunda', '464300338874911', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911290970099699714', '0', '2025-04-13 13:30:51', '2025-04-13 13:30:51', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', 'tiantian', '123141151', '1', NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911291366801166338', '0', '2025-04-13 13:32:26', '2025-04-13 13:32:26', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1911294114296778753', '0', '2025-04-13 13:43:21', '2025-04-13 13:43:21', NULL, '张1', '18336336761', '天津市市辖区和平区啊实打实大苏打实打实的', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1912392808366632962', '0', '2025-04-16 14:29:10', '2025-04-16 14:29:10', NULL, '桂花园', '1325683560', '北京市市辖区东城区荷花池', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `order_logistics` VALUES ('1914997890253955074', '0', '2025-04-23 19:00:50', '2025-04-23 19:00:50', NULL, '桂花鱼', '132325232745', '江苏省苏州市昆山市杨树路555号', 'huitongkuaidi', '23456', '1', NULL, NULL);

-- ----------------------------
-- Table structure for order_logistics_info
-- ----------------------------
DROP TABLE IF EXISTS `order_logistics_info`;
CREATE TABLE `order_logistics_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `logistics_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '物流id',
  `status` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '物流状态 1在途中，2派件中，3已签收，4派送失败，5揽收，6退回，7转单，8疑难，9退签，10待清关，11清关中，12已清关，13清关异常',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '物流名称',
  `com` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '快递公司代码',
  `number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '快递单号',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '快递公司logo',
  `list` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '快递信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '物流信息查询表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_logistics_info
-- ----------------------------
INSERT INTO `order_logistics_info` VALUES (1, 'YT8736186768458', '3', '圆通速递', 'yuantong', 'YT8736186768458', 'http://img.lundear.com/yuantong.png', '[{\"time\":\"2025-02-11 17:55:18\",\"status\":\"已签收，签收人凭取货码签收。如有疑问请联系快递员: 18521102536，网点电话：18521803516,0512-81633526，投诉电话: 18521100313。感谢使用圆通速递，期待再次为您服务！\"},{\"time\":\"2025-02-11 13:40:44\",\"status\":\"您好，快件已暂存至昆山珠江御景北门475号店菜鸟驿站，如有疑问请联系18136413727，投诉电话：18521100313。感谢使用圆通速递，期待再次为您服务！\"},{\"time\":\"2025-02-11 07:54:12\",\"status\":\"【江苏省昆山蓬朗】的张兴盛（18521102536）正在派件，（有事先呼我，勿找平台，少一次投诉，多一份感恩）！如有疑问请联系网点:18521803516,0512-81633526，投诉电话:18521100313。[95161和18521号段的上海号码为圆通快递员专属号码，请放心接听]\"},{\"time\":\"2025-02-11 07:54:09\",\"status\":\"您的快件已经到达【江苏省昆山蓬朗】\"},{\"time\":\"2025-02-11 04:02:39\",\"status\":\"您的快件离开【上海转运中心】，已发往【江苏省昆山蓬朗】\"},{\"time\":\"2025-02-11 03:32:36\",\"status\":\"您的快件已经到达【上海转运中心】\"},{\"time\":\"2025-02-09 22:41:05\",\"status\":\"您的快件离开【深圳转运中心】，已发往【上海转运中心】。预计【02月11日】到达【上海市】，因运输距离较远，预计将在【11日晚上】为您更新快件状态，请您放心！\"},{\"time\":\"2025-02-09 22:39:56\",\"status\":\"您的快件已经到达【深圳转运中心】\"},{\"time\":\"2025-02-09 21:43:54\",\"status\":\"您的快件离开【广东省深圳市龙岗区平湖】，已发往【深圳转运中心】\"},{\"time\":\"2025-02-08 08:07:09\",\"status\":\"您的快件在【广东省深圳市龙岗区平湖】已揽收，揽收人: 王小明（15691613295）\"}]');
INSERT INTO `order_logistics_info` VALUES (2, '1111223543535346', NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户编号',
  `spu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '商品SPU',
  `quantity` int NOT NULL COMMENT '数量',
  `spu_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '加入时的spu名字',
  `add_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '加入时价格',
  `pic_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------
INSERT INTO `shopping_cart` VALUES ('1353755369452634114', '0', '2021-01-26 01:23:26', '2021-01-26 01:29:11', '1352233320682930178', '1353738731164561410', 1, 'iPhone12白色', 4999.00, NULL);
INSERT INTO `shopping_cart` VALUES ('1354094384559210498', '0', '2021-01-26 23:50:33', '2021-01-26 23:50:33', '1352572935968165889', '1353738731164561410', 1, 'iPhone12白色', 4999.00, 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png');
INSERT INTO `shopping_cart` VALUES ('1355427342960320514', '0', '2021-01-30 16:07:16', '2021-01-30 16:07:16', '1355406809988345857', '1353738731164561410', 1, 'Apple iPhone', 6000.00, 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/10952adc-cad0-4c53-8762-9906d1dde220.jpg');
INSERT INTO `shopping_cart` VALUES ('1357249438573252609', '0', '2021-02-04 16:47:37', '2021-02-04 16:47:37', '1356171782972882945', '1355440649314263041', 1, 'HUAWEI Mate 40 Pro+', 8999.00, 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-5.png');
INSERT INTO `shopping_cart` VALUES ('1357249497834573826', '0', '2021-02-04 16:47:51', '2021-02-04 16:47:51', '1356171782972882945', '1355412081553190914', 1, 'HUAWEI P40 Pro+', 0.10, 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-7.png');
INSERT INTO `shopping_cart` VALUES ('1357673715054202882', '0', '2021-02-05 20:53:31', '2021-02-05 20:53:31', '1354473059078176770', '1353738731164561410', 1, 'iPhone 12 Pro', 8499.00, 'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-4.png');

-- ----------------------------
-- Table structure for spu_try_on_img_url
-- ----------------------------
DROP TABLE IF EXISTS `spu_try_on_img_url`;
CREATE TABLE `spu_try_on_img_url`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片地址',
  `goods_spu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '商品SPU ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_goods_spu_id`(`goods_spu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品试戴图片表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of spu_try_on_img_url
-- ----------------------------
INSERT INTO `spu_try_on_img_url` VALUES (1, '/profile/upload/2025/04/07/bls_20250407111523A002.jpg', '1900363838747389953', '2025-04-10 14:17:25', '2025-04-10 14:17:25', '0');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-09-11 09:31:32', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-09-11 09:31:32', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-09-11 09:31:32', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-09-11 09:31:32', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-09-11 09:31:32', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-09-11 09:31:32', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-09-11 09:31:30', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, '进口', '1', 'spu_tag_type', NULL, 'default', 'N', '0', 'admin', '2025-03-19 09:29:58', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 2, '国产', '2', 'spu_tag_type', NULL, 'default', 'N', '0', 'admin', '2025-03-19 09:30:11', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 13, '半框', '13', 'spu_tag_type', NULL, 'default', 'N', '0', 'admin', '2025-03-19 09:30:32', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (103, 12, '全框', '12', 'spu_tag_type', NULL, 'default', 'N', '0', 'admin', '2025-03-19 09:30:52', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-09-11 09:31:32', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '商品标签', 'spu_tag_type', '0', 'admin', '2025-03-19 09:29:34', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-09-11 09:31:32', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-09-11 09:31:32', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-09-11 09:31:32', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 147 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-09-11 09:36:42');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-09-11 10:06:16');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-09-11 10:19:10');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-09-11 15:58:28');
INSERT INTO `sys_logininfor` VALUES (104, 'test', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2024-09-11 16:13:48');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-09-11 16:14:04');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-09-11 16:23:14');
INSERT INTO `sys_logininfor` VALUES (107, 'test', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-12 13:12:57');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-12 13:13:11');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-12 13:13:22');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-12 13:14:23');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-14 09:41:46');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-14 11:48:26');
INSERT INTO `sys_logininfor` VALUES (113, 'test', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-03-14 13:24:16');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-14 13:24:35');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-14 14:11:26');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-14 15:44:20');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-17 13:56:09');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-17 14:01:56');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-17 14:02:06');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-17 14:02:25');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-18 16:22:47');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-19 09:06:03');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-19 10:05:05');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-19 10:33:47');
INSERT INTO `sys_logininfor` VALUES (125, 'test', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-19 10:53:25');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-19 10:53:42');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-19 12:53:14');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-19 13:18:51');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-19 13:19:00');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-19 13:19:12');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-19 15:29:11');
INSERT INTO `sys_logininfor` VALUES (132, 'test', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '1', '用户不存在/密码错误', '2025-03-19 15:59:10');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-19 15:59:19');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-19 17:03:12');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-21 11:03:28');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '192.168.0.69', '内网IP', 'Chrome 13', 'Mac OS X', '0', '登录成功', '2025-03-21 11:12:18');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-24 14:18:24');
INSERT INTO `sys_logininfor` VALUES (138, 'test', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-03-24 15:13:38');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-24 15:13:47');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-24 15:24:15');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-24 16:00:32');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-03-27 10:57:21');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-03-27 10:57:25');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-03-27 10:57:29');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '192.168.0.35', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-03-27 10:57:38');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2025-04-13 14:07:13');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2060 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-09-11 09:31:31', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-09-11 09:31:31', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-09-11 09:31:31', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '公众号管理', 0, 4, 'wxmp', NULL, '', '', 1, 0, 'M', '0', '0', '', 'wechat', 'admin', '2024-09-11 09:31:31', 'admin', '2025-03-14 13:36:08', '公众号管理');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-09-11 09:31:31', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-09-11 09:31:31', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-09-11 09:31:31', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-09-11 09:31:31', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-09-11 09:31:31', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-09-11 09:31:31', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-09-11 09:31:31', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-09-11 09:31:31', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-09-11 09:31:31', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-09-11 09:31:31', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-09-11 09:31:31', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-09-11 09:31:31', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-09-11 09:31:31', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-09-11 09:31:31', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-09-11 09:31:31', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-09-11 09:31:31', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-09-11 09:31:31', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-09-11 09:31:31', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-09-11 09:31:31', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-09-11 09:31:31', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '用户标签', 4, 10, 'wxusertags', 'wxmp/wxusertags/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxusertags:list', 'tab', 'admin', '2020-03-03 10:47:36', 'admin', '2020-03-03 20:17:50', '');
INSERT INTO `sys_menu` VALUES (2001, '修改标签', 2000, 10, '', NULL, NULL, '', 1, 0, 'F', '1', '0', 'wxmp:wxusertags:edit', '#', 'admin', '2020-03-03 11:16:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2002, '公众号用户', 4, 20, 'wxuser', 'wxmp/wxuser/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxuser:index', 'peoples', 'admin', '2020-03-04 10:13:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '用户消息', 4, 30, 'wxmsg', 'wxmp/wxmsg/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxmsg:index', 'clipboard', 'admin', '2020-03-04 10:15:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '素材管理', 4, 40, 'wxmaterial', 'wxmp/wxmaterial/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxmaterial:index', 'example', 'admin', '2020-03-04 10:17:21', 'admin', '2020-03-05 21:31:33', '');
INSERT INTO `sys_menu` VALUES (2005, '自定义菜单', 4, 50, 'wxmenu', 'wxmp/wxmenu/detail', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxmenu:get', 'cascader', 'admin', '2020-03-04 10:18:02', 'admin', '2020-03-04 10:29:20', '');
INSERT INTO `sys_menu` VALUES (2006, '消息自动回复', 4, 60, 'wxautoreply', 'wxmp/wxautoreply/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxautoreply:index', 'dashboard', 'admin', '2020-03-04 10:18:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '数据统计', 4, 70, 'wxsummary', 'wxmp/wxsummary/index', NULL, '', 1, 0, 'C', '0', '0', NULL, 'druid', 'admin', '2020-03-04 10:19:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '用户标签删除', 2000, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxusertags:del', '#', 'admin', '2020-03-04 17:08:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '用户标签新增', 2000, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxusertags:add', '#', 'admin', '2020-03-04 17:08:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '公众号用户新增', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:add', '#', 'admin', '2020-03-04 17:15:01', 'admin', '2020-03-04 17:16:59', '');
INSERT INTO `sys_menu` VALUES (2011, '公众号用户修改', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:edit', '#', 'admin', '2020-03-04 17:16:17', 'admin', '2020-03-04 17:17:09', '');
INSERT INTO `sys_menu` VALUES (2012, '公众号用户打标签', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:tagging', '#', 'admin', '2020-03-04 17:16:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '公众号用户备注修改', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:edit:remark', '#', 'admin', '2020-03-04 17:17:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '公众号用户同步', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:synchro', '#', 'admin', '2020-03-04 17:18:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '公众号用户删除', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:del', '#', 'admin', '2020-03-04 17:18:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '公众号用户详情', 2002, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:get', '#', 'admin', '2020-03-04 17:18:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '用户消息新增', 2003, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmsg:add', '#', 'admin', '2020-03-04 17:19:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '用户消息修改', 2003, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmsg:edit', '#', 'admin', '2020-03-04 17:19:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2019, '用户消息删除', 2003, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmsg:del', '#', 'admin', '2020-03-04 17:20:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '用户消息详情', 2003, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmsg:get', '#', 'admin', '2020-03-04 17:20:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '素材新增', 2004, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmaterial:add', '#', 'admin', '2020-03-04 17:20:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '素材修改', 2004, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmaterial:edit', '#', 'admin', '2020-03-04 17:21:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '素材删除', 2004, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmaterial:del', '#', 'admin', '2020-03-04 17:21:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '素材详情', 2004, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmaterial:get', '#', 'admin', '2020-03-04 17:21:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, '自定义菜单发布', 2005, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxmenu:add', '#', 'admin', '2020-03-04 17:22:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '消息自动回复新增', 2006, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxautoreply:add', '#', 'admin', '2020-03-04 17:22:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '消息自动回复修改', 2006, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxautoreply:edit', '#', 'admin', '2020-03-04 17:23:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '消息自动回复删除', 2006, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxautoreply:del', '#', 'admin', '2020-03-04 17:23:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '消息自动回复详情', 2006, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxautoreply:get', '#', 'admin', '2020-03-04 17:23:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '商城管理', 0, 5, 'mall', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'shopping', 'admin', '2021-01-21 17:44:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '商品分类', 2033, 10, 'goodscategory', 'mall/goodscategory/index', NULL, '', 1, 0, 'C', '0', '0', 'mall:goodscategory:index', 'build', 'admin', '2021-01-21 17:47:43', 'admin', '2021-01-21 17:48:30', '');
INSERT INTO `sys_menu` VALUES (2035, '商品类目查询', 2034, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodscategory:get', '#', 'admin', '2021-01-21 17:48:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '新增商品类目', 2034, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodscategory:add', '#', 'admin', '2021-01-21 17:48:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '修改商品类目', 2034, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodscategory:edit', '#', 'admin', '2021-01-21 17:49:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '删除商品类目', 2034, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodscategory:del', '#', 'admin', '2021-01-21 17:49:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '商品管理', 2033, 10, 'goodsspu', 'mall/goodsspu/index', NULL, '', 1, 0, 'C', '0', '0', 'mall:goodsspu:index', 'shopping', 'admin', '2021-01-25 22:10:44', 'admin', '2021-01-25 22:12:13', '');
INSERT INTO `sys_menu` VALUES (2040, '商品查询', 2039, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodsspu:get', '#', 'admin', '2021-01-25 22:13:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '新增商品', 2039, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodsspu:add', '#', 'admin', '2021-01-25 22:14:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '修改商品', 2039, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodsspu:edit', '#', 'admin', '2021-01-25 22:15:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '删除商品', 2039, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:goodsspu:del', '#', 'admin', '2021-01-25 22:15:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '订单管理', 2033, 10, 'orderinfo', 'mall/orderinfo/index', NULL, '', 1, 0, 'C', '0', '0', 'mall:orderinfo:index', 'list', 'admin', '2021-01-27 00:07:14', 'admin', '2021-01-27 00:07:45', '');
INSERT INTO `sys_menu` VALUES (2045, '订单查询', 2044, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:orderinfo:get', '#', 'admin', '2021-01-27 00:08:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '商城订单修改', 2044, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:orderinfo:edit', '#', 'admin', '2021-01-28 22:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '商城订单新增', 2044, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:orderinfo:add', '#', 'admin', '2021-01-28 22:39:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '商城订单删除', 2044, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'mall:orderinfo:del', '#', 'admin', '2021-01-28 22:39:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2049, '小程序管理', 0, 6, 'wxma', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'phone', 'admin', '2021-01-28 23:45:03', 'admin', '2025-03-14 10:55:47', '');
INSERT INTO `sys_menu` VALUES (2050, '小程序用户', 2049, 10, 'wxuser-ma', 'wxma/wxuser/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxuser:index', 'peoples', 'admin', '2021-01-28 23:54:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '小程序用户查询', 2050, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxuser:get', '#', 'admin', '2021-01-28 23:57:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '草稿箱', 4, 44, 'wxdraft', 'wxmp/wxdraft/index', NULL, '', 1, 0, 'C', '0', '0', '	 wxmp:wxdraft:index', 'guide', 'admin', '2022-03-29 14:48:47', 'admin', '2022-03-29 14:51:31', '');
INSERT INTO `sys_menu` VALUES (2053, '新增草稿箱', 2052, 0, '', NULL, NULL, '', 1, 0, 'F', '1', '0', 'wxmp:wxdraft:add', '#', 'admin', '2022-03-29 14:50:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '修改草稿箱', 2052, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxdraft:edit', '#', 'admin', '2022-03-29 14:50:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2055, '删除草稿箱', 2052, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxdraft:del', '#', 'admin', '2022-03-29 14:50:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '发布草稿', 2052, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxdraft:publish', '#', 'admin', '2022-03-29 14:51:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '已发布', 4, 46, 'wxfreepublish', 'wxmp/wxfreepublish/index', NULL, '', 1, 0, 'C', '0', '0', 'wxmp:wxfreepublish:index', 'clipboard', 'admin', '2022-03-29 14:52:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '删除已发布', 2058, 0, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'wxmp:wxfreepublish:del', '#', 'admin', '2022-03-29 14:52:57', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2024-09-11 09:31:32', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2024-09-11 09:31:32', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 2, 'com.joolun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-09-11 09:31:31\",\"icon\":\"wechat\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公众号管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"wxmp\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-14 10:55:18', 43);
INSERT INTO `sys_oper_log` VALUES (101, '菜单管理', 2, 'com.joolun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2021-01-28 23:45:03\",\"icon\":\"phone\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"小程序管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"wxma\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-14 10:55:47', 21);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 2, 'com.joolun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-09-11 09:31:31\",\"icon\":\"wechat\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公众号管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"wxmp\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-14 13:36:08', 33);
INSERT INTO `sys_oper_log` VALUES (103, '用户头像', 2, 'com.joolun.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/03/17/avatar_20250317150205A001.png\",\"code\":200}', 0, NULL, '2025-03-17 15:02:05', 239);
INSERT INTO `sys_oper_log` VALUES (104, '字典类型', 1, 'com.joolun.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"商品标签\",\"dictType\":\"spu_tag_type\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 09:29:34', 18);
INSERT INTO `sys_oper_log` VALUES (105, '字典数据', 1, 'com.joolun.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"进口\",\"dictSort\":1,\"dictType\":\"spu_tag_type\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 09:29:58', 14);
INSERT INTO `sys_oper_log` VALUES (106, '字典数据', 1, 'com.joolun.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"国产\",\"dictSort\":2,\"dictType\":\"spu_tag_type\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 09:30:11', 13);
INSERT INTO `sys_oper_log` VALUES (107, '字典数据', 1, 'com.joolun.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"半框\",\"dictSort\":13,\"dictType\":\"spu_tag_type\",\"dictValue\":\"13\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 09:30:32', 21);
INSERT INTO `sys_oper_log` VALUES (108, '字典数据', 1, 'com.joolun.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"全框\",\"dictSort\":12,\"dictType\":\"spu_tag_type\",\"dictValue\":\"12\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 09:30:52', 12);
INSERT INTO `sys_oper_log` VALUES (109, '字典类型', 9, 'com.joolun.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '192.168.0.69', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 10:50:11', 36);
INSERT INTO `sys_oper_log` VALUES (110, '代码生成', 6, 'com.joolun.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"goods_spu\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-03-19 14:31:10', 150);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2024-09-11 09:31:31', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2024-09-11 09:31:31', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-09-11 09:31:31', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-09-11 09:31:31', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '/profile/avatar/2025/03/17/avatar_20250317150205A001.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-04-13 14:07:13', 'admin', '2024-09-11 09:31:31', '', '2025-04-13 14:07:12', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-09-11 09:31:31', 'admin', '2024-09-11 09:31:31', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- Table structure for try_on_glass_img_url
-- ----------------------------
DROP TABLE IF EXISTS `try_on_glass_img_url`;
CREATE TABLE `try_on_glass_img_url`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `wx_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信用户ID',
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片地址',
  `goods_spu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品SPU ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '试戴眼镜图片地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of try_on_glass_img_url
-- ----------------------------

-- ----------------------------
-- Table structure for try_optometry
-- ----------------------------
DROP TABLE IF EXISTS `try_optometry`;
CREATE TABLE `try_optometry`  (
  `try_optometry_id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `results_id` bigint NULL DEFAULT NULL COMMENT '视图验光id',
  `left_right_eyes` int NULL DEFAULT NULL COMMENT '左右眼睛（0左，1右）',
  `spherical_mirror` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '球镜',
  `cylindrical_mirror` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '柱镜',
  `position_of_axis` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '轴位',
  `addend` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ADD',
  PRIMARY KEY (`try_optometry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '试戴验光表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of try_optometry
-- ----------------------------

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户编号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '收货人名字',
  `postal_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '邮编',
  `province_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '省名',
  `city_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '市名',
  `county_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '区名',
  `detail_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '详情地址',
  `tel_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '电话号码',
  `is_default` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '是否默认 1是0否',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '用户地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_address
-- ----------------------------
INSERT INTO `user_address` VALUES ('1354441894547988481', '0', '2021-01-27 22:51:26', '2021-01-27 22:51:26', '1352168072700571649', '张三', NULL, '广东省', '广州市', '海珠区', '新港中路397号', '18602513214', '1');
INSERT INTO `user_address` VALUES ('1354474056307511297', '0', '2021-01-28 00:59:14', '2021-01-28 00:59:14', '1354473059078176770', '张三', NULL, '广东省', '广州市', '海珠区', '新港中路397号', '18563265321', '1');
INSERT INTO `user_address` VALUES ('1355417330850476033', '0', '2021-01-30 15:27:29', '2021-01-30 15:27:29', '1355406809988345857', '张三', NULL, '北京市', '北京市', '东城区', '大冲地铁口', '15580802543', '1');
INSERT INTO `user_address` VALUES ('1901559553876070402', '0', '2025-03-17 17:01:41', '2025-03-17 17:01:41', '1900425114278260738', '桂花鱼', NULL, '江苏省', '苏州市', '昆山市', '前进中路345号', '13313124523', NULL);
INSERT INTO `user_address` VALUES ('1909168328773275650', '0', '2025-04-07 16:56:14', '2025-04-08 11:39:08', '1907278202958839809', '张1', NULL, '天津市', '市辖区', '和平区', '啊实打实大苏打实打实的', '18336336761', '1');
INSERT INTO `user_address` VALUES ('1909233132762370049', '0', '2025-04-07 21:13:45', '2025-04-08 11:39:08', '1907278202958839809', '哪吒', NULL, '河北省', '石家庄市', '长安区', '工人路429号', '15711281598', '0');
INSERT INTO `user_address` VALUES ('1909794902082150401', '0', '2025-04-09 10:26:01', '2025-04-09 10:26:01', '1907300228113170433', '规划风格化', NULL, '北京市', '北京市', '东城区', '234325', '18333333333', '1');
INSERT INTO `user_address` VALUES ('1910136218544558082', '0', '2025-04-10 09:02:17', '2025-04-10 09:02:17', '1910132627566022658', '桂花鱼', NULL, '江苏省', '苏州市', '昆山市', '杨树路555号', '132325232745', '1');
INSERT INTO `user_address` VALUES ('1910241229412880386', '0', '2025-04-10 15:59:34', '2025-04-10 15:59:36', '1910240925996929026', 'zhang', NULL, '天津市', '市辖区', '河东区', 'dd', '1', '1');

-- ----------------------------
-- Table structure for vision_test_results
-- ----------------------------
DROP TABLE IF EXISTS `vision_test_results`;
CREATE TABLE `vision_test_results`  (
  `results_id` int NOT NULL AUTO_INCREMENT,
  `optometry_records_id` bigint NULL DEFAULT NULL COMMENT '验光记录ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `ww4points` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '沃氏4点',
  `stereo_view` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '立体观',
  `vgf_bi` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '隐斜（远）BI',
  `vgf_bu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '隐斜（远）BU',
  `pnif_bi_1` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（远）BI1',
  `pnif_bi_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（远）BI2',
  `pnif_bi_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（远）BI3',
  `pnif_bu_1` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（远）BU1',
  `pnif_bu_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（远）BU2',
  `pnif_bu_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（远）BU3',
  `vgn_bi` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '隐斜（近）BI',
  `vgn_bu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '隐斜（近）BU',
  `aca` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '梯度法',
  `pnin_bi_1` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（近）BI1',
  `pnin_bi_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（近）BI2',
  `pnin_bi_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（近）BI3',
  `pnin_bu_1` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（近）BU1',
  `pnin_bu_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（近）BU2',
  `pnin_bu_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正负融像（近）BU3',
  `nra` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负相对调节NRA',
  `bcc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '调节反应BCC',
  `pra` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正相对调节PRA',
  `reverse_beat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '反转拍',
  `visual_chart` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视力表',
  `binoculus` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '双眼',
  `left_eye` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '左眼',
  `right_eye` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '右眼',
  `diagnosis_name` bigint NULL DEFAULT NULL COMMENT '诊断名称',
  `diagnosis_abnormal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '诊断异常名称',
  `rests` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其他',
  `sugggestions` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '建议方案',
  PRIMARY KEY (`results_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '视图验光数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vision_test_results
-- ----------------------------

-- ----------------------------
-- Table structure for wx_auto_reply
-- ----------------------------
DROP TABLE IF EXISTS `wx_auto_reply`;
CREATE TABLE `wx_auto_reply`  (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '主键',
  `create_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注',
  `del_flag` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `type` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '类型（1、关注时回复；2、消息回复；3、关键词回复）',
  `req_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '关键词',
  `req_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '请求消息类型（text：文本；image：图片；voice：语音；video：视频；shortvideo：小视频；location：地理位置）',
  `rep_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复消息类型（text：文本；image：图片；voice：语音；video：视频；music：音乐；news：图文）',
  `rep_mate` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复类型文本匹配类型（1、全匹配，2、半匹配）',
  `rep_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL COMMENT '回复类型文本保存文字',
  `rep_media_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复类型imge、voice、news、video的mediaID或音乐缩略图的媒体id',
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复的素材名、视频和音乐的标题',
  `rep_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '视频和音乐的描述',
  `rep_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '链接',
  `rep_hq_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '高质量链接',
  `rep_thumb_media_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '缩略图的媒体id',
  `rep_thumb_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '缩略图url',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL COMMENT '图文消息的内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '微信自动回复' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wx_auto_reply
-- ----------------------------

-- ----------------------------
-- Table structure for wx_menu
-- ----------------------------
DROP TABLE IF EXISTS `wx_menu`;
CREATE TABLE `wx_menu`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '菜单ID（click、scancode_push、scancode_waitmsg、pic_sysphoto、pic_photo_or_album、pic_weixin、location_select：保存key）',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort` int NULL DEFAULT 1 COMMENT '排序值',
  `parent_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '父菜单ID',
  `type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '菜单类型click、view、miniprogram、scancode_push、scancode_waitmsg、pic_sysphoto、pic_photo_or_album、pic_weixin、location_select、media_id、view_limited等',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '菜单名',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'view、miniprogram保存链接',
  `ma_app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '小程序的appid',
  `ma_page_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '小程序的页面路径',
  `rep_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复消息类型（text：文本；image：图片；voice：语音；video：视频；music：音乐；news：图文）',
  `rep_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL COMMENT 'Text:保存文字',
  `rep_media_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'imge、voice、news、video：mediaID',
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '素材名、视频和音乐的标题',
  `rep_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '视频和音乐的描述',
  `rep_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '链接',
  `rep_hq_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '高质量链接',
  `rep_thumb_media_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '缩略图的媒体id',
  `rep_thumb_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '缩略图url',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL COMMENT '图文消息的内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '自定义菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wx_menu
-- ----------------------------

-- ----------------------------
-- Table structure for wx_msg
-- ----------------------------
DROP TABLE IF EXISTS `wx_msg`;
CREATE TABLE `wx_msg`  (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '主键',
  `create_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注',
  `del_flag` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `app_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '公众号名称',
  `app_logo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '公众号logo',
  `wx_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '微信用户ID',
  `nick_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '微信用户昵称',
  `headimg_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '微信用户头像',
  `type` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '消息分类（1、用户发给公众号；2、公众号发给用户；）',
  `rep_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '消息类型（text：文本；image：图片；voice：语音；video：视频；shortvideo：小视频；location：地理位置；music：音乐；news：图文；event：推送事件）',
  `rep_event` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '事件类型（subscribe：关注；unsubscribe：取关；CLICK、VIEW：菜单事件）',
  `rep_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL COMMENT '回复类型文本保存文字、地理位置信息',
  `rep_media_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复类型imge、voice、news、video的mediaID或音乐缩略图的媒体id',
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '回复的素材名、视频和音乐的标题',
  `rep_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '视频和音乐的描述',
  `rep_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '链接',
  `rep_hq_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '高质量链接',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL COMMENT '图文消息的内容',
  `rep_thumb_media_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '缩略图的媒体id',
  `rep_thumb_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '缩略图url',
  `rep_location_x` double NULL DEFAULT NULL COMMENT '地理位置维度',
  `rep_location_y` double NULL DEFAULT NULL COMMENT '地理位置经度',
  `rep_scale` double NULL DEFAULT NULL COMMENT '地图缩放大小',
  `read_flag` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '1' COMMENT '已读标记（1：是；0：否）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '微信消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wx_msg
-- ----------------------------
INSERT INTO `wx_msg` VALUES ('1632267995913953281', NULL, '2023-03-05 14:33:11', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'subscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632272703470731266', NULL, '2023-03-05 14:51:53', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'unsubscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632272808005369857', NULL, '2023-03-05 14:52:18', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'subscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632272917996797954', NULL, '2023-03-05 14:52:44', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'unsubscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632272989350297601', NULL, '2023-03-05 14:53:01', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'subscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632273483217068033', NULL, '2023-03-05 14:54:59', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'unsubscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632273535528427521', NULL, '2023-03-05 14:55:12', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'event', 'subscribe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632273641581404162', NULL, '2023-03-05 14:55:37', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'text', NULL, '小鲜肉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632273658178265090', NULL, '2023-03-05 14:55:41', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'text', NULL, '的', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632273702734356482', NULL, '2023-03-05 14:55:52', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'image', NULL, NULL, 'eRUJFkjKKJcKu_vvI-uXy6eMNbSS-ftq1a_JB6M0BAAcvHK6VA0UpVc1IG-_csAI', NULL, NULL, 'http://mmbiz.qpic.cn/mmbiz_jpg/5X3iagjL72nicRx8gcY0hZT2wepsfvTDxYicF0xY2KkEfNKje4mGbvDXXbOWVs1cukF6GDLcS3aXSwAZTIGuOTyVg/0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `wx_msg` VALUES ('1632878647481229313', NULL, '2023-03-07 06:59:42', NULL, NULL, NULL, '0', NULL, NULL, '1632267995788124162', NULL, NULL, '1', 'text', NULL, '提交', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');

-- ----------------------------
-- Table structure for wx_user
-- ----------------------------
DROP TABLE IF EXISTS `wx_user`;
CREATE TABLE `wx_user`  (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '主键',
  `create_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '用户备注',
  `del_flag` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `app_type` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '应用类型(1:小程序，2:公众号)',
  `subscribe` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '是否订阅（1：是；0：否；2：网页授权用户）',
  `subscribe_scene` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '返回用户关注的渠道来源，ADD_SCENE_SEARCH 公众号搜索，ADD_SCENE_ACCOUNT_MIGRATION 公众号迁移，ADD_SCENE_PROFILE_CARD 名片分享，ADD_SCENE_QR_CODE 扫描二维码，ADD_SCENEPROFILE LINK 图文页内名称点击，ADD_SCENE_PROFILE_ITEM 图文页右上角菜单，ADD_SCENE_PAID 支付后关注，ADD_SCENE_OTHERS 其他',
  `subscribe_time` datetime NULL DEFAULT NULL COMMENT '关注时间',
  `subscribe_num` int NULL DEFAULT NULL COMMENT '关注次数',
  `cancel_subscribe_time` datetime NULL DEFAULT NULL COMMENT '取消关注时间',
  `open_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户标识',
  `nick_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '昵称',
  `sex` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '性别（1：男，2：女，0：未知）',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '所在城市',
  `country` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '所在国家',
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '所在省份',
  `phone` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `language` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '用户语言',
  `headimg_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '头像',
  `union_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT 'union_id',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '用户组',
  `tagid_list` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '标签列表',
  `qr_scene_str` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NULL DEFAULT NULL COMMENT '二维码扫码场景',
  `latitude` double NULL DEFAULT NULL COMMENT '地理位置纬度',
  `longitude` double NULL DEFAULT NULL COMMENT '地理位置经度',
  `precision` double NULL DEFAULT NULL COMMENT '地理位置精度',
  `session_key` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '会话密钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`open_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_croatian_ci COMMENT = '微信用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wx_user
-- ----------------------------
INSERT INTO `wx_user` VALUES ('1352168072700571649', NULL, '2021-01-21 16:16:05', NULL, '2021-01-21 16:37:22', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'ol3ea5DyEplVd0B5lD9gLwCme8zw', 'JL', '1', '深圳', '中国', '广东', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKRsdzV55M85n8DAsVhH7wrS05ficLFjQMLlZUdUichYqZKKCB2GyibRGJNZ3JvPzVWg5hVVRx9hACEw/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'CNKq11a69WSezik2aobqsA==');
INSERT INTO `wx_user` VALUES ('1352233320682930178', NULL, '2021-01-21 20:35:21', NULL, '2021-01-21 21:16:01', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'ol3ea5HBFdkSYTC4uzf9gvW3cutU', 'NULL', '1', '长沙', '中国', '湖南', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/chMqczIChvg1AXBmBran0EzkD4f52jKEpRFmIweBDN1QpeC4JPN5HKE3fgUYFNAFN4warrIQhEj69SCkY2zyYA/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'jSa/lKtJmYPVHZcTl7r5kw==');
INSERT INTO `wx_user` VALUES ('1352572935968165889', NULL, '2021-01-22 19:04:52', NULL, '2021-01-22 19:05:20', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'ol3ea5HWkzS2_iL2nBoao-nsxlgI', 'Ethan.D', '1', '益阳', '中国', '湖南', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/5DPIvtrqFPv2hcU09UmW3fGQXzIwmO8iciajsHNTzz1NrlwBeVm5ou8HCaO7kXIDmVwhoqnicIibI4BXf8GlKFN7YA/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'G87A8PJ+HeqJzeVxW/tYpA==');
INSERT INTO `wx_user` VALUES ('1354473059078176770', NULL, '2021-01-28 00:55:16', NULL, '2021-01-28 00:55:23', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'oJ-q55T2ZXs-p68eMcouJR7IFVQw', 'JL', '1', '深圳', '中国', '广东', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJru7MZse3ErXMMsSSQ3rcrBoESJN5F9p7xibr1u54DaGv3NGb6Z9tSTsJ07VsYCBFW7GWkQhIJc2A/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'WlJiMoAA/VZs0wI33kieFw==');
INSERT INTO `wx_user` VALUES ('1355406809988345857', NULL, '2021-01-30 14:45:40', NULL, '2021-01-30 14:50:37', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'oJ-q55eVbz74-EiU2f-j1Rie_BwM', 'NULL', '1', '长沙', '中国', '湖南', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/cuTB5LL4dia7CJLqAxV2ibE8OiawFCcF4yRduugIxZTnJBmye7wddrErqShW1JkmXgYibDSKgib2cicURicLaPPknGGjw/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'YM7Jk6qAfQ3yr8jNNbj2ww==');
INSERT INTO `wx_user` VALUES ('1356171782972882945', NULL, '2021-02-01 17:25:25', NULL, '2021-02-02 22:44:21', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'oJ-q55a_buCs7ozlJOBHYgm6b_ko', 'Ethan.D', '1', '益阳', '中国', '湖南', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/XdqjFObB4mmxQMURhIr5XzUgicRic3qOuXhz74OQnmHg4wKf5NUSm11ib0rXBsaIsJxGjicz1AY3a2Pz46iacqibfNqg/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'oknUXi+2mvSjisq3vyGrtw==');
INSERT INTO `wx_user` VALUES ('1357673320701546498', NULL, '2021-02-05 20:51:57', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-01-06 14:14:44', 1, NULL, 'o3QwG1QnY-BOe4M724t0dvVQaUUo', '魂散', '0', '', '', '', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/PiajxSqBRaEK4NgUCJLPziclZYMfTnaYFXvz1GajlxariavaOkbKsXzXMoVHO6E5LKUWaaxxQccLVaicYR2Zqv5ZnA/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320701546499', NULL, '2021-02-05 20:51:57', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-10-29 23:34:34', 1, NULL, 'o3QwG1YepdGeVJZv_2bfIEjwnb_I', '愈辉', '1', '', '亚美尼亚', '', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/lV0d907m3OWXHibcSriareU9XpBCdBgkOd286EialAX0BtrWEdrhunepPEUq82E6wneLbtNttjKDMJSM7Y9HOnaRA/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320714129409', NULL, '2021-02-05 20:51:57', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-11-09 11:36:47', 1, NULL, 'o3QwG1ThD7gJ-qIXTDF88rly1VHg', '八爪鱼', '1', '', '中国', '北京', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/lV0d907m3OW2BkZicF01PtUQera34FdW1Ga68DhZxQ7MlGMLDG3DZIBMm2Cibjueb6NMDvRMMRZFqjMVEogD9Oibw/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320722518017', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-12-05 16:04:40', 1, NULL, 'o3QwG1ZP0s_alsf-PuhDU7CmLQ24', '十万伏特', '1', '成都', '中国', '四川', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/J6c32680OdZUtzqT9zvNO2QR8jG1jdPiaFFQVA91Szrnpke0ga7UCCXGTKqZIppyibuhv6NTRX3OXqPtSQey8Ww0qgzhqicUgGR/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320730906626', NULL, '2021-02-05 20:51:58', NULL, NULL, '备注', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2021-01-23 11:54:59', 1, NULL, 'o3QwG1Z4EZBdLwtKbK9TozDunLZw', 'Allen', '1', '成都', '中国', '四川', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/OT05QvwvgZZ3KeIaQ25CrjHF9rQTpZhO4RM1szUEcUdfLjEcFoicD3snicPq8GIqiayc1Ned8CIY5Gk5kCInF4TrR07Isicn4gFS/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320739295234', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2021-01-18 14:27:13', 1, NULL, 'o3QwG1UuAz7VYM24e9rmihxyKJvg', 'JL', '1', '深圳', '中国', '广东', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/dMKNvxZfIaEco8NogUXngnPhXrEEzLoY69XP5ymS2RWFIyXpOGE8trxiaqydnIibicluloYMWO06qmmibuvZR6GEbYR1HmVCq41R/132', NULL, '{}', '[107,2]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320747683841', NULL, '2021-02-05 20:51:58', NULL, NULL, '99', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2021-01-11 17:43:37', 1, NULL, 'o3QwG1XWOtVl_ifcXYbPuiaPPnMc', 'redis', '1', '', '中国', '', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/lV0d907m3OU18kicFJhIBibV0XlvEnWzKN09tvVz3wyryA2cysGibW8BarSLyia8HeuOx8YDibGE192BibXG1xTtfC2nXf0x3MZS1x/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320747683842', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-03-16 10:32:31', 1, NULL, 'o3QwG1ecy727RcaP3XyevHbPK33M', '、', '1', '厦门', '中国', '福建', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/OT05QvwvgZYuck1R4BqYzwFzicuAicDHSeJTKI21VvxgrUxEWnVxiaEseEVLnM2tzibxTIfUiaZ1aSLn4hJ8FSgu7EBgeID2LCh9s/132', NULL, '{}', '[2]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320747683843', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-11-09 20:41:24', 1, NULL, 'o3QwG1RLqJDTP-KZfNxMrMOKpl1U', 'gameover!!!', '1', '武汉', '中国', '湖北', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/upjJ1bex0ocf0rsbPbSW6yorFpT2SicGibyia5bYRjqLpWDgnYR4icEtQ87TcDibO3qujm8wkhDib4CPQCldShq1FHovW9J2ibSsfFH/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320747683844', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-10-14 14:32:49', 1, NULL, 'o3QwG1f7sT5V_FV_EVj4kaQ09Zzs', '壹杯淸茶。', '1', '青岛', '中国', '山东', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/ajNVdqHZLLCYmmGPrvvXcib0iaiaGQba4yFtwt35zEUgOAzGwPcwG2GIqmejmo8fxRibwQzSDibejrXV4dia1uiaanvXrZ3SKZyZiaEo3G2K8WhDTjs/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320756072449', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-02-24 16:49:28', 1, NULL, 'o3QwG1eaqyTxxW4VisfbaKL0BcWY', '.Llkoi', '1', '长沙', '中国', '湖南', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/TBfgdHR2VFWloL25J3r1DfDE3a5R3yctJD3wc5CSoe3xWmy4lZPzxRZpj2x14dl87ndzlRXAN1ZN2W7w1n8bYtKWOMxG8ahq/132', NULL, '{}', '[2]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320760266753', NULL, '2021-02-05 20:51:58', NULL, NULL, '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2020-06-17 22:14:41', 1, NULL, 'o3QwG1d4Bq8lg-NbUOOYdaaVWhnE', 'Quentin', '1', '南京', '中国', '江苏', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/ceebSkrkkFTBe1cSDicrLGq05uMsfRkzNWhKp3JY6eISxwCoiagt6q2L4RGcGh61jnWWTI3xeXsAmFCEpozdSIDQKBhNosic8TY/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1357673320760266754', NULL, '2021-02-05 20:51:58', NULL, NULL, '后来', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2019-06-04 22:22:21', 1, NULL, 'o3QwG1aKxN5AMEaNSbDV-vHJHtvM', '安安晨晨', '2', '益阳', '中国', '湖南', NULL, 'zh_CN', 'http://thirdwx.qlogo.cn/mmopen/ceebSkrkkFTRWgtVgYzPOETJtkqz0TIOzpVber8ic5DlUTky6zpgTGJHic6gG4wH7B7iay12QHo7BF3Iv0r6vTfS2GkcdywCmN8/132', NULL, '{}', '[]', '1', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1632267995788124162', NULL, '2023-03-05 14:33:10', NULL, '2023-03-05 14:51:53', '', '0', '2', '1', 'ADD_SCENE_QR_CODE', '2023-03-05 14:55:09', 4, '2023-03-05 14:54:59', 'obe_Pt4Ot_pap7RZwkVAfqBDoAQM', NULL, NULL, NULL, NULL, NULL, NULL, 'zh_CN', NULL, NULL, '{}', '[]', 'jl-wiki:1677999301202', NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1900425114278260738', NULL, '2025-03-14 13:53:50', NULL, '2025-03-17 16:59:43', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'oPXd06wSf5K8mW_h5uJsUsxU55sk', '   ', '0', '', '', '', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/z770JtevmV1aHqKmiaYwcicqaXR0e32ywqMKuFBfWg6rauFNeiaYLGEdBAosZx119SZcOSibbmImQQzOoCEMoax24LV88Iict1reHibibyXS6jh0zM/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, '3ydRrXSYaEnG8PVt9/yp7w==');
INSERT INTO `wx_user` VALUES ('1907278202958839809', NULL, '2025-04-02 11:45:33', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, 'o_2jP6zd9W79TNucHkuemFrpFaPg', '这个网速只能', '0', NULL, NULL, NULL, NULL, NULL, 'https://thirdwx.qlogo.cn/mmopen/vi_32/hh0DgEGDicETFV15NcqXB0fHa4PSyfDMAb3tgkpsqpc8JhDRVo50sia87DhL2NRUaictGSBcNibY9ncbAic9icayEBZxQUu5OeqWhgr9lZ1otoGs4/132', 'oKmXP6xeGKe2c9mYyYWwIPImtuAc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1907300228113170433', NULL, '2025-04-02 13:13:04', NULL, '2025-04-02 13:20:22', NULL, '0', '1', NULL, NULL, NULL, NULL, NULL, 'o3h6g7TOi2Pd0NnroMdXwvXK4oqM', '这个网速只能', '0', '', '', '', NULL, 'zh_CN', 'https://thirdwx.qlogo.cn/mmopen/vi_32/dr34H3hOMVuictiacGsIISbUc91bHdNvCelIvqqhDAddE64zNSMRI90XfMaXlmchTcHNx3KZPChwby2p5xs3sBeEtRjBIy2hJu3h8iaqvkY5d0/132', NULL, NULL, '[]', NULL, NULL, NULL, NULL, 'TbiMnu17lL4rdpCPEi8mRQ==');
INSERT INTO `wx_user` VALUES ('1910127473236168705', NULL, '2025-04-10 08:27:32', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, 'o_2jP6-KR1YgkNg_Kw2cJgDcQq3M', '锅巴肉片', '0', NULL, NULL, NULL, NULL, NULL, 'https://thirdwx.qlogo.cn/mmopen/vi_32/JzIRs07U8G0t0o2USQvoSQkK9gtxDaV3TRMU0HU3nVLbTmZOG0oibKFAIfFNzgzKcZ2wC8Jn8c3tg2rXDZSB8wOnWooEQdxicb2YIubfYsaEE/132', 'oKmXP66EmWw6zXdcfoarzefWDvg8', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1910132627566022658', NULL, '2025-04-10 08:48:01', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, 'o_2jP6wtOEF1kqhIWV8miVeiq0N0', '   ', '0', NULL, NULL, NULL, NULL, NULL, 'https://thirdwx.qlogo.cn/mmopen/vi_32/ooZCPFY1xgBfkiacUA4D3DXe4PXZI8OVGnh4NM9Sl7H4c9nfy09L2XibjXiaPtCakW0ibkRwZUic0xG4ysEFWQ9BvXICG73f1iaT0mbhKB5yPOGJA/132', 'oKmXP65p7Sg98Kz_PcLNy9I-oBIE', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1910171594734710786', NULL, '2025-04-10 11:22:52', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, 'o_2jP6xp26adYNzgfOBD4S0QQVw8', 'XM小希-13382518118', '0', NULL, NULL, NULL, NULL, NULL, 'https://thirdwx.qlogo.cn/mmopen/vi_32/9mjKN9eFKKGu8vibticCZJzrjz65aMxj4n98z5xGy2QCGicpHXBXGt7CpC8N8OLWr2Vg5Jj1cLGibHrClA9xEVQAk168Mw1c7QwVNsYIdk6KUuA/132', 'oKmXP66VFdLU5eAMTX3VH-Zziv88', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `wx_user` VALUES ('1910240925996929026', NULL, '2025-04-10 15:58:21', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, 'o_2jP6wA5zbhkCRTjq7g6x7kBiSA', '张翔', '0', NULL, NULL, NULL, NULL, NULL, 'https://thirdwx.qlogo.cn/mmopen/vi_32/lPOXDTOLtvzWHXsCKSY0CBj2RNAnBiajLNNZ2gsUyvj42v2ibkYNibHwybB37BjqibjIsbImRJnib1f4Dz5ibE1gS1xc1swdmpMELxHgW8WYy6v5M/132', 'oKmXP631Avt6f4EiAb7xki5D9Chk', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
