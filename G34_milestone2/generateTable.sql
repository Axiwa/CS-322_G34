-- Must be Ordered!

-- To change the date format to YYYY-MM-DD HH24:MI:SS
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD HH24:MI:SS'

CREATE TABLE Other_fac_en(
other_fac_num INTEGER,
other_fac VARCHAR2(3),
PRIMARY KEY (other_fac_num)
);

CREATE TABLE Safety_equip_en(
safety_equip_num INTEGER,
safety_equip VARCHAR2(3),
PRIMARY KEY (safety_equip_num)
);

CREATE TABLE Vehicle(
ve_num INTEGER,
ve_type VARCHAR2(50),
ve_make VARCHAR2(20),
ve_year INTEGER,
PRIMARY KEY (ve_num)
);

CREATE TABLE PCF(
pcf_num INTEGER,
pcf_violation_code INTEGER,
pcf_violation_category VARCHAR2(50),
subsection VARCHAR2(3),
pcf_type VARCHAR2(50),
PRIMARY KEY (pcf_num)
);

CREATE TABLE Location(
loc_num INTEGER,
population INTEGER,
county_city INTEGER,
loc_type VARCHAR2(20),
ramp_int VARCHAR2(10), 
PRIMARY KEY (loc_num)
);


CREATE TABLE Condition(
con_num INTEGER,
lighting VARCHAR2(50),
road_surf VARCHAR2(10),
PRIMARY KEY (con_num)
);

CREATE TABLE Road_en(
road_num INTEGER,
road_con VARCHAR2(20),
PRIMARY KEY (road_num)
);

CREATE TABLE Weather_en(
wea_num INTEGER,
weather_con VARCHAR2(20),
PRIMARY KEY (wea_num)
);

CREATE TABLE Case(
case_id INTEGER,
loc_num INTEGER NOT NULL,
con_num INTEGER NOT NULL,
pcf_num INTEGER NOT NULL,
col_date DATE,
col_severity VARCHAR2(30),
col_time DATE,
hit_run VARCHAR2(30),
jurisdiction INTEGER,
officer_id VARCHAR2(10),
process_date DATE,
tow_away INTEGER,
col_type VARCHAR2(30),
PRIMARY KEY (case_id),
FOREIGN KEY (loc_num) REFERENCES Location(loc_num),
FOREIGN KEY(con_num) REFERENCES Condition(con_num),
FOREIGN KEY(pcf_num) REFERENCES PCF(pcf_num)
);


CREATE TABLE Party_involve(
party_id INTEGER,
case_id INTEGER NOT NULL,
at_fault INTEGER,  
phone VARCHAR2(3),     
fin_resp VARCHAR2(3),  
haz_mat VARCHAR2(3),   
move_pre VARCHAR2(3), 
age INTEGER,
drug_phy VARCHAR2(3),
sobriety VARCHAR2(3),
party_type VARCHAR2(15),
party_num INTEGER,
sex VARCHAR2(6),
PRIMARY KEY (party_id),
FOREIGN KEY (case_id) REFERENCES Case(case_id)
);

CREATE TABLE Associate_victim(
vic_id INTEGER,
party_id INTEGER NOT NULL,
vic_age INTEGER,
ejected INTEGER, 
vic_role INTEGER,
deg_injury VARCHAR2(50),
vic_seat INTEGER,
vic_sex VARCHAR2(6),
PRIMARY KEY (vic_id),
FOREIGN KEY (party_id) REFERENCES Party_involve(party_id)
);

CREATE TABLE Have (
other_fac_num INTEGER,
party_id INTEGER,
PRIMARY KEY (other_fac_num, party_id),
FOREIGN KEY (party_id) REFERENCES Party_involve(party_id),
FOREIGN KEY (other_fac_num) REFERENCES Other_fac_en(other_fac_num)
);

CREATE TABLE Have_ps(
party_id INTEGER,
safety_equip_num INTEGER,
PRIMARY KEY (party_id, safety_equip_num),
FOREIGN KEY (party_id) REFERENCES Party_involve(party_id),
FOREIGN KEY (safety_equip_num) REFERENCES Safety_equip_en(safety_equip_num)
);

CREATE TABLE Have_vs(
vic_id INTEGER,
safety_equip_num INTEGER,
PRIMARY KEY (vic_id, safety_equip_num),
FOREIGN KEY (vic_id) REFERENCES Associate_victim(vic_id),
FOREIGN KEY (safety_equip_num) REFERENCES Safety_equip_en(safety_equip_num)
);


CREATE TABLE Take(
ve_num INTEGER,
party_id INTEGER,
school_bus_rel VARCHAR2(5),
PRIMARY KEY (ve_num, party_id), 
FOREIGN KEY (party_id) REFERENCES Party_involve(party_id),
FOREIGN KEY (ve_num) REFERENCES Vehicle(ve_num)
);

CREATE TABLE Under_r(
case_id INTEGER,
road_num INTEGER,
PRIMARY KEY (road_num, case_id),
FOREIGN KEY (road_num) REFERENCES Road_en(road_num),
FOREIGN KEY (case_id) REFERENCES Case(case_id)
);


CREATE TABLE Under_w(
case_id INTEGER, 
wea_num INTEGER,
PRIMARY KEY (wea_num, case_id),
FOREIGN KEY (wea_num) REFERENCES Weather_en(wea_num),
FOREIGN KEY (case_id) REFERENCES Case(case_id)
);
--
--
--drop table Under_w;
--drop table Under_r;
--drop table Take;
--drop table Have_vs;
--drop table Have_ps;
--drop table Have ;
--drop table Associate_victim;
--drop table Party_involve;
--drop table case;
--drop table Weather_en;
--drop table Road_en;
--drop table Condition;
--drop table Location;
--drop table vehicle;
--drop table PCF;
--drop table Safety_equip_en;
--drop table Other_fac_en;
--
