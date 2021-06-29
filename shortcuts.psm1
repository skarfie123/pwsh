<#
.SYNOPSIS
    open chrome extensions folder
#>
function chromeExt {
    fe "${env:LocalAppData}\Google\Chrome\User Data\Default\Extensions"
}

<#
.SYNOPSIS
    cd to Downloads folder
#>
function dl {
    Set-Location $env:DOWNLOADS
}

<#
.SYNOPSIS
    explorer here
#>
function eh {
    explorer .
}

<#
.SYNOPSIS
    file explorer here
#>
function feh {
    fe "$PWD"
}

<#
.SYNOPSIS
    cd to home folder
#>
function home {
    Set-Location $HOME
}

<#
.SYNOPSIS
    cd to GitHub folder
#>
function gh {
    Set-Location $env:GITHUB
}

<#
.SYNOPSIS
    JupyterLab
#>
function jl {
    py -m jupyterlab
}

<#
.SYNOPSIS
    open startup folder
#>
function startup {
    fe "${env:AppData}\Microsoft\Windows\Start Menu\Programs\Startup\"
}

<#
.SYNOPSIS
    open taskbar folder
#>
function taskbar {
    fe "${env:AppData}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
}

<#
.SYNOPSIS
    VS Code here
#>
function ch {
    code .
}