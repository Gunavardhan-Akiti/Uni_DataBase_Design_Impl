#include <mysql.h>
#include <stdio.h>
#include <string.h>

// checks if that department exists in the database else gives the error statment not present
int CheckDept(MYSQL *conn, char* deptId){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300];
    sprintf(query, "SELECT d.deptId FROM department as d Where d.deptId = ('%s')", deptId);

    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) == NULL){ 
        printf("ERROR : Department with that Id doesn't Exist \n");
        mysql_free_result(res);
        return -1;
    }
    mysql_free_result(res);
    return 0;
}

// checks if the professor with that empId exists in the database else gives the error statment not present
int CheckProf(MYSQL *conn, char* empId){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300];
    sprintf(query, "SELECT p.empId FROM professor as p Where p.empId = ('%s')", empId);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) == NULL){ 
        printf("ERROR : Professor with that Id doesn't Exist \n");
        mysql_free_result(res);
        return -1;
    }
    mysql_free_result(res);
    return 0;
}

// checks if the student with that rollNo exists in the database else gives the error statment not present
int CheckrollNo(MYSQL *conn, char* rollNo){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300];
    sprintf(query, "SELECT s.rollNo FROM student as s Where s.rollNo = ('%s')", rollNo);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) == NULL){ 
        printf("ERROR : Student with that Id doesn't Exist \n");
        mysql_free_result(res);
        return -1;
    }
    mysql_free_result(res);
    return 0;
}

// checks if the course with that that courseId exists in the database else gives the error statment not present
int Checkcourse(MYSQL *conn, char* courseId){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300];
    sprintf(query, "SELECT t.courseId FROM teaching as t Where t.courseId = ('%s') and t.sem = 'even' and t.year = 2006", courseId);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) == NULL){ 
        printf("ERROR : Course with that Id is not offered in even sem of 2006 \n");
        mysql_free_result(res);
        return -1;
    }
    mysql_free_result(res);
    return 0;
}

// checks if the student with that rollNo has enrolled in all prerequiste courses of courseId if not then prints all the prerequisite courses which he has to do, to get enrolled
int Checkpre(MYSQL *conn, char* rollNo, char* courseId){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300];
    sprintf(query, "select p.preReqCourse from prerequisite as p where p.courseId = ('%s') and p.preReqCourse not in (select e.courseId from enrollment as e where e.year <=2006 and e.rollNo = ('%s')) ", courseId, rollNo);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) != NULL){
        printf("Given student with Id %s has not done the following prerequisite courses :\n", rollNo);
        printf("%s ", row[0]);
        while ((row = mysql_fetch_row(res)) != NULL)
            printf("%s ", row[0]);
        printf("\nHence cannot be enrolled \n");
        mysql_free_result(res);
        return -1;
    }
    mysql_free_result(res);
    return 0;
}

// checks whether to update or insert the tuple as we are focusing on even sem of 2006 then does the necessary
int UpdAddteac(MYSQL *conn, char* courseId, char* empId, char* clsrm){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300], query1[300], query2[300];
    sprintf(query, "SELECT t.courseId FROM teaching as t Where t.empId = ('%s') and t.courseId = ('%s') and t.sem = 'Even' and t.year = 2006", empId, courseId);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) == NULL){ 
        mysql_free_result(res);
        sprintf(query1, "INSERT INTO teaching VALUES (('%s'), ('%s'), 'Even', 2006, ('%s'));", empId, courseId, clsrm);
        if (mysql_query(conn, query1)) {
            fprintf(stderr, "%s\n", mysql_error(conn));
            exit(1);
        }
    }
    else{
        mysql_free_result(res);
        sprintf(query2, "UPDATE teaching SET classRoom = ('%s') Where empId = ('%s') and courseId = ('%s') and sem = 'even' and year = 2006;", clsrm, empId, courseId);

        if (mysql_query(conn, query2)) {
            fprintf(stderr, "%s\n", mysql_error(conn));
            exit(1);
        }
    }
    res = mysql_use_result(conn);
    mysql_free_result(res);
    return 0;
}

// Collects all the needed information to update the existing course of even sem of 2006 and updates it in the course and teaching table of database
void UpdCourse(MYSQL *conn, char* deptId, char* courseId){
    
    char query[300], cname[50], empId[5], clsrm[8];
    int credits;
    printf("Enter the Id of Professor teaching the existing course %s : ", courseId);
    scanf("%s", empId);
    if(CheckProf(conn, empId) == -1) return;
    printf("Enter the updated course name of the existing course %s : ", courseId);
    scanf("%s", cname);
    printf("Enter the updated credits of the existing courses %s : ", courseId);
    scanf("%d", &credits);
    printf("Enter the updated class room of the existing courses %s : ", courseId);
    scanf("%s", clsrm);

    sprintf(query, "UPDATE course SET cname = ('%s'), credits = ('%d') Where courseId = ('%s') and deptNo = ('%s');", cname, credits, courseId, deptId);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    UpdAddteac(conn, courseId, empId, clsrm);

    printf("\nExisting course is updated successfully\n");
}

