INSTALL PLUGIN Spider SONAME 'ha_spider.so';
CREATE SERVER srv FOREIGN DATA WRAPPER MYSQL OPTIONS (SOCKET '../socket.sock',DATABASE 'test',user 'Spider',PASSWORD'');
CREATE TABLE t (c INT,c2 TEXT) ENGINE=InnoDB;
INSERT INTO t VALUES (0,'a'),(1,'b'),(2,'c');
CREATE TABLE t2 (c INT KEY,c2 TEXT) ENGINE=Spider COMMENT='WRAPPER "mysql",SRV "srv",TABLE "t"';
SELECT HEX (c2) FROM t2 WHERE c=0;
