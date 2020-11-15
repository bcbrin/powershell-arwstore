#
#
#
# BEGIN FUNCTIONS
#
#
#


<#
    Splif-File: Splits File into specified number of parts. Returning file part size.
#>
function Split-File ($fromFolder,$rootName,$ext,$MaxParts) {
 
    $maxBuffSize = 2000000000
    $from = "{0}{1}.{2}" -f ($fromFolder, $rootName, $ext)
    $fromFile = [io.file]::OpenRead($from)
    $fileSize = $fromFile.Length

    #If too small to Split - Just Duplicate File w/ File Part Name Convention
    $index = 0
    if($fileSize -lt $MaxParts) {
        while ($index -lt $MaxParts) {
            $to = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $index, $ext)
            Copy-Item -LiteralPath $from -Destination $to
            $index++
        }
        $fromFile.Close()
        return $fileSize
    }

    
    [int64]$upperBound = [math]::Ceiling($fileSize / $MaxParts )
    Write-Verbose "Split-File: FilePartSize is: $upperBound"
    
    #If Part Size is greater than Int32 max
    if($upperBound -gt $maxBuffSize) {
       $buff =  new-object byte[] $maxBuffSize
       $FilePartSize = $upperBound
       $count = $idx = 0
      
       try {
           Write-Verbose "Split-File: Splitting $from using $([math]::Round(($UpperBound/1MB),2)) MB per file."
          
           do {    
               $total = 0    
               $to = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $idx, $ext)
               $toFile = [io.file]::OpenWrite($to)    
                              
               while ($total -lt $upperBound) {
                   if($maxBuffSize -gt ($upperBound - $count)) {
                         $count = $fromFile.Read($buff, 0, ($upperBound-$count))                           
                   }
                   else {                        
                         $count = $fromFile.Read($buff, 0, $maxBuffSize)                         
                   }
                                       
                   try {
                       Write-Verbose "Split-File: Writing to $to"                       
                       $tofile.Write($buff,0, $count)
                   } 
                   catch {
                       Write-Warning "Split-Files: Unable to write to file $($to)"
                   }
                   
                   $total = $total + $count
                      
                }                                                   
                $tofile.Close()                                                   
                $idx ++
            } while ($idx -lt $MaxParts)
        }
        finally {
            $fromFile.Close()
        }
    }
    else {
        #do normal stuff
        
        $buff =  new-object byte[] $upperBound

        $FilePartSize = $buff.Length
        $count = $idx = 0

        try {
            Write-Verbose "Split-File: Splitting $from using $([math]::Round(($UpperBound/1MB),2)) MB per file."
            do {
                $count = $fromFile.Read($buff, 0, $buff.Length)
                if ($count -gt 0) {
                    $to = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $idx, $ext)
                    $toFile = [io.file]::OpenWrite($to)
                try {
                    Write-Verbose "Split-File: Writing to $to"
                    $tofile.Write($buff, 0, $count)
                } finally {
                    $tofile.Close()
                }
                }
                $idx ++
            } while ($count -gt 0)
        }
        finally {
            $fromFile.Close()
        }
    }   

    return $FilePartSize
}


<#
    Import-NodesDB: Returns Nodes Table Contents
#>
function Import-NodesDB ($Volume) {
    $i = 0
    $NodesDB = @()
    $SQL_Nodes = Invoke-SQLQuery -Query "SELECT * FROM [ARWStore].[dbo].[Nodes] WHERE Volume='$($Volume)';"

    foreach ($Node in $SQL_Nodes.Tables[0].Rows) {
        $DBEntry = New-Object -TypeName PSObject
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Volume -Value $SQL_Nodes.Tables[0].Rows[$i].Volume
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Path -Value $SQL_Nodes.Tables[0].Rows[$i].FullPath
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Part -Value $SQL_Nodes.Tables[0].Rows[$i].PartNumber
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Set -Value $SQL_Nodes.Tables[0].Rows[$i].SetNumber
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name ComputerName -Value $SQL_Nodes.Tables[0].Rows[$i].ComputerName
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name FreeSpace -Value $SQL_Nodes.Tables[0].Rows[$i].FreeSpace
        $NodesDB += $DBEntry
        $i++
    }

    return $NodesDB
}

<#
    Import-NodesDB: Returns Files Table Entries for FileName Specified
