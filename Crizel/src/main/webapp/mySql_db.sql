CREATE TABLE ANI(
ANI_ID	INT,
TITLE	VARCHAR(100 ),
ANI_TIME	VARCHAR(100 ),
DAY	VARCHAR(100 ),
KEYWORD	VARCHAR(100 ),
SITE	VARCHAR(30 ),
LAST_TITLE VARCHAR(255),
DIRECTORY VARCHAR(255)
);


CREATE TABLE BOARD(
B_NO INT PRIMARY KEY,
PARENT_B_NO INT,
B_LEVEL INT,
TITLE VARCHAR(255),
USER_NICK VARCHAR(255),
USER_ID VARCHAR(255),
CONTENT TEXT,
VIEW_COUNT INT,
NOTICE CHAR,
SECRET CHAR,
PASSWORD VARCHAR(255),
REGISTER_DATE DATE,
MODIFY_DATE DATE,
DELETE_STATUS CHAR,
TMP_FIELD1 VARCHAR(255),
TMP_FIELD2 VARCHAR(255),
TMP_FIELD3 VARCHAR(255),
TMP_FIELD4 VARCHAR(255),
TMP_FIELD5 VARCHAR(255),
TMP_FIELD6 VARCHAR(255),
TMP_FIELD7 VARCHAR(255),
TMP_FIELD8 VARCHAR(255),
TMP_FIELD9 VARCHAR(255),
TMP_FIELD10 VARCHAR(255)
);

CREATE TABLE BOARD_COMMENT(
C_NO INT PRIMARY KEY,
B_NO INT,
USER_NICK VARCHAR(255),
CONTENT TEXT,
C_GROUP INT,
C_LEVEL INT,
REGISTER_DATE DATE,
DELETE_STATUS CHAR
);

CREATE TABLE BOARD_FILE(
F_NO INT PRIMARY KEY,
B_NO INT,
DIRECTORY VARCHAR(255),
SAVE_NAME VARCHAR(255),
REAL_NAME VARCHAR(255)
);

CREATE TABLE INSTA(
NAME	VARCHAR(100 ),
ADDR	VARCHAR(100 )
);

CREATE TABLE LOGIN(
ID	VARCHAR(100 ),
PW	VARCHAR(100 ),
NAME	VARCHAR(100 ),
EMAIL	VARCHAR(100 ),
PHONE	VARCHAR(100 ),
NICK	VARCHAR(100 ),
REGISTER	VARCHAR(100 )
);

CREATE TABLE MONEY(
MONEY_ID	INT,
ITEM		VARCHAR(150 ),
PRICE		INT,
DAY			VARCHAR(20 ),
ID			VARCHAR(60 ),
YEAR 		VARCHAR(50),
MONTH 		VARCHAR(50)	
);

CREATE TABLE TWITTER(
NAME	VARCHAR(100 ),
ADDR	VARCHAR(100 )
);

CREATE TABLE DIARY
(
    DIARY_ID         INT    NOT NULL, 
    DIARY_DATE       DATE      NULL, 
    CONTENT          TEXT      NULL, 
    DELETE_STATUS    CHAR      NULL, 
    CONSTRAINT DIARY_PK PRIMARY KEY (DIARY_ID)
);

CREATE TABLE GIRLS
(
    G_ID    INT           NOT NULL, 
    NAME    VARCHAR(50)     NULL, 
    ADDR    VARCHAR(255)    NULL, 
    TYPE    VARCHAR(50)     NULL, 
    TAG1    VARCHAR(50)     NULL,
    TAG2    VARCHAR(50)     NULL,
    CONSTRAINT GIRLS_PK PRIMARY KEY (G_ID)
);

CREATE TABLE COMIC(
  COMIC_ID INT,
  TITLE VARCHAR(255),
  ADDR VARCHAR(255),
  ADDR2 VARCHAR(255)
);


CREATE TABLE COMIC_CHECK(
  CHECK_ID INT,
  TITLE VARCHAR(255),
  ADDR VARCHAR(255),
  REGISTER_DATE DATE
);

CREATE TABLE ONEJAV(
NO INT,
DAY VARCHAR(20),
TITLE VARCHAR(255),
ADDR VARCHAR(255),
IMG VARCHAR(255),
NAME VARCHAR(255)
);
