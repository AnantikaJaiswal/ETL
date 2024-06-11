select * from netflix_raw
order by title

drop table netflix_raw

--creating table to handle foreign characters
CREATE TABLE [dbo].[netflix_raw](
	[show_id] [varchar](10) primary key,
	[type] [varchar](10) NULL,
	[title] [Nvarchar](255) NULL,
	[director] [varchar](250) NULL,
	[cast] [varchar](1000) NULL,
	[country] [varchar](130) NULL,
	[date_added] [varchar](20) NULL,
	[release_year] [int] NULL,
	[rating] [varchar](10) NULL,
	[duration] [varchar](10) NULL,
	[listed_in] [varchar](100) NULL,
	[description] [varchar](500) NULL
)


--making show_id primary key as it  doesn't have duplicates
select show_id,count(*)
from netflix_raw
group by show_id
having count(*)>1

--let's check if there are duplicate title
--keeping only required columns
--data type conversion for date added 

select * from netflix_raw
where concat(upper(title),type) in(
select concat(upper(title),type)
from netflix_raw
group by upper(title),type
having count(*)>1
)
order by title

with cte as (
select *,
ROW_NUMBER() over (partition by title,type order by show_id) as rn
from netflix_raw
) 
select  show_id,type,title,cast(date_added as date) as date_added,release_year,rating,
case when duration is null then rating else duration end as duration,description
into netflix
from cte --where rn=1 and date_added is null;


--new table for director,cast,country
select show_id, trim(value) as director
into netflix_director
from netflix_raw
cross apply string_split(director,',')

select show_id, trim(value) as cast
into netflix_cast
from netflix_raw
cross apply string_split(cast,',')

select show_id, trim(value) as country
into netflix_country
from netflix_raw
cross apply string_split(country,',')

select show_id, trim(value) as genre
into netflix_genre
from netflix_raw
cross apply string_split(listed_in,',')


--populate country in country table where country is nulll
insert into netflix_country
select show_id,m.country
from netflix_raw nr
inner join (
select director,country from netflix_director nd
inner join netflix_country nc
on nd.show_id=nc.show_id
group by director,country
)m on nr.director=m.director
where nr.country is null
 



