INSTALL PLUGIN Spider SONAME 'ha_spider.so';
CREATE TABLE t (c INT) ENGINE=InnoDB;
LOCK TABLES t WRITE;
CREATE OR REPLACE TABLE t (d INT) ENGINE=Spider PARTITION BY LIST COLUMNS (d) (PARTITION p VALUES IN (0));
