use mavenmovies;
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 
	staff.first_name AS manager_first_name, 
    staff.last_name AS manager_last_name,
    address.address, 
    address.district, 
    city.city, 
    country.country

FROM store
	LEFT JOIN staff  ON store.manager_staff_id = staff.staff_id
    LEFT JOIN address  ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id
;




	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

select 
	i.store_id,
    i.inventory_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
from inventory i
left join film f
on f.film_id=i.film_id;










/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT 
	i.store_id,
    f.rating,
    count(i.inventory_id) as inventory_items
from film f
Left join inventory i
on f.film_id=i.film_id
group by 1,2;    










/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

select 
	i.store_id,
    c.name as category_name,
    count(f.film_id) as Number_of_film,
    avg(f.replacement_cost) as Avg_replacement_cost,
    sum(f.replacement_cost) as sum_of_replacement
from film f
	LEFT JOIN film_category fc
		on f.film_id=fc.film_id    
left join inventory i
		on i.film_id=fc.film_id
left join category c
		on fc.category_id=c.category_id
group by 1,2
order by 5 desc;	


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

select 
	cus.first_name,
    cus.last_name,
    cus.store_id,
    ad.address,
    ci.city,
    ctry.country,
case when cus.active=1 then 'active' else 'inactive' end as status
from customer cus
	LEFT JOIN address ad
		on cus.address_id=ad.address_id
	LEFT JOIN city ci
		on ad.city_id=ci.city_id
    LEFT JOIN country ctry
		on ctry.country_id=ci.country_id;



/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

select
	c.first_name,
    c.last_name,
    count(r.rental_id) as rental_count,
    sum(p.amount) as ttl_amount
from customer c
LEFT JOIN rental r
	on c.customer_id=r.customer_id
LEFT JOIN payment p
		on r.rental_id=p.rental_id
        group by 1,2
        order by 4 desc;

	
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

select
	'Investor' as type,
    first_name,
    last_name,
    company_name
from investor
UNION
select 
	'advisor' as type,
    first_name,
    last_name,
    NULL
from advisor;


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
select
	CASE WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
		 when actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') then '2 awards'
		 else '1 awards'
	end as Number_of_awards,
	AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film     
from actor_award
group by 1; 


