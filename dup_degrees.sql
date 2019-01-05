_---script_to_find_people_dup_degrees

select id_number, school_code, degree_level_code, degree_year, count(id_number) as cnt
from degrees 
where isnull(school_code,'') <> ''
and isnull(degree_level_code, '') <> ''
and isnull(degree_year, '') <> ''
and isnull(major_code1, '') <> '' 
and operator_name = 'SISX20151116'
group by id_number, school_code, degree_level_code, degree_year, major_code1
having count(id_number) > 1
order by cnt desc





------Remove dups from Load-----


--delete degrees where id_number = '0010350687'

select * from degrees where id_number = '0010350687'

--drop table #dups
select id_number, school_code, degree_level_code, degree_year, major_code1, min(sequence) keeper
into #dups
from degrees 
where isnull(school_code,'') <> ''
and isnull(degree_level_code, '') <> ''
and isnull(degree_year, '') <> ''
and isnull(major_code1, '') <> '' 
and operator_name = ('SISX' + convert(char(8),getdate(),112))
group by id_number, school_code, degree_level_code, degree_year, major_code1
having count(id_number) > 1
order by id_number, school_code, major_code1, keeper

select * from #dups

delete degrees
from degrees a
inner join #dups b
on a.id_number = b.id_number
and  a.school_code = b.school_code
and a.degree_level_code = b.degree_level_code
and a.degree_year = b.degree_year
and a.major_code1 = b.major_code1
and a.sequence <> b.keeper



declare @id char(10),
        @seq int,
        @next_seq int 
        
select @id = (select min(id_number) from #dups)        )
select @seq = (select min(keeper) from #dups where id_number = @id)
select @next_seq = (select 

drop table #dups










---Load Only one entity----

declare @id char(10), @sq smallint, @op char(12), @sq2 smallint, @ctid char(10), @ck datetime, @rv smallint,@rd char(8)
select @rd=convert(char(8),getdate(),112),@op="SISX"+convert(char(8),getdate(),112), @ck=getdate()


BEGIN TRAN
select @id="0010350687" print "3 update advid 0010350687"


select @sq=isnull(max(sequence),0) from degrees where id_number=@id
select @sq=@sq+1
insert degrees (id_number,date_added,date_modified,operator_name,user_group,campus_code,concentration_code,degree_code,degree_level_code,degree_year,grad_dt,honor_code1,institution_code,local_ind,major_code1,major_code2,minor_code1,minor_code2,quarters_qty,school_code,sequence,data_source_code,honorary_alumnus_ind,non_grad_code,admiss_year,start_dt) VALUES (@id,getdate(),getdate(),@op,"00","W06","228","BS","B","2016","20150904","SL","4586","Y","447","","","",0,"PHHS",@sq,"SI","N","","2012","00000000") if @@error<>0 goto err_3
select @sq=@sq+1
insert degrees (id_number,date_added,date_modified,operator_name,user_group,campus_code,concentration_code,degree_code,degree_level_code,degree_year,grad_dt,honor_code1,institution_code,local_ind,major_code1,major_code2,minor_code1,minor_code2,quarters_qty,school_code,sequence,data_source_code,honorary_alumnus_ind,non_grad_code,admiss_year,start_dt) VALUES (@id,getdate(),getdate(),@op,"00","W06","228","BS","B","2016","20150904","SL","4586","Y","447","","","",0,"PHHS",@sq,"SI","N","","2012","00000000") if @@error<>0 goto err_3
select @sq=@sq+1
insert degrees (id_number,date_added,date_modified,operator_name,user_group,campus_code,concentration_code,degree_code,degree_level_code,degree_year,grad_dt,honor_code1,institution_code,local_ind,major_code1,major_code2,minor_code1,minor_code2,quarters_qty,school_code,sequence,data_source_code,honorary_alumnus_ind,non_grad_code,admiss_year,start_dt) VALUES (@id,getdate(),getdate(),@op,"00","W06","","BS","B","2016","20150904","SL","4586","Y","233","","","",0,"ED",@sq,"SI","N","","2012","00000000") if @@error<>0 goto err_3
select @sq=@sq+1
insert degrees (id_number,date_added,date_modified,operator_name,user_group,campus_code,concentration_code,degree_code,degree_level_code,degree_year,grad_dt,honor_code1,institution_code,local_ind,major_code1,major_code2,minor_code1,minor_code2,quarters_qty,school_code,sequence,data_source_code,honorary_alumnus_ind,non_grad_code,admiss_year,start_dt) VALUES (@id,getdate(),getdate(),@op,"00","W06","","BS","B","2016","20150904","SL","4586","Y","233","","","",0,"ED",@sq,"SI","N","","2012","00000000") if @@error<>0 goto err_3

update entity set relations_nbr=(select count(*) from relationship where id_number=@id) where id_number=@id

COMMIT

goto cont_3
err_3:
ROLLBACK print "err in rec 3"
cont_3: