param (
    [string]$url
)

# Validate input
if (-not $url) {
    echo "Error: No URL provided. Use -url <download_url>" -ForegroundColor Red
    Exit 1
}

# Enable TLS 1.2 to avoid potential download issues
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Extract the filename from the URL dynamically
$fileName = $url -split "/" | Select-Object -Last 1
$filePath = "$env:TEMP\$fileName"
$logFile = "$env:TEMP\install.log"

# Try downloading the file
try {
    echo "Downloading MSI from $url ..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $filePath -UseBasicParsing
    echo "Download completed: $filePath" -ForegroundColor Green
} catch {
    echo "Download failed: $_" -ForegroundColor Red
    Exit 1
}

# Verify file exists before proceeding
if (Test-Path $filePath) {
    echo "Installing MSI silently..." -ForegroundColor Cyan
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$filePath`" ALLUSERS=1 /qn /norestart /log `"$logFile`"" -Wait -NoNewWindow
    echo "Installation completed." -ForegroundColor Green

    # Optionally, delete the installer
    Remove-Item $filePath -Force
} else {
    echo "Installation file not found!" -ForegroundColor Red
    Exit 1
}
