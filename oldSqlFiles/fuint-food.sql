/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : fuint-food

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 14/04/2026 11:02:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for mt_address
-- ----------------------------
DROP TABLE IF EXISTS `mt_address`;
CREATE TABLE `mt_address`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '用户ID',
  `NAME` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `MOBILE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '收货手机号',
  `PROVINCE_ID` int UNSIGNED NULL DEFAULT 0 COMMENT '省份ID',
  `CITY_ID` int UNSIGNED NULL DEFAULT 0 COMMENT '城市ID',
  `REGION_ID` int NULL DEFAULT 0 COMMENT '区/县ID',
  `DETAIL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '详细地址',
  `IS_DEFAULT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '是否默认',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '会员地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_address
-- ----------------------------

-- ----------------------------
-- Table structure for mt_article
-- ----------------------------
DROP TABLE IF EXISTS `mt_article`;
CREATE TABLE `mt_article`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `STORE_ID` int NOT NULL DEFAULT 0 COMMENT '目录ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '标题',
  `BRIEF` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '简介',
  `URL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '链接地址',
  `IMAGE` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '图片地址',
  `DESCRIPTION` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '描述',
  `CLICK` int NULL DEFAULT 0 COMMENT '点击次数',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后操作人',
  `SORT` int NULL DEFAULT 0 COMMENT '排序',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT 'A：正常；N：禁用；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '文章表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of mt_article
-- ----------------------------

-- ----------------------------
-- Table structure for mt_balance
-- ----------------------------
DROP TABLE IF EXISTS `mt_balance`;
CREATE TABLE `mt_balance`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '所属店铺ID',
  `MOBILE` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '手机号',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '用户ID',
  `ORDER_SN` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '订单号',
  `AMOUNT` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额变化数量',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注说明',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A正常；D作废',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 832 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '余额变化表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_balance
-- ----------------------------

-- ----------------------------
-- Table structure for mt_banner
-- ----------------------------
DROP TABLE IF EXISTS `mt_banner`;
CREATE TABLE `mt_banner`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '标题',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '所属店铺ID',
  `URL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '链接地址',
  `IMAGE` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '图片地址',
  `DESCRIPTION` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '描述',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后操作人',
  `SORT` int NULL DEFAULT 0 COMMENT '排序',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT 'A：正常；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 307 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '会员端焦点图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_banner
-- ----------------------------

-- ----------------------------
-- Table structure for mt_book
-- ----------------------------
DROP TABLE IF EXISTS `mt_book`;
CREATE TABLE `mt_book`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `GOODS_ID` int NULL DEFAULT 0 COMMENT '预约服务ID',
  `SERVICE_DATES` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '可预约日期',
  `SERVICE_TIMES` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '可预约时间段',
  `SERVICE_STAFF_IDS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '可预约员工',
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '预约说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '订单状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '预约表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_book
-- ----------------------------

-- ----------------------------
-- Table structure for mt_book_item
-- ----------------------------
DROP TABLE IF EXISTS `mt_book_item`;
CREATE TABLE `mt_book_item`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `GOODS_ID` int NULL DEFAULT 0 COMMENT '预约服务ID',
  `CONTACT` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '预约联系人',
  `MOBILE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '预约手机号',
  `SERVICE_START_TIME` datetime NULL DEFAULT NULL COMMENT '预约开始日期',
  `SERVICE_END_TIME` datetime NULL DEFAULT NULL COMMENT '预约结束日期',
  `SERVICE_STAFF_ID` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '可预约员工',
  `REMARK` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '预约说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '预约详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_book_item
-- ----------------------------

-- ----------------------------
-- Table structure for mt_cart
-- ----------------------------
DROP TABLE IF EXISTS `mt_cart`;
CREATE TABLE `mt_cart`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '会员ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `TABLE_ID` int NULL DEFAULT 0 COMMENT '桌码ID',
  `IS_VISITOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '是否游客',
  `HANG_NO` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '挂单号',
  `SKU_ID` int NULL DEFAULT 0 COMMENT 'skuID',
  `GOODS_ID` int NULL DEFAULT 0 COMMENT '商品ID',
  `NUM` double(10, 2) NULL DEFAULT 1.00 COMMENT '数量',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_cart
-- ----------------------------

