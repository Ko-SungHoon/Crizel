DELETE FROM isign_session;
ALTER TABLE isign_session DROP PRIMARY KEY, ADD PRIMARY KEY(`session_id`);