##User Table
CREATE TABLE User (
	User_ID	VARCHAR(10) NOT NULL UNIQUE,
	 User_Name 	VARCHAR(20),
	 Email_ID 	VARCHAR(20),
	 Mobile_Num 	VARCHAR(10),
	 User_Type 	VARCHAR(10),
	PRIMARY KEY( User_ID )
);

INSERT INTO User 
VALUES ('John101','John, Adams','john0@gmail.com','(857) 1231223','User');

##Destination Table
CREATE TABLE  Destination  (
	 Dest_ID 	VARCHAR(10) NOT NULL UNIQUE,
	 Dest_Name 	VARCHAR(50),
	 State 	VARCHAR(20),
	 City 	VARCHAR(20),
	 Zipcode 	VARCHAR(5),
	PRIMARY KEY( Dest_ID )
);
insert into Destination values ('GCNPTU23',	'Grand Canyon National Park',	'Arizona',	'Tusayan',	'86023');

##Trail Table
CREATE TABLE  Trail  (
	 Trail_ID 	VARCHAR(10) NOT NULL UNIQUE,
	 Trail_Name 	VARCHAR(50),
	 FK_Dest_ID 	VARCHAR(10),
	 Duration 	VARCHAR(10),
	 Difficulty_Level 	VARCHAR(10),
	 Total_Slots 	INTEGER,
	 Date 	VARCHAR(10),
	 Time_Slots 	VARCHAR(10),
	FOREIGN KEY( FK_Dest_ID ) REFERENCES  Destination ( Dest_ID ),
	PRIMARY KEY( Trail_ID )
);
insert into Trail values ('10',	'South Kaibab Trail',	'GCNPTU23',	'5-7 Hrs',	'Low',	15	,'Friday, November 25, 2022',	'8 AM');

##Booking Table
CREATE TABLE  Booking  (
	 Booking_ID 	VARCHAR(10) NOT NULL UNIQUE,
	 FK_User_ID 	VARCHAR(10),
	 FK_Trail_ID 	VARCHAR(10),
	 Num_Of_People 	INTEGER,
	 Date 	VARCHAR(10),
	 Time_Slot 	VARCHAR(10),
	FOREIGN KEY( FK_Trail_ID ) REFERENCES  Trail ( Trail_ID ),
	FOREIGN KEY( FK_User_ID ) REFERENCES  User ( User_ID ),
	PRIMARY KEY( Booking_ID )
);
insert into Booking values('11',	'John101',	'10',	1,	'Friday, November 25, 2022'	,'8:00:00 AM');

##All 4 four tables populated with data. I have given only one insert query per table as an example. It would take too much space if I paste all insert statements. 
select *  from user;
select * from Destination;
select * from Trail;
select * from Booking;


##Query 1: Admin wants to check the total number of trails per destination
SELECT d.Dest_Name,d.State, COUNT(t.trail_id) as 'Number of Trails'
FROM Destination as D 
JOIN Trail as T 
ON D.Dest_ID=T.FK_Dest_ID
GROUP BY Dest_Name
ORDER BY COUNT(t.trail_id) DESC;

##Query 2: User Kiley, Duckitt wants to see all his bookings in the month of November
SELECT u.User_ID, u.User_Name, b.Booking_ID, b.FK_Trail_ID, b.Num_Of_People, b.date, b.Time_Slot
FROM user as u 
JOIN Booking as b 
ON u.User_ID=b.FK_User_ID 
WHERE u.User_Name='Kiley, Duckitt' 
AND b.date LIKE '%November%';

##Query 3: User wants to see all the trails in california which are easy and which are not more than one day and which fall on a weekends (Saturaday or Sunday)
SELECT t.Trail_ID, t.Trail_Name, d.Dest_Name, d.State, 
t.Duration, t.Difficulty_Level, t.Total_Slots, t.date, t.Time_Slot
FROM Trail as T 
JOIN Destination as D 
ON d.Dest_ID=t.FK_Dest_ID
WHERE d.State='California' 
AND t.Difficulty_Level='Low' 
AND t.Duration like '%Hrs%' 
AND (t.date like '%Saturday%' OR t.date like '%Sunday%');