-- ----------------------------
-- Table structure for mt_commission_cash
-- ----------------------------
DROP TABLE IF EXISTS `mt_commission_cash`;
CREATE TABLE `mt_commission_cash`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `SETTLE_NO` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '结算单号',
  `UUID` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '结算UUID',
  `MERCHANT_ID` int NOT NULL COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT NULL COMMENT '店铺ID',
  `USER_ID` int NULL DEFAULT NULL COMMENT '会员ID',
  `STAFF_ID` int NULL DEFAULT NULL COMMENT '员工ID',
  `AMOUNT` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `DESCRIPTION` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A:待确认,B:已确认,C:已支付,D:已作废',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '分佣提现记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_commission_cash
-- ----------------------------

-- ----------------------------
-- Table structure for mt_commission_log
-- ----------------------------
DROP TABLE IF EXISTS `mt_commission_log`;
CREATE TABLE `mt_commission_log`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NOT NULL COMMENT '商户ID',
  `TARGET` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '对象,member:会员分销；staff：员工提成',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '分佣类型',
  `LEVEL` int NULL DEFAULT 1 COMMENT '分销等级',
  `USER_ID` int NULL DEFAULT NULL COMMENT '会员ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `STAFF_ID` int NULL DEFAULT 0 COMMENT '员工ID',
  `ORDER_ID` int NULL DEFAULT 0 COMMENT '订单ID',
  `AMOUNT` decimal(10, 2) NULL DEFAULT NULL COMMENT '分佣金额',
  `RULE_ID` int NULL DEFAULT NULL COMMENT '分佣规则ID',
  `RULE_ITEM_ID` int NULL DEFAULT NULL COMMENT '分佣规则项ID',
  `DESCRIPTION` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  `SETTLE_UUID` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '结算uuid',
  `CASH_ID` int NULL DEFAULT NULL COMMENT '提现记录ID',
  `IS_CASH` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '是否提现，Y：是；N：否',
  `CASH_TIME` datetime NULL DEFAULT NULL COMMENT '提现时间',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A：待结算；B：已结算；C：已作废',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '佣金记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_commission_log
-- ----------------------------

-- ----------------------------
-- Table structure for mt_commission_relation
-- ----------------------------
DROP TABLE IF EXISTS `mt_commission_relation`;
CREATE TABLE `mt_commission_relation`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NOT NULL COMMENT '商户ID',
  `USER_ID` int NULL DEFAULT NULL COMMENT '邀请会员ID',
  `LEVEL` int NULL DEFAULT 1 COMMENT '等级',
  `INVITE_CODE` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '邀请码',
  `SUB_USER_ID` int NULL DEFAULT NULL COMMENT '被邀请会员ID',
  `DESCRIPTION` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A：激活；D：删除',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '会员分销关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_commission_relation
-- ----------------------------

-- ----------------------------
-- Table structure for mt_commission_rule
-- ----------------------------
DROP TABLE IF EXISTS `mt_commission_rule`;
CREATE TABLE `mt_commission_rule`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '方案类型',
  `TARGET` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '方案对象,member:会员分销；staff：员工提成',
  `MERCHANT_ID` int NOT NULL COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `STORE_IDS` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '适用店铺',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A：激活；N：禁用；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '方案规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_commission_rule
-- ----------------------------

-- ----------------------------
-- Table structure for mt_commission_rule_item
-- ----------------------------
DROP TABLE IF EXISTS `mt_commission_rule_item`;
CREATE TABLE `mt_commission_rule_item`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '分佣类型',
  `RULE_ID` int NOT NULL DEFAULT 0 COMMENT '规则ID',
  `MERCHANT_ID` int NOT NULL COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '适用店铺',
  `TARGET` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '分佣对象',
  `TARGET_ID` int NOT NULL DEFAULT 0 COMMENT '对象ID',
  `METHOD` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '提成方式（按比例/固定金额）',
  `STORE_IDS` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '适用店铺',
  `GUEST` decimal(10, 2) NULL DEFAULT NULL COMMENT '散客佣金',
  `SUB_GUEST` decimal(10, 2) NULL DEFAULT NULL COMMENT '二级散客佣金',
  `MEMBER` decimal(10, 2) NULL DEFAULT NULL COMMENT '会员佣金',
  `SUB_MEMBER` decimal(10, 2) NULL DEFAULT NULL COMMENT '二级会员佣金',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A：激活；N：禁用；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '分佣提成规则项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_commission_rule_item
-- ----------------------------

