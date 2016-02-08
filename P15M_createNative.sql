
USE [P15M]
GO
CREATE PROC P15M_1RUN
WITH NATIVE_COMPILATION,SCHEMABINDING,EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH
( TRANSACTION ISOLATION LEVEL = REPEATABLE READ, LANGUAGE = N'us_english')
DECLARE @@A1 as int, @@A2 as int,@@V1 as float, @@V2 as float
 
						         
		BEGIN
			SET @@A1 = (RAND()*5000001)                                         
			SET @@A2 = (RAND()*5000001)									
					
	SELECT accountNo
	FROM dbo.account
	where (accountNo = @@A1)


	SELECT @@V1 = balance 
			FROM dbo.account 
			WHERE accountNo = @@A1
							                     
	SELECT accountNo
	FROM dbo.account
	where (accountNo = @@A2)

	SELECT @@V2 = balance
			FROM dbo.account
			WHERE accountNo = @@A2

	UPDATE dbo.account
	SET balance = @@V1 where accountNo = @@A2

	UPDATE dbo.account
	SET balance = @@V2 where accountNo = @@A1 
END
END
GO
