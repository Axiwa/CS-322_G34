create index age_ix on party_involve(age) 
create index case_coltype_ix on case(case_id, col_type)
create index case_loc_ix on case(case_id, loc_num)
create index county_city_ix on location(loc_num, county_city)
create index ix_par on party_involve(ve_num) 
create index ix_ve on vehicle(ve_type) 
create index loc_in_case on case(loc_num)
create index ve_case_ix on party_involve(case_id, ve_num)
create index ve_party_ix on party_involve(party_id, ve_num)
create index ix_age on associate_victim(vic_age);
create index vic_injury_ix on associate_victim(vic_id, deg_injury)
create index vic_partyid on associate_victim(vic_id, party_id)
create index vic_age_id on associate_victim(vic_id, vic_age)
create index party_case_id on party_involve(party_id, case_id)
create index case_in_party on party_involve(case_id)


alter index case_in_party invisible
alter index age_ix invisible
alter index case_coltype_ix invisible
alter index case_loc_ix invisible
alter index county_city_ix invisible
alter index ix_par invisible
alter index ix_ve invisible
alter index loc_in_case invisible
alter index ve_case_ix invisible
alter index ve_party_ix invisible
alter index vic_age_ix invisible
alter index vic_injury_ix invisible --no use
alter index vic_partyid invisible


--1


SELECT 
(CASE WHEN AGE<=18 THEN 'underage'
WHEN AGE BETWEEN 19 and 21 then 'young I'
when AGE BETWEEN 22 AND 24 THEN 'young II'
when AGE BETWEEN 24 AND 60 THEN 'adult'
when AGE BETWEEN 61 AND 64 THEN 'elder I'
else 'elder II' END) as AGE_RANGE, 
CONCAT(100*ROUND(SUM(AT_FAULT)/COUNT (AT_FAULT), 3), '%') as ratio
FROM (SELECT AGE, AT_FAULT FROM PARTY_INVOLVE WHERE PARTY_TYPE like '%driver%' and AGE IS NOT NULL and AT_FAULT IS NOT NULL)
group by (CASE WHEN AGE<=18 THEN 'underage'
WHEN AGE BETWEEN 19 and 21 then 'young I'
when AGE BETWEEN 22 AND 24 THEN 'young II'
when AGE BETWEEN 24 AND 60 THEN 'adult'
when AGE BETWEEN 61 AND 64 THEN 'elder I'
ELSE 'elder II' END)
order by RATIO DESC

--2

alter index ve_case_ix visible

SELECT VE_TYPE, COUNT(*) AS COUNT
FROM
    (SELECT DISTINCT VEHICLE.VE_TYPE, PARTY_INVOLVE.CASE_ID
    FROM PARTY_INVOLVE, VEHICLE, ROAD_EN
    WHERE ROAD_EN.ROAD_CON LIKE '%holes%'
    AND VE_TYPE IS NOT NULL
    AND ROAD_EN.CASE_ID = PARTY_INVOLVE.CASE_ID
    AND VEHICLE.VE_NUM = PARTY_INVOLVE.VE_NUM)
GROUP BY VE_TYPE
ORDER BY COUNT DESC
FETCH FIRST 5 ROWS ONLY

alter index ve_case_ix invisible

--3

alter index ve_party_ix visible

SELECT VE_MAKE, COUNT(ASSOCIATE_VICTIM.VIC_ID) AS COUNT 
FROM VEHICLE, PARTY_INVOLVE, ASSOCIATE_VICTIM
WHERE VEHICLE.VE_NUM = PARTY_INVOLVE.VE_NUM
AND ASSOCIATE_VICTIM.PARTY_ID = PARTY_INVOLVE.PARTY_ID
AND (ASSOCIATE_VICTIM.DEG_INJURY LIKE '%severe injury%' OR ASSOCIATE_VICTIM.DEG_INJURY LIKE '%killed%')
AND VEHICLE.VE_MAKE IS NOT NULL
GROUP BY VE_MAKE
ORDER BY COUNT DESC
FETCH FIRST 10 ROWS ONLY

alter index ve_party_ix invisible

--4

