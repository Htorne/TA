color 80
echo off
cls
echo **************************
sqlcmd -o "C:\Project15\%K2%SUMS.txt" -p -v K=%K2% -i P15_SUM_Loop.sql 
echo ####################################
echo       Finished %K2% SUM Operations
echo ####################################
exit
