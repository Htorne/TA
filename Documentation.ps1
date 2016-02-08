cls
Write-Host "
Experimentation program
Written by Max Enroth menr@itu.dk 
                        
------------------------------------------------------------------------------------------
 0. Known bugs and Issues
------------------------------------------------------------------------------------------
 0.1   
    Changing the size of the main window will cause issues with the performance
    reporting, and might cause the program / scripts to act in unpredictble ways.
    This is because the program reads from a stream buffer, and changing the size
    of the window changes the values in the stream buffer. 

    If you however need to change the window regardless, do so in line 8 of
    Batchman.bat where it says [mode CON: COLS=120 Lines=300] to whichever
    configuration that suits you. 

    *Note Lowest recommended value for COLS is 90.

 0.2
    Parsing of very large experimental results (+10,000,000 transactions)
    might consume large amounts of system memory. E.g. 2,000,000 transactions
    will consume around 180 MB of system memory.

 0.3
    Warning
    No consideration has been given to, limmiting the size of the workloads,
    which means that if you start 1000 threads with 2 million transactions.
    Your system might freeze for a long long time depending on it's configuration.
 
0.4
    SSD Warning
    Futher more SSD wearing could become an issue with if you run large workloads
    over longer periods of time. As of this writing I've written roughly 6 TB to my
    SSD during the development of this program.  
    The weakest of contempary SSD's should be able to handle roughly 20 TB before
    they starting become an issue to worry about, and high grade consumer SSD's should
    be allright with handling writes in the 100 TB range, before becomming faulty or die. 
0.5
    During experimentation temp files will be created in c:\Project15\Thread1.temp these
    files can become very large depending on the number of transactions and threads.
    10 million transactions roughly equals 100 MB per thread. 
0.6
    Program crashes after experimentation has completed - make sure that your experiment runs for more
    than 2 seconds.  
------------------------------------------------------------------------------------------
 1. Requirements
------------------------------------------------------------------------------------------
1.1
    Windows 8.1 or Windows 10 (Which is free until sometime in 2016). Microsoft SQL 
    Server 2014 with **Service Pack 1**. Minimum 2 GB of
    system RAM, 6 GB or above is strongly recommended. Microsoft .Net Framework 3.5
    and 4.5. Microsoft Power Shell (Included in Windows)
    
------------------------------------------------------------------------------------------
 2. Program Details
------------------------------------------------------------------------------------------
2.1 
    This program / script collection is designed for easy modification
    by utilizing Windows batch scripts, Powershell scripts, C#,
    .NET and finnaly MSSQL scripts. The main entry to the package is in Batchman.bat.

2.2 
    P15 is the standard disk based database
    P15M is an augmented version of P15, that resides as a memory optimized database
    SR is a bigger schema database built for more complex queries.
2.3
    There are various files associated with this program
    File 1. rows (Contains information used by the program, to identify the total number
                  of rows within a given P15 Database)
    File 2. crew     (Same purpose as File 1)
    File 3. missions (Same purpose as File 1)
    File 4. NameList.csv (List of random first and last names for random name generation)
    File 5. MoonList.csv (List of all natural moons in our solar system )
   
    *.ps1 files (Are used to call various .NET and Windows OS API calls, used in parsing, 
                 generation of CSV files, Experimental logging, Performance Logging 
                  and Hardware identification)
    *.bat files (Windows Batch files used to launch and call different T-SQL scripts)
------------------------------------------------------------------------------------------
 3. Experimentation Guide
------------------------------------------------------------------------------------------
3.1
    Transaction based experiment on multiple threads.
    Outputs 4 different files, which are all named in the following way.
    They are by default located in the folder c:\Project15\Tests
    
    DD-MM-YYYY@hour-minute-second
    
    E.g. 29-10-2015@13.4.22 = 29th of October 2015 at 13:04:22

    The files are.
    29-10-2015@13.4.22-CPU.cvs 
    *Contains comma seprated values for use in E.g. Excel
    
    29-10-2015@13.4.22-SystemInfo.txt
    (Contains system and experiment information headlines)
    
    29-10-2015@13.4.22-Parsed.txt 
    *Contains parsed cvs information for use in R or elsewhere
    
    LatestExperiment.txt 
    *Contains the ID of last run experiment DD-MM-YYYY@hour-minute-second
    
    

    "