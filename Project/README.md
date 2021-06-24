Programmatic access of database:
To update or add courses - Enroll students

CH18B035 - A Gunavardhan Reddy

Requirements to run the code:
1 - academic_insti locally hosted
2 - Environment to execute C - code
3 - mysql library refer - http://zetcode.com/db/mysqlc/											(SUCCESSFULLY WORKED IN UBUNTU)

cmds to execute in terminal: (-- after changing the input password in int main())
$ c99 Group12_CH18B035_Assignment5.c `mysql_config --cflags --libs`
$ ./a.out

except for specific asked inputs rest all are binary inputs...

Assumptions:
1 - As given in question all the courses and students are added with respect to the even sem of 2006 i.e., for checking prerequisite 
	courses we check enrollment data of students on or before 2006
2 - Course update checks if course is in even sem of 2006, as per the question, on this it updates or adds
3 - No function to delete a tuple(course) - not asked in question so keeping it simple

Basic Idea:
update/add course:
	check if course is already offered
		if yes then proceed with updating
		if no then proceed with inserting

Enrollment:
	check if the course and rollNo exists and offered in even sem of 2006:
		if yes check for prerequisites whether the student has done or not:
			if yes enroll or insert
			if no print all the courses need by him to enroll this course
		if no return to intial statement


What exactly happening in the code is shown in the flowchart attached along with the zip ----- Please look into it for better understanding


Functions decalred and there applications :-

Function CheckDept ( takes deptId ) : 
		checks if that department exists in the database else gives the error statment not present

Function CheckProf ( takes empId ) : 
		checks if the professor with that empId exists in the database else gives the error statment not present

Function CheckrollNo ( takes rollNo ) :
		checks if the student with that rollNo exists in the database else gives the error statment not present

Function Checkcourse ( takes courseId ) : 
		checks if the course with that that courseId exists in the database else gives the error statment not present

Funciton Checkpre ( takes rollNO, courseId ) :
		checks if the student with that rollNo has enrolled in all prerequiste courses of courseId
			if not then prints all the prerequisite courses which he has to do, to get enrolled

Function UpdAddteac ( takes courseId, empId, classroom )
		checks whether to update or insert the tuple as we are focusing on even sem of 2006 then does the necessary

Function UpdCourse (takes deptId, courseId ) : 
		Collects all the needed information to update the existing course of even sem of 2006 and updates it in the course and 
		teaching table of database

Function AddCourse (takes deptId, courseId ) : 
		Collects all the needed information to add the new course of even sem of 2006 and inserts it in the course and teaching 
		table of database

Function colCourseInfo ():
		Takes deptId and courseId and checks if its beeing offered in even sem of 2005 based on that decides to update or insert 
		the course

Function Enroll ():
		Collects rollN of student and courseId to be enrolled then checks prerequsites and then inserts this into enrollment table 
		of database 
