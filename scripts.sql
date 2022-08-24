Select distinct playerid From collegeplaying
Where schoolid = 'vandy';

--Q1. What range of years for baseball games played does the provided database cover?
Select distinct yearid
From appearances
Order by yearid asc;
--A. 1871-2016

--Q2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
Select namefirst , namelast, height
From people
Order by height asc;
--A. Eddie Gaedel, 43 inches
Select p.namefirst, p.namelast, a.g_all
From people as p
Left Join appearances as a
Using(playerid)
Where p.namefirst = 'Eddie'
    And p.namelast = 'Gaedel';
--A. 1 game
Select distinct t.name, t.teamid
From people as p
Join appearances as a
Using(playerid)
Join teams as t
Using(teamid)
Where p.namefirst = 'Eddie'
    And p.namelast = 'Gaedel';
--A. St. Louis Browns

--Q3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
Select distinct p.namefirst, p.namelast, sum(s.salary)
From people as p
Left Join collegeplaying as c
Using (playerid)
Left Join salaries as s
Using (playerid)
Where c.schoolid = 'vandy'
    And s.salary is not null
Group By p.namefirst, p.namelast
Order by sum(s.salary) desc;
--A. David Price w/ $245,553,888

--Q4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.


--Q5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?


--Q6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.


--Q7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?


--Q8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.


--Q9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.


--Q10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.