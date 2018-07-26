DELETE FROM isign_config where config_key = 'SESSION_ADMIN_SESSION_TIME_OUT_N';
DELETE FROM isign_config where config_key = 'SESSION_MANAGE_SESSION_TIME_OUT_N';
INSERT INTO isign_config(`config_key`, `config_value`) VALUES ('SESSION_ADMIN_SESSION_TIME_OUT_N', '10');
INSERT INTO isign_config(`config_key`, `config_value`) VALUES ('SESSION_MANAGE_SESSION_TIME_OUT_N', '10');