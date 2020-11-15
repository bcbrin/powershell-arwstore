[CmdletBinding()]
param (
    $fromFolder = "C:\BBRIN\Books\",   
    $LogicalPath = "\",
    [switch]$Overwrite = $false,
    $Volume = 1
)


#Import Functions.ps1 
. ".\Functions.ps1"

#Get MaxParts from Properties Table
$MaxParts = Get-MaxParts -Volume $Volume

$Folder = Get-Item -Path $fromFolder

if($Folder.PSIsContainer) {
    Write-Verbose "Save-ARWStoreFolder: $($fromFolder) is directory"
}
else {
    Write-Verbose "Save-ARWStoreFolder: $($fromFolder) is not a directory. Terminating"
    return
} 


#Get Files
$Files = Get-ChildItem -Path $Folder.FullName -Recurse

#Foreach File in Folder
foreach ($File in $Files) {
    if($File.PSIsContainer) {
        Write-Verbose "Save-ARWStoreFolder: Nested Folder Found - $($File.BaseName)"
    }
    else {
        $Ext = ($File.Extension).Replace('.','')

        #If nested folder is nested then update logical path
        $DirectoryFullName = $fromFolder.Substring(0,$fromfolder.Length-1)
        

        if($File.Directory.FullName -eq $DirectoryFullName) {
             Write-Verbose "Save-ARWStoreFolder: Running Save-ARWStoreFile -fromFolder $($fromFolder) -rootName $($File.BaseName) -Ext $($Ext) -LogicalPath $($LogicalPath) -Volume $($Volume)"
            .\Save-ARWStoreFile.ps1 -fromFolder $fromFolder -rootName $File.BaseName -Ext $Ext -LogicalPath $LogicalPath -Verbose -Volume $Volume
        }

        else {
            if($LogicalPath -eq "\") {
                $NestedLogicalPath = "{0}{1}" -f ($LogicalPath,($File.Directory.FullName).Replace($($FromFolder),''))
                $NestedFromFolder = "{0}\" -f ($File.Directory.FullName)
            }
            else {
                $NestedLogicalPath = "{0}\{1}" -f ($LogicalPath,($File.Directory.FullName).Replace($($FromFolder),''))
                $NestedFromFolder = "{0}\" -f ($File.Directory.FullName)
            }           
            
            Write-Verbose "Save-ARWStoreFolder: Running Save-ARWStoreFile -fromFolder $($NestedFromFolder) -rootName $($File.BaseName) -Ext $($Ext) -LogicalPath $($NestedLogicalPath) -Volume $($Volume)"
            .\Save-ARWStoreFile.ps1 -fromFolder $NestedFromFolder -rootName $File.BaseName -Ext $Ext -LogicalPath $NestedLogicalPath -Verbose -Volume $Volume
        }   
    } 
}

