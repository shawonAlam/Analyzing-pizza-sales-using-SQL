---basic
---Retrieve the total number of orders placed.
select count(*) as Total_number_of_odrder_placed from orders;

---Calculate the total revenue generated from pizza sales.
select 
round(sum(order_details.quantity * pizzas.price),2) as Total_sales
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id

---Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc


---Identify the most common pizza size ordered.

select top 1 pizzas.size, count(quantity) as order_count
from pizzas join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc

---List the top 5 most ordered pizza types along with their quantities.
select top 5 pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity desc

---intermediate
---Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc

---Determine the distribution of orders by hour of the day.
select DATEPART(hh, time) as Hour, count(order_id) as count_order  from orders
group by DATEPART(hh, time)
order by DATEPART(hh, time) 

---Join relevant tables to find the category-wise distribution of pizzas.
select category as Pizza_category , count(name) as pizza_type 
from pizza_types
group by category

---Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(total_pizzas) as Avg_order_quantity 
from
(select orders.date as orders_dates, sum(order_details.quantity) as total_pizzas
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as abc;


---Determine the top 3 most ordered pizza types based on revenue.

select top 3 pizza_types.name as pizza_name, sum(pizzas.price * order_details.quantity) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by revenue desc

---Advanced:
---Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, 
(sum(pizzas.price * order_details.quantity) / (select 
	round(sum(pizzas.price * order_details.quantity),2) as Total_sales
	from order_details join pizzas
	on order_details.pizza_id = pizzas.pizza_id)
*100) as Parcetage_of_contribution

from pizza_types join  pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by Parcetage_of_contribution

---Analyze the cumulative revenue generated over time.
select dates, sum(Revenue) over (order by dates) as cumulitive_revenue
from
(select orders.date as dates, round(sum(pizzas.price * order_details.quantity),2) as Revenue
from orders join order_details
on orders.order_id = order_details.order_id
join pizzas 
on pizzas.pizza_id = order_details.pizza_id
group by orders.date) as sales;


---Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category, name, Revenue 
from  
(select category, name, Revenue, 
Rank() over(partition by category order by Revenue desc) as ranking
from
(select pizza_types.category, pizza_types.name,
sum(pizzas.price * order_details.quantity) as Revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as table1) as table2
where ranking <= 3








