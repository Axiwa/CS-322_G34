--1

SELECT EXTRACT (YEAR FROM COL_DATE) AS YEAR , COUNT(*) AS N_COLLISIONS
FROM CASE
GROUP BY EXTRACT (YEAR FROM COL_DATE)
ORDER BY YEAR ASC

--2
--
SELECT VE_MAKE, COUNT(*) AS N_COLLISION
FROM (VEHICLE INNER JOIN PARTY_INVOLVE ON VEHICLE.VE_NUM = PARTY_INVOLVE.VE_NUM)
GROUP BY VE_MAKE
ORDER BY N_COLLISION DESC
FETCH FIRST 1 ROWS ONLY
----
----
------3
----
SELECT ROUND(NOM/(SELECT COUNT(*) FROM CASE),2) as FRACTION
FROM
  (SELECT COUNT(*) AS NOM
  FROM CASE
  WHERE CASE.LIGHTING LIKE '%dark%')
----    
----
------4
----
SELECT COUNT(*)
FROM WEATHER_EN
WHERE WEATHER LIKE '%snowing%'
----
----
------5
----
SELECT TO_CHAR(COL_DATE, 'D') AS WEEK_DAY, COUNT(*) AS N_COLLISONS
FROM CASE
GROUP BY TO_CHAR(COL_DATE, 'D')
ORDER BY N_COLLISONS DESC
FETCH FIRST 1 ROWS ONLY
----
----
------6
----
SELECT WEATHER, COUNT(*) AS N_COLLISION
FROM WEATHER_EN
GROUP BY WEATHER
ORDER BY N_COLLISION
----
----
------7
----
SELECT COUNT(*) AS N_PARTIES 
FROM PARTY_INVOLVE P, ROAD_EN R
WHERE P.CASE_ID = R.CASE_ID AND P.AT_FAULT = 1 AND P.FIN_RESP = 'Y' AND R.ROAD_CON LIKE '%loose material%'
--
--
---- 8 
--
SELECT VIC_SEAT AS MOST_COMMON_SEAT_POSITION
FROM
    (SELECT COUNT(vic_seat) AS count, vic_seat
     FROM associate_victim v2
     GROUP BY vic_seat
     ORDER BY count DESC)
FETCH FIRST 1 ROWS ONLY;
--
--
---- 9
----
SELECT ROUND(A.FRACTION,3) AS fraction
FROM(SELECT DISTINCT
        (SELECT  COUNT(vic_id) AS count
            FROM  
               (SELECT h1.vic_id as vic_id
                    FROM SAFETY_V H1
                    WHERE H1.SAFETY_EQUIP like '%C%') v_belt)/
        ((SELECT COUNT(party_id) FROM party_involve) 
        +(SELECT COUNT(vic_id) FROM associate_victim)) as fraction      
FROM party_involve) a
--
--
----10
--
SELECT DISTINCT 
EXTRACT(hour from cast(col_time as timestamp)) as hour, CONCAT( ROUND((COUNT(*)/(SELECT COUNT(*) FROM CASE)*100.0),2),'%') as FRACTION
FROM CASE
   GROUP BY EXTRACT(hour from cast(col_time as timestamp))
   ORDER BY hour ASC