-- ----------------------------
-- Table structure for mt_confirm_log
-- ----------------------------
DROP TABLE IF EXISTS `mt_confirm_log`;
CREATE TABLE `mt_confirm_log`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `CODE` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '编码',
  `AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '核销金额',
  `COUPON_ID` int NULL DEFAULT 0 COMMENT '卡券ID',
  `USER_COUPON_ID` int NOT NULL DEFAULT 0 COMMENT '用户券ID',
  `ORDER_ID` int NULL DEFAULT 0 COMMENT '订单ID',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '卡券所属用户ID',
  `OPERATOR_USER_ID` int NULL DEFAULT NULL COMMENT '核销者用户ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NOT NULL DEFAULT 0 COMMENT '核销店铺ID',
  `STATUS` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '状态，A正常核销；D：撤销使用',
  `CANCEL_TIME` datetime NULL DEFAULT NULL COMMENT '撤销时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后操作人',
  `OPERATOR_FROM` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'mt_user' COMMENT '操作来源user_id对应表t_account 还是 mt_user',
  `REMARK` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 291 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '核销记录表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_confirm_log
-- ----------------------------

-- ----------------------------
-- Table structure for mt_coupon
-- ----------------------------
DROP TABLE IF EXISTS `mt_coupon`;
CREATE TABLE `mt_coupon`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `GROUP_ID` int NOT NULL DEFAULT 0 COMMENT '券组ID',
  `TYPE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'C' COMMENT '券类型，C优惠券；P预存卡；T集次卡',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '券名称',
  `IS_GIVE` tinyint(1) NULL DEFAULT 0 COMMENT '是否允许转赠',
  `GRADE_IDS` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '适用会员等级',
  `POINT` int NULL DEFAULT 0 COMMENT '获得卡券所消耗积分',
  `APPLY_GOODS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '适用商品：allGoods、parkGoods',
  `RECEIVE_CODE` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '领取码',
  `USE_FOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '使用专项',
  `EXPIRE_TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '过期类型',
  `EXPIRE_TIME` int NULL DEFAULT 0 COMMENT '有效期，单位：天',
  `BEGIN_TIME` datetime NULL DEFAULT NULL COMMENT '开始有效期',
  `END_TIME` datetime NULL DEFAULT NULL COMMENT '结束有效期',
  `AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面额',
  `SEND_WAY` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'backend' COMMENT '发放方式',
  `SEND_NUM` int UNSIGNED NULL DEFAULT 1 COMMENT '每次发放数量',
  `TOTAL` int NULL DEFAULT 0 COMMENT '发行数量',
  `LIMIT_NUM` int NULL DEFAULT 1 COMMENT '每人拥有数量限制',
  `EXCEPT_TIME` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '不可用日期，逗号隔开。周末：weekend；其他：2019-01-02_2019-02-09',
  `STORE_IDS` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '所属店铺ID,逗号隔开',
  `DESCRIPTION` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '描述信息',
  `IMAGE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '效果图片',
  `REMARKS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '后台备注',
  `IN_RULE` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '获取券的规则',
  `OUT_RULE` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '核销券的规则',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT 'A：正常；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '卡券信息表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_coupon
-- ----------------------------

-- ----------------------------
-- Table structure for mt_coupon_goods
-- ----------------------------
DROP TABLE IF EXISTS `mt_coupon_goods`;
CREATE TABLE `mt_coupon_goods`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `COUPON_ID` int NOT NULL COMMENT '卡券ID',
  `GOODS_ID` int NOT NULL COMMENT '商品ID',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '卡券商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_coupon_goods
-- ----------------------------

-- ----------------------------
-- Table structure for mt_coupon_group
-- ----------------------------
DROP TABLE IF EXISTS `mt_coupon_group`;
CREATE TABLE `mt_coupon_group`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '券组名称',
  `MONEY` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '价值金额',
  `NUM` int NULL DEFAULT 0 COMMENT '券种类数量',
  `TOTAL` int NULL DEFAULT 0 COMMENT '发行数量',
  `DESCRIPTION` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新日期',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT 'A：正常；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '优惠券组' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_coupon_group
-- ----------------------------

-- ----------------------------
-- Table structure for mt_freight
-- ----------------------------
DROP TABLE IF EXISTS `mt_freight`;
CREATE TABLE `mt_freight`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '名称',
  `TYPE` int NOT NULL COMMENT '计费类型，1：按件数；2：按重量',
  `AMOUNT` decimal(10, 2) NOT NULL COMMENT '费用',
  `INCRE_AMOUNT` decimal(10, 2) NOT NULL COMMENT '续费',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '运费模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_freight
