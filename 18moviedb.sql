-- You need to create a movie database.
-- Create three tables, one for
-- actors(AID, name),
-- movies(MID, title) and
-- actor_role(MID, AID, rolename).
-- Use appropriate data types for each of the attributes, and add appropriate primary/foreign key constraints.
-- 7.
-- Insert data to the above tables (approx 3 to 6 rows in each table), including data for actor "Charlie Chaplin", and for yourself (using your roll number as ID).
-- 8.
-- Write a query to list all movies in which actor "Charlie Chaplin" has acted, along with the number of roles he had in that movie.
-- 9.
-- Write a query to list all actors who have not acted in any movie
-- 10.
-- List names of actors, along with titles of movies they have acted in. If they have not acted in any movie, show the movie title as null.
-- 11.
-- List all roles of a given actor
-- 12.
-- Write a trigger to convert actor name in uppercase.

-- DROP tables if they already exist
DROP TABLE IF EXISTS actor_role;
DROP TABLE IF EXISTS actors;
DROP TABLE IF EXISTS movies;

-- Create actors table
CREATE TABLE actors (
    AID INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Create movies table
CREATE TABLE movies (
    MID INT PRIMARY KEY,
    title VARCHAR(100)
);

-- Create actor_role table (junction table for many-to-many)
CREATE TABLE actor_role (
    MID INT,
    AID INT,
    rolename VARCHAR(100),
    PRIMARY KEY (MID, AID, rolename),
    FOREIGN KEY (MID) REFERENCES movies(MID),
    FOREIGN KEY (AID) REFERENCES actors(AID)
);

-- Insert sample actors (include Charlie Chaplin and roll number 2301)
INSERT INTO actors (AID, name) VALUES
(1, 'Charlie Chaplin'),
(2, 'Emma Watson'),
(3, 'Robert Downey Jr.'),
(4, 'Tom Holland'),
(2301, 'Your Name');  -- Replace "Your Name" with your actual name if needed

-- Insert sample movies
INSERT INTO movies (MID, title) VALUES
(101, 'Modern Times'),
(102, 'Iron Man'),
(103, 'Harry Potter'),
(104, 'Avengers'),
(105, 'The Great Dictator');

-- Insert actor_role entries
INSERT INTO actor_role (MID, AID, rolename) VALUES
(101, 1, 'Factory Worker'),
(105, 1, 'Hynkel'),
(102, 3, 'Tony Stark'),
(103, 2, 'Hermione'),
(104, 4, 'Spiderman'),
(104, 3, 'Iron Man');

-- 8. Movies Charlie Chaplin acted in + role count
SELECT m.title, COUNT(ar.rolename) AS role_count
FROM movies m
JOIN actor_role ar ON m.MID = ar.MID
JOIN actors a ON ar.AID = a.AID
WHERE a.name = 'Charlie Chaplin'
GROUP BY m.title;

-- 9. List actors who have not acted in any movie
SELECT a.name
FROM actors a
LEFT JOIN actor_role ar ON a.AID = ar.AID
WHERE ar.MID IS NULL;

-- 10. List actor names and movies they've acted in (even if not acted)
SELECT a.name, m.title
FROM actors a
LEFT JOIN actor_role ar ON a.AID = ar.AID
LEFT JOIN movies m ON ar.MID = m.MID;

-- 11. List all roles of a given actor (replace 'Charlie Chaplin' with desired name)
SELECT a.name, m.title, ar.rolename
FROM actor_role ar
JOIN actors a ON ar.AID = a.AID
JOIN movies m ON ar.MID = m.MID
WHERE a.name = 'Charlie Chaplin';

-- 12. Trigger to convert actor name to uppercase before insert or update
DELIMITER //

CREATE TRIGGER trg_uppercase_actor_name
BEFORE INSERT ON actors
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END;
//

CREATE TRIGGER trg_uppercase_actor_name_update
BEFORE UPDATE ON actors
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END;
//

DELIMITER ;
