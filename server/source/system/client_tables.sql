-- 安装包管理表
CREATE TABLE IF NOT EXISTS `installing_packages` (
  `installing_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '安装包ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  `app_name` varchar(100) DEFAULT '' COMMENT '应用名称',
  `app_version` varchar(50) DEFAULT '' COMMENT '应用版本',
  `app_url` varchar(500) DEFAULT '' COMMENT '应用下载地址',
  `force_update` int(1) DEFAULT '0' COMMENT '是否强制更新0否1是',
  `update_content` text COMMENT '更新内容',
  `package_type` int(1) DEFAULT '1' COMMENT '包类型1APP2键盘3验光仪4手动验光仪',
  `status` int(1) DEFAULT '1' COMMENT '状态0禁用1启用',
  PRIMARY KEY (`installing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='安装包管理表';

-- 错误报告日志表
CREATE TABLE IF NOT EXISTS `error_report_log` (
  `log_id` varchar(64) NOT NULL COMMENT '日志ID',
  `equipment_id` varchar(100) DEFAULT '' COMMENT '设备ID',
  `log_path` varchar(500) DEFAULT '' COMMENT '日志路径或内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错误报告日志表';

-- 插入默认安装包数据
INSERT INTO `installing_packages` (`installing_id`, `app_name`, `app_version`, `app_url`, `force_update`, `package_type`, `status`) VALUES
(1, '牛头APP', '1.0.0', '', 0, 1, 1),
(2, '键盘APP', '1.0.0', '', 0, 2, 1),
(3, '验光仪APP', '1.0.0', '', 0, 3, 1),
(4, '手动验光仪APP', '1.0.0', '', 0, 4, 1);
