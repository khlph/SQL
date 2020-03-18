/*

CREATE PROCEDURE SelectTagpath @path_name varchar(max),
							@start_time varchar(100),
							@end_time varchar(100)
*/


DECLARE @start_time varchar(100);
SET @start_time = '2020-01-01';

DECLARE @end_time varchar(100);
SET @end_time = '2020-02-29';

DECLARE @path_name varchar(max);
SET @path_name = 'cm2/feeder/cli_feed';

select DATEDIFF_BIG(ms, '1970-01-01', format(convert(datetime, @start_time), 'yyyy-MM-01'))-25200000 as start_time, 
DATEDIFF_BIG(ms, '1970-01-01', dateadd(month, 1, format(convert(datetime, @end_time), 'yyyy-MM-01')))-25200000 as end_time

DECLARE partition cursor local for 
	select distinct pname from ( Select distinct scid from sqlth_te where tagpath = @path_name) te
		INNER JOIN sqlth_scinfo as scinfo ON te.scid = scinfo.id
		INNER JOIN sqlth_drv as drv on scinfo.drvid = drv.id
		INNER JOIN sqlth_partitions as partitions_table on drv.id -1 = partitions_table.drvid 
		where start_time >= DATEDIFF_BIG(ms, '1970-01-01', format(convert(datetime, @start_time), 'yyyy-MM-01'))-25200000
			and end_time <= DATEDIFF_BIG(ms, '1970-01-01', dateadd(month, 1, format(convert(datetime, @end_time), 'yyyy-MM-01')))-25200000
		-- Start and end time manage to select the partition even the intervals weren't during a month
		-- However 25200000 was fixed due database store in UTC 

-- Declare Temporary Table (Structure same as the partitions) 
	DECLARE @return_table TABLE (
			[t_stamp] datetime,
			[value] float,
			[tagid] int
			)

DECLARE @temp_partition varchar(255);
DECLARE @interval AS nvarchar(5) = 15
DECLARE @date as NVARCHAR(200) = 'dateadd(minute, (datediff(minute, 0, 
									dateadd(s, convert(bigint, t_stamp)/1000, 
									convert(datetime, ''1-1-1970 00:00:00'')))/ '+@interval+') * '+@interval+', 0)';
OPEN partition;
	FETCH NEXT FROM partition INTO @temp_partition
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--select @temp_partition
			exec ('select ' + @date + ' as t_stamp, avg(floatvalue) as "value", [partition].[tagid] as "tagid"
			from ' + @temp_partition + ' as [partition] inner join [sqlth_te] as [te] on [te].[id] = [partition].[tagid] 
			where [t_stamp] between [dbo].[return_date]('''+@start_time+''') and [dbo].[return_date]('''+@end_time+''') 
			group by ' + @date + ', tagid')
			FETCH NEXT FROM partition INTO @temp_partition
		END
CLOSE partition;

--SELECT * from @return_table order by t_stamp DESC
--SELECT * from sqlth_te where tagpath IN (@path_name);

-- From 
-- Monday, January 6, 2020 10:12:28.525 PM
-- 
-- January 7, 2020 4:45:18.529 AM 
--GO;
--DECLARE @tags CURSOR;
--SET @tags = CURSOR FOR (SELECT id FROM [EC_DB].[dbo].[sqlth_te] where tagpath IN (@path_name);