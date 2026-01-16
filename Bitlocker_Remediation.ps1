<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)
.SYNOPSIS
This script can be used to Remediate Bitlocker to 256 bit encryption.
.DESCRIPTION
This script can be used to Remediate Bitlocker to 256 bit encryption.
.EXAMPLE
C:\PS> C:\Script\Bitlocker_Remediation.ps1
To Remediate Bitlocker to 256 bit encryption.
#>

#Create log file using PS1

function Write-Log
{
   Param ([string]$LogString)

   $LogFile = "C:\Windows\Temp\BitlockerStateRemediation.log"

   $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)

   $LogMessage = "$Datetime $LogString"

   Add-content $LogFile -value $LogMessage
}

Write-Log "******** Decryption started, as detection script found that Encryption State is 128 bit ********"

#Start-Process -FilePath "powershell.exe" -ArgumentList "Suspend-BitLocker -MountPoint `"C:`""
Suspend-BitLocker -MountPoint C: -ErrorAction SilentlyContinue
Start-Sleep -Seconds 60

#Start-Process -FilePath "powershell.exe" -ArgumentList "Disable-BitLocker -MountPoint `"C:`""
Disable-BitLocker -MountPoint C: -ErrorAction SilentlyContinue
Start-Sleep -Seconds 120

do{
    $VolumeStatus = (Get-BitLockerVolume -MountPoint C:).VolumeStatus
    $encrypStatus = (Get-BitLockerVolume -MountPoint C:).EncryptionPercentage
    $protStatus = (Get-BitLockerVolume -MountPoint C:).ProtectionStatus

}until(($VolumeStatus -eq 'FullyDecrypted') -and ($encrypStatus -eq 0) -and ($protStatus -eq 'Off'))

Write-Log "******** Decryption done, now changing Encryption Method to 256 bit ********"

#Enable-BitLocker -MountPoint C: -EncryptionMethod XtsAes256

do{
    $VolumeStatus = (Get-BitLockerVolume -MountPoint C:).VolumeStatus
    $encrypStatus = (Get-BitLockerVolume -MountPoint C:).EncryptionPercentage
    $protStatus = (Get-BitLockerVolume -MountPoint C:).ProtectionStatus
    $encrypMethod = (Get-BitLockerVolume -MountPoint C:).EncryptionMethod

    if(($VolumeStatus -ne $null) -and ($encrypStatus -eq $null))
    {
        if(($VolumeStatus -eq 'FullyEncrypted') -and ($encrypStatus -eq 100))
        {
            Write-Log "******** Resuming Bitlocker ********"
            Resume-BitLocker -MountPoint C:
            Start-Sleep -Seconds 90
        }
    }

}until(($encrypMethod -Like '*256') -and ($VolumeStatus -eq 'FullyEncrypted') -and ($encrypStatus -eq 100) -and ($protStatus -eq 'On'))

Exit 0

Write-Log "******** BitlockerState Remediation script ended... ********"