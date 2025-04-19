<#
.SYNOPSIS
    check if admin
.LINK
    https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil
#>
function admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Output '[92mAdmin[0m'
        return $true
    }
    else {
        Write-Output '[91mNot Admin[0m'
        return $false
    }
}

<#
.SYNOPSIS
    edit/add ahk script / edit whole repo
#>
function ahk {
    param (
        [String]
        $module # module to edit
    )
    $AHK = "$skarfie123\AHK"
    if ($PSBoundParameters.ContainsKey('module')) {
        if (-not(Test-Path -Path "$AHK\$module.ahk" -PathType Leaf)) {
            Write-Output "#Include, $module.ahk">>$AHK\main.ahk
        }
        code $AHK\$module.ahk
    }
    else {
        code $AHK
    }
}

<#
.SYNOPSIS
    boot script (opens wt with a few tasks)
.DESCRIPTION
    create a shortcut in the startup folder that targets `"C:\Program Files\PowerShell\7\pwsh.exe" -c boot`
#>
function boot {
    wt -w _quake nt `; nt --title Check pwsh -c 'cls && check' `; nt -d $env:GITHUB --title GitHub pwsh -c gsa`; nt -d $skarfie123 --title Skarfie123 pwsh -c gsa

    Set-Location $skarfie123\AHK
    .\main.ahk

    if ($env:MONITOR_BATTERY -eq 'TRUE') {
        pwsh -windowstyle hidden -c MonitorBattery
    }
}

<#
.SYNOPSIS
    make a sound
#>
function bell {
    Write-Output '[1A'
}

<#
.SYNOPSIS
    Export chrome tabs to file
#>
function chrome-export {
    param (
        [Parameter(Mandatory)]
        [String]
        $name 
    )
    osascript (Join-Path $pwsh chrome_export.applescript) | Out-File (Join-Path $HOME .chrome_export "$name.chrome")
    chrome-list $name
}
Set-Alias ce chrome-export

<#
.SYNOPSIS
    List chrome exports
#>
function chrome-list {

    param (
        [String]
        $name
    )
    
    if (-not($PSBoundParameters.ContainsKey('name'))) {
        Get-ChildItem (Join-Path $HOME .chrome_export '*.chrome') | ForEach-Object { Write-Output $_.BaseName }
    }
    else {
        Get-Content (Join-Path $HOME .chrome_export "$name.chrome")
    }
    
}
Set-Alias cl chrome-list

<#
.SYNOPSIS
    Load chrome tabs from file
#>
function chrome-open {
    param (
        [Parameter(Mandatory)]
        [String]
        $name 
    )
    Get-Content (Join-Path $HOME .chrome_export "$name.chrome") | ForEach-Object { open $_ }
}
Set-Alias co chrome-open

<#
.SYNOPSIS
    count total RAM used by chrome.exe instances
#>
function chromeTotal {
    return ramTotal chrome
}

<#
.SYNOPSIS
    colours reference
.LINK
    https://gist.github.com/skarfie123/ab1d4c728e6ffd1d8c94876891178430
#>
function col {
    cmd /c $skarfie123\gists\colours.cmd
}

<#
.SYNOPSIS
    convert using ffmpeg
#>
function convert {

    param (
        [Parameter(Mandatory)]
        [String]
        $type,
        [Parameter(Mandatory)]
        [String]
        $original,
        [String]
        $newName
    )
    
    if (-not($PSBoundParameters.ContainsKey('newName'))) {
        $newName = Split-Path $original -LeafBase
    }

    ffm -i $original "$newName.$type"
}

<#
.SYNOPSIS
    count output lines
#>
function count {
    return @(Invoke-Expression "$args").Count
}


<#
.SYNOPSIS
    count files
#>
function CountFiles {
    param(
        [string]$Path
    )

    Get-ChildItem -Path $Path -Recurse | Measure-Object | Select-Object -ExpandProperty Count
}


<#
.SYNOPSIS
    count files by extension
#>
function CountFilesByExtension {
    param(
        [string]$Path
    )

    Get-ChildItem -Path $Path -Recurse -File | Group-Object Extension | ForEach-Object {
        Write-Host "Extension: $($_.Group[0].Extension) - Count: $($_.Count)"
    }
}


<#
.SYNOPSIS
    print event(s) corresponding to failed ejection(s)
#>
function ejectFailed {

    param (
        [int]
        $count = 1
    )

    wevtutil qe System /q:"*[System[(EventID=225)]]" /c:$count /f:text /rd:true

    Write-Output "Now for ``abc.exe`` you need to open powershell admin and run ``Stop-Process -Name abc``"
}

<#
.SYNOPSIS
    print errorlevel
#>
function el {
    Write-Output "$LASTEXITCODE $?"
}

<#
.SYNOPSIS
    extract archive contents in new folder(s)
#>
function extract {

    param (
        [Parameter(Mandatory)]
        [String]
        $archive,
        [String]
        $folder
    )
    
    if (-not($PSBoundParameters.ContainsKey('folder'))) {
        $folder = Split-Path $archive -LeafBase
    }

    $archive_path = Resolve-Path $archive
    $current = $PWD

    New-Item -ItemType directory -Path $folder
    Set-Location $folder

    extracth $archive_path
    
    Set-Location $current
}

<#
.SYNOPSIS
    find (unix)
.LINK
    https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
#>
function find($name) {
    Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output($PSItem.FullName)
    }
}

<#
.SYNOPSIS
    extract archive contents here
#>
function extracth {

    param (
        [Parameter(Mandatory)]
        [String]
        $archive
    )

    7z x $archive
}

<#
.SYNOPSIS
    grep (unix)
.LINK
    https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
#>
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | Select-String $regex
        return
    }
    $input | Select-String $regex
}

<#
.SYNOPSIS
    grepv (unix)
.LINK
    https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
#>
function grepv($regex) {
    $input | Where-Object { !$_.Contains($regex) }
}

<#
.SYNOPSIS
    ??
#>
function helloWorld {
    Write-Output 'Hello World![1A[2K[1A'
}

<#
.SYNOPSIS
    horizontal flip an image
#> 
function hflip {
    $image = [System.Drawing.image]::FromFile( $_ )
    $image.rotateflip('Rotate90FlipNone', 'jpeg')
    $image.save($_)
}

<#
.SYNOPSIS
    pause and then hide trace
#>
function invisiblePause {
    Pause
    Write-Output '[1A[2K[1A'
}

<#
.SYNOPSIS
    return current IPv4 addresses for Linux, MacOS, or Windows
.LINK
    https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/create-powershell-scripts.md
#>
function ip {
    $IP = if ($IsLinux -or $IsMacOS) {
        $ipInfo = ifconfig | Select-String 'inet'
        $ipInfo = [regex]::matches($ipInfo, 'addr:\b(?:\d{1,3}\.){3}\d{1,3}\b') | ForEach-Object value
        foreach ($ip in $ipInfo) {
            $ip.Replace('addr:', '')
        }
    }
    else {
        Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' } | ForEach-Object IPAddress
    }

    # Remove loopback address from output regardless of platform
    return $IP | Where-Object { $_ -ne '127.0.0.1' }
}

<#
.SYNOPSIS
    keep running a command
.LINK
    https://github.com/microsoft/terminal/issues/4379#issuecomment-905112832
#>
function Keep-Alive {

    while ($TRUE) {
        Invoke-Expression $args
        Start-Sleep -Seconds 1
        Write-Output 'Command ended. Press Enter to reload.'
        Read-Host
    }
}

<#
.SYNOPSIS
    load secret script if it exists
#>
function load_secret {

    $secret_load = (Join-Path $pwsh secret.ps1)
    if (Test-Path $secret_load) {
        & $secret_load
    }
}

<#
.SYNOPSIS
    digital rain
#>
function matrix {
    $size = $Host.UI.RawUI.WindowSize.Width
    while ($true) {
        $str = "$(Get-Random -Maximum 10)"
        for ($i = 2; $i -lt $size; $i += 2) {
            $str += " $(Get-Random -Maximum 10)"
        }
        Write-Output "[92m$str[0m"
        Start-Sleep -Milliseconds 50
    }
}

<#
.SYNOPSIS
    Monitor Battery Level
#>
function MonitorBattery {
    
    [CmdletBinding()]
    param (
    )
    while ($true) {
        $battery = battery
        $status = (Get-CimInstance Win32_Battery).BatteryStatus
        $file = "$env:USERPROFILE\battery.log"
        
        if (-not(Test-Path $file)) {
            Write-Output 'Time,EstimatedChargeRemaining,BatteryStatus' >> $file
        }
        Write-Output "$(Get-Date),$battery,$status" >> $file
        
        # https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-battery
        # for my laptop 1 is discharging, 2 is charging
        if ($battery -le 15 -and $status -eq 1) {
            notify 'Warning' "Low Battery Level: $battery" Warning
        }
        else {
            Write-Output $battery
        }
        Start-Sleep 60
    }
}

<#
.SYNOPSIS
    convert to mp3
#>
function mp3 {
    convert 'mp3' @args
}

<#
.SYNOPSIS
    convert to mp4
#>
function mp4 {
    convert 'mp4' @args
}

enum NotifyIcon {
    Application
    Asterisk
    Error
    Exclamation
    Hand
    Information
    Question
    Shield
    Warning
    WinLogo
}

<#
.SYNOPSIS
    Notification
.LINK
    https://mcpmag.com/articles/2017/09/07/creating-a-balloon-tip-notification-using-powershell.aspx
#>
function notify {
    
    param (
        [Parameter(Mandatory)]
        [String]
        $title,
        [Parameter(Mandatory)]
        [String]
        $message,
        [NotifyIcon]
        $icon
    )
    
    if ($PSBoundParameters.ContainsKey('icon')) {
        $system_icon = [system.drawing.systemicons]::$icon
    }
    else {
        $path = (Get-Process -Id $PID).Path
        Write-Verbose $path
        $system_icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    }

    Add-Type -AssemblyName System.Windows.Forms
    if ($null -eq $global:pwshNotifyIcon) {
        $global:pwshNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
    }

    $events = 'BalloonTipClosed', 'BalloonTipClicked', 'MouseDoubleClick'

    $action = {
        
        #Perform  cleanup actions on balloon tip
    
        $global:pwshNotifyIcon.dispose()
    
        foreach ($item in $events) {
            Unregister-Event -SourceIdentifier $item
    
            Remove-Job -Name $item
        }
    
        Remove-Variable -Name pwshNotifyIcon -Scope Global
  
    }

    foreach ($item in $events) {
        [void](Register-ObjectEvent -InputObject $global:pwshNotifyIcon -EventName $item -SourceIdentifier $item -Action $action)
    }
        
    $global:pwshNotifyIcon.BalloonTipText = $message
    $global:pwshNotifyIcon.Text = "pwsh - $title - $message"
    $global:pwshNotifyIcon.Icon = $system_icon
    $global:pwshNotifyIcon.BalloonTipTitle = $title
    switch ($icon) {
        Error { $large_icon = [System.Windows.Forms.ToolTipIcon]::Error }
        Information { $large_icon = [System.Windows.Forms.ToolTipIcon]::Info }
        Warning { $large_icon = [System.Windows.Forms.ToolTipIcon]::Warning }
        Default { $large_icon = [System.Windows.Forms.ToolTipIcon]::None }
    }
    $global:pwshNotifyIcon.BalloonTipIcon = $large_icon
    $global:pwshNotifyIcon.Visible = $True
    $global:pwshNotifyIcon.ShowBalloonTip(5000)
}

<#
.SYNOPSIS
    uninstall all user pip modules
#>
function pipUninstallAll {
    pip freeze --user > req.text
    pip uninstall -y -r req.text
    Remove-Item req.text
}

<#
.SYNOPSIS
    pstree (unix)
.LINK
    https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
#>
function pstree {
    $ProcessesById = @{}
    foreach ($Process in (Get-WmiObject -Class Win32_Process)) {
        $ProcessesById[$Process.ProcessId] = $Process
    }

    $ProcessesWithoutParents = @()
    $ProcessesByParent = @{}
    foreach ($Pair in $ProcessesById.GetEnumerator()) {
        $Process = $Pair.Value

        if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
            $ProcessesWithoutParents += $Process
            continue
        }

        if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
            $ProcessesByParent[$Process.ParentProcessId] = @()
        }
        $Siblings = $ProcessesByParent[$Process.ParentProcessId]
        $Siblings += $Process
        $ProcessesByParent[$Process.ParentProcessId] = $Siblings
    }

    function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
        $Process = $ProcessesById[$ProcessId]
        $Indent = ' ' * $IndentLevel
        if ($Process.CommandLine) {
            $Description = $Process.CommandLine
        }
        else {
            $Description = $Process.Caption
        }

        Write-Output ('{0,6}{1} {2}' -f $Process.ProcessId, $Indent, $Description)
        foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
            Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
        }
    }

    Write-Output ('{0,6} {1}' -f 'PID', 'Command Line')
    Write-Output ('{0,6} {1}' -f '---', '------------')

    foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
        Show-ProcessTree $Process.ProcessId 0
    }
}

<#
.SYNOPSIS
    count total RAM (for all or for specified)
#>
function ramTotal {
    [CmdletBinding()]
    param (
        [String]
        $name = '*',
        [switch]
        $silent
    )

    $processes = Get-Process $name

    if (-not $silent) { Write-Output "$($processes.Count) Processes" }

    $ramTotal = 0
    foreach ($item in ($processes)) {
        Write-Verbose "$($item.Name) - $([int] ($item.WS / 1000000)) MB"
        $ramTotal += $item.WS
    }
    [int] $ramTotal = $ramTotal / 1000000 # B to MB
    
    if (-not $silent) {
        Write-Output "$($ramTotal) MB"
        invisiblePause
    }

    if ($silent) { return $ramTotal }
}

<#
.SYNOPSIS
    restart explorer.exe
#>
function restartExplorer {
    taskkill /IM 'explorer.exe' /F
    Start-Process explorer
}

<#
.SYNOPSIS
    clear screen and print logo
#>
function splash {
    Clear-Host
    Get-Content $pwsh\rpc.txt
}

<#
.SYNOPSIS
    sudo (unix)
.LINK
    https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
#>
function sudo() {
    Invoke-Elevated @args
}

<#
.SYNOPSIS
    add a suffix to each file in the folder
#>
function suffix {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $suffix
    )

    foreach ($file in Get-ChildItem) {
        Rename-Item $file.Name ($file.BaseName + $suffix + $file.Extension)
    }
}

<#
.SYNOPSIS
    check if filename is valid
.LINK
    https://stackoverflow.com/a/36408199/6023007
#>
function Test-ValidFileName {
    param([string]$FileName)

    $IndexOfInvalidChar = $FileName.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars())

    # IndexOfAny() returns the value -1 to indicate no such character was found
    return $IndexOfInvalidChar -eq -1
}

<#
.SYNOPSIS
    run a command n times and alert if it errors
#>
function testn {

    param (
        [Parameter(Mandatory)]
        [String]
        $command,
        [Parameter(Mandatory)]
        [int]
        $number # number of times to run command
    )
    
    for ($i = 0; $i -lt $number; $i++) {
        Write-Output "Running $i"
        & $command | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Output "[93mError Level $LASTEXITCODE at Run $i[0m"
        }
        else {
            Write-Output '[1A[2K[1A'
        }
    }
}

<#
.SYNOPSIS
Runs the given script block and returns the execution duration.
Discovered on StackOverflow. http://stackoverflow.com/questions/3513650/timing-a-commands-execution-in-powershell

https://gist.github.com/jpoehls/2206444

.EXAMPLE
Measure-Command2 { ping -n 1 google.com }
#>
function Measure-Command2 ([ScriptBlock]$Expression, [int]$Samples = 1, [Switch]$Silent, [Switch]$Long) {
    $timings = @()
    do {
        $sw = New-Object Diagnostics.Stopwatch
        if ($Silent) {
            $sw.Start()
            $null = & $Expression
            $sw.Stop()
            Write-Host '.' -NoNewline
        }
        else {
            $sw.Start()
            & $Expression
            $sw.Stop()
        }
        $timings += $sw.Elapsed

        $Samples--
    }
    while ($Samples -gt 0)

    Write-Host

    $stats = $timings | Measure-Object -Average -Minimum -Maximum -Property Ticks

    # Print the full timespan if the $Long switch was given.
    if ($Long) {
        Write-Host "Avg: $((New-Object System.TimeSpan $stats.Average).ToString())"
        Write-Host "Min: $((New-Object System.TimeSpan $stats.Minimum).ToString())"
        Write-Host "Max: $((New-Object System.TimeSpan $stats.Maximum).ToString())"
    }
    else {
        # Otherwise just print the milliseconds which is easier to read.
        Write-Host "Avg: $((New-Object System.TimeSpan $stats.Average).TotalMilliseconds)ms"
        Write-Host "Min: $((New-Object System.TimeSpan $stats.Minimum).TotalMilliseconds)ms"
        Write-Host "Max: $((New-Object System.TimeSpan $stats.Maximum).TotalMilliseconds)ms"
    }
}

Set-Alias time Measure-Command2

<#
.SYNOPSIS
    check for TODO like comments
#>
function todo {

    param (
        [String]
        $path = '.'
    )

    Get-ChildItem $path -Recurse | Select-String -Pattern '((#|//) (\?|TODO|FIXME|XXX|BUG|HACK))|\[ \]|\[x\]'
}

<#
.SYNOPSIS
    Toggle sound between speakers and headphones
#>
function toggle-sound {

    $current = Get-AudioDevice -List | Where-Object Type -Like 'Playback' | Where-Object default -EQ $true
    $headphones = 'Headphones (Realtek USB2.0 Audio)'
    $speakers = 'M27Q (AMD High Definition Audio Device)'
    if ($current.Name -eq $headphones) {
        Get-AudioDevice -List | Where-Object Type -Like 'Playback' | Where-Object name -EQ $speakers | Set-AudioDevice -Verbose
        return
    }
    Get-AudioDevice -List | Where-Object Type -Like 'Playback' | Where-Object name -EQ $headphones | Set-AudioDevice -Verbose
    
}

<#
.SYNOPSIS
    create a file
#>
function touch {

    param (
        [Parameter(Mandatory)]
        [String]
        $file
    )

    if ( Test-Path $file ) {
        Write-Output "$file already exists"
    }
    else {
        New-Item $file -type file
    }
}

<#
.SYNOPSIS
    ydl video description
#>
function ydldesc {
    ydl --skip-download --get-description $args
}

<#
.SYNOPSIS
    ydl as mp3
#>
function ydlmp3 {
    ydl -x --audio-format mp3 $args
}

<#
.SYNOPSIS
    compress a file or folder
#>
function zip {
    

    param (
        [Parameter(Mandatory)]
        [String]
        $path,
        [String]
        $archive
    )


    
    if (-not($PSBoundParameters.ContainsKey('archive'))) {
        $archive = "$(Split-Path $path -LeafBase).zip"
    }

    7z a $archive $path
}

<#
.SYNOPSIS
    list the top level files and directories in an archive
#>
function ziplist {
    7z l -x!*\* $args
}