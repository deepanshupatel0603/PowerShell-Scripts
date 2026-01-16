<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)
.SYNOPSIS
This script can be used to get all local Admins from device.
.DESCRIPTION
This script can be used to get all local Admins from device.
.EXAMPLE
C:\PS> C:\Script\GatherLocalAdministrators.ps1
Create a file which has all local Admins from device.
#>

############################     Main program    #########################################

if(!(Test-Path -Path "C:\Windows\Temp\AWS_LocalAdminUsers"))
{
    #If "C:\Windows\Temp\AWS_LocalAdminUsers" is not available creating it
    New-Item -Path "C:\Windows\Temp" -Name 'AWS_LocalAdminUsers' -ItemType Directory -Force
}

if(!(Test-Path -Path "C:\Windows\Temp\LocalAdminUsers"))
{
    #If "C:\Windows\Temp\LocalAdminUsers" is not available creating it
    New-Item -Path "$env:SystemDrive\Windows\Temp" -Name "LocalAdminUsers" -ItemType "Directory" -Force
}

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$CName = $env:computername
$TempLogFile = "$env:SystemDrive\Windows\Temp\LocalAdminUsers"

$addTxt = "$TempLogFile\addTxt.txt"
$t = "$TempLogFile\$cname.csv"

Remove-Item -Path "$TempLogFile\$CName.txt" -ErrorAction SilentlyContinue
Remove-Item -Path $addTxt -ErrorAction SilentlyContinue
Remove-Item -Path $t -ErrorAction SilentlyContinue

Start-Process -FilePath "$env:SystemDrive\Windows\System32\cmd.exe" -ArgumentList "/c net localgroup administrators > `"$TempLogFile\$CName.txt`"" -WindowStyle Hidden -Wait

$NActual = Get-Content "$TempLogFile\$CName.txt"
New-Item -Path "$scriptPath\Files" -Name "addTxt.txt" -ItemType "file" -Force
ForEach ($line in $NActual)
{
    If (($line -match "Alias name") -or ($line -match "Comment") -or ($line -match "Members") -or ($line -match "-------") -or ($line -match "The command completed"))
    {
       # "Line Content: $line" | Add-Content $LogFile #Do Nothing
    }
    Else
    {
        $FaddTxt = "$line,"
        If ($FaddTxt -contains ",")
        {
            # Do nothing as it is a blank line
        }
        Else
        {
            $FaddTxt | Add-Content $addTxt
        }

    }
}
#Remove-Item "$TempLogFile\$CName.txt"
$NFinal = Get-Content $addTxt


$Final = $CName + "," + $NFinal
$Final | Add-Content $t

Start-Sleep -Seconds 5
$destloc = "C:\Windows\Temp\AWS_LocalAdminUsers\$cname.csv"

DO{
    Copy-Item "$t" -Destination "C:\Windows\Temp\AWS_LocalAdminUsers\" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 30
  } Until (Test-Path -Path $destloc)

# Remove-Item $addTxt

# "######################################### $(Get-Date) - Execution completed ##################################" | Add-Content $LogFile