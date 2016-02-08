
SET NOCOUNT ON
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
use Project15
DECLARE @rowNumber as varchar(MAX)
DECLARE @ISOLEVEL as INT

SET @ISOLEVEL = (SELECT TOP (1) TILS FROM dbo.TIL)

IF @ISOLEVEL = 1 SET TRANSACTION ISOLATION LEVEL Read Uncommitted
ELSE
IF @ISOLEVEL = 2 SET TRANSACTION ISOLATION LEVEL Read Committed
ELSE
IF @ISOLEVEL = 3 SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
ELSE
IF @ISOLEVEL = 4 SET TRANSACTION ISOLATION LEVEL Serializable
ELSE
IF @ISOLEVEL = 5 SET TRANSACTION ISOLATION LEVEL Snapshot
ELSE
SET TRANSACTION ISOLATION LEVEL Read Committed


SET @rowNumber = (SELECT * FROM OPENROWSET(BULK 'C:\Project15\rows', SINGLE_CLOB) AS INT)


SELECT CASE transaction_isolation_level 
WHEN 0 THEN 'Unspecified' 
WHEN 1 THEN 'ReadUncommitted' 
WHEN 2 THEN 'ReadCommitted' 
WHEN 3 THEN 'Repeatable' 
WHEN 4 THEN 'Serializable' 
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL 
FROM sys.dm_exec_sessions 
where session_id = @@SPID




DECLARE @@A1 as int, @@A2 as int,@@V1 as float, @@V2 as float
DECLARE @N as int												
DECLARE @counter as int
DECLARE @BUFF as int 
SET @counter = 0 -- Don't Change.

WHILE (@counter <  N'$(T)')										 -- Cast Nvar to Int (Takes Input from CMD console)
							         
BEGIN
SET @@A1 = floor((RAND()*@rowNumber))+1                                       -- Get random Account Number in the range 1-100,000.      
SET @@A2 = floor((RAND()*@rowNumber))+1																-- Start While Loop				    
 
if @@A2 > @@A1	
BEGIN									                 		-- Check to see if the same account has been selected twice                                                            
SET @BUFF = @@A2 
SET @@A2 = @@A1 
SET @@A1 = @BUFF 
END


BEGIN TRAN A1A2V1V2
				
SELECT accountNo      
FROM dbo.account
where (accountNo = @@A1)

SET @@V1 = (SELECT balance 
			FROM dbo.account 
			WHERE accountNo = @@A1)	
						                     
SELECT accountNo
FROM dbo.account
where (accountNo = @@A2)
SET @@V2 = (SELECT balance
			FROM dbo.account
			WHERE accountNo = @@A2)

/*Begin Try*/ 
UPDATE dbo.account
SET balance = @@V1 where accountNo = @@A2

UPDATE dbo.account
SET balance = @@V2 where accountNo = @@A1
--WAITFOR DELAY '00:00:00:002'  --(When enabled correctness ratio goes down)
/*end try
begin catch
rollback transaction 
return
end catch
*/
--WAITFOR DELAY '00:00:00:500'
COMMIT TRAN A1A2V1V2 


SET @counter = @counter + 1 


END
