/*the task is to create an average profile of a regional client based on a dataset for regions (the first two digits of the zip code), who has an education (at least a graduate), does not have a mortgage at the moment, indicating his minimum and maximum amount of credit card charges, which amount to no more than 45% of annual income and falls in 50% average age percentile. The family size is at least 3 people. It is necessary to evaluate the percentage of clients by region that fall under these conditions in order to verify the viability of a future mortgage program.

The regional client's profile includes age, education, experience, family size, income information, and credit card charges.

The results should contain the following set of fields:
- region
- target number of clients
- total number of clients by region
- % of eligible clients for the program
- average customer experience
- the minimum and maximum amount of credit card charges
- minimum income

Admissions:
- to determine the region, the first two digits of the postal code are taken, which are considered to be entered correctly.
- the size of the family according to the client / completed questionnaire. There is no official verification through government systems
- 50% average age percentile - it is assumed that the client falls within the range of 25-75% of the age of all clients
- the meaning of a negative experience is considered a typo
- CCAvg is considered an average monthly debit on the card

задача - на основе датасета для регинов (первые две цифры почтового индекса) сформировать среднестатистический профиль регионального клиента, у которого есть образование (минимум выпускник), нет ипотеки на текущий момент, с указанием его минимального и максимального размера списаний по кредитным картам, которые составляют не более 45 % от годового дохода и по падает в 50% средний перцентиль по возрасту. Размер семьи - минимум 3 человека. Необходимо оценить % клиентов по регионам, которые подпадают под эти условия для проверки жизнеспособности будущей ипотечной программы.

Профиль регионального клиента включает в себя возраст, образование, опыт, размер семьи, информацию по доходам и списаниям по кредитной карте.

В итогах должен быть следующий набор полей:
- регион
- целевое количество клиентов
- общее количество клиентов по региону
- % подходящих клиентов под программу
- средний опыт клиента
- мин и макс размер списаний по кредитной карте
- минимальный доход

Допушения:
- для определения региона берутся первые две цифры почтового индекса, которые считаются корректно введенными
- размер семьи со слов клиента / заполненной анкеты. Официальной проверки через государственные системы нет
- 50% средний перцентиль по возрасту - подразумевается, что клиент по падает в диапазон 25-75% возраста всех клиентов
- значение отрицательного опыта считается опечаткой
- CCAvg считается средним месячным списанием по карте
*/

with client_set as (
    SELECT
        ID,
		substr(cast([ZIP Code] as varchar(10)), 1,2)  zip_region,
		age,
	    education,	
		abs(Experience) as Experience,
		Family,
		income,
		CCAvg,
		Mortgage,
		nullif(round((100 * CCAvg * 12 / income), 2), 0) ccpay_to_income,
		NTILE(4) OVER (ORDER BY age) age_score
    FROM CreditoPersonal
	where 1=1
),
total_clients as (
SELECT substr(cast([ZIP Code] as varchar(10)), 1,2)  zip_region, count(id) clients_cnt
from CreditoPersonal
group by substr(cast([ZIP Code] as varchar(10)), 1,2)  
)

select s.zip_region, 
		count(s.id) target_clients
       ,c.clients_cnt total_region_clients
       ,round(100.0 *count(s.id)/ c.clients_cnt, 2) per_clients
	   ,round(avg(s.Experience), 0) Experience_avg 
	   ,min(s.ccavg)
	   ,max(s.ccavg)
	   ,min(s.income)
from client_set s
left join total_clients c on s.zip_region = c.zip_region
where 1=1
and Education in (2,3)
and s.age_score in (2,3)
and Mortgage = 0
and ccpay_to_income <= 45
and s.family >=3

group by s.zip_region
order by s.zip_region

/*
резюме -моделирование показало, что по всем регионам на текущий момент заявленным условиям удовлетворяют около 360 клиентов, что составляет около 7% от общего числа клиентов. В постановке задачи не указан порог жизнеспособности проекта

Summary modeling showed that about 360 clients currently meet the stated conditions in all regions, which is about 7% of the total number of clients. The task statement does not specify a threshold for the viability of the project
*/