#>
function Import-FilesDB ($FileName,$Volume){
    $i = 0
    $FilesDB = @()
    $SQL_Nodes = Invoke-SQLQuery -Query "SELECT * FROM [ARWStore].[dbo].[Files] WHERE FileName=""$($FileName)"" AND Volume='$Volume'"

    foreach ($Node in $SQL_Nodes.Tables.Rows) {
        $DBEntry = New-Object -TypeName PSObject
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Volume -Value $SQL_Nodes.Tables[0].Rows[$i].Volume
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Path -Value $SQL_Nodes.Tables[0].Rows[$i].FullPath
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Part -Value $SQL_Nodes.Tables[0].Rows[$i].PartNumber
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name Set -Value $SQL_Nodes.Tables[0].Rows[$i].SetNumber
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name ComputerName -Value $SQL_Nodes.Tables[0].Rows[$i].ComputerName
        Add-Member -InputObject $DBEntry -Type NoteProperty -Name FreeSpace -Value $SQL_Nodes.Tables[0].Rows[$i].FreeSpace
        $NodesDB += $DBEntry
        $i++
    }

    return $NodesDB
}


<#
    Invoke-SQLQuery: Invokes SQL Query against ARWStore SQL database.
#>
function Invoke-SQLQuery ($Query) {

    $DBServer = "localhost"
    $databasename = "ARWStore"
    $user = "arwsagent"
    $pass = "Computer1"

    $connectionString = "server=$DBServer;Database=$databasename;User Id=$user;Password=$pass;Integrated Security=True;"
    $connection = New-Object System.Data.SQLClient.SQLConnection

    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $connection.open() 

    #$reader = $command.ExecuteReader()

    $SQLAdaptor = New-Object System.Data.SqlClient.SqlDataAdapter
    $SQLAdaptor.SelectCommand = $command
    $SQLDataSet = New-Object System.Data.DataSet
    $SQLAdaptor.Fill($SQLDataSet) 
    $connection.Close()

    return $SQLDataSet
}

<#
	Combine-Files: Recombines previously split files into original
#>
function Combine-Files ($fromFolder,$rootName,$ext) {
    $maxBuffSize = 2000000000
    $from = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, 0, $ext)
    $fromFile = [io.file]::OpenRead($from)
    $upperBound = $fromFile.length
 
    
    #If FilePart size is less than MaxParts
    if($upperBound -lt $MaxParts) {
        $hash = Get-FileHash -LiteralPath $from | Select -ExpandProperty Hash
        $index = 0
        $smallfile = $false
        $truecount = 0

        #Check if file parts are identical
        while ($index -lt $MaxParts) {
            $from = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $index, $ext)
            if($hash -eq (Get-FileHash -LiteralPath $from | Select -ExpandProperty Hash)) {
                $truecount++
            }
            $index++
        }

        #If files parts are the same
        if($index -eq $truecount) {
            $from = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, 0, $ext)
            $to = "{0}{1}.{2}" -f ($fromFolder, $rootName, $ext)
            Copy-Item -LiteralPath $from -Destination $to
            $fromFile.Close()
            return
        }
    }


    #If FilePartSize is greater than MaxBufferSize
    if($upperbound -gt $maxBuffSize) {
        $buff = new-object byte[] $maxBuffSize
        $fromFile.Close()

        $count= $i = 0
        $to = "{0}{1}.{2}" -f ($fromFolder, $rootName, $ext)
        $toFile = [io.file]::OpenWrite($to)

        do {
            $from = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $i, $ext)
            $fromFile = [io.file]::OpenRead($from)
            $total = 0
            
            while ($total -lt $fromFile.length) {
                  if($maxBuffSize -gt ($upperbound - $count)) {
                     $count = $fromFile.Read($buff, 0, ($upperBound - $count))
                  }
                  else {
                     $count = $fromFile.Read($buff, 0, $maxBuffSize)
                  }

                  
                 if ($count -gt 0) {
                     $tofile.Write($buff, 0, $count) 
                 }

                 $total = $total + $count

            }
            
            $i++
            $fromFile.Close()

        } while ($i -lt $MaxParts)

        $toFile.Close()   

    }
    else {
        $buff = new-object byte[] $upperBound
        $fromFile.Close()

        $i=0
        $to = "{0}{1}.{2}" -f ($fromFolder, $rootName, $ext)
        $toFile = [io.file]::OpenWrite($to)

        do {
            $from = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $i, $ext)
            $fromFile = [io.file]::OpenRead($from)
   
            $count = $fromFile.Read($buff, 0, $buff.Length)
            if ($count -gt 0) {
                $tofile.Write($buff, 0, $count) 
            }

            $i++
            $fromFile.Close()
        } while ($i -lt $MaxParts)

        $toFile.Close()
    }

}

