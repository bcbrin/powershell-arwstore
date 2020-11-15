[CmdletBinding()]
param (
    $Volume = 0,
    $ComputerName = "",
    $ReserveComputers = "S-0335-041WHF",
    $MaxParts = 4,
    [switch]$SecondaryCopy = $false
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Test ComputerName list
if($ComputerName -eq $null) {
    Write-Warning "Init-ARWStoreDB: Computer list is empty. Terminating"
    return
}

#Test Connectivity 
foreach ($Computer in $ComputerName) {
    if(!(Test-Connection -ComputerName $Computer -Count 1 -Quiet)) {
      Write-Warning "Init-ARWStoreDB: $($Computer) is unreachable"
    }
}

#Test access to c$
foreach ($Computer in $ComputerName) {
  try { 
    Test-Path -Path "\\$($Computer)\c$" | Out-Null
  }
  catch { 
    Write-Warning "Init-ARWStoreDB: $($Computer) unable to access UNC share" 
  }
}


#Check if Volume Already Exists
$Query = "SELECT * FROM [ARWStore].[dbo].[Properties] WHERE Volume='$($Volume)'; "
Write-Verbose "Init-ARWStoreDB: Executing SQL QUERY: $($Query)"
$Volumes = Invoke-SQLQuery -Query $Query
$Volumes = $Volumes.Tables.Rows

if($Volumes.Volume -contains $Volume) {
    Write-Warning "Init-ARWStoreDB: Volume $($Volume) already exists. Terminating"    
    return
}



#Add Properties to Properties table
$Query = "INSERT INTO [ARWStore].[dbo].[Properties] (Volume,MaxParts,SecondaryCopy) VALUES ('$Volume','$MaxParts','$SecondaryCopy')"
Write-Verbose "Init-ARWStoreDB: Executing SQL QUERY: $($Query)"
Invoke-SQLQuery -Query $Query | Out-Null



#Setup NodeDB and indexes
$NodeDB = @()
$FileDB = @()
$part = 0
$set = 0

foreach ($Computer in $ComputerName) {
    Write-Verbose "Init-ARWStoreDB: Initializing ARWStore on $($Computer)"
        $FreeSpace = Get-WmiObject -ComputerName $Computer -Class win32_logicaldisk | Where {$_.DeviceID -eq "C:"} | Select -ExpandProperty FreeSpace

    try {        
        New-Item -Path "\\$($Computer)\c$\" -Name "ARWStore" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Init-ARWStoreDB: Unable to create ARWStore on $($Computer)"
    }
        $Path = "\\$($Computer)\c$\ARWStore\"
        $DBEntry = New-Object -TypeName PSObject
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Path -Value $Path
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Part -Value $part
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Set -Value $set
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name ComputerName -Value $Computer
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name FreeSpace -Value $FreeSpace
        $NodeDB += $DBEntry

        #Write to SQL DB
        $Query = "INSERT INTO [ARWStore].[dbo].[Nodes] (Volume,ComputerName,PartNumber,SetNumber,FullPath,FreeSpace) VALUES ('$Volume','$Computer','$Part','$Set','$Path','$FreeSpace');"
        Write-Verbose "Init-ARWStoreDB: Executing SQL QUERY: $($Query)"
        Invoke-SQLQuery -Query $Query | Out-Null
        

        if($part -eq ($MaxParts -1)) {
            $set++
            $part = 0
        }
        else {
            $part++
        }
}


#Add Reserve Nodes to ReserveNodes table
$Date = Get-Date | Select -ExpandProperty Ticks
foreach ($ReserveNode in $ReserveComputers) {
    $Query = "INSERT INTO [ARWStore].[dbo].[ReserveNodes] (Volume,ComputerName,DateAdded,DateLastSeen) VALUES ('$Volume','$ReserveNode','$Date','$Date')"
    Write-Verbose "Init-ARWStoreDB: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}


#Add Root Folder to Folders table
$Query = "INSERT INTO [ARWStore].[dbo].[Folders] (Volume,LogicalPath) VALUES ('$Volume','\')"
Write-Verbose "Init-ARWStoreDB: Executing SQL QUERY: $($Query)"
Invoke-SQLQuery -Query $Query | Out-Null

