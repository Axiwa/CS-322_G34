--1
--
SELECT 
(CASE WHEN AGE<=18 THEN 'underage'
WHEN AGE BETWEEN 19 and 21 then 'young I'
when AGE BETWEEN 22 AND 24 THEN 'young II'
when AGE BETWEEN 24 AND 60 THEN 'adult'
when AGE BETWEEN 61 AND 64 THEN 'elder I'
ELSE 'elder II' END) as AGE_RANGE, 
SUM(AT_FAULT)/COUNT (*) as ratio
FROM (SELECT AGE, AT_FAULT FROM PARTY_INVOLVE WHERE PARTY_TYPE = 'driver')
group by (CASE WHEN AGE<=18 THEN 'underage'
WHEN AGE BETWEEN 19 and 21 then 'young I'
when AGE BETWEEN 22 AND 24 THEN 'young II'
when AGE BETWEEN 24 AND 60 THEN 'adult'
when AGE BETWEEN 61 AND 64 THEN 'elder I'
ELSE 'elder II' END)

--2
--
SELECT VE_TYPE, COUNT(*) AS COUNT
FROM
    (SELECT VEHICLE.VE_TYPE, PARTY_INVOLVE.CASE_ID
    FROM PARTY_INVOLVE, VEHICLE, ROAD_EN
    WHERE ROAD_EN.ROAD_CON LIKE '%holes%'
    AND ROAD_EN.CASE_ID = PARTY_INVOLVE.CASE_ID
    AND VEHICLE.VE_NUM = PARTY_INVOLVE.VE_NUM)
GROUP BY VE_TYPE
ORDER BY COUNT DESC
FETCH FIRST 5 ROWS ONLY

--3

SELECT VE_MAKE, COUNT(VIC_ID) AS COUNT 
FROM VEHICLE, PARTY_INVOLVE, ASSOCIATE_VICTIM
WHERE VEHICLE.VE_NUM = PARTY_INVOLVE.VE_NUM
AND ASSOCIATE_VICTIM.PARTY_ID = PARTY_INVOLVE.PARTY_ID
AND (ASSOCIATE_VICTIM.DEG_INJURY LIKE '%severe injury%' OR ASSOCIATE_VICTIM.DEG_INJURY LIKE '%killed%')
GROUP BY VE_MAKE
ORDER BY COUNT DESC
FETCH FIRST 10 ROWS ONLY

--4

(SELECT vic_seat, SUM(1.0/denom) AS SAFETY_INDEX
FROM
    (SELECT VIC_ID, VIC_SEAT, DEG_INJURY, COUNT(*) OVER (PARTITION BY VIC_SEAT) AS DENOM
    FROM ASSOCIATE_VICTIM)
WHERE DEG_INJURY LIKE '%no injury%'
GROUP BY VIC_SEAT
ORDER BY SAFETY_INDEX DESC
FETCH FIRST 1 ROWS ONLY)

UNION ALL

(SELECT vic_seat, SUM(1.0/denom) AS SAFETY_INDEX
FROM
    (SELECT VIC_ID, VIC_SEAT, DEG_INJURY, COUNT(*) OVER (PARTITION BY VIC_SEAT) AS DENOM
    FROM ASSOCIATE_VICTIM)
WHERE DEG_INJURY LIKE '%no injury%'
GROUP BY VIC_SEAT
ORDER BY SAFETY_INDEX
FETCH FIRST 1 ROWS ONLY)

