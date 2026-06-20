create database sales_analytics;
use sales_analytics;

CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100) NOT NULL,
city VARCHAR(50),
email VARCHAR(100) UNIQUE,
created_date DATE
);
select * from customers;

CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2),
stock INT
);
select * from products;

CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
select * from orders;

CREATE TABLE order_details (
order_detail_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
select * from order_details;

-- > Add a NOT NULL constraint to the category column in products
alter table products modify category varchar(50) not null;

-- > Add a CHECK constraint to ensure price > 0 in products.
alter table products add constraint check (price >0);

-- > Change email column datatype to VARCHAR(150).
alter table customers modify email varchar(150);

-- > Create a table suppliers with appropriate data types.
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(100),
    supply_date DATE
);

-- > Rename column city to location in customers.
alter table customers rename column city to location;

-- > Drop the stock column from products.
alter table products drop column stock;
select * from products;

-- > Truncate the suppliers table. and Drop the suppliers table.
truncate table suppliers;
drop table suppliers;

-- > inserting records;
INSERT INTO customers VALUES
(1,'Arun Kumar','Chennai','arun@gmail.com','2024-01-10'),
(2,'Asha Devi','Chennai','asha@gmail.com','2024-02-12'),
(3,'Ajay Raj','Chennai','ajay@gmail.com','2024-03-15'),
(4,'Priya Nair','Chennai','priya@gmail.com','2024-04-18'),
(5,'Rahul Singh','Chennai','rahul@gmail.com','2024-05-20'),
(6,'Meena Joseph','Chennai','meena@gmail.com','2024-06-12'),
(7,'Suresh Babu','Mumbai','suresh@gmail.com','2024-07-01');

INSERT INTO products VALUES
(101,'Laptop','Electronics',65000),
(102,'Mobile','Electronics',25000),
(103,'Headphones','Electronics',1500),
(104,'Office Chair','Furniture',7000),
(105,'Printer','Electronics',12000),
(106,'Keyboard','Accessories',800);

INSERT INTO orders VALUES
(1001,1,'2024-01-15',65000),
(1002,1,'2024-02-10',25000),
(1003,1,'2024-03-12',12000),
(1004,1,'2024-04-10',65000),
(1005,2,'2024-05-18',25000),
(1006,3,'2024-06-15',7000),
(1007,4,'2024-07-20',12000),
(1008,7,'2024-08-11',65000),
(1009,2,'2024-08-15',50000),
(1010,3,'2024-08-20',40000);

INSERT INTO order_details VALUES
(1,1001,101,20,65000),
(2,1002,102,10,25000),
(3,1003,105,15,12000),
(4,1004,101,20,65000),
(5,1005,102,25,25000),
(6,1006,104,10,7000),
(7,1007,105,20,12000),
(8,1008,101,15,65000),
(9,1009,102,20,25000),
(10,1010,101,16,65000);

-- > Update product price by 10% for category 'Electronics'.
set sql_safe_updates=0;
update products set price = price*1.10; where category ='Electronics';
select * from products;

-- > Delete customers who are from 'Delhi'.
delete from customers where location ='delhi';
select * from customers;

-- > Display all customers sorted by name.
select * from customers order by customer_name asc;

-- > Display distinct product categories.
select distinct category from products;

-- > Fetch top 5 most expensive products.
select * from products order by price desc limit 5;

-- > Display customers created after 2023-01-01.
select * from customers where created_date>2023-01-01;

-- > Show all orders placed in the year 2024.
select * from orders where year(order_date)=2024;

-- > Find customers whose name starts with 'A'.
select * from customers where customer_name like 'A%';

-- > Display products priced between 500 and 2000.
select * from products where price between 500 and 2000;

-- > Fetch orders where total_amount > 10000.
select * from orders where total_amount > 10000;

-- > List products ordered by price descending.
select * from products order by price desc;

-- > Find customers whose email contains 'gmail'.
select * from customers where email like '%gmail%';

-- > Fetch customer name with their order details (INNER JOIN).
select customer_name,order_id,total_amount
from customers
inner join orders
on customers.customer_id=orders.customer_id;

-- > List all customers and their orders (LEFT JOIN).
select customer_name,order_id,total_amount
from customers
left join orders
on customers.customer_id=orders.customer_id;

-- > Show all orders and customers (RIGHT JOIN).
select customer_name,order_id,total_amount
from customers
right join orders
on customers.customer_id=orders.customer_id;

-- > Display product names with quantities sold.
select products.product_name,order_details.quantity
from products
inner join order_details
on products.product_id=order_details.product_id;

-- > Find customers who have not placed any order.
select customer_name,order_id,total_amount
from customers
left join orders
on customers.customer_id=orders.customer_id
where orders.order_id is null;

-- > Find total sales amount.
select sum(total_amount) from orders;

-- > Calculate average product price by category.
select avg(price) from products group by category;

-- > Find total number of orders per customer.
select customer_id,count(order_id) from orders group by customer_id;

-- > Get maximum and minimum product prices.
select product_name , max(price) as Maximum_price , min(price) as Minimum_price from products group by product_name;

-- > Count number of customers city-wise.
select location,count(customer_id) as total_customers from customers group by location;

-- > Find customers who placed more than 3 orders
select customer_id,count(order_id) from orders group by customer_id having count(order_id)>3;

-- > Display categories with average price > 1000.
select category,avg(price) as Average_price from products group by category having avg(price)>1000;

--  > Show cities having more than 5 customers.
select location , count(customer_id) from customers group by location having count(customer_id)>5;


-- > Find products sold more than 50 units.
select product_id ,sum(quantity) from order_details group by product_id having sum(quantity)>50;

-- > Calculate monthly sales and filter months with sales > 1,00,000.
select month(order_date),sum(total_amount)as total_sales from orders group by month(order_date) having sum(total_amount)>100000;


-- > Find customers who placed orders above average order value.
select * from orders where total_amount> (select avg(total_amount) from orders)

-- > List products that were never ordered.
select product_name from products where product_id not in (select product_id from order_details);

-- > Find second highest product price.
select max(price) from products where price < (select max(price) from products);

-- > Get customers who ordered the most expensive product.
SELECT DISTINCT customers.customer_name
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
JOIN order_details
ON orders.order_id = order_details.order_id
WHERE order_details.product_id =
(
    SELECT product_id
    FROM products
    WHERE price = (SELECT MAX(price) FROM products)
);

-- > Delete orders of customers from 'Mumbai' using subquery.
delete from orders where customer_id in(select customer_id from customers where location ='Mumbai');

-- > Create a view showing customer name, order date, and total amount.
create view vwOrder_Detail as
select customers.customer_name,orders.order_date,orders.total_amount
from customers
join orders
on customers.customer_id=orders.order_id
group by customers.customer_id;

-- > Create an index on order_date in orders table.
create index idx_date on orders(order_date);

-- > Create a user-defined function to calculate GST (18%) on amount.
delimiter //
create function gst (amount decimal(10,2))
returns decimal(10,2)
deterministic
begin
return amount * 0.18;
end //
delimiter ;
select gst(30);

-- > Create a stored procedure to fetch orders by customer_id.
delimiter $$
create procedure orders (in ID INT)
begin
select * from orders
where customer_id=ID;
end $$
delimiter ;
call orders(2);

-- > Create a temporary table to store top 5 selling products.
create temporary table temp_top_products as
select * from products order by price desc limit 5;
select * from temp_top_products;







