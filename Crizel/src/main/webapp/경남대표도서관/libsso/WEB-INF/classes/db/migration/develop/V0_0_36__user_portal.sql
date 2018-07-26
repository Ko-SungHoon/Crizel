CREATE TABLE IF NOT EXISTS `isign_motp_temporary_number` (
  `sid` BIGINT(8) NOT NULL COMMENT '사용자 고유 식별 번호',
  `no` INT NOT NULL COMMENT '순서',
  `temporary_motp_number` varchar(20) NOT NULL COMMENT '임시 MOTP 번호',
  `used` varchar(1) NOT NULL COMMENT '사용 유무(0: 사용안함, 1:사용함)',
  PRIMARY KEY (`sid`, `no`))
ENGINE = InnoDB
COMMENT = '임시 MOTP 번호';


CREATE TABLE IF NOT EXISTS `isign_password_question_answer` (
  `sid` BIGINT(8) NOT NULL COMMENT '사용자 고유 식별 번호',
  `question` varchar(200) NOT NULL COMMENT '질문',
  `answer` varchar(200) NOT NULL COMMENT '답변',
  PRIMARY KEY (`sid`))
ENGINE = InnoDB
COMMENT = '보안 질문/답변';

ALTER TABLE `isign_service` DROP STYPE;
ALTER TABLE `isign_service` DROP PATHURL;
ALTER TABLE `isign_service` ADD COLUMN `SERVICE_TYPE` varchar(128) COMMENT '서비스 유형'  AFTER `DESCR`;
ALTER TABLE `isign_service` ADD COLUMN `SHORT_CUT_URL` varchar(128) COMMENT '바로가기 URL'  AFTER `RETURNURL`;