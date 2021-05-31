CREATE TABLE PCF(
pcf_num INTEGER,
pcf_violation_code INTEGER,
pcf_violation_category VARCHAR2(50),
subsection VARCHAR2(3),
pcf_type VARCHAR2(50),
PRIMARY KEY (pcf_num)
);

CREATE TABLE Vehicle(
ve_num INTEGER,
ve_type VARCHAR2(50),
ve_make VARCHAR2(30),
ve_year INTEGER,
school_bus_rel VARCHAR2(5),
PRIMARY KEY (ve_num)
);

CREATE TABLE Location(
loc_num INTEGER,
population INTEGER,
county_city INTEGER,
loc_type VARCHAR2(20),
ramp_int VARCHAR2(10), 
PRIMARY KEY (loc_num)
);

CREATE TABLE Case(
case_id VARCHAR2(30),
loc_num INTEGER NOT NULL,
pcf_num INTEGER NOT NULL,
col_severity VARCHAR2(30),
col_time DATE,
col_date DATE,
hit_run VARCHAR2(30),
jurisdiction INTEGER,
officer_id VARCHAR2(10),
process_date DATE,
tow_away INTEGER,
col_type VARCHAR2(30),
lighting VARCHAR2(50),
road_surf VARCHAR2(10),
PRIMARY KEY (case_id),
FOREIGN KEY (loc_num) REFERENCES Location(loc_num),
FOREIGN KEY(pcf_num) REFERENCES PCF(pcf_num)
);

CREATE TABLE Party_involve(
party_id INTEGER,
case_id VARCHAR2(30) NOT NULL,
at_fault INTEGER,  
phone VARCHAR2(3),     
fin_resp VARCHAR2(3),  
haz_mat VARCHAR2(3),   
move_pre VARCHAR2(30), 
age INTEGER,
drug_phy VARCHAR2(3),
sobriety VARCHAR2(3),
party_type VARCHAR2(15),
party_num INTEGER,
sex VARCHAR2(6),
ve_num INTEGER,
PRIMARY KEY (party_id),
FOREIGN KEY (case_id) REFERENCES Case(case_id)
ON DELETE CASCADE,
FOREIGN KEY (ve_num) REFERENCES Vehicle(ve_num)
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
ON DELETE CASCADE
);

CREATE TABLE Other_fac_en(
party_id INTEGER,
other_fac VARCHAR2(3),
PRIMARY KEY (party_id, other_fac),
FOREIGN KEY (party_id) REFERENCES Party_involve(party_id) 
ON DELETE CASCADE
);

CREATE TABLE road_en(
case_id VARCHAR2(30),
road_con VARCHAR2(20),
PRIMARY KEY (case_id, road_con),
FOREIGN KEY (case_id) REFERENCES Case(case_id)
ON DELETE CASCADE
);

CREATE TABLE Weather_en(
case_id VARCHAR2(30),
weather VARCHAR2(20),
PRIMARY KEY (case_id, weather),
FOREIGN KEY (case_id) REFERENCES Case(case_id)
ON DELETE CASCADE
);

CREATE TABLE safety_p(
party_id INTEGER,
safety_equip VARCHAR2(3),
PRIMARY KEY (party_id, safety_equip),
FOREIGN KEY (party_id) REFERENCES Party_involve(party_id)
ON DELETE CASCADE
);

CREATE TABLE safety_v(
vic_id INTEGER,
safety_equip VARCHAR2(3),
PRIMARY KEY (vic_id, safety_equip),
FOREIGN KEY (vic_id) REFERENCES Associate_victim(vic_id)
ON DELETE CASCADE
);

-- drop table safety_v;
-- drop table safety_p;
-- drop table weather_en;
-- drop table road_en;
-- drop table other_fac_en;
-- drop table associate_victim;
-- drop table party_involve;
-- drop table case;
-- drop table location;
-- drop table vehicle;
-- drop table pcf
