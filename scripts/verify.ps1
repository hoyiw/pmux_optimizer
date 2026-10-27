param(
    [Parameter(Mandatory = $true)]
    [string] $Yosys,
    [string] $Plugin = ""
)

$ErrorActionPreference = "Stop"
$ProjectDir = (Resolve-Path "$PSScriptRoot\..").Path
$loadArgs = @()
if ($Plugin) {
    $loadArgs = @("-m", (Resolve-Path $Plugin).Path)
}

Push-Location $ProjectDir
try {
    & $Yosys @loadArgs -s tests/equivalence.ys
    if ($LASTEXITCODE -ne 0) {
        throw "Equivalence verification failed with exit code $LASTEXITCODE."
    }
    & $Yosys @loadArgs -s tests/equivalence_mapped.ys
    if ($LASTEXITCODE -ne 0) {
        throw "Mapped equivalence verification failed with exit code $LASTEXITCODE."
    }
    & $Yosys @loadArgs -s tests/competition_equivalence.ys
    if ($LASTEXITCODE -ne 0) {
        throw "Competition-case equivalence verification failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

Write-Host "All tests passed."
