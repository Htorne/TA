:: Written by: Max Enroth
:: E-mail: maxenrothdk@gmail.com
:: **********************************
:: Part of Project15
:: **********************************
:: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:: %%% PROGRAM MUST BE EXECUTED FROM C:\Project15\ %%%%
:: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unblock-file *.ps1
setlocal enableextensions enabledelayedexpansion
mode CON: COLS=90 Lines=80000
:: Adjust mode COLS 
echo off 
prompt SQL-Work :
cls
color 97
Title Database Experimenter P15
	:: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	:: Change this part to your local environment - It should be the location
	:: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	:: %%%%% Variables in use
	:: %%%%% M (Used in menu) Has the /P switch
	:: %%%%% E (Used in experiments) 
	:: %%%%% K (Used for loops)
	:: %%%%% B (Used in Isolation Level selection)
	:: %%%%% N (Used in number of Threads)
	:: %%%%% T2 (Used in number of Threads)
	:: %%%%% K2 (Used in number of sumations)
	:: %%%%% Q (Used in Database Restore)
	:: %%%%% T (Used in number of Transactions)
	:: %%%%% D (Used in Drive Selection in conjunction with a powershell script)
	echo *********************************
	echo *** Database Experimenter P15 ***
	echo ***   MSSQL 2014 Enterprise   ***   
	echo ***      version only         ***
	echo *********************************
	echo Please make your selection
	echo -
	ECHO (1) [Database Creation]
	ECHO (2) [Experiments]
	ECHO (3) [Database Settings]
	ECHO (8) [Documentation]
	ECHO (9) [Exit]
	@SET /a K=0
	SET /P M=Make your selection: 
		if %M%==1 GOTO DatabaseSetup
		if %M%==2 GOTO Experiments
		if %M%==3 GOTO Settings
		if %M%==8 GOTO Documentation
		if %M%==9 GOTO QUIT
**********************************
:Settings
	cls
	echo ------------------------------------------------------------
	echo Please select Executionpolicy Unrestricted if you wish
	echo to gather performance information.
	echo ------------------------------------------------------------
	echo (1) Show connected Harddrives
	echo (2) Set Isolation level for P15
	echo (3) Show current Isolation level fpr P15
	echo (9) Return to Main menu  
	SET /P E= Enter (1-9):
	if %E%==1 Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveModels.ps1
	if %E%==2 goto ISOLATION
	if %E%==3 goto CURRENT-ISOLATION-LEVEL
	if %E%==9 batchman.bat
	pause
	goto Settings
:Documentation
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\Documentation.ps1

	pause
	batchman.bat 
:ISOLATION
	cls
	ECHO Select Transaction Level (1-6)
	ECHO (1) Read Uncommitted
	ECHO (2) Read Committed
	ECHO (3) Repeatable Read
	ECHO (4) Serializable
	ECHO (5) Snapshot
	SET /P B= Enter (1-5)
	sqlcmd -v B=%B% -i P15_SetIsoLevel.sql
	pause
	Batchman.bat
:TRANSACTIONS
	cls
	ECHO ------------------------------------------------------------------
	ECHO P15(Traditional DB) P15M(Memory Optimized DB) P15C(Columnstore DB)
	ECHO ------------------------------------------------------------------
	ECHO (1) P15  Multiple Thread Transactions
	ECHO (2) P15  Multiple Thread Transactions with summations on accounts
	ECHO (3) P15M Multiple Thread Transactions
	ECHO (9) Return to previous menu
	ECHO ------------------------------------------------------------------
	ECHO Select your Experiment
	SET /P E= Enter (1-9):
		if %E%==1 GOTO ExperimentA
		if %E%==2 GOTO ExperimentB
		if %E%==3 GOTO ExperimentC
		if %E%==9 GOTO experiments
	Batchman.bat
