CREATE TABLE t1(id INT,a CHAR,b TEXT);
BINLOG 'AMqaOw8BAAAAdAAAAHgAAAAAAAQANS42LjM0LTc5LjEtZGVidWctbG9nAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAEzgNAAgAEgAEBAQEEgAAXAAEGggAAAAICAgCAAAACgoKGRkAAYVx w2w=';
BINLOG 'wlZOTxMBAAAAKgAAADwCAAAAACkAAAAAAAEABHRlc3QAAnQxAAIDAwAC wlZOTxcBAAAAJgAAAGICAAAAACkAAAAAAAEAAv/8AgAAAAgAAAA=';

# Will result in the CLI: "ERROR 1105 (HY000): Unknown error" and "[ERROR]  BINLOG_BASE64_EVENT: Column 1 of table 'test.t1' cannot be converted from type 'int' to type 'char(1 octets) character set latin1', Internal MariaDB error code: 1677" in the error log, likely as a result of using an impossible BINLOG command sequence which could never have been generated by the master in the first place
