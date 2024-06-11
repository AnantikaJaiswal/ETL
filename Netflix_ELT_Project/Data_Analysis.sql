select director,
sum(case when type='Movie' then 1 else 0 end ) as Movie,
sum(case when type='TV Show' then 1 else 0 end )as tv_shows
from netflix_director nd
 inner join netflix n
 on nd.show_id=n.show_id
 group by director
 having count(distinct type)>=2
 order by director;

 select 
 country,count(genre) comedy_cnt
 from netflix_genre g
 inner join netflix_country c on g.show_id=c.show_id
 inner join netflix n on g.show_id=n.show_id 
 where type='Movie' and genre='Comedies'
 group by country
 order by comedy_cnt desc;


with cte as(
 select year(date_added) year ,director,count(n.show_id) movie_cnt from netflix n
  inner join netflix_director nd on nd.show_id=n.show_id
 where type='Movie'
 group by year(date_added),director
 )select * from (select *,
 rank() over (partition by year order by movie_cnt desc) as rank
 from cte
)A
where rank= 1
order by year desc


select genre,avg(cast(replace(n.duration,'min','')as int)) as avg_duration_int
from netflix n
inner join netflix_genre ng on ng.show_id=n.show_id
where type='Movie'
group by genre



select director,
sum(case when genre='Comedies' then 1 else 0 end) as comedy,
sum(case when genre='Horror Movies' then 1 else 0 end) as horror
from netflix n 
inner join netflix_genre ng on n.show_id=ng.show_id
inner join netflix_director nd on n.show_id=nd.show_id
where type='Movie' and genre in ('Comedies','Horror Movies')
group by director
having count(distinct genre)=2