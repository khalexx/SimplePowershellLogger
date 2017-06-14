# SimplePowershellLogger
Simple Custom powershell logger<br/>
Script return logger object with atrributes setted in command line.
<p>
<code>$logger=.\GetLogger.ps1 [[-LogPath] <String>] [-Screen] [-OnlyScreen] [&ltCommonParameters&gt]</code>

<table>
<tr><td>-LogPath</td>
                        <td><p>may be a directory or file, that exist or not exist. If file or
                        directory not exist it would be created.
                        if Path is directory, in that directory created file yyyyMMdd.log and
                        setted as log file.</p>
                        <p>-LogPath can be omitted, then in directory script started from would
                        be created log directory,inside which would be created yyyyMMdd.log
                        file.</p></td></tr>

<tr><td>-Screen</td>     <td>Write-Host information to screen while writing it in log</td></tr>

<tr><td nowrap>-OnlyScreen</td> <td>No file created, information writed only to Screen(Write-Host)</td></tr>
</table>

Object have method .Write("string") or .Write("string","error_level")
error_level can be:
<ul>
    <li>INFO</li>
    <li>WARNING</li>
    <li>DEBUG</li>
    <li>ERROR</li>
    <li>FATAL</li>
</ul>
By default, or if .Write() don't understand error level setting to INFO

.EXAMPLE
<p><code>$logger=.\GetLogger.ps1</code><br/>
Create in current directory new log directory, then create file with current
date yyyyMMdd.log. Setup this file as log.</p>

<p><code>$logger.write("Message")</code><br/>
Write "Message" to the log file.</p>

<p><code>$logger.write("Message","WARNING")</code><br/>
Write WARNING message to the log</p>

.EXAMPLE
<p><code>$logger=.\GetLogger.ps1 c:\test\test.log -Screen</code><br/>
Create test.log if not exist. When information would be writen in file, it also
would be writen to screen</p>
