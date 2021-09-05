Set-Alias d deactivate

<#
.SYNOPSIS
    delete a venv
#>
function delvenv {

    param (
        [Parameter(Mandatory)]
        [String]
        $name
    )

    Remove-Item (Join-Path $venv $name) -Recurse -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $venv "$name.desc") -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
    list available venvs / show venv description
#>
function helpvenv {

    param (
        [String]
        $name
    )

    if ($PSBoundParameters.ContainsKey('name')) {
        Get-Content (Join-Path $venv "$name.desc") -ErrorAction SilentlyContinue
        return
    }

    Get-ChildItem $venv -Directory | ForEach-Object {
        $description = Get-Content (Join-Path $venv "$($_.Name).desc") -ErrorAction SilentlyContinue
        Write-Output "[95m$($_.Name)[0m $description"
    }
}

<#
.SYNOPSIS
    create venv in venv folder
#>
function venv {

    param (
        [Parameter(Mandatory)]
        [String]
        $name,
        [String]
        $description,
        [String]
        $version = 3 # python version
    )

    $current = $PWD
    Set-Location $venv
    venvh -name $name -version $version
    Set-Location $current

    if ($PSBoundParameters.ContainsKey('description')) {
        Write-Output $description > (Join-Path $venv $name.desc)
    }
}

<#
.SYNOPSIS
    venv activate
#>
function venva {

    param (
        [Parameter(Mandatory)]
        [String]
        $name
    )

    & (Join-Path $venv $name Scripts Activate.ps1)
}

<#
.SYNOPSIS
    venv activate here
#>
function venvah {

    param (
        [String]
        $name = 'env'
    )

    & (Join-Path $name Scripts Activate.ps1)
}

<#
.SYNOPSIS
    create venv here
#>
function venvh {

    param (
        [String]
        $name = 'env',
        [String]
        $version = 3 # python version
    )

    py -$version -m venv $name

    venvah $name
}
<#
.SYNOPSIS
    open venv folder in wt
#>

function wherevenv {
    wt -w 0 nt -d $venv
}