Create table books(
Book_ID serial ,	Title varchar(100),	Author varchar(100),	Genre varchar(100),	Published_Year int,	Price numeric(10,2),
Stock int);

Alter table books add constraint Book_ID primary key (Book_ID);

select * from books;
select * from customers;
select * from orders;

create table customers(
Customer_ID serial primary key,
Name varchar(100),	Email varchar(100),	Phone varchar(100),	City varchar(100),	Country varchar(150)
);
Create table orders(
Order_ID serial primary key, Customer_ID int references customers(Customer_ID), 
Book_ID int references books(Book_ID),
Order_Date	Date,
Quantity int,
Total_Amount numeric(10,2)
);

-- retrive all books on 'friction' genre
select * from books where genre = 'Fiction';

-- find books published after the year 1995
select * from books where published_year > 1950;

-- list all customers from canada
select * from customers where country = 'Canada';

-- show orders placed in november 2023
select * from orders where order_date between '2023-11-01' and '2023-11-30';

-- retrive the total stock of books available;
select sum(stock) as total_stock from books;

-- find the details of most expensive books
select * from books order by price desc limit 1; 

-- show all customers who orderd more than 1 quantity of books
select * from orders where quantity > 1;

-- select all the orders where the total amount exceeds more than $20;
select * from orders where total_amount > 20;

-- list all geners available in the books table
select distinct genre from books;

-- Find the book with lowest stock
select * from books order by stock ASC limit 1;

-- calculate the total revenue generated from all orders;
select sum(total_amount) as revenue_generated from orders;

-- retrive the total number of books sold for each gener
select * from orders;

select b.genre, SUM(o.quantity) as total_books_sold
from books b join orders o
on b.book_id = o.book_id
group by b.genre;

-- find the average price of books in the fantacy genre
select AVG(price) as average_price from books where Genre = 'Fantasy';

-- list customers who have placed at least 2 orders
select c.customer_id, c.name, Count(o.order_id) as order_count
from orders o join customers c on
c.customer_id = o.customer_id
group by c.customer_id having count(o.order_id)>=2;

-- find the most frequenty ordered book
select b.title,b.author,b.genre,b.book_id, count (o.order_id) from
books b join orders o on
b.book_id = o.book_id
group by b.book_id order by count(o.order_id) desc limit 1;

-- show top 3 most expensive books from fantacy genre
select * from books where genre = 'Fantasy' order by price DESC limit 3;

-- retrive the total quantity of books sold by each author;
select b.author, sum(o.quantity) as total_books_sold from
books b join orders o on
b.book_id = o.book_id
group by b.author;

-- List the cities where customers who spent over $30 are located;
select * from customers;
select * from orders;
select distinct c.city,c.name,o.customer_id, o.total_amount as total_amount_spent
from orders o join customers c on
o.customer_id = c.customer_id where o.total_amount >30;

-- find the customers who spent the most on orders;
select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o join customers c on
o.customer_id = c.customer_id 
group by c.customer_id, c.name order by total_spent desc limit 1;

-- calculate the stocks remaining after fulfilling all orders 
select b.book_id, b.title, b.stock, Coalesce (Sum(o.quantity),0) as order_quantity, 
b.stock - Coalesce (Sum(o.quantity),0) as remaining_quantity
from
books b left join orders o
on b.book_id = o.book_id
group by b.book_id order by b.book_id;
