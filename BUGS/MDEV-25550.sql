SET DEBUG_DBUG='+d,innodb_alter_table_pk_assert_no_sort';
CREATE TABLE t1(c1 TIMESTAMP) ENGINE=INNODB;
CREATE UNIQUE INDEX i12 ON t1(c1);
