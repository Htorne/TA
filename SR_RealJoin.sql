DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
select MissionID,RockID ,date,Crew1FirstName, Crew1LastName, Crew2FirstName, Crew2LastName,Crew3FirstName, Crew3LastName,Mass,Name as MoonName


from crew_view as q1 
	,
		( 
			select RockId,Mass,Name,MissionID, MoonList.MoonID
			from Rock, Rocks.dbo.MoonList
			
			where Rock.MoonID = MoonList.MoonID
		) as q2
		where q2.MissionID = q1.mID
		order by MissionID

	

