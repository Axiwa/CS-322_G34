Hi Team, Please find below my feedback on your submission corresponding to the Milestone 1 of the project. 

I trust that you will find the suggestions as useful and continue successfully with tasks that go towards Milestone 2. 

=============== Feedback on Assumptions =============== 

- Good job on assumptions, they are clear and reasonable. Note that you might need more assumptions and modifications of the participation and key constraints once you clean the data and start loading it. Keep up the good work, and back up any new assumptions that you might add with data whenever possible. 

- "Party_number refers to the specific party of a particular case, so party_number + case_id is unique for each party, playing the same role as party_id." * Have you verified this from the data? 

=============== Feedback on ER Model =============== 

- Why do you need a separate "condition" entity on top of "road_en" and "weather_en"? Would having just the latter two not suffice? When in doubt always go for simple and direct relationships between entities over unnecessary complex and multi-level relationships. 

- From your DDL translations I inferred that "party" is a weak entity of "case", and similarly, "victims" is a weak entity of "party". Please clarify if that's not the case. If yes, please make sure that all weak entities are appropriately marked in the ER model as well as in the description. If no, you need to rethink this aspect. For example, parties can be modeled as a weak entity, as they only exist in the context of a collision ("case" entity in your ER model). 

- Everything else looks good. 

=============== Feedback on DDL and Relational Schema =============== 

- It is not clear to me how did you translate the aggregation of "case" and "location" to DDL? Is it really necessary to have that aggregation? As a general suggestion: consider simplifying the ER aggregation if you think that the ER aggregation is not necessary. 

- Please take **utmost** care about the datatypes. 
  For instance, I noticed that you have used "varchar" for modeling "collision_time". AFAIK, there is a time datatype (https://docs.oracle.com/javadb/10.8.3.0/ref/rrefsqlj21908.html), which seems to be better suited in this case. While I did not spot any other violations, please check other cases as well. 

- General guidelines about DDL: * If you model entities as weak entities, you should also make sure they behave accordingly (e.g. if you delete the main entity, you delete all the dependents) * Make sure that you have all the **NOT NULL constraints** where you need them for the presented cardinalities in the ER model.

 =============== Feedback on General Comments =============== 
 - "We have tried our best to create a rigorous, elegant and efficient model, but we also have some confusion about some constraints and a better way to integrate attributes, entities and relationships." Please explicitly state the sources of confusion in the future. This is exactly why we have milestones. Anyway, you can discuss more during the project office hours if something is still unclear. As general information, if you want you can read this blog post (https://www.geeksforgeeks.org/normal-forms-in-dbms/) about normalization and normal forms. Overall, I appreciate your effort and thought process. If you have any further queries, please feel free to ask or schedule a meeting for better understanding. Keep your cadence! Best, Akhil