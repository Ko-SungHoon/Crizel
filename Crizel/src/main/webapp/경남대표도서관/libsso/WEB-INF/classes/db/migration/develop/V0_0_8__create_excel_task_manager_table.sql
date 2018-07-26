CREATE TABLE IF NOT EXISTS `isign_excel_task_manager` (
    `LOG_TYPE` VARCHAR(50) NOT NULL,
    `LOG_FILE_NAME` VARCHAR(100) NOT NULL,
    `RUNNING` TINYINT(4) NOT NULL,
    `START_DATE` DATETIME NOT NULL,
    `STOP_DATE` DATETIME NULL DEFAULT NULL
)
COMMENT='엑셀생성을 관리하는 매니져 table'
DEFAULT CHARSET=utf8
ENGINE=InnoDB
;
