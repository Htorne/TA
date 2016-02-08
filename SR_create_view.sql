DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
GO
CREATE VIEW crew_view AS
	SELECT q12.mID as mID, q12.date, q12.Crew1FirstName as Crew1FirstName, q12.Crew1LastName as Crew1LastName, q12.Crew2FirstName as Crew2FirstName, q12.Crew2LastName as Crew2LastName, q3.FirstName as Crew3FirstName, q3.LastName as Crew3LastName
	FROM
		(
		SELECT q1.MissionID as mID, q1.Date as date, q1.FirstName as Crew1FirstName, q1.LastName as Crew1LastName, q2.FirstName as Crew2FirstName, q2.LastName as Crew2LastName 
		FROM
			(
			SELECT * 
			FROM Mission as m, Crew as c
			WHERE c.CrewID = m.Crew1
			) as q1
		,
			(
			SELECT * 
			FROM Mission as m, Crew as c
			where c.CrewID = m.Crew2
			) as q2
		WHERE q1.MissionID = q2.MissionID
	) as q12
,
	(
	SELECT * 
	FROM Mission as m, Crew as c
	where c.CrewID = m.Crew3
	) as q3
WHERE q12.mID = q3.MissionID


	


 
    
