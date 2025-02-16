SET SESSION lc_time_names=zh_hk;
CREATE TABLE t (c CHAR,cc TEXT AS (CONCAT (c,IF(c=c,DATE_FORMAT(c,''),'')))) ENGINE=InnoDB;
SET NAMES utf8;
INSERT INTO t VALUES (0,0);
INSERT INTO t VALUES (0,0);
INSERT INTO t VALUES (0,0);

SET NAMES gbk;
CREATE TABLE t (id INT,js CHAR,t TIME AS (CAST(JSON_VALUE (JSON_EXTRACT(js,CONCAT ('',DAYNAME (curDATE()))),'') AS TIME)) VIRTUAL);
UPDATE t SET name='U +0B HIRAGANA LETTER HO';
INSERT INTO t VALUES (0,0);
INSERT INTO t SELECT 0 t;

SET NAMES utf8;
CREATE TABLE t (c1 DATE NOT NULL,c2 TEXT AS (IF(c1=c1,DATE_FORMAT(c1,''),'')));
SHOW CREATE TABLE t;
INSERT INTO t (a) VALUES (1);

CREATE TABLE t (d1 DATE NOT NULL,d2 DATE NOT NULL,gd TEXT AS (CONCAT (d1,IF(d1=d2,DATE_FORMAT(d2,0),0))));
SELECT * FROM (SELECT f2 AS a FROM t UNION SELECT f3 FROM t) t;
SET collation_connection=ucs2_general_ci;
INSERT INTO t (b) SELECT * FROM t;
