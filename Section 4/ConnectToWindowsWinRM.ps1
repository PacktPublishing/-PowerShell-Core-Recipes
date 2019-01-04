Test-WsMan -ComputerName 'DATACENTER'


$session = New-PSSession -ComputerName 'DATACENTER' -Credential tech\shurst


Get-PSSession 

invoke-command -Session $session -ScriptBlock {
    Get-Process | Where-Object {$_.Name -like "*ssh*"}
}