#Requires -Version 2.0

function Get-DefautAppByProtocol {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false  )] [string]$AppName,
        [Parameter(Mandatory=$false  )] [string]$AppScheme,
        [Parameter(Mandatory=$false  )] [string]$AppPath, 
        [Parameter(Mandatory=$true  )] [ValidateSet('HKCR', 'HKLM', 'HKCU')][string]$Hive
    )

    #Create a registry drive for the HKEY_CLASSES_ROOT registry hive
    switch ($Hive) {
        HKLM { $registryPath = "HKLM:SOFTWARE\Classes\*" }
        HKCU { $registryPath = "HKCU:SOFTWARE\Classes\*" }
        Default { 
            New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
            $registryPath = "HKCR:\*"
        }
    }

    Get-Item -Path $registryPath | Where-Object -Property "Property" -EQ "URL Protocol"
    Get-Item -Path $registryPath | Select-Object * | Where-Object -Property "Property" -EQ "URL Protocol"
    
     
} 