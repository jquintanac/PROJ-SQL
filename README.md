# PROY-SQL

![alt text](https://github.com/jquintanac/PROY-SQL/blob/main/imgs/sqlproyect.jpg?raw=true)

The goal of this project is to build a database from seven csv files about video club data. These csv files have to be cleaned to work with them and check them to build a sql database.

## Requeriments

1) Clean the data

2) Build your databse with at least 10 queries including: join, groupby, orderby, where, subqueries…

## Development

### Cleaning and treatment data 🧹

First of all, I uploaded all csv files in jupyter notebook to look the data and try to comprehend them. Data seemed to be relationated with a video club due to I found information about: films, actor/actress, rental, categories, languages, inventories and a apparently old data about movies.

My first step was checking duplicates and data missing. I did not find duplicates but one column in film dataframe seemed to have one column about origin language that was empty so I deleted it for not giving information. 
After that, I figured out that two dataframe had the same name but the information was not so I changed the 'name' in language for 'name_lang' and the 'name' in category for 'name_cat'. This way is no place for mistakes.
Working on table by table, I found a duplicate entry in actor table where two differents ID were taken by the same actress. Due to the ID could not be traceable by another table, I had to delete one of them (ID=110 instead ID=101). 
Finally, I created a new variable within first name and last name for actor and old data called 'name_act' that will be usefull as a primary key to conect them and another tables.

To work with it, I exported data as csv files to upload directly in MySQL.

### MySQL 💻

I created a new schema (called 'proy') and I uploaded the seven csv files. First of all, I worked in reverse engineer to see the connections, primary and foreign keys. All the connections were many-to-many. Check the result below:
    
![alt text](https://github.com/jquintanac/PROY-SQL/blob/main/imgs/connections.png?raw=true)
    
I worked on some querys to find interesting information or for using the database in case of need:

♦ I created a temporary table called 'moviesold' with left join to add category (by category_id) and actor (by name_act) to old_hdd to have a database with title, actor/actress name and id, and category. 📹
    
♦ A table called 'moviesrev' based on 'moviesold' was created but with a left join on film (by title) and language (by language_id) to have a complete database about old and recent movies with language info, movie description, rental, rating, length, replacement cost, special features... 🗒

♦ I created a table called 'infomov' based on 'moviesold' with left join as I did with 'moviesrev' but showing the relevant info for clients about movies such as title, description, rating, cast, movie length, category, release year. ℹ
    
♦ Working on 'infomov', with count / group by and order by asc/desc and limit N, I showed in which movies have been every actor/actress, with the most and less acclaimed ones. I dit another query to know how many actors and actresses were participated in each movie. 🏆
    
♦ Many videoclub clients would like to know about family movies to watch with their kids, so I ideated a where or/and query based on 'infomov' for Animation/Children/Family categories and G, PG and PG-13 rating. 👨‍👩‍👧‍👦
    
♦ For those clients who prefer short films, I created a query with where / between / order by desc / limit to search movies with a determinated length in case of a client needs it. 🎞
    
♦ A similar table as 'infomov' table was created and named 'videodep' but for the videoclub staff where they can find info about rental, replacement cost, ID customer, ID movie, ID cast, inventory, store... 💸
    
♦ Thanks to 'videodep' and count/sum group by queries with order by asc/desc and limit N, you could see the top 3 customers based on fidelity or even check the quantity and profits of sales based on its categories (always drama wins...💔).

♦ Finally, applying a simple subquery we can find the shortest or longest films from a unique category or those ones you like but avoiding those you do not like.🤙


## Links & Resources

https://numpy.org/doc/1.18/

https://pandas.pydata.org/

https://docs.python.org/3/library/functions.html

https://matplotlib.org/

https://seaborn.pydata.org/

https://pandas.pydata.org/docs/

https://towardsdatascience.com/beware-of-storytelling-with-data-1710fea554b0?gi=537e0c10d89e
