[CmdletBinding()]
param (
    $Path = "C:\BBRIN\ARWStore\Database"
)

$Date = Get-Date -Format MMddyyyy

#Export Nodes Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Nodes]"
Write-Verbose "Export-ARWStoreDB: Executing SQL QUERY: $($Query)"
$Nodes = Invoke-SQLQuery -Query $Query
$Nodes = $Nodes.Tables.Rows
#ExportToCSV
$ExportPath = "{0}\{1}_{2}.csv" -f ($Path,"NodesTable_",$Date)
$Nodes | Select-Object -Property Volume,ComputerName,PartNumber,SetNumber,FreeSpace,FullPath | Export-Csv -NoTypeInformation -Path $ExportPath



#Export Folders Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Folders]"
Write-Verbose "Export-ARWStoreDB: Executing SQL QUERY: $($Query)"
$Folders = Invoke-SQLQuery -Query $Query
$Folders = $Folders.Tables.Rows
#ExportToCSV
$ExportPath = "{0}\{1}_{2}.csv" -f ($Path,"FoldersTable_",$Date)
$Folders | Select-Object -Property Volume,LogicalPath | Export-Csv -NoTypeInformation -Path $ExportPath



#Export Files Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Files]"
Write-Verbose "Export-ARWStoreDB: Executing SQL QUERY: $($Query)"
$Files = Invoke-SQLQuery -Query $Query
$Files = $Files.Tables.Rows
#ExportToCSV
$ExportPath = "{0}\{1}_{2}.csv" -f ($Path,"FilesTable_",$Date)
$Files | Select-Object -Property Volume,FileID,FileName,Ext,Hash,Size,DateSaved,ComputerName,LogicalPath,FilePath | Export-Csv -NoTypeInformation -Path $ExportPath



#Export Properties Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Properties]"
Write-Verbose "Export-ARWStoreDB: Executing SQL QUERY: $($Query)"
$Properties = Invoke-SQLQuery -Query $Query
$Properties = $Properties.Tables.Rows
#ExportToCSV
$ExportPath = "{0}\{1}_{2}.csv" -f ($Path,"PropertiesTable_",$Date)
$Properties | Select-Object -Property Volume,MaxParts,SecondaryCopy | Export-Csv -NoTypeInformation -Path $ExportPath


#Export ReserveNodes Table
$Query = "SELECT * FROM [ARWStore].[dbo].[ReserveNodes]"
Write-Verbose "Export-ARWStoreDB: Executing SQL QUERY: $($Query)"
$ReserveNodes = Invoke-SQLQuery -Query $Query
$ReserveNodes = $ReserveNodes.Tables.Rows
#ExportToCSV
$ExportPath = "{0}\{1}_{2}.csv" -f ($Path,"ReserveNodesTable_",$Date)
$ReserveNodes | Select-Object -Property Volume,ComputerName,DateAdded,DateLastSeen | Export-Csv -NoTypeInformation -Path $ExportPath


#Export InactiveNodes Table
$Query = "SELECT * FROM [ARWStore].[dbo].[InactiveNodes]"
Write-Verbose "Export-ARWStoreDB: Executing SQL QUERY: $($Query)"
$InactiveNodes = Invoke-SQLQuery -Query $Query
$InactiveNodes = $InactiveNodes.Tables.Rows
#ExportToCSV
$ExportPath = "{0}\{1}_{2}.csv" -f ($Path,"InactiveNodesTable_",$Date)
$InactiveNodes | Select-Object -Property Volume,ComputerName,DateAdded,DateLastAttempt | Export-Csv -NoTypeInformation -Path $ExportPath