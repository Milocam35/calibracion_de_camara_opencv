# Run this script as Administrator
# Setup OpenCV + MinGW environment for calibracion project

Write-Host "Installing MinGW (C++ compiler)..." -ForegroundColor Cyan
choco install mingw -y

Write-Host "Installing OpenCV 4.x..." -ForegroundColor Cyan
choco install opencv -y

# OpenCV installs to C:\tools\opencv by default
$opencvDir = "C:\tools\opencv\build"
if (-not (Test-Path $opencvDir)) {
    Write-Host "OpenCV not found at $opencvDir - check choco install output above" -ForegroundColor Red
    exit 1
}

Write-Host "Adding MinGW and OpenCV bin to PATH for this session..." -ForegroundColor Cyan
$mingwBin = (Get-ChildItem "C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin" -ErrorAction SilentlyContinue)?.FullName
if ($mingwBin) {
    $env:PATH += ";$mingwBin"
}
$env:PATH += ";$opencvDir\x64\mingw\bin"

Write-Host "Building project with CMake + MinGW..." -ForegroundColor Cyan
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildDir = Join-Path $projectDir "build"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
Set-Location $buildDir

cmake .. -G "MinGW Makefiles" "-DOpenCV_DIR=$opencvDir\x64\mingw\lib"
mingw32-make

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful! Run: .\build\calibracion.exe" -ForegroundColor Green
} else {
    Write-Host "Build failed." -ForegroundColor Red
}
