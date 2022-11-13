@echo off
title Texteditor_v1.0 by L8

:menu
cls
echo Texteditor in Batch v1.0 by L8
echo.
echo Type "help" for a List of all commands.
echo.
if exist tempwrite.temp echo It seems you have not saved your previously worked on file. Do you want to save it now?& choice /c yn
if %errorlevel% EQU 1 goto notsaved
if %errorlevel% EQU 2 goto menu2

:menu2
echo.
set /p menu=Command: 
if "%menu%"=="help" goto help
if "%menu%"=="write" goto write0
if "%menu%"=="edit" goto edit1
if "%menu%"=="del" goto delete
if "%menu%"=="exit" exit
echo.
echo Please enter a right command.
pause >nul
goto menu

:write0
if exist tempwrite.temp del tempwrite.temp
set /a line=0
cls

:write
set /p write=
set line+=1
if "%write%"=="save" goto save
if "%write%"=="exit" goto menu
echo %write%>>tempwrite.temp
goto write

:save
cls
set /p path=Full path to folder (example: %userprofile%\Desktop\YourFolder):
set path=%path%\
if not exist %path% echo Folder does not exist!& pause>nul& goto save
echo.
set /p save=Name (with extension):
set content=c1
(for %%i in (%content%)do set/p %%~i=)<tempwrite.temp
echo %c1%>%path%%save%
for /F "skip=1 delims=" %%i in (tempwrite.temp) do echo %%i>>%path%%save%
if not exist %path%%save% goto error_save
cls
echo Sucessfully saved the file.
del tempwrite.temp
pause >nul
goto menu

:error_save
cls
echo A problem has accured while saving your file.
echo Please try again.
pause >nul
goto save

:notsaved
cls
type tempwrite.temp
echo.
set /p path=Full path to folder (example: %userprofile%\Desktop\YourFolder):
set path=%path%\
if not exist %path% echo Folder does not exist!& pause>nul& goto save
echo.
set /p save=Name (with extension):
set content=c1
(for %%i in (%content%)do set/p %%~i=)<tempwrite.temp
echo %c1%>%path%%save%
for /F "skip=1 delims=" %%i in (tempwrite.temp) do echo %%i>>%path%%save%
if not exist %path%%save% goto error_notsaved
cls
echo Sucessfully saved the file.
del tempwrite.temp
pause >nul
goto menu

:error_notsaved
cls
echo A problem has accured while saving your file.
echo Please try again.
pause >nul
goto notsaved

:edit1
cls
set /p file=Full path to file (with file extension, exmaple: %userprofile%\Desktop\YourFile.txt):
if %file%==exit goto menu
if not exist %file% echo File does not exist!& pause>nul& goto edit1
echo.
type %file%

:edit2
echo.
set /p lineusr=Line to edit:
if "%lineusr%"=="exit" goto menu
set /a linecalc=%lineusr%-1
if %linecalc% EQU 0 goto edit3
set skip=skip=%linecalc%

:edit3
if exist tempedit.temp del tempedit.temp
type %file%>tempedit.temp
echo.
set /p edit=New line content: 
rem following edit code from Spencer May on https://stackoverflow.com/questions/10686261/write-batch-variable-into-specific-line-in-a-text-file
rem modified a little bit by me L8 to get it work properly in this programm
setlocal enableextensions enabledelayedexpansion
set inputfile=tempedit.temp
set tempfile=%random%-%random%.tmp
copy /y %tempfile%>nul
set line=0
for /f "delims=" %%l in (%inputfile%) do (
    set /a line+=1
    if !line!==%lineusr% (
        echo %edit%>>%tempfile%
    ) else (
        echo %%l>>%tempfile%
    )
)
del %inputfile%
ren %tempfile% %inputfile%
endlocal
rem end of Spencer's code
type tempedit.temp>%file%
del tempedit.temp
echo.
type %file%
goto edit2

:delete
cls
set /p file=Full path to file (with file extension, exmaple: %userprofile%\Desktop\YourFile.txt):
if %file%==exit goto menu
if not exist %file% echo File does not exist!& pause>nul& goto delete
del %file%
if not exist %file% cls& echo Sucessfully deleted the file.& pause>nul& goto menu
cls
echo A problem has accured while deleting your file.
echo Please try again.
pause >nul
goto delete

:help
cls
echo Commands in the main menu:
echo write          creates new file to write in
echo edit           edits a file
echo help           shows this list of commands
echo del            deletes a file
echo exit           closes program
echo.
echo Commands in writing mode:
echo save           saves file with user set name
echo exit           gets you to the main menu
echo.
echo Commands in edit mode:
echo exit           gets you to the main menu
echo.
echo Commands in delete mode:
echo exit           gets you to the main menu
pause >nul
goto menu