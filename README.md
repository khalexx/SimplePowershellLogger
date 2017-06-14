# SimplePowershellLogger
Simple Custom powershell logger
.SYNOPSIS
Simple logger by Aleksandr Kharkovskij
Script return logger object with atrributes setted in command line.

.DESCRIPTION


-LogPath    may be a directory or file, that exist or not exist. If file or
            directory not exist it would be created.
            if Path is directory, in that directory created file yyyyMMdd.log and
            setted as log file.
            -LogPath can be omitted, then in directory script started from would
            be created log directory,inside which would be created yyyyMMdd.log
            file.

-Screen     Write-Host information to screen while writing it in log

-OnlyScreen No file created, information writed only to Screen(Write-Host)

Object have method .Write("string") or .Write("string","error_level")
error_level can be:
    INFO
    WARNING
    DEBUG
    ERROR
    FATAL
By default, or if .Write() don't understand error level setting to INFO

.EXAMPLE
$logger=.\GetLogger.ps1
Create in current directory new log directory, then create file with current
date yyyyMMdd.log. Setup this file as log.

$logger.write("Message")
Write "Message" to the log file.

$logger.write("Message","WARNING")
Write WARNING message to the log

.EXAMPLE
$logger=.\GetLogger.ps1 c:\test\test.log -Screen
Create test.log if not exist. When information would be writen in file, it also
would be writen to screen
