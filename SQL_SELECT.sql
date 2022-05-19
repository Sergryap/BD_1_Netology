/*SELECT запросы */

/* 1. Название и год выхода альбомов, вышедших в 2018 году */
SELECT name, release_year FROM albums
WHERE release_year = '2018'

/* 2. Название и продолжительность самого длительного трека */
SELECT name, duration FROM tracks
ORDER BY duration DESC
LIMIT 1;

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
