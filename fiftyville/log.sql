-- Find crime scene description
SELECT *
FROM crime_scene_reports
WHERE year = '2021'
    AND month = '7'
    AND day = '28'
    AND street = 'Humphrey Street'
;

-- Find interview reports based on the crime scene descriptions
SELECT *
FROM interviews
WHERE year = '2021'
    AND month = '7'
    AND day = '28'
    AND transcript LIKE '%bakery%'
;