# fix_java_path.ps1
# PowerShell script to fix JAVA_HOME and PATH for Flutter development
# Run as Administrator: Right-click PowerShell -> "Run as Administrator"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Java Environment Fix Script" -ForegroundColor Cyan
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

Write-Host "Target JDK found: $JdkPath" -ForegroundColor Green

# Step 1: Set JAVA_HOME system environment variable
Write-Host "`n[1/3] Setting JAVA_HOME system environment variable..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JdkPath, "Machine")
Write-Host "JAVA_HOME set to: $JdkPath" -ForegroundColor Green

# Step 2: Update System PATH
Write-Host "`n[2/3] Updating System PATH..." -ForegroundColor Yellow

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

# Check if JDK bin is already in the filtered path
$JdkAlreadyInPath = $FilteredEntries | Where-Object { $_ -eq $JdkBinPath }

# Prepend JDK bin to the beginning if not already present
if (-not $JdkAlreadyInPath) {
    $NewPathEntries = @($JdkBinPath) + $FilteredEntries
} else {
    $NewPathEntries = $FilteredEntries
}

# Join the path entries back
$NewPath = $NewPathEntries -join ';'

# Set the new system PATH
[Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
Write-Host "PATH updated successfully" -ForegroundColor Green

# Step 3: Verify changes
Write-Host "`n[3/3] Verification:" -ForegroundColor Yellow
$NewJavaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine")
$NewPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

Write-Host "JAVA_HOME: $NewJavaHome" -ForegroundColor Cyan
Write-Host "PATH starts with: $($NewPath -split ';' | Select-Object -First 3 | ForEach-Object { $_ })" -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "SUCCESS! Changes applied to system environment." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: You must restart your terminal/IDE for changes to take effect." -ForegroundColor Yellow
Write-Host "After restart, run: java -version" -ForegroundColor Cyan
Write-Host "Expected output: openjdk version \"23\" or similar" -ForegroundColor Cyan