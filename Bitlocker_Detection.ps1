<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)
.SYNOPSIS
This script can be used to Detect Bitlocker encryption is 128 bit for Laptop only.
.DESCRIPTION
This script can be used to Detect Bitlocker encryption is 128 bit for Laptop only.
.EXAMPLE
C:\PS> C:\Script\BitlockerDetection.ps1
To Detect Bitlocker encryption is 128 bit.
#>

#Function to create log file

function Write-Log
{
   Param ([string]$LogString)

   $LogFile = "C:\Windows\Temp\BitlockerStateDetection.log"

   $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)

   $LogMessage = "$Datetime $LogString"

   Add-content $LogFile -value $LogMessage
}

#checking if device is Laptop or Desktop
$hardwareType = (Get-WmiObject -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType

if(($hardwareType -ne $null) -and ($hardwareType -eq 2))
{
    Write-Log "******** Device has PCSystemType = `"$hardwareType`" ********"
    
    $encrypMethod = (Get-BitLockerVolume -MountPoint C:).EncryptionMethod

    Write-Log "******** Encryption Method is: `"$encrypMethod`" ********"

    $bStatus = (Get-CimInstance -ClassName Win32_Battery).BatteryStatus
    Write-Log "******** Battery Status is: `"$bStatus`" ********"

    if(($encrypMethod -Like '*128') -and ($bStatus -eq 2))
    {
        Write-Log "******** Encryption Method is: `"$encrypMethod`" and Power cable is connected so exiting for remediation script to run ********"
        Exit 1
    }
    Else
    {
        Write-Log "******** Either Encryption Method is `"256 bit`" or Power cable is not connected. ********"
        Exit 0
    }
}
Else
{
    Write-Log "******** Device is not Laptop, so skipping this action ********"
    Exit 0
}
