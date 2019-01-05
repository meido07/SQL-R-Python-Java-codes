------Remove dups from Load-----

--drop table #dups
--Find all of the duplicate records and load their relevant information into a temp table, identifying which sequence to keep for each
select id_number, school_code, degree_level_code, degree_year, major_code1, min(sequence) keeper
into #dups
from degrees 
where isnull(school_code,'') <> ''
and isnull(degree_level_code, '') <> ''
and isnull(degree_year, '') <> ''
and isnull(major_code1, '') <> '' 
and operator_name = 'SISX20151119' --('SISX' + convert(char(8),getdate(),112))--'SISX20151117'
group by id_number, school_code, degree_level_code, degree_year, major_code1
having count(id_number) > 1
order by id_number, school_code, major_code1, keeper


--delete the duplicate records that do not have the sequence number we flagged to keep in the prior step
delete degrees
--select * 
from degrees a
inner join #dups b
on a.id_number = b.id_number
and  a.school_code = b.school_code
and a.degree_level_code = b.degree_level_code
and a.degree_year = b.degree_year
and a.major_code1 = b.major_code1
and a.sequence <> b.keeper
and a.operator_name = 'SISX20151119' --('SISX' + convert(char(8),getdate(),112))--'SISX20151117'



--------------FIX SEQUENCE NUMBER ORDER-------------------
--Sequence numbers are out of order now, put them back into sequenctial order

--drop table #digits
--create a table of numbers to compare to the sequence numbers in degrees.  Will be used to find the next available number.
create table #digits(digit int)
insert into #digits(digit) values (1)
insert into #digits(digit) values (2)
insert into #digits(digit) values (3)
insert into #digits(digit) values (4)
insert into #digits(digit) values (5)
insert into #digits(digit) values (6)
insert into #digits(digit) values (7)
insert into #digits(digit) values (8)
insert into #digits(digit) values (9)
insert into #digits(digit) values (10)
insert into #digits(digit) values (11)
insert into #digits(digit) values (12)
insert into #digits(digit) values (13)
insert into #digits(digit) values (14)
insert into #digits(digit) values (15)
insert into #digits(digit) values (16)
insert into #digits(digit) values (17)
insert into #digits(digit) values (18)
insert into #digits(digit) values (19)

--select * from #digits


declare @id char(10),  --id_number to fix sequence numbers on
        @seq int,      --our current starting sequence number
        @avail_seq int, --the next avaialbe blank sequence number
        @update_seq int --the sequence number that we need to change
        
select @id =  (select min(id_number) from #dups)        
select @seq = (select min(sequence) from degrees where id_number = @id)
select @avail_seq = (select min(digit) from #digits d left join degrees d2 on d2.id_number = @id and d.digit = d2.sequence where d2.sequence is null)
if @seq > @avail_seq                --In the event our starting sequence number is greater than the 1st available (example, 2 and 4 are the sequence numbers for an id), we want to update the current sequence number in order to set it to 1)
                select @update_seq = @seq
else
                select @update_seq = (select min(sequence) from degrees where sequence > @avail_seq)
--select @id, @seq, @avail_seq, @update_seq
--LOOP...
WHILE 1=1
BEGIN
    --Set the sequence identified as the one we need to change to the lowest available sequence number
                print 'Id_Number is %1!, sequence is %2!, next available sequence is %3!, sequence to change is %4!',@id, @seq, @avail_seq, @update_seq
                update degrees
                set sequence = @avail_seq
                where id_number = @id and sequence = @update_seq
                print 'update complete...modifying variables'
                
                
                select @seq = @avail_seq                       --set the sequence number we're working on to the available slot we just used
                print 'Now working on sequence %1!', @seq
                select @avail_seq = (select min(digit) from #digits d left join degrees d2 on d2.id_number = @id and d.digit = d2.sequence where d2.sequence is null)    --find the new lowest available slot
                print 'Next available sequence is now %1!, checking if its time to switch ids', @avail_seq
                if @avail_seq > (select max(sequence) from degrees where id_number = @id)   --evaluate whether the next available sequence number is higher than any of the sequence numbers for this id...
                                BEGIN
                                print 'Time to switch id_numbers...'
                                                if @id = (select max(id_number) from #dups)  --..if it is higher, we're done with this id.  So if this is the highest id in our #dups table, we're done with this loop and can exit (BREAK)
                                                                BREAK
                                                ELSE --..if it's higher than the sequences but NOT the highest id, then we need to move to the next id_number and start over for them.
                                                BEGIN
                                                                select @id = (select min(id_number) from #dups where id_number > @id)
                                                                print 'New id_number is %1!',@id
                                                                select @seq = (select min(sequence) from degrees where id_number = @id)
                                                                print 'First sequence to work for new id is %1!',@seq
                                                                select @avail_seq = (select min(digit) from #digits d left join degrees d2 on d2.id_number = @id and d.digit = d2.sequence where d2.sequence is null)
                                                                print 'Next available sequence number is %1!, evaluating whether or not starting sequence is greater than 1',@avail_seq
                                                                if @seq > @avail_seq
                                                                                select @update_seq = @seq
                                                                else
                                                                                select @update_seq = (select min(sequence) from degrees where sequence > @avail_seq)
                                                                print 'next sequence to update is %1! after evaluation',@update_seq
                                                                CONTINUE
                                                END
                                END
                ELSE
                                select @update_seq = (select min(sequence) from degrees where sequence > @avail_seq)--the next available sequence number ISN'T higher than all of the remaining sequences in degrees, then we need to find the next sequence to update for this id
END
print 'Done'



drop table #dups

go