-- 添加审核状态字段的SQL脚本
-- review_status: 0=待审核, 1=审核通过, 2=审核不通过

-- 1. 修改 post 表添加审核状态字段
ALTER TABLE `post` ADD COLUMN `review_status` TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态：0=待审核, 1=审核通过, 2=审核不通过' AFTER `status`;
ALTER TABLE `post` ADD COLUMN `review_message` VARCHAR(500) NULL DEFAULT NULL COMMENT '审核意见' AFTER `review_status`;

-- 2. 修改 tutorial_articles 表添加审核状态字段
ALTER TABLE `tutorial_articles` ADD COLUMN `review_status` TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态：0=待审核, 1=审核通过, 2=审核不通过' AFTER `status`;
ALTER TABLE `tutorial_articles` ADD COLUMN `review_message` VARCHAR(500) NULL DEFAULT NULL COMMENT '审核意见' AFTER `review_status`;

-- 3. 修改 tutorial_videos 表添加审核状态字段
ALTER TABLE `tutorial_videos` ADD COLUMN `review_status` TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态：0=待审核, 1=审核通过, 2=审核不通过' AFTER `author`;
ALTER TABLE `tutorial_videos` ADD COLUMN `review_message` VARCHAR(500) NULL DEFAULT NULL COMMENT '审核意见' AFTER `review_status`;

-- 4. 为现有数据设置默认审核通过状态
UPDATE `post` SET `review_status` = 1 WHERE `status` = 1;
UPDATE `tutorial_articles` SET `review_status` = 1 WHERE `status` = 1;
UPDATE `tutorial_videos` SET `review_status` = 1;

COMMIT;