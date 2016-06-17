@ECHO OFF
rem *this was a simple script to allow agents to perform basic internet/network troubleshooting*
rem *without giving them access to the full command.exe or cmd.exe*

SET nettoolsver=2.0.1
SET builddate=8.22.2006

rem *written by Adam McKinney 8.21.06 -- version 2.0.1*
rem *CHANGELOG*
rem *v 1.0 - Initial Script
rem *v 1.1 - Bug Fixes for EXIT Menu and Removal of CHOICE.exe auto-populated menu
rem *v 1.2 - Added CLS to clear buffer after each command and before return to main menu
rem *v 1.3 - Enhancements to Input area to make it look more like a command prompt
rem *v 1.4 - Enhancement to LIST section, added CLS to blank console before displaying LIST
rem *v 1.5 - Check for CHOICE.EXE in the "." directory - pre self-installing .exe form
rem *v 1.6 - If your system has wget, download CHOICE.EXE from nettool.andarazoroflove.org
rem *v 1.7 - Script no longer requires CHOICE.EXE
rem *v 2.0 - MANY CHANGES have bumped the version number up!
rem				*script is now in COLOR!!
rem				*script no longer requires any additional programs to run
rem				*security loophole created by piped commands is no longer present
rem				*script creates .com object in assembler to handle stripping of | commands
rem				*script creates and executes portions in Windows Scripting Host allowing for
rem				 flexibility and the ability to analyze user input prior to running commands
rem				*script now contains an HELP section which explains the tools and their syntax
rem				*working sections of the script are now only commented once--comments apply throughout
rem *v 2.0.1 Small enhancements to color and script flow corrected. Help system is completed.
rem *code begins below this line*
rem -------------------------------------------------------------------------------------------

