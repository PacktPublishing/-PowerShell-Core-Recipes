# Get this from the PS gallery
# https://www.powershellgallery.com/packages/WindowsCompatibility/1.0.0
Install-Module -Name WindowsCompatibility

Import-WinModule -name storage  # 160 cmdlets
Import-WinModule -name smbshare # 38 cmdlets

# Establish Connectivity & Run Get-DISK (GPT - GUID Partition Table)
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-Disk | select Number,FriendlyName,PartitionStyle}

# Retrieve Volume (Drive Type 3 - )
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-Volume}
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-PSDRIVE | where-object {$_.Name -eq 'C'}}

# Lets find the disk which is RAW and prepare it
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-Disk | select Number,FriendlyName,PartitionStyle}
Invoke-Command -ComputerName DC1 -ScriptBlock `
{get-disk | where-object PartitionStyle -eq "RAW" | Initialize-Disk -PassThru}
Invoke-Command -ComputerName DC1 -ScriptBlock `
{New-Partition -AssignDriveLetter  -UseMaximumSize -DiskNumber 1}
Invoke-Command -ComputerName DC1 -ScriptBlock `
{Format-Volume -FileSystem NTFS -DriveLetter D  -NewFileSystemLabel data}

# Check New Disk
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-PSDRIVE | where-object {$_.Name -eq 'D'}}

# View a share
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-smbshare}

# View Access Permissions
Invoke-Command -ComputerName DC1 -ScriptBlock {Get-smbshareaccess -Name Resources}

# Create a folder and share
New-item -ItemType Directory -Path \\dc1\d$\scripts
Invoke-Command -ComputerName DC1 -ScriptBlock `
{New-SmbShare -Name Scripts -Path 'd:\scripts' -FullAccess Administrators}

# Connect to share
New-SmbMapping -LocalPath x:  -RemotePath \\dc1\scripts

# Privileges
Invoke-Command -ComputerName DC1 -ScriptBlock `
{Grant-SmbShareAccess -Name Scripts -AccountName "psdevops\techsnips" -AccessRight Change -Force}
Invoke-Command -ComputerName DC1 -ScriptBlock `
{Revoke-SmbShareAccess -Name Scripts -AccountName "psdevops\techsnips" -Force}

# NTFS Permissions - Set A Rule
get-acl \\dc1\resources | fl
$acl = Get-acl \\dc1\resources
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule `
("psdevops\techsnips","FullControl","Allow")
$acl.Setaccessrule($AccessRule)
$acl | set-acl \\dc1\resources

# NTFS Permissions - Remove A Rule
$acl.RemoveAccessRule($AccessRule)
$acl | Set-Acl \\dc1\resources