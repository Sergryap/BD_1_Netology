/* Создание таблиц для базы данных музыкального сервера */

CREATE TABLE IF NOT EXISTS
singers ( 
id SERIAL PRIMARY KEY,  
name VARCHAR(100) NOT NULL 
); 
  
CREATE TABLE IF NOT EXISTS
albums (  
id SERIAL PRIMARY KEY , 
name VARCHAR(100) NOT NULL, 
release_year VARCHAR(4)
); 
  
CREATE TABLE IF NOT EXISTS
tracks ( 
id SERIAL PRIMARY KEY,  
album_id INTEGER REFERENCES albums(id), 
name VARCHAR(100) NOT NULL, 
duration INTERVAL MINUTE TO SECOND  
); 
  
CREATE TABLE IF NOT EXISTS
genres (
id SERIAL PRIMARY KEY,   
name VARCHAR(50) NOT NULL 
 );

CREATE TABLE IF NOT EXISTS
singers_genres (
singer_id INTEGER NOT NULL REFERENCES singers(id),
genre_id INTEGER NOT NULL REFERENCES genres(id),
CONSTRAINT singers_genres_unique PRIMARY KEY (singer_id, genre_id)
 );

CREATE TABLE IF NOT EXISTS
singers_albums (
id SERIAL PRIMARY KEY,  
singer_id INTEGER NOT NULL REFERENCES singers(id),
album_id INTEGER NOT NULL REFERENCES albums(id)
 );

CREATE TABLE IF NOT EXISTS
collections (
id SERIAL PRIMARY KEY,  
name VARCHAR(50) NOT NULL,
release_year VARCHAR(4)
);

CREATE TABLE IF NOT EXISTS
tracks_collections (
track_id INTEGER REFERENCES tracks(id),
collection_id INTEGER REFERENCES collections(id),
CONSTRAINT track_collection_unique PRIMARY KEY (track_id, collection_id)
);



/* Создание таблиц схемы отношений сотрудник-отдел */

CREATE TABLE IF NOT EXISTS
departments (
id SERIAL PRIMARY KEY, 
name VARCHAR(10) NOT NULL, 
chief VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS
employees (
id SERIAL PRIMARY KEY, 
name VARCHAR(50) NOT NULL,
department_id INTEGER NOT NULL REFERENCES departments(id)
);