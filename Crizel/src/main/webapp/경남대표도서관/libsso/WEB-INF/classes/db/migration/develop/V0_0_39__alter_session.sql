ALTER TABLE `isign_session` ADD COLUMN `token` varchar(255) COMMENT '토큰' AFTER `token_seq`;
ALTER TABLE `isign_session` ADD COLUMN `authorized_auth_types` varchar(255) COMMENT '인증 받은 인증 타입(예 : idpw,pki,otp)' AFTER `ip`;