##Query 4: Admin wants the total number of bookings and total number of people going on 8AM trek in Arizona on 27th November.
SELECT d.State,b.Time_Slot, b.date,
SUM(b.Num_of_People) as 'Total number of people',
COUNT(b.Booking_ID) as 'Number of Bookings'
FROM Booking as b 
JOIN Trail as T
ON b.FK_Trail_ID=t.Trail_ID
JOIN Destination as d  
ON t.FK_Dest_ID=d.Dest_ID
WHERE b.Time_Slot like '%8%' 
AND d.State='Arizona' 
AND t.date LIKE '%November 27%'
GROUP BY d.State,b.Time_Slot, b.date;


 ##Query 5: A user from Arizona wants to paln a trekking with his colleagues and wants to see the number of slots available in all trails of Sedona
 SELECT d.Dest_Name, t.Trail_Name, t.Trail_ID, t.Time_Slot, 
 t.date,t.Difficulty_Level, 
 (t.Total_Slots-sum(b.Num_Of_People)) as Available_Slots
 FROM  Trail as T 
 JOIN Booking as B
 ON b.FK_Trail_ID= t.Trail_ID
 JOIN Destination as D
 ON t.FK_Dest_ID=d.Dest_ID
 WHERE d.Dest_Name LIKE '%Sedona%' 
 group by t.Trail_ID
 order by Available_Slots DESC;
 ##queries to validate the results of above query
 select * from Trail where Trail_ID in ('105','110','100');
 select * from Booking where FK_Trail_ID in ('105','110','100');
 
##Query 6: Get all users and their booking details who have more than 1 bookings
 SELECT u.User_ID, u.User_Name, u.Mobile_Num,
 b.Booking_ID, b.FK_Trail_ID, b.Num_Of_People,
 b.date, b.Time_Slot 
 FROM user as u 
 join booking as b on u.User_ID= b.FK_User_ID 
 WHERE u.User_ID IN 
 (SELECT U.User_ID
   FROM booking as b
   JOIN User as U
   ON u.User_ID= b.FK_User_ID
   GROUP BY u.User_ID
   HAVING COUNT(B.Booking_ID)>1)
ORDER BY User_ID;

##Query 7: Trail details which have rating below 3
select t.Trail_Name, t.Duration, 
t.Difficulty_Level, r.Rating, r.Cons from 
Review as r
JOIN Trail as T
ON t.Trail_ID= r.FK_Trail_ID
WHERE rating <3;

##########Begin-User registeration to Booking##########
##1. A new user registers into the application and all user details are inserted into User table.
INSERT INTO User VALUES ('John101','John, Adams','john0@gmail.com','(857) 1231223','User');

##2. This user is in Arizona and wants to plan a trekking with family and wants to see the number of slots available in all trails of Sedona which are not more than one day.
SELECT t.Trail_ID, t.Trail_Name, d.Dest_Name, d.State, t.Duration, t.Difficulty_Level, t.Total_Slots, t.date, t.Time_Slot
FROM Trail as T 
JOIN Destination as D 
ON d.Dest_ID=t.FK_Dest_ID
WHERE d.State='California' 
AND t.Difficulty_Level='Low' 
AND t.Duration like '%Hrs%' 
AND (t.date like '%Saturday%' OR t.date like '%Sunday%');

##3. Based on the output, user decides to book for 3 people in Trail_ID 100 and wants to know the total cost and amount to be paid while booking.
SELECT (cost*3) as 'Total_Amount', -- Cost for 3 members
((cost*3)*20)/100 as 'Amount to pay while booking' ##20% of total amount
FROM 
trail AS t
WHERE t.Trail_ID= '100';

##4. User proceeds with the booking and details are inserted into Booking table
insert into Booking values ('286','John101','100',3,'Thursday, November 10, 2022','8:00:00 AM',180);

##5. User wants to view booking details along with destination and Trail details
SELECT u.User_Name, b.Booking_ID, b.Num_Of_People,
t.Trail_ID,t.Trail_Name,d.Dest_Name,d.State,t.Duration,
t.Difficulty_Level,b.date,b.Time_Slot,  b.Total_Amount 
FROM user as u
JOIN Booking as b
ON u.User_ID = b. FK_User_ID
JOIN Trail as t
ON t.Trail_ID = b.FK_Trail_ID
JOIN Destination as d
ON d.Dest_ID = t.FK_Dest_ID
where u.User_ID='John101';

##########End-User registeration to Booking#########


##########Begin - Visualization Data Query##########
select FK_Trail_ID, t.Trail_Name, d.Dest_Name,d.State, 
t.Duration, t.Difficulty_Level,t.Time_Slot,  sum(b.num_of_people) 
from booking as b
join Trail as t on t.Trail_ID= b.FK_Trail_ID
join Destination as d on d.Dest_ID = t.FK_Dest_ID
group by  FK_Trail_ID, t.Trail_Name, d.Dest_Name,d.State,
t.Duration,t.Time_Slot, t.Difficulty_Level
order  by sum(b.num_of_people)  desc
##########End - Visualization Data Query##########

