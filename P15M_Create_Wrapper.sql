USE [P15M]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P15M_WRAPPER]
AS
BEGIN
DECLARE @retry int = 10
WHILE (@retry > 0)
BEGIN -- Retry logic used with multiple threads to chatch error 41302,41305,41325,41301,1205 
	BEGIN TRY
	exec dbo.P15M_1RUN
	set @retry = 0
	end try
	begin catch
	set @retry = @retry - 1
	IF (@retry > 0 AND error_number() in (41302, 41305, 41325, 41301, 1205))
      BEGIN
 
        IF XACT_STATE() = -1 -- If the transaction state is -1 or not commited wait for delay.
           WAITFOR DELAY '00:00:00.001'
        -- use a delay if there is a high rate of write conflicts (41302)
	  END
	  END CATCH
	  END
	  END
	
GO


