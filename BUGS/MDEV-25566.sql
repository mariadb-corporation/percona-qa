CREATE EVENT EVENT2 ON SCHEDULE AT current_timestamp ON COMPLETION NOT PRESERVE DO SELECT 1;
SET GLOBAL wsrep_cluster_address='';
SET GLOBAL event_scheduler=1;
SELECT SLEEP(1);
SELECT SLEEP(1);
SELECT SLEEP(1);
