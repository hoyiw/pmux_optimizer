param(
    [Parameter(Mandatory = $true)]
    [string] $Yosys,
    [string] $Plugin = "",
    [ValidateSet(2, 3, 4, 5, 6, 7, 8)]
    [int] $Lut = 4
)

$ErrorActionPreference = "Stop"
$ProjectDir = (Resolve-Path "$PSScriptRoot\..").Path
$rows = foreach ($test in 1..4) {
    $verilog = Join-Path $ProjectDir "tests\competition_case\test$test\test$test.v"
    $arguments = @{
        Yosys = $Yosys
        Verilog = $verilog
        Top = "test$test"
        Lut = $Lut
    }
    if ($Plugin) {
        $arguments.Plugin = $Plugin
    }
    & (Join-Path $ProjectDir "scripts\benchmark.ps1") @arguments
}

$rows | Format-Table -AutoSize

$buildDir = Join-Path $ProjectDir "build"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
$rows | Export-Csv -Path (Join-Path $buildDir "competition_results.csv") `
    -NoTypeInformation -Encoding utf8
