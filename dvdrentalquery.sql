--------------------------------------------------------------------
1)	Show the trend of rental payment across time for each of the stores.
SELECT
	staff.store_id,
	DATE(pay.payment_date),
	SUM(pay.amount) AS total_rental_amt
FROM 
	payment AS pay
INNER JOIN staff 
	ON pay.staff_id = staff.staff_id
GROUP BY 
	store_id,DATE(pay.payment_date)
ORDER BY 
	store_id,DATE(pay.payment_date)


--------------------------------------------------------------------

2) List the number of rentals within each category as well as their total sales, order by the number of rentals in descending order

WITH rental_count AS (
SELECT 
	category.name,
	COUNT(rental.rental_id) AS number_rental
FROM 
	category 
INNER JOIN film_category 
	ON category.category_id = film_category.category_id
INNER JOIN film
	ON film_category.film_id = film.film_id
INNER JOIN inventory
	ON film.film_id = inventory.film_id
INNER JOIN rental 
	ON inventory.inventory_id = rental.inventory_id
GROUP BY 
	category.name
ORDER BY 
	number_rental DESC 
),
/* have to do the rental counts and payment amount separate because 
not all rentals had been paid 
*/
rental_sales AS (SELECT 
	category.name,
	SUM(payment.amount) AS sales
FROM 
	category 
INNER JOIN film_category 
	ON category.category_id = film_category.category_id
INNER JOIN film
	ON film_category.film_id = film.film_id
INNER JOIN inventory
	ON film.film_id = inventory.film_id
INNER JOIN rental 
	ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
	ON payment.rental_id = rental.rental_id
GROUP BY 
	category.name
ORDER BY 
	sales DESC 
)

SELECT 
	rental_sales.name,
	rental_count.number_rental,
	rental_sales.sales
FROM 	
	rental_sales
INNER JOIN rental_count
	ON rental_sales.name = rental_count.name
ORDER BY 
	number_rental DESC
	

--------------------------------------------------------------------

3)	List number of rentals for each customer

SELECT
	customer.customer_id,
	CONCAT(first_name,' ', last_name),
	COUNT(rental_id) AS number_rental
FROM 
	customer
LEFT JOIN rental	
	ON customer.customer_id = rental.customer_id
GROUP BY 
	customer.customer_id,
	CONCAT(first_name,' ', last_name)
ORDER BY 
	number_rental ASC


--------------------------------------------------------------------
4)	Return the top 3 genre each customer rents

SELECT
	*
FROM (
SELECT 
	customer.customer_id,
	category.name,
	COUNT(category.name),
	RANK() OVER (PARTITION BY customer.customer_id ORDER BY COUNT(category.name) DESC) 
FROM 
	category 
INNER JOIN film_category 
	ON category.category_id = film_category.category_id
INNER JOIN film
	ON film_category.film_id = film.film_id
INNER JOIN inventory
	ON film.film_id = inventory.film_id
INNER JOIN rental 
	ON inventory.inventory_id = rental.inventory_id
LEFT JOIN customer 
	ON rental.customer_id = customer.customer_id
GROUP BY 
	customer.customer_id,
	category.name
ORDER BY 
	customer_id
) AS full_category_rank
WHERE
	full_category_rank.rank <= 3

--------------------------------------------------------------------

5) Return a table with country name in 1 column,the number of customers in each country in another column as well as the total sales within the country. 
Sort the table in descending order with sales.

WITH CUSTOMER_PAYMENT_INFO AS (
SELECT
	payment.amount,
	address.address_id,
	customer.customer_id,
	address.city_id
FROM 
	customer
LEFT JOIN address
	ON customer.address_id = address.address_id	
INNER JOIN payment
	ON payment.customer_id = customer.customer_id
),
COUNTRY_INFO AS (
SELECT
	country,
	city.city_id,
	country.country_id
FROM 
	country
LEFT JOIN 
	city
ON city.country_id = country.country_id )

SELECT 
	country,
	SUM(amount) AS sales,
	COUNT(DISTINCT customer_id) AS customer_in_country
FROM 
	CUSTOMER_PAYMENT_INFO
LEFT JOIN COUNTRY_INFO
	ON
CUSTOMER_PAYMENT_INFO.city_id = COUNTRY_INFO.city_id
GROUP BY 
	country
ORDER BY 
	sales DESC
	
--------------------------------------------------------------------

6)	List the actors that are most popularly rented, so we can use these actors as promotional material


SELECT
	actor.actor_id,
	concat(first_name,' ',last_name) AS actor_name,
	COUNT(DISTINCT rental_id) AS number_rental
FROM 
	actor
LEFT JOIN 
	film_actor
ON 	actor.actor_id = film_actor.actor_id
INNER JOIN 
	film
ON film_actor.film_id = film.film_id
INNER JOIN 
	inventory
ON film.film_id = inventory.film_id
INNER JOIN 
	rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY 
	actor.actor_id,
	actor_name
ORDER BY 
	number_rental DESC
	

--------------------------------------------------------------------

7)	List the top 5 customers per total sales, so we can reward them.
SELECT
	concat(first_name, ' ',last_name),
	SUM(payment.amount) AS sales
FROM
	customer
LEFT JOIN 
	payment
ON 	
	customer.customer_id  = payment.customer_id
GROUP BY 
	concat(first_name,' ',last_name)
ORDER BY 
	sales DESC
LIMIT 5


