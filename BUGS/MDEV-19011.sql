USE test;
CREATE TABLE t(a POINT GENERATED ALWAYS AS (POINT(1,1)) VIRTUAL, UNIQUE INDEX i(a(1))) ENGINE=MyISAM;
REPAIR LOCAL TABLE t;

CREATE TABLE t1 (a INT GENERATED ALWAYS AS (1) VIRTUAL) ENGINE=MyISAM;
ALTER TABLE t1 ADD KEY (a);

USE test;
CREATE TABLE t(c TEXT GENERATED ALWAYS AS (1) VIRTUAL, INDEX i(c(1))) ENGINE=MyISAM;
OPTIMIZE TABLE t;
