set @path_name := "cm1/feeder/rda_feed";

-- Select scid from sqlth_te
-- 	INNER JOIN sqlth_scinfo as scinfo ON te.scid = scinfo.id
-- 	INNER JOIN sqlth_drv as drv on scinfo.drvid = drv.id
-- 	INNER JOIN sqlth_partitions as partitions_table on drv.id -1 = partitions_table.drvid 
--     where tagpath = @path_name
-- create function sqlth_partition()
-- returns cursor
-- begin
-- 	declare cursors cursor for 
-- 		select distinct pname from (
-- 		Select distinct scid from sqlth_te where tagpath = @path_name) te
-- 			INNER JOIN sqlth_scinfo as scinfo ON te.scid = scinfo.id
-- 			INNER JOIN sqlth_drv as drv on scinfo.drvid = drv.id
-- 			INNER JOIN sqlth_partitions as partitions_table on drv.id -1 = partitions_table.drvid
-- 						where start_time >= '1577811600000' and end_time <= '1580490000000';
-- end;
CREATE PROCEDURE get_tag()
BEGIN
	DECLARE partitions varchar(50);
	DECLARE kuy cursor for 
		select distinct pname from (
				Select distinct scid from sqlth_te where tagpath = @path_name) te
					INNER JOIN sqlth_scinfo as scinfo ON te.scid = scinfo.id
					INNER JOIN sqlth_drv as drv on scinfo.drvid = drv.id
					INNER JOIN sqlth_partitions as partitions_table on drv.id -1 = partitions_table.drvid
								where start_time >= '1577811600000' and end_time <= '1580490000000';
                                
	OPEN kuy;
	FETCH kuy INTO partitions;
    select partitions;
    CLOSE kuy;
END//

DELIMITER ;                    
