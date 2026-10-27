param(
    [ValidateSet("verify", "benchmark", "stress")]
    [string] $Action = "verify",
    [ValidateSet(2, 3, 4, 5, 6, 7, 8)]
    [int] $Lut = 4
)

$ErrorActionPreference = "Stop"
$ProjectDir = (Resolve-Path "$PSScriptRoot\..").Path
$Yosys = Join-Path $ProjectDir "tools\yosys\yosys.exe"

if (-not (Test-Path -LiteralPath $Yosys)) {
    throw "Bundled Yosys was not found at $Yosys"
}

Push-Location $ProjectDir
try {
    switch ($Action) {
        "verify" {
            & "$PSScriptRoot\verify.ps1" -Yosys $Yosys
        }
        "benchmark" {
            & "$ProjectDir\tests\run_competition.ps1" -Yosys $Yosys -Lut $Lut
        }
        "stress" {
            $stress = Join-Path $ProjectDir "build\pmux_stress.v"
            if (-not (Test-Path -LiteralPath $stress)) {
                throw "Stress input was not found at $stress"
            }
            $stress = $stress.Replace("\", "/")
            $stopwatch = [Diagnostics.Stopwatch]::StartNew()
            & $Yosys -p "read_verilog -sv `"$stress`"; synth -top pmux_stress -run begin:fine; opt -fast -full; memory_map; opt -full; pmux_opt -abc -lut $Lut; opt -fast; stat"
            $stopwatch.Stop()
            Write-Host ("Stress run completed in {0:N2} seconds." -f $stopwatch.Elapsed.TotalSeconds)
        }
    }

    if ($LASTEXITCODE -ne 0) {
        throw "Project action '$Action' failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
