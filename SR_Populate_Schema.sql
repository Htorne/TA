Use Rocks

--########################################200 Crew #####################################################################
Declare @CreateCrew as int
Declare @F1 as varchar(64)
Declare @L1 as varchar(64)
Set @CreateCrew = 0
while (@CreateCrew < 200 )
Begin
	
	
	Set @F1 =(
	Select FirstName
	From StaticDB.dbo.NameList
	Where StaticDB.dbo.NameList.NameListID = ABS(Checksum(NewID()) % 124) + 1)

	Set @L1 = (
	Select LastName
	From StaticDB.dbo.NameList
	Where StaticDB.dbo.NameList.NameListID = ABS(Checksum(NewID()) % 124) + 1)
	
	INSERT into Rocks.dbo.Crew(CrewID,FirstName,LastName)  values(@CreateCrew,@F1,@L1)
	

SET @CreateCrew = @CreateCrew + 1
end
--#######################################200 missions ######################################################################
Declare @CreateMission as int
Set @CreateMission = 0
Declare @CrewNumberTotal as int
Declare @C1 as int
Declare @C2 as int
Declare @C3 as int
Declare @date as date
Declare @FromDate date = '2011-01-01'
Declare @ToDate date = '2016-10-10'
SET @CrewNumberTotal = (SELECT * FROM OPENROWSET(BULK 'C:\Project15\crew', SINGLE_CLOB) AS INT)

while (@CreateMission < 150) --Define number of missions that you want to create
Begin

set @C1 = (ABS(Checksum(NewID()) %  @CrewNumberTotal))
set @C2 = (ABS(Checksum(NewID()) %  @CrewNumberTotal))
set @C3 = (ABS(Checksum(NewID()) %  @CrewNumberTotal))
set @date = (
		select dateadd(day, 
               rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
               @FromDate)

)	

Insert into Rocks.dbo.Mission(MissionID,Crew1,Crew2,Crew3,Date) values (@CreateMission,@C1,@C2,@C3,@date)

set @CreateMission = @CreateMission + 1
End

--#############################################################################################################
Declare @TotalNumberOfMissions as int
Declare @NumberOfRocks as int
Declare @SelectRandomMission as int
Declare @PickRandomMoon as int
Declare @RandomMass as int
set @NumberOfRocks = 0
SET @TotalNumberOfMissions = (SELECT * FROM OPENROWSET(BULK 'C:\Project15\missions', SINGLE_CLOB) AS INT)

while (@NumberOfRocks < @TotalNumberOfMissions)
Begin
set @SelectRandomMission = (ABS(Checksum(NewID()) %  @TotalNumberOfMissions))
set @PickRandomMoon = (ABS(Checksum(NewID()) %  124) +1)
set @RandomMass = (ABS(Checksum(NewID()) %  100000) +1)
insert into Rocks.dbo.Rock(RockID,MissionID,MoonID,Mass) values(@NumberOfRocks,@SelectRandomMission,@PickRandomMoon,@RandomMass)
set @NumberOfRocks = @NumberOfRocks +1
end
--#############################################################################################################

Insert into Rocks.dbo.Moon (MoonID,Name) 