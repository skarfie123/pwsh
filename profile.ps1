$skarfie123 = "$env:GITHUB\skarfie123"
$pwsh = "$skarfie123\pwsh"
$venv = "${env:USERPROFILE}\venv"
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme $pwsh\paradox_custom.omp.json

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
}

load

splash