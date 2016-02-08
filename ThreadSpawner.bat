echo off
color 44
mode CON: COLS=40 Lines=22
echo *****************************************
echo Working on (%T2%) TRANSACTIONS
echo Window will terminate once they 
echo are done
echo Output: Thread%N%.temp
echo *****************************************

	
	sqlcmd 1> Thread%N%.temp -p -y 0 -v T=%T2% -i P15_TransactionsSwap.sql

taskkill /f /im powershell.exe
exit
