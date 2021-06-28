$pwsh = "$env:GITHUB\pwsh"

Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme $pwsh\paradox_custom.omp.json

function load {
    Get-ChildItem $pwsh -Filter *.psm1 | 
    ForEach-Object {
        Write-Output $_.FullName
        Import-Module -Name $_.FullName -Force -Global
    }
}

load

splash