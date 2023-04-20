-- Look into crime_scene_report happened in
-- Jan. 15, 2018 at SQL City
SELECT *
FROM crime_scene_report
WHERE date = '20180115'
    AND city = 'SQL City'
;

-- Look into first witness who lives at the
-- lives at the last house on "Northwestern Dr"
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1
;

-- Look into second witness named Annabel who
-- lives somewhere at the Franklin Ave
SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave'
    AND name LIKE '%Annabel%'
;

-- Look into witnesses' transcripts
SELECT name, transcript
FROM interview
JOIN person ON interview.person_id = person.id
WHERE (name LIKE '%Annabel%'
    AND address_street_name = 'Franklin Ave')
    OR interview.person_id = (
        SELECT id
        FROM person
        WHERE address_street_name = 'Northwestern Dr'
        ORDER BY address_number DESC
        LIMIT 1
    )
;

-- Look into Get Fit Now Gym gold members
-- with "48Z" in id and who check in Jan. 9, 2018
SELECT id, name, membership_status, check_in_date, check_in_time, check_out_time
FROM get_fit_now_member
JOIN get_fit_now_check_in
    ON id = membership_id
WHERE id LIKE '%48Z%'
    AND membership_status = 'gold'
    AND check_in_date = '20180109'
;

-- Look into further details of the suspected
-- members of the gym
SELECT person.*
FROM person
JOIN get_fit_now_member
    ON person.id = get_fit_now_member.person_id
JOIN get_fit_now_check_in
    ON get_fit_now_member.id = get_fit_now_check_in.membership_id
WHERE get_fit_now_member.id LIKE '%48Z%'
    AND membership_status = 'gold'
    AND check_in_date = '20180109'
;

-- Find the drivers license of the lead persons who
-- has 'H42W' in their plate number
SELECT drivers_license.*
FROM drivers_license
WHERE plate_number LIKE '%H42W%'
    AND id IN (
        SELECT person.license_id
        FROM person
        JOIN get_fit_now_member
            ON person.id = get_fit_now_member.person_id
        JOIN get_fit_now_check_in
            ON get_fit_now_member.id = get_fit_now_check_in.membership_id
        WHERE get_fit_now_member.id LIKE '%48Z%'
            AND membership_status = 'gold'
            AND check_in_date = '20180109'
    ) 
;

-- We got 'Jeremy Bowers' as primary lead
-- Look into lead person's transcript for clues
SELECT name, transcript
FROM interview
JOIN person ON interview.person_id = person.id
WHERE name = 'Jeremy Bowers'
;

-- Find the person's details mentioned in
-- lead person's transcript (Part 1)
SELECT person.*
FROM drivers_license
JOIN person
    ON drivers_license.id = person.license_id
WHERE gender = 'female'
    AND (height >= '65' AND height <= '67')
    AND hair_color = 'red'
    AND car_make = 'Tesla'
    AND car_model = 'Model S'
;