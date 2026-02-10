use music_store;
-- 1. Who is the senior most employee based on job title? 
select last_name, first_name, title 
from employee
 order by  title asc 
 limit 1;
 
 -- 2. Which countries have the most Invoices?
 select billing_country, count(*) as total_invoices
 from invoice
group by billing_country
order by total_invoices desc
limit 1;
  
 -- 3. What are the top 3 values of total invoice?
 select total 
 from  invoice
 order by total desc
limit 3;
 
 -- select * 
--  from  invoice
--  order by total desc 
--  limit 3;

/* 4. Which city has the best customers? 
-  We would like to throw a promotional Music Festival in 
the city we made the most money. Write a query that returns one
 city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select  billing_city, total, sum(total) as total_invoice
from invoice
group by billing_city, total
order by total_invoice desc
limit 1 ;

/*5. Who is the best customer? 
- The customer who has spent the most money will be declared the best customer.
 Write a query that returns the person who has spent the most money
*/

select customer_id, first_name, last_name, sum(total) as total_spent
from customer
join invoice using (customer_id)
group by  customer_id, first_name, last_name
order by total_spent desc
 limit 1;

/* 6. Write a query to return the email, first name, last name, & Genre of all Rock Music
 listeners. Return your list ordered alphabetically by email starting with A */

select c.email, c.first_name, c.last_name, g.name as genre
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on t.track_id = il.track_id
join genre g on g.genre_id = t.genre_id
where g.name = 'rock'
order by email asc;

/* 7. Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands 
*/

select 
ar.name as arist_name,
count(track_id) as rock_track_count
from track t
join genre g on t.genre_id = g.genre_id
join album al on t.album_id = al.album_id
join artist ar on al.artist_id = ar.artist_id
where g.name = 'rock'
group by ar.artist_id,ar.name
order by  rock_track_count desc
limit 10;

/* 8. Return all the track names that have a song length longer 
than the average song length.- Return the Name and Milliseconds for each track. 
Order by the song length, with the longest songs listed first
 */
 
 select name, milliseconds
 from track
 where milliseconds > (select avg(milliseconds) from track)
order by  milliseconds desc ;
 
/* 9. Find how much amount is spent by each customer on artists? 
Write a query to return customer name, artist name and total spent  */ 

-- customer -> invoice -> invoice_line -> track -> album -> artist
-- Logic ---> unit_price * quantity from invoice_line as total_spent

select CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
ar.name as artist_name,
sum(il.unit_price * il.quantity) as total_spent
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album al on t.album_id = al.album_id
join artist ar on al.artist_id = ar.artist_id
group by c.customer_id,ar.artist_id
order by total_spent desc;

/* 10. We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases.
 Write a query that returns each country along with the top Genre. */

-- subquery 
--  (select i.billing_country as country,
--  g.name as genre_name,
--  count(il.invoice_line_id) as total_purchases,
--  rank() over(partition by i.billing_country order by count(il.invoice_line_id) desc) as genre_rank
--  from invoice i
--  join invoice_line il on i.invoice_id = il.invoice_id
--  join track t on il.track_id = t.track_id
--  join genre g on t.genre_id = g.genre_id
--  group by i.billing_country, g.name;)

select country, genre_name, total_purchases
from (select i.billing_country as country,
 g.name as genre_name,
 count(il.invoice_line_id) as total_purchases,
 rank() over(partition by i.billing_country order by count(il.invoice_line_id) desc) as genre_rank
 from invoice i
 join invoice_line il on i.invoice_id = il.invoice_id
 join track t on il.track_id = t.track_id
 join genre g on t.genre_id = g.genre_id
 group by i.billing_country, g.name) as ranked
 where genre_rank = 1
 order by country;
 

/* 11. Write a query that determines the customer that has spent the most on music for each country.
 Write a query that returns the country along with the top customer and how much they spent. 
 For countries where the top amount spent is shared, provide all customers who spent this amount */


-- subquery 
-- (select c.country, 
-- CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
-- sum(i.total) as total_spent,
-- rank() over (partition by c.country order by sum(i.total) desc) as spent_rank
-- from customer c
-- join invoice i on c.customer_id = i.customer_id
-- group by c.country, c.first_name, c.last_name;)

select country, customer_name, total_spent
from(select c.country, 
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
sum(i.total) as total_spent,
rank() over (partition by c.country order by sum(i.total) desc) as spent_rank
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.country, c.first_name, c.last_name)
as ranked_customer
where spent_rank = 1
order by country;




select * from genre;
select * from media_type;
select * from employee;
select * from customer;
select * from artist;
select * from album;
select * from track;
select * from invoice;
select * from invoice_line;
select * from playlist;
select * from playlist_track;