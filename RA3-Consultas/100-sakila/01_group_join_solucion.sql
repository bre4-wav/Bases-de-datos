-- ==============================================
-- SECCIÓN A) 30 CONSULTAS CON JOIN DE 2 TABLAS
-- ==============================================
USE sakila;
-- 1:  Para cada actor, muestra el número total de películas en las que aparece; es decir, cuenta cuántas filas de film_actor corresponden a cada actor.
SELECT CONCAT(first_name, ' ', last_name) AS nombre, COUNT(film_id)
FROM actor JOIN film_actor USING(actor_id)
GROUP BY (actor_id);
-- 2:  Lista solo los actores que participan en 20 o más películas (umbral alto) con su conteo.
SELECT CONCAT(first_name, ' ', last_name) AS nombre, COUNT(film_id)
FROM actor JOIN film_actor USING(actor_id)
GROUP BY (actor_id)
HAVING COUNT(film_id) >= 20;
-- 3:  Para cada idioma, indica cuántas películas están catalogadas en ese idioma.
SELECT language.name, COUNT(film_id)
FROM language JOIN film USING(language_id)
GROUP BY language_id;
-- 4:  Muestra el promedio de duración (length) de las películas por idioma y filtra aquellos idiomas con duración media estrictamente mayor a 110 minutos.
SELECT language.name, AVG(length)
FROM film JOIN language USING(language_id)
GROUP BY language_id
HAVING AVG(length > 110);
-- 5:  Para cada película, muestra cuántas copias hay en el inventario.
SELECT title, count(inventory_id)
FROM film JOIN inventory USING(film_id)
GROUP BY film_id;
-- 6:  Lista solo las películas que tienen al menos 5 copias en inventario.
SELECT title, count(inventory_id)
FROM film JOIN inventory USING(film_id)
GROUP BY film_id
HAVING count(inventory_id) >= 5;
-- 7:  Para cada artículo de inventario, cuenta cuántos alquileres se han realizado.
SELECT inventory_id, count(rental_id)
FROM inventory JOIN rental USING(inventory_id)
GROUP BY inventory_id;
-- 8:  Para cada cliente, muestra cuántos alquileres ha realizado en total.
SELECT CONCAT(first_name, ' ', last_name), COUNT(rental_id)
FROM customer JOIN rental USING(customer_id)
GROUP BY customer_id;
-- 9:  Lista los clientes con 30 o más alquileres acumulados.
SELECT CONCAT(first_name, ' ', last_name), COUNT(rental_id)
FROM customer JOIN rental USING(customer_id)
GROUP BY customer_id
HAVING COUNT(rental_id) >= 30;
-- 10:  Para cada cliente, muestra el total de pagos (suma en euros/dólares) que ha realizado.
SELECT CONCAT(first_name, ' ', last_name) AS nombre, SUM(amount) AS importe_total_pagado
FROM customer JOIN payment USING(customer_id)
GROUP BY customer_id;
-- 11:  Muestra los clientes cuyo importe total pagado es al menos 200.
SELECT CONCAT(first_name, ' ', last_name) AS nombre, SUM(amount) AS importe_total_pagado
FROM customer JOIN payment USING(customer_id)
GROUP BY customer_id
HAVING SUM(amount) >= 200;
-- 12:  Para cada empleado (staff), muestra el número de pagos que ha procesado.
SELECT CONCAT(first_name,' ',last_name) AS nombre, COUNT(payment_id) AS numero_de_pagos
FROM payment JOIN staff USING(staff_id)
GROUP BY staff_id;
-- 13:  Para cada empleado, muestra el importe total procesado.
SELECT CONCAT(first_name, ' ', last_name), SUM(amount)
FROM staff JOIN payment USING(staff_id)
GROUP BY staff_id;
-- 14:  Para cada tienda, cuenta cuántos artículos de inventario tiene.
SELECT store_id, COUNT(inventory_id)
FROM inventory JOIN store USING(store_id)
GROUP BY store_id;
-- 15:  Para cada tienda, cuenta cuántos clientes tiene asignados.
SELECT store_id, COUNT(customer_id)
FROM customer JOIN store USING(store_id)
GROUP BY store_id;
-- 16:  Para cada tienda, cuenta cuántos empleados (staff) tiene asignados.
SELECT store_id, COUNT(staff_id)
FROM store JOIN staff USING(store_id)
GROUP BY store_id;
-- 17:  Para cada dirección (address), cuenta cuántas tiendas hay ubicadas ahí (debería ser 0/1 en datos estándar).
SELECT address_id, address, COUNT(store_id) AS numero_de_tiendas
FROM address JOIN store USING(address_id)
GROUP BY address_id;
-- 18:  Para cada dirección, cuenta cuántos empleados residen en esa dirección.
SELECT address_id, address, COUNT(staff_id) AS empleados_residiendo_aqui
FROM address JOIN staff USING(address_id)
GROUP BY address_id;
-- 19:  Para cada dirección, cuenta cuántos clientes residen ahí.
SELECT address_id, address, COUNT(customer_id) AS clientes_residiendo_aqui
FROM address JOIN customer USING(address_id)
GROUP BY address_id;
-- 20:  Para cada ciudad, cuenta cuántas direcciones hay registradas.
SELECT city_id, city, COUNT(address_id) AS numero_de_direcciones
FROM address JOIN city USING(city_id)
GROUP BY city_id;
-- 21:  Para cada país, cuenta cuántas ciudades existen.
SELECT country, COUNT(city_id)
FROM city JOIN country USING(country_id)
GROUP BY country_id;
-- 22:  Para cada idioma, calcula la duración media de películas y muestra solo los idiomas con media entre 90 y 120 inclusive.
SELECT language.name, AVG(film.length)
FROM language JOIN film USING(language_id)
GROUP BY language_id
HAVING AVG(film.length)  >= 90 AND AVG(film.length) <= 120;
-- 23:  Para cada película, cuenta el número de alquileres que se han hecho de cualquiera de sus copias (usando inventario).
SELECT film_id, COUNT(rental_id)
FROM inventory JOIN rental USING(inventory_id)
GROUP BY film_id;
-- 24:  Para cada cliente, cuenta cuántos pagos ha realizado en 2005 (usando el año de payment_date).
SELECT customer_id, CONCAT(first_name, ' ', last_name), COUNT(payment_id)
FROM customer JOIN payment USING(customer_id)
WHERE YEAR(payment_date) = 2005
GROUP BY customer_id;
-- 25:  Para cada película, muestra el promedio de tarifa de alquiler (rental_rate) de las copias existentes (es un promedio redundante pero válido).
SELECT film_id, title, AVG(rental_rate)
FROM inventory JOIN film USING(film_id)
GROUP BY film_id;
-- 26:  Para cada actor, muestra la duración media (length) de sus películas.
SELECT actor_id, AVG(film.length)
FROM film_actor JOIN film USING(film_id)
GROUP BY actor_id
ORDER BY actor_id ASC;
-- 27:  Para cada ciudad, cuenta cuántos clientes hay (usando la relación cliente->address->city requiere 3 tablas; aquí contamos direcciones por ciudad).
SELECT city_id, city, COUNT(customer_id)
FROM customer JOIN address USING(address_id)
				JOIN city USING(city_id)
GROUP BY city_id
ORDER BY city_id ASC;
-- 28:  Para cada película, cuenta cuántos actores tiene asociados.
SELECT film_actor.film_id, title, COUNT(actor_id)
FROM film_actor JOIN film USING(film_id)
GROUP BY film_id;
-- 29:  Para cada categoría (por id), cuenta cuántas películas pertenecen a ella (sin nombre de categoría para mantener 2 tablas).
SELECT category_id, name, COUNT(film_id)
FROM film_category JOIN category USING(category_id)
GROUP BY category_id;
-- 30:  Para cada tienda, cuenta cuántos alquileres totales se originan en su inventario.
SELECT store_id, COUNT(rental_id)
FROM rental JOIN inventory USING(inventory_id)
GROUP BY store_id;
-- ==============================================
-- SECCIÓN B) 30 CONSULTAS CON JOIN DE 3 TABLAS
-- ==============================================
-- 31:  Para cada actor, cuenta cuántas películas tiene y muestra solo los que superan 15 películas.
SELECT actor_id, CONCAT(first_name, ' ', last_name), COUNT(film_id)
FROM actor JOIN film_actor USING(actor_id)
GROUP BY actor_id
HAVING COUNT(film_id) > 15;
-- 32:  Para cada categoría (por nombre), cuenta cuántas películas hay en esa categoría.
SELECT category_id, name, COUNT(film_id)
FROM category JOIN film_category USING(category_id)
GROUP BY category_id;
-- 33:  Para cada película, cuenta cuántos alquileres se han hecho de sus copias.

-- 34:  Para cada cliente, suma el importe pagado en 2005 y filtra clientes con total >= 150.
-- 35:  Para cada tienda, suma el importe cobrado por todos sus empleados.
-- 36:  Para cada ciudad, cuenta cuántos empleados residen ahí (staff -> address -> city).
-- 37:  Para cada ciudad, cuenta cuántas tiendas existen (store -> address -> city).
-- 38:  Para cada actor, calcula la duración media de sus películas del año 2006.
-- 39:  Para cada categoría, calcula la duración media y muestra solo las que superan 120.
-- 40:  Para cada idioma, suma las tarifas de alquiler (rental_rate) de todas sus películas.
-- 41:  Para cada cliente, cuenta cuántos alquileres realizó en fines de semana (SÁB-DO) usando DAYOFWEEK (1=Domingo).
-- 42:  Para cada actor, muestra el total de títulos distintos en los que participa (equivale a COUNT DISTINCT, sin subconsulta).
-- 43:  Para cada ciudad, cuenta cuántos clientes residen ahí (customer -> address -> city).
-- 44:  Para cada categoría, muestra cuántos actores distintos participan en películas de esa categoría.
-- 45:  Para cada tienda, cuenta cuántas copias totales (inventario) tiene de películas en 2006.
-- 46:  Para cada cliente, suma el total pagado por alquileres cuyo empleado pertenece a la tienda 1.
-- 47:  Para cada película, cuenta cuántos actores tienen el apellido de longitud >= 5.
-- 48:  Para cada categoría, suma la duración total (length) de sus películas.
-- 49:  Para cada ciudad, suma los importes pagados por clientes que residen en esa ciudad.
-- 50:  Para cada idioma, cuenta cuántos actores distintos participan en películas de ese idioma.
-- 51:  Para cada tienda, cuenta cuántos clientes activos (active=1) tiene.
-- 52:  Para cada cliente, cuenta en cuántas categorías distintas ha alquilado (aprox. vía film_category; requiere 4 tablas, aquí contamos películas 2006 por inventario).
-- 53:  Para cada empleado, cuenta cuántos clientes diferentes le han pagado.
-- 54:  Para cada ciudad, cuenta cuántas películas del año 2006 han sido alquiladas por residentes en esa ciudad.
-- 55:  Para cada categoría, calcula el promedio de replacement_cost de sus películas.
-- 56:  Para cada tienda, suma los importes cobrados en 2006 (vía empleados de esa tienda).
-- 57:  Para cada actor, cuenta cuántas películas tienen título de más de 12 caracteres.
-- 58:  Para cada ciudad, calcula la suma de pagos de 2005 y filtra las ciudades con total >= 300.
-- 59:  Para cada categoría, cuenta cuántas películas tienen rating 'PG' o 'PG-13'.
-- 60:  Para cada cliente, calcula el total pagado en pagos procesados por el empleado 2.
-- ==============================================
-- SECCIÓN C) 20 CONSULTAS CON JOIN DE 4 TABLAS
-- ==============================================
-- 61:  Para cada ciudad, cuenta cuántos clientes hay y muestra solo ciudades con 10 o más clientes.
-- 62:  Para cada actor, cuenta cuántos alquileres totales suman todas sus películas.
-- 63:  Para cada categoría, suma los importes pagados derivados de películas de esa categoría.
-- 64:  Para cada ciudad, suma los importes pagados por clientes residentes en esa ciudad en 2005.
-- 65:  Para cada tienda, cuenta cuántos actores distintos aparecen en las películas de su inventario.
-- 66:  Para cada idioma, cuenta cuántos alquileres totales se han hecho de películas en ese idioma.
-- 67:  Para cada cliente, cuenta en cuántos meses distintos de 2005 realizó pagos (meses distintos).
-- 68:  Para cada categoría, calcula la duración media de las películas alquiladas (considerando solo películas alquiladas).
-- 69:  Para cada país, cuenta cuántos clientes hay (country -> city -> address -> customer).
-- 70:  Para cada país, suma los importes pagados por sus clientes.
-- 71:  Para cada tienda, cuenta cuántas categorías distintas existen en su inventario.
-- 72:  Para cada tienda, suma la recaudación por categoría (resultado agregado por tienda y categoría).
-- 73:  Para cada actor, cuenta en cuántas tiendas distintas se han alquilado sus películas.
-- 74:  Para cada categoría, cuenta cuántos clientes distintos han alquilado películas de esa categoría.
-- 75:  Para cada idioma, cuenta cuántos actores distintos participan en películas alquiladas en ese idioma.
-- 76:  Para cada país, cuenta cuántas tiendas hay (país->ciudad->address->store).
-- 77:  Para cada cliente, cuenta los alquileres en los que la devolución (return_date) fue el mismo día del alquiler.
-- 78:  Para cada tienda, cuenta cuántos clientes distintos realizaron pagos en 2005.
-- 79:  Para cada categoría, cuenta cuántas películas con título de longitud > 15 han sido alquiladas.
-- 80:  Para cada país, suma los pagos procesados por los empleados de las tiendas ubicadas en ese país.
-- ==============================================
-- SECCIÓN D) 20 CONSULTAS EXTRA (DIFICULTAD +), <=4 JOINS
-- ==============================================
-- 81:  Para cada cliente, muestra el total pagado con IVA teórico del 21% aplicado (total*1.21), redondeado a 2 decimales.
-- 82:  Para cada hora del día (0-23), cuenta cuántos alquileres se iniciaron en esa hora.
-- 83:  Para cada tienda, muestra la media de length de las películas alquiladas en 2005 y filtra las tiendas con media >= 100.
-- 84:  Para cada categoría, muestra la media de replacement_cost de las películas alquiladas un domingo.
-- 85:  Para cada empleado, muestra el importe total por pagos realizados entre las 00:00 y 06:00 (inclusive 00:00, exclusivo 06:00).
-- 86:  Para cada actor, cuenta cuántas de sus películas tienen un título que contiene la palabra 'LOVE' (mayúsculas).
-- 87:  Para cada idioma, muestra el total de pagos de alquileres de películas en ese idioma.
-- 88:  Para cada cliente, cuenta en cuántos días distintos de 2005 realizó algún alquiler.
-- 89:  Para cada categoría, calcula la longitud media de títulos (número de caracteres) de sus películas alquiladas.
-- 90:  Para cada tienda, cuenta cuántos clientes distintos alquilaron en el primer trimestre de 2006 (enero-marzo).
-- 91:  Para cada país, cuenta cuántas categorías diferentes han sido alquiladas por clientes residentes en ese país.
-- 92:  Para cada cliente, muestra el importe medio de sus pagos redondeado a 2 decimales, solo si ha hecho al menos 10 pagos.
-- 93:  Para cada categoría, muestra el número de películas con replacement_cost > 20 que hayan sido alquiladas al menos una vez.
-- 94:  Para cada tienda, suma los importes pagados en fines de semana.
-- 95:  Para cada actor, cuenta cuántas películas suyas fueron alquiladas por al menos 5 clientes distintos (se cuenta alquileres y luego se filtra por HAVING).
-- 96:  Para cada idioma, muestra el número de películas cuyo título empieza por la letra 'A' y que han sido alquiladas.
-- 97:  Para cada país, suma el importe total de pagos realizados por clientes residentes y filtra países con total >= 1000.
-- 98:  Para cada cliente, cuenta cuántos días han pasado entre su primer y su último alquiler en 2005 (diferencia de fechas), mostrando solo clientes con >= 5 alquileres en 2005.
--     (Se evita subconsulta calculando sobre el conjunto agrupado por cliente y usando MIN/MAX de rental_date en 2005).
-- 99:  Para cada tienda, muestra la media de importes cobrados por transacción en el año 2006, con dos decimales.
-- 100:  Para cada categoría, calcula la media de duración (length) de películas alquiladas en 2006 y ordénalas descendentemente por dicha media.
