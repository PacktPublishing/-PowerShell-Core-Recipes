#Region
# Setup Script Variables
$location = "HKLM:\Software"
$key      = "$location\Techsnips"
$creds = Get-Credential 

# Retrieve a remote system registry values
$params = @{
    "ComputerName" = "dc1"
    "ScriptBlock"  = {
        Get-ChildItem -Path $Using:key
        Get-ItemProperty -Path $Using:key
    }
}
Invoke-Command @params -Credential $creds
#Endregion

#Region
# Retrieve multiple remote system registry values
$computers = @(
    "DC1"
    "APP1"
)

$computers | Foreach-Object {
    $params = @{
        "ComputerName" = $_
        "ScriptBlock"  = {
            Get-ChildItem -Path $Using:key
            Get-ItemProperty -Path $Using:key
        }
    }
    Invoke-Command @params -Credential $creds
}
#EndRegion

#Region
# Retrieve multiple remote system registry values for comparison
$computers = @(
    "DC1"
    "APP1"
)

$results = $computers | Foreach-Object {
    $params = @{
        "ComputerName" = $_
        "ScriptBlock"  = {
            Get-ItemProperty -Path $Using:key
        }
    }
    Invoke-Command @params -Credential $creds
}
#EndRegion

#Region
$compareResults = $results | Select-Object -Skip 1 | Foreach-Object {
    $excludeProps = @(
        "PSPath"
        "PSParentPath"
        "PSChildName"
        "PSDrive"
        "PSProvider"
        "RunspaceId"
        "PSComputerName"
        "PSShowComputerName"
    )
    $referenceObject = $results[0]
    $referenceProps  = $results[0] | Get-Member | Where-Object { $_.MemberType -EQ 'NoteProperty' -And $excludeProps -NotContains $_.Name } | Select-Object -ExpandProperty Name
} {
    $result = $_

    $referenceProps | Foreach-Object {
        $property = $_
        $compare  = Compare-Object -ReferenceObject $referenceObject -DifferenceObject $result -Property $property -IncludeEqual

        [PSCustomObject]@{
            "ReferenceComputerName"  = $results[0].PSComputerName
            "DifferenceComputerName" = $result.PSComputerName
            "PropertyName"           = $property
            "ReferenceValue"         = $compare | Where-Object { $_.SideIndicator -EQ '==' -Or $_.SideIndicator -EQ '<=' } | Select-Object -ExpandProperty $property
            "DifferenceValue"        = $compare | Where-Object { $_.SideIndicator -EQ '==' -Or $_.SideIndicator -EQ '=>' } | Select-Object -ExpandProperty $property
            "SideIndicator"          = $( If ( $compare.SideIndicator -EQ '==' ) { '==' } Else { '<>' } )
        }
    }
}
$compareResults | Where-Object SideIndicator -NE '==' | Format-Table -AutoSize
#EndRegion