(SELECT vic_seat, ROUND(SUM(1.0/denom),3) AS SAFETY_INDEX
FROM
    (SELECT VIC_SEAT, DEG_INJURY, COUNT(DEG_INJURY) OVER (PARTITION BY VIC_SEAT) AS DENOM
    FROM ASSOCIATE_VICTIM)
WHERE DEG_INJURY LIKE '%no injury%'
GROUP BY VIC_SEAT
ORDER BY SAFETY_INDEX DESC
FETCH FIRST 1 ROWS ONLY)

UNION ALL

(SELECT vic_seat, ROUND(SUM(1.0/denom),3) AS SAFETY_INDEX
FROM
    (SELECT VIC_SEAT, DEG_INJURY, COUNT(DEG_INJURY) OVER (PARTITION BY VIC_SEAT) AS DENOM
    FROM ASSOCIATE_VICTIM)
WHERE DEG_INJURY LIKE '%no injury%'
GROUP BY VIC_SEAT
ORDER BY SAFETY_INDEX
FETCH FIRST 1 ROWS ONLY)


--5
alter index ve_case_ix visible
alter index ve_party_ix visible
alter index case_loc_ix visible

explain plan for 
SELECT COUNT(VE_TYPE) AS NUM_VE_TYPE
FROM
    (SELECT VE_TYPE, COUNT(COUNTY_CITY) AS CITY_NUM
    FROM
        (SELECT DISTINCT VE_TYPE, COUNTY_CITY, COUNT(*) AS CASE_NUM
        FROM VEHICLE, PARTY_INVOLVE, CASE, LOCATION
        WHERE VEHICLE.VE_NUM=PARTY_INVOLVE.VE_NUM
            AND PARTY_INVOLVE.CASE_ID=CASE.CASE_ID
            AND LOCATION.LOC_NUM=CASE.LOC_NUM
            GROUP BY VE_TYPE, COUNTY_CITY)CITY
    WHERE CASE_NUM >=10
    GROUP BY VE_TYPE) COUNT_CITY,
    (SELECT COUNT(DISTINCT COUNTY_CITY) AS TOTAL_CITY FROM LOCATION) TOTAL
WHERE CITY_NUM>= TOTAL_CITY/2



alter index ve_case_ix invisible
alter index ve_party_ix invisible
alter index case_loc_ix invisible

--6
alter index case_in_party visible
alter index loc_in_case visible
alter index county_city_ix_test visible
alter index party_case_id visible

explain plan for
SELECT COUNTY_CITY, POPULATION, CASE_ID, AVG_AGE
FROM
    (SELECT COUNTY_CITY, POPULATION, CASE_ID, AVG_AGE, ROW_NUMBER() OVER(PARTITION BY COUNTY_CITY ORDER BY AVG_AGE ASC) AS ROW_NUMBER
    FROM
        (SELECT COL_CITY.COUNTY_CITY, COL_CITY.POPULATION, CASE.CASE_ID, AVG(VIC_AGE) AS AVG_AGE
        FROM
            (SELECT DISTINCT COUNTY_CITY, POPULATION
                FROM LOCATION 
                order by (case population
                    when 7 then 0
                    when 6 then 1
                    when 5 then 2
                    when 4 then 3 
                    when 3 then 4
                    when 2 then 5
                    when 1 then 6 
                    when 9 then 7
                    when 0 then 8
                    else 9 end)                
                FETCH FIRST 3 ROWS ONLY) COL_CITY,
                LOCATION, CASE, PARTY_INVOLVE, ASSOCIATE_VICTIM 
        WHERE COL_CITY.county_city=LOCATION.county_city
            AND CASE.LOC_NUM=LOCATION.LOC_NUM
            AND PARTY_INVOLVE.CASE_ID=CASE.CASE_ID
            AND ASSOCIATE_VICTIM.PARTY_ID=PARTY_INVOLVE.PARTY_ID
            AND VIC_AGE IS NOT NULL
            GROUP BY COL_CITY.COUNTY_CITY, COL_CITY.POPULATION, CASE.CASE_ID)AGE)RANK_AGE
WHERE ROW_NUMBER<=10
ORDER BY COUNTY_CITY, ROW_NUMBER

select * from table(dbms_xplan.display)

