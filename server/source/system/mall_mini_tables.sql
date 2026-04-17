-- 创建购物车表
CREATE TABLE IF NOT EXISTS `shopping_cart` (
  `id` varchar(32) NOT NULL COMMENT 'PK',
  `del_flag` char(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) NOT NULL COMMENT '用户编号',
  `spu_id` varchar(32) NOT NULL COMMENT '商品SPU',
  `quantity` int NOT NULL COMMENT '数量',
  `spu_name` varchar(200) DEFAULT NULL COMMENT '加入时的spu名字',
  `add_price` decimal(10,2) DEFAULT NULL COMMENT '加入时价格',
  `pic_url` varchar(500) DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_spu_id` (`spu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车';

-- 创建用户地址表
CREATE TABLE IF NOT EXISTS `user_address` (
  `id` varchar(32) NOT NULL COMMENT 'PK',
  `del_flag` char(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) NOT NULL COMMENT '用户编号',
  `user_name` varchar(50) DEFAULT NULL COMMENT '收货人名字',
  `postal_code` varchar(50) DEFAULT NULL COMMENT '邮编',
  `province_name` varchar(50) DEFAULT NULL COMMENT '省名',
  `city_name` varchar(50) DEFAULT NULL COMMENT '市名',
  `county_name` varchar(50) DEFAULT NULL COMMENT '区名',
  `detail_info` varchar(255) DEFAULT NULL COMMENT '详情地址',
  `tel_num` varchar(50) DEFAULT NULL COMMENT '电话号码',
  `is_default` char(2) DEFAULT NULL COMMENT '是否默认 1是0否',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户地址';
