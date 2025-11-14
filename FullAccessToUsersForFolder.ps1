#Give Users Full Control/Grant Full Control
 
$Folder = ($envProgramFilesX86 + "\CostWork")
icacls.exe $folder /grant 'USERS:(OI)(CI)(F)'

#OR

$dir= "${env:ProgramFiles(x86)}\Template"
icacls.exe $dir /grant 'USERS:(OI)(CI)(F)'

#OR

if(Test-Path -Path "$env:ProgramFiles\Autodesk\MDM")
{
    $Acl = Get-Acl "$env:ProgramFiles\Autodesk\MDM"
    $Permission = "everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $Acl.SetAccessRule($rule)
    $Acl | Set-Acl "$env:ProgramFiles\Autodesk\MDM"
}
