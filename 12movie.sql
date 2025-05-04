-- You need to create a movie database.
-- Create three tables, one for
-- actors(AID, name),
-- movies(MID, title) and
-- actor_role(MID, AID, rolename).
-- Use appropriate data types for each of the attributes, and add appropriate primary/foreign key constraints.
-- 1.
-- Insert data to the above tables (approx 3 to 6 rows in each table), including data for actor "Charlie Chaplin", and for yourself (using your roll number as ID).
-- 2.
-- Write a query to list all movies in which actor "Charlie Chaplin" has acted, along with the number of roles he had in that movie.
-- 3.
-- Write a query to list all actors who have not acted in any movie.
-- 4.
-- List names of actors, along with titles of movies they have acted in. If they have not acted in any movie, show the movie title as null.
-- 5.
-- List all roles of a given actor
-- 6.
-- Write a trigger to convert actor name in uppercase.

-- Drop tables if they already exist
DROP TABLE IF EXISTS actor_role;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS actors;

-- Create 'actors' table
CREATE TABLE actors (
    AID INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Create 'movies' table
CREATE TABLE movies (
    MID INT PRIMARY KEY,
    title VARCHAR(255)
);

-- Create 'actor_role' table
CREATE TABLE actor_role (
    MID INT,
    AID INT,
    rolename VARCHAR(100),
    PRIMARY KEY (MID, AID, rolename),
    FOREIGN KEY (MID) REFERENCES movies(MID) ON DELETE CASCADE,
    FOREIGN KEY (AID) REFERENCES actors(AID) ON DELETE CASCADE
);

-- Insert sample data into 'actors'
-- Replace 999 with your actual roll number if needed
INSERT INTO actors (AID, name) VALUES
(1, 'Charlie Chaplin'),
(2, 'Meryl Streep'),
(3, 'Leonardo DiCaprio'),
(4, 'Tom Hanks'),
(999, 'Your Name');

-- Insert sample data into 'movies'
INSERT INTO movies (MID, title) VALUES
(101, 'Modern Times'),
(102, 'The Great Dictator'),
(103, 'The Post'),
(104, 'Forrest Gump');

-- Insert sample data into 'actor_role'
INSERT INTO actor_role (MID, AID, rolename) VALUES
(101, 1, 'Factory Worker'),
(102, 1, 'Adenoid Hynkel'),
(102, 1, 'The Barber'),
(103, 2, 'Katharine Graham'),
(104, 4, 'Forrest Gump'),
(103, 999, 'Reporter');

-- Required Queries:

-- 1. List all movies in which Charlie Chaplin has acted, along with the number of roles in each movie
SELECT m.title, COUNT(ar.rolename) AS role_count
FROM movies m
JOIN actor_role ar ON m.MID = ar.MID
JOIN actors a ON a.AID = ar.AID
WHERE a.name = 'CHARLIE CHAPLIN'
GROUP BY m.title;

-- 2. List all actors who have not acted in any movie
SELECT a.name
FROM actors a
LEFT JOIN actor_role ar ON a.AID = ar.AID
WHERE ar.MID IS NULL;

-- 3. List names of actors, along with titles of movies they have acted in
--    If they have not acted, show movie title as NULL
SELECT a.name, m.title
FROM actors a
LEFT JOIN actor_role ar ON a.AID = ar.AID
LEFT JOIN movies m ON ar.MID = m.MID;

-- 4. List all roles of a given actor (e.g., Charlie Chaplin)
SELECT m.title, ar.rolename
FROM movies m
JOIN actor_role ar ON m.MID = ar.MID
JOIN actors a ON a.AID = ar.AID
WHERE a.name = 'CHARLIE CHAPLIN';

-- 5. Trigger to convert actor name to UPPERCASE on insert
DELIMITER //

CREATE TRIGGER uppercase_actor_name
BEFORE INSERT ON actors
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END;
//

DELIMITER ;
