@echo off
setlocal enabledelayedexpansion

:: Configuration variables
set "sourceDir=C:\Videos\To Be Converted"
set "convertedDir=C:\Videos\Converted"
set "failedDir=C:\Videos\Failed"
set "successfulDir=C:\Videos\Successful"

:: Initialize counters
set "totalProcessed=0"
set "successfulCount=0"
set "failedCount=0"

:: Capture start time
set "startTime=%time%"

:: Verify source directory exists
if not exist "%sourceDir%\" (
    echo Error: Source directory "%sourceDir%" does not exist.
    pause
    goto :eof
)

:: Debug: Display source directory and list files
echo Checking for files in: %sourceDir%
echo Listing files in directory:
dir "%sourceDir%\*.*" /b
if %ERRORLEVEL% neq 0 (
    echo Error: Unable to list files in "%sourceDir%". Check permissions or path.
    pause
    goto :eof
)

:loop
:: Check for files in the source directory (looking for all files)
set "foundFile="
for %%F in ("%sourceDir%\*.*") do (
    set "foundFile=%%~nxF"
    goto :process
)

:: No files found, calculate elapsed time
set "endTime=%time%"
:: Convert times to hundredths of a second for calculation
set "startH=%startTime:~0,2%"
set "startM=%startTime:~3,2%"
set "startS=%startTime:~6,2%"
set "startC=%startTime:~9,2%"
set /a "startTotal=(%startH%*360000)+(%startM%*6000)+(%startS%*100)+%startC%"

set "endH=%endTime:~0,2%"
set "endM=%endTime:~3,2%"
set "endS=%endTime:~6,2%"
set "endC=%endTime:~9,2%"
set /a "endTotal=(%endH%*360000)+(%endM%*6000)+(%endS%*100)+%endC%"

:: Handle case where end time is past midnight
if %endTotal% lss %startTotal% set /a "endTotal+=8640000"

set /a "elapsedTotal=%endTotal%-%startTotal%"
set /a "elapsedHours=%elapsedTotal%/360000"
set /a "elapsedMinutes=(%elapsedTotal% %% 360000)/6000"
set /a "elapsedSeconds=(%elapsedTotal% %% 6000)/100"
set /a "elapsedCentiseconds=%elapsedTotal% %% 100"

:: Format elapsed time
set "elapsedTime=%elapsedHours%h %elapsedMinutes%m %elapsedSeconds%.%elapsedCentiseconds%s"

:: Display summary
echo handbrakecli --version
echo No more files found to convert in "%sourceDir%".
echo Total time spent: %elapsedTime%
echo Total files processed: %totalProcessed%
echo Successful conversions: %successfulCount%
echo Failed conversions: %failedCount%
pause
goto :eof

:process
:: Get the oldest file
set "oldestFile="
for /f "delims=" %%F in ('dir "%sourceDir%\*.*" /b /o:d') do (
    set "oldestFile=%%F"
    goto :convert
)

:convert
:: Debug: Display file being processed
echo Processing file: %oldestFile%

:: Increment total processed counter
set /a "totalProcessed+=1"

:: Extract filename without extension
set "fileName=%oldestFile%"
set "fileNameNoExt=%fileName:~0,-4%"

:: Define input and output paths
set "inputFile=%sourceDir%\%oldestFile%"
set "outputFile=%convertedDir%\%fileNameNoExt%.webm"

:: Verify input file exists
if not exist "%inputFile%" (
    echo Error: Input file "%inputFile%" not found.
    goto :loop
)

:: Perform conversion
echo Converting "%inputFile%" to "%outputFile%"...
handbrakecli -i "%inputFile%" -o "%outputFile%" -f av_webm -O -e VP9

:: Check if conversion was successful
if %ERRORLEVEL% equ 0 (
    echo Conversion successful for "%oldestFile%".
    :: Move converted file to Converted folder
    move "%outputFile%" "%convertedDir%\"
    :: Move original file to Successful folder
    move "%inputFile%" "%successfulDir%\"
    set /a "successfulCount+=1"
) else (
    echo Conversion failed for "%oldestFile%".
    :: Move original file to Failed folder
    move "%inputFile%" "%failedDir%\"
    set /a "failedCount+=1"
)

:: Loop back to check for more files
goto :loop

:eof
endlocal