-- ----------------------------

-- ----------------------------
-- Table structure for mt_freight_region
-- ----------------------------
DROP TABLE IF EXISTS `mt_freight_region`;
CREATE TABLE `mt_freight_region`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `FREIGHT_ID` int NOT NULL COMMENT '运费模板ID',
  `PROVINCE_ID` int NOT NULL COMMENT '省份ID',
  `CITY_ID` int NOT NULL COMMENT '城市ID',
  `AREA_ID` int NOT NULL COMMENT '区域ID',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '运费模板地区' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_freight_region
-- ----------------------------

-- ----------------------------
-- Table structure for mt_give
-- ----------------------------
DROP TABLE IF EXISTS `mt_give`;
CREATE TABLE `mt_give`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '获赠者用户ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `GIVE_USER_ID` int NOT NULL DEFAULT 0 COMMENT '赠送者用户ID',
  `MOBILE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '赠予对象手机号',
  `USER_MOBILE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '用户手机',
  `GROUP_IDS` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '券组ID，逗号隔开',
  `GROUP_NAMES` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '券组名称，逗号隔开',
  `COUPON_IDS` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '券ID，逗号隔开',
  `COUPON_NAMES` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '券名称，逗号隔开',
  `NUM` int NOT NULL DEFAULT 0 COMMENT '数量',
  `MONEY` decimal(10, 2) NOT NULL COMMENT '总金额',
  `NOTE` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注',
  `MESSAGE` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '留言',
  `CREATE_TIME` datetime NOT NULL COMMENT '赠送时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT '状态，A正常；C取消',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `index_user_id`(`USER_ID` ASC) USING BTREE,
  INDEX `index_give_user_id`(`GIVE_USER_ID` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '转赠记录表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_give
-- ----------------------------

-- ----------------------------
-- Table structure for mt_give_item
-- ----------------------------
DROP TABLE IF EXISTS `mt_give_item`;
CREATE TABLE `mt_give_item`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `GIVE_ID` int NOT NULL COMMENT '转赠ID',
  `USER_COUPON_ID` int NOT NULL COMMENT '用户电子券ID',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '状态，A正常；D删除',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `index_give_id`(`GIVE_ID` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '转赠明细表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_give_item
-- ----------------------------

-- ----------------------------
-- Table structure for mt_goods
-- ----------------------------
DROP TABLE IF EXISTS `mt_goods`;
CREATE TABLE `mt_goods`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'goods' COMMENT '商品类别',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '所属店铺ID',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '商品名称',
  `CATE_ID` int NULL DEFAULT 0 COMMENT '分类ID',
  `GOODS_NO` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '商品编码',
  `IS_SINGLE_SPEC` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Y' COMMENT '是否单规格',
  `LOGO` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '主图地址',
  `IMAGES` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '图片地址',
  `PRICE` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '价格',
  `LINE_PRICE` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '划线价格',
  `COST_PRICE` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成本价格',
  `STOCK` double(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '库存',
  `WEIGHT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '重量',
  `COUPON_IDS` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '关联卡券ID',
  `SERVICE_TIME` int NULL DEFAULT 0 COMMENT '服务时长，单位：分钟',
  `INIT_SALE` double(10, 2) NULL DEFAULT 0.00 COMMENT '初始销量',
  `SALE_POINT` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '商品卖点',
  `CAN_USE_POINT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '可否使用积分抵扣',
  `IS_MEMBER_DISCOUNT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'Y' COMMENT '会员是否有折扣',
  `SORT` int NULL DEFAULT 0 COMMENT '排序',
  `DESCRIPTION` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '商品描述',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT 'A：正常；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 570 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '商品表' ROW_FORMAT = COMPRESSED;

-- ----------------------------
-- Records of mt_goods
-- ----------------------------

-- ----------------------------
-- Table structure for mt_goods_cate
-- ----------------------------
DROP TABLE IF EXISTS `mt_goods_cate`;
CREATE TABLE `mt_goods_cate`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '所属店铺',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '分类名称',
  `LOGO` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT 'LOGO地址',
  `DESCRIPTION` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '分类描述',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后操作人',
  `SORT` int NULL DEFAULT 0 COMMENT '排序',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT 'A：正常；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 226 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_goods_cate
-- ----------------------------

-- ----------------------------
-- Table structure for mt_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `mt_goods_sku`;
CREATE TABLE `mt_goods_sku`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `SKU_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT 'sku编码',
  `LOGO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '图片',
  `GOODS_ID` int NOT NULL DEFAULT 0 COMMENT '商品ID',
  `SPEC_IDS` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '规格ID',
  `STOCK` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '库存',
  `PRICE` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '价格',
  `LINE_PRICE` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '划线价格',
  `COST_PRICE` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成本价格',
  `WEIGHT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '重量',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1006 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '商品SKU表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_goods_sku
-- ----------------------------

-- ----------------------------
-- Table structure for mt_goods_spec
-- ----------------------------
DROP TABLE IF EXISTS `mt_goods_spec`;
CREATE TABLE `mt_goods_spec`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `GOODS_ID` int NOT NULL DEFAULT 0 COMMENT '商品ID',
  `NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '规格名称',
  `VALUE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '规格值',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 584 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '规格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_goods_spec
-- ----------------------------

-- ----------------------------
-- Table structure for mt_merchant
-- ----------------------------
DROP TABLE IF EXISTS `mt_merchant`;
CREATE TABLE `mt_merchant`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '类型，restaurant：餐饮；retail：零售；service：服务；other：其他',
  `LOGO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT 'logo',
  `NO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '商户号',
  `NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '商户名称',
  `CONTACT` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '联系人姓名',
  `PHONE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '联系电话',
  `ADDRESS` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '联系地址',
  `WX_APP_ID` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '微信小程序appId',
  `WX_APP_SECRET` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '微信小程序秘钥',
  `WX_OFFICIAL_APP_ID` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '微信公众号appId',
  `WX_OFFICIAL_APP_SECRET` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '微信公众号秘钥',
  `DESCRIPTION` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注信息',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A：有效/启用；D：无效',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '商户表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_merchant
-- ----------------------------

-- ----------------------------
-- Table structure for mt_message
-- ----------------------------
DROP TABLE IF EXISTS `mt_message`;
CREATE TABLE `mt_message`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `USER_ID` int NOT NULL COMMENT '用户ID',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '消息类型',
  `TITLE` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '友情提示' COMMENT '消息标题',
  `CONTENT` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '消息内容',
  `IS_READ` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '是否已读',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `PARAMS` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '参数信息',
  `IS_SEND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '是否已发送',
  `SEND_TIME` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 463952 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '系统消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_message
-- ----------------------------

-- ----------------------------
-- Table structure for mt_open_gift
-- ----------------------------
DROP TABLE IF EXISTS `mt_open_gift`;
CREATE TABLE `mt_open_gift`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NOT NULL DEFAULT 0 COMMENT '门店ID',
  `GRADE_ID` int NOT NULL DEFAULT 0 COMMENT '会员等级ID',
  `POINT` int NOT NULL DEFAULT 0 COMMENT '赠送积分',
  `COUPON_ID` int NOT NULL DEFAULT 0 COMMENT '卡券ID',
  `COUPON_NUM` int NOT NULL DEFAULT 1 COMMENT '卡券数量',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '会员开卡赠礼' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_open_gift
-- ----------------------------

-- ----------------------------
-- Table structure for mt_open_gift_item
-- ----------------------------
DROP TABLE IF EXISTS `mt_open_gift_item`;
CREATE TABLE `mt_open_gift_item`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `USER_ID` int NOT NULL COMMENT '会用ID',
  `OPEN_GIFT_ID` int NOT NULL COMMENT '赠礼ID',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `STATUS` char(1) CHARACTER SET utf32 COLLATE utf32_general_ci NOT NULL COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf32 COLLATE = utf32_general_ci COMMENT = '开卡赠礼明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_open_gift_item
-- ----------------------------

-- ----------------------------
-- Table structure for mt_order
-- ----------------------------
DROP TABLE IF EXISTS `mt_order`;
CREATE TABLE `mt_order`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '订单类型',
  `PAY_TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'JSAPI' COMMENT '支付类型',
  `ORDER_MODE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'express' COMMENT '订单模式',
  `ORDER_SN` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `COUPON_ID` int NULL DEFAULT 0 COMMENT '卡券ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '所属店铺ID',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '用户ID',
  `VERIFY_CODE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '核销验证码',
  `IS_VISITOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '是否游客',
  `AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单金额',
  `PAY_AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付金额',
  `USE_POINT` int NULL DEFAULT 0 COMMENT '使用积分数量',
  `POINT_AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '积分金额',
  `DISCOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '折扣金额',
  `DELIVERY_FEE` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '配送费用',
  `PARAM` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '订单参数',
  `EXPRESS_INFO` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '物流信息',
  `REMARK` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '用户备注',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '订单状态',
  `PAY_TIME` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `PAY_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '支付状态',
  `SETTLE_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '结算状态',
  `STAFF_ID` int NULL DEFAULT 0 COMMENT '操作员工',
  `CONFIRM_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N' COMMENT '核销状态',
  `CONFIRM_TIME` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `CONFIRM_REMARK` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '核销备注',
  `COMMISSION_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '分佣提成计算状态',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2160 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_order
-- ----------------------------

-- ----------------------------
-- Table structure for mt_order_address
-- ----------------------------
DROP TABLE IF EXISTS `mt_order_address`;
CREATE TABLE `mt_order_address`  (
  `ID` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `NAME` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `MOBILE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '联系电话',
  `PROVINCE_ID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '省份ID',
  `CITY_ID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '城市ID',
  `REGION_ID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '区/县ID',
  `DETAIL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `ORDER_ID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单ID',
  `USER_ID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `ORDER_ID`(`ORDER_ID` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '订单收货地址记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_order_address
-- ----------------------------

-- ----------------------------
-- Table structure for mt_order_goods
-- ----------------------------
DROP TABLE IF EXISTS `mt_order_goods`;
CREATE TABLE `mt_order_goods`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ORDER_ID` int NOT NULL DEFAULT 0 COMMENT '订单ID',
  `GOODS_ID` int NOT NULL DEFAULT 0 COMMENT '商品ID',
  `SKU_ID` int NULL DEFAULT 0 COMMENT 'skuID',
  `PRICE` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `DISCOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '优惠价',
  `NUM` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商品数量',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT 'A：正常；D：删除',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '订单商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_order_goods
-- ----------------------------

-- ----------------------------
-- Table structure for mt_point
-- ----------------------------
DROP TABLE IF EXISTS `mt_point`;
CREATE TABLE `mt_point`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '所属店铺ID',
  `USER_ID` int NOT NULL DEFAULT 0 COMMENT '用户ID',
  `ORDER_SN` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '订单号',
  `AMOUNT` int NOT NULL DEFAULT 0 COMMENT '积分变化数量',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注说明',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态，A正常；D作废',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2490 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '积分变化表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_point
-- ----------------------------

-- ----------------------------
-- Table structure for mt_refund
-- ----------------------------
DROP TABLE IF EXISTS `mt_refund`;
CREATE TABLE `mt_refund`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ORDER_ID` int NOT NULL COMMENT '订单ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '所属商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `USER_ID` int NOT NULL COMMENT '会员ID',
  `AMOUNT` decimal(10, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '售后类型',
  `REMARK` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '退款备注',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  `IMAGES` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '图片',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '售后表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_refund
-- ----------------------------

-- ----------------------------
-- Table structure for mt_region
-- ----------------------------
DROP TABLE IF EXISTS `mt_region`;
CREATE TABLE `mt_region`  (
  `ID` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '区划信息ID',
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '区划名称',
  `PID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '区划编码',
  `LEVEL` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '层级(1省级 2市级 3区/县级)',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3705 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '省市区数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_region
-- ----------------------------

-- ----------------------------
-- Table structure for mt_send_log
-- ----------------------------
DROP TABLE IF EXISTS `mt_send_log`;
CREATE TABLE `mt_send_log`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `TYPE` tinyint(1) NOT NULL COMMENT '1：单用户发券；2：批量发券',
  `USER_ID` int NULL DEFAULT NULL COMMENT '用户ID',
  `FILE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '导入excel文件名',
  `FILE_PATH` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '导入excel文件路径',
  `MOBILE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户手机',
  `GROUP_ID` int NOT NULL COMMENT '券组ID',
  `GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '券组名称',
  `COUPON_ID` int NULL DEFAULT 0 COMMENT '卡券ID',
  `SEND_NUM` int NULL DEFAULT NULL COMMENT '发放套数',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `UUID` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '导入UUID',
  `REMOVE_SUCCESS_NUM` int NULL DEFAULT 0 COMMENT '作废成功张数',
  `REMOVE_FAIL_NUM` int NULL DEFAULT 0 COMMENT '作废失败张数',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '状态，A正常；B：部分作废；D全部作废',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 120124 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '卡券发放记录表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_send_log
-- ----------------------------

-- ----------------------------
-- Table structure for mt_setting
-- ----------------------------
DROP TABLE IF EXISTS `mt_setting`;
CREATE TABLE `mt_setting`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `TYPE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '类型',
  `NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '配置项',
  `VALUE` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '配置值',
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '配置说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态 A启用；D禁用',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '全局设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_setting
-- ----------------------------

-- ----------------------------
-- Table structure for mt_settlement
-- ----------------------------
DROP TABLE IF EXISTS `mt_settlement`;
CREATE TABLE `mt_settlement`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `SETTLEMENT_NO` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '结算单号',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `TOTAL_ORDER_AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单总金额',
  `AMOUNT` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '结算金额',
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `PAY_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '支付状态',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '结算表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_settlement
-- ----------------------------

-- ----------------------------
-- Table structure for mt_settlement_order
-- ----------------------------
DROP TABLE IF EXISTS `mt_settlement_order`;
CREATE TABLE `mt_settlement_order`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `SETTLEMENT_ID` int NOT NULL DEFAULT 0 COMMENT '结算ID',
  `ORDER_ID` int NULL DEFAULT 0 COMMENT '订单ID',
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1093 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '结算订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_settlement_order
-- ----------------------------

-- ----------------------------
-- Table structure for mt_sms_sended_log
-- ----------------------------
DROP TABLE IF EXISTS `mt_sms_sended_log`;
CREATE TABLE `mt_sms_sended_log`  (
  `LOG_ID` int NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `MOBILE_PHONE` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `CONTENT` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '短信内容',
  `SEND_TIME` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`LOG_ID`) USING BTREE,
  INDEX `FK_REFERENCE_1`(`MOBILE_PHONE` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '短信发送记录表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_sms_sended_log
-- ----------------------------

-- ----------------------------
-- Table structure for mt_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `mt_sms_template`;
CREATE TABLE `mt_sms_template`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `UNAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '英文名称',
  `CODE` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '编码',
  `CONTENT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '内容',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT '状态：A激活；N禁用',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '短信模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_sms_template
-- ----------------------------

-- ----------------------------
-- Table structure for mt_staff
-- ----------------------------
DROP TABLE IF EXISTS `mt_staff`;
CREATE TABLE `mt_staff`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NULL DEFAULT 0 COMMENT '店铺ID',
  `USER_ID` int NULL DEFAULT 0 COMMENT '用户ID',
  `CATEGORY` int NULL DEFAULT 0 COMMENT '员工类别,1:店长;2:收银员;3:销售人员;3:服务人员;',
  `MOBILE` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `REAL_NAME` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '真实姓名',
  `WECHAT` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '微信号',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `AUDITED_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'U' COMMENT '审核状态，A：审核通过；U：未审核；D：无效; ',
  `AUDITED_TIME` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 87 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '店铺员工表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of mt_staff
-- ----------------------------

-- ----------------------------
-- Table structure for mt_stock
-- ----------------------------
DROP TABLE IF EXISTS `mt_stock`;
CREATE TABLE `mt_stock`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `MERCHANT_ID` int NULL DEFAULT 0 COMMENT '商户ID',
  `STORE_ID` int NOT NULL DEFAULT 0 COMMENT '店铺ID',
  `TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'increase' COMMENT '类型，increase:入库，reduce:出库',
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '备注说明',
  `CREATE_TIME` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT '状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '库存管理记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_stock
-- ----------------------------

-- ----------------------------
-- Table structure for mt_stock_item
-- ----------------------------
DROP TABLE IF EXISTS `mt_stock_item`;
CREATE TABLE `mt_stock_item`  (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `STOCK_ID` int NOT NULL DEFAULT 0 COMMENT '库存管理ID',
  `GOODS_ID` int NOT NULL DEFAULT 0 COMMENT '商品ID',
  `SKU_ID` int NOT NULL DEFAULT 0 COMMENT 'SKUID',
  `NUM` int NOT NULL DEFAULT 0 COMMENT '数量',
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '' COMMENT '说明备注',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL COMMENT '更新时间',
  `OPERATOR` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '最后操作人',
  `STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'A' COMMENT '订单状态',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 147 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '库存管理明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mt_stock_item
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
