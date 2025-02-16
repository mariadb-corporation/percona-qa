CREATE TABLE t1 (id int, a int, KEY id (id), KEY (a)) partition BY list (id) (PARTITION p1 VALUES IN (1,2,3,4,5,6,7,8,9,10 ));
INSERT INTO t1 VALUES (1,5),(2,3),(3,7),(4,2),(5,7),(6,4),(7,9),(8,7),(9,NULL),(10,NULL);
SELECT  * FROM t1 WHERE id IN (255) OR a IN (25,1);

CREATE TABLE t (c INT) PARTITION BY LIST (c) (PARTITION p VALUES IN (NULL));
ALTER TABLE t ADD KEY(c);
DELETE FROM t WHERE c=0;
