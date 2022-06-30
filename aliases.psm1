<#
.SYNOPSIS
    `bell`
#>
function b {
    [String] $command = $args
    Invoke-Expression $command
    bell
}

<#
.SYNOPSIS
    return battery level
#>
function battery {
    return (Get-CimInstance Win32_Battery).EstimatedChargeRemaining
}

Set-Alias cra create-react-app

<#
.SYNOPSIS
    docformatter
#>
function df {
    docformatter -i $args
}

<#
.SYNOPSIS
    exit
#>
function e {
    exit
}

<#
.SYNOPSIS
    file explorer
#>
function fe {

    param (
        [Parameter(Mandatory)]
        [String]
        $path
    )

    $full_path = Resolve-Path $path
    & 'C:\Program Files (x86)\FreeCommander XE\FreeCommander.exe' /C /T /L="$full_path"
}

<#
.SYNOPSIS
    ffmpeg
#>
function ffm {
    ffmpeg -hide_banner $args
}

<#
.SYNOPSIS
    ffplay
#>
function ffp {
    ffplay -hide_banner $args
}

<#
.SYNOPSIS
    ffprobe
#>
function ffpr {
    ffprobe -hide_banner $args
}

Set-Alias gvol Get-Volume


Set-Alias ifconfig ipconfig

<#
.SYNOPSIS
    interactive python
#>
function ipy {
    ptipython $args
}

<#
.SYNOPSIS
    dir by type
#>
function lst {

    param (
        [Parameter(Mandatory)]
        [String]
        $type
    )

    Get-ChildItem "*.$type"
}

<#
.SYNOPSIS
    more
#>
function m {
    [String] $command = "$args 2>&1"
    Invoke-Expression $command | more
}

Set-Alias marktext 'C:\Users\rahul\AppData\Local\Programs\Mark Text\Mark Text.exe'

Set-Alias np notepad

# https://notepad-plus-plus.org/
Set-Alias npp notepad++

Set-Alias open Invoke-Item

Set-Alias pdf 'C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe'

<#
.SYNOPSIS
    Paint.NET
.LINK
    https://www.getpaint.net/
#>
function pdn {

    param (
        [Parameter(Mandatory)]
        [String]
        $path
    )

    $full_path = Resolve-Path $path
    Start-Process paintdotnet:$full_path

}

<#
.SYNOPSIS
    python pip
#>
function pip {
    py -m pip $args
}

Set-Alias tf Get-Process

Set-Alias timeit Measure-Command

<#
.SYNOPSIS
    task kill
#>
function tk {

    param (
        [Parameter(Mandatory)]
        [String]
        $name
    )

    Stop-Process -Name $name -Force
}

<#
.SYNOPSIS
    task kill by PID
#>
function tkp {

    param (
        [Parameter(Mandatory)]
        [int]
        $processID
    )

    Stop-Process -Id $processID -Force

}

<#
.SYNOPSIS
    Windows Terminal here
#>
function wth {

    param (
        [String]
        $folder = '.'
    )

    wt -w 0 nt -d $folder
}

<#
.SYNOPSIS
    Windows Terminal Quake here
#>
function wtq {

    param (
        [String]
        $folder = '.'
    )

    wt -w _quake nt -d $folder
}

# https://github.com/ytdl-org/youtube-dl
Set-Alias ydl "$pwsh\youtube-dl.exe"