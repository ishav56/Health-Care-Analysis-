

select count(*) from healthcare_dateset where `Followup Date` is null;

update healthcare_dateset set `Followup Date`="2025-05-11" where `Followup Date` is null;

select * from healthcare_dateset where year(`Followup Date`)=2025;	

-- 1️ Write a query to count total number of patients in the hospital.
SELECT 
    COUNT(*) AS total_number_patients
FROM
    healthcare_dateset;

-- Q-2 Display total billing amount collected per diagnosis type.
select * from healthcare_dateset;
select diagnosis,sum(`billing amount`) as total_billing_amount from healthcare_dateset
group by diagnosis;

-- Q-3 Find the average feedback rating for each doctor.
select doctor,round(avg(Feedback),1) from healthcare_dateset 
group by doctor;

-- Q-4 Show all patients admitted in the ICU only.
select count(Patient_ID) as all_patients,Bed_Occupancy from healthcare_dateset where Bed_Occupancy="ICU"
group by Bed_Occupancy;

-- Q-5 Get patients whose discharge date is later than ‘2023-01-10’.
select * from healthcare_dateset where date(`Followup Date`)>'2023-01-10';

-- Q-6 List the top 5 highest billing patients.
select Patient_ID,sum(`billing amount`) as higest_billing from healthcare_dateset
group by Patient_ID  order by higest_billing  desc limit 5;

-- Q-7 Display total health insurance claim amount per bed type.
select Bed_Occupancy,sum(`Health Insurance Amount`) as total_health_amount from healthcare_dateset
group by Bed_Occupancy;

--  Q-8 Get the patient ID, doctor, and billing amount for viral infection diagnosis.
select Patient_ID,Doctor,`Billing Amount`,Diagnosis from healthcare_dateset  where Diagnosis="viral infection";

-- Q-9 Count how many follow-ups are scheduled for each month.
select count(`Followup Date`) as follow_ups ,month(`Followup Date`) as month from healthcare_dateset 
group by month(`Followup Date`);


-- Q-10 Calculate the total days each patient stayed in the hospital.
select  Patient_ID,datediff(discharge_date,admit_date) as patient_stayed_total_days from healthcare_dateset;

-- Q-11 Retrieve the top 3 doctors whose average billing amount per patient is the highest.
select Patient_ID,doctor,avg(`Billing Amount`) as avg_billing from healthcare_dateset
group by Patient_ID,doctor order by doctor desc limit 3;

-- Q-12 Find the percentage of total patients in each diagnosis category.
select round((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM healthcare_dateset)),1) AS Percentage_of_Patients,Diagnosis from healthcare_dateset
group by diagnosis;

-- Q-13 Identify patients who stayed longer than the average stay duration of the hospital.
with stayed_longer as 
(select Patient_ID,datediff(discharge_date,admit_date)as stayed_longer_duration from healthcare_dateset order by stayed_longer_duration desc )

select Patient_ID,stayed_longer_duration from stayed_longer where stayed_longer_duration>(select avg(stayed_longer_duration) from stayed_longer) limit 1 ;


-- Q-14 Get patients with more than one follow-up scheduled and show count of follow-ups.
select Patient_ID,count(`Followup Date`) as follow_up from healthcare_dateset 
group by Patient_ID having follow_up>1;

-- Q-15 Retrieve the patients admitted on a weekend and calculate their average feedback rating.
select dayofweek(admit_date) as week_days,Patient_ID,avg(Feedback) as avg_feedback_rating from healthcare_dateset where dayofweek(admit_date)=7
group by Patient_ID,week_days;

-- Q-16 Find the longest continuous sequence of bed occupancy days per patient.

select * from
(
select Patient_ID,Bed_Occupancy,datediff(discharge_date,admit_date) as day_diff,
row_number() over (partition by Bed_Occupancy order by datediff(discharge_date,admit_date) desc) 
as sequence_of_bed 
from healthcare_dateset order by day_diff desc
) 
as e where e.sequence_of_bed=1;

--  Q-17 Display only those doctors whose total insurance claim amount from patients is greater than 80% of total billing.
with total_billing as 
(
select doctor,round(sum(`health insurance amount`),1) 
as total_claim_amount,
round(sum(`billing amount`)*0.80,1) as `80% of total billing` from healthcare_dateset group by Doctor)
select * from total_billing where  total_claim_amount>`80% of total billing` ;

-- Q-18 Rank doctors based on total number of patients handled per month using RANK() window function.

select doctor,count(Patient_ID) as total_number_of_patients 
,month(admit_date) as month,
dense_rank() over(partition by month(admit_date) order by count(doctor) desc ) 
as rank_dotor from healthcare_dateset
group by month(admit_date),doctor;

-- Q-19 Create a pivot-style output: Count of patients by Diagnosis (rows) and Bed Type (columns).

SELECT 
    Diagnosis,
    SUM(CASE WHEN Bed_Occupancy = 'General' THEN 1 ELSE 0 END) AS General,
    SUM(CASE WHEN Bed_Occupancy = 'ICU' THEN 1 ELSE 0 END) AS ICU,
    SUM(CASE WHEN Bed_Occupancy = 'Private' THEN 1 ELSE 0 END) AS Private
FROM healthcare_dateset
GROUP BY Diagnosis
ORDER BY Diagnosis;







