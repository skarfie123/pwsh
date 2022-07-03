if (-not(Test-Path variable:env:GITHUB)) {
    $env:GITHUB = Join-Path $HOME GitHub
}
$skarfie123 = Join-Path $env:GITHUB skarfie123
$pwsh = Join-Path $skarfie123 pwsh
$venv = Join-Path $HOME venv
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

if ($IsLinux){
    $env:PATH = $env:PATH+":/home/linuxbrew/.linuxbrew/bin"
}

Import-Module posh-git
oh-my-posh init pwsh --config (Join-Path $pwsh paradox_custom.omp.json) | Invoke-Expression

Set-PSReadLineOption -PredictionSource History -Colors @{
    Operator         = "`e[38;5;208m"
    Parameter        = "`e[38;5;208m"
    InlinePrediction = "`e[48;5;4m"
}
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

function load {

    [CmdletBinding()]
    param (
    )

    Get-ChildItem $pwsh -Filter *.psm1 | 
    ForEach-Object {
        Write-Verbose "[91m$($_.BaseName)[0m"
        Import-Module -Name $_.FullName -Force -Global
    }

    load_secret
}

load

if ($IsMacOS) {
    $(/usr/local/bin/brew shellenv) | Invoke-Expression
}

$env:PATH += (Join-Path $HOME .local bin)

splash
