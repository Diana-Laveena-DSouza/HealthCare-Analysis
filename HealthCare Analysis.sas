/*import data */
proc import datafile='/home/u61251187/sasuser.v94/HospitalCosts.csv' 
out= Healthcare replace dbms=csv;
run;

/*Task 1: To record the patient statistics, the agency wants to find the age category of people who frequent the hospital and has the maximum expenditure.*/
/*To find the age category of people who frequent the hospital*/
proc sql;
create table Age_Frame as 
select AGE, count(AGE) as counts from Healthcare group by AGE;
run;
proc sql outobs=5;
select * from Age_Frame order by counts desc;
run;

/*To find the age category of people has the maximum expenditure.*/
proc sql;
create table Health_Frame as 
select AGE, sum(TOTCHG) as TOT from Healthcare group by AGE;
run;
proc sql outobs=5;
select * from Health_Frame order by TOT desc;
run;

/*Task 2: In order of severity of the diagnosis and treatments and to find out the expensive treatments, the agency wants to find the diagnosis related group that has maximum hospitalization and expenditure.*/

proc sql;
create table Health_Frame as 
select APRDRG, sum(TOTCHG) as TOT from Healthcare group by APRDRG;
run;
proc sql outobs=5;
select * from Health_Frame order by TOT desc;
run;

/*Task 3: To make sure that there is no malpractice, the agency needs to analyze if the race of the patient is related to the hospitalization costs.*/

proc anova data=Healthcare;
class RACE;
model TOTCHG=RACE;
means RACE / alpha=0.05;
run;

/*Task 4: To properly utilize the costs, the agency has to analyze the severity of the hospital costs by age and gender for proper allocation of resources.*/

proc glm data=Healthcare;
class AGE FEMALE;
model TOTCHG=AGE FEMALE;
means AGE FEMALE / alpha=0.05;
run;

/*Task 5: Since the length of stay is the crucial factor for inpatients, the agency wants to find if the length of stay can be predicted from age, gender, and race.*/

proc glm data=Healthcare;
class AGE FEMALE RACE;
model LOS=AGE FEMALE RACE;
means AGE FEMALE RACE/ alpha=0.05;
run;

/*Task 6: To perform a complete analysis, the agency wants to find the variable that mainly affects the hospital costs.*/

proc glm data=Healthcare;
class AGE FEMALE LOS RACE APRDRG;
model TOTCHG=AGE FEMALE LOS RACE APRDRG;
means AGE FEMALE LOS RACE APRDRG/ alpha=0.05;
run;

