CREATE TABLE t (c INT,INDEX (c)) TRANSACTIONAL=1;
INSERT INTO t VALUES (1);
SELECT COLUMN_JSON(c) FROM t;
SHUTDOWN;

CREATE TABLE t (a INT,b INT) ENGINE=InnoDB;
INSERT INTO t VALUES (0,0);
SELECT COLUMN_JSON(b) FROM t;
SHUTDOWN;
