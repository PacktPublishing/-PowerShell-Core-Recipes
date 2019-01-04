$UserFolders = Get-ChildItem -Path "C:\Users" -directory 

foreach ($Folder in $UserFolders.Name)
{
    try
    {
        if (Get-ChildItem -Path "C:\Users\$folder\.ssh\" -ErrorAction Stop)
        {
            Clear-Host
            try
            {
                Get-Content "C:\Users\$folder\.ssh\config" -ErrorAction Stop
            }
            catch
            {
                Write-Host "User $folder has an ssh folder but no config file"    
            }
        }
    } 
    catch { }
}