alter index loc_in_case invisible
alter index county_city_ix invisible
alter index party_case_id invisible
--7 

alter index case_coltype_ix visible 
alter index party_case_id visible 


SELECT DISTINCT CASE_ID, MAX(VIC_AGE) OVER(PARTITION BY CASE_ID) AS ELDEST
FROM
    (SELECT PE_CASE.CASE_ID, VIC_AGE, MIN(VIC_AGE) OVER (PARTITION BY PE_CASE.CASE_ID)AS MIN_AGE
    FROM
        (SELECT CASE_ID
        FROM CASE
        WHERE COL_TYPE LIKE '%pedestrian%') PE_CASE, PARTY_INVOLVE, ASSOCIATE_VICTIM
    WHERE PARTY_INVOLVE.CASE_ID=PE_CASE.CASE_ID
        AND ASSOCIATE_VICTIM.PARTY_ID=PARTY_INVOLVE.PARTY_ID)CASE_AGE
WHERE MIN_AGE>100
ORDER BY CASE_ID

alter index case_coltype_ix invisible 
alter index party_case_id invisible 


--8

alter index ve_case_ix visible


WITH 
VE_COL AS
    (
    SELECT VE_NUM, COUNT(case_id) AS N_COLLISION
    FROM PARTY_INVOLVE
    GROUP BY VE_NUM
    )
SELECT VEHICLE.VE_TYPE || ', ' || VEHICLE.VE_MAKE || ', ' || VEHICLE.VE_YEAR AS VE_ID, VE_COL.N_COLLISION AS N_COLLISION
FROM (VEHICLE INNER JOIN VE_COL ON VE_COL.VE_NUM = VEHICLE.VE_NUM)
WHERE N_COLLISION > 9 AND VEHICLE.VE_MAKE IS NOT NULL AND VEHICLE.VE_TYPE IS NOT NULL AND VEHICLE.VE_TYPE != 'pedestrain'
ORDER BY N_COLLISION DESC
FETCH FIRST 20 ROWS ONLY

alter index ve_case_ix invisible

--9

alter index county_city_ix visible
alter index case_loc_ix visible


SELECT COUNTY_CITY, COUNT(CASE_ID) as N_COLLISION FROM
LOCATION, CASE
WHERE LOCATION.LOC_NUM = CASE.LOC_NUM and LOCATION.COUNTY_CITY IS NOT NULL
GROUP BY COUNTY_CITY
ORDER BY N_COLLISION DESC
FETCH FIRST 10 ROWS ONLY

alter index county_city_ix invisible
alter index case_loc_ix invisible

--10

create index col_period_ix on case()

WITH 
COL_PERIOD AS
    (
    SELECT
    CASE
    WHEN CASE.LIGHTING LIKE '%day%' THEN 'DAY'
    WHEN CASE.LIGHTING LIKE '%dark%' THEN 'NIGHT'
    ELSE 
            (CASE
                WHEN EXTRACT(MONTH FROM COL_TIME)>8 OR EXTRACT(MONTH FROM COL_TIME)<4 THEN
                    (CASE
                    WHEN EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))>5 AND EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))<8 THEN 'DAWN'
                    WHEN EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))>17 AND EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))<20 THEN 'DUSK'
                    WHEN EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))>7 AND EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))<18 THEN 'DAY'
                    ELSE 'NIGHT'
                    END)
                WHEN EXTRACT(MONTH FROM COL_TIME)>3 OR EXTRACT(MONTH FROM COL_TIME)<9 THEN
                    (CASE
                    WHEN EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))>3 AND EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))<6 THEN 'DAWN'
                    WHEN EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))>19 AND EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))<22 THEN 'DUSK'
                    WHEN EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))>5 AND EXTRACT(HOUR FROM CAST(COL_TIME AS TIMESTAMP))<20 THEN 'DAY'
                    ELSE 'NIGHT'
                    END)           
            ELSE NULL
            END)
    END AS PERIOD
    FROM CASE
    )
SELECT PERIOD, COUNT(*) AS N_COLLISION
FROM COL_PERIOD
WHERE PERIOD IS NOT NULL
GROUP BY PERIOD
ORDER BY N_COLLISION DESC


--============================================================================================================
