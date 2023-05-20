$extension = Read-Host "Enter the file extension (without the dot):"
$application = Read-Host "Enter the path to the default application:"

if (-not (Test-Path -Path $application)) { Write-Host "The specified application path does not exist."; exit }

$customProgId = "CustomProgId.$extension"
$regPath = "HKCU:\Software\Classes\$customProgId"
$regPathHKLM = "HKLM:\Software\Classes\$customProgId"

# Create ProgId registry keys
New-Item -Path $regPath -Force | Out-Null
New-Item -Path $regPathHKLM -Force | Out-Null

# Set the default value of the ProgId keys to the extension
Set-ItemProperty -Path $regPath -Name "(Default)" -Value $extension
Set-ItemProperty -Path $regPathHKLM -Name "(Default)" -Value $extension

# Create the Open command key and set the application as the default handler
$openCommandPath = "$regPath\shell\open\command"
$openCommandPathHKLM = "$regPathHKLM\shell\open\command"

New-Item -Path $openCommandPath -Force | Out-Null
New-Item -Path $openCommandPathHKLM -Force | Out-Null

Set-ItemProperty -Path $openCommandPath -Name "(Default)" -Value "`"$application`" `"%1`""
Set-ItemProperty -Path $openCommandPathHKLM -Name "(Default)" -Value "`"$application`" `"%1`""

Write-Host "Default application set for '.$extension' files."
