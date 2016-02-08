/************
Written by: Max Enroth
e-mail: maxenrothdk@gmail.com
*/

--SET NOCOUNT ON -- Don't inform me of ROWS affected it's irellevant for this T-SQL
USE Project15 -- USE DATABASE NEEDED FOR dbo.TIL SELECT statement
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

SELECT CASE transaction_isolation_level -- Case Find Trasaction level
WHEN 0 THEN 'Unspecified' -- Start Conversation "Write to user" Sorta :)
WHEN 1 THEN 'ReadUncommitted' 
WHEN 2 THEN 'ReadCommitted' 
WHEN 3 THEN 'Repeatable' 
WHEN 4 THEN 'Serializable' 
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL -- END Case by writing TRASACTION_ISOLATION_LEVEL
FROM sys.dm_exec_sessions -- Access sys.dm_exec_sessions to get current sessions' ISO Level
where session_id = @@SPID -- Where Current session_id (Process ID) is the same as current session ID - Obviously :)