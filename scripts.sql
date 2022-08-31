Select sum(so), g From teams
Where yearid = '2016';

Select * From teams
Where yearid between '1970' And '2016'
And wswin = 'Y';

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

Select
    Case When pos = 'OF' Then 'Outfield'
        When pos In ('SS','1B','2B','3B') Then 'Infield'
        When pos In ('P','C') Then 'Battery' End As Player_position,
        Sum(po) as total_po
From fielding
Where yearid ='2016'
Group By Player_position;

--Bettery = 41424, Infield = 58934, Outfield = 29560

--Q5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

Select decade, round(avg(avg_strikeouts),2) as avg_strikeouts
From
(Select distinct yearid/10*10 as decade,
    sum(so)/g as avg_strikeouts
From teams
Group By yearid,g
Having yearid >=1920) as iq
Group by decade
Order by decade asc;

Select decade, round(avg(avg_homeruns),2) as avg_homeruns
From
(Select distinct yearid/10*10 as decade,
    sum(hr)/g as avg_homeruns
From teams
Group By yearid, g
Having yearid >=1920) as iq
Group by decade
Order by decade asc;
--Opinion: The averages for both strikeouts and homeruns seem to have a steady incline from decade to decade. 

--Q6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.
Select p.namefirst,
    p.namelast,
    round(b.sb*1.0/sum(b.sb+b.cs),2) as perc_stolen
From people as p
Join batting as b
using(playerid)
Group By p.namefirst, p.namelast,b.sb, b.yearid
Having yearid = '2016'
    And  sum(b.sb+b.cs) > 20
Order By perc_stolen desc;
--A. Chris Owings w/ 91% success rate

--Q7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
Select *
From teams
Where yearid between '1970' And '2016'
    And wswin ='N'
order by w desc;
--A. 116 wins

Select *
From teams
Where yearid between '1970' And '2016'
    And wswin = 'Y'
Order By w asc;
--A. 63 wins

Select *
From teams
Where yearid between '1970' And '2016'
    And wswin = 'Y'
    And yearid <> '1981'
Order By w asc;
--A. 83 wins after excluding 1981 due to low game count.

Select teamid, sum(w) as perc_win
From teams
Where yearid between '1970' and '2016'
    And wswin = 'N'
Group by teamid
Order By perc_win;

Select distinct yearid, teamid, sum(g) as total_games, sum(w) as total_wins
From teams
Where yearid between '1970' AND '2016'
    AND wswin = 'Y'
Group By yearid,teamid
    
SElect *
From teams
Where yearid between '1970'and '2016'

--Q8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
Select distinct h.team,
    p.park_name,
    sum(attendance)/sum(games) as avg_attendance
From homegames as h
Left Join parks as p
Using(park)
Where h.games >= 10
    And year = '2016'
Group By h.team, p.park_name
Order By avg_attendance desc
Limit 5;
--A. Run Query for "Top 5 Avg_Attendance"

Select distinct h.team,
    p.park_name,
    sum(attendance)/sum(games) as avg_attendance
From homegames as h
Left Join parks as p
Using(park)
Where h.games >= 10
    And year = '2016'
Group By h.team, p.park_name
Order By avg_attendance asc
Limit 5;
--A. Run Query for "Bottom 5 Avg_Attendance"

--Q9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
    
SELECT DISTINCT am1.playerid, CONCAT(p.namefirst,' ',p.namelast) as manager, am2.awardid, am2.yearid AS NL_year, mh1.teamid as team, am2.lgid, am3.yearid AS AL_year, mh2.teamid as team, am3.lgid
FROM awardsmanagers AS am1
JOIN awardsmanagers AS am2
ON am1.playerid = am2.playerid AND am2.lgid = 'NL'
JOIN awardsmanagers AS am3
ON am2.playerid = am3.playerid AND am3.lgid = 'AL'
LEFT JOIN people as p
ON am1.playerid = p.playerid
left Join managershalf as mh1
On p.playerid = mh1.playerid
Left Join managershalf as mh2
On mh1.teamid = mh2.teamid
WHERE am2.awardid = 'TSN Manager of the Year' 
    AND am3.awardid = 'TSN Manager of the Year'
--Can get everything except team names.....

/*Select Concat(p.namefirst,' ', p.namelast), t.name as team, concat(am.lgid,'/',am2.lgid) as lgid1, am.awardid
From awardsmanagers as am
Join awardsmanagers as am2
On am.playerid=am2.playerid And am.lgid='NL'
Inner Join people as p
On am.playerid = p.playerid
Inner Join managershalf as mh
On p.playerid = mh.playerid
Inner Join teams as t
On mh.teamid = t.teamid
Where am.awardid = 'TSN Manager of the Year'
    And am2.lgid In ('NL','AL')
Group By concat,t.yearid, team, lgid1, am.awardid
Having Count(*)=2;

--With award_winner as
With award_winner as
(Select distinct t.yearid, Concat(p.namefirst,' ', p.namelast), t.name as team, t.lgid, am.awardid
From awardsmanagers as am
Inner Join people as p
On am.playerid = p.playerid
Inner Join managershalf as mh
On p.playerid = mh.playerid
Inner Join teams as t
On mh.teamid = t.teamid
Where am.awardid = 'TSN Manager of the Year')
Select distinct concat, team ,lgid, awardid
From award_winner
Where lgid IN ('NL' , 'AL')
Group By distinct concat, team, lgid, awardid
Having  Count(*)=3
Order By concat;

SELECT am.playerid, CONCAT(p.namefirst,' ', p.namelast) as full_name, am2.awardid, am.lgid, am.yearid, am2.lgid, am2.yearid, t.name
FROM awardsmanagers am
JOIN awardsmanagers am2
USING (playerid)
JOIN people p
USING (playerid)
--JOIN managers m
--USING(yearid)
WHERE am.awardid = 'TSN Manager of the Year' 
AND am.lgid IN ('AL','NL')
GROUP BY am.playerid, p.namegiven, am.awardid, am.yearid, m.teamid
ORDER BY am.playerid
    
Select distinct p.namefirst, p.namelast, t.name AS team 
From People as p
Left Join awardsmanagers as am
Using(playerid)
Join managershalf as mh
Using(playerid)
Join teams as t
Using(teamid)
Where am.awardid = 'TSN Manager of the Year'
    And am.lgid = 'NL'
UNION
Select distinct p.namefirst, p.namelast, t.name AS team 
From People as p
Left Join awardsmanagers as am
Using(playerid)
Join managershalf as mh
Using(playerid)
Join teams as t
Using(teamid)
Where am.awardid = 'TSN Manager of the Year'
    And am.lgid = 'AL';*/


--Q10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

WITH record_homeruns AS
   (SELECT playerid, yearid, MAX(hr) as max_homeruns
    FROM batting
    GROUP BY playerid, yearid),
        decade AS
            (SELECT playerid
            FROM batting
            GROUP BY playerid
            HAVING count(playerid) >= 10)
SELECT rh.yearid,(CONCAT(p.namefirst, ' ', p.namelast)) as name, rh.max_homeruns
FROM decade as d
LEFT JOIN record_homeruns as rh
USING(playerid)
LEFT JOIN people as p
USING(playerid)
WHERE yearid = 2016 AND max_homeruns <> 0
ORDER BY rh.max_homeruns DESC;
--A. Run Query...

