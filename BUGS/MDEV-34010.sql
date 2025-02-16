# Requires m/s with --slave-parallel-threads=10 --slave_skip_errors=ALL on the slave and --log_bin=binlog --binlog_format=MIXED on the master (or =STATEMENT). RBR does not reproduce the issue. Sporadic
set sql_mode='';
CREATE TABLE t (c YEAR KEY);
INSERT INTO t VALUES (ST_GEOMFROMTEXT ('POINT(1 1)'));
DELETE FROM t WHERE c IN (SELECT 1) LIMIT 2;
INSERT INTO t VALUES (1)

SET sql_mode='';
CREATE TABLE t (f INT) ENGINE=mrg_innodb UNION (t);
CREATE TEMPORARY TABLE t (i INT) ENGINE=InnoDB;
CREATE TABLE t2 (c1 CHAR(1)) ENGINE=InnoDB;
DROP TABLE IF EXISTS t,mysqlt,mysqlt2;
INSERT INTO t VALUES (1);
DELETE FROM t WHERE f=29;
INSERT INTO t2 VALUES (1);

SET sql_mode='';
CREATE TABLE t (c INT);
INSERT INTO t VALUES (0);
UPDATE t SET c=REPEAT (0,0) WHERE c=REPEAT (0,0);
INSERT INTO t VALUES (0);

CREATE TABLE t0 (a BLOB) ;
CREATE TABLE t3 (a TINYINT,b INT,c CHAR(0),d VARCHAR(0),e VARCHAR(0),f VARBINARY(0),g MEDIUMBLOB,h BLOB,id BIGINT,KEY(b),KEY(e)) ;
SET SESSION autocommit=0;
DELETE FROM t0;
CREATE TABLE t3 (a INT,b INT UNSIGNED,c BINARY (0),d VARCHAR(0),e VARBINARY(0),f VARCHAR(0),g MEDIUMBLOB,h MEDIUMBLOB,id BIGINT,KEY(b),KEY(e)) ;
INSERT INTO mysql.user SELECT * FROM t0;
INSERT INTO t0 VALUES (0xCFD0);
SELECT REPEAT (
ALTER TABLE t CHANGE COLUMN c c BINARY (0);
INSERT INTO t0 VALUES (1);
ALTER TABLE t CHANGE COLUMN a a BINARY (0);
