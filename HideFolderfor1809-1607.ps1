<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)

This script will hide folders for Windows 1809-1607. This also has unhide command but it is commented.
#>

#Log function to create log
function WriteLog{  
  
Param ([string]$LogString)    
$LogFile = "C:\Windows\Temp\REGN_HideFolderfor1809-1607_v1.0.log"    
$DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)    
$LogMessage = "$Datetime $LogString"    
Add-content $LogFile -value $LogMessage
}

#Hiding folder for DEV Environment
WriteLog "**************** Checking for DEV Folder ****************"

$FolDEV="$env:ProgramData\Microsoft\Windows\Start Menu\Programs\AnyFolder"
if($FolDEV -ne $null)
{
    if(Test-Path -Path $FolDEV)
    {
        $F_DEV=Get-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\AnyFolder" -Force -ErrorAction SilentlyContinue
        WriteLog "**************** DEV Folder Found, so hiding it ****************"
        $F_DEV.Attributes = 'Hidden'
        WriteLog "**************** DEV Folder hidden successfully ****************"
    }
}

#Unhide folder
#$Folder.Attributes = $Folder.Attributes -bxor [System.IO.FileAttributes]::Hidden