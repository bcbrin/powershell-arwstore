[CmdletBinding()]
param (
    [switch]$SecondaryCopy = $false,
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Import Nodes Database 
$NodeDB = Import-NodesDB -Volume $Volume

#Get MaxParts from Properties Table
$MaxParts = Get-MaxParts -Volume $Volume


#Verify Each Node
$index = 0
foreach ($Node in $NodeDB) {
    Write-Progress -Activity "Update-ARWStore" -Status "Verifying $($Node.ComputerName)" -PercentComplete (($index/$NodeDB.Count)*100)
    #Test Connectivity
    if(Test-Connection -ComputerName $Node.ComputerName -Count 1 -Quiet) {
        
        #Get FileDB entries from Files Table
        $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE ComputerName='$($Node.ComputerName)' AND Volume='$($Volume)';"
        Write-Verbose "Update-ARWStore: Executing SQL Query: $($Query)"
        $Files = Invoke-SQLQuery -Query $Query
        
        #Test ARWStorePath        
        if(Test-Path -LiteralPath $Node.Path) {                        
            Write-Verbose "Update-ARWStore: Verified $($Node.Path)"                       
        }
        else { #ARWStore Directory Does not Exist on Node
            Write-Warning "Update-ARWStore: Unable to verify $($Node.Path)"
            
            #Create ARWStore Folder
            Write-Verbose "Update-ARWStore: Creating: $($Node.Path)"
            try {
                New-Item -Path "\\$($Node.ComputerName)\c$" -Name "ARWStore" -ItemType Directory
            }
            catch {
                Write-Warning "Update-ARWStore: Unable to create $($Node.Path)"
            }
        }

        if(Test-Path $Node.Path) {
            #Check for each file
            foreach ($File in $Files.Tables.Rows) {                
                
                Write-Verbose "Update-ARWStore: Testing Path: $($File.FilePath)"
                #Check That File Exists
                if(Test-Path -LiteralPath $File.FilePath) {
                    Write-Verbose "Update-ARWStore: $($File.FilePath) - OK"
                    
                    #Verify file hash vs DB File Hash
                    $FileHash = Get-FileHash -LiteralPath $File.FilePath | Select -ExpandProperty Hash
                    if($FileHash -eq $File.Hash) { #Consistency Check Passed
                        Write-Verbose "Update-ARWStore: $($File.FilePath) passed consistency check"
                    }
                    else { #Consistency Check Failed
                        Write-Warning "Update-ARWStore: $($File.FilePath) did not pass consistency check. Deleting file, then re-syncing filepart."
                        Write-Verbose "Update-ARWStore: Removing: $($File.FilePath)"
                        Remove-Item -LiteralPath $File.FilePath

                        #Remove SQL Entry
                        $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE ComputerName='$($Node.ComputerName)' AND FileID='$($File.FileID)' AND Volume='$($Volume)';"
                        Write-Verbose "Update-ARWStore: Executing SQL Query: $($Query)"
                        Invoke-SQLQuery -Query $Query | Out-Null

                        
			            #Copy File from partner node
                        Write-Verbose "Update-ARWStore: Running Sync-ARWStoreFile -FileID $($File.FileID) -TargetNode $($Node.ComputerName) -Volume $($Volume)"
                        .\Sync-ARWStoreFile.ps1 -FileID $File.FileID -TargetNode $Node.ComputerName -Verbose -Volume $Volume
                    }
                }
                else { #File Doesn't Exist
                    #Sync File from other nodes
                    Write-Warning "Update-ARWStore: Test-Path Failed"

                    #Remove SQL Entry
                    $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE ComputerName='$($Node.ComputerName)' AND FileID='$($File.FileID)' AND Volume='$($Volume)';"
                    Write-Verbose "Update-ARWStore: Executing SQL Query: $($Query)"
                    Invoke-SQLQuery -Query $Query | Out-Null

		            #Copy File from partner node
                    Write-Verbose "Update-ARWStore: Running Sync-ARWStoreFile -FileID $($File.FileID) -TargetNode $($Node.ComputerName) -Volume $($Volume)"
                    .\Sync-ARWStoreFile.ps1 -FileID $File.FileID -TargetNode $Node.ComputerName -Verbose -Volume $Volume
                }
            }
        } 
        else {
            Write-Warning "Update-ARWStore: Unable to verify $($Node.Path)" 
        }


        #Remove Files in ARWStore Share not in Files DB
        $NodeFiles = Get-ChildItem -LiteralPath $Node.Path
        $FileList = $Files.Tables.Rows | Select -ExpandProperty FileID
        foreach ($NodeFile in $NodeFiles) {
            if($FileList -notcontains $NodeFile.BaseName) {
                Write-Verbose "Update-ARWStore: Removing: $($NodeFile.FullName)"
                Remove-Item -Path $NodeFile.FullName
            }
        }

    }
    else { #Ping Node Failed
        Write-Warning "Update-ARWStore: $($Node.ComputerName) is unavailable. Replacing Node."
        Replace-ARWStoreNode -Node $Node.ComputerName        
    }
    $index++
}

