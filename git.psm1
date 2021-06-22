<#
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

Remove-Alias gc -Force
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
    git checkout %*
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
    git clone %*
}

Remove-Alias gcm -Force
Set-Alias gcom Get-Command
<#
.SYNOPSIS
    git commit amend
#>
function gcm {
    git commit -m %1 --amend  
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

Remove-Alias gl -Force
Set-Alias glo Get-Location
<#
.SYNOPSIS
    git log
#>
function gl {
    git log $args
}

Remove-Alias gp -Force
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
        Set-Location $name
        if (@(git status -s 2>&1).Count -ne 0) {
            Write-Output "[92m${name}:[0m"
            git status -s 2>&1
            Pause
            Write-Output '[1A[2K[1A' ''
        }
        else {
            Write-Verbose "[92m${name}:[0m"
        }
        Set-Location ..
    }
}