/*
2.1 (suggested time 30 min - 45 min)
We recently built a new feature—study schedules—in our core web app, and it’s rolled out to 10% of all users.  We want to first understand whether students are coming back to the feature after trying it
 for the first time. Could you generate a weekly retention report (just like the output sample) using the feature usage log (table name: study_sch) in SQL? 

Notes: 
•	You'll be writing the initial query, but someone else on the team will be reviewing it and updating it, so take that into consideration as you write it.
•	The first row of the output sample below reads: 1000 users tried the schedule feature in the week of 2017-4-20 - 2017-4-27 for the first time, and 10% of them used it again 20 weeks later 
•	n week retention = % of distinct users that came back between 7n days and 7(n-1) days after their first visit  
•	Users don’t have to consistently come back every single week between Week 1 and Week n, where Week 1 is when they first experienced the feature, to be considered retention for Week n
•	study_sch is a comprehensive log that records the user and the time they used the feature since the inception of the feature


*/



---2.1 

--Create a function to capture set of 7 days

declare @work_date char(8), @begin_date char(8), @end_date char(8)
select @begin_date = convert(char(8), dateadd(day,-datepart(dw,@work_date) -1, @work_date) ,112) 
select @end_date = convert(char(8), dateadd(day,-datepart(dw,@work_date) +7, @work_date) ,112) 


----find out the retention by specific week

SELECT COUNT(user_id)
from study_sch a
WHERE  created_at BETWEEN @begin_date and @end_date
AND EXISTS (SELECT * FROM study_sch WHERE a.user_id = user_id and created_at < @begin_date)
group by user_id




--seeking an extra credit for 2.1

----if you want to indentify the returend users for this particular week, so you would use this code for future analytics

SELECT  user_id
      , COUNT(user_id) nr
FROM     study_sch 
WHERE created_at BETWEEN @begin_date and @end_date
GROUP BY user_id
HAVING  COUNT(user_id) > 1




