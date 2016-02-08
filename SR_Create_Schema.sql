SET NOCOUNT ON
USE [master]
GO

/****** Object:  Database [Rocks] N'$(W)   Script Date: 12/6/2015 6:25:20 PM ******/
CREATE DATABASE [Rocks]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Rocks', FILENAME = 'd:\DatabaseFile\SpaceRocks.mdf' , SIZE = 6072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Rocks_log', FILENAME = 'd:\DatabaseLog\SpaceRocks._log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [Rocks] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Rocks].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Rocks] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Rocks] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Rocks] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Rocks] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Rocks] SET ARITHABORT OFF 
GO
ALTER DATABASE [Rocks] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Rocks] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Rocks] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Rocks] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Rocks] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Rocks] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Rocks] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Rocks] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Rocks] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Rocks] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Rocks] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Rocks] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Rocks] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Rocks] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Rocks] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Rocks] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Rocks] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Rocks] SET RECOVERY FULL 
GO
ALTER DATABASE [Rocks] SET  MULTI_USER 
GO
ALTER DATABASE [Rocks] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Rocks] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Rocks] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Rocks] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Rocks] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Rocks] SET  READ_WRITE 
GO

USE [Rocks]
GO

SET ANSI_NULLS ON
go
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
go

CREATE TABLE [dbo].[Crew](
	[CrewID] [int] NOT NULL,
	[FirstName] [varchar](50),
	[LastName] [varchar](50) ,
 CONSTRAINT [PK_Crew] PRIMARY KEY CLUSTERED 
(
	[CrewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO


CREATE TABLE [dbo].[Mission](
	[MissionID] [int] NOT NULL,
	[Crew1] [int] NULL,
	[Crew2] [int] NULL,
	[Crew3] [int] NULL,
	[Date] [date] NULL,
 CONSTRAINT [PK_Mission] PRIMARY KEY CLUSTERED 
(
	[MissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Rock](
	[RockID] [int] NOT NULL,
	[MissionID] [int] NOT NULL,
	[MoonID] [int] NOT NULL,
	[Mass] [int] NULL,
 CONSTRAINT [PK_Rock] PRIMARY KEY CLUSTERED 
(
	[RockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]




CREATE TABLE [dbo].[NameList](
	[NameID] [int] NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	
 CONSTRAINT [NameID] PRIMARY KEY CLUSTERED 
(
	[NameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[MoonList](
	[MoonID] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	
	
 CONSTRAINT [MoonID] PRIMARY KEY CLUSTERED 
(
	[MoonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


GO






ALTER TABLE [dbo].[Rock]  WITH CHECK ADD  CONSTRAINT [FK_Rock_Mission] FOREIGN KEY([MissionID])
REFERENCES [dbo].[Mission] ([MissionID])
GO

ALTER TABLE [dbo].[Rock] CHECK CONSTRAINT [FK_Rock_Mission]
GO

ALTER TABLE [dbo].[Rock]  WITH CHECK ADD  CONSTRAINT [FK_Rock_MoonList] FOREIGN KEY([MoonID])
REFERENCES [dbo].[MoonList] ([MoonID])
GO

ALTER TABLE [dbo].[Rock] CHECK CONSTRAINT [FK_Rock_MoonList]
GO



ALTER TABLE [dbo].[Mission]  WITH CHECK ADD  CONSTRAINT [FK_Mission_Crew] FOREIGN KEY([Crew1])
REFERENCES dbo.Crew ([CrewID])
GO

ALTER TABLE [dbo].[Mission] CHECK CONSTRAINT [FK_Mission_Crew]
GO

ALTER TABLE dbo.Mission  WITH CHECK ADD  CONSTRAINT [FK_Mission_Crew1] FOREIGN KEY([Crew2])
REFERENCES dbo.Crew ([CrewID])
GO

ALTER TABLE [dbo].[Mission] CHECK CONSTRAINT [FK_Mission_Crew1]
GO

ALTER TABLE dbo.Mission  WITH CHECK ADD  CONSTRAINT [FK_Mission_Crew2] FOREIGN KEY([Crew3])
REFERENCES dbo.Crew ([CrewID])
GO

ALTER TABLE dbo.Mission CHECK CONSTRAINT [FK_Mission_Crew2]
GO
Use Rocks

Bulk
INSERT [Rocks].[dbo].[NameList]
FROM 'c:\Project15\NameList.csv'
with
(
KEEPIDENTITY,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'

)
Bulk
INSERT [Rocks].[dbo].[MoonList]
FROM 'c:\Project15\MoonList.csv'
with
(
KEEPIDENTITY,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'

)

--########################################200 Crew #####################################################################
Declare @CreateCrew as int
Declare @F1 as varchar(64)
Declare @L1 as varchar(64)
Set @CreateCrew = 0
while (@CreateCrew < N'$(V8)' /*55*/)
Begin
	
	
	Set @F1 =(
	Select FirstName
	From Rocks.dbo.NameList
	Where Rocks.dbo.NameList.NameID = ABS(Checksum(NewID()) % 124) + 1)

	Set @L1 = (
	Select LastName
	From Rocks.dbo.NameList
	Where Rocks.dbo.NameList.NameID = ABS(Checksum(NewID()) % 124) + 1)
	
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

while (@CreateMission <  N'$(V9)' /*55*/ ) --Define number of missions that you want to create
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
go
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


 
    


	


 
    
