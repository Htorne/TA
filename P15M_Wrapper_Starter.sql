USE [P15M2M]
GO
DECLARE @counter as int = 100000
While (@counter > 0)
Begin

EXEC [dbo].[P15M_WRAPPER]

set @counter = @counter -1
end
GO
