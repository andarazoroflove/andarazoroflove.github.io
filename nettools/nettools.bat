@ECHO OFF
rem *this is a simple script to allow agents to perform basic internet/network troubleshooting*
rem *without giving them access to the full command.exe or cmd.exe*
rem *this script relies on choice.exe from the Windows 2000 Resource Kit*
rem *if your PC doesn't have it, it will attempt to download it from \\pocpw01\public*

rem *written by Adam McKinney 7.18.06 -- version 1.5*
rem *CHANGELOG*
rem *v 1.0 - Initial Script
rem *v 1.1 - Bug Fixes for EXIT Menu and Removal of CHOICE.exe auto-populated menu
rem *v 1.2 - Added CLS to clear buffer after each command and before return to main menu
rem *v 1.3 - Enhancements to Input area to make it look more like a command prompt
rem *v 1.4 - Enhancement to LIST section, added CLS to blank console before displaying LIST
rem *v 1.5 - Check for CHOICE.EXE in the "." directory - pre self-installing .exe form.
rem *v 1.6 - If your system has wget, download CHOICE.EXE from nettool.andarazoroflove.org
rem *script begins below this line*
rem -------------------------------------------------------------------------------------------

:CHOICECHECK
rem *checking in a few spots for choice.exe*
if exist c:\progra~1\resour~1\choice.exe GOTO LIST
if exist %systemroot%\choice.exe GOTO LIST
if exist .\choice.exe GOTO LIST
if exist %systemroot%\system32\choice.exe GOTO LIST
if not exist %systemroot%\choice.exe GOTO CHOICEINST

:CHOICEINST
rem *wget CHOICE.EXE if system has wget installed
wget http://nettool.andarazoroflove.org/CHOICE.EXE
rem *change this path to download from a local server if desired*
xcopy /Y /Q \\someserver\someshare\choice.exe %systemroot%

:LIST
rem *present a nice menu of network troubleshooting tools to the user*
cls
echo [What Would You Like To Do?]
echo ============================
echo 1: PING an IP address        
echo 2: TRACERT an IP address     
echo 3: NSLOOKUP a URL or IP address    
echo 4: NETSH commands
echo 5: EXIT this Program
echo ============================
choice /c:12345 /N /t:5,30 Press the number of the command you'd like to run [1,2,3,4,5]:
rem *script will default to EXIT after 30 seconds*
IF ERRORLEVEL 5 GOTO EXIT
IF ERRORLEVEL 4 GOTO NETSH
IF ERRORLEVEL 3 GOTO NSLOOKUP
IF ERRORLEVEL 2 GOTO TRACERT
IF ERRORLEVEL 1 GOTO PING

:PING
cls
set ping=
echo [PING Tool]
echo Enter the URL or IP Address to PING at the Command Prompt below:
echo =====================================================================
set /p ping="C:\>ping "
set ping=%ping%
ping %ping%
pause
cls
GOTO LIST

:TRACERT
cls
set tracert=
echo [TRACERT Tool]
echo Enter the URL or IP Address to TRACERT at the Command Prompt below:
echo =====================================================================
set /p tracert="C:\>tracert "
set tracert=%tracert%
tracert %tracert%
pause
cls
GOTO LIST

:NSLOOKUP
cls
set nslookup=
echo [NSLOOKUP Tool]
echo Enter the URL or IP Address to NSLOOKUP at the Command Prompt below:
echo =====================================================================
set /p nslookup="C:\>nslookup "
set nslookup=%nslookup%
nslookup %nslookup%
pause
cls
GOTO LIST

:NETSH
cls
set netsh=
echo [NETSH Tool]
echo Enter the NETSH Command to execute at the Command Prompt below:
echo =====================================================================
set /p netsh="C:\>netsh "
set netsh=%netsh%
netsh %netsh%
pause
cls
GOTO LIST

:EXIT
cls
choice /C:12 /N /t2,10 Are You Sure You're Done? (1 for YES, 2 for NO):
IF ERRORLEVEL 2 GOTO LIST
IF ERRORLEVEL 1 GOTO YES

:YES
EXIT

