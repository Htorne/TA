echo off
color 44
mode CON: COLS=40 Lines=12
cls



echo *****************************************
echo Working on 1,000,000 TRANSACTIONS
echo To change this edit line 3 in 
echo P15M_Run_Wrapper.sql
echo -------------------------------------
echo Window will terminate once they 
echo are done
echo Output: Thread%N%.temp
echo *****************************************
if %E% EQU 1 (sqlcmd 1> Thread%N%.temp -p -y 0 -i P15M_Run_Wrapper.sql)
taskkill /f /im powershell.exe
exit
::RETRY LOGIC
