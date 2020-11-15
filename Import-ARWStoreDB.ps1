[CmdletBinding()]
param (
    $Path = "C:\BBRIN\ARWStore\Database",
    $Date = "07272017"
)

#Import Nodes Table
#ExportToCSV
$ImportPath = "{0}\{1}_{2}.csv" -f ($Path,"NodesTable_",$Date)
$Nodes = Import-Csv -Path $ImportPath

foreach ($Entry in $Nodes) {
    $Query = "INSERT INTO [ARWStore].[dbo].[Nodes] (Volume,ComputerName,PartNumber,SetNumber,FullPath,FreeSpace) VALUES ('$($Entry.Volume)','$($Entry.ComputerName)','$($Entry.PartNumber)','$($Entry.SetNumber)','$($Entry.FullPath)','$($Entry.FreeSpace)')"
    Write-Verbose "Import-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}



#Import Properties Table
#ExportToCSV
$ImportPath = "{0}\{1}_{2}.csv" -f ($Path,"PropertiesTable_",$Date)
$Properties = Import-Csv -Path $ImportPath

foreach ($Entry in $Properties) {
    $Query = "INSERT INTO [ARWStore].[dbo].[Properties] (Volume,MaxParts,SecondaryCopy) VALUES ('$($Entry.Volume)','$($Entry.MaxParts)','$($Entry.SecondaryCopy)')"
    Write-Verbose "Import-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}



#Import Folders Table
#ExportToCSV
$ImportPath = "{0}\{1}_{2}.csv" -f ($Path,"FoldersTable_",$Date)
$Folders = Import-Csv -Path $ImportPath

foreach ($Entry in $Folders) {
    $Query = "INSERT INTO [ARWStore].[dbo].[Folders] (Volume,LogicalPath) VALUES ('$($Entry.Volume)','$($Entry.LogicalPath)')"
    Write-Verbose "Import-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}


#Import Files Table
#ExportToCSV
$ImportPath = "{0}\{1}_{2}.csv" -f ($Path,"FilesTable_",$Date)
$Files = Import-Csv -Path $ImportPath

foreach ($Entry in $Files) {
    $Query = "INSERT INTO [ARWStore].[dbo].[Files] (Volume,FileID,FileName,Ext,Hash,Size,DateSaved,ComputerName,LogicalPath,FilePath) VALUES ('$($Entry.Volume)','$($Entry.FileID)','$($Entry.FileName)','$($Entry.Ext)','$($Entry.Hash)','$($Entry.Size)','$($Entry.DateSaved)','$($Entry.ComputerName)','$($Entry.LogicalPath)','$($Entry.FilePath)')"
    Write-Verbose "Import-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}



#Import ReserveNodes Table
#ExportToCSV
$ImportPath = "{0}\{1}_{2}.csv" -f ($Path,"ReserveNodesTable_",$Date)
$ReserveNodes = Import-Csv -Path $ImportPath

foreach ($Entry in $ReserveNodes) {
    $Query = "INSERT INTO [ARWStore].[dbo].[ReserveNodes] (Volume,ComputerName,DateAdded,DateLastSeen) VALUES ('$($Entry.Volume)','$($Entry.ComputerName)','$($Entry.DateAdded)','$($Entry.DateLastSeen)')"
    Write-Verbose "Import-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}


#Import InactiveNodes Table
#ExportToCSV
$ImportPath = "{0}\{1}_{2}.csv" -f ($Path,"InactiveNodesTable_",$Date)
$InactiveNodes = Import-Csv -Path $ImportPath

foreach ($Entry in $InactiveNodes) {
    $Query = "INSERT INTO [ARWStore].[dbo].[InactiveNodes] (Volume,ComputerName,DateAdded,DateLastAttempt) VALUES ('$($Entry.Volume)','$($Entry.ComputerName)','$($Entry.DateAdded)','$($Entry.DateLastAttempt)')"
    Write-Verbose "Import-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}