rem *create a .com object which can search and replace the | pipe character - it's a no no.
@echo Bj@jzh`0X-`/PPPPPPa(DE(DM(DO(Dh(Ls(Lu(LX(LeZRR]EEEUYRX2Dx=> %temp%\pipeclean.com
@echo 0DxFP,0Xx.t0P,=XtGsB4o@$?PIyU!WvX0GwUY Wv;ovBX2Gv0ExGIuht6>> %temp%\pipeclean.com
@echo ?@}IKuNWpe~Fpe?FNHlF?wGMECIQqo{Ox{T?kPv@jeoSeIlRFD@{AyEKj@>> %temp%\pipeclean.com
@echo iqe~1NeAyR?mHAG~BGRgB{~H?o~TsdgCYqe?HR~upkpBG?~slJBCyA?@xA>> %temp%\pipeclean.com
@echo LZp{xq`Cs?H[C_vHDyB?Hos@QslFA@wQ~~x}viH}`LYNBGyA?@xAB?sUq`>> %temp%\pipeclean.com
@echo LRy@PwtCYQEuFK@A~BxPtDss@fFqjVmzD@qBEOEenU?`eHHeBCMs?FExep>> %temp%\pipeclean.com
@echo LHsPBGyA?@xAunjzA}EKNs@CA?wQpQpKLBHv?s`WJ`LRCYyIWMJaejCksl>> %temp%\pipeclean.com
@echo H[GyFGhHBwHZjjHeoFasuFUJeHeB?OsQH[xeHCPvqFj@oq@eNc?~}Nu??O>> %temp%\pipeclean.com
@echo ~oEwoAjBKs?Zp`LBzHQzyEFrAWAG{EFrAqAGYwHTECIQ{coKIsaCsf{Oe~>> %temp%\pipeclean.com
@echo CK}Ayre~CNFA{rAyEKFACrA{EKGAjbA}eKGSjNMtQFtc{OAyDGFj?{FDGQ>> %temp%\pipeclean.com
@echo KAjNVk_OCAx@e?f{o?CosI}1EGizhljJ~H1ZeG}JBA~rACBMDGjjDG@g0>> %temp%\pipeclean.com

:LIST
rem *present a nice menu of network troubleshooting tools to the user*
cls
color 1F
echo [nettools Main Menu -- What Would You Like To Do?]
echo =====================================================================
echo 1: PING an IP address        
echo 2: TRACERT an IP address     
echo 3: NSLOOKUP a URL or IP address    
echo 4: NETSH commands
echo 5: EXIT this Program
echo 6: Get HELP With This Program
echo =====================================================================
set choice=
set /p choice="Press the number of the command you'd like to run [1,2,3,4,5,6]:"
if '%choice%'=='1' goto PING
if '%choice%'=='2' goto TRACERT
if '%choice%'=='3' goto NSLOOKUP
if '%choice%'=='4' goto NETSH
if '%choice%'=='5' goto EXIT
if "%choice%"=="6" goto HELP

:PING
cls
set ping=
rem * create a dummy file to give the erase command something to delete to make sure the .vbs is gone
echo TESTPING > %temp%\npingt.txt
@erase /F /Q %temp%\nping*.*
rem * create a wsh .vbs to accept input and write a temporary file containing the user's input
@echo Dim FSO, objFile, RegEx, strDestin, strSource > %temp%\npingin.vbs
@echo Set FSO = CreateObject("Scripting.FileSystemObject") >>%temp%\npingin.vbs
@echo Set RegEx = New RegExp >>%temp%\npingin.vbs
@echo RegEx.Global = True >>%temp%\npingin.vbs
@echo RegEx.Pattern = "[ ]{2,}" >>%temp%\npingin.vbs
@echo Const ForReading = 1 >>%temp%\npingin.vbs
@echo strSource = Wscript.StdIn.ReadLine >>%temp%\npingin.vbs
@echo strDestin = "%temp%\npingin.txt" >>%temp%\npingin.vbs
@echo Set objFile = FSO.CreateTextFile(strDestin, True) >>%temp%\npingin.vbs
@echo objFile.Write strSource >>%temp%\npingin.vbs
@echo objFile.Close >>%temp%\npingin.vbs
rem * present the user with some text explaining what we're doing
echo [PING Tool]
echo Enter the URL or IP Address to PING:
echo =====================================================================

cscript.exe //NoLogo //B %temp%\npingin.vbs 

%temp%\pipeclean.com 0 "|" "ILLEGAL.SYNTAX-PIPED.COMMANDS.ARE.NOT.AVAILABLE!" < %temp%\npingin.txt > %temp%\npingclean.txt
set /p ping=<%temp%\npingclean.txt
ping %ping%
pause
@erase /F /Q %temp%\nping*.*
cls
GOTO LIST

:TRACERT
cls
set tracert=
echo TESTTRACERT > %temp%\ntracertt.txt
@erase /F /Q %temp%\ntr*.*
@echo Dim FSO, objFile, RegEx, strDestin, strSource > %temp%\ntracert.vbs
@echo Set FSO = CreateObject("Scripting.FileSystemObject") >>%temp%\ntracert.vbs
@echo Set RegEx = New RegExp >>%temp%\ntracert.vbs
@echo RegEx.Global = True >>%temp%\ntracert.vbs
@echo RegEx.Pattern = "[ ]{2,}" >>%temp%\ntracert.vbs
@echo Const ForReading = 1 >>%temp%\ntracert.vbs
@echo strSource = Wscript.StdIn.ReadLine >>%temp%\ntracert.vbs
@echo strDestin = "%temp%\ntracert.txt" >>%temp%\ntracert.vbs
@echo Set objFile = FSO.CreateTextFile(strDestin, True) >>%temp%\ntracert.vbs
@echo objFile.Write strSource >>%temp%\ntracert.vbs
@echo objFile.Close >>%temp%\ntracert.vbs
echo [TRACERT Tool]
echo Enter the URL or IP Address to TRACERT below:
echo =====================================================================
cscript.exe //NoLogo //B %temp%\ntracert.vbs 
%temp%\pipeclean.com 0 "|" "ILLEGAL.SYNTAX-PIPED.COMMANDS.ARE.NOT.AVAILABLE!" < %temp%\ntracert.txt > %temp%\ntrclean.txt
set /p tracert=<%temp%\ntrclean.txt
tracert %tracert%
pause
@erase /F /Q %temp%\ntr*.*
cls
GOTO LIST

:NSLOOKUP
cls
set nslookup=
echo TESTNSLOOKUP > %temp%\nslookt.txt
@erase /F /Q %temp%\nsl*.*
@echo Dim FSO, objFile, RegEx, strDestin, strSource > %temp%\nslook.vbs
@echo Set FSO = CreateObject("Scripting.FileSystemObject") >>%temp%\nslook.vbs
@echo Set RegEx = New RegExp >>%temp%\nslook.vbs
@echo RegEx.Global = True >>%temp%\nslook.vbs
@echo RegEx.Pattern = "[ ]{2,}" >>%temp%\nslook.vbs
@echo Const ForReading = 1 >>%temp%\ntslook.vbs
@echo strSource = Wscript.StdIn.ReadLine >>%temp%\nslook.vbs
@echo strDestin = "%temp%\nslook.txt" >>%temp%\nslook.vbs
@echo Set objFile = FSO.CreateTextFile(strDestin, True) >>%temp%\nslook.vbs
@echo objFile.Write strSource >>%temp%\nslook.vbs
@echo objFile.Close >>%temp%\nslook.vbs
echo [NSLOOKUP Tool]
echo Enter the URL or IP Address to NSLOOKUP below:
echo =====================================================================
cscript.exe //NoLogo //B %temp%\nslook.vbs
%temp%\pipeclean.com 0 "|" "ILLEGAL.SYNTAX-PIPED.COMMANDS.ARE.NOT.AVAILABLE!" < %temp%\nslook.txt > %temp%\nslclean.txt
set /p nslookup=<%temp%\nslclean.txt
nslookup %nslookup%
pause
@erase /F /Q %temp%\nsl*.*
cls
GOTO LIST

:NETSH
cls
set netsh=
echo TESTNETSH > %temp%\nnetsh.txt
@erase /F /Q %temp%\nne*.*
@echo Dim FSO, objFile, RegEx, strDestin, strSource > %temp%\nnetsh.vbs
@echo Set FSO = CreateObject("Scripting.FileSystemObject") >>%temp%\nnetsh.vbs
@echo Set RegEx = New RegExp >>%temp%\nnetsh.vbs
@echo RegEx.Global = True >>%temp%\nnetsh.vbs
@echo RegEx.Pattern = "[ ]{2,}" >>%temp%\nnetsh.vbs
@echo Const ForReading = 1 >>%temp%\nnetsh.vbs
@echo strSource = Wscript.StdIn.ReadLine >>%temp%\nnetsh.vbs
@echo strDestin = "%temp%\nnetsh.txt" >>%temp%\nnetsh.vbs
@echo Set objFile = FSO.CreateTextFile(strDestin, True) >>%temp%\nnetsh.vbs
@echo objFile.Write strSource >>%temp%\nnetsh.vbs
@echo objFile.Close >>%temp%\nnetsh.vbs
echo [NETSH Tool]
echo Enter the NETSH Command to execute below:
echo (when finished, exit netsh> by typing quit and pressing enter)
echo =====================================================================
cscript.exe //NoLogo //B %temp%\nnetsh.vbs
%temp%\pipeclean.com 0 "|" "ILLEGAL.SYNTAX-PIPED.COMMANDS.ARE.NOT.AVAILABLE!" < %temp%\nnetsh.txt > %temp%\nneclean.txt
set /p nslookup=<%temp%\nneclean.txt
netsh %netsh%
pause
@erase /F /Q %temp%\nne*.*
cls
GOTO LIST

rem *Integrated Help System - New as of v2.0!
:HELP
cls
color 1E
echo [Welcome to the nettools Integrated Help System]
echo =====================================================================
echo 1: Show Me an Example of what the Command Line looks like.
echo 2: Show Me the Syntax and Options for PING
echo 3: Show Me the Syntax and Options for TRACERT
echo 4: Show Me the Syntax and Options for NSLOOKUP
echo 5: Show Me the Syntax and Options for NETSH
echo 6: About nettools
echo 7: Back to the Main Menu
echo =====================================================================
set /p choice="Press the number of the Help Item you'd like to see [1,2,3,4,5,6,7]:"
if '%choice%'=='1' goto HELP1
if '%choice%'=='2' goto HELP2
if '%choice%'=='3' goto HELP3
if '%choice%'=='4' goto HELP4
if '%choice%'=='5' goto HELP5
if '%choice%'=='6' goto ABOUT
if '%choice%'=='7' goto LIST

:HELP1
cls
@echo The Command Line or Command Prompt looks like this: > %temp%\cmdhlp.txt
@echo "C:\>" >> %temp%\cmdhlp.txt
@echo The Command Prompt is started by clicking the Start Menu, choosing Run >> %temp%\cmdhlp.txt
@echo and typing either "CMD" or "COMMAND", then pressing OK. >> %temp%\cmdhlp.txt
@echo - >> %temp%\cmdhlp.txt
@echo When troubleshooting a customer issue, it may be necessary to >> %temp%\cmdhlp.txt
@echo have the customer type the commands in manually at the prompt like: >> %temp%\cmdhlp.txt
@echo "C:\>ping" >> %temp%\cmdhlp.txt
@echo "C:\>tracert" >> %temp%\cmdhlp.txt
@echo "C:\>netsh" >> %temp%\cmdhlp.txt
type %temp%\cmdhlp.txt
pause
@del %temp%\cmdhlp.txt
goto HELP

:HELP2
cls
ping /? > %temp%\npingprt.txt
type %temp%\npingprt.txt
pause
@del %temp%\npingprt.txt
goto HELP

:HELP3
cls
tracert /? > %temp%\ntraceprt.txt
type %temp%\ntraceprt.txt
pause
@del %temp%\ntraceprt.txt
goto HELP

:HELP4
cls 
@echo Syntax: "nslookup [-SubCommand ...] [{ComputerToFind| [-Server]}]" > %temp%\nslookhlp.txt
@echo - >> %temp%\nslookhlp.txt
@echo SubCommand :Specifies one or more nslookup subcommands as a command-line option. >> %temp%\nslookhlp.txt
@echo ComputerToFind : Looks up information for ComputerToFind using the current >> %temp%\nslookhlp.txt
@echo default DNS name server, if no other server is specified.  >> %temp%\nslookhlp.txt
@echo To look up a computer not in the current DNS domain, append a period to the name >> %temp%\nslookhlp.txt
@echo You can get a list of SubCommands and what they do by typing HELP or ? from >> %temp%\nslookhlp.txt
@echo the NSLOOKUP Prompt. >> %temp%\nslookhlp.txt
@echo - >> %temp%\nslookhlp.txt
@echo To leave the NSLOOKUP Prompt type, EXIT. >> %temp%\nslookhlp.txt
type %temp%\nslookhlp.txt
pause
@del %temp%\nslookhlp.txt
goto HELP

:HELP5
cls
netsh /? >%temp%\netshhlp.txt
type %temp%\netshhlp.txt |more
pause
@del %temp%\netshhlp.txt
goto HELP

:ABOUT
cls
color 0C
echo ==============================
echo nettools version:
@echo %nettoolsver%
echo compiled on:
@echo %builddate%
echo (c)2006 Adam McKinney
echo ==============================
pause
GOTO LIST

*rem *END of Integrated Help System.

:EXIT
cls
color 1D
set /p choice="Are You Sure You're Done? [Press 1 for Yes, Press 2 for No]:"
if '%choice%'=='1' goto YES
if '%choice%'=='2' goto LIST

:YES
cls
@del %temp%\pipeclean.com
EXIT

