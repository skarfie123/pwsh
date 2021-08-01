$pwsh = "$env:GITHUB\pwsh"
$venv = "${env:USERPROFILE}\venv"
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme $pwsh\paradox_custom.omp.json

Set-PSReadLineOption -PredictionSource History

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