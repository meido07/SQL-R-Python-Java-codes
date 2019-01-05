USE [reporting]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		  Mohamed Abdalla
-- Create date:   29th March 2016
-- =============================================
CREATE FUNCTION [dbo].[DM_080_School_By_class_year]
(@School_By_Class_Yr varchar(25)

)
RETURNS TABLE 
AS
RETURN 
(
select convert(char(8),getdate(),112) as RunDate,
a.class_year,
a.Pref_school_desc as School,
isnull (a.Total,0) as Total

FROM 

--Total count

(select E.pref_class_year as class_year, E.Pref_school_desc, count(distinct(E.id_number)) as Total from xrpt_bio E
inner join xrpt_address A on A.id_number = E.id_number
where --e.record_status = 'A' --and  a.addr_status_code = 'A'  
 e.record_type = 'AL' and isnull(rtrim(E.pref_school_desc),space(0)) <> space(0)  --and A.addr_pref_ind = 'Y'
group by E.pref_class_year, E.Pref_school_desc) a
where @School_By_Class_Yr = 'Scl_class'
)



--select * from DM_080_School_By_class_year('Scl_class') order by class_year

GO


