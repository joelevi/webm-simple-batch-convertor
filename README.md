# 📽️ webm-simple-batch-convertor
When executed, this `.bat` file checks a folder for videos, uses HandbrakeCLI to convert them to .webm VP9, and handles failures, with basic reporting.

## Description
This is a `.bat` file which, when executed:
  1. checks "C:\Videos\To Be Converted\" for files
    - if no files are found, prints a message "No more files found to convert"; reports basic statistics
    - else, continues with the next steps
  1. converts the oldest file in the folder using `handbrakecli -i "input.mp4" -o "output.webm" -f av_webm -O -e VP9` where `input.mp4` is the name of the input filename (`*.*`), and `outout.webm` is the same filename prefix with the `.webm` suffix
  1. upon a successful convert, moves the converted file to  `C:\Videos\Converted\`
  1. upon a successful convert, moves the input file to `C:\Videos\Successful\`
  1. upon an unsuccessful convert, moves the input file to `C:\Videos\Failed\`
  1. loops back to the top

## Assumptions & Dependencies
1. This is a batch program written to be executed in a Microsoft Windows environtment
1. Assumes you have [HandBrake CLI](https://handbrake.fr/downloads2.php)
1. Assumes `HandbrakeCLI.exe` is located in the `C:\Videos` directory
1. Assumes you have all HandBrake's dependencies installed
1. Assumes the following directory structure exists, with appropriate `R/W` permissions:

| Directory | Description |
| -------------- | -------------- |
|  `C:\Videos\` | Where the project lives (including the `.bat` and `HandBrakeCLI.exe` executables)  |
|  `C:\Videos\To Be Converted` | Where the (source) video files you want to convert live; once processed they will be moved to another folder |
|  `C:\Videos\Converted` | Where the video files which have been converted live |
|  `C:\Videos\Successful` | Where the successfully converted source files are moved |
|  `C:\Videos\Failed` | Where the failed source files are moved |
