/****** Script for SelectTopNRows command from SSMS  ******/
/*
declare @second int;
set @second = 60; 
  GROUP BY FLOOR(t_stamp/10000)
--*/
------------------------------------------------------
--GROUP BY
--  FLOOR(DATEDIFF(second, '1970-01-01', t_stamp)/1800)*1800
SELECT floatvalue, dateadd(s, convert(bigint, t_stamp)/1000, convert(datetime, '1-1-1970 00:00:00')) as t_stamp
  FROM [swcc_db].[dbo].[sqlt_data_1_2020_01] 
  where t_stamp between 1578346898532 and 1578347118529 order by t_stamp

declare @Interval int
set @Interval = 1
select dateadd(minute, (datediff(minute, 0, dateadd(s, convert(bigint, t_stamp)/1000, convert(datetime, '1-1-1970 00:00:00'))) / @Interval) * @Interval, 0), avg(floatvalue) as value
from sqlt_data_1_2020_01 where t_stamp between 1578346898532 and 1578347118529
group by dateadd(minute, (datediff(minute, 0, dateadd(s, convert(bigint, t_stamp)/1000, convert(datetime, '1-1-1970 00:00:00'))) / @Interval) * @Interval, 0), tagid


-- Interval in minutes    
/*
declare @Interval int
set @Interval = 1

select count(*) as "Count",
       dateadd(minute, (datediff(minute, 0, Value) / @Interval) * @Interval, 0) as "Value"
from @T
group by dateadd(minute, (datediff(minute, 0, Value) / @Interval) * @Interval, 0);
*/