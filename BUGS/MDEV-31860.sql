INSTALL PLUGIN Spider SONAME 'ha_spider.so';
CREATE USER Spider@localhost IDENTIFIED BY '';
CREATE SERVER srv FOREIGN DATA WRAPPER MYSQL OPTIONS (SOCKET '../socket.sock',DATABASE 'test',user 'Spider',PASSWORD '');
CREATE TABLE t (c INT) ENGINE=InnoDB;
CREATE TABLE t1 (c INT) ENGINE=Spider COMMENT='WRAPPER "mysql",srv "srv",TABLE "t"';
INSERT INTO t VALUES (1),(2),(3);
SET SESSION spider_quick_page_size=1;
HANDLER t1 OPEN;
HANDLER t1 READ NEXT;
CREATE TABLE t1 (c INT) ENGINE=Spider COMMENT='WRAPPER "mysql",srv "srv",TABLE "t"';
