<#

.SYNOPSIS
Simple logger by Aleksandr Kharkovskij
Script return logger object with atrributes setted in command line.

.DESCRIPTION


-LogPath    may be a directory or file, that exist or not exist. If file or
            directory not exist it would be created.
            if Path is directory in that directory created file yyyyMMdd.log and
            setted as log file.
            -LogPath can be omitted, then in directory from script started would
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

.NOTES
Put some notes here.

#>

param(
    [string]$LogPath="",
    [switch]$Screen,
    [switch]$OnlyScreen
    )

$scriptPath=Split-Path -Path $MyInvocation.MyCommand.Definition -Parent


enum ErrorLevel {
    INFO
    WARNING
    DEBUG
    ERROR
    FATAL
}

$errlvlHash=@{
    "INFO"=[ErrorLevel]::INFO
    "WARNING"=[ErrorLevel]::WARNING
    "DEBUG"=[ErrorLevel]::DEBUG
    "ERROR"=[ErrorLevel]::ERROR
    "FATAL"=[ErrorLevel]::FATAL
}

$logger=[PSCustomObject]@{
    "LogFile"=""
    "LogPath"=$LogPath
    "ErrorLevels"=$errlvlHash
    "ScriptPath"=$ScriptPath
}

Add-Member -memberType ScriptMethod -InputObject $logger -Name getLogFile -Value {
    $LogFilePath = $this.LogPath

    function createFile($newFilePath) {
        $file = New-Item $newFilePath -ItemType File -Force
        return $file
    }

    if ($LogFilePath -eq "") {
        $logFileName=(get-date -f yyyyMMdd)+".log"
        $relativeLogFilename="log\"+$logFileName
        $logFilePath=Join-Path $this.ScriptPath $relativeLogFilename
        if (Test-Path $logFilePath) {
            return Get-Item $logFilePath
        } else {
            return createFile($logFilePath)
        }
    }

    if (Test-Path $LogFilePath -PathType Leaf) {
        return (Get-Item $LogFilePath)
    } elseif (Test-Path $LogFilePath -PathType Container) {
        $logFileName=(get-date -f yyyyMMdd)+".log"
        $LogPath=Join-Path $LogFilePath $logFileName
        if (Test-Path $LogPath) {
            return Get-Item $LogPath
        } else {
            return createFile($LogPath)
        }
    } elseif ((Test-Path $LogFilePath -isValid) -and -not (Test-Path $LogFilePath)) {
        return createFile($LogFilePath)
    } else {
        throw "Something go wrong with path"
    }
    
}

Add-Member -memberType ScriptMethod -InputObject $logger -Name GetEventString -Value {
    param ([Parameter(Mandatory=$true)][string]$eventLogged,[string]$errorlevel)
    if (-not ($this.ErrorLevels.ContainsKey($errorlevel))) {
        $errorlevel="INFO"
    }
    $timestamp=get-date -f "dd/MM/yyyy HH:mm:ss"
    $errorlevel="["+$errorlevel+"]"
    $string="{0} {1,-9} {2}" -f $timestamp,$errorlevel,$eventLogged
    return $string
}

#Parameter check

if ($OnlyScreen) {
    Add-Member -memberType ScriptMethod -InputObject $logger -Name Write -Value {
        param ([Parameter(Mandatory=$true)][string]$eventLogged,[string]$errlvl="INFO")
        Write-Host $this.GetEventString($eventLogged,$errlvl)
    }
} elseif ($Screen) {
    Add-Member -memberType ScriptMethod -InputObject $logger -Name Write -Value {
            param ([Parameter(Mandatory=$true)][string]$eventLogged,[string]$errlvl="INFO")
            $logger.LogFile = $this.getLogFile()
            Write-Host $this.GetEventString($eventLogged,$errlvl)
            Add-Content $this.LogFile $this.GetEventString($eventLogged,$errlvl) -Force
    }    
} else {
    Add-Member -memberType ScriptMethod -InputObject $logger -Name Write -Value {
            param ([Parameter(Mandatory=$true)][string]$eventLogged,[string]$errlvl="INFO")
            $logger.LogFile = $this.getLogFile()
            Add-Content $this.LogFile $this.GetEventString($eventLogged,$errlvl) -Force
    }
}

return $logger