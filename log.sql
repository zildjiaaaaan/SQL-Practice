-- Look into crime_scene_report happened in
-- Jan. 15, 2018 at SQL City
SELECT *
FROM crime_scene_report
WHERE date = '20180115'
    AND city = 'SQL City'
;