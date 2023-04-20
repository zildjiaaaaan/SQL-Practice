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

-- Look into withdrawal ATM transactions on July 28, 2021 at Leggett Street:
SELECT *
FROM atm_transactions
WHERE year = '2021'
    AND month = '7'
    AND day = '28'
    AND atm_location = 'Leggett Street'
    AND transaction_type = 'withdraw'
;

-- Look into phone calls made in July 28, 2021 that has a duration of
-- less than a minute
SELECT *
FROM phone_calls
WHERE year = '2021'
    AND month = '7'
    AND day = '28'
    AND duration < '60'
;

-- Look into further details of account numbers associated with the
-- withdrawal ATM transactions on July 28, 2021 at Leggett Street:
SELECT people.*, bank_accounts.account_number, creation_year
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
WHERE bank_accounts.account_number IN (
    SELECT atm_transactions.account_number
    FROM atm_transactions
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND atm_location = 'Leggett Street'
        AND transaction_type = 'withdraw'
);

-- Narrow it down by only the license plates who made an exit on
-- July 28, 2021 sometime at 10am
SELECT people.*, bank_accounts.account_number, creation_year
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
WHERE people.license_plate IN (
    SELECT bakery_security_logs.license_plate
    FROM bakery_security_logs
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND hour = '10'
        AND (minute >= '15' AND minute <= '25')
        AND activity = 'exit'
) AND bank_accounts.account_number IN (
    SELECT atm_transactions.account_number
    FROM atm_transactions
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND atm_location = 'Leggett Street'
        AND transaction_type = 'withdraw'
);

/*
+--------+-------+----------------+-----------------+---------------+----------------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate | account_number | creation_year |
+--------+-------+----------------+-----------------+---------------+----------------+---------------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       | 2010          |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       | 2012          |
| 396669 | Iman  | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       | 2014          |
| 467400 | Luca  | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       | 2014          |
+--------+-------+----------------+-----------------+---------------+----------------+---------------+
*/

-- With these details, I can further narrow it down by the only the phone numbers who
-- appeared in phone calls made in July 28, 2021 that has a duration of
-- less than a minute

SELECT people.*, bank_accounts.account_number, creation_year
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
WHERE people.license_plate IN (
    SELECT bakery_security_logs.license_plate
    FROM bakery_security_logs
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND hour = '10'
        AND (minute >= '15' AND minute <= '25')
        AND activity = 'exit'
) AND bank_accounts.account_number IN (
    SELECT atm_transactions.account_number
    FROM atm_transactions
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND atm_location = 'Leggett Street'
        AND transaction_type = 'withdraw'
) AND people.phone_number IN (
    SELECT caller
    FROM phone_calls
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND duration < '60'
);

/*
+--------+-------+----------------+-----------------+---------------+----------------+---------------+
|   id   | name  |  phone_number  | passport_number | license_plate | account_number | creation_year |
+--------+-------+----------------+-----------------+---------------+----------------+---------------+
| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       | 2010          |
| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       | 2012          |
+--------+-------+----------------+-----------------+---------------+----------------+---------------+
*/

-- Look into the earlist flight of July 29, 2021

SELECT *
FROM flights
WHERE year = '2021'
    AND month = '7'
    AND day = '29'
ORDER BY hour, minute
LIMIT 1
;

-- Look into passengers of the earlist flight who has passport number
-- confirmed from the records of ATM transaction, bakery security logs, and
-- less-than-a-minute phone calls

SELECT people.*, bank_accounts.account_number, creation_year
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
WHERE people.license_plate IN (
    SELECT bakery_security_logs.license_plate
    FROM bakery_security_logs
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND hour = '10'
        AND (minute >= '15' AND minute <= '25')
        AND activity = 'exit'
) AND bank_accounts.account_number IN (
    SELECT atm_transactions.account_number
    FROM atm_transactions
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND atm_location = 'Leggett Street'
        AND transaction_type = 'withdraw'
) AND people.phone_number IN (
    SELECT caller
    FROM phone_calls
    WHERE year = '2021'
        AND month = '7'
        AND day = '28'
        AND duration < '60'
) AND people.passport_number IN (
    SELECT passengers.passport_number
    FROM passengers
    WHERE passengers.flight_id = (
        SELECT flights.id
        FROM flights
        WHERE year = '2021'
            AND month = '7'
            AND day = '29'
        ORDER BY hour, minute
        LIMIT 1
    )
);