param(
    [Parameter(Mandatory = $true)]
    [string] $Yosys,
    [string] $Plugin = "",
    [Parameter(Mandatory = $true)]
    [string] $Verilog,
    [Parameter(Mandatory = $true)]
    [string] $Top,
    [ValidateSet(2, 3, 4, 5, 6, 7, 8)]
    [int] $Lut = 4
)

$ErrorActionPreference = "Stop"
$ProjectDir = (Resolve-Path "$PSScriptRoot\..").Path
$Verilog = (Resolve-Path $Verilog).Path -replace '\\', '/'
$loadArgs = @()
if ($Plugin) {
    $loadArgs = @("-m", (Resolve-Path $Plugin).Path)
}

$baseline = & $Yosys @loadArgs -p "read_verilog -sv `"$Verilog`"; synth -top $Top; stat" 2>&1
if ($LASTEXITCODE -ne 0) {
    $baseline | Write-Host
    throw "Baseline synthesis failed."
}

$optimized = & $Yosys @loadArgs -p "read_verilog -sv `"$Verilog`"; synth -top $Top -run begin:fine; opt -fast -full; memory_map; opt -full; pmux_opt -abc -lut $Lut; opt -fast; stat" 2>&1
if ($LASTEXITCODE -ne 0) {
    $optimized | Write-Host
    throw "PMUX optimization failed."
}

function Get-FinalCellCount([object[]] $Log) {
    $matches = [regex]::Matches(($Log -join "`n"), '(?m)^\s+(\d+) cells\s*$')
    if ($matches.Count -eq 0) {
        throw "Could not parse the final cell count."
    }
    return [int] $matches[$matches.Count - 1].Groups[1].Value
}

$baselineCells = Get-FinalCellCount $baseline
$candidateCells = Get-FinalCellCount $optimized
$selectedCells = [math]::Min($baselineCells, $candidateCells)
$selectedFlow = if ($candidateCells -lt $baselineCells) { "pmux_opt" } else { "default fallback" }
$reduction = 100.0 * ($baselineCells - $selectedCells) / $baselineCells

[pscustomobject]@{
    top = $Top
    lut_size = $Lut
    baseline_cells = $baselineCells
    pmux_candidate_cells = $candidateCells
    selected_cells = $selectedCells
    selected_flow = $selectedFlow
    reduction_percent = [math]::Round($reduction, 2)
}
