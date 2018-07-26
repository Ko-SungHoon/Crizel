RENAME TABLE isign_sp_info TO isign_saml_idp_sp_info;

ALTER TABLE `isign_saml_idp_sp_info` COMMENT='SAML IdP 설정의 SP 정보';
ALTER TABLE `isign_saml_idp_sp_info` DROP PRIVATE_KEY_VALUE;
ALTER TABLE `isign_saml_idp_sp_info` DROP PUBLIC_KEY_VALUE;

CREATE TABLE IF NOT EXISTS `isign_saml_idp_idp_info` (
  `SID` BIGINT(8) NOT NULL AUTO_INCREMENT COMMENT 'index',
  `ENTITY_ID` varchar(256) NOT NULL COMMENT '식별자',
  `DOMAIN_NAME` varchar(256) NOT NULL COMMENT '도메인',
  `FACTOR` varchar(10) NOT NULL COMMENT '인증 단계',
  `AUTHENTICATION_TYPE1` varchar(20) NOT NULL COMMENT '첫번째 인증 타입',
  `AUTHENTICATION_TYPE2` varchar(20) NOT NULL COMMENT '두번째 인증 타입',
  `SP_LOGOUT_BATCH_USE` varchar(10) COMMENT 'SP 일괄 로그아웃 사용여부',
  `SP_LOGOUT_BATCH_DELAY_TIME` varchar(10) COMMENT 'SP 일괄 로그아웃 딜레이 시간(초)',
  `PRIVATE_KEY_VALUE` VARCHAR(4096) NOT NULL COMMENT '개인키 값',
  `PUBLIC_KEY_VALUE` VARCHAR(4096) NOT NULL COMMENT '공개키 값',
  `KEY_ALGORITHM` VARCHAR(20) NOT NULL COMMENT '키 알고리즘',
  PRIMARY KEY (`SID`))
ENGINE = InnoDB
COMMENT = 'SAML IdP 설정의 IdP 정보';

RENAME TABLE isign_idp_info TO isign_saml_sp_idp_info;

CREATE TABLE `isign_saml_sp_sp_info` LIKE `isign_saml_sp_idp_info`;
INSERT INTO `isign_saml_sp_sp_info` SELECT * FROM `isign_saml_sp_idp_info`;

ALTER TABLE `isign_saml_sp_sp_info` DROP LOGIN_SERVICE;
ALTER TABLE `isign_saml_sp_sp_info` DROP LOGOUT_SERVICE;
ALTER TABLE `isign_saml_sp_sp_info` DROP PUBLIC_KEY_VALUE;
ALTER TABLE `isign_saml_sp_sp_info` COMMENT='SAML SP 설정의 SP 정보';

ALTER TABLE `isign_saml_sp_idp_info` DROP DOMAIN_NAME;
ALTER TABLE `isign_saml_sp_idp_info` DROP ASSERTION_CONSUMER_SERVICE;
ALTER TABLE `isign_saml_sp_idp_info` DROP PROVIDER_NAME;
ALTER TABLE `isign_saml_sp_idp_info` DROP RELAYSTATE_URL;
ALTER TABLE `isign_saml_sp_idp_info` ADD COLUMN `USE_IDPW` varchar(10) COMMENT 'IdP IDPW 인증 타입 사용여부' AFTER `LOGOUT_SERVICE`;
ALTER TABLE `isign_saml_sp_idp_info` ADD COLUMN `USE_PKI` varchar(10) COMMENT 'IdP PKI 인증 타입 사용여부'  AFTER `USE_IDPW`;
ALTER TABLE `isign_saml_sp_idp_info` ADD COLUMN `USE_OTP` varchar(10) COMMENT 'IdP OTP 인증 타입 사용여부'  AFTER `USE_PKI`;
ALTER TABLE `isign_saml_sp_idp_info` COMMENT='SAML SP 설정의 IdP 정보';

INSERT INTO isign_saml_idp_idp_info (
	FACTOR,
	ENTITY_ID,
	DOMAIN_NAME,
	AUTHENTICATION_TYPE1,
	AUTHENTICATION_TYPE2,
	SP_LOGOUT_BATCH_USE,
	SP_LOGOUT_BATCH_DELAY_TIME,
	PRIVATE_KEY_VALUE,
	PUBLIC_KEY_VALUE,
	KEY_ALGORITHM
) VALUES (
	'1',
	(select CASE WHEN (select count(SID) from isign_saml_idp_sp_info) > 0 THEN (select ENTITY_ID from isign_saml_idp_sp_info limit 1) ELSE '' END from dual),
	(select CASE WHEN (select count(SID) from isign_saml_idp_sp_info) > 0 THEN (select DOMAIN_NAME from isign_saml_idp_sp_info limit 1) ELSE '' END from dual),
	(select CASE WHEN (select count(SID) from isign_service where SID = 100000) > 0 THEN (select AUTHMETHOD from isign_service where SID = 100000) ELSE 'idpw' END from dual),
	'disabled',
	'false',
	1,
	'',
	'',
	''
);

UPDATE isign_saml_idp_sp_info SET ENTITY_ID = '';
UPDATE isign_saml_sp_idp_info SET ENTITY_ID = '';

DELETE FROM isign_service where SID = 100000;
UPDATE isign_service SET SVCGROUPSID = -1 WHERE SVCGROUPSID = 100000;
DELETE FROM isign_servicegroup where SID = 100000;