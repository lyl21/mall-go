-- 商城表结构更新脚本
-- 执行此脚本以确保所有字段都有正确的默认值

-- 更新商品表：确保version字段有默认值0
ALTER TABLE `goods_spu` 
MODIFY COLUMN `version` int DEFAULT 0 COMMENT '版本号（乐观锁）';

-- 如果version字段为NULL，设置为0
UPDATE `goods_spu` SET `version` = 0 WHERE `version` IS NULL;

-- 更新订单表：确保is_refund字段有默认值
ALTER TABLE `order_info` 
MODIFY COLUMN `is_refund` char(2) DEFAULT '0' COMMENT '是否退款0:否 1:是';

-- 更新订单项表：确保status和is_refund字段有默认值
ALTER TABLE `order_item` 
MODIFY COLUMN `status` char(2) DEFAULT '0' COMMENT '状态0：正常；1：退款中；2:拒绝退款；3：同意退款',
MODIFY COLUMN `is_refund` char(2) DEFAULT '0' COMMENT '是否退款0:否 1：是';

-- 添加索引优化查询性能
ALTER TABLE `order_info` 
ADD INDEX `idx_user_id` (`user_id`),
ADD INDEX `idx_status` (`status`),
ADD INDEX `idx_order_no` (`order_no`),
ADD INDEX `idx_create_time` (`create_time`);

ALTER TABLE `order_item` 
ADD INDEX `idx_order_id` (`order_id`),
ADD INDEX `idx_spu_id` (`spu_id`);

ALTER TABLE `goods_spu` 
ADD INDEX `idx_category_first` (`category_first`),
ADD INDEX `idx_shelf` (`shelf`);

-- 更新已有数据的版本号（如果没有的话）
UPDATE `goods_spu` SET `version` = 0 WHERE `version` IS NULL OR `version` = '';