:ExperimentA
	cls
	ECHO ##########################
	ECHO   N = Number of Threads
	ECHO   T = Number of swarps (1 swarp equals 2 transactions)
	ECHO ##########################
	SET /P N= Enter number of Threads you wish to run [N]=
	SET /P T2= Enter number of Swarps per Thread you wish to run[T]=
    ECHO -  
	:: Edit here if you wish to Change
	:: the lower limmit for amount of transactions possible
	:: in an experiment
		
	if %N% GTR 25 (
		cls
		ECHO ###### WARNING #####
		ECHO Are you sure you want to start %N% threads,
		ECHO you might experience system issues if your
		ECHO system can't handle %N% threads?
		ECHO ###### WARNING #####
		SET /P !Q!=[Y]/[N]:
			if !Q!==N GOTO TRANSACTIONS
			if !Q!==n GOTO TRANSACTIONS
		)
	

	
	if %T2% LSS 0 (
	::Cokkie
		ECHO Less than 10,000 transactions are not going to provide anything
		ECHO useful information please try again.
		ECHO If you disagree with this change the code in Batchman.bat
		ECHO search for Cokkie to find code bit.
		pause
		goto ExperimentA
		)
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveModels.ps1
	SET /P D= Enter Drive number for current drive[ X]=
	start Bench.bat
	ECHO Starting performance monitor data collector
	timeout 4
	
	

	GOTO WHILELOOP

:WHILELOOP
		if %K% EQU 1 (
		SET /a K = 0
		START "SumSpawner" SumSpawner.Bat
		

			)
			if %N% GTR 0 (
			START "ThreadSpawner" ThreadSpawner.bat 
			@SET /a N =N-1
			echo. 1>Thread%N%.temp
			goto WHILELOOP
			)
			::cls
			Echo Press a key to see CPU performance
			pause
			Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\Grapher.ps1
			pause	
			goto Experiments

				:WHILELOOP2
				if %K% EQU 1 (
				SET /a K = 0
				START "SumSpawner" MEMSumSpawner.Bat
				)
					if %N% GTR 0 ( 
					START "ThreadSpawner" MEMThreadSpawner.bat 
					@SET /a N =N-1
					goto WHILELOOP
					)
					pause
					Batchman.bat
:WHILELOOPInMEM
	if %N% GTR 0 ( 
			START "InmemThreadSpawner" InmemThreadSpawner.bat 
			@SET /a N =N-1
			echo. 1>Thread%N%.temp
			goto WHILELOOPInMEM
			)
			cls
			Echo Press a key to see CPU performance
			pause
			Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\Grapher.ps1	
			pause
			GOTO Experiments				
:ExperimentB
	cls
	ECHO ##########################
	ECHO   N = Number of Threads
	ECHO   T = Number of Transactions
	ECHO   K = Number of SUM Transactions
	ECHO ##########################
	@SET /P N= Enter number of Threads you wish to run [N]=
	SET /P T2= Enter number of Transactions per Thread you wish to run [T]=
	SET /P K2= Enter the number of SUM Transactions you want [K]= 
	@SET /a K=1
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveModels.ps1
	SET /P D= Enter Drive number for current drive[ X]=
	START Bench.bat
	timeout 3
	GOTO WHILELOOP
:ExperimentC
	cls
	ECHO ####### IN MEMORY DATABASE ###################
    ECHO (1) USE P15M (5 Million Rows - 4 Filestream Files) 

    ECHO (9) Return to previous menu
    SET /p E= Enter (1-9):
    	if %E%==1 GOTO P15M
    	if %E%==9 GOTO TRANSACTIONS
:P15M
	cls
	ECHO ####### IN MEMORY DATABASE ###################
	ECHO DB    : P15M (5,000,000) ROWS
	ECHO       : 1,000,000 Transactions per Thread
	ECHO ##############################################
	SET /P N= Enter number of Threads you wish to run [N]=
	if %N% GTR 25 (
		cls
		ECHO ###### WARNING #####
		ECHO Are you sure you want to start %N% threads,
		ECHO you might experience system issues if your
		ECHO system can't handle %N% threads?
		ECHO ###### WARNING #####
		SET /P @J=[Y]/[N]:
			if @J =="N" GOTO TRANSACTIONS
			if @J =="n" GOTO TRANSACTIONS
		)
	start Bench.bat
	ECHO Starting performance monitor data collector
	timeout 2
	GOTO WHILELOOPInMEM

