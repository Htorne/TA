/*You might get a Error called
701	17	103	NULL	9	There is insufficient system memory in resource pool 'default' to run this query.
In most cases this can be ignored, check that the creation went correct and that all 1 million rows have been created
*/

CREATE DATABASE P15M
ON  PRIMARY 
( NAME = N'P15M', FILENAME = 'D:\DatabaseFile\MemoryOptimized.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'P15M_log', FILENAME ='D:\DatabaseLog\MemoryOptimizedLog.ldf' , SIZE = 1280KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
GO
set nocount on
ALTER DATABASE P15M add filegroup P15M_mod CONTAINS MEMORY_OPTIMIZED_DATA
ALTER DATABASE P15M ADD FILE (name='P15M_mod1', filename=N'D:\DATA1-P15M') to filegroup P15M_mod --DATA
ALTER DATABASE P15M ADD FILE (name='P15M_mod2', filename=N'D:\DELTA2-P15M') to filegroup P15M_mod --DELTA
ALTER DATABASE P15M ADD FILE (name='P15M_mod3', filename=N'D:\DATA3-P15M') to filegroup P15M_mod --DATA
ALTER DATABASE P15M ADD FILE (name='P15M_mod4', filename=N'D:\DELTA4-P15M') to filegroup P15M_mod --DELTA
GO
ALTER DATABASE [Project15] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Project15] SET DELAYED_DURABILITY = Disabled  
go
ALTER DATABASE P15M SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT=ON
USE P15M
GO


CREATE TABLE dbo.account
(
accountNo int IDENTITY(1,1) not null, PRIMARY KEY NONCLUSTERED (accountNo), 
branchNo int,
balance float NOT NULL,
) with (MEMORY_OPTIMIZED=on)
GO
DECLARE @counterInt INT
SET @counterInt = 1


WHILE (@counterInt < 5000000)
BEGIN
	
	begin try
	INSERT dbo.account (branchNo,balance)
	VALUES (RAND()*21,RAND()*10001)
	SET @counterInt = @counterInt + 1
	end try
begin catch
    --returns the complete original error message as a result set
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage

    --will return the complete original error message as an error message
    DECLARE @ErrorMessage nvarchar(400), @ErrorNumber int, @ErrorSeverity int, @ErrorState int, @ErrorLine int
    SELECT @ErrorMessage = N'Error %d, Line %d, Message: '+ERROR_MESSAGE(),@ErrorNumber = ERROR_NUMBER(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE(),@ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber,@ErrorLine)
end catch
	
END
GO

UPDATE STATISTICS P15M.dbo.account WITH FULLSCAN, NORECOMPUTE

GO