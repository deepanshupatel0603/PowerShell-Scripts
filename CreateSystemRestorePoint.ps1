<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)

This script will create system restore point
#>

#Create log file in PS1
function Write-Log
{
   Param ([string]$LogString)

   $LogFile = "C:\Windows\Temp\REGN_CreateSystemRestorePoint_1.0.log"

   $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)

   $LogMessage = "$Datetime $LogString"

   Add-content $LogFile -value $LogMessage
}

$date = Get-Date -UFormat %d-%m-%Y

# Enable System Protection on C drive with 10GB space
$restore = Start-Process -FilePath "powershell.exe" -ArgumentList '-command "Enable-ComputerRestore -Drive `"C:\`""' -Wait -PassThru
Write-Log "**** Enable Computer Restore execution done with exit code [$($restore.ExitCode)] ****"

$size = Start-Process -FilePath "powershell.exe" -ArgumentList "-command vssadmin resize shadowstorage /on=C: /for=C: /maxsize=5GB" -Wait -PassThru
Write-Log "**** Shadow storage is setting for 5GB and execution done with exit code [$($size.ExitCode)] ****"
 
# Set Volume Shadow Copy (VSS) service to Automatic and start it
Write-Log "****** Setting Volume Shadow Copy (VSS) service startup type to Automatic *****"
Set-Service -Name "VSS" -StartupType Automatic

Write-Log "****** Restarting Volume Shadow Copy (VSS) service ******"
Start-Service -Name "VSS"
 
# Set Microsoft Software Shadow Copy Provider (swprv) service to Automatic and start it
Write-Log "****** Setting Microsoft Software Shadow Copy Provider (swprv) service startup type to Automatic ******"
Set-Service -Name "swprv" -StartupType Automatic

Write-Log "****** Restarting Microsoft Software Shadow Copy Provider (swprv) service ******"
Start-Service -Name "swprv"
 
# Create a restore point
Write-Log "***** Creating a restore checkpoint *****"
$checkpoint = Start-Process -FilePath "powershell.exe" -ArgumentList '-command "Checkpoint-Computer -Description `"RestorePoint_$date`" -RestorePointType `"MODIFY_SETTINGS`""' -Wait -PassThru
Start-Sleep -Seconds 20
Write-Log "**** Created System Restore point with ExitCode [$($checkpoint.ExitCode)] ****"

#vssadmin delete shadows /all

Write-Log "***** Script execution done *****"