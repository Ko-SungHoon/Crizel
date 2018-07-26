-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema isignplus
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema isignplus
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `isignplus` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `isignplus` ;

CREATE TABLE IF NOT EXISTS `dsm_code_master` (
  `CODE_TYPE` varchar(15) NOT NULL,
  `CODE` varchar(15) NOT NULL,
  `CODE_NM` varchar(255) NOT NULL,
  `USE_YN` char(1) DEFAULT 'Y',
  `DISPLAY_ORDER` decimal(10,0) DEFAULT '0',
  `REMARK` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`CODE_TYPE`,`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_data_effect` (
  `KEY_NUM` decimal(15,0) NOT NULL,
  `EVENT_TIME` datetime NOT NULL,
  `PROJECT_ID` varchar(100) NOT NULL,
  `SCHEDULE_ID` varchar(100) NOT NULL,
  `PROCESS_ID` varchar(100) NOT NULL,
  `FUNCTION_ID` varchar(100) DEFAULT NULL,
  `DATA_SOURCE` varchar(40) DEFAULT NULL,
  `SCHEMA_NAME` varchar(40) DEFAULT NULL,
  `TABLE_NAME` varchar(80) DEFAULT NULL,
  `CRUD` char(1) DEFAULT NULL,
  PRIMARY KEY (`KEY_NUM`),
  KEY `DSM_DATA_EFFECT_IDX` (`PROJECT_ID`,`SCHEDULE_ID`,`PROCESS_ID`,`FUNCTION_ID`),
  KEY `DSM_DATA_EFFECT_IDX2` (`DATA_SOURCE`,`SCHEMA_NAME`,`TABLE_NAME`),
  KEY `DSM_DATA_EFFECT_IDX3` (`TABLE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_data_effect_column` (
  `KEY_NUM` decimal(15,0) NOT NULL,
  `COLUMN_NAME` varchar(80) NOT NULL,
  PRIMARY KEY (`KEY_NUM`,`COLUMN_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_data_model_history` (
  `KEY_DATE` date NOT NULL,
  PRIMARY KEY (`KEY_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_data_model_history_column` (
  `KEY_DATE` date NOT NULL,
  `DATA_SOURCE` varchar(40) NOT NULL,
  `TABLE_SCHEMA` varchar(40) NOT NULL,
  `TABLE_NAME` varchar(80) NOT NULL,
  `COLUMN_NAME` varchar(80) NOT NULL,
  `TABLE_TYPE` varchar(20) DEFAULT NULL,
  `COLUMN_TYPE_NAME` varchar(20) DEFAULT NULL,
  `COLUMN_SIZE` decimal(10,0) DEFAULT NULL,
  `DECIMAL_DIGITS` decimal(4,0) DEFAULT NULL,
  `IS_NULLABLE` varchar(3) DEFAULT NULL,
  `IS_AUTOINCREMENT` varchar(3) DEFAULT NULL,
  `ORDINAL_POSITION` decimal(4,0) DEFAULT NULL,
  PRIMARY KEY (`KEY_DATE`,`DATA_SOURCE`,`TABLE_SCHEMA`,`TABLE_NAME`,`COLUMN_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_data_model_history_table` (
  `KEY_DATE` date NOT NULL,
  `DATA_SOURCE` varchar(40) NOT NULL,
  `TABLE_SCHEMA` varchar(40) NOT NULL,
  `TABLE_NAME` varchar(80) NOT NULL,
  `TABLE_TYPE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`KEY_DATE`,`DATA_SOURCE`,`TABLE_SCHEMA`,`TABLE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_job_log` (
  `JOB_NUM` decimal(15,0) NOT NULL,
  `JOB_DATE` datetime NOT NULL,
  `JOB_USERID` varchar(20) NOT NULL,
  `STATUS` decimal(10,0) DEFAULT '0',
  `DESCRIPTION` varchar(4000) DEFAULT NULL,
  `JOB_PLAN_DT` datetime DEFAULT NULL,
  `JOB_COMP_DT` datetime DEFAULT NULL,
  `JOB_USERIP` varchar(20) DEFAULT NULL,
  `REG_DT` datetime DEFAULT NULL,
  `REG_ID` varchar(20) NOT NULL,
  `MOD_DT` datetime DEFAULT NULL,
  `MOD_ID` varchar(20) NOT NULL,
  PRIMARY KEY (`JOB_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_job_log_doc` (
  `JOB_LOG_DOC_NUM` decimal(15,0) NOT NULL,
  `JOB_NUM` decimal(15,0) NOT NULL,
  `SERVER_FILE_NM` varchar(256) DEFAULT NULL,
  `DISP_FILE_NM` varchar(256) DEFAULT NULL,
  `REG_DT` datetime DEFAULT NULL,
  `REG_ID` varchar(20) NOT NULL,
  `MOD_DT` datetime DEFAULT NULL,
  `MOD_ID` varchar(20) NOT NULL,
  PRIMARY KEY (`JOB_LOG_DOC_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_job_user` (
  `PROJECT_ID` varchar(100) NOT NULL,
  `SCHEDULE_ID` varchar(100) NOT NULL,
  `JOB_USERID` varchar(20) NOT NULL,
  `SCHEDULE_SHORT_ID` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PROJECT_ID`,`SCHEDULE_ID`,`JOB_USERID`),
  KEY `DSM_JOB_USER_IDX` (`PROJECT_ID`,`SCHEDULE_SHORT_ID`,`JOB_USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_log_detail` (
  `DETAIL_NUM` decimal(15,0) NOT NULL,
  `MASTER_NUM` decimal(15,0) NOT NULL,
  `PROCESS_ID` varchar(100) NOT NULL,
  `PROCESS_SHORT_ID` varchar(100) DEFAULT NULL,
  `FUNCTION_ID` varchar(100) DEFAULT NULL,
  `LOG_OWNER_TYPE` decimal(1,0) NOT NULL,
  `SUCCESS_FLAG` decimal(1,0) DEFAULT NULL,
  `TRY_INDEX` decimal(10,0) DEFAULT '0',
  `TRY_COUNT` decimal(10,0) DEFAULT '0',
  `LOG_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `END_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `LOG_TYPE` decimal(1,0) DEFAULT '2',
  `LOG_LEVEL` varchar(15) DEFAULT '0',
  `LOG_CD` varchar(15) DEFAULT '-1',
  `LOG_DESCRIPTION` mediumtext,
  `INTERVAL_TIME` decimal(10,0) DEFAULT NULL,
  `EXCEPTION_TRACE` blob,
  PRIMARY KEY (`DETAIL_NUM`),
  KEY `LOG_DETAIL_IDX` (`PROCESS_ID`,`FUNCTION_ID`),
  KEY `LOG_DETAIL_IDX2` (`PROCESS_SHORT_ID`,`FUNCTION_ID`),
  KEY `LOG_DETAIL_IDX3` (`MASTER_NUM`,`DETAIL_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_log_master` (
  `MASTER_NUM` decimal(15,0) NOT NULL,
  `EVENT_TIME` datetime NOT NULL,
  `END_TIME` datetime DEFAULT NULL,
  `PROJECT_ID` varchar(100) NOT NULL,
  `SCHEDULE_ID` varchar(100) NOT NULL,
  `SCHEDULE_SHORT_ID` varchar(100) DEFAULT NULL,
  `SUCCESS_FLAG` decimal(1,0) DEFAULT NULL,
  `TRY_INDEX` decimal(10,0) DEFAULT '0',
  `TRY_COUNT` decimal(10,0) DEFAULT '0',
  `TIME_SCHEDULE` varchar(200) DEFAULT NULL,
  `INTERVAL_TIME` decimal(10,0) DEFAULT NULL,
  `JOB_NUM` decimal(15,0) DEFAULT NULL,
  PRIMARY KEY (`MASTER_NUM`),
  KEY `LOG_MASTER_IDX` (`PROJECT_ID`,`SCHEDULE_ID`),
  KEY `LOG_MASTER_IDX2` (`PROJECT_ID`,`SCHEDULE_SHORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_log_sum_process` (
  `EVENT_DATE` varchar(10) NOT NULL,
  `PROJECT_ID` varchar(100) NOT NULL,
  `SCHEDULE_ID` varchar(100) NOT NULL,
  `SCHEDULE_SHORT_ID` varchar(100) DEFAULT NULL,
  `PROCESS_ID` varchar(100) NOT NULL,
  `PROCESS_SHORT_ID` varchar(100) DEFAULT NULL,
  `FUNCTION_ID` varchar(100) NOT NULL,
  `LOG_OWNER_TYPE` decimal(1,0) NOT NULL,
  `SUCCESS_FLAG` decimal(1,0) NOT NULL,
  `LOG_TYPE` decimal(1,0) NOT NULL DEFAULT '2',
  `LOG_LEVEL` varchar(15) NOT NULL DEFAULT '0',
  `LOG_CD` varchar(15) NOT NULL DEFAULT '-1',
  `LOG_CNT` decimal(15,0) NOT NULL DEFAULT '0',
  `EVENT_YYMM` varchar(6) NOT NULL,
  PRIMARY KEY (`EVENT_DATE`,`PROJECT_ID`,`SCHEDULE_ID`,`PROCESS_ID`,`FUNCTION_ID`,`LOG_OWNER_TYPE`,`SUCCESS_FLAG`,`LOG_TYPE`,`LOG_LEVEL`,`LOG_CD`),
  KEY `DSM_LOG_SUM_PROCESS_IDX1` (`EVENT_YYMM`,`EVENT_DATE`,`PROJECT_ID`,`SCHEDULE_ID`,`PROCESS_ID`,`FUNCTION_ID`,`LOG_OWNER_TYPE`,`SUCCESS_FLAG`,`LOG_TYPE`,`LOG_LEVEL`,`LOG_CD`),
  KEY `DSM_LOG_SUM_PROCESS_IDX2` (`EVENT_YYMM`,`EVENT_DATE`,`PROJECT_ID`,`SCHEDULE_SHORT_ID`,`PROCESS_ID`,`FUNCTION_ID`,`LOG_OWNER_TYPE`,`SUCCESS_FLAG`,`LOG_TYPE`,`LOG_LEVEL`,`LOG_CD`),
  KEY `DSM_LOG_SUM_PROCESS_IDX3` (`EVENT_YYMM`,`EVENT_DATE`,`PROJECT_ID`,`SCHEDULE_ID`,`PROCESS_SHORT_ID`,`FUNCTION_ID`,`LOG_OWNER_TYPE`,`SUCCESS_FLAG`,`LOG_TYPE`,`LOG_LEVEL`,`LOG_CD`),
  KEY `DSM_LOG_SUM_PROCESS_IDX4` (`EVENT_YYMM`,`EVENT_DATE`,`PROJECT_ID`,`SCHEDULE_SHORT_ID`,`PROCESS_SHORT_ID`,`FUNCTION_ID`,`LOG_OWNER_TYPE`,`SUCCESS_FLAG`,`LOG_TYPE`,`LOG_LEVEL`,`LOG_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_log_sum_schedule` (
  `EVENT_DATE` varchar(10) NOT NULL,
  `PROJECT_ID` varchar(100) NOT NULL,
  `SCHEDULE_ID` varchar(100) NOT NULL,
  `SCHEDULE_SHORT_ID` varchar(100) DEFAULT NULL,
  `SUCCESS_FLAG` decimal(1,0) NOT NULL,
  `LOG_CNT` decimal(15,0) DEFAULT '0',
  `EVENT_YYMM` varchar(6) NOT NULL,
  PRIMARY KEY (`EVENT_DATE`,`PROJECT_ID`,`SCHEDULE_ID`,`SUCCESS_FLAG`),
  KEY `DSM_LOG_SUM_SCHEDULE_IDX` (`EVENT_YYMM`,`PROJECT_ID`,`SCHEDULE_ID`,`SUCCESS_FLAG`),
  KEY `DSM_LOG_SUM_SCHEDULE_IDX2` (`EVENT_YYMM`,`PROJECT_ID`,`SCHEDULE_SHORT_ID`,`SUCCESS_FLAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_seq_info` (
  `TABLE_NM` varchar(255) NOT NULL,
  `SEQ` decimal(15,0) DEFAULT '1',
  PRIMARY KEY (`TABLE_NM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_user_admin` (
  `USER_ID` varchar(20) NOT NULL,
  `USER_NM` varchar(100) DEFAULT NULL,
  `USER_PWD` varchar(256) DEFAULT NULL,
  `USER_HP` varchar(20) DEFAULT NULL,
  `USER_TEL` varchar(20) DEFAULT NULL,
  `EMAIL_ADDR` varchar(100) DEFAULT NULL,
  `DEPT_NM` varchar(100) DEFAULT NULL,
  `USER_TITLE` varchar(100) DEFAULT NULL,
  `STAFF_FLAG` char(1) DEFAULT NULL,
  `USE_FLAG` char(1) DEFAULT NULL,
  `ERR_TASK_CD` varchar(15) DEFAULT NULL,
  `TASK_EXPLAIN` varchar(2000) DEFAULT '',
  `AUTHORITY` decimal(1,0) DEFAULT '1',
  `CTRL_ALL_PRJ` decimal(1,0) DEFAULT '0',
  `REG_DT` datetime DEFAULT NULL,
  `REG_ID` varchar(20) NOT NULL,
  `MOD_DT` datetime DEFAULT NULL,
  `MOD_ID` varchar(20) NOT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_user_project_map` (
  `USER_ID` varchar(20) NOT NULL,
  `PROJECT_ID` varchar(100) NOT NULL,
  `REG_DT` datetime DEFAULT NULL,
  `REG_ID` varchar(20) NOT NULL,
  PRIMARY KEY (`USER_ID`,`PROJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dsm_work_log` (
  `SEQ` decimal(15,0) NOT NULL,
  `WORK_DT` datetime NOT NULL,
  `WORK_USER_ID` varchar(50) DEFAULT NULL,
  `WORK_USER_NM` varchar(100) DEFAULT NULL,
  `WORK_CLIENT_IP` varchar(50) DEFAULT NULL,
  `WORK_SERVER_IP` varchar(50) DEFAULT NULL,
  `REM` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`SEQ`),
  KEY `DSM_WORK_LOG_IDX` (`WORK_DT`,`WORK_USER_ID`,`WORK_USER_NM`,`WORK_SERVER_IP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_admin` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '관리자 고유 식별번호',
  `ATYPE` int(4) DEFAULT '1' COMMENT '관리자 유형\\n1 : 최상위 관리자\\n2 : 서비스 관리자\\n3 : 부서 관리자\\n4 : 시스템 관리자\\n',
  `CRTADMINSID` bigint(8) DEFAULT NULL COMMENT '생성한 관리자 SID',
  `CRTDATE` datetime DEFAULT NULL COMMENT '생성 날짜',
  `MDFADMINSID` bigint(8) DEFAULT NULL COMMENT '수정한 관리자 SID',
  `MDFDATE` datetime DEFAULT NULL COMMENT '수정 날짜',
  `MDFREASON` varchar(1024) DEFAULT NULL COMMENT '수정 사유',
  `PARENTADMINSID` bigint(8) DEFAULT NULL COMMENT '상위 관리자 SID',
  `ADMINID` varchar(128) DEFAULT NULL COMMENT '관리자 페이지 접속 ID',
  `ADMINPW` varchar(64) DEFAULT NULL COMMENT '관리자 페이지 접속 비밀번호',
  `USERSID` bigint(8) DEFAULT NULL COMMENT '사용자 SID, adm : -1',
  `SUPER_ADMIN` int(4) DEFAULT NULL COMMENT '최상위 관리자\n0 : 일반 관리자\n1 : 최상위 관리자',
  `USEALARM` int(4) DEFAULT NULL COMMENT '운영설정에서 알람 사용을 설정하면 해당 알람을 받을지 여부\n0 : 이벤트 알람을 받지 않음\n1 : 이벤트 알람을 받음',
  `LASTCHANGEDATE` datetime DEFAULT NULL COMMENT '최종 변경일',
  `INCORRECTTIME` datetime DEFAULT NULL COMMENT '실패날짜',
  `ISDEFAULTPWD` int(10) DEFAULT NULL COMMENT '자동설정된 초기 패스워드인가?\\n0 : 아니오\\n1 : 예',
  `INCORECTNUM` int(4) DEFAULT NULL COMMENT '누적실패횟수, 성공 시 0으로 초기화',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='관리자';

CREATE TABLE IF NOT EXISTS `isign_api` (
  `API_NAME` varchar(25) NOT NULL,
  `API_URL` varchar(200) NOT NULL,
  `API_EXPLAIN` varchar(45) NOT NULL,
  PRIMARY KEY (`API_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='OPENAPI 권한 설정';

-- 테이블 isignplus의 구조를 덤프합니다. isign_api_user
CREATE TABLE IF NOT EXISTS `isign_api_user` (
  `sid` bigint(8) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(128) NOT NULL,
  `api_secretkey` varchar(500) NOT NULL,
  `api_email` varchar(128) NOT NULL,
  PRIMARY KEY (`sid`),
  UNIQUE KEY `api_key` (`api_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='OPENAPI 사용자 정보';

-- 테이블 isignplus의 구조를 덤프합니다. isign_backup
CREATE TABLE IF NOT EXISTS `isign_backup` (
  `SID` bigint(8) NOT NULL COMMENT '식별자',
  `METHOD` int(4) DEFAULT NULL COMMENT '백업 방식\n1 : 삭제\n2 : 유지',
  `TIME_HOUR` int(4) DEFAULT NULL COMMENT '백업 시간(시)',
  `TIME_MINUTE` int(4) DEFAULT NULL COMMENT '백업 시간(분)',
  `INTERVAL_DAY` int(4) DEFAULT NULL COMMENT '백업 주기(일)',
  `PERTAIN_DAY` int(4) DEFAULT NULL COMMENT '데이터 유지기간(일), 1일 이상\n-1 : 미사용',
  `FORWARDING` int(4) DEFAULT NULL COMMENT '외부로 전송\n1 : 전송\n2 : 미전송',
  `FORWARDING_PROTOCOL` varchar(16) DEFAULT NULL COMMENT '전송 프로토콜\nFTP, SFTP',
  `FORWARDING_IP` varchar(64) DEFAULT NULL COMMENT '전송될 곳의 IP',
  `FORWARDING_PORT` varchar(12) DEFAULT NULL COMMENT '전송될 곳의 PORT',
  `FORWARDING_ACCOUNT` varchar(128) DEFAULT NULL COMMENT '전송될 곳의 계정 정보(ID)',
  `FORWARDING_PASSWD` varchar(64) DEFAULT NULL COMMENT '전송될 곳의 계정 정보(PWD)',
  `FORWARDING_PATH` varchar(64) DEFAULT NULL COMMENT '배업할 경로',
  `AUTO_BACKUP` varchar(10) DEFAULT NULL COMMENT '자동 백업 사용 유무\nY : 예\nN : 아니오',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='DB 백업 설정';

CREATE TABLE IF NOT EXISTS `isign_config` (
  `config_key` varchar(255) NOT NULL COMMENT '설정정보 키',
  `config_value` varchar(1000) DEFAULT NULL COMMENT '설정정보 값',
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='환경설정 정보 테이블';

CREATE TABLE IF NOT EXISTS `isign_dept` (
  `SID` varchar(128) NOT NULL COMMENT '부서 고유 식별번호\n',
  `NAME_KOR` varchar(128) DEFAULT NULL COMMENT '부서이름(한글)',
  `NAME_ENG` varchar(128) DEFAULT NULL COMMENT '부서이름(영문)',
  `PARENTSID` varchar(128) DEFAULT NULL COMMENT '상위부서 SID',
  `TYPECODE` varchar(128) DEFAULT NULL,
  `TYPENAME` varchar(128) DEFAULT NULL,
  `LOCALHQCODE` varchar(128) DEFAULT NULL,
  `DEPTH` int(4) DEFAULT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='부서(조직도)';

-- 테이블 isignplus의 구조를 덤프합니다. isign_duty
CREATE TABLE IF NOT EXISTS `isign_duty` (
  `SID` varchar(128) NOT NULL COMMENT '직무코드',
  `NAME_KOR` varchar(128) DEFAULT NULL COMMENT '직무이름(한글)',
  `NAME_ENG` varchar(128) DEFAULT NULL COMMENT '직무이름(영문)',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='직무';

CREATE TABLE IF NOT EXISTS `isign_empgroup` (
  `SID` varchar(128) NOT NULL COMMENT '직군코드',
  `NAME_KOR` varchar(128) DEFAULT NULL COMMENT '직군이름(한글)',
  `NAME_ENG` varchar(128) DEFAULT NULL COMMENT '직군이름(영문)',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='직군';

CREATE TABLE IF NOT EXISTS `isign_eventalarm` (
  `SID` bigint(8) NOT NULL COMMENT '식별자',
  `ISENABLE` int(4) DEFAULT NULL COMMENT '이벤트 알람 설정 사용 여부',
  `DBCHECK` int(4) DEFAULT NULL COMMENT '저장소 용량 체크',
  `DBCHECKLIMIT` varchar(32) DEFAULT NULL COMMENT '저장소 용량 체크 설정 시 해당값 이상이 되면 알림',
  `UPDATECHECK` int(4) DEFAULT NULL COMMENT '업데이트 시 알림',
  `SMTPADDR` varchar(64) DEFAULT NULL COMMENT '메일 서버 IP',
  `SMTPPORT` int(4) DEFAULT NULL COMMENT '메일 서버 Port',
  `EMAILID` varchar(128) DEFAULT NULL COMMENT '메일 계정 ID',
  `EMAILPWD` varchar(64) DEFAULT NULL COMMENT '메일 계정 PWD',
  `SMTPMETHOD` int(4) DEFAULT NULL COMMENT 'smtp 형식\n0 : 평문\n1 : SSL\n2 : TLS',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='이벤트 알람 설정';

-- 테이블 isignplus의 구조를 덤프합니다. isign_idp_info
CREATE TABLE IF NOT EXISTS `isign_idp_info` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT 'index',
  `ENTITY_ID` varchar(256) NOT NULL COMMENT '식별자 설정',
  `DOMAIN_NAME` varchar(256) NOT NULL COMMENT '도메인',
  `LOGIN_SERVICE` varchar(512) NOT NULL COMMENT '로그인 페이지',
  `LOGOUT_SERVICE` varchar(512) NOT NULL COMMENT '로그아웃 페이지',
  `ASSERTION_CONSUMER_SERVICE` varchar(512) NOT NULL COMMENT 'ACS 페이지',
  `PROVIDER_NAME` varchar(256) NOT NULL COMMENT '서비스명',
  `RELAYSTATE_URL` varchar(512) NOT NULL COMMENT 'RelayState 페이지',
  `PUBLIC_KEY_VALUE` varchar(4096) NOT NULL COMMENT '서명 확인 인증서',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SAML IdP 설정';

CREATE TABLE IF NOT EXISTS `isign_ldap_config` (
  `SID` bigint(8) NOT NULL,
  `HOST` varchar(256) DEFAULT 'ldap://localhost:389' COMMENT 'LDAP IP 혹은 Domain 주소 (ex. ldap://192.168.21.167:389)',
  `TYPE` varchar(20) DEFAULT 'AD' COMMENT 'LDAP 타입 ("AD", "OpenLDAP")',
  `PRINCIPAL` varchar(256) DEFAULT 'example.com' COMMENT 'LDAP 도메인 설정 (ex. "AD"의 경우 "example.com", "OpenLDAP"의 경우 "dc=example,dc=com")',
  `OBJECTNAME` varchar(20) DEFAULT 'cn' COMMENT 'LDAP DN 사용자 구분 필드값 (ex. "cn", "uid")',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='AD/OpenLDAP 연동 설정';

CREATE TABLE IF NOT EXISTS `isign_log_temp` (
  `uuid` varchar(36) NOT NULL COMMENT 'uuid 값',
  `dttm` datetime NOT NULL COMMENT '일시',
  `temp_log_data` longtext NOT NULL COMMENT '로그 코드 값',
  `log_type` varchar(64) NOT NULL COMMENT '로그 타입 값',
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='임시 로그 저장';

CREATE TABLE IF NOT EXISTS `isign_log_verification` (
  `LOG_TYPE` varchar(45) NOT NULL COMMENT '검증작업의 대상 로그유형',
  `JOB_STAT` varchar(45) DEFAULT NULL COMMENT '검증작업의 현재 상태. 진행중/성공/실패/에러',
  `JOB_PCNT` int(11) DEFAULT NULL COMMENT '검증작업의 진행율. 정수 퍼센트로 기록',
  `FAIL_DETAIL` varchar(4000) DEFAULT NULL COMMENT '검증 실패시 실패한 로그 번호, 번호를 콤마로 묶는다',
  `START_TIME` datetime DEFAULT NULL COMMENT '검증작업의 시작시간',
  `END_TIME` datetime DEFAULT NULL COMMENT '검증작업의 종료시간. 작업의 에러 여부 검사를 위해 사용함',
  PRIMARY KEY (`LOG_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='HMAC 검증시 상태정보를 기록';

CREATE TABLE IF NOT EXISTS `isign_map_api_user` (
  `api_name` varchar(25) NOT NULL,
  `user_id` bigint(8) NOT NULL,
  PRIMARY KEY (`api_name`,`user_id`),
  KEY `fk_isign_api_has_isign_api_user_isign_api_user1_idx` (`user_id`),
  KEY `fk_isign_api_has_isign_api_user_isign_api1_idx` (`api_name`),
  CONSTRAINT `fk_isign_api_has_isign_api_user_isign_api1` FOREIGN KEY (`api_name`) REFERENCES `isign_api` (`API_NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_isign_api_has_isign_api_user_isign_api_user` FOREIGN KEY (`user_id`) REFERENCES `isign_api_user` (`sid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='OPENAPI 권한 매핑';

CREATE TABLE IF NOT EXISTS `isign_motp_history` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT 'index',
  `INCORRECTTIME` datetime DEFAULT NULL COMMENT 'MOTP 검증 실패 시간',
  `INCORRECTNUM` int(4) DEFAULT NULL COMMENT 'MOTP 검증 실패 누적 횟수',
  `LASTVERIFIED` bigint(8) DEFAULT NULL COMMENT '가장 최근에 검증된\n시간 (재사용 방지)',
  `ISDEFAULTOTP` int(4) DEFAULT NULL COMMENT 'OTP 초기화 여부(재등록 방지)\n0 : 아니오, 1 : 예',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='모바일 OTP 이력';

CREATE TABLE IF NOT EXISTS `isign_position` (
  `SID` varchar(128) NOT NULL COMMENT '직급코드',
  `NAME_KOR` varchar(128) DEFAULT NULL COMMENT '직급이름(한글)',
  `NAME_ENG` varchar(128) DEFAULT NULL COMMENT '직급이름(영문)',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='직급';

CREATE TABLE IF NOT EXISTS `isign_pwdhistory` (
  `SID` bigint(8) NOT NULL COMMENT '사용자 고유번호',
  `LASTCHANGEDATE` datetime DEFAULT NULL COMMENT '최종 변경일',
  `INCORRECTTIME` datetime DEFAULT NULL COMMENT '실패날짜',
  `ISDEFAULTPWD` int(10) DEFAULT NULL COMMENT '자동설정된 초기 패스워드인가?\n0 : 아니오\n1 : 예',
  `INCORECTNUM` int(4) DEFAULT NULL COMMENT '누적실패횟수, 성공 시 0으로 초기화',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='패스워드 이력';

CREATE TABLE IF NOT EXISTS `isign_registerip` (
  `IPSID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '등록된 아이피 SID',
  `IP` varchar(64) DEFAULT NULL COMMENT '아이피',
  PRIMARY KEY (`IPSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='등록된 IP 리스트';

CREATE TABLE IF NOT EXISTS `isign_role` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '식별자',
  `NAME` varchar(128) DEFAULT NULL COMMENT '이름',
  `DESCR` varchar(1024) DEFAULT NULL COMMENT '설명',
  `CRTADMINSID` bigint(8) DEFAULT NULL COMMENT '생성한 관리자의 SID',
  `CRTDATE` datetime DEFAULT NULL COMMENT '생성된 날짜',
  `MDFADMINSID` bigint(8) DEFAULT NULL COMMENT '수정한 관리자의 SID',
  `MDFDATE` datetime DEFAULT NULL COMMENT '수정한 날짜',
  `RTYPE` varchar(128) DEFAULT NULL COMMENT '역활의 타입',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='역활';

CREATE TABLE IF NOT EXISTS `isign_roleservicemap` (
  `RSID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '역활 SID',
  `SSID` bigint(8) NOT NULL COMMENT '서비스 SID',
  `CRTADMINSID` bigint(8) DEFAULT NULL COMMENT '생성한 관리자의 SID',
  `CRTDATE` datetime DEFAULT NULL COMMENT '생성 날짜',
  `MDFADMINSID` bigint(8) DEFAULT NULL COMMENT '수정한 관리자의 SID',
  `MDFDATE` datetime DEFAULT NULL COMMENT '수정 날짜',
  `USERDATA` varchar(1024) DEFAULT NULL COMMENT '보충 항목',
  `RESERVED1` varchar(1024) DEFAULT NULL COMMENT '예약 필드 1',
  `RESERVED2` varchar(1024) DEFAULT NULL COMMENT '예약 필드 2',
  PRIMARY KEY (`RSID`,`SSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='역활 - 서비스 매핑 테이블';

CREATE TABLE IF NOT EXISTS `isign_roleusermap` (
  `RSID` bigint(8) NOT NULL COMMENT '역활 SID',
  `USID` bigint(8) NOT NULL COMMENT '사용자 SID',
  `CRTADMINSID` bigint(8) DEFAULT NULL COMMENT '생성한 관리자의 SID',
  `CRTDATE` datetime DEFAULT NULL COMMENT '생성 날짜',
  `MDFADMINSID` bigint(8) DEFAULT NULL COMMENT '수정한 관리자의 SID',
  `MDFDATE` datetime DEFAULT NULL COMMENT '수정 날짜',
  `USERDATA` varchar(1024) DEFAULT NULL COMMENT '보충 항목',
  `RESERVED1` varchar(1024) DEFAULT NULL COMMENT '예약 필드 1',
  `RESERVED2` varchar(1024) DEFAULT NULL COMMENT '예약 필드 2',
  PRIMARY KEY (`RSID`,`USID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='역활 - 사용자 매핑 테이블';

CREATE TABLE IF NOT EXISTS `isign_role_accesslistmap` (
  `RND` int(11) NOT NULL AUTO_INCREMENT,
  `RID` bigint(8) NOT NULL,
  `SSID` bigint(8) NOT NULL,
  `CODE_NAME` varchar(120) DEFAULT NULL,
  `CODE_USE` varchar(1) NOT NULL,
  PRIMARY KEY (`RND`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='자원 추가';

CREATE TABLE IF NOT EXISTS `isign_sap_user` (
  `SID` bigint(8) NOT NULL COMMENT 'index',
  `SAP_ID` varchar(128) NOT NULL COMMENT 'sap id',
  `SAP_PW` varchar(512) NOT NULL COMMENT 'sap pwd, 암호화시 길이 300자',
  `SAP_SYSTEM` varchar(128) NOT NULL COMMENT 'sap system',
  `SAP_CLIENT` varchar(128) NOT NULL COMMENT 'sap client',
  `SAP_LANGUAGE` varchar(128) NOT NULL COMMENT 'sap language',
  `SAP_TITLE` varchar(128) NOT NULL COMMENT 'sap title',
  `SAP_SERVERIP` varchar(128) NOT NULL COMMENT 'sap server ip',
  `SAP_SYSTEMNUMBER` varchar(128) NOT NULL COMMENT 'sap system number',
  `SAP_GROUPNAME` varchar(128) NOT NULL COMMENT 'sap groupname',
  `SAP_COMMAND` varchar(128) NOT NULL COMMENT 'sap command',
  `REV01` varchar(1024) DEFAULT NULL COMMENT '예비, 1:n, n:m 매핑시 사용',
  `REV02` varchar(1024) DEFAULT NULL COMMENT '예비',
  `REV03` varchar(1024) DEFAULT NULL COMMENT '예비',
  `REV04` varchar(1024) DEFAULT NULL COMMENT '예비',
  `REV05` varchar(1024) DEFAULT NULL COMMENT '예비',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SAP 사용자';

CREATE TABLE IF NOT EXISTS `isign_service` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '식별자',
  `NAME` varchar(128) DEFAULT NULL COMMENT '이름',
  `DESCR` varchar(1024) DEFAULT NULL COMMENT '설명',
  `STYPE` varchar(128) DEFAULT NULL COMMENT '유형',
  `SVCGROUPSID` bigint(8) DEFAULT NULL COMMENT '서비스 그룹',
  `INURL` varchar(256) DEFAULT NULL COMMENT 'URL',
  `OUTURL` varchar(256) DEFAULT NULL COMMENT '로그아웃 URL',
  `IP` varchar(64) DEFAULT NULL COMMENT 'IP',
  `PORT` varchar(128) DEFAULT NULL COMMENT 'PORT\nv1.9',
  `SERVERTYPE` varchar(12) DEFAULT NULL COMMENT '서비스 타입\nv1.9',
  `SERVERTYPE2` varchar(12) DEFAULT NULL COMMENT '2번째 인증 서비스 타입',
  `ACSTIMEFROM` date DEFAULT NULL COMMENT '접근 가능 시간(시작)',
  `ACSTIMETO` date DEFAULT NULL COMMENT '접근 가능 시간(종료)',
  `ISENCRYPT` varchar(2) DEFAULT NULL COMMENT '세션 암호화 여부',
  `AUTHMETHOD` varchar(16) DEFAULT NULL COMMENT '인증방식\nidpw, pki, idpwpki, ssl',
  `ISMUTUAL` varchar(2) DEFAULT NULL COMMENT '상호인증 여부\n0 : ignore\n1 : apply',
  `REQUESTAGENT` varchar(128) DEFAULT NULL COMMENT '요청 에이전트',
  `CHECKALLOWIP` varchar(2) DEFAULT '1' COMMENT '허용 IP\n0 : ignore\n1 : apply',
  `CHECKDENYIP` varchar(2) DEFAULT '0' COMMENT '거부 IP\n0 : ignore\n1 : apply',
  `CRTADMINSID` bigint(8) DEFAULT NULL COMMENT '생성한 관리자의 SID',
  `CRTDATE` datetime DEFAULT NULL COMMENT '생성한 날짜',
  `MDFADMINSID` bigint(8) DEFAULT NULL COMMENT '수정한 관리자의 SID',
  `MDFDATE` datetime DEFAULT NULL COMMENT '수정한 날짜',
  `DN` varchar(128) DEFAULT NULL,
  `NOTIFY` varchar(2) DEFAULT NULL COMMENT '서비스 변경정보 알림',
  `USEISIGNPAGE` int(4) DEFAULT NULL COMMENT 'ISIGN PLUS 통합로그인 페이지\n0 : ignore\n1 : apply',
  `USEISIGNPAGE2` int(4) DEFAULT NULL COMMENT '2번째 인증의 통합로그인 페이지 사용 여부 \n0 : ignore\n1 : apply',
  `PATHURL` varchar(128) DEFAULT NULL COMMENT 'Path\nv2.1',
  `AUTHURL` varchar(128) DEFAULT NULL COMMENT '1번째 인증 PATH',
  `AUTHURL2` varchar(128) DEFAULT NULL COMMENT '2번째 인증 PATH',
  `AUTHORIZATION_URL` varchar(128) DEFAULT NULL COMMENT '검증 PATH',
  `RETURNURL` varchar(128) DEFAULT NULL COMMENT '검증 성공 후의 PATH',
  `LOGOUTURL` varchar(128) DEFAULT NULL COMMENT '서비스의 로그아웃 페이지',
  `USE_IP_CONTROL` varchar(2) DEFAULT '0' COMMENT 'IP 접근제어 사용 여부\n0 : ignore\n1 : apply',
  `AUTHMETHOD2` varchar(16) DEFAULT NULL,
  `DEFAULT_SERVICE` varchar(2) DEFAULT '0' COMMENT 'Default Agent Service 여부, 0 : Default Agent Service 아님, 1 : Default Agent Service임',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='서비스';

CREATE TABLE IF NOT EXISTS `isign_serviceaccessip` (
  `SSID` bigint(8) DEFAULT NULL COMMENT '서비스 SID',
  `IPSID` bigint(8) DEFAULT NULL COMMENT '등록된 아이피 SID',
  `SATYPE` varchar(128) DEFAULT NULL COMMENT '형태\n0 : ALLOW\n1 : DENY'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='서비스 접근 IP 제어';

CREATE TABLE IF NOT EXISTS `isign_servicegroup` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '서비스 그룹 SID',
  `NAME` varchar(128) DEFAULT NULL COMMENT '서비스 그룹명',
  `DESCR` varchar(1024) DEFAULT NULL COMMENT '설명',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='서비스 그룹';

CREATE TABLE IF NOT EXISTS `isign_session` (
  `session_id` varchar(64) NOT NULL COMMENT 'Session id',
  `user_id` varchar(128) NOT NULL COMMENT '사용자 ID',
  `agent_service_id` bigint(8) DEFAULT NULL COMMENT 'Agent 서비스 ID',
  `token_key` varchar(512) NOT NULL COMMENT 'token 암복호화를 위한 비밀키',
  `token_seq` int(4) DEFAULT NULL COMMENT '토큰 시퀀스',
  `device_info` varchar(64) NOT NULL COMMENT '발생주체의 장비 정보',
  `ip` varchar(64) NOT NULL COMMENT '발생주체의 IP',
  `valid_session` varchar(1) DEFAULT NULL COMMENT '유효한 세션 여부(0: 유효하지 않음, 1:유효함)',
  `create_dttm` datetime NOT NULL COMMENT '생성 일시',
  `update_dttm` datetime NOT NULL COMMENT '수정 일시',
  PRIMARY KEY (`session_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='세션 정보 저장';

CREATE TABLE IF NOT EXISTS `isign_sp_info` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT 'index',
  `ENTITY_ID` varchar(256) NOT NULL COMMENT '식별자 설정',
  `PROVIDER_NAME` varchar(256) NOT NULL COMMENT '서비스 명',
  `ASSERTION_CONSUMER_SERVICE` varchar(512) NOT NULL COMMENT 'ACS 페이지',
  `LOGOUT_SERVICE` varchar(512) NOT NULL COMMENT '로그아웃 페이지',
  `DESCRIPTION` varchar(4096) DEFAULT NULL COMMENT '설명',
  `PRIVATE_KEY_VALUE` varchar(4096) NOT NULL COMMENT '개인키 값',
  `PUBLIC_KEY_VALUE` varchar(4096) NOT NULL COMMENT '공개키 값',
  `DOMAIN_NAME` varchar(256) NOT NULL COMMENT '도메인',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SAML SP 설정';

CREATE TABLE IF NOT EXISTS `isign_title` (
  `SID` varchar(128) NOT NULL COMMENT '직위코드',
  `NAME_KOR` varchar(128) DEFAULT NULL COMMENT '직위이름(한글)',
  `NAME_ENG` varchar(128) DEFAULT NULL COMMENT '직위이름(영문)',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='직위';

CREATE TABLE IF NOT EXISTS `isign_u2f_keydata` (
  `accountname` varchar(50) NOT NULL,
  `userpublickey` varchar(500) NOT NULL,
  `keyhandle` varchar(500) NOT NULL,
  `counter` int(11) NOT NULL,
  `transports` varchar(500) DEFAULT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`accountname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_u2f_transaction` (
  `sessionid` varchar(50) NOT NULL,
  `accountname` varchar(100) NOT NULL,
  `challenge` varchar(100) NOT NULL,
  `appid` varchar(500) NOT NULL,
  `userpublickey` varchar(500) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`sessionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_u2f_trustedcertificate` (
  `certificate` varchar(2000) NOT NULL,
  `comment` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_u2f_trusteddomain` (
  `domain` varchar(2000) NOT NULL,
  `comment` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_uaf_device` (
  `uid` varchar(128) NOT NULL,
  `deviceid` varchar(128) NOT NULL,
  `type` int(11) NOT NULL,
  `pushid` varchar(256) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`,`deviceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_uaf_keys` (
  `username` varchar(128) NOT NULL,
  `aaid` varchar(128) NOT NULL,
  `keyid` varchar(128) NOT NULL,
  `public_key` blob,
  `authenticator_version` varchar(16) DEFAULT NULL,
  `sign_counter` int(11) DEFAULT NULL,
  `png_char` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_uaf_metadata` (
  `aaid` varchar(128) NOT NULL,
  `description` varchar(128) NOT NULL,
  `assertionScheme` varchar(128) NOT NULL DEFAULT 'UAFV1TLV',
  `authenticationAlgorithm` int(11) DEFAULT NULL,
  `publicKeyAlgAndEncoding` int(11) DEFAULT NULL,
  `json` blob,
  PRIMARY KEY (`aaid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_uaf_transaction` (
  `tid` varchar(128) NOT NULL,
  `uid` varchar(128) NOT NULL,
  `deviceid` varchar(128) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `result` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_uaf_trustedfacets` (
  `facetid` varchar(2000) NOT NULL,
  `comment` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `isign_user` (
  `SID` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '사용자 고유 식별번호',
  `ID` varchar(128) DEFAULT NULL COMMENT '아이디',
  `PWD` varchar(64) DEFAULT NULL COMMENT '비밀번호',
  `NAME_KOR` varchar(128) DEFAULT NULL COMMENT '이름(한글)',
  `NAME_ENG` varchar(128) DEFAULT NULL COMMENT '이름(영문)',
  `NAME_CHN` varchar(128) DEFAULT NULL COMMENT '이름(한자)',
  `RESID` varchar(64) DEFAULT NULL COMMENT '주민등록번호',
  `EMPID` varchar(64) DEFAULT NULL COMMENT '사번',
  `EMAIL` varchar(64) DEFAULT NULL COMMENT '이메일',
  `OFFICEPHONE` varchar(64) DEFAULT NULL COMMENT '사무실 전화번호',
  `MOBILE` varchar(64) DEFAULT NULL COMMENT '휴대 전화번호',
  `DEPARTCODE` bigint(20) DEFAULT NULL COMMENT '부서 고유 식별번호\n',
  `TITLECODE` bigint(20) DEFAULT NULL COMMENT '직위 고유 식별번호',
  `POSITIONCODE` bigint(20) DEFAULT NULL COMMENT '직급 고유 식별번호',
  `PRIMARYDUTYCODE` bigint(20) DEFAULT NULL COMMENT '주직무 고유 식별번호',
  `SUBDUTYCODE` bigint(20) DEFAULT NULL COMMENT '부직무 고유 식별번호',
  `EMPGROUPCODE` bigint(20) DEFAULT NULL COMMENT '직군 고유 식별번호',
  `ADDITIONALTITLECODE` bigint(20) DEFAULT NULL COMMENT '겸직 고유 식별번호',
  `ISADMIN` int(11) DEFAULT '0' COMMENT '관리자유무',
  `ADMINSID` bigint(8) DEFAULT NULL COMMENT '관리자 SID(ADMIN)',
  `EMPTYPE` varchar(64) DEFAULT NULL COMMENT '고용형태',
  `CRTADMINSID` bigint(8) DEFAULT NULL COMMENT '생성한 관리자 고유 식별번호',
  `CRTDATE` datetime DEFAULT NULL COMMENT '생성일',
  `MDFADMINSID` bigint(8) DEFAULT NULL COMMENT '수정한 관리자 고유 식별번호',
  `MDFDATE` datetime DEFAULT NULL COMMENT '수정일',
  `MDFREASON` varchar(1024) DEFAULT NULL COMMENT '수정사유',
  `PROVINCE` varchar(256) DEFAULT NULL COMMENT '시/도',
  `COUNTY` varchar(256) DEFAULT NULL COMMENT '구/군/시',
  `STREET` varchar(256) DEFAULT NULL COMMENT '번지',
  `POB` varchar(256) DEFAULT NULL COMMENT '사서함',
  `ZIPCODE` varchar(64) DEFAULT NULL COMMENT '우편번호',
  `ADDR` varchar(256) DEFAULT NULL COMMENT '주소',
  `HOMEADDR` varchar(256) DEFAULT NULL COMMENT '집주소',
  `HOMEPHONE` varchar(64) DEFAULT NULL COMMENT '집전화',
  `FAX` varchar(64) DEFAULT NULL COMMENT '팩스',
  `PKIDN` varchar(512) DEFAULT NULL COMMENT '인증서 Distinguished Name',
  `PKISN` varchar(100) DEFAULT NULL COMMENT '인증서 Serial Number',
  `EMPLOYMENT_STATUS` int(11) DEFAULT '1' COMMENT '직원 상태',
  `SAML_NAM_ID` varchar(256) DEFAULT NULL COMMENT 'SAML 네임 아이디',
  `NOTES_ID` varchar(256) DEFAULT NULL COMMENT 'NOTES 아이디',
  `MOTP_KEY` varchar(1024) DEFAULT NULL COMMENT '모바일 OTP 생성키\n',
  `USE_IP_CONTROL` varchar(2) DEFAULT NULL COMMENT 'IP 접근제어 사용유무\n',
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자';

CREATE TABLE IF NOT EXISTS `isign_useraccessip` (
  `USID` bigint(8) DEFAULT NULL COMMENT '사용자 SID',
  `IPSID` bigint(8) DEFAULT NULL COMMENT '등록된 아이피 SID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 접근 IP 제어';

CREATE TABLE IF NOT EXISTS `network_conf` (
  `WEBSERVER_IP` varchar(32) NOT NULL,
  `WEBSERVER_PORT` int(11) NOT NULL,
  `WAPPLES_IP` varchar(32) DEFAULT NULL,
  `WAPPLES_PORT` int(11) DEFAULT NULL,
  `SSL` int(11) DEFAULT NULL,
  `SSL_CRT` varchar(1024) DEFAULT NULL COMMENT 'Bit DATA',
  `SSL_KEY` varchar(1024) DEFAULT NULL COMMENT 'Bit DATA',
  `SPHERE_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`WEBSERVER_IP`,`WEBSERVER_PORT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='네트워크 설정 : 미사용';

CREATE TABLE IF NOT EXISTS `network_stat` (
  `OID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'index',
  `DEVICE_NAME` varchar(10) NOT NULL COMMENT '이더넷 이름',
  `STATUS` char(5) DEFAULT NULL COMMENT '이더넷 상태',
  `RX_BYTES` bigint(8) DEFAULT NULL COMMENT '데이터의 총량, 이더넷 인터페이스를 통과한 데이터의 총량을 말함',
  `RX_PACKETS` bigint(8) DEFAULT NULL COMMENT '수신된 패킷의 수',
  `RX_ERRORS` bigint(8) DEFAULT NULL COMMENT '수신된 패킷의 에러 수',
  `RX_DROPPED` bigint(8) DEFAULT NULL COMMENT '수신된 패킷의 드랍 수',
  `RX_FIFO_ERRORS` bigint(8) DEFAULT NULL,
  `RX_COMPRESSED` bigint(8) DEFAULT NULL,
  `RX_MULTICAST` bigint(8) DEFAULT NULL,
  `TX_BYTES` bigint(8) DEFAULT NULL COMMENT '데이터의 총량, 이더넷 인터페이스를 통과한 데이터의 총량을 말함',
  `TX_PACKETS` bigint(8) DEFAULT NULL COMMENT '송신된 패킷의 수',
  `TX_ERRORS` bigint(8) DEFAULT NULL COMMENT '송신된 패킷의 에러 수',
  `TX_DROPPED` bigint(8) DEFAULT NULL COMMENT '송신된 패킷의 드랍 수',
  `TX_FIFO_ERRORS` bigint(8) DEFAULT NULL,
  `TX_CARRIER_ERRORS` bigint(8) DEFAULT NULL,
  `TX_COMPRESSED` bigint(8) DEFAULT NULL,
  `COLLISIONS` bigint(8) DEFAULT NULL COMMENT '네트워크 혼잡도',
  `LOG_TIME` datetime NOT NULL COMMENT '로그 시간',
  `SPHERE_ID` varchar(32) NOT NULL COMMENT '장비 ID',
  `LINK` smallint(8) DEFAULT NULL,
  `NEGOTIATION` varchar(10) DEFAULT NULL COMMENT '랜카드 연결 속도',
  `CONTROLDEV` varchar(10) DEFAULT NULL COMMENT '인터페이스 역활\nservice, control',
  `DUPLEX` smallint(8) DEFAULT NULL,
  PRIMARY KEY (`OID`,`LOG_TIME`,`SPHERE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='시스템 모니터링, 실시간 정보';

CREATE TABLE IF NOT EXISTS `route_table` (
  `DESTINATION` varchar(32) NOT NULL,
  `NETMASK` varchar(32) NOT NULL,
  `GATEWAY` varchar(32) NOT NULL,
  `SPHERE_ID` varchar(32) NOT NULL,
  PRIMARY KEY (`DESTINATION`,`SPHERE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='라우팅 테이블 : 미사용';

CREATE TABLE IF NOT EXISTS `sphere` (
  `ID` varchar(32) NOT NULL,
  `IP` varchar(32) DEFAULT NULL,
  `DESCRIPTION` varchar(32) DEFAULT NULL,
  `GATEWAY` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SPHERE : 미사용';

CREATE TABLE IF NOT EXISTS `system_res` (
  `OID` int(11) NOT NULL AUTO_INCREMENT,
  `CPU1_TEMP` int(11) DEFAULT NULL,
  `CPU2_TEMP` int(11) DEFAULT NULL,
  `MBOARD_TEMP` int(11) DEFAULT NULL,
  `CPU1_FAN` int(11) DEFAULT NULL,
  `CPU2_FAN` int(11) DEFAULT NULL,
  `CPU_USED` int(11) DEFAULT NULL,
  `RAM_USED` int(11) DEFAULT NULL,
  `TIME` datetime DEFAULT NULL,
  PRIMARY KEY (`OID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='시스템 모니터링';

CREATE TABLE IF NOT EXISTS `wapples_ip` (
  `IP` varchar(32) NOT NULL,
  `NETMASK` varchar(32) DEFAULT NULL,
  `SPHERE_ID` varchar(32) NOT NULL,
  PRIMARY KEY (`IP`,`SPHERE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='WAPPLES IP : 미사용';

CREATE TABLE IF NOT EXISTS `isign_log_openapi` (
  `sid` bigint(8) NOT NULL AUTO_INCREMENT COMMENT '로그 테이블의 고유 식별번호 ',
  `id` varchar(128) NOT NULL COMMENT '사용자 아이디 apikey',
  `dttm` datetime NOT NULL COMMENT 'api 요청 시간',
  `ip` varchar(128) NOT NULL COMMENT '요청 클라이언트 IP',
  `url` varchar(256) NOT NULL COMMENT '요청한 url',
  `resultCode` varchar(128) NOT NULL COMMENT '결과 코드 저장',
  `hmac` varchar(64) DEFAULT NULL COMMENT '데이터 위변조 방지',
  PRIMARY KEY (`sid`, `dttm`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='OPENAPI 로그 테이블'
 PARTITION BY RANGE(TO_DAYS(dttm))
(
  PARTITION isign_log_openapi_201702 VALUES LESS THAN (TO_DAYS('2017-02-01')) ENGINE=InnoDB
); 

CREATE TABLE IF NOT EXISTS `isign_log_manager` (
  `log_no` bigint(11) NOT NULL AUTO_INCREMENT COMMENT 'index Key 값',
  `dttm` datetime NOT NULL COMMENT '일시',
  `admin_id` varchar(64) NOT NULL COMMENT '관리자 아이디 값',
  `admin_name` varchar(64) DEFAULT NULL COMMENT '관리자 이름 값',
  `user_ip` varchar(1000) NOT NULL COMMENT '사용자 IP 값',
  `target_information` varchar(1024) NOT NULL DEFAULT '' COMMENT '변경 대상 값',
  `log_code` varchar(20) NOT NULL COMMENT '로그 코드 값',
  `detail` varchar(2048) DEFAULT NULL COMMENT '상세로그 값',
  `hmac` varchar(1000) NOT NULL COMMENT '데이터 위변조 값',
  PRIMARY KEY (`log_no`, `dttm`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='시스템 관리 로그'
 PARTITION BY RANGE(TO_DAYS(dttm))
(
  PARTITION isign_log_manager_201702 VALUES LESS THAN (TO_DAYS('2017-02-01')) ENGINE=InnoDB 
);

CREATE TABLE IF NOT EXISTS `isign_log_session` (
  `log_no` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'index',
  `dttm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '일시',
  `session_id` varchar(64) NOT NULL COMMENT 'Session id',
  `user_id` varchar(128) NOT NULL COMMENT '사용자 ID',
  `agent_service_id` bigint(8) DEFAULT NULL COMMENT 'Agent 서비스 ID',
  `device_info` varchar(64) NOT NULL COMMENT '발생주체의 장비 정보',
  `ip` varchar(64) NOT NULL COMMENT '발생주체의 IP',
  `detail` varchar(16) DEFAULT NULL COMMENT 'login : 로그인, logout : 로그아웃, terminate : 강제 종료',
  `admin_id` varchar(128) DEFAULT NULL COMMENT '관리자 ID',
  `hmac` varchar(64) DEFAULT NULL COMMENT '데이터 위변조 방지',
  PRIMARY KEY (`log_no`, `dttm`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='세션 로그'
 PARTITION BY RANGE(TO_DAYS(dttm))
(
  PARTITION isign_log_session_201702 VALUES LESS THAN (TO_DAYS('2017-02-01')) ENGINE=InnoDB 
);

CREATE TABLE IF NOT EXISTS `isign_log_system` (
  `log_no` bigint(11) NOT NULL AUTO_INCREMENT COMMENT 'index Key 값',
  `dttm` datetime NOT NULL COMMENT '일시',
  `log_code` varchar(20) NOT NULL COMMENT '로그 코드 값',
  `detail` varchar(2048) DEFAULT NULL,
  `hmac` varchar(64) NOT NULL COMMENT '데이터 위변조 값',
  PRIMARY KEY (`log_no`, `dttm`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='시스템 로그'
 PARTITION BY RANGE(TO_DAYS(dttm))
(
  PARTITION isign_log_system_201702 VALUES LESS THAN (TO_DAYS('2017-02-01')) ENGINE=InnoDB 
);

CREATE TABLE IF NOT EXISTS `isign_log_user` (
  `log_no` bigint(11) NOT NULL AUTO_INCREMENT COMMENT 'index Key 값',
  `dttm` datetime NOT NULL COMMENT '일시',
  `user_id` varchar(64) NOT NULL COMMENT '사용자 아이디 값',
  `user_name` varchar(64) DEFAULT NULL COMMENT '사용자 이름 값',
  `agent_service_id` bigint(8) NOT NULL COMMENT '업무시스템 ID 값',
  `user_ip` varchar(64) NOT NULL COMMENT '사용자 IP 값',
  `log_code` varchar(20) NOT NULL COMMENT '로그 코드 값',
  `detail` varchar(2048) DEFAULT NULL COMMENT '상세로그 값',
  `hmac` varchar(64) NOT NULL COMMENT '데이터 위변조 값',
  PRIMARY KEY (`log_no`, `dttm`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 로그'
 PARTITION BY RANGE(TO_DAYS(dttm))
(
  PARTITION isign_log_user_201702 VALUES LESS THAN (TO_DAYS('2017-02-01')) ENGINE=InnoDB 
);

-- 1. create partition manage table
CREATE TABLE t_partition_manage(
    TABLE_NAME VARCHAR(100),
    partition_range VARCHAR(5),
    data_dir VARCHAR(100),
    index_dir VARCHAR(100),
    add_range INT,
    remove_range INT
);

-- 2. 파티션 매니지먼트 로그 테이블 생성
CREATE TABLE t_partition_manage_log(
    sql_text VARCHAR(1024)
);

-- 3. 파티션 메니지먼트 값
-- 용량체크 스크립트가 동작하면서 생성된 테이블을 옮겨버릴수가 있으니 가급적 짧은 주기로 생성한다.
INSERT INTO t_partition_manage(TABLE_NAME,partition_range,data_dir,index_dir,add_range,remove_range) 
VALUES ('isign_log_openapi','month', NULL, NULL, 3, 24);
INSERT INTO t_partition_manage(TABLE_NAME,partition_range,data_dir,index_dir,add_range,remove_range) 
VALUES ('isign_log_manager','month', NULL, NULL, 3, 24);
INSERT INTO t_partition_manage(TABLE_NAME,partition_range,data_dir,index_dir,add_range,remove_range) 
VALUES ('isign_log_system','month', NULL, NULL, 3, 24);
INSERT INTO t_partition_manage(TABLE_NAME,partition_range,data_dir,index_dir,add_range,remove_range) 
VALUES ('isign_log_user','month', NULL, NULL, 3, 24);

-- 4. 파티션 생성 프로시져
DELIMITER //
CREATE PROCEDURE `create_partition`()
BEGIN
  DECLARE tblnm VARCHAR(100) DEFAULT '1'; 
  DECLARE parnm VARCHAR(35) DEFAULT '1'; 
  DECLARE pardate VARCHAR(35) DEFAULT '1'; 
  DECLARE pardatevalue VARCHAR(35) DEFAULT '1'; 
  DECLARE datadir VARCHAR(100) DEFAULT '/opt/penta/data1/mysql'; 
  DECLARE indexdir VARCHAR(100) DEFAULT '/opt/penta/data1/mysql'; 
  DECLARE parrange VARCHAR(35) DEFAULT '1'; 
  DECLARE addrange VARCHAR(35) DEFAULT '1'; 
  DECLARE curdate VARCHAR(35) DEFAULT '1'; 
  DECLARE log VARCHAR(1024) DEFAULT '1'; 
  DECLARE cur_state INT DEFAULT 0;
  DECLARE i INT DEFAULT 1;
  DECLARE iter INT DEFAULT 1;
 
  -- SELECT Partition Info
    DECLARE cur CURSOR FOR select src.tbl_nm, src.par_nm, src.par_date, src.par_range,  -- !! WIKI 업로드시 에러 발생 시켜 주석 처리함!! 사용시 해제 --
    src.data_dir data_dir,src.index_dir index_dir, src.add_range - period_diff(src.par_date,src.cur_date) add_range , src.cur_date
    FROM (
      SELECT w.TABLE_NAME tbl_nm,
        MAX(IF(t.partition_range LIKE 'year',
               SUBSTR((w.PARTITION_NAME),1, LENGTH(w.PARTITION_NAME)-4),
               concat(SUBSTR((w.PARTITION_NAME), 1, LENGTH(w.PARTITION_NAME)-6)))) par_nm,
        MAX(IF(t.partition_range LIKE 'year',
               SUBSTR((w.PARTITION_NAME), LENGTH(w.PARTITION_NAME)-3,4),
               concat(SUBSTR((w.PARTITION_NAME), LENGTH(w.PARTITION_NAME)-5,6)))) par_date,
        t.partition_range par_range,
        t.data_dir data_dir,
        t.index_dir index_dir,
        t.add_range add_range,
        IF(t.partition_range LIKE 'year' , YEAR(now()), DATE_FORMAT(now(), '%Y%m') ) cur_date
      FROM INFORMATION_SCHEMA.PARTITIONS w, t_partition_manage t
      WHERE w.TABLE_NAME = t.TABLE_NAME
      GROUP BY w.TABLE_NAME) src
      WHERE period_diff(src.par_date,src.cur_date) < add_range;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cur_state = 1;
 
  -- Create Partition
  OPEN cur;
  REPEAT
   FETCH cur INTO tblnm, parnm, pardate, parrange, datadir, indexdir, addrange, curdate;
   IF NOT cur_state THEN
     SET i = 1; 
     WHILE i <= addrange DO
 
       IF parrange = 'year' THEN
        SET pardate = pardate+1; 
        SET @sql_text = concat('alter table ', tblnm, 
        ' add partition ( partition ', parnm, pardate, 
        ' values less than ( ', pardate+1, ' ) ENGINE=INNODB )');
 
       ELSEIF parrange = 'month' THEN
        IF SUBSTR(pardate+1,5,2) = 12 THEN 
          SET pardate = pardate+1; 
          SET pardatevalue = concat(SUBSTR(pardate+1,1,4)+1,'01'); 
        ELSEIF SUBSTR(pardate+1,5,2) = 13 THEN 
          SET pardate = concat(SUBSTR(pardate+1,1,4)+1,'01'); 
          SET pardatevalue = pardate+1; 
        ELSE
          SET pardate = pardate+1; 
          SET pardatevalue = pardate+1; 
        END IF;
 
        SET @sql_text = concat('alter table ', tblnm, 
        ' add partition ( partition ', parnm, pardate, 
        ' values less than ( TO_DAYS(', pardatevalue, '01 )) ENGINE=INNODB )');
       END IF;
 
       INSERT t_partition_manage_log VALUES (@sql_text);
       PREPARE stmt FROM @sql_text;
       EXECUTE stmt;
       DEALLOCATE PREPARE stmt;   
       SET i = i + 1; 
     END WHILE;
   END IF;
  UNTIL cur_state END REPEAT;
  CLOSE cur;
 
  SET @log = concat(now(),': create_partition called');
  INSERT t_partition_manage_log VALUES (@log);
END //


-- 5. 파티션 삭제 프로시져
CREATE PROCEDURE `drop_partition`()
BEGIN
  DECLARE tblnm VARCHAR(35) DEFAULT '1'; 
  DECLARE parnm VARCHAR(35) DEFAULT '1'; 
  DECLARE log VARCHAR(1024) DEFAULT '1'; 
  DECLARE cur_state INT DEFAULT 0;
 
  DECLARE cur CURSOR FOR select src.tbl_nm, src.par_nm  -- !! WIKI 업로드시 에러 발생 시켜 주석 처리함!! 사용시 해제 --
  FROM(
    SELECT w.TABLE_NAME tbl_nm,
    w.PARTITION_NAME par_nm,
    IF(t.partition_range LIKE 'year',
       SUBSTR((w.PARTITION_NAME), LENGTH(w.PARTITION_NAME)-3,4), 
       concat(SUBSTR((w.PARTITION_NAME), LENGTH(w.PARTITION_NAME)-5,6))) par_date,
    t.partition_range par_range,
    t.add_range add_range,
    t.remove_range rem_range,
    IF(t.partition_range LIKE 'year' , YEAR(now()), DATE_FORMAT(now(), '%Y%m') ) cur
    FROM INFORMATION_SCHEMA.PARTITIONS w, t_partition_manage t
    WHERE w.TABLE_NAME = t.TABLE_NAME) src
  WHERE src.par_date < src.cur - src.rem_range;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cur_state = 1;
 
  OPEN cur;
  REPEAT
   FETCH cur INTO tblnm, parnm;
   IF NOT cur_state THEN
     SET @sql_text = concat('alter table ', tblnm, ' drop partition ', parnm ); 
     PREPARE stmt FROM @sql_text;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;   
     INSERT t_partition_manage_log VALUES (@sql_text);
   END IF;
  UNTIL cur_state END REPEAT;
  CLOSE cur;
 
  SET @log = concat(now(),': drop_partition called');
  INSERT t_partition_manage_log VALUES (@log);
END //


-- 6. 프로시져 호출 이벤트 
-- 7. 파티션 관리 프로시저 수행 이벤트
CREATE EVENT IF NOT EXISTS partition_manager
    ON SCHEDULE
        EVERY 1 DAY
        STARTS CURRENT_TIMESTAMP
    DO
    BEGIN
     CALL create_partition();
     CALL drop_partition();
    END;
    //
