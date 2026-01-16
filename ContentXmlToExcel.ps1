<#
AUTHOR: Deepanshu Patel (deepanshupatel0603)

This script will read XML content and convert it to excel file.
#>

Install-Module -Name ImportExcel -Scope CurrentUser -Force

$cname = $env:COMPUTERNAME

# Load the XML file
[xml]$xmlContent = Get-Content -Path "C:\Windows\Temp\database_$cname.xml"

# Create an array to store the extracted data
$data = @()

# Loop through each package in the XML and extract the required information
foreach ($package in $xmlContent.Database.Package) {
    $data += [PSCustomObject]@{
        PackageID    = $package.ID
        Name         = $package.Name
        Description  = $package.Description
        Version      = $package.Version
        ReleaseDate  = $package.ReleaseDate
    }
}

# Convert the array to a DataTable
#$dataTable = $data | Out-DataTable
$dataTable = $data

# Export the DataTable to an Excel file
$dataTable | Export-Excel -Path "C:\Windows\Temp\database_$cname.xlsx" -WorksheetName "Packages" -Append