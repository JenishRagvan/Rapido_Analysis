use rapido ; 
select * from city_wise_demand ; 
select * from customer_feedback ; 
select * from customers ; 
select * from drivers ; 
select * from ride_cancel ; 
select * from ride_payments ; 
select * from rides ; 


-- 1 .  Identify the city with the highest ride demand . 

select city , sum(total_rides) as Total_Rides from city_wise_demand
group by city order by Total_Rides desc ; 

-- 2. Find the most common ride start and end locations. 

select pickup_location , drop_location , count(*) as Most_rides  from  rides
group by pickup_location , drop_location
order by Most_rides desc limit 5 ; 

-- 3. Identify the Total rides completed per driver . 

select driver_name , sum(total_rides_completed) as Completed_rides 
from drivers group by driver_name 
order by Completed_rides desc limit 5 ; 

-- 4. Find the longest ride distance recorded.

select ride_id , pickup_location , drop_location , max(ride_distance_km) as Longest_ride 
from rides group by ride_id order by Longest_ride desc limit 5 ; 

-- 5. Calculate total revenue generated per month. 

select date_format(transaction_date , '%Y-%m') as Month ,
sum(amount_paid) as Total_revenue from ride_payments 
group by Month
 order by Total_revenue  desc ; 
 
 -- 6. Identify the top 5 cities by revenue. 
 
 select r.city , sum(rp.amount_paid) as Total_revenue from rides as r 
 join ride_payments as rp 
 on r.ride_id = rp.ride_id 
 group by r.city 
 order by Total_revenue desc limit  5 ; 
 
 -- 7.  Identify drivers who earned the highest revenue.

select driver_name , sum(earnings) as highest_revenue from drivers 
group by driver_name order by highest_revenue desc limit 5 ; 

-- 8. Analyze the most common reasons for ride cancellations. 

select cancellation_reason , count(*) as Cancel_reason 
from  ride_cancel group by cancellation_reason order by Cancel_reason desc  ; 

-- 9. ustomers with the Highest Ride Frequency & Spending 

 select c.customer_id , c.customer_name , count(r.ride_id) as Total_rides , coalesce(sum(rp.amount_paid),0) as total_spent 
from customers as c 
inner join rides as r on c.customer_id = r.customer_id
inner join ride_payments as rp on r.ride_id = rp.ride_id
where r.ride_date >= date_sub(curdate(), interval 3 month ) -- last 3 month 
group by c.customer_id , c.customer_name 
order by total_spent desc , total_rides desc 
limit 10 ; 

 
-- 10.  Find the top 5 customers who took the most rides . 

SELECT customer_id  , COUNT(*) AS ride_count 
FROM Rides 
GROUP BY customer_id 
ORDER BY ride_count DESC 
LIMIT 5;

-- 11 . Get the percentage of canceled rides .  
SELECT 
    (SELECT COUNT(*) FROM Ride_Cancel) / COUNT(*) * 100 AS cancel_rate
FROM Rides; 

-- 12. Find customer satisfaction score per city. 

SELECT r.city, AVG(cf.rating) AS avg_rating 
FROM rides as r join customer_feedback as cf on r.ride_id = cf.ride_id
GROUP BY r.city 
ORDER BY avg_rating DESC;

-- 13 . Find the most profitable payment method.

SELECT payment_method, SUM(amount_paid) AS total_revenue
FROM Ride_Payments
GROUP BY payment_method
ORDER BY total_revenue DESC
LIMIT 1;
 
 -- 14 . Find drivers with the highest customer ratings. 
  
  SELECT driver_id, driver_name ,round(AVG(driver_rating),1) AS avg_rating
FROM drivers 
GROUP BY driver_id
ORDER BY avg_rating DESC
LIMIT 5;

-- 15 .   HOW MANY RIDES WERE COMPLETED WITHOUT CUSTOMER RATINGS? 

SELECT COUNT(*) AS no_rating_rides
FROM Rides r
LEFT JOIN Customer_Feedback cf ON r.ride_id = cf.ride_id
WHERE cf.rating IS NULL;

-- 16 . WHICH VEHICLE TYPE IS USED THE MOST FOR RAPIDO RIDES?

SELECT d.vehicle_type, COUNT(r.ride_id) AS ride_count
FROM Rides r
JOIN Drivers d ON r.driver_id = d.driver_id
GROUP BY d.vehicle_type
ORDER BY ride_count DESC;

-- 17 . WHICH CUSTOMERS HAVE SPENT THE MOST MONEY ON RAPIDO? 

SELECT c.customer_id, c.customer_name, SUM(rp.amount_paid) AS total_spent
FROM Customers c
JOIN Rides r ON c.customer_id = r.customer_id
JOIN Ride_Payments rp ON r.ride_id = rp.ride_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10 ; 

-- 18.  WHICH TIME SLOT HAS THE HIGHEST DEMAND FOR RAPIDO RIDES? 

SELECT CASE 
         WHEN HOUR(ride_time) BETWEEN 6 AND 10 THEN 'Morning (6AM-10AM)'
         WHEN HOUR(ride_time) BETWEEN 11 AND 16 THEN 'Afternoon (11AM-4PM)'
         WHEN HOUR(ride_time) BETWEEN 17 AND 21 THEN 'Evening (5PM-9PM)'
         ELSE 'Night (10PM-5AM)'
       END AS time_slot, COUNT(*) AS ride_count
FROM Rides
GROUP BY time_slot
ORDER BY ride_count DESC; 


-- 19 .  WHAT IS THE TOTAL REVENUE GENERATED FROM NIGHT-TIME RIDES?

SELECT SUM(rp.amount_paid) AS total_night_revenue
FROM Rides r
JOIN Ride_Payments rp ON r.ride_id = rp.ride_id
WHERE HOUR(r.ride_time) BETWEEN 22 AND 5;

-- 20 . HOW MANY CUSTOMERS HAVE USED RAPIDO IN MULTIPLE CITIES?

SELECT r.city, COUNT(DISTINCT c.customer_name) AS customer_count
FROM Rides as r join customers as c on r.customer_id = c.customer_id
GROUP BY r.city
HAVING customer_count > 1
ORDER BY customer_count DESC;

-- 21.  Average Ride Frequency per Month by Gender . 

SELECT c.gender, round(COUNT(r.ride_id) / COUNT(DISTINCT DATE_FORMAT(r.ride_date, '%Y-%m')),1) AS avg_rides_per_month
FROM Rides as r
JOIN Customers as c ON r.customer_id = c.customer_id
GROUP BY c.gender;

-- 22 . Highest Spending Age Group . 

SELECT 
    CASE 
        WHEN c.age BETWEEN 18 AND 25 THEN 'Adult'
        WHEN c.age BETWEEN 26 AND 35 THEN 'Teenage'
        WHEN c.age BETWEEN 36 AND 50 THEN 'Middle-Aged'
        ELSE 'Senior'
    END AS age_group,
    SUM(rp.amount_paid) AS total_spent
FROM Ride_Payments rp
JOIN Rides r ON rp.ride_id = r.ride_id
JOIN Customers c ON r.customer_id = c.customer_id
GROUP BY age_group
ORDER BY total_spent DESC;

-- 23. Calculate Cancellation Rate by Gender . 

SELECT c.gender, 
       COUNT(rc.ride_id) / (SELECT COUNT(*) FROM Rides) * 100 AS cancellation_rate
FROM Ride_Cancel as  rc
JOIN Customers as c ON rc.customer_id = c.customer_id
GROUP BY c.gender; 

-- Project Completed *
 





























  
  