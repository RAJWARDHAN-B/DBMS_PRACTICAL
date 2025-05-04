-- ======================
-- 1. CREATE TABLES
-- ======================

-- PAINTER Table
CREATE TABLE PAINTER (
    Painter_Cd INT PRIMARY KEY,
    Painter_Name VARCHAR(100),
    Address VARCHAR(200),
    Contact_No VARCHAR(20)
);

-- GALLERY Table
CREATE TABLE GALLERY (
    Gallery_No INT PRIMARY KEY,
    Gallery_Name VARCHAR(100),
    Gallery_address VARCHAR(200)
);

-- PAINTING Table
CREATE TABLE PAINTING (
    Painting_id INT PRIMARY KEY,
    Painting_De VARCHAR(200),
    PaintingTheme VARCHAR(100),
    Painter_Cd INT,
    FOREIGN KEY (Painter_Cd) REFERENCES PAINTER(Painter_Cd)
);

-- DISPLAY Table (Associative entity)
CREATE TABLE DISPLAY (
    Painting_id INT,
    Gallery_No INT,
    PRIMARY KEY (Painting_id, Gallery_No),
    FOREIGN KEY (Painting_id) REFERENCES PAINTING(Painting_id),
    FOREIGN KEY (Gallery_No) REFERENCES GALLERY(Gallery_No)
);

-- ======================
-- 2. INSERT SAMPLE DATA
-- ======================

-- Insert into PAINTER
INSERT INTO PAINTER VALUES
(1, 'Leonardo da Vinci', 'Vinci, Italy', '1234567890'),
(2, 'Vincent van Gogh', 'Zundert, Netherlands', '2345678901'),
(3, 'Pablo Picasso', 'Malaga, Spain', '3456789012');

-- Insert into GALLERY
INSERT INTO GALLERY VALUES
(101, 'Louvre Museum', 'Paris, France'),
(102, 'Modern Art Gallery', 'New York, USA'),
(103, 'Van Gogh Museum', 'Amsterdam, Netherlands');

-- Insert into PAINTING
INSERT INTO PAINTING VALUES
(1001, 'Mona Lisa', 'Portrait', 1),
(1002, 'Starry Night', 'Landscape', 2),
(1003, 'Guernica', 'War', 3),
(1004, 'Sunflowers', 'Still Life', 2);

-- Insert into DISPLAY
INSERT INTO DISPLAY VALUES
(1001, 101),
(1002, 103),
(1003, 102),
(1004, 103),
(1002, 102); -- Same painting displayed in multiple galleries

-- ======================
-- 3. DQL (SELECT) QUERIES
-- ======================

-- 1. Retrieve all painters and their paintings
SELECT p.Painter_Name, pa.Painting_id, pa.Painting_De
FROM PAINTER p
JOIN PAINTING pa ON p.Painter_Cd = pa.Painter_Cd;

-- 2. List all paintings displayed in 'Modern Art Gallery'
SELECT pa.Painting_id, pa.Painting_De, g.Gallery_Name
FROM PAINTING pa
JOIN DISPLAY d ON pa.Painting_id = d.Painting_id
JOIN GALLERY g ON d.Gallery_No = g.Gallery_No
WHERE g.Gallery_Name = 'Modern Art Gallery';

-- 3. Show all galleries and the number of paintings they display
SELECT g.Gallery_Name, COUNT(d.Painting_id) AS NumberOfPaintings
FROM GALLERY g
JOIN DISPLAY d ON g.Gallery_No = d.Gallery_No
GROUP BY g.Gallery_Name;

-- 4. Get painters who have painted in the theme 'Landscape'
SELECT DISTINCT p.Painter_Name
FROM PAINTER p
JOIN PAINTING pa ON p.Painter_Cd = pa.Painter_Cd
WHERE pa.PaintingTheme = 'Landscape';

-- 5. Find painting details and the gallery they are displayed in
SELECT pa.Painting_id, pa.Painting_De, g.Gallery_Name, g.Gallery_address
FROM PAINTING pa
JOIN DISPLAY d ON pa.Painting_id = d.Painting_id
JOIN GALLERY g ON d.Gallery_No = g.Gallery_No;
