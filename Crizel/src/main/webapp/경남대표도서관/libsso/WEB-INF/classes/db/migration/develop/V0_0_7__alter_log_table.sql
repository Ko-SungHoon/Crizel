ALTER TABLE `isign_log_user` ADD COLUMN `log_type` VARCHAR(255) NOT NULL COMMENT '로그 종류' AFTER `log_code` ;
ALTER TABLE `isign_log_system` ADD COLUMN `log_type` VARCHAR(255) NOT NULL COMMENT '로그 종류' AFTER `log_code` ;
ALTER TABLE `isign_log_manager` ADD COLUMN `log_type` VARCHAR(255) NOT NULL COMMENT '로그 종류' AFTER `log_code` ;