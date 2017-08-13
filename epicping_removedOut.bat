@setlocal enableextensions enabledelayedexpansion
@echo off
Title Epic Ping by Josh Avalos (v-joava) -- http://Avalos.info

set out=no

:begin
Echo For Advanced Options Enter C
Echo For Local Computer Leave Blank
Echo ----------------------------------
set /p ipaddr=Enter IP or Server Name:
IF /I '%ipaddr%'=='' (set ipaddr=%computername%)
IF /I '%ipaddr%'=='C' (set choice=c) && goto advping
goto start

:advping
cls 
Echo Advanced Options Selected
Echo -------------------------
set /p ipaddr=Enter IP or Server Name:
goto advance

:start
cls && Echo Checking Connection.. Please wait && echo. && echo.
ping -n 1 %ipaddr% -4|Findstr /I /C:"not find host" /C:"Bad parameter" /C:"Invalid" >nul:
if %errorlevel%==0 cls & Echo ERROR: & Echo ------ & ping -4 -n 1 %ipaddr% & echo. && goto begin

set ping=down
set state=down
ping -n 1 %ipaddr% -4|Findstr /I /C:"TTL" /C:"time=" >nul:
if %errorlevel%==0 set state=up
IF !state! == down GOTO ping
set ping=up
cls

::choice
::ECHO Options For - %ipaddr% - && ECHO -----------------------
::ECHO A. Ping + Get Host Information
::ECHO C. Advanced Options
::ECHO.
::SET /P Choice=Select EpicPing Type: 
::IF /I '%Choice%'=='A' GOTO advance
::IF /I '%Choice%'=='C' GOTO advance
::ECHO "%Choice%" is not valid. Please try again 
::pause && cls
::goto choice

:advance
cls
IF /I '%Choice%'=='C' @cmd /c start cmd /k "Title Port Query For %ipaddr% & MODE CON: COLS=65 LINES=27 && @Echo OFF & Echo In Order To Run PortQry You Will Need To Install: & Echo http://www.microsoft.com/en-us/download/details.aspx?id=17148 & Echo. & Echo Running Port Query On: & Echo 2381,3389,80,443 & Echo. & Echo --------- & portqry -n "%ipaddr%" -p TCP -o 2381,3389,80,443"

:ping
cls && Echo DNS INFO: && Echo ---------
nslookup "%ipaddr%"
echo.
(for /f "skip=2 tokens=*" %%F in ('ping -4 -n 1 %ipaddr%') do @if not defined _A @echo %%F&set _A=0) &set "_A="
echo.
IF !state! == down goto loop

:wmic
Echo. && Echo SYSTEM INFO: && Echo ---------
wmic /node:"%ipaddr%" computersystem get name
IF %ERRORLEVEL% LSS 0 goto wmifail
set wmic=up
wmic /node:"%ipaddr%" systemenclosure get smbiosassettag,serialnumber
systeminfo /s %ipaddr%|Findstr /c:"OS Name" /c:"OS Version" /c:"Install Date" /c:"System Boot Time" /c:"System Model" /c:"Processor" /c:"BIOS Version" /c:"Total Physical Memory" /c:"Logon Server" /c:"Network Card"

set virtual=no
wmic /node:"%ipaddr%" computersystem get model|Findstr /C:"Virtual" >nul:
if %errorlevel%==0 set virtual=yes && goto virtual
IF /I '%Choice%'=='C' goto advping
echo. && echo.

:loop
set state=down
ping -n 1 %ipaddr% -4|Findstr /I /C:"TTL" /C:"time=" >nul:
if %errorlevel%==0 set state=up
IF !state! == down Time /T && Echo Link is Down && Echo -------- && goto bad
IF !state! == up Time /T && Echo Link is Up && Echo -------- && goto good
Echo Ping Stuck In Loop Close Window
ping -n 6 127.0.0.1 >nul: 2>nul:
goto loop

:bad
set state=down
ping -n 1 %ipaddr% -4|Findstr /I /C:"TTL" /C:"time=" >nul:
if %errorlevel%==0 set state=up
IF !state! == up Time /T && Echo Link is Up && Echo -------- && goto good
ping -n 6 127.0.0.1 >nul: 2>nul:
goto outloop


:good
set state=down
ping -n 1 %ipaddr% -4|Findstr /I /C:"TTL" /C:"time=" >nul:
if %errorlevel%==0 set state=up
IF !state! == down Time /T && Echo Link is Down && Echo -------- && goto bad
ping -n 6 127.0.0.1 >nul: 2>nul:
if !ping! == down goto checkup
goto outloop


:wmifail
set wmic=down
Echo Could Not Execute Remote Commands && echo. && echo. 
IF /I '%Choice%'=='C' goto advping 
goto loop

:virtual
Echo. && Echo Virtual Machine Hosted On:
reg query "\\%ipaddr%\HKLM\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters" /v PhysicalHostName >nul: 2>nul:
IF %ERRORLEVEL% GTR 0 Echo Error Querying VM Host - Try from a Jumpbox && Echo. && goto loop
FOR /F "tokens=3 delims= " %%G IN ('"reg query "\\%ipaddr%\HKLM\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters" /v PhysicalHostName"') DO ECHO %%G
Echo.
goto loop

:checkup
wmic /node:"%ipaddr%" computersystem get name >nul: 2>nul:
IF %ERRORLEVEL% LSS 0 goto good
set ping=up
echo.
echo -Server Acccessible, Continuing Commands-
echo.
goto wmic

:advping
set state=down
ping -n 1 %ipaddr% -4|Findstr /I /C:"TTL" /C:"time=" >nul:
if %errorlevel%==0 set state=up

Echo. && Time /t && Echo Link Is !state! && Echo. && Echo Additional Options && Echo To Quit just enter [Q] for any option && Echo ------------------ && Echo.

:advstart
IF !wmic! ==down goto next
set /p sys=Pull Full System Information:(Y/N)
IF /I '%sys%'=='Y' @cmd /c start cmd /k "@Echo off && TITLE Pulling System Information For %ipaddr% && systeminfo /s %ipaddr%"
set /p txt=Write System Information To .TXT File:(Y/N)
IF /I '%txt%'=='Y' systeminfo /s %ipaddr% > ".\%ipaddr%.txt"
IF /I '%txt%'=='Y' Echo Done.. File %ipaddr%.txt Created && Echo. && goto next
IF /I '%sys%'=='Y' Echo. && goto next
IF /I '%sys%'=='N' echo. && goto next
IF /I '%sys%'=='Q' exit
goto advstart

:next
set /p hphp=Open HP System Management Homepage:2381 (Y/N)
IF /I '%hphp%'=='Y' start iexplore https://%ipaddr%:2381
IF /I '%hphp%'=='Y' Echo. && goto next1
IF /I '%hphp%'=='N' echo. && goto next1
IF /I '%hphp%'=='Q' exit
goto next

:next1
set /p rem=Attempt Remote Desktop Connection:3389 (Y/N)
IF /I '%rem%'=='Y' start mstsc /v:"%ipaddr%" /f
IF /I '%rem%'=='Y' Echo. && goto next2
IF /I '%rem%'=='N' Echo. && goto next2
IF /I '%rem%'=='Q' exit
goto next1

:next2
echo.
goto loop

:outloop
IF !state! == down goto bad
IF !state! == up goto good
goto outloop
