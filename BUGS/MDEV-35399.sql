SET @@big_tables=TRUE;
CREATE TABLE t (a INT KEY,b VARCHAR(2048)) ;
SELECT * FROM (WITH t AS ((SELECT * FROM t) UNION (SELECT * FROM t WHERE a>3) LIMIT 3) ((SELECT a FROM t WHERE a=4 UNION SELECT a FROM t WHERE a=7) ORDER BY a)) AS dt;