<#
    Replace-ARWStoreNode: Replaces passed node with new node from ReserveNodes table
#> 
function Replace-ARWStoreNode ($Node,$Volume) {
  
    #Add Computer To Inactive Table
    $Date = Get-Date | Select -ExpandProperty Ticks
    $Query = "INSERT INTO [ARWStore].[dbo].[InactiveNodes] (Volume,ComputerName,DateAdded,DateLastAttempt) VALUES ('$($Volume)','$($Node)','$($Date)','$($Date)');"
    Write-Verbose "Replace-ARWStoreNode: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null


    #Find and initialize reserve node
    $Query = "SELECT ComputerName FROM [ARWStore].[dbo].[ReserveNodes] WHERE Volume='$($Volume)';"
    Write-Verbose "Replace-ARWStoreNode: Executing SQL Query: $($Query)"
    $ReserveNodes = Invoke-SQLQuery -Query $Query
    $NewNode = ""

    foreach ($ReserveNode in $ReserveNodes.Tables.Rows) {
       $ReserveNodePath = "\\$($ReserveNode.ComputerName)\c$\"

        Write-Verbose "Replace-ARWStoreNode: Checking $($ReserveNode.ComputerName)"
        if(Test-Connection -ComputerName $ReserveNode.ComputerName -Count 1 -Quiet) {
            #Test access to c$
            Write-Verbose "Replace-ARWStoreNode: Testing C$ Share on $($ReserveNode.ComputerName)"
            if(Test-Path -LiteralPath $ReserveNodePath) {
                Write-Verbose "Replace-ARWStoreNode: Creating ARWStore directory on $($ReserveNode.ComputerName)"
                try {
                    New-Item -Path $ReserveNodePath -Name "ARWStore" -ItemType Directory | Out-Null
                    $NewNode = $ReserveNode.ComputerName
                    break
                }
                catch {
                    Write-Warning "Replace-ARWStoreNode: Unable to create ARWStore directory on $($ReserveNode.ComputerName)"
                }
            }            
            catch {                 
                Write-Warning "Replace-ARWStoreNode: Unable to access UNC Share on $($ReserveNode.ComputerName)" 
            }
            
        }
        else {
            Write-Warning "Replace-ARWStoreNode: Unable to contact $($ReserveNode.ComputerName)"
        }
    }


    #Save new node in nodes table
    $FreeSpace = Get-WmiObject -ComputerName $NewNode -Class win32_logicaldisk | Where {$_.DeviceID -eq "C:"} | Select -ExpandProperty FreeSpace
    $Path = "\\$($NewNode)\c$\ARWStore\"
    $Query = "UPDATE [ARWStore].[dbo].[Nodes] SET ComputerName='$($NewNode)',FullPath='$($Path)',FreeSpace='$FreeSpace' WHERE ComputerName='$($Node)' AND Volume='$($Volume)';"
    Write-Verbose "Replace-ARWStoreNode: Executing SQL QUERY: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
    
    #Remove new node from reserve table
    $Query = "DELETE FROM [ARWStore].[dbo].[ReserveNodes] WHERE ComputerName='$($NewNode)' AND Volume='$($Volume)';"
    Write-Verbose "Replace-ARWStoreNode: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null

    #Get list of files from Files table
    $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE ComputerName='$($Node)' AND Volume='$($Volume)';"
    Write-Verbose "Replace-ARWStoreNode: Executing SQL Query: $($Query)"
    $Files = Invoke-SQLQuery -Query $Query


    foreach ($File in $Files.Tables.Rows) {
        Write-Verbose "Replace-ARWStoreNode: Executing Sync-ARWStoreFile -FileID $($File.FileID) -TargetNode $($NewNode) -Volume $($Volume)"
        .\Sync-ARWStoreFile.ps1 -FileID $($File.FileID) -TargetNode $NewNode -Volume $Volume
    }
        

    #Remove references to original node from files table
    $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE ComputerName='$($Node)' AND Volume='$($Volume)';"
    Write-Verbose "Replace-ARWStoreNode: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}


<#
    Get-FilesDBEntries: Returns Files Table Entries for FileName Specified
#>
function Get-FilesDBEntries ($FileName,$Extension,$LogicalPath,$Volume) {

#If FileName contains esc char
if($FileName.contains("'")) {
    $FileName = $FileName.Replace("'","''")
}

#If LogicalPath contains esc char
if($LogicalPath.contains("'")) {
    $SQL_LogicalPath = $LogicalPath.Replace("'","''")
}
else {
    $SQL_LogicalPath = $LogicalPath
}


$FilesDB = @()
$Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE FileName='$($FileName)' AND Ext='$($Extension)' AND LogicalPath='$($SQL_LogicalPath)' AND Volume='$Volume';"
Write-Verbose "Get-FilesDBEntries: Executing SQL Query: $($Query)"
$SQL_Nodes = Invoke-SQLQuery -Query $Query

foreach ($Row in $SQL_Nodes.Tables.Rows) {
    $DBEntry = New-Object -TypeName PSObject
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name Volume -Value $Row.Volume
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name FileID -Value $Row.FileID
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name FileName -Value $Row.FileName
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name Ext -Value $Row.Ext    
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name Size -Value $Row.Size
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name Hash -Value $Row.Hash
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name DateSaved -Value $Row.DateSaved
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name ComputerName -Value $Row.ComputerName
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name LogicalPath -Value $Row.LogicalPath
    Add-Member -InputObject $DBEntry -Type NoteProperty -Name FilePath -Value $Row.FilePath    
    $FilesDB += $DBEntry
    $i++
}

return $FilesDB
}


<#
    Update-FreeSpace - Updates freespace for specified node
#>
function Update-FreeSpace ($ComputerName) {

    #Get FreeSpace
    try {
        $FreeSpace = Get-WmiObject -Class Win32_logicaldisk -ComputerName $ComputerName | Where {$_.DeviceID -eq "C:"} | Select -ExpandProperty FreeSpace
        Write-Verbose "Update-FreeSpace: $([math]::Round(($FreeSpace/1GB),2))GB free on $($ComputerName) after remove."
    }
    catch {
        Write-Warning "Update-FreeSpace: Unable to verify freespace on $($ComputerName)"
    }

    #Update FreeSpace -  SQL Database        
    $Query = "UPDATE [dbo].[Nodes] SET FreeSpace = $FreeSpace WHERE ComputerName = '$($ComputerName)';"
    Write-Verbose "Update-FreeSpace: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}

<#
    Get-MaxParts: Returns integer value of MaxParts in Properties table
#>
function Get-MaxParts ($Volume) {
    $Query = "SELECT [MaxParts] FROM [ARWStore].[dbo].[Properties] WHERE Volume='$($Volume)';"
    Write-Verbose "Get-MaxParts: Executing SQL QUERY: $($Query)"
    $MaxParts = Invoke-SQLQuery -Query $Query
    $MaxParts = $MaxParts.Tables.Rows | Select -ExpandProperty MaxParts
    return $MaxParts    
}

<#
    Get-SecondaryCopy: Returns boolean value of SecondaryCopy in Properties table
#>
function Get-SecondaryCopy ($Volume) {
    $Query = "SELECT [SecondaryCopy] FROM [ARWStore].[dbo].[Properties] WHERE Volume='$($Volume)';"
    Write-Verbose "Get-SecondaryCopy: Executing SQL QUERY: $($Query)"
    $SecondaryCopy = Invoke-SQLQuery -Query $Query
    $SecondaryCopy = $SecondaryCopy.Tables.Rows | Select -ExpandProperty SecondaryCopy
    return $SecondaryCopy    
}

<#
    Reset-ARWStore: Clears SQL Tables and removes file parts from Nodes
#>
function Reset-ARWStore ($Computers) {
$Computers |  foreach { Remove-Item "\\$($_)\c$\ARWStore" -Recurse -Force }
Invoke-Sqlcmd -ServerInstance localhost -Query "DELETE FROM [ARWStore].[dbo].[Nodes]"
Invoke-Sqlcmd -ServerInstance localhost -Query "DELETE FROM [ARWStore].[dbo].[Files]"
Invoke-Sqlcmd -ServerInstance localhost -Query "DELETE FROM [ARWStore].[dbo].[ReserveNodes]"
Invoke-Sqlcmd -ServerInstance localhost -Query "DELETE FROM [ARWStore].[dbo].[InactiveNodes]"
Invoke-Sqlcmd -ServerInstance localhost -Query "DELETE FROM [ARWStore].[dbo].[Folders]"
Invoke-Sqlcmd -ServerInstance localhost -Query "DELETE FROM [ARWStore].[dbo].[Properties]"
Remove-Item -LiteralPath ".\Restore\*"
}
###################### FOLDER OPERATIONS ###########################

<#
    Update-FolderTable: Updates Folder Table based on Files table entries    
#>
function Update-FolderTable ([switch]$RemoveEmptyDirectories,$Volume) {

    #Get FileDB entries from Files Table
    $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE ComputerName='$($Node.ComputerName)' AND Volume='$($Volume)';"
    Write-Verbose "Update-FolderTable: Executing SQL Query: $($Query)"
    $Files = Invoke-SQLQuery -Query $Query 
    $Files = $Files.Tables.Rows | Select-Object -Property LogicalPath | Select-Object -Unique LogicalPath

    #Get Folder entries from Folders table
    $Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE Volume='$($Volume)';"
    Write-Verbose "Update-FolderTable: Executing SQL Query: $($Query)"
    $Folders = Invoke-SQLQuery -Query $Query
    $Folders = $Folders.Tables.Rows

    foreach ($File in $Files.LogicalPath) {
        if($Folders.LogicalPath -notcontains $File) {
        
            #If FileName contains esc char
            if($File.contains("'")) {
                $SQL_FileName = $File.Replace("'","''")
            }
            else {
                $SQL_FileName = $File
            }
        
                                       
            #Create Folder in Folders Table
            $Query = "INSERT INTO [ARWStore].[dbo].[Folders] (Volume,LogicalPath) VALUES ('$($Volume)','$($SQL_FileName)');"
            Write-Verbose "Update-FolderTable: Executing SQL Query: $($Query)"
            Invoke-SQLQuery -Query $Query | Out-Null
        }
    }

    #Remove Empty Directories
    if($RemoveEmptyDirectories) {
        #Get Folder entries from Folders table
        $Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE Volume='$($Volume)';"
        Write-Verbose "Update-ARWStore: Executing SQL Query: $($Query)"
        $Folders = Invoke-SQLQuery -Query $Query
        $Folders = $Folders.Tables.Rows

        foreach ($Folder in $Folders.LogicalPath) {
            if($Files.LogicalPath -notcontains $Folder) {

                #If LogicalPath contains esc char
                if($Folder.contains("'")) {
                    $SQL_Folder = $Folder.Replace("'","''")
                }
                else {
                    $SQL_Folder = $Folder
                }

                Write-Output "Delete $($Folder)"
                #Delete Folder from Folders Table
                $Query = "DELETE FROM [ARWStore].[dbo].[Folders] WHERE LogicalPath='$($SQL_Folder)' AND Volume='$($Volume)';"
                Write-Verbose "Update-FolderTable: Executing SQL Query: $($Query)"
                Invoke-SQLQuery -Query $Query | Out-Null
            }
        }
    }
}


<#
    Test-ParentFolderPath: Returns true if parent path to LogicalPath exists in Folder table
#>
function Test-ParentFolderPath ($LogicalPath,$Volume) {             
    #Get Folder entries from Folders table
    $Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE Volume='$($Volume)';"
    Write-Verbose "Update-ARWStore: Executing SQL Query: $($Query)"
    $Folders = Invoke-SQLQuery -Query $Query
    $Folders = $Folders.Tables.Rows

    #Return true if parent path is root
    if($LogicalPath.LastIndexOf('\') -eq 0) {
        Write-Verbose "Test-ParentFolderPath: Parent folder to $($LogicalPath) is root."
        return $true
    }   
    else {
        $ParentPath = $LogicalPath.SubString(0,$LogicalPath.LastIndexOf('\'))
            
        #Check parent path exists
        Write-Verbose "Test-ParentFolderPath: Testing parent path $($ParentPath)"
           
        if($Folders.LogicalPath -contains $ParentPath) {    
            Write-Verbose "Test-ParentFolderPath: $($ParentPath) exists in Folder table"                            
            return $true
        }
        else {
            Write-Verbose "Test-ParentFolderPath: $($ParentPath) does not exist in Folder table"
            return $false
        }
    }
}