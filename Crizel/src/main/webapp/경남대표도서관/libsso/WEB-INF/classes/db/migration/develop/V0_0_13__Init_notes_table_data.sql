CREATE TABLE IF NOT EXISTS `isign_notes_user` (
	`SID` BIGINT(8) NOT NULL COMMENT '사용자 고유 식별번호',
	`ID` VARCHAR(128) NOT NULL COMMENT 'notes 아이디',
	`PWD` VARCHAR(64) NOT NULL COMMENT 'notes 비밀번호',
	`DOMINO_SERVER` VARCHAR(128) NOT NULL COMMENT 'domino server 주소(IP or Domain)',
	PRIMARY KEY (`SID`),
	CONSTRAINT `FK__isign_user` FOREIGN KEY (`SID`) REFERENCES `isign_user` (`SID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='notes 유저 정보 테이블';

INSERT INTO `isign_config` (`config_key`, `config_value`) VALUES
    ('NOTES_CONFIG_B', 'false'),
    ('NOTES_MODE_N', '2'),
    ('NOTES_VERSION_N', '1'),
    ('NOTES_KEY_VALUE_T', '');