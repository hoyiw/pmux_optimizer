param(
    [Parameter(Mandatory = $true)]
    [string] $YosysBuildDir,
    [string] $BuildDir = "$PSScriptRoot\..\build",
    [ValidateSet("Debug", "Release", "RelWithDebInfo")]
    [string] $Configuration = "Release"
)

$ErrorActionPreference = "Stop"
$ProjectDir = (Resolve-Path "$PSScriptRoot\..").Path
$YosysBuildDir = (Resolve-Path $YosysBuildDir).Path
$BuildDir = [IO.Path]::GetFullPath($BuildDir)

$cmake = Get-Command cmake -ErrorAction SilentlyContinue
if (-not $cmake) {
    $cmake = Get-ChildItem `
        "C:\Program Files\Microsoft Visual Studio" `
        -Recurse -Filter cmake.exe -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match "CommonExtensions\\Microsoft\\CMake" } |
        Select-Object -First 1
}
if (-not $cmake) {
    throw "cmake.exe was not found."
}

& $cmake.Source `
    -S $ProjectDir `
    -B $BuildDir `
    -G "Visual Studio 17 2022" `
    -A x64 `
    "-DYOSYS_BUILD_DIR=$YosysBuildDir"

& $cmake.Source --build $BuildDir --config $Configuration

$plugin = Get-ChildItem $BuildDir -Filter "pmux_opt.*" -Recurse |
    Where-Object { $_.Extension -in @(".dll", ".so", ".dylib") } |
    Select-Object -First 1
Write-Host "Plugin: $($plugin.FullName)"
