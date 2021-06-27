<#
.SYNOPSIS
    `bell`
#>
function b {
    [String] $command = $args
    Invoke-Expression $command
    bell
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

# https://github.com/skarfie123/FolderCompare
Set-Alias foc "${env:GITHUB}\pwsh\FolderCompare.exe" 

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

# https://github.com/skarfie123/MarkdownDiary
Set-Alias mdd "${env:GITHUB}\pwsh\MarkdownDiary.exe" 

<#
.SYNOPSIS
    more
#>
function m {
    [String] $command = "$args 2>&1"
    Invoke-Expression $command | more
}

Set-Alias np notepad

# https://notepad-plus-plus.org/
Set-Alias npp notepad++

Set-Alias pdf 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'

<#
.SYNOPSIS
    Paint.NET https://www.getpaint.net/
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

# https://github.com/skarfie123/PythonImageViewer
Set-Alias piv "${env:GITHUB}\pwsh\PythonImageViewer.exe"

# https://github.com/skarfie123/pdfTools
Set-Alias pt "${env:GITHUB}\pwsh\pdfTools.exe"

Set-Alias tf Get-Process

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

# https://github.com/ytdl-org/youtube-dl
Set-Alias ydl "${env:GITHUB}\pwsh\youtube-dl.exe"