﻿<#
.SYNOPSIS
    git add
#>
function ga {
    git add $args
}

<#
.SYNOPSIS
    git add all
#>
function gaa {
    git add -A
}

<#
.SYNOPSIS
    git branch
#>
function gb {

    [CmdletBinding()]
    param (
        [String]
        $branch
    )

    if ($PSBoundParameters.ContainsKey('branch')) {
        git checkout -b $branch
    }
    else {
        gbl
    }
    
}

<#
.SYNOPSIS
    git branch delete
#>
function gbd {
    git branch -d $args
}

<#
.SYNOPSIS
    git branch DELETE
#>
function gbdd {
    git branch -D $args
}

<#
.SYNOPSIS
    git branch list
#>
function gbl {
    git branch -l
}

Remove-Alias gc -Force -ErrorAction SilentlyContinue
Set-Alias gco Get-Content
<#
.SYNOPSIS
    git commit
#>
function gc {
    git commit -m $args
}

<#
.SYNOPSIS
    git commit all (adds all tracked)
#>
function gca {
    git commit -a -m $args
}

<#
.SYNOPSIS
    git commit add all (adds all tracked and untracked)
#>
function gcaa {
    git add -A
    git commit -m $args
}

<#
.SYNOPSIS
    `gcaa` then push
#>
function gcaap {
    git add -A
    git commit -m $args
    git push
}

<#
.SYNOPSIS
    `gca` then push
#>
function gcap {
    git commit -a -m $args
    git push
}

<#
.SYNOPSIS
    git checkout
#>
function gch {
    git checkout $args
}

<#
.SYNOPSIS
    git checkout main
#>
function gchm {
    git checkout main
}

<#
.SYNOPSIS
    git clone
#>
function gcl {
    git clone $args
}

Remove-Alias gcm -Force -ErrorAction SilentlyContinue
Set-Alias gcom Get-Command
<#
.SYNOPSIS
    git commit amend
#>
function gcm {

    param (
        [Parameter(Mandatory)]
        [String]
        $message
    )

    git commit -m $message --amend  
}

<#
.SYNOPSIS
    `gc` then push
#>
function gcp {
    git commit -m $args
    git push
}

<#
.SYNOPSIS
    git commit undo
#>
function gcu {
    git reset --soft HEAD~1
}

<#
.SYNOPSIS
    git diff
#>
function gd {
    git diff $args
}

Remove-Alias gl -Force -ErrorAction SilentlyContinue
Set-Alias glo Get-Location
<#
.SYNOPSIS
    git log
#>
function gl {
    git log $args
}

Remove-Alias gp -Force -ErrorAction SilentlyContinue
Set-Alias gpr Get-ItemProperty
<#
.SYNOPSIS
    git pull
#>
function gp {
    git pull
}

<#
.SYNOPSIS
    git push
#>
function gpu {
    git push
}

<#
.SYNOPSIS
    git status
#>
function gs {
    git status $args
}

<#
.SYNOPSIS
    git status all (`gs` in each subfolder)
#>
function gsa {

    [CmdletBinding()]
    param (
    )

    Write-Output ''
    Get-ChildItem -Directory | ForEach-Object {
        $name = $_.Name
        if (Test-Path (Join-Path $name '.gsa_ignore')) {
            Write-Verbose "Ignored $name"
            return
        }

        Set-Location $name
        if (@(git status -s 2>&1).Count -ne 0) {
            Write-Output "[92m${name}:[0m"
            git status -s 2>&1
            invisiblePause
            Write-Output ''
        }
        else {
            Write-Verbose "[92m${name}[0m"
        }
        Set-Location ..
    }
}