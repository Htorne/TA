USE [P15M]
GO
DECLARE @counter as int = 1000000
While (@counter > 0)
Begin

EXEC [dbo].[P15M_WRAPPER]

set @counter = @counter -1
end
GO
