Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme $env:GITHUB\pwsh\paradox_custom.omp.json

function load {
    Get-ChildItem "$env:GITHUB\pwsh" -Filter *.psm1 | 
    ForEach-Object {
        Write-Output $_.FullName
        Import-Module -Name $_.FullName -Force -Global
    }
}

load

splash