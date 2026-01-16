<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)

This script will check DesignedCapacity and add it in registry.
#>

$computer = $env:COMPUTERNAME
$namespace = "ROOT\WMI"
$classname = "BatteryStaticData"

<# 
Write-Output "====================================="
Write-Output "COMPUTER : $computer "
Write-Output "CLASS    : $classname "
Write-Output "====================================="
#>

$DesignDCap = (Get-WmiObject -Class $classname -ComputerName $computer -Namespace $namespace | Select-Object DesignedCapacity).DesignedCapacity #-ExcludeProperty PSComputerName, Scope, Path, Options, ClassPath, Properties, SystemProperties, Qualifiers, Site, Container | Format-List -Property [a-z]*

if(!(Test-Path -Path "HKLM:\Software\DesignCapacity"))
{
    New-Item -Path "HKLM:\Software\DesignCapacity" -ItemType Directory -Force
}

New-ItemProperty -Path "HKLM:\Software\DesignCapacity" -Name 'DesignedCapacity' -Value $DesignDCap -PropertyType String -ErrorAction SilentlyContinue

#Get-WmiObject -Class $classname -ComputerName $computer -Namespace $namespace | Select-Object * -ExcludeProperty PSComputerName, Scope, Path, Options, ClassPath, Properties, SystemProperties, Qualifiers, Site, Container | Format-List -Property [a-z]*