:RESTORE
	cls
	ECHO ###################################
	ECHO ###          WARNING            ###
	ECHO ###                             ###
	ECHO ###  You are about to drop      ###
	ECHO ###  current database and       ###
	ECHO ###  create a new database      ###
	ECHO ###                             ###
	ECHO ###                             ###
	ECHO ################################### 
	ECHO NB: This might fail if you do not run 
	ECHO     this as Administartor  
	SET /P Q=Type (Y)/(N):
	if %Q%==y GOTO RESTOREYES
	if %Q%==Y GOTO RESTOREYES
	if %Q%==N GOTO RESTORENO
	if %Q%==n GOTO RESTORENO
:RESTOREYES
	cls
	ECHO ####################################
	ECHO Please enter on which partition
	ECHO you wish the DATABASE FILE to be 
	ECHO created. 
	ECHO Please type the path using semicolon
	ECHO E.g. D:
	ECHO ###################################
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveLogicalNames.ps1
	SET /P W= Enter Path=
	ECHO ####################################
	ECHO Please enter on which partition
	ECHO you wish the DATABASE LOG to be 
	ECHO created. 
	ECHO Please type the path using semicolon
	ECHO E.g. D:
	ECHO ###################################
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveLogicalNames.ps1
	SET /P W2= Enter Path=
	pause
	ECHO Please enter the number of rows you want in your tabel
	SET /P R= Rows = 
	echo %W%\DatabaseFile
	mkdir %W%\DatabaseFile
	mkdir %W2%\DatabaseLog
	pause
	sqlcmd -m 1 -i P15_DROP.sql 
	echo Database Project15 DROPED
	echo LOG Project15_log DROPED
	echo --------------------------------
	echo press a key to create a new database
	pause
	echo Attempting to Create new Database
	sqlcmd -m 1 -i P15_CreateDatabaseAndPopulate.sql
	echo -
	echo DATABASE Project15 Created and Populated
	echo With %R% rows over 20 branches
	echo|set /p=%R%>rows
	pause
	Batchman.bat	
:RESTORENO
	echo You pressed NO
	pause
	goto DatabaseSetup
:DatabaseSetup
	cls
	echo Select Database
	echo *********************
	echo (1) P15  (Diskbased Database)
	echo (2) P15M (In Memory Database)
	echo (3) Space Rocks (Traditional Relelational Database)
	echo (9) Return to Main menu

	SET /P M=Make your selection: 
		if %M%==1 GOTO P15
		if %M%==2 GOTO P15M
		if %M%==3 GOTO SR
		if %M%==9 Batchman.bat
	pause
	Batchman.bat

::SR is the Space Rocks Database
:SR
	cls
	echo Space Rocks Database Setup
	echo *********************
	echo (1) Create New Space Rocks DatabaseSetup
	echo (2) Drop existing Space Rocks DatabaseSetup
	echo (9) Return

	SET /P M=Make your selection:
		if %M%==1 GOTO SR_Create
		if %M%==2 GOTO SR_Drop
		if %M%==9 Batchman.bat
