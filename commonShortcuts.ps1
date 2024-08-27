# Function to check if the user account is over 1 hour old
function Check-UserAccountAge {
    $user = [ADSI]"WinNT://$env:COMPUTERNAME/$env:USERNAME, user"
    $creationDate = $user.CreateDate
    $currentDate = Get-Date
    $accountAge = $currentDate - $creationDate

    if ($accountAge.TotalHours -gt 1) {
        exit
    }
}

# Function to create a desktop shortcut
function Create-Shortcut {
    param (
        [string]$targetPath,
        [string]$shortcutName
    )
    $desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "$shortcutName.lnk")
    if (-not (Test-Path $desktopPath)) {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($desktopPath)
        $shortcut.TargetPath = $targetPath
        $shortcut.Save()
        Write-Host "Created shortcut for $shortcutName"
    } else {
        Write-Host "Shortcut for $shortcutName already exists"
    }
}

# Check if the user account is over 1 hour old
Check-UserAccountAge

# Define application paths
$firefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

# Create shortcuts if the applications exist
if (Test-Path $firefoxPath) {
    Create-Shortcut -targetPath $firefoxPath -shortcutName "Firefox"
}

if (Test-Path $chromePath) {
    Create-Shortcut -targetPath $chromePath -shortcutName "Google Chrome"
}

if (Test-Path $edgePath) {
    Create-Shortcut -targetPath $edgePath -shortcutName "Microsoft Edge"
}

# Define the URL and file path for the shortcut
$websiteUrl = "https://support.ultimac.ca"
$websiteShortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "Ultimac Support.lnk")

# Define the path and icon index
$iconPath = "$env:SystemRoot\System32\imageres.dll"
$iconIndex = 24

# Function to create a desktop shortcut
function Create-Shortcut {
    param (
        [string]$targetPath,
        [string]$shortcutName,
        [string]$iconFile,
        [int]$iconIndex
    )
    if (-not (Test-Path $shortcutName)) {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutName)
        $shortcut.TargetPath = $targetPath
        $shortcut.IconLocation = "$iconFile,$iconIndex"
        $shortcut.Save()
        Write-Host "Created shortcut for $shortcutName"
    } else {
        Write-Host "Shortcut for $shortcutName already exists"
    }
}

# Create a shortcut to the website if it does not already exist
Create-Shortcut -targetPath $websiteUrl -shortcutName $websiteShortcutPath -iconFile $iconPath -iconIndex $iconIndex
