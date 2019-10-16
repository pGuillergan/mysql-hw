USE sakila;

#1a ------------------------------
SELECT first_name, last_name FROM actor;

#1b ------------------------------
SELECT CONCAT( first_name, ' ',  last_name) AS 'Actor Name' FROM actor;

#2a ------------------------------
SELECT actor_id, first_name, last_name FROM actor WHERE first_name='Joe';

#2b ------------------------------
SELECT * FROM actor WHERE last_name LIKE '%gen%';

#2c ------------------------------
SELECT * FROM actor WHERE last_name LIKE '%li%' ORDER BY last_name, first_name;

#2d ------------------------------
SHOW TABLES;
SELECT * FROM country;
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a ------------------------------
SELECT * FROM actor;
ALTER TABLE actor ADD description BLOB;

#3b ------------------------------
SELECT * FROM actor;
ALTER TABLE actor DROP description;

#4a ------------------------------
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;

#4b ------------------------------
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;

#4c ------------------------------
SELECT * FROM actor WHERE last_name = 'williams';
UPDATE actor SET first_name = 'HARPO' WHERE first_name='GROUCHO' AND last_name = 'WILLIAMS';

#4d ------------------------------
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name='HARPO' AND last_name = 'WILLIAMS';
SELECT * FROM actor WHERE last_name = 'williams';

#5a ------------------------------
SHOW TABLES;
SELECT * FROM address;

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50),
  address2 VARCHAR(50),
  district VARCHAR(20),
  city_id SMALLINT UNSIGNED,
  postal_code VARCHAR(10),
  phone VARCHAR(20),
  location GEOMETRY,
  last_update TIMESTAMP,
  PRIMARY KEY (address_id)
);

#6a ------------------------------
SELECT * FROM staff;
SELECT * FROM address;

SELECT s.first_name, s.last_name, a.address FROM staff AS s INNER JOIN address AS a ON s.address_id=a.address_id;

#6b ------------------------------
SELECT * FROM staff;
SELECT * FROM payment;

SELECT s.first_name, s.last_name, SUM(p.amount) AS 'Total Amount' FROM staff AS s INNER JOIN payment AS p ON s.staff_id=p.staff_id GROUP BY s.staff_id;

#6c ------------------------------
SELECT * FROM film;
SELECT * FROM film_actor;

SELECT f.title, COUNT(a.actor_id) AS 'Number of Actors' FROM film f INNER JOIN film_actor a ON f.film_id=a.film_id GROUP BY f.title;

#6d ------------------------------
SHOW TABLES;
SELECT * FROM inventory;
SELECT * FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE';

SELECT f.title, COUNT(i.inventory_id) AS 'Stocked Units' FROM film f INNER JOIN inventory i ON f.film_id=i.film_id GROUP BY i.film_id HAVING f.title = 'HUNCHBACK IMPOSSIBLE';

#6e ------------------------------
SELECT * FROM payment; # get amount here
SELECT * FROM customer; # get fist_name, last_name

SELECT c.first_name, c.last_name, SUM(p.amount) FROM customer c INNER JOIN payment p ON p.customer_id=c.customer_id GROUP BY p.customer_id ORDER BY c.last_name;

#7a ------------------------------
SELECT * FROM film;
SELECT * FROM language;

SELECT title FROM film WHERE (title LIKE 'Q%' OR title LIKE 'K%') 
AND language_id= (SELECT language_id FROM language WHERE name='English');

#7b ------------------------------
SHOW TABLES;
SELECT * FROM actor; #get rows
SELECT * FROM film_actor; # get actor ids based on film id
SELECT * FROM film; # get film ID here

SELECT first_name, last_name FROM actor WHERE actor_id IN
	(SELECT actor_id FROM film_actor WHERE film_id = 
		(SELECT film_id FROM film WHERE title ='ALONE TRIP')
	)
;

#7c ------------------------------
SHOW TABLES;
SELECT * FROM country WHERE country = "canada"; # get canada country id
SELECT * FROM city WHERE country_id = 20;
SELECT * FROM address; # get address id here
SELECT * FROM customer; # get names and email here

SELECT cu.first_name, cu.last_name, cu.email FROM customer AS cu 
	INNER JOIN address AS ad ON cu.address_id=ad.address_id
    INNER JOIN city AS ci ON ad.city_id=ci.city_id
    INNER JOIN country AS co ON ci.country_id=co.country_id
    WHERE co.country = "Canada";

#7d ------------------------------
SHOW TABLES;
SELECT * FROM category; # get category_id here
SELECT * FROM film_category; # link category_id and film_id here
SELECT * FROM film;

SELECT f.title, c.name FROM film AS f 
	INNER JOIN film_category AS fc ON f.film_id=fc.film_id
    INNER JOIN category AS c ON fc.category_id=c.category_id
    WHERE c.name = "Family";

#7e ------------------------------
SHOW TABLES;
SELECT * FROM rental; # get count 
SELECT * FROM inventory;

SELECT r.inventory_id, count(r.rental_date), f.title
FROM inventory AS i
INNER JOIN film AS f ON f.film_id = i.film_id
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY count(r.rental_date) desc;

#7f ------------------------------
SHOW TABLES;
SELECT* FROM store;
SELECT* FROM address;
SELECT * FROM staff;
SELECT * FROM payment; # staff id equals store id

SELECT staff_id as store_id, sum(amount) FROM payment GROUP BY store_id;

#7g ------------------------------
SELECT * FROM store;
SELECT * FROM city; #city id and country id
SELECT * FROM country; # country id
SELECT * FROM address; # address id and city id

SELECT s.store_id, ci.city, co.country FROM store AS s
	INNER JOIN address AS a ON s.address_id=a.address_id
	INNER JOIN city AS ci ON a.city_id=ci.city_id
    INNER JOIN country AS co ON ci.country_id=co.country_id
;

#7h ------------------------------
# use category, film_category, inventory, payment, rental
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT c.name AS 'Category', SUM(p.amount) AS 'Total Amount'
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id=fc.category_id
INNER JOIN inventory AS i ON fc.film_id=i.film_id
INNER JOIN rental AS r ON i.inventory_id=r.inventory_id
INNER JOIN payment AS p ON r.rental_id=p.rental_id
GROUP BY c.name ORDER BY SUM(p.amount) DESC LIMIT 5;

#8a ------------------------------
CREATE VIEW custom_view AS
SELECT c.name AS 'Category' , SUM(p.amount) AS 'Total Amount'
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id=fc.category_id
INNER JOIN inventory AS i ON fc.film_id=i.film_id
INNER JOIN rental AS r ON i.inventory_id=r.inventory_id
INNER JOIN payment AS p ON r.rental_id=p.rental_id
GROUP BY c.name ORDER BY SUM(p.amount) DESC LIMIT 5;

#8b ------------------------------
SELECT * FROM custom_view;

#8c ------------------------------
DROP VIEW custom_view;
