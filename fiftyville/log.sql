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

-- Look into bakery security logs on July 28, 2021 sometime at
-- 10am with exiting activities:
SELECT *
FROM bakery_security_logs
WHERE year = '2021'
    AND month = '7'
    AND day = '28'
    AND hour = '10'
    AND (minute >= '15' AND minute <= '25')
    AND activity = 'exit'
;