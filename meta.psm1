<#
.SYNOPSIS
    Check for pwsh and ahk
.DESCRIPTION
    Check all modules included in readme, then check all functions in all modules have documentation, then check all ahk files included in readme
#>
function check {
    [CmdletBinding()]
    param (
    )
    ForEach-Object { checkReadme -folder pwsh -filetype psm1; checkFunctions; checkReadme -folder AHK -filetype ahk } | more
}

<#
.SYNOPSIS
    Check all functions in pwsh modules have SYNOPSIS comment
#>
function checkFunctions {

    [CmdletBinding()]
    param (
    )

    load 2>&1 | Out-Null
        
    Get-ChildItem $pwsh -Filter *.psm1 | 
    ForEach-Object {
        
        $positive = 0
        $negative = 0
        $module = Split-Path -Path $_.FullName -LeafBase
        Write-Output ''
        Get-Command -Module $module | 
        ForEach-Object {
            $help = help $_.Name
            $synopsis_matches = $help | Select-String -Pattern 'SYNOPSIS'
            if ($synopsis_matches.Matches.Count -eq 0 -or (Get-Command $_.Name).definition.Trim().Length -eq 0) {
                $negative++
                Write-Output "[91m$_[0m"
            }
            else {
                $positive++
                Write-Verbose "[92m$_[0m"
            }
        }
        Write-Output "[93m${module}:[0m [92m$positive[0m - [91m$negative[0m"
    }

    
}

<#
.SYNOPSIS
    Check README.md includes all files
.DESCRIPTION
    For specified repo and file type, check all files are included in the README.md
.EXAMPLE
    PS C:\> checkReadme -folder pwsh -filetype psm1
    Check for *,psm1 in pwsh repo
#>
function checkReadme {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $folder,
        [String]
        $filetype
    )
    if ( -Not $PSBoundParameters.ContainsKey('filetype') ) {
        $filetype = $folder
    }

    Write-Output ''

    $positive = 0
    $negative = 0

    Get-ChildItem "$env:GITHUB\$folder" -Filter *.$filetype | 
    ForEach-Object {
        $file = Split-Path -Path $_.FullName -Leaf
        if ((Select-String -Path $env:GITHUB\$folder\README.md -Pattern "$file").Matches.Count -eq 0) {
            $negative++
            Write-Output "[91m$file[0m"
        }
        else {
            $positive++
            Write-Verbose "[92m$file[0m"
        }
    }

    Write-Output "[95m${folder}:[0m [92m$positive[0m - [91m$negative[0m"
    
}


<#
.SYNOPSIS
    Copies PowerShell profile from pwsh repo
#>
function copyProfile {
    Copy-Item -Path $pwsh\profile.ps1 -Destination $profile.CurrentUserAllHosts
}

<#
.SYNOPSIS
    Edit custom pwsh modules
.DESCRIPTION
    sdfom
.EXAMPLE
    PS C:\> edit
    Open whole pwsh repo
.EXAMPLE
    PS C:\> edit meta
    Open meta.psm1
.EXAMPLE
    PS C:\> edit new
    Creates and opens new.psm1
#>
function edit {
    param (
        [String]
        $module # module to edit
    )
    if ($PSBoundParameters.ContainsKey('module')) {
        code $pwsh\$module.psm1
    }
    else {
        code $pwsh
    }
}

<#
.SYNOPSIS
    Edit the PowerShell profile
#>
function editprofile {
    code $profile.CurrentUserAllHosts
}

<#
.SYNOPSIS
    List executables in pwsh folder
#>
function helpexe {
    Get-ChildItem $pwsh *.exe
}

<#
.SYNOPSIS
    Print code for function
.EXAMPLE
    PS C:\> morepwsh reload
    Print code for reload function
#>
function morepwsh {
    param (
        [Parameter(Mandatory)]
        [String]
        $function # function to print
    )
    (Get-Command $function).definition
}

<#
.SYNOPSIS
    Open the PowerShell profile location
#>
function whereprofile {
    Start-Process (Split-Path -Parent $profile.CurrentUserAllHosts)
}

<#
.SYNOPSIS
    Opens the pwsh GitHub folder
#>
function wherepwsh {
    wt -w 0 nt -d $pwsh
}