-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Michael Runnels and Emily Boyer
-- Description: SQL for job huntington database

DROP DATABASE job_hunters;

CREATE DATABASE job_hunters;

\c job_hunters

-- TODO: table create statements
CREATE TABLE Positions (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(250) NOT NULL,
    skills VARCHAR(100),
    classification VARCHAR(10) NOT NULL,
    post_date DATE NOT NULL,
    expiration_date DATE NOT NULL
);

CREATE TABLE Candidates (
    email VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Applications (
    id SERIAL PRIMARY KEY,
    position_id INT NOT NULL,
    candidate_email VARCHAR(100) NOT NULL,
    application_date DATE NOT NULL,
    application_status CHAR(3) NOT NULL,
    FOREIGN KEY (position_id) REFERENCES Positions (id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_email) REFERENCES Candidates (email) ON DELETE CASCADE
);

CREATE TABLE Statuses (
    code CHAR(3) PRIMARY KEY,
    description VARCHAR(11)
);

-- TODO: table insert statements 
INSERT INTO Positions (
    title,
    description,
    skills,
    classification,
    post_date,
    expiration_date
    )
VALUES(
    'Software Engineer',
    'A software engineer for a mobile app development project',
    'android, java, postgres',
    'entry',
    '2024-02-25',
    '2024-03-25'),
    ('Database Administrator',
    'A database administrator with experience with postgres',
    'sql, postgres, erd, uml',
    'senior',
    '2024-02-20',
    '2024-04-20'),
    ('Software QA',
    'A software quality assurance test engineer',
    'python, java, unit test, selenium',
    'medium',
    '2024-01-15',
    '2024-02-20'),
    ('Project Manager',
    'A project manager with experience in agile development',
    'agile, scrum',
    'senior',
    '2024-02-26',
    '2024-06-26'),
    ('Software Intern',
    'An intern with desire',
    'android, java, postgres',
    'entry',
    '2024-02-25',
    '2024-03-25');

INSERT INTO Candidates (
    email,
    name,
    address,
    phone
    )
VALUES(
    'amelinha@gmail.com',
    'Amelia Claudia Garcia Collares',
    NULL,
    '(720) 484-1234'),
    ('cazuza@gmail.com',
    'Agenor de Miranda Aruajo Neto',
    NULL,
    '(484) 234-2312'),
    ('yahoo@yahoo.com',
    'Robertinho do Recife',
    'Refice, PE',
    '(720) 123-9876');


INSERT INTO Applications (
    position_id,
    candidate_email,
    application_date,
    application_status
    )
VALUES(
    '1',
    'amelinha@gmail.com',
    '2024-02-26',
    'RJT'),
    ('5',
    'amelinha@gmail.com',
    '2024-02-26',
    'DRP'),
    ('2',
    'cazuza@gmail.com',
    '2024-03-17',
    'SLT'),
    ('3',
    'cazuza@gmail.com',
    '2024-02-01',
    'HRD');
    
INSERT INTO Statuses (
    code,
    description
    )
VALUES
    ('APL',
    'candidate'),
    ('RJT',
    'rejected'),
    ('SLT',
    'selected'),
    ('DRP',
    'discarded'),
    ('HRD',
    'contractor');

-- TODO: SQL queries

-- a) all position titles in alphabetical order

SELECT title
FROM Positions
ORDER BY title;

-- b) number of candidates (labeled as total_candidates) in the database

SELECT COUNT(DISTINCT email) AS total_candidates
FROM Candidates;

-- c) number of positions (labeled as number_positions) by classification

SELECT classification, COUNT(id) AS number_positions
FROM Positions
GROUP BY classification;

-- d) a list of all applications with the position ids, candidate names, and the status (description) of their applications, ordered by position id and then candidate name

SELECT a.position_id, c.name, s.description
FROM Applications a
JOIN Candidates c ON a.candidate_email = c.email
JOIN Statuses s ON a.application_status = s.code
ORDER BY a.position_id, c.name;

-- e) similar to d, but showing the position title too

SELECT a.position_id, p.title, c.name, s.description
FROM Applications a
JOIN Candidates c ON a.candidate_email = c.email
JOIN Statuses s ON a.application_status = s.code
JOIN Positions p ON a.position_id = p.id
ORDER BY a.position_id, c.name;

-- f) number of positions per classification, order by classification and having the number of positions column referred to as "total"

SELECT classification, COUNT(id) AS total
FROM Positions
GROUP BY classification
ORDER BY classification;

-- g) positions (id and title) that are still open (ie, candidates can still apply today), order by their id. 

SELECT id, title
FROM Positions
WHERE expiration_date > CURRENT_DATE
ORDER BY id;

-- h) a (distinct) alphabetic list of the candidates that are applying for positions

SELECT DISTINCT c.name
FROM Candidates c
JOIN Applications a ON c.email = a.candidate_email
ORDER BY c.name;

-- i) show a (distinct) alphabetic list of the candidates that are NOT applying for positions

SELECT DISTINCT c.name
FROM Candidates c
LEFT JOIN Applications a ON c.email = a.candidate_email
WHERE a.id IS NULL
ORDER BY c.name;

-- j) show a list of all positions that require "java" as a skill

SELECT title
FROM Positions
WHERE skillS LIKE '%java%';

-- *** BONUS ***
-- k) the name of the candidate that applied for the most positions

SELECT c.name
FROM Candidates c
JOIN Applications a ON c.email = a.candidate_email
GROUP BY c.name
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM Applications
    GROUP BY candidate_email
    ORDER BY COUNT(*) DESC
    LIMIT 1
);