:SR_Create
	cls
	ECHO ####################################
	ECHO Please enter on which partition
	ECHO you wish the DATABASE FILE to be 
	ECHO created. 
	ECHO Please type the path using semicolon
	ECHO E.g. D:
	ECHO ###################################
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveLogicalNames.ps1
	SET /P W= Enter Path=
	ECHO ####################################
	ECHO Please enter on which partition
	ECHO you wish the DATABASE LOG to be 
	ECHO created. 
	ECHO Please type the path using semicolon
	ECHO E.g. D:
	ECHO ###################################
	Powershell.exe -executionpolicy Unrestricted -File  C:\Project15\ShowDiskDriveLogicalNames.ps1
	SET /P W2= Enter Path=
	mkdir %W%DatabaseFile
	mkdir %W2%DatabaseLog
	ECHO Enter the total number of CrewMembers you want
	ECHO with a minimum of 3 CrewMembers
	SET /P V8= CrewMembers = 
	echo|set /p=%V8%>crew
	ECHO Now enter total number of Missions you want
	ECHO Recomended above 100
	SET /P V9= Missions = 
	echo|set /p=%V9%>missions
	cls
	ECHO Attempting to Create new Database
	sqlcmd -m 1 -i SR_Create_Schema.sql
	Pause
	batchman.bat
:SR_Drop
	echo Dropping Space Rocks Database 
	echo Press [Ctrl+Z] to abort
	pause
	sqlcmd -m 1 -i SR_DROP.sql 
	echo Database DROPED
	pause
	batchman.bat
:P15
	cls
	echo P15 Database Setup
	echo *********************
	echo (1) Create and Drop P15
	echo (9) Return

	SET /P M=Make your selection:
		if %M%==1 GOTO RESTORE
		if %M%==9 Batchman.bat
		pause
		Batchman.bat 
:P15M
	cls
	echo P15M Database Setup
	echo *********************
	echo (1) Create P15M
	echo (9) Return

	SET /P M=Make your selection:
		if %M%==1 GOTO P15M_Create
		if %M%==9 Batchman.bat
		pause
		Batchman.bat 
:P15M_Create
	cls
	echo **********************************
	echo Creating Memory Optimized Database
	echo **********************************
	ECHO (1) Create P15M with 5,000,000 rows (4 Filestream)
	ECHO (9) Return
	SET /P R= Select a option: 
	if %R%==1 GOTO P15M

	if %R%==9 GOTO DatabaseSetup
	goto Batchman
:P15M
	cls
	echo **********************************
	echo Creating Memory Optimized Database
	echo P15M
	echo Rows 5,000,000  
	echo 4 Filestream (Data + Delta)
	echo Delayed Durability DISABLED by Default
	echo ****** NOTICE ********************
	echo Default Location in D:\DatabaseFile\
	echo To change this, edit Line 8 and 10 
	echo In P15M-CreateAccountAndPopulate.sql
	echo **********************************
	ECHO (1) Create P15M
	ECHO (9) Return
	SET /P R= Select a option: 
	if %R%==1 GOTO P15MCreate
	if %R%==9 GOTO DatabaseSetup
	GOTO DatabaseSetup
:P15MCreate
	cls
	echo *********** NOTICE ****************
	echo Press a Key to start creating Database P15M
	pause
	echo Attempting to create new database
	Echo Takes from 5min to 10min depending on system
	sqlcmd -m 1 -i P15M-CreateAccountAndPopulate.sql
	echo Attempting to create natively complied procedures
	sqlcmd -m 1 -i P15M_createNative.sql
	echo Attempting to create SQL-T wrapper
	sqlcmd -m 1 -i P15M_Create_Wrapper.sql
	echo Done
	pause
	Batchman.bat

:Experiments
	cls
	echo Experiments
	echo ****************
	echo (1) Transaction based Experiments
	echo (2) Show values in Database P15 Ordered by branches
	echo (8) Open Experiments folder
	echo (9) Retun to main menu

	set /P M=Make your selection:
		if %M%==1 goto TRANSACTIONS
		if %M%==2 goto TotalBalance 
		if %M%==8 goto ExploreFolder
		if %M%==9 batchman

	pause
:ExploreFolder
	explorer c:\Project15\Tests
	goto Experiments
:TotalBalance
	cls
	sqlcmd -m 1 -p -i P15_SUM.sql
	pause
	goto experiments
:CURRENT-ISOLATION-LEVEL
	cls
	sqlcmd -i P15_GetIsolationLevel.sql
	pause
	goto DatabaseSetup
:QUIT
	prompt
	cls


