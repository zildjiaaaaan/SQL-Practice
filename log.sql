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