INSTALL PLUGIN Spider SONAME 'ha_spider.so';
CREATE TABLE t (c INT) ENGINE=Spider;
LOCK TABLES t WRITE CONCURRENT;
SHOW TABLES;
INSERT INTO t VALUES (2);
