Hi Team, Please find below my feedback on your submission corresponding to the Milestone 2 of the project. 

I trust that you will find the suggestions as useful and continue successfully with tasks that go towards the final project submission (Milestone 3). 

## =============== General Comment =============== 

- While you explicitly included the updated ER and DDL in your report, for future deliverables I would also encourage you to add a brief description of the difference between the previous and the current deliverable preferrably in a separate section of your report. Please do this for your milestone-3 deliverable by including the diff between the second and third deliverable. 



## =============== Feedback on Assumptions =============== 
- Good job on assumptions, they are clear and reasonable. 
- We found that there are duplicates of case_id in the collision2018.csv (6 of them), and since their total number is small, we recognize them as incorrectly registered data and removed them. 
  * I hope you have read the following Moodle posts, especially the part: "Finally for the Milestone 2 and data loading, make sure to check that in the data type conversion you have not lost the uniqueness of the key." https://moodle.epfl.ch/mod/forum/discuss.php?d=59121 https://moodle.epfl.ch/mod/forum/discuss.php?d=59140 
  * I just want to make sure that the duplicates are not because of the datatype issue (you are modeling case_id as integer), and are genuine duplicates. Please reanalyze this part. 
- For entities which may appear multiple times (weather, road_condition...), two identical value may appear in both con_1 and con_2 columns, when we encounter this situation, we only record once in the under_condition-like tables (relationship between party/case/victim and various condition). 
  * While you need to ensure that the same value is not stored in the two fields as you described in your assumption, I don't understand why do you have to control this manually. For example, you can create a new entity (and the corresponding table) for "road conditions", with road condition as an attribute and the case_id acts as a foreign key referred from the collision table. Note that in this case, both the case_id and the road_condition serve as the PK. This will ensure the problem that you described above doesn't happen while also respecting all the normalization principles. Similar approach can be used for other attributes stated above. Let me know if something is unclear! 

## =============== Feedback on ER Model =============== 

- Thank you for incorporating the suggestions from Milestone 1. It looks good now, no further changes needed IMHO. 
  
## =============== Feedback on DDL and Relational Schema ===============

 - I noticed multiple oversights in the translation from your ER to the DDL. 
    * Other_fac_en: Since party is a weak entity of case, shouldn't you have a foreign key reference of the primary keys of party into this table? Also, I don't think factors can exist without a party. Can they? If you agree, you also need to add the 'on delete cascade' constraint. Lastly, I don't think you need a separate table for the "have" relationship b/w party and other_fac_en, it is absorbed as a single table for 'other_fac_en'. 
    * safety_equip_en: It is indeed correct to have a single "safety_equipment" entity in the ER, however, during the translation I think you would need two separate tables: safetey_equipment for party and victim. Similar to the previous point and with a very similar explanation, I don't think you need separate tables for the relationships "have_ps" and "have_vs". 
    * party_involve: Recall that party can/should not exist without a collision, thus, you need to add 'on delete cascade' with FOREIGN KEY (case_id) REFERENCES Case(case_id). Also, shouldn't ve_num be added as a foreign key in the party table? Lastly, similar to the above two points, I don't think you need a separate table for the "take" relationship. 
    * associate_victim: Recall that victim can/should not exist without a party, thus, you need to add 'on delete cascade' with FOREIGN KEY (party_id) REFERENCES Party_involve(party_id). 
    * As stated in "feedback on assumptions", the 'road_en' and 'weather_en' tables need to be modeled differently. Again, similar to the above three points, I don't think you need separate tables for the relationships 'under_r' and 'under_w'. Feel free to decide on what all points from the above list you want/choose to include in your DDL. It is important to understand the reasoning behind each and every design choice. Lastly, if anything is unclear, we can discuss in more detail during the office hours. 
    * 
## =============== Feedback on Data Cleaning & Loading =============== 
- Thanks for the elaborate explanation of the data cleaning procedure. All good! 
  
- Questions: 
  * How are you generated identifiers: e.g. pcf_num, loc_num, con_num, etc.? 
  * How are you handling attributes with missing values, if any? Especially, the attributes that are important and shouldn't/can't be simply ignored. 

## =============== Feedback on Queries ===============
- Query 3, Query 9: Note that the query asks you to print the "fraction" and not the "percentage". 
- Query 4: shouldn't you use 'like' operator for fuzzy search on the snowy weather conditions? Also, this is a very simple query, consider solving it without nested queries. 
- Query 5: Can be solved without nested queries. Consider using 'fetch first 1 rows only;' on 5a after sorting in descending order, and I think that should just solve it! 
- Query 7: Consider using 'like' operator for fuzzy string matching with 'loose material'. 
- Query 10: You are again printing 'percentages'. Also, consider simplifying the query, you have a very deep nested query. 



## =============== Feedback on General Comments =============== 
  - We found that TIME type will lead to error in query (in Oracle SQL) so we use DATE type. There are also other types like timestamp/datetime and so on, and we are not sure if this type is the best choice. 
    * I think using "DATE" type is just fine. I don't see any reason for not to use it. If it helps solve all the queries (both deliverable 2 and 3), I think the choice should be just fine. 
- Is it better to combine condition into the case? For it has only two attributes now. We found that we may need more join operations based on this design, is it acceptable? 
  * Yes, I think that the "condition" entity could be merged with "case". It doesn't give you any specific advantage to keep these two entities as separate. 
  
Overall, I appreciate your effort and thought process. Please incorporate the minor feedback around the ER model and DDL, and then, keep up the good work on the queries. If you have any further queries, please feel free to ask or schedule a meeting for better understanding. Keep your cadence! 
