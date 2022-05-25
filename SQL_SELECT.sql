/*SELECT запросы */

/* 1. Название и год выхода альбомов, вышедших в 2018 году */
SELECT name, release_year FROM albums
WHERE release_year = '2018'

/* 2. Название и продолжительность самого длительного трека */
SELECT name, duration FROM tracks
ORDER BY duration DESC
LIMIT 1;

/* Либо:*/
SELECT name, duration FROM tracks
where duration = (SELECT max(duration) FROM tracks);

/* 3. Название треков, продолжительность которых не менее 3,5 минуты */
SELECT name, duration FROM tracks
WHERE duration >= '00:03:30';

/* 4. Названия сборников, вышедших в период с 2018 по 2020 год включительно */
SELECT name, release_year FROM collections
WHERE release_year = IN ('2018', '2019', '2020');

/* 5. Исполнители, чье имя состоит из 1 слова */

SELECT name FROM singers
WHERE name NOT iLIKE '% %'

/* 6. Название треков, которые содержат слово "мой"/"my"*/
SELECT name FROM tracks
WHERE name iLIKE '%мой%' OR name iLIKE '%моя%'; 

/* Корректировка названий и типов столбцов ранее созданной базы
перед следующими запросами для более удобных вариантов записей */

ALTER TABLE genres
RENAME COLUMN id TO genre_id;

ALTER TABLE singers 
RENAME COLUMN id TO singer_id;

ALTER TABLE albums  
RENAME COLUMN id TO album_id;

ALTER TABLE tracks  
RENAME COLUMN id TO track_id;

ALTER TABLE collections  
RENAME COLUMN id TO collection_id;

ALTER TABLE albums 
ALTER COLUMN release_year TYPE INTEGER USING release_year::INTEGER;

ALTER TABLE collections 
ALTER COLUMN release_year TYPE INTEGER USING release_year::INTEGER;

/* количество исполнителей в каждом жанре
с сортировкой по количеству по убыванию и затем названию */

SELECT name AS Жанр,  COUNT(genre_id) AS Количество_исполнителей
FROM
  genres
  INNER JOIN singers_genres USING (genre_id)
GROUP BY 1
ORDER BY 2 DESC, 1;

/* количество треков, вошедших в альбомы 2000-2020 годов */

SELECT COUNT(track_id) AS Количество
FROM
  tracks
  INNER JOIN albums USING (album_id)  
WHERE release_year BETWEEN 2000 AND 2020;


/* средняя продолжительность треков по каждому альбому 
с сортировкой по средней длительности по убыванию */
SELECT album_id, albums.name, date_trunc('second', AVG(duration)) AS Средняя_продолжительность
FROM
  tracks
  INNER JOIN albums USING (album_id)
GROUP BY 1, 2
ORDER BY 3 DESC;

/* все исполнители, которые не выпустили альбомы в 2018 году */

SELECT singer_id, singers.name AS Исполнитель
FROM singers
WHERE singer_id NOT IN (
SELECT DISTINCT singer_id
FROM
  singers
  INNER JOIN singers_albums USING (singer_id)
  INNER JOIN albums USING (album_id)  
  WHERE release_year = 2018)
ORDER BY 1;

/* названия сборников, в которых присутствует конкретный исполнитель (выберите сами) */

SELECT collection_id, collections.name AS Сборник
FROM
  singers
  INNER JOIN singers_albums USING (singer_id)
  INNER JOIN albums USING (album_id)
  INNER JOIN tracks USING (album_id)
  INNER JOIN tracks_collections USING (track_id)
  INNER JOIN collections USING (collection_id)
WHERE singers.name = 'Цой'
ORDER BY 1;

/* название альбомов, в которых присутствуют исполнители более 1 жанра */
SELECT album_id, albums.name AS Альбом
FROM
  albums
  INNER JOIN singers_albums USING (album_id)
  INNER JOIN singers USING (singer_id)
WHERE singer_id IN (
  SELECT singer_id
  FROM singers_genres
  GROUP BY singer_id
  HAVING count(*) > 1)
ORDER BY 1;

/* наименование треков, которые не входят в сборники */
SELECT track_id, name
FROM
tracks
  LEFT JOIN tracks_collections USING (track_id)
WHERE collection_id IS NULL
ORDER BY 1;

/* исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько) */

SELECT singer_id, singers.name, duration AS Продолжительность
  FROM
  tracks
  INNER JOIN albums USING (album_id)  
  INNER JOIN singers_albums USING (album_id) 
  INNER JOIN singers USING (singer_id)
WHERE duration = (
SELECT MIN(duration) FROM tracks);

/* название альбомов, содержащих наименьшее количество треков */

SELECT album_id, albums.name, count(*) as Количество
  FROM albums
  INNER JOIN tracks USING (album_id)
  GROUP BY 1, 2
  HAVING count(*) = (
   SELECT MIN(n)
   FROM (
    SELECT COUNT(*) as n
    FROM albums
    INNER JOIN tracks USING (album_id)
    GROUP BY album_id) query_in_1)
   
/* Либо */

SELECT album_id, albums.name, count(*) as Количество
  FROM albums
  INNER JOIN tracks USING (album_id)
  GROUP BY 1, 2
  HAVING count(*) = (   
    SELECT COUNT(*)
    FROM albums
    INNER JOIN tracks USING (album_id)
    GROUP BY album_id
	ORDER BY 1
	LIMIT 1)
  





