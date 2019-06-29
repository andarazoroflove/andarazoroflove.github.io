@ECHO OFF
rem *this is a simple script to allow agents to perform basic internet/network troubleshooting*
rem *without giving them access to the full command.exe or cmd.exe*
rem *this script relies on choice.exe from the Windows 2000 Resource Kit*
rem *if your PC doesn't have it, it will attempt to download it from \\pocpw01\public*

rem *written by Adam McKinney 7.18.06 -- version 1.7*
rem *CHANGELOG*
rem *v 1.0 - Initial Script
rem *v 1.1 - Bug Fixes for EXIT Menu and Removal of CHOICE.exe auto-populated menu
rem *v 1.2 - Added CLS to clear buffer after each command and before return to main menu
rem *v 1.3 - Enhancements to Input area to make it look more like a command prompt
rem *v 1.4 - Enhancement to LIST section, added CLS to blank console before displaying LIST
rem *v 1.5 - Check for CHOICE.EXE in the "." directory - pre self-installing .exe form.
rem *v 1.6 - If your system has wget, download CHOICE.EXE from nettool.andarazoroflove.org
rem *v 1.7 - Script no longer requires CHOICE.EXE
rem *script begins below this line*
rem -------------------------------------------------------------------------------------------

rem :CHOICECHECK
rem **THIS HAS BEEN ANTIQUATED AS OF VERSION 1.7 -- SCRIPT NO LONGER NEEDS CHOICE.EXE**
rem *checking in a few spots for choice.exe*
rem if exist c:\progra~1\resour~1\choice.exe GOTO LIST
rem if exist %systemroot%\choice.exe GOTO LIST
rem if exist .\choice.exe GOTO LIST
rem if exist %systemroot%\system32\choice.exe GOTO LIST
rem if not exist %systemroot%\choice.exe GOTO CHOICEINST

rem :CHOICEINST
rem **THIS HAS BEEN ANTIQUATED AS OF VERSION 1.7 -- SCRIPT NO LONGER NEEDS CHOICE.EXE**
rem *change this path to download from a local server if desired*
rem xcopy /Y /Q \\someserver\someshare\choice.exe %systemroot%

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
set choice=
set /p choice="Press the number of the command you'd like to run [1,2,3,4,5]:"
if '%choice%'=='1' goto PING
if '%choice%'=='2' goto TRACERT
if '%choice%'=='3' goto NSLOOKUP
if '%choice%'=='4' goto NETSH
if '%choice%'=='5' goto EXIT

:PING
cls
set ping=
rem * create a dummy file to give the erase command something to delete
echo TESTPING > %temp%\pingt.txt
@erase /F /Q %temp%\ping*.*
rem * create a wsh .vbs to accept input and write a temporary file containing the user's input
@echo Dim FSO, objFile, RegEx, strDestin, strSource > %temp%\pingin.vbs
@echo Set FSO = CreateObject("Scripting.FileSystemObject") >>%temp%\pingin.vbs
@echo Set RegEx = New RegExp >>%temp%\pingin.vbs
@echo RegEx.Global = True >>%temp%\pingin.vbs
@echo RegEx.Pattern = "[ ]{2,}" >>%temp%\pingin.vbs
@echo Const ForReading = 1 >>%temp%\pingin.vbs
@echo strSource = Wscript.StdIn.ReadLine >>%temp%\pingin.vbs
@echo strDestin = "%temp%\pingin.txt" >>%temp%\pingin.vbs
@echo Set objFile = FSO.CreateTextFile(strDestin, True) >>%temp%\pingin.vbs
@echo objFile.Write strSource >>%temp%\pingin.vbs
@echo objFile.Close >>%temp%\pingin.vbs
rem * present the user with some text explaining what we're doing
echo [PING Tool]
echo Enter the URL or IP Address to PING below:
echo =====================================================================
cscript.exe //NoLogo //B %temp%\pingin.vbs 
rem create a .com object which can search and replace the | pipe character - it's a no no.
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
%temp%.\pipeclean.com 0 "|" "ILLEGAL.SYNTAX-PIPED.COMMANDS.ARE.NOT.AVAILABLE!" < %temp%\pingin.txt > %temp%\pingclean.txt
del %temp%.\pipeclean.com
set /p ping=<%temp%\pingclean.txt
rem ping %ping% > %temp%\pingresult.txt
ping %ping%
rem type %temp%\pingresult.txt
pause
@erase /F /Q %temp%\ping*.*
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

