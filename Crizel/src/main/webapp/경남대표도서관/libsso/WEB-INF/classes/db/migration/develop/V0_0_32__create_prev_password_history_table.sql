CREATE TABLE `isign_previous_password_history` (
    `SID` BIGINT(8) NOT NULL,
    `PASSWORD` VARCHAR(64) NOT NULL,
    `SAVEDATE` DATETIME(3) NOT NULL,
    PRIMARY KEY (`SID`, `SAVEDATE`)
)
COMMENT='이전에 사용한 패스워드를 기록함'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

insert into isign_config (config_key, config_value) values ('PWD_POLICY_PREVIOUS_HISTORY_USE_B', 'false');
insert into isign_config (config_key, config_value) values ('PWD_POLICY_PREVIOUS_HISTORY_CHECK_COUNT_N', '1');

CREATE TABLE `isign_admin_previous_password_history` (
    `SID` BIGINT(8) NOT NULL,
    `PASSWORD` VARCHAR(64) NOT NULL,
    `SAVEDATE` DATETIME(3) NOT NULL,
    PRIMARY KEY (`SID`, `SAVEDATE`)
)
COMMENT='관리자용 이전 패스워드 기록\r\nisign_previous_password_history 동일한 역화을 하지만 관리자 관련 수정이 있을경우 수정이 용이하도록 따로 분리하였음.'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

