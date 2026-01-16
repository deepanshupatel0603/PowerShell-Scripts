<#
.SYNOPSIS
This script can be used to determine whether a machine is Laptop or not.
.DESCRIPTION
This script can be used to determine whether a machine is Laptop or not.
.EXAMPLE
C:\PS> C:\Script\Detect_Laptop.ps1
To determine whether a machine is Laptop or not.#>
Function Detect-Laptop
{
Param( [string]$computer = "localhost" )
$isLaptop = $false
#The chassis is the physical container that houses the components of a computer. Check if the machineâs chasis type is 9.Laptop 10.Notebook 14.Sub-Notebook
if(Get-WmiObject -Class win32_systemenclosure -ComputerName $computer | Where-Object { $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14})
{ $isLaptop = $true }
#Shows battery status , if true then the machine is a laptop.
if(Get-WmiObject -Class win32_battery -ComputerName $computer)
{ $isLaptop = $true }
$isLaptop
}
If(Detect-Laptop) { laptop }
else { Not laptop}
#Listing computer manufacturer and model
#Get-CimInstance -ClassName Win32_ComputerSystem