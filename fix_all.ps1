# fix_all.ps1 - Complete Environment Fix for FluxMarket Flutter Project
# Run as Administrator: Right-click PowerShell -> "Run as Administrator"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FluxMarket Environment Fix Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Define the target JDK path
$JdkPath = "C:\Program Files\Java\jdk-23"
$JdkBinPath = "$JdkPath\bin"

# Check if JDK directory exists
if (-not (Test-Path $JdkPath)) {
    Write-Host "ERROR: JDK path not found: $JdkPath" -ForegroundColor Red
    Write-Host "Please verify the JDK is installed at this location." -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/3] Setting JAVA_HOME to: $JdkPath" -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JdkPath, "Machine")
Write-Host "JAVA_HOME set successfully" -ForegroundColor Green

# Step 2: Clean and update System PATH
Write-Host "[2/3] Updating System PATH..." -ForegroundColor Yellow

# Get current system PATH
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Split PATH into individual entries
$PathEntries = $CurrentPath -split ';' | Where-Object { $_ -ne '' }

# Remove entries containing "Eclipse Foundation" or "Java 8"
$FilteredEntries = $PathEntries | Where-Object {
    $_ -notmatch "Eclipse Foundation" -and
    $_ -notmatch "jdk-8" -and
    $_ -notmatch "Java 8"
}

# Prepend JDK bin to the beginning
$NewPathEntries = @($JdkBinPath) + $FilteredEntries
$NewPath = $NewPathEntries -join ';'

# Set the new system PATH
[Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
Write-Host "PATH updated successfully" -ForegroundColor Green

# Step 3: Verify changes
Write-Host "[3/3] Verification:" -ForegroundColor Yellow
$NewJavaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine")
$NewPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

Write-Host "JAVA_HOME: $NewJavaHome" -ForegroundColor Cyan
Write-Host "PATH starts with: $($NewPath -split ';' | Select-Object -First 3 | ForEach-Object { $_ })" -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "SUCCESS! Environment variables updated." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: Close ALL terminals and open a NEW terminal." -ForegroundColor Yellow
Write-Host "Then run: java -version" -ForegroundColor Cyan
Write-Host "Expected: openjdk version \"23\"" -ForegroundColor Cyan