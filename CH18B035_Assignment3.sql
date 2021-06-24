-- Assignment - 3 - CH18B035 - Gunavardhan

-- Query 1 -- Find Id name of multitalented physician i.e., physicians who look after patients from more than one carecenters, in order of their Id
-- Used count, distinct, join, group by, having, order by -- Method From patient data finding physicians and tracking the distinct carecenters they interact with then filter using having to get answer
-- Output 3 rows
select p.physicianId, p1.name, count(distinct p.ccId)
from patient as p join physician as p1 on p.physicianId = p1.physicianId group by p.physicianId having count(distinct p.ccid) >= 2 order by p.physicianId;


-- Query 2 -- Find the discharged patients Id and name who have consumed any pain management drug in between 30/04/2020 and 20/07/2020 as the drug manufacturer has mistakely mixed a hazardous chemical in the drug in priority of contanct order
-- Used distinct, any, like, between and, order by -- Method From item tuple identify the drugs Id then check with patients used data when they consumed this drug and whether they discharged or not then sort by priority order
-- Output 5 rows
select distinct u.patientId, p.name
from used as u, patient as p
where u.itemId = any(select i.itemId from item as i where i.description like '%Pain management') and u.date between 20200430 and 20200720 and p.patientId = u.patientId and p.patientId != 00000000 order by u.date desc;


-- Query 3 -- Find the number of empty VIP rooms(rooms with single beds) in the each care center of the hospital along with room numbers
-- Used not in, group by, having, count -- Method From bed find the rooms with single beds which are VIP rooms then check with patient data to know whether they are occupied are not
-- Output 10 rows
select b.carecenterId, b.room_no
from bed as b
where b.bed_no not in (select p.bed_no from patient as p where p.ccId = b.carecenterId and p.room_no = b.room_no and p.dis_date = 00000000) 
					group by carecenterId, room_no having count(bed_no) = 1;

                    
-- Query 4 -- Find the name and Id youngest employe/e who is incharge of a carecenter also find out name of it, work hours he/she is assigned
-- Used join, all, min -- Method Join employee and carecenter to identify the incharge employees and find the min age of incharge employee within then
-- Output 2 rows
select e.empId, e.name, c.name, a.assigned_time
from employee as e join assigns as a on a.empId = e.empId, carecenter as c
where c.Id = e.carecenterId and e.empId = c.incharge_id and e.age = all (select min(e1.age) from employee as e1, carecenter as c1 where c1.incharge_Id = e1.empId);


-- Query 5 -- Find the cost incurred by the hospital for each patient whose treatment went unsuccessfull(hospital policy from the day of unsuccessful treatment all costs are 
-- rembruised i.e., treatment cost and medicine cost) along with patient name and physician responsible
-- Used views, sum, join, group by -- Method join performs, treatment, patient identify the cost of unsuccessfull treatment then find total sum of used medicines from used table after the unsuccessfull treatment date
-- Output 2 rows
create view lossincurred as
(select p.patientId, p1.name as patientName, p2.name as physicianName, t.cost as treatment_cost, sum(u.total_cost) as medicine_cost
from performs as p, treatment as t, used as u, patient as p1 join physician as p2 on p1.physicianId = p2.physicianId
where p.result = 'unsuccessful' and t.treatmentId = p.treatmentId and p1.patientId = p.patientId and u.patientId = p.patientId and p.date <= u.date group by p.patientId);

select patientId, patientName, physicianName, treatment_cost + medicine_cost as total_cost
from lossincurred;


-- Query 6 -- Find the Id, name of physician who is proficient in cardiology treatment i.e., has highest number of successful cardiology treatments without a single unsuccessful treatment in his/her track record
-- Used view, join, not exists, group by, max, count -- Method find the count of all successful cardiology treatments by each physician then remove those with even a single unsuccessful treatment, use this table to identify the best physician for the treatment
-- Output 1 row -- aditi
create view succCardiology as
(select  p.physicianId, p1.name, count(p.result) as sucount
from performs as p join physician as p1 on p1.physicianId = p.physicianId, treatment as t
where t.name = 'Cardiology' and p.treatmentId = t.treatmentId and not exists (select p2.physicianId from performs as p2
                                                                where p2.treatmentId = t.treatmentId and p.physicianId = p2.physicianId and p2.result = 'unsuccessful') group by p.physicianId);
                                                                                        
select physicianId, name
from succCardiology
where sucount = (select max(sucount) from succCardiology);


-- Query 7 -- Find Id and name of most sought after treatment by VIP patients
-- Used views, count, group by having, exists, max -- Method first find the VIP rooms, then collect the treatments of patients who reside in VIP rooms generated before count them, lastly find the one which is most sought after
-- Output 1 row - cardiology
create view VIProoms as
(select carecenterId, room_no
from bed group by carecenterId, room_no having count(bed_no) = 1);

create view VIP_treatmentcount as
(select p.treatmentId, t.name, count(p.patientId) as count
from performs as p, treatment as t
where t.treatmentId = p.treatmentId and exists(select p1.patientId from patient as p1, VIProoms as v
                                                where p1.room_no = v.room_no and p1.ccId = v.carecenterId and p.patientId = p1.patientId) group by p.treatmentId);

select treatmentId, name
from VIP_treatmentcount
where count = (select max(count) from VIP_treatmentcount);


-- Query 8 -- Find the Id and Names of all employees whose carecenter has got most patients getting treatment in the last month i.e., 09/2020 that at night hours after 6'oclock if clash find all employees which has lowest carecenter Id
-- Used views, count, between and, group by, order by, limit -- Method count the patients whose treatment is scheduled in Sept2020 per each carecenter then find the carecenter with max number of patients and lowest Id then join with employee to find the employees list
-- Output 2 rows
create view treatment_sept2020 as
(select p1.ccId, count(p.patientId) as no_patients
from performs as p, patient as p1
where p.time >= 1800 and p.date between 20200901 and 202020930 and p.patientId = p1.patientId group by p1.ccId);

select e.empId, e.name, e.carecenterId
from employee as e
where e.carecenterId = (select ccId from treatment_sept2020 as t order by no_patients desc, ccId asc limit 1)