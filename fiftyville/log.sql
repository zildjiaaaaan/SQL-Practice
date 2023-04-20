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