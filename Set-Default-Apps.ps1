$extension = Read-Host "Enter the file extension (without the dot):"
$application = Read-Host "Enter the path to the default application:"

# Check if the provided application exists
if (-not (Test-Path -Path $application)) {
    Write-Host "The specified application path does not exist."
    exit
}

# Define the default application for the extension
$progId = "CustomProgId.$extension"

# Create a new ProgId key for the extension
$regPath = "HKCU:\Software\Classes\$progId"
New-Item -Path $regPath -Force | Out-Null

# Set the default value of the ProgId key to the extension
Set-ItemProperty -Path $regPath -Name "(Default)" -Value $extension

# Create the Open command key and set the application as the default handler
$openCommandPath = "$regPath\shell\open\command"
New-Item -Path $openCommandPath -Force | Out-Null
Set-ItemProperty -Path $openCommandPath -Name "(Default)" -Value "`"$application`" `"%1`""

Write-Host "Default application set for '.$extension' files."
