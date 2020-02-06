-- /*

-- CREATE PROCEDURE SelectTagpath @path_name varchar(max),
-- 							@start_time varchar(100),
-- 							@end_time varchar(100)
-- */


-- DECLARE @start_time varchar(100);
-- SET @start_time = '2019-11-25';

-- DECLARE @end_time varchar(100);
-- SET @end_time = '2019-11-26';

-- DECLARE @path_name varchar(max);
-- SET @path_name = 'cm1/roller press/roller_drive_pres';

-- DECLARE @partitions CURSOR;
-- SET @partitions = CURSOR FOR (Select distinct pname from 
-- 				(Select scid from [EC_DB].[dbo].[sqlth_te] where tagpath IN (@path_name)) te
-- 	INNER JOIN [EC_DB].[dbo].[sqlth_scinfo] as scinfo ON te.scid = scinfo.id
-- 	INNER JOIN [EC_DB].[dbo].[sqlth_drv] as drv on scinfo.drvid = drv.id
-- 	INNER JOIN [EC_DB].[dbo].[sqlth_partitions] as partitions_table on drv.id -1 = partitions_table.drvid					
-- 					where start_time >= DATEDIFF_BIG(ms, '1970-01-01', format(convert(datetime, @start_time), 'yyyy-MM-01'))-25200000
-- 					and end_time <= DATEDIFF_BIG(ms, '1970-01-01', dateadd(month, 1, format(convert(datetime, @end_time), 'yyyy-MM-01')))-25200000)

DECLARE @path_name varchar(max); 
set @path_name = 'cm1/feeder/gyp_feed'

DECLARE sqlth_partitions cursor for 
	select distinct pname from ( Select distinct scid from sqlth_te where tagpath = @path_name) te
		INNER JOIN sqlth_scinfo as scinfo ON te.scid = scinfo.id
		INNER JOIN sqlth_drv as drv on scinfo.drvid = drv.id
		INNER JOIN sqlth_partitions as partitions_table on drv.id -1 = partitions_table.drvid where start_time >= '1577811600000' and end_time <= '1580490000000';



DECLARE @return_table TABLE (
	[tagid] int,
	[intvalue] bigint,
	[floatvalue] float,
	[stringvalue] [varchar](255),
	[datevalue] [datetime] ,
	[dataintegrity] [int] ,
	[t_stamp] [bigint]);

-- -- Declare Temporary Table (Structure same as the partitions) 
-- DECLARE @return_table TABLE (
-- 	[tagid] int,
-- 	[intvalue] bigint,
-- 	[floatvalue] float,
-- 	[stringvalue] [varchar](255),
-- 	[datevalue] [datetime] ,
-- 	[dataintegrity] [int] ,
-- 	[t_stamp] [bigint])

-- DECLARE @temp_partition varchar(255);
-- OPEN @partitions;
-- 	FETCH NEXT FROM @partitions INTO @temp_partition
-- 	WHILE @@FETCH_STATUS = 0
-- 		BEGIN
-- 			INSERT @return_table
-- 			EXEC ('SELECT * from [EC_DB].[dbo].' + @temp_partition + '
-- 					WHERE tagid IN (SELECT id FROM [EC_DB].[dbo].[sqlth_te] where tagpath IN (' + @path_name + '))
-- 					and t_stamp BETWEEN DATEDIFF_BIG(ms, ''1970-01-01'', ' + @start_time + ') 
-- 					and DATEDIFF_BIG(ms, ''1970-01-01'',  ' + @end_time + ');')
-- 			FETCH NEXT FROM @partitions INTO @temp_partition
-- 		END

-- SELECT * from @return_table order by t_stamp DESC
-- SELECT * from [EC_DB].[dbo].[sqlth_te] where tagpath IN (@path_name);

-- --GO;

-- --DECLARE @tags CURSOR;
-- --SET @tags = CURSOR FOR (SELECT id FROM [EC_DB].[dbo].[sqlth_te] where tagpath IN (@path_name);