// Collects all the needed information to add the new course of even sem of 2006 and inserts it in the course and teaching table of database
void AddCourse(MYSQL *conn, char* deptId, char* courseId){
    
    char query1[300], query2[300], cname[50], empId[5], clsrm[8];
    int credits;
    printf("Enter the Id of Professor teaching the New course %s : ", courseId);
    scanf("%s", empId);
    if(CheckProf(conn, empId) == -1) return;
    printf("Enter the course name of the course %s : ", courseId);
    scanf("%s", cname);
    printf("Enter the credits of the courses %s: ", courseId);
    scanf("%d", &credits);
    printf("Enter the class room of the courses %s: ", courseId);
    scanf("%s", clsrm);

    sprintf(query1, "INSERT INTO course VALUES (('%s'), ('%s'), ('%d'), ('%s'));", courseId, cname, credits, deptId);
    if (mysql_query(conn, query1)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }

    sprintf(query2, "INSERT INTO teaching VALUES (('%s'), ('%s'), 'Even', 2006, ('%s'));", empId, courseId, clsrm);
    if (mysql_query(conn, query2)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    printf("\nNew course is added successfully\n");
}

// Takes deptId and courseId and checks if its beeing offered in even sem of 2005 based on that decides to update or insert the course
void colCourseInfo(MYSQL *conn){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300], deptId[20], courseId[8];

    printf("Enter Department Id of the course : ");
    scanf("%s", deptId);
    if(CheckDept(conn, deptId) == -1) return;
    printf("Enter Course Id of the course : ");
    scanf("%s", courseId);
    sprintf(query, "SELECT c.courseId FROM course as c Where c.deptNo = ('%s') and c.courseId = ('%s')", deptId, courseId);

    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }
    res = mysql_use_result(conn);
    if ((row = mysql_fetch_row(res)) != NULL){ 
        printf("\n!Course Exists! i.e., already offering in the given Department in even sem of 2006!\n\nCurrent provided details will be updated on the previous details \n");
        mysql_free_result(res);
        UpdCourse(conn, deptId, courseId);
    }
    else{
        printf("\n!New Course! i.e., course doesnt exist in the given Department in even sem of 2006!\n\nProvide all the details to add it to the database \n");
        mysql_free_result(res);
        AddCourse(conn, deptId, courseId);
    }
}

// Collects rollN of student and courseId to be enrolled then checks prerequsites and then inserts this into enrollment table of database 
void enroll(MYSQL *conn){
    MYSQL_RES *res;
    MYSQL_ROW row;
    char query[300], rollNo[5], courseId[8];
    printf("Enter rollNo of the student : ");
    scanf("%s", rollNo);
    if(CheckrollNo(conn, rollNo) == -1) return;
    printf("Enter Course Id of the course to enroll : ");
    scanf("%s", courseId);
    if(Checkcourse(conn, courseId) == -1) return;
    if(Checkpre(conn, rollNo, courseId) == -1) return;

    sprintf(query, "INSERT INTO enrollment(rollNo, courseId, sem, year) VALUES (('%s'), ('%s'), 'even', 2006);", rollNo, courseId);
    if (mysql_query(conn, query)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }

    printf("\nStudent is successfully enrolled\n");
}

int main() {
    MYSQL *conn;
    int add = 1, choose;

    char *server = "localhost";
    char *user = "root";
    char *password = "guna"; /* set me first */
    char *database = "academic_insti";

    conn = mysql_init(NULL);

    /* Connect to database */
    if (!mysql_real_connect(conn, server,
            user, password, database, 0, NULL, 0)) {
        fprintf(stderr, "%s\n", mysql_error(conn));
        exit(1);
    }

    printf("Welcome ADMIN!");
    while(exit){
        printf("\nMain Menu\nChoose what changes you want to make (1/2/3): \n1 - Add/Update course details\n2 - Enroll student/s to courses\n3 - EXIT\n SELECT OPTION - ");
        scanf("%d", &choose);
        add = 1;
        if(choose == 1)
            while(add){
                printf("\n1 - Add/Update course details\nEnter the following details\n");
                if(add == 1) colCourseInfo(conn);
                printf("\nWant to add/update anymore courses to the database : Choose(1-YES / 0-NO): ");
                scanf("%d", &add);
            }
        else if(choose == 2)
            while(add){
                printf("\n2 - Enroll student/s to courses\nEnter the following details\n");
                if(add == 1) enroll(conn);
                printf("\nWant to Enroll Students : Choose(1-YES / 0-NO)");
                scanf("%d", &add);
            }
        else{
            printf("\nThank you! Hope to see to soon\nExiting...");
            break;
        }
    }

    /* close connection */
    mysql_close(conn);
}