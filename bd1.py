import sqlalchemy
import urllib.parse
from pprint import pprint

# Просто потренировался с sqlalchemy
# Все ДЗ находится в sql-файлах
password = urllib.parse.quote_plus("Sofa@2015")
db = f'postgresql://sergryap:{password}@localhost:5432/sergryap'
engine = sqlalchemy.create_engine(db)
connection = engine.connect()

sel = connection.execute("""
SELECT collections.name, genres.name, COUNT(*) AS Количество 
FROM
  genres
  INNER JOIN singers_genres USING (genre_id)
  INNER JOIN singers USING (singer_id)
  INNER JOIN singers_albums USING (singer_id)
  INNER JOIN albums USING (album_id)
  INNER JOIN tracks USING (album_id)
  INNER JOIN tracks_collections USING (track_id)
  INNER JOIN collections USING (collection_id)
WHERE genres.name = 'Поп'
GROUP BY 1, 2
ORDER BY 3, 1
""").fetchall()
pprint(sel)

# количество исполнителей в каждом жанре
# с сортировкой по количеству по убыванию и затем названию
sel = connection.execute("""
SELECT name AS Жанр, COUNT(genre_id) AS Количество_исполнителей
FROM
  genres
  INNER JOIN singers_genres USING (genre_id)
GROUP BY 1
ORDER BY 2 DESC, 1;
""").fetchall()
pprint(sel)

# все исполнители, которые не выпустили альбомы в 2018 году
sel = connection.execute("""
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
""").fetchall()
pprint(sel)

# название альбомов, в которых присутствуют исполнители более 1 жанра
sel = connection.execute("""
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
""").fetchall()
pprint(sel)

# Наименование треков, которые не входят в сборники
sel = connection.execute("""
SELECT track_id, name
FROM
tracks
  LEFT JOIN tracks_collections USING (track_id)
WHERE collection_id IS NULL
ORDER BY 1;
""").fetchall()
pprint(sel)

# Название альбомов, содержащих наименьшее количество треков
sel = connection.execute("""
SELECT album_id, albums.name, count(*) AS Количество
FROM albums
  INNER JOIN tracks USING (album_id)
  GROUP BY 1, 2
  HAVING count(*) = (
   SELECT MIN(n)
   FROM (
    SELECT COUNT(*) as n
    FROM albums
    INNER JOIN tracks USING (album_id)
    GROUP BY album_id) query_in_1); 
""").fetchall()
pprint(sel)
