I want to build a portfolio project where I
1)	show case writing sql queries to answer business questions
2)	create dashboard/visualization using Power BI 

The first step will be to create a database. Following the tutorial below, I found a sample DvDrental database which I load it into a PostgreSQL database server. 

https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/

ER diagram:

<image src = "dvd_er_diagram.png">


After exploring the database, I felt that there were also too few stores and staff in the database so I added additional data into the database.

I came up with 7 questions I imagine would be interesting business questions:


1)	Show the trend of rental payment across time for each of the stores.


2) List the number of rentals within each category as well as their total sales, order by the number of rentals in descending order


3)	List number of rentals for each customer

4)	Return the top 3 genre each customer rents


5) Return a table with country name in 1 column,the number of customers in each country in another column as well as the total sales within the country. 
Sort the table in descending order with sales.


6)	List the actors that are most popularly rented, so we can use these actors as promotional material



7)	List the top 5 customers per total sales, so we can reward them.


The queries to answer these questions are in the dvdrentalquery.sql file.

