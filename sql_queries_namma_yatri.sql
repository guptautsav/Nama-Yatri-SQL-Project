-- total trips

select count(distinct tripid) from trips_details;


-- total earnings

select sum(fare) fare from trips;


-- total completed trips 


select count(distinct tripid) trips from  trips;


-- total searches

select sum(searches) searches from trips_details4;


-- total searches which got estimate

select sum(searches_got_estimate) searches from trips_details4;


-- total searches for quotes

select sum(searches_for_quotes) searches from trips_details4;


-- total driver cancelled

select * from trips_details4;



select count(*) - sum(driver_not_cancelled) cancelled from trips_details4; 
    




-- total otp entered

select sum(otp_entered) otp from trips_details4;




-- total end ride 

select sum(end_ride) from trips_details4;





-- average distance per trip

select avg(distance) from trips;




-- average fare per trip

select avg(fare) from trips;





-- distance travelled

select sum(distance) from trips;


-- which is the most used payment method

SELECT 
    a.method
FROM
    payment a
        INNER JOIN
    (SELECT 
        faremethod, COUNT(DISTINCT tripid) cnt
    FROM
        trips
    GROUP BY faremethod
    ORDER BY COUNT(DISTINCT tripid) DESC
    LIMIT 1) b ON a.id = b.faremethod;

-- the highest payment was made through which instrument 

SELECT 
    a.method
FROM
    payment a
        INNER JOIN
    (SELECT 
        *
    FROM
        trips
    ORDER BY fare DESC LIMIT 1) b ON a.id = b.faremethod;


-- which two locations had the most trips 

select * from
(select *,dense_rank() over(order by trip desc) rnk
from
( select loc_from, loc_to, count(distinct tripid) trip from trips
group by loc_from, loc_to
)a)b
where rnk=1;


-- top 5 earning drivers

select * from
(select * ,dense_rank() over(order by fare desc) rnk
from
(select driverid, sum(fare) fare from trips 
group by driverid)b)c
where rnk<6;

-- which duration had more trips

select * from
(select * ,rank() over(order by cnt desc) rnk from 
(select duration, count(distinct tripid) cnt from trips
group by duration)b)c
where rnk=1;


-- which driver , customer pair had more orders

select * from
(select *, rank() over(order by cnt desc) rnk from
(select driverid, custid, count(distinct tripid) cnt from trips
group by driverid, custid)c)d
where rnk=1 ;


-- search to estimate rate


select sum(searches_got_estimate)*100/sum(searches) Rate from trips_details4;



-- which area got highest trips in which duration

select * from 
(select *, rank() over(partition by duration order by cnt desc ) rnk from 
(select duration, loc_from, count(distinct tripid) cnt 
from trips group by duration, loc_from) a ) c
where rnk=1 ;

-- which duration got the highest number of trips in each of the location present
 
 select * from 
(select *, rank() over(partition by loc_from order by cnt desc ) rnk from 
(select duration, loc_from, count(distinct tripid) cnt 
from trips group by duration, loc_from) a ) c
where rnk=1 ;


-- which area got the highest fares


select * from (select *,rank() over(order by fare desc) rnk
from
( select loc_from, sum(fare) fare from trips
group by loc_from) b )c
where rnk=1;


-- which area got the highest cancellations by driver

select * from (select *, rank() over(order by can desc) rnk
from
(select loc_from, count(*) - sum(driver_not_cancelled) can
from trips_details4
group by loc_from)b)c
where rnk =1;

-- which area got the highest cancellations by customer

select * from (select *, rank() over(order by can desc) rnk
from
(select loc_from, count(*) - sum(customer_not_cancelled) can
from trips_details4
group by loc_from)b)c
where rnk =1;

--  which duration got the highest fares


select * from (select *,rank() over(order by fare desc) rnk
from
( select duration, sum(fare) fare from trips
group by duration) b )c
where rnk=1;

--  which duration got the highest trips

select * from (select *,rank() over(order by trip desc) rnk
from
( select duration, count(distinct tripid) trip from trips
group by duration) b )c
where rnk=1;
