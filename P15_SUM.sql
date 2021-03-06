USE Project15 -- USE DATABASE NEEDED FOR dbo.TIL SELECT statement
SET NOCOUNT ON -- Don't inform me of ROWS affected it's irellevant for this T-SQL

DECLARE @ISOLEVEL as INT -- Declare @ISOLEVEL 
SET @ISOLEVEL = (SELECT TOP (1) TILS FROM dbo.TIL) --Set the value of @ISOLEVEL to top 1 value of column TILS in TIL tabel

IF @ISOLEVEL = 1 SET TRANSACTION ISOLATION LEVEL Read Uncommitted -- If TOP(1) value of column TILS in dbo.TIL is 1 then... 
ELSE
IF @ISOLEVEL = 2 SET TRANSACTION ISOLATION LEVEL Read Committed -- And so on and on 
ELSE
IF @ISOLEVEL = 3 SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
ELSE
IF @ISOLEVEL = 4 SET TRANSACTION ISOLATION LEVEL Serializable
ELSE
IF @ISOLEVEL = 5 SET TRANSACTION ISOLATION LEVEL Snapshot
ELSE
SET TRANSACTION ISOLATION LEVEL Read Committed -- IF Giberish set MSSQL Default


select sum(cast(balance as bigint)) as TotalValue, branchNo
from dbo.account
group by branchNo
order by TotalValue desc

select sum(cast(balance as bigint)) as TotalValue 
from dbo.account



