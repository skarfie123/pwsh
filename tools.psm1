﻿<#
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
    if ($PSBoundParameters.ContainsKey('module')) {
        if (-not(Test-Path -Path "$env:GITHUB\AHK\$module.ahk" -PathType Leaf)) {
            Write-Output "#Include, $module.ahk">>$env:GITHUB\AHK\main.ahk
        }
        code $env:GITHUB\AHK\$module.ahk
    }
    else {
        code $env:GITHUB\AHK
    }
}

<#
.SYNOPSIS
    boot script (opens wt with a few tasks)
#>
function boot {
    wt -w _quake nt `; nt pwsh -c 'cls && check && pause' `; nt -d $env:GITHUB pwsh -c gsa
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
    cmd /c $env:GITHUB\gists\colours.cmd
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
    print event(s) corresponding to failed ejection(s)
#>
function ejectFailed {

    param (
        [int]
        $count = 1
    )

    wevtutil qe System /q:"*[System[(EventID=225)]]" /c:$count /f:text /rd:true
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
    👋
#>
function helloWorld {
    Write-Output 'Hello World![1A[2K[1A'
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
    kubernetes log by pod name
#>
function kubelog {}

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
    foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
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
    Get-Content $env:GITHUB\pwsh\rpc.txt
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

Set-Alias timeit Measure-Command

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