[CmdletBinding()]
param (
    $fromFolder = "C:\BBRIN\Stuff\",
    $rootName = "CompTIA '",
    $ext = "pdf",
    $LogicalPath = "\",
    [switch]$Overwrite = $false,
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Setup File Path
$FilePath = "{0}{1}.{2}" -f ($fromFolder,$rootName,$ext)

#Import Nodes Database 
$NodeDB = Import-NodesDB -Volume $Volume

#Get MaxParts from Properties Table
$MaxParts = Get-MaxParts -Volume $Volume

#Get SecondaryPart from Properties Table
$SecondaryCopy = Get-SecondaryCopy -Volume $Volume

#Check for Existing File Entry
$ExistingEntries = Get-FilesDBEntries -FileName $rootName -Extension $Ext -LogicalPath $LogicalPath -Volume $Volume
 
#If FileName contains esc char
if($rootName.contains("'")) {
    $SQLFileName = $rootName.Replace("'","''")
}
else {
    $SQLFileName = $rootName
}

if($ExistingEntries) {
    Write-Warning "Save-ARWStoreFile: $($FileName) already exists in ARWStore - Volume: $($Volume)."
    
    if($Overwrite) {
        #Remove Existing SQL Entries

        #Remove Original File Entry - SQL Database
        Write-Verbose "Save-ARWStoreFile: Removing SQL Entry for $($FileName)"
        $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE FileName=""$($SQLFileName)"" WHERE Volume='$($Volume)';"
        Write-Verbose "Save-ARWStoreFile: Executing SQL Query: $($Query)"
        Invoke-SQLQuery -Query $Query | Out-Null

        #Remove File Part SQL Entries
        Write-Verbose "Save-ARWStoreFile: Removing SQL Entries for $($FileName) file parts"
        $FileParts = "$($SQLFileName).%"
        $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE FileName like '$($FileParts)' WHERE Volume='$($Volume)';"
        Write-Verbose "Save-ARWStoreFile: Executing SQL Query: $($Query)"
        Invoke-SQLQuery -Query $Query | Out-Null
    
    }
    else {
        #Terminate Save
        Write-Warning "Save-ARWStoreFile: Overwrite disabled. Process terminated."
        return
    }
}


#If Folder contains esc char
if($LogicalPath.contains("'")) {
    $SQL_LogicalPath = $LogicalPath.Replace("'","''")
}
else {
    $SQL_LogicalPath = $LogicalPath
}
    
#Prepare FileDB entry
$Date = Get-Date | Select -ExpandProperty Ticks
$FileHash = Get-FileHash -LiteralPath $FilePath | Select -ExpandProperty Hash
$FileDBEntry = New-Object -TypeName PSObject
$FileSize = Get-Item -LiteralPath $FilePath | Select -ExpandProperty Length
Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name FileName -Value $SQLFileName
Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Ext -Value $ext
Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Size -Value $FileSize
Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Hash -Value $FileHash
Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name DateSaved -Value $Date
Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name LogicalPath -Value $SQL_LogicalPath



#Save original FileDB entry to SQL
$Query = "INSERT INTO [dbo].[Files] (Volume,FileID,FileName,Ext,Size,Hash,DateSaved,ComputerName,LogicalPath,FilePath) VALUES ('$($Volume)','','$($FileDBEntry.FileName)','$($FileDBEntry.Ext)','$($FileDBEntry.Size)','$($FileDBEntry.Hash)','$($FileDBEntry.DateSaved)','','$($FileDBEntry.LogicalPath)','');"
Write-Verbose "Save-ARWStoreFile: Executing SQL Query: $($Query)"
Invoke-SQLQuery -Query $Query | Out-Null

#Split File and Store FileSize
$FilePartSize = Split-File -fromFolder $fromFolder -rootName $rootName -ext $ext -MaxParts $MaxParts -Verbose

#Build GUID Array
$GUID = @()
$i = 0
while ($i -lt $MaxParts) { 
    $GUID += New-Guid | Select -ExpandProperty guid 
    $i++ 
}


#Save File Part to Each Node
$i = 0
foreach ($Node in $NodeDB) {
     Write-Progress -Activity "Save-ARWStoreFile" -Status "Copying to $($Node.ComputerName)" -PercentComplete (($i/($NodeDB.Count))*100)
     if(Test-Path -LiteralPath $Node.Path) {
        $PrimaryFilePartPath = "{0}{1}.{2}.{3}" -f ($fromFolder,$rootName,$Node.Part,$ext)
        $PrimaryFilePartName = "{0}.{1}" -f ($rootName,$Node.Part)
        $SQLPrimaryFilePartName = "{0}.{1}" -f ($SQLFileName,$Node.Part)

        Write-Verbose "Save-ARWStoreFile: Copying $($PrimaryFilePartPath) to $($Node.Path) - Part $($Node.Part) - Set $($Node.Set) - Volume $($Volume)"              

        #Check Freespace before save
        try {
            $FreeSpace = Get-WmiObject -Class Win32_logicaldisk -ComputerName $Node.ComputerName | Where {$_.DeviceID -eq "C:"} | Select -ExpandProperty FreeSpace
        }
        catch {
            Write-Warning "Save-ARWStoreFile: Unable to verify freespace $($Node.ComputerName)"
        }
        
        #Check for addequate free space on target node
        Write-Verbose "Save-ARWStoreFile: $($Node.ComputerName) FreeSpace $([math]::Round(($FreeSpace/1GB),2))GB"
        if($Freespace -gt $FilePartSize) {
            #Copy File Part To Node
            Write-Verbose "Save-ARWStoreFile: Copying $($PrimaryFilePartPath) to $($Destination)"
            $Destination = "{0}{1}" -f ($Node.Path,$GUID[$Node.Part])            
            
            Write-Progress -Activity "Save-ARWStoreFile" -Status "Copying $($PrimaryFilePartName) to $($Node.ComputerName)" -PercentComplete (($i/($NodeDB.Count))*100)
            try { Copy-Item -LiteralPath $PrimaryFilePartPath -Destination $Destination -Force }
            catch { Write-Warning "Save-ARWStoreFile: Unable to copy $PrimaryFilePartPath to $Destination. Exiting"
                    return
            }

            #Save file info to SQL
            #Prepare FileDB entry
            $DateSaved = Get-Date | Select -ExpandProperty Ticks
            $FileHash = Get-FileHash -LiteralPath $PrimaryFilePartPath | Select -ExpandProperty Hash
            $FileDBEntry = New-Object -TypeName PSObject
            $FileSize = Get-Item -LiteralPath $PrimaryFilePartPath | Select -ExpandProperty Length
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name FileID -Value $GUID[$($Node.Part)]
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name FileName -Value $SQLPrimaryFilePartName
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Ext -Value $Ext
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Size -Value $FileSize
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Hash -Value $FileHash
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name DateSaved -Value $DateSaved
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name ComputerName -Value $Node.ComputerName
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name LogicalPath -Value $SQL_LogicalPath
            Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name FilePath -Value $Destination


            #Save original FileDB entry to SQL
            $Query = "INSERT INTO [dbo].[Files] (Volume,FileID,FileName,Ext,Size,Hash,DateSaved,ComputerName,LogicalPath,FilePath) VALUES ('$Volume','$($FileDBEntry.FileID)','$($FileDBEntry.FileName)','$($FileDBEntry.Ext)','$($FileDBEntry.Size)','$($FileDBEntry.Hash)','$($FileDBEntry.DateSaved)','$($Node.ComputerName)','$($FileDBEntry.LogicalPath)','$($FileDBEntry.FilePath)');"
            Write-Verbose "Save-ARWStoreFile: Executing SQL Query: $($Query)"
            Invoke-SQLQuery -Query $Query | Out-Null
        }
        else {
            Write-Warning "Save-ARWStoreFile: Insufficient disk space on $($Node.ComputerName)"
        }

        #If Double Redundancy is TRUE
        if($SecondaryCopy) {
            $SecondaryPart = [Math]::Abs(($Node.Part)-($MaxParts-1))
            $SecondaryFilePartPath = "{0}{1}.{2}.{3}" -f ($fromFolder,$rootName,$SecondaryPart,$ext)
            $SecondaryFilePartName = "{0}.{1}" -f ($rootName,$SecondaryPart)
            $SQLSecondaryFilePartName = "{0}.{1}" -f ($SQLFileName,$SecondaryPart)

            Write-Verbose "Save-ARWStoreFile: Copying $($SecondaryFilePartPath) to $($Node.Path) - Part $($SecondaryPart) - Set $($Node.Set) - Volume $($Volume)"

            Write-Verbose "Save-ARWStoreFile: $([math]::Round(($FreeSpace/1GB),2))GB free on $($Node.ComputerName) after secondary part copy."
            if($FreeSpace -gt ($FilePartSize * 2)) {
                Write-Verbose "Save-ARWStoreFile: Copying $($PrimaryFilePartPath) to $($Node.Path)"
                $Destination = "{0}{1}" -f ($Node.Path,$GUID[$SecondaryPart])

                Write-Progress -Activity "Save-ARWStoreFile" -Status "Copying $($SecondaryFilePartName) to $($Node.ComputerName)" -PercentComplete (($i/($NodeDB.Count))*100)                                
                try { Copy-Item -LiteralPath $SecondaryFilePartPath -Destination $Destination -Force }
                catch { Write-Warning "Save-ARWStoreFile: Unable to copy $PrimaryFilePartPath to $Destination. Exiting"
                    return
                }

                #Save file info to SQL
                #Prepare FileDB entry
                $DateSaved = Get-Date | Select -ExpandProperty Ticks
                $FileHash = Get-FileHash -LiteralPath $SecondaryFilePartPath | Select -ExpandProperty Hash
                $FileDBEntry = New-Object -TypeName PSObject
                $FileSize = Get-Item -LiteralPath $SecondaryFilePartPath | Select -ExpandProperty Length
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name FileID -Value $GUID[$($SecondaryPart)]
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Name -Value $SQLSecondaryFilePartName
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Ext -Value $Ext
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Size -Value $FileSize
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name Hash -Value $FileHash
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name DateSaved -Value $DateSaved
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name ComputerName -Value $Node.ComputerName
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name LogicalPath -Value $SQL_LogicalPath
                Add-Member -InputObject $FileDBEntry -Type NoteProperty -Name FilePath -Value $Destination

                #Save original FileDB entry to SQL
                $Query = "INSERT INTO [dbo].[Files] (Volume,FileID,FileName,Ext,Size,Hash,DateSaved,ComputerName,LogicalPath,FilePath) VALUES ('$($Volume)','$($FileDBEntry.FileID)','$($FileDBEntry.FileName)','$($FileDBEntry.Ext)','$($FileDBEntry.Size)','$($FileDBEntry.Hash)','$($FileDBEntry.DateSaved)','$($Node.ComputerName)','$($FileDBEntry.LogicalPath)','$($FileDBEntry.FilePath)');"
                Write-Verbose "Save-ARWStoreFile: Executing SQL Query: $($Query)"
                Invoke-SQLQuery -Query $Query | Out-Null
            }
            else {
                Write-Warning "Save-ARWStoreFile: Insufficient disk space on $($Node.ComputerName)"
            }
        }
        else {
            Write-Verbose "Save-ARWStoreFile: $([math]::Round(($FreeSpace/1GB),2))GB free on $($Node.ComputerName) after primary part copy."
        }


        #Update FreeSpace in Nodes Table
        Update-FreeSpace -ComputerName $Node.ComputerName
              
    }
    #Test Path Failed on Node
    else {
        Write-Warning "Save-ARWStoreFile: Unable to connect to $($Node.ComputerName)"
        #Possible Location For Node Replacement
    }

    $i++
}

#Remove Split Files from $fromFolder
$idx = 0

while ($idx -lt $MaxParts) {
    $FilePartPath = "{0}{1}.{2}.{3}" -f ($fromFolder, $rootName, $idx, $ext)
    Write-Verbose "Save-ARWStoreFile: Deleting $($FilePartPath)" 
    Remove-Item -LiteralPath $FilePartPath
    $idx++
}

#Update Folder Information
Update-FolderTable -Volume $Volume