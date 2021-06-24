-- Assignment - 2 = CH18B035

-- Query 1 -- Find RollNo, name of Mech. Eng. students who have taken atleast one Comp. Sci. department course along with the course name and Id
-- Used -- join, exists, nested queries -- Method First we filter other departments and select mech students then we check if they have done atleast one course from CS department
-- Output -- 60 rows
select s.rollNo, s.name, c.cname, c.courseId
from student as s join department as d on s.deptNo = d.deptId, course as c
where d.name = 'Mech. Eng.' and exists 
		(select c.courseId, c1.cname from enrollment as e, department as d, course as c1
		where d.name = 'Comp. Sci.' and d.deptId = c1.deptNo and e.courseId = c1.courseId and e.rollNo = s.rollNo and c.courseId = c1.courseId);


-- Query 2 -- Find the names and rollNo of all students strongly influenced by senoir most professor of accounting department i.e., all students who enrolled in his course and secured S grade
-- Used -- join, orderby, min, nest queries -- Methid Find the empId of senor most professor then find the students enrolled in the courses taught by the prof and check whether they recived an S grade
-- Output 121 rows
select distinct e.rollNo, s.name
from enrollment as e, teaching as t, student as s
where t.courseId = e.courseId and e.rollNo = s.rollNo and t.empId = (select p.empId from professor as p join department as d on d.deptId = p.deptNo where d.name = 'Accounting' and
													p.startYear = (select min(p1.startYear) from professor as p1 where p1.deptNo = d.deptId)) and t.sem = e.sem and t.year = e.year and e.grade = 'S' order by e.rollNo;


-- Query 3 -- Find the ID and name of professors and the respective courses offered in year 2018 in which they didnt give S grade to any student enrolled
-- Used distinct, not in -- Method Join enrollment and teaching tuples and check for the course Id not to be in enrollment subset of which contains courses enrolled students with S grades
-- Output 1 row
select distinct p.empId, p.name, e.courseId
from enrollment as e, professor as p, teaching as t
where e.courseId = t.courseId and t.sem = e.sem and t.year = 2018 and e.year = 2018 and p.empId = t.empId and e.courseId
			not in (select distinct e1.courseId from enrollment as e1 where e1.grade = 'S' and e1.year = 2018 and e.sem = e1.sem);
 

-- Query 4 -- Find rollNo, name of female students who have enrolled in engineering departments(departments whose name ends with Eng.) in between year 2001 and 2003 and have done exactly 9 unique courses 
-- between 2001 and 2005 and order their names in alphabetical order
-- Used distinct, count, like, between and, order by, group by, having -- Method Filtering the eng. female students then counting the courses they have enrolled in years from enrollment and selecting those with count 9
-- Output 10 rows
select distinct s.rollNo, s.name, count(distinct e.courseId) as coursecont
from student as s, department as d, enrollment as e
where d.name like '%Eng.' and d.deptId = s.deptNo and s.sex = 'female' and e.rollNo = s.rollNo and e.year between 2001 and 2005 and s.year between 2001 and 2003 group by s.rollNo having coursecont = 9 order by s.name;


-- Query 5 -- Find first degree and second degree prerequistes of courses Game programming and Operating systems
-- Used distinct, join, union, in, nested queries -- Method Selecting the courseId first then checking the prerequistie table twice for first degree and second degree using nested queries
-- Output 8 rows 
(select distinct c1.courseId, c1.cname
from prerequisite as p join course as c on c.courseId = p.courseId, course as c1
where (c.cname = 'Game Programming' or c.cname = 'Operating Systems') and c1.courseId in ((select p1.preReqCourse from prerequisite as p1 where p1.courseId = p.courseId) union
                                                (select p1.preReqCourse from prerequisite as p1 
                                                where p1.courseId = any (select p2.preReqCourse from prerequisite as p2 where p2.courseId = p.courseId))));
 

 -- Query 6 -- Find id and name of department which is youngest and oldest in terms of students year of joining(avergae) along with total number of students (assumption students enter at age of 18/ in terms of insti experience)
 -- Used views, count, avg, union, all, group by -- Method create a view of just deptId, and avergae of the joining year of students lower it is oldest it is, then pick the min and max i.e, young and old and join using union
 -- Output 2 rows -- Comp. Sci Young, Accounting Old
create view deptstudrel as
(select d.deptId, d.name, count(s.rollNo) as totalStud, avg(s.year) as avgyear
from department as d join student as s on d.deptId = s.deptNo group by d.deptId);

select d.deptId, d.name, totalStud, avgyear
from deptstudrel as d
where avgyear >= all (select avgyear
						from deptstudrel) union
select d.deptId, d.name, totalStud, avgyear
from deptstudrel as d
where avgyear <= all (select avgyear
						from deptstudrel);
 
 

-- Query 7 -- Find the most demanded course from each department in between year 2001-2002 also find the sem and year they offered it with the strength (if a clash pick both)
-- Used views, count, all, max, group by, order by -- Method Create a view of all courese strength offered between 2001 and 2002 then pick each departments max strength or mosted demanded course using the view 
-- Output 14 rows
create view demandedcourse as
(select d.deptId, d.name, c.courseId, c.cname, e.sem, e.year, count(e.rollNo) as studenrolled
from enrollment as e join course as c on c.courseId = e.courseId, department as d
where c.deptNo = d.deptId and (e.year = 2002 or e.year = 2001) group by e.courseId, e.sem, e.year order by d.deptId);

select d.deptId, d.name, d.courseId, d.cname, d.sem, d.year, studenrolled
from demandedcourse as d
where d.studenrolled = all (select max(studenrolled)
							from demandedcourse as d1
                            where d1.deptId = d.deptId);


-- Query 8 -- Find the students who have enrolled in atleast 2 courses offered by their advisors and secured S or A grade in them
-- Used count, exists, group by, having, orderby -- Method select the students who have done enrolled in courses by their advisors then count the number of courses and only those in which they secured S/A then tailor using having
-- Output 8 rows
select s.rollNo, s.name, p.name, count(c.courseId) as cont
from student as s, professor as p, course as c
where p.empId = s.advisor and exists (select e.courseId from enrollment as e, teaching as t 
				where e.courseId = t.courseId and c.courseId = t.courseId and e.sem = t.sem and e.year = t.year and t.empId = s.advisor and e.rollNo = s.rollNo and (e.grade = 'S' or e.grade = 'A'))
				group by s.rollNo having cont >= 2 order by s.rollNo;

