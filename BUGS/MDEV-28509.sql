CREATE TABLE v1054 ( v1055 INT ) ;
 INSERT INTO v1054 ( v1055 ) VALUES ( 54 ) ;
 UPDATE v1054 SET v1055 = 127 WHERE v1055 = 83 ;
 INSERT INTO v1054 ( v1055 ) VALUES ( -1 ) , ( -1 ) ;
 WITH v1057 AS ( SELECT v1055 FROM ( SELECT v1055 FROM v1054 GROUP BY v1055 ) AS v1056 ) SELECT v1055 FROM v1057 WHERE v1055 BETWEEN FALSE AND ( ( ( v1055 OR NOT v1055 ) BETWEEN ( ( ( ( EXISTS ( WITH v1063 AS ( SELECT v1055 FROM ( SELECT v1055 FROM v1054 GROUP BY v1055 ) AS v1058 WINDOW v1062 AS ( PARTITION BY v1055 ORDER BY ( SELECT DISTINCT 16 FROM v1054 AS v1059 , v1054 AS v1060 , v1054 AS v1061 JOIN v1054 ) DESC RANGE BETWEEN 80808358.000000 FOLLOWING AND 82012945.000000 FOLLOWING ) ) SELECT v1055 FROM ( SELECT DISTINCT ( ( NOT ( 60914711.000000 AND v1055 = 68 ) ) = -1 AND v1055 = 17 ) % v1055 , ( v1055 = -1 OR v1055 > 'x' ) FROM v1054 WHERE v1055 = -128 AND ( v1055 = -128 OR v1055 = 0 OR v1055 = 31 ) ) AS v1064 NATURAL JOIN v1063 AS v1065 NATURAL JOIN v1063 AS v1066 NATURAL JOIN ( SELECT DISTINCT v1055 , ( v1055 = -1 OR v1055 > 'x' ) FROM v1054 ) AS v1067 NATURAL JOIN v1063 AS v1068 NATURAL JOIN v1063 WHERE v1055 != 72 GROUP BY v1055 ORDER BY v1055 ) AND v1055 = -1 ) - 2147483647 ) ) ) AND 'x' = ( 4 + 34235093.000000 <= 60 ) ) ) ;

CREATE TABLE t1 (i int) ;
INSERT INTO t1 VALUES (1),(2),(3) ;
WITH cte AS (SELECT i FROM (SELECT i FROM t1 GROUP BY i) dt WINDOW w AS (PARTITION BY i)) SELECT a.i FROM cte a JOIN cte b on a.i=b.i WHERE a.i != 5 ;

WITH c AS (SELECT i FROM (SELECT i FROM (SELECT 1 AS i) AS i GROUP BY i) d WINDOW w AS (PARTITION BY i)) SELECT a.i FROM c a JOIN c b on a.i=b.i WHERE a.i!=1;
