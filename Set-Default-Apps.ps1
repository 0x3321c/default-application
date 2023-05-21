$extension = Read-Host "Enter the file extension (without the dot):"
$apppath = Read-Host "Enter the path to the default application:"
$EXT = $extension.ToUpper()

if (-not (Test-Path -Path $application)) { Write-Host "The specified application path does not exist."; exit }

$executable=$apppath.Split("\")[-1]
$app=$executable.Split(".")[0]

$customProgId = "$app.$extension"
$regPath = "HKCU:\Software\Classes\$customProgId"
$regPathHKLM = "HKLM:\Software\Classes\$customProgId"

$regPathEXT = "HKCU:\Software\Classes\.$extension"
$regPathEXTHKLM = "HKLM:\Software\Classes\.$extension"

# Create ProgId registry keys
New-Item -Path $regPathEXT -Force | Out-Null
New-Item -Path $regPathHKLM -Force | Out-Null

# Create Extension registry keys
New-Item -Path $regPath -Force | Out-Null
New-Item -Path $regPathEXTHKLM -Force | Out-Null

# Set the default value of the ProgId keys to the extension
Set-ItemProperty -Path $regPath -Name "(Default)" -Value "$EXT Source File" 
Set-ItemProperty -Path $regPathHKLM -Name "(Default)" -Value "$EXT Source File" 

# Set OpenWithProgids for the extension
$openWithProgids = @{
    $customProgId = ''
}

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$extension\OpenWithProgids" -Force | Out-Null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$extension\OpenWithList" -Force | Out-Null

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$extension\OpenWithList" -Name "a" -Value $executable
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$extension\OpenWithList" -Name "MRUList" -Value "a"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$extension\OpenWithProgids" -Name $extension -Value ""
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$extension\OpenWithProgids" -Name $customProgId -Value ""

# Create the Open command key and set the application as the default handler
$openCommandPath = "$regPath\shell\open\command"
$openCommandPathHKLM = "$regPathHKLM\shell\open\command"

New-Item -Path $openCommandPath -Force | Out-Null
New-Item -Path $openCommandPathHKLM -Force | Out-Null

Set-ItemProperty -Path $openCommandPath -Name "(Default)" -Value "`"$application`" `"%1`""
Set-ItemProperty -Path $openCommandPathHKLM -Name "(Default)" -Value "`"$application`" `"%1`""

Write-Host "Default application set for '.$extension' files."
