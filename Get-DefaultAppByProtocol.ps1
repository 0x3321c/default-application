#Requires -Version 2.0

function Get-DefautAppByProtocol {
    <#
    .SYNOPSIS
    Collect the default applications by protocol.
    
    .DESCRIPTION
     
   
    .EXAMPLE

    Get-DefaultAppByProtocol -Hive  HKLM  

    .PARAMETER Hive

    Specifies the root location in the registry
 

    .INPUTS

    None. Cannot pipe objects to the script.

    .OUTPUTS

    Object. This cmdlet returns the item that it creates.

    .LINK
    https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa767914(v=vs.85)

    Registering an Application to a URI Scheme with registry key. It is the former method to do it.

     .LINK
    https://docs.microsoft.com/en-us/windows/uwp/launch-resume/handle-uri-activation
    
    Handle URI activation or Registering an Application to a URI Scheme with xml file. It seems like the fashion method to do it.
    
    .LINK
    https://github.com/egiberne/DefaultApps

    .NOTES

     
    #>
    [CmdletBinding()]
    param (
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

    #Get-Item -Path $registryPath | Where-Object -Property "Property" -EQ "URL Protocol"
    $AppProtocols = Get-Item -Path $registryPath | Select-Object * | Where-Object -Property "Property" -EQ "URL Protocol"
    
    #$isAppPath = Test-Path "$registryPath\shell\open\command"
    

    foreach ($ap in $AppProtocols){
        [string] $AppPath =$ap.Name+"\shell\open\command"
        
        switch -Wildcard ($AppPath) {
            "*USER*" { [string]  $path=$AppPath.Replace("HKEY_CURRENT_USER\","HKCU:") ; $path }
            "*MACHINE*" { [string]  $path=$AppPath.Replace("HKEY_LOCAL_MACHINE\","HKLM:" ) ; $path  }
            Default {[string]  $path=$AppPath.Replace("HKEY_CLASS_ROOT\","HKCR:") ; $path}
        }
        
        [bool]$isAppPath = Test-Path $path
        If($true -eq $isAppPath){
        write-host "AppPath = $path" -ForegroundColor Green
            
        }
    }
} 