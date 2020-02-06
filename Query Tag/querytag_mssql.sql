/*

CREATE PROCEDURE SelectTagpath @path_name varchar(max),
							@start_time varchar(100),
							@end_time varchar(100)
*/


DECLARE @start_time varchar(100);
SET @start_time = '2019-12-25';

DECLARE @end_time varchar(100);
SET @end_time = '2020-01-26';

DECLARE @path_name varchar(max);
SET @path_name = 'cm2/feeder/cli_feed';

DECLARE partition cursor local for 
	select distinct pname from ( Select distinct scid from sqlth_te where tagpath = @path_name) te
		INNER JOIN sqlth_scinfo as scinfo ON te.scid = scinfo.id
		INNER JOIN sqlth_drv as drv on scinfo.drvid = drv.id
		INNER JOIN sqlth_partitions as partitions_table on drv.id -1 = partitions_table.drvid where start_time >= '1577811600000' and end_time <= '1580490000000';

-- Declare Temporary Table (Structure same as the partitions) 
DECLARE @return_table TABLE (
	[tagid] int,
	[intvalue] bigint,
	[floatvalue] float,
	[stringvalue] [varchar](255),
	[datevalue] [datetime] ,
	[dataintegrity] [int] ,
	[t_stamp] [bigint])

DECLARE @temp_partition varchar(255);
DECLARE @sql AS NVARCHAR(max) 
OPEN partition;
	FETCH NEXT FROM partition INTO @temp_partition
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @sql = N'SELECT * FROM '
			INSERT INTO @return_table
			exec (@sql + @temp_partition + ' WHERE tagid IN
			(SELECT id FROM sqlth_te where tagpath IN (@path_name))')
			FETCH NEXT FROM partition INTO @temp_partition
		END
CLOSE partition;

SELECT * from @return_table order by t_stamp DESC
--SELECT * from sqlth_te where tagpath IN (@path_name);
-- From 
-- Monday, January 6, 2020 10:12:28.525 PM
-- to 
-- January 7, 2020 4:45:18.529 AM 
--GO;

--DECLARE @tags CURSOR;
--SET @tags = CURSOR FOR (SELECT id FROM [EC_DB].[dbo].[sqlth_te] where tagpath IN (@path_name);