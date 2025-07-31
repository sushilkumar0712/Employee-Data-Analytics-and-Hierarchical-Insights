--1- write a query to print dep name and average salary of employees in that dep .

select d.dep_name, AVG(salary) as AVG_SALARY
from employee e 
	inner join dept d 
	on e.dept_id=d.dep_id
	group by d.dep_name

--2- write a query to print dep names where none of the employees have same salary.

select d.dep_name
from employee e
	inner join dept d on e.dept_id=d.dep_id
	group by d.dep_name
	having count(e.emp_id)=count(distinct e.salary)

--3- write a query to print dep name for which there is no employee

select * from dept
where dep_id not in (select dept_id from employee)

select d.dep_id,d.dep_name
from dept d 
	left join employee e on e.dept_id=d.dep_id
	group by d.dep_id,d.dep_name
	having count(e.emp_id)=0;

--4- write a query to print employees name for which dep id is not avaiable in dept table
select * from employee
where dept_id not in (select dep_id from dept)

select e.*
from employee e 
	left join dept d  on e.dept_id=d.dep_id
	where d.dep_id is null;

--5- Pint employee name whose slalry is more then managers salary

select e1.*
from employee e1 
	inner join employee e2 on e1.manager_id=e2.emp_id
	where e1.salary>e2.salary

--6- write a query to print emp name , their manager name and diffrence in their age (in days) 
--for employees whose year of birth is before their managers year of birth(manager is older)

select * from employee

select e1.emp_name,e2.emp_name as manager_name 
	,DATEDIFF(day,e1.dob,e2.dob) as diff_in_age
from employee e1
	inner join employee e2 
	on e1.manager_id=e2.emp_id
	where DATEPART(year,e1.dob)< DATEPART(year,e2.dob)

--7- write a query to print manager names along with the comma separated list(order by emp salary)
--of all employees directly reporting to him.

select e2.emp_name, STRING_AGG(e1.emp_name, '|') within group (order by e1.salary) as employees_name
from employee e1 
inner join employee e2 on e1.manager_id=e2.emp_id
group by e2.emp_name

--8- write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)

select  e1.emp_name as EMPLOYEE_NAME, e2.emp_name as MANAGER_NAME, e3.emp_name as HEAD_MANAGER
from employee e1
	inner join employee e2 on e1.manager_id=e2.emp_id
		inner join employee e3 on e2.manager_id=e3.emp_id

--9- Print average department salary for each department

select * from employee e1
inner join (
	select dept_id,AVG(salary) as average_salary
	from employee
	group by dept_id) e2 on e1.dept_id=e2.dept_id;

select *, AVG(salary) over(partition by dept_id) as average_salary
from employee
;

--10- write a query to find employees whose salary is more than average salary of employees in their department

select * from employee e1 
inner join(
	select dept_id, AVG(salary) as AVG_SALARY
	from employee
	group by dept_id) e2 
	on e1.dept_id=e2.dept_id
where e1.salary>e2.AVG_SALARY

select * from(
select *,AVG(salary) over(partition by dept_id ) as AVG_SALARY 
from employee) A
where salary>AVG_SALARY


--11- write a query to find employees whose age is more than average age of all the employees.

select * from employee e1
where emp_age > (select AVG(emp_age) as AVG_AGE from employee) 

--12- write a query to print emp name, salary and dep id of highest salaried employee in each department 

select * from employee e1 
inner join (
	select dept_id, MAX(salary)as maximum_salary
	from employee
	group by dept_id) e2
	on e2.dept_id=e1.dept_id
where maximum_salary=salary

select * from(
select *, rank() over(partition by dept_id order by salary desc) as rn from employee) A
where rn=1

--13- write a query to print emp name, salary and dep id of highest salaried employee overall
select * from employee
where salary = (select max(salary) from employee)

--14(a)- Print first 2 highest salaries of employees in different department

select * from(
select *, DENSE_RANK() over(partition by dept_id order by salary desc) as rn from employee) A
where rn<=2

--14(b)- if salary is same rearrange them on the basis of name

select * from(
select *, DENSE_RANK() over(partition by dept_id order by salary desc,emp_name) as rn from employee) A
where rn<=2


--15- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
--In case a department has less than 3 employees then print the details of highest salaried employee in that department.

select * from(
	SELECT *, DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rn
			,COUNT(1) OVER(PARTITION BY dept_id) AS no_of_emp
			FROM employee) a
		where rn=3 or (no_of_emp<3 and rn=1)




