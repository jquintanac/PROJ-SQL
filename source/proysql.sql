-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema proy
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema proy
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `proy` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `proy` ;

-- -----------------------------------------------------
-- Table `proy`.`film2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`film2` (
  `film_id` INT NOT NULL,
  `title` TEXT NOT NULL,
  `description` TEXT NOT NULL,
  `release_year` INT NOT NULL,
  `language_id` INT NOT NULL,
  `rental_duration` INT NOT NULL,
  `rental_rate` DOUBLE NOT NULL,
  `length` INT NOT NULL,
  `replacement_cost` DOUBLE NOT NULL,
  `rating` TEXT NOT NULL,
  `special_features` TEXT NOT NULL,
  PRIMARY KEY (`film_id`, `language_id`, `title`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `proy`.`old_hdd2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`old_hdd2` (
  `first_name` TEXT NOT NULL,
  `last_name` TEXT NOT NULL,
  `name_act` TEXT NOT NULL,
  `title` TEXT NOT NULL,
  `category_id` INT NOT NULL,
  INDEX `fk_old_hdd2_film21_idx` (`title` ASC) VISIBLE,
  PRIMARY KEY (`title`),
  CONSTRAINT `fk_old_hdd2_film21`
    FOREIGN KEY (`title`)
    REFERENCES `proy`.`film2` (`title`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `proy`.`actor2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`actor2` (
  `actor_id` INT NOT NULL,
  `name_act` TEXT NOT NULL,
  INDEX `fk_actor2_old_hdd22_idx` (`name_act` ASC) VISIBLE,
  PRIMARY KEY (`name_act`),
  CONSTRAINT `fk_actor2_old_hdd22`
    FOREIGN KEY (`name_act`)
    REFERENCES `proy`.`old_hdd2` (`name_act`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `proy`.`category2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`category2` (
  `category_id` INT NOT NULL,
  `name_cat` TEXT NOT NULL,
  INDEX `fk_category2_old_hdd21_idx` (`category_id` ASC) VISIBLE,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `fk_category2_old_hdd21`
    FOREIGN KEY (`category_id`)
    REFERENCES `proy`.`old_hdd2` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `proy`.`inventory2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`inventory2` (
  `inventory_id` INT NOT NULL,
  `film_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  INDEX `fk_inventory2_film21_idx` (`film_id` ASC) VISIBLE,
  PRIMARY KEY (`film_id`, `inventory_id`),
  CONSTRAINT `fk_inventory2_film21`
    FOREIGN KEY (`film_id`)
    REFERENCES `proy`.`film2` (`film_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `proy`.`language2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`language2` (
  `language_id` INT NOT NULL,
  `name_lang` TEXT NOT NULL,
  INDEX `fk_language2_film21_idx` (`language_id` ASC) VISIBLE,
  PRIMARY KEY (`language_id`),
  CONSTRAINT `fk_language2_film21`
    FOREIGN KEY (`language_id`)
    REFERENCES `proy`.`film2` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `proy`.`rental2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `proy`.`rental2` (
  `rental_id` INT NOT NULL,
  `inventory_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `staff_id` INT NOT NULL,
  INDEX `fk_rental2_inventory21_idx` (`inventory_id` ASC) VISIBLE,
  PRIMARY KEY (`inventory_id`),
  CONSTRAINT `fk_rental2_inventory21`
    FOREIGN KEY (`inventory_id`)
    REFERENCES `proy`.`inventory2` (`inventory_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Creo una tabla temporal a través de tres tablas con: película, categoría, año de lanzamiento, actor/actriz y su ID

create temporary table if not exists moviesold
select actor2.actor_id, old_hdd2.name_act, old_hdd2.title, old_hdd2.release_year, category2.name_cat
from old_hdd2
left join actor2
on actor2.name_act = old_hdd2.name_act
left join category2
on category2.category_id = old_hdd2.category_id;

select * from moviesold;

-- Creo una tabla fija a través de la tabla anterior para añadir el id de la película y el idioma. Esta tabla será la estructura de muchas otras.

create table if not exists moviesrev
select moviesold.actor_id, moviesold.name_act, film2.film_id, moviesold.title, moviesold.release_year, moviesold.name_cat, language2.name_lang 
from moviesold
left join film2
on film2.title = moviesold.title
left join language2
on language2.language_id = film2.language_id;

select * from moviesrev;

-- Creo una tabla a través de la tabla moviesold para añadir información de la película relevante para el videoclub. Con esta tabla podremos ver cuánto dura la película, su idioma, de qué va, en qué año se estrenó, su valoración y los actores y/o actrices que participan en ella.

create table if not exists infomov
select moviesold.title, film2.description, moviesold.release_year, moviesold.name_cat, language2.name_lang, film2.length, film2.rating, moviesold.name_act
from moviesold
left join film2
on film2.title = moviesold.title
left join language2
on language2.language_id = film2.language_id;

select * from infomov;

-- Para esta misma tabla podemos agrupar por actor/actriz y ver en cuántas películas han participado, incluso el que más ha trabajado y el que menos.

select name_act, count(title)
from infomov
group by name_act;

select name_act, count(title) as total
from infomov
group by name_act
order by total desc limit 10;

select name_act, count(title) as total
from infomov
group by name_act
order by total asc limit 10;

-- Con la fórmula inversa podemos ver cuántos actores/actrices registrados hay por película.

select title, count(name_act) as total
from infomov
group by title;


-- Podríamos hacer una selección de aquellas películas familiares por categoría o rating.

select * 
from infomov
where (name_cat = 'Animation' or name_cat = 'Children' or name_cat = 'Family') and (rating = 'G' or rating = 'PG' or rating ='PG-13');

-- Podríamos también seleccionar sólo las películas que no sean excesivamente largas.

select *
from infomov
where length between 60 and 100
order by length desc limit 10;


-- Es necesario también hacer una tabla útil para el dependiente del videoclub en la que necesitamos datos diferentes tales como los datos del cliente, el identificador de la película en el inventario, la tienda en la que se encuentra, el precio de alquiler (rental_rate), el coste por pérdida de la película (replacement_cost)...


create table if not exists videodep
select film2.film_id, moviesold.title, moviesold.actor_id, moviesold.name_act, moviesold.name_cat, film2.rental_duration, film2.rental_rate, film2.replacement_cost, rental2.customer_id, inventory2.store_id, rental2.inventory_id 
from moviesold
left join film2
on film2.title = moviesold.title
left join language2
on language2.language_id = film2.language_id
left join inventory2
on inventory2.film_id = film2.film_id
left join rental2
on rental2.inventory_id = inventory2.inventory_id;

select * from videodep;


-- De esta tabla podemos conocer quién es el top 3 clientes o la categoría más cara.

select customer_id, count(customer_id) as total
from videodep
group by customer_id
order by total desc limit 3;

select name_cat, count(name_cat) as qty, sum(rental_rate) as total
from videodep
group by name_cat
order by total desc limit 5;

-- Una manera sencilla de aplicar una subquery para comprobar las películas más cortas y más largas del repertorio que no sean de Sci-Fi (por ejemplo).

select title, name_cat, length
from infomov
where length = (
select min(length)
from infomov)
or length = (
select max(length)
from infomov)
and name_cat != 'Sci-Fi'
order by length desc;
