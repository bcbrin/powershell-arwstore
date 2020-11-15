#Import Functions.ps1 
. ".\Functions.ps1"

Reset-ARWStore ($Computers16Vol0)
Reset-ARWStore ($Computers4Vol1)
$RestorePath = "C:\BBRIN\ARWStore\Restore\"

$Volume0 = 0
$Volume1 = 1

$Computers16Vol0 = Get-Content -Path "C:\BBRIN\ARWStore\ComputerList\SenComputers16.txt"
$Computers4Vol1 = Get-Content -Path "C:\BBRIN\ARWStore\ComputerList\Computer4.txt"

$ReserveComputersVol0 = Get-Content -Path "C:\BBRIN\ARWStore\ComputerList\ReserveVol1.txt"
$ReserveComputersVol1 = Get-Content -Path "C:\BBRIN\ARWStore\ComputerList\ReserveVol2.txt"

$MaxPartsVol0 = 4
$MaxPartsVol1 = 2


$FileName = "'FSQuotaStatstics_06212017"
$Extension = "csv"

$FromFolder = "C:\BBRIN\Stuff\"
$fromFolder1 = "C:\ISOs\"

#Init two volumes
$Init4x4_Vol0 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers16Vol0 -MaxParts $MaxPartsVol0 -ReserveComputers $ReserveComputersVol0 -Volume $Volume0 }
$Init4x4_Vol1 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers4Vol1 -MaxParts $MaxPartsVol1 -ReserveComputers $ReserveComputersVol1 -Volume $Volume1 }

#Save to Root
$SaveFolder4x4_Vol0 = Measure-Command { .\Save-ARWStoreFolder.ps1 -Verbose -fromFolder $fromFolder -LogicalPath "\" -Volume $Volume0 }
$SaveFolder4x4_Vol1 = Measure-Command { .\Save-ARWStoreFolder.ps1 -Verbose -fromFolder $fromFolder1 -LogicalPath "\" -Volume $Volume1 }

#Save to Folder
#$SaveFolder4x4_Vol0 = Measure-Command { .\Save-ARWStoreFolder.ps1 -Verbose -fromFolder "C:\Users\bbrin\Pictures\" -LogicalPath "\Pictures" -Volume $Volume0 }
#$SaveFolder4x4_Vol1 = Measure-Command { .\Save-ARWStoreFolder.ps1 -Verbose -fromFolder "C:\Users\bbrin\Music\Augustus Pablo Presents Rockers Story\" -LogicalPath "\Pablo" -Volume $Volume1 }

#Get Folder x Root
$Get4x4_Vol0 = Measure-Command { .\Get-ARWStoreFolder.ps1 -Verbose -restorePath $RestorePath -LogicalPath "\" -Recurse -Volume $Volume0 }
$Get4x4_Vol1 = Measure-Command { .\Get-ARWStoreFolder.ps1 -Verbose -restorePath $RestorePath -LogicalPath "\" -Recurse -Volume $Volume1 }

#Remove File x Folders
$RemoveFile4x4_Vol0 = Measure-Command { .\Remove-ARWStoreFile.ps1 -Verbose -LogicalPath "\Bob's Stuff" -Volume $Volume0 -rootName "$FileName" -ext $Extension }
$RemoveFolder4x4_Vol0 = Measure-Command { .\Remove-ARWStoreFolder.ps1 -Verbose -LogicalPath "\Bob's Stuff" -Recurse -Volume $Volume0 }

#Rename
$RenameFile4x4_Vol0 = Measure-Command { .\Rename-ARWStoreFile.ps1 -Verbose -LogicalPath "\Bob's Stuff" -Volume $Volume0 -rootName $FileName -ext $Extension -NewName "DATABASE"}
$RenameFolder4x4_Vol0 = Measure-Command { .\Rename-ARWStoreFolder.ps1 -Verbose -LogicalPath "\Bob's Stuff" -Volume $Volume0 -NewName "\AugustusPablo" }
$RenameFolder4x4_Vol0 = Measure-Command { .\Rename-ARWStoreFolder.ps1 -Verbose -NewName "\Bob's Stuff" -Volume $Volume0 -LogicalPath "\AugustusPablo" }


#Move
$MoveFile4x4_Vol0 = Measure-Command { .\Move-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -LogicalPath "\Bob's Stuff" -Destination "\" -Verbose -Volume $Volume0 }
$MoveFolder4x4_Vol0 = Measure-Command { .\Move-ARWStoreFolder.ps1 -LogicalPath "\Bob's Stuff" -Destination "\Jan" -Verbose -Volume $Volume0 }
$MoveFolder4x4_Vol0 = Measure-Command { .\Move-ARWStoreFolder.ps1 -LogicalPath "\Scripts\Stuff" -Destination "\Jan\Pictures" -Verbose -Volume $Volume0 }



#Test Update
Remove-Item -Path "\\S-0016-121320\c$\ARWStore" -Recurse
$Update4x4 = Measure-Command { .\Update-ARWStore.ps1 -Verbose -Volume $Volume0 }
$Update4x4 = Measure-Command { .\Update-ARWStore.ps1 -Verbose -Volume $Volume1 }



#Test Get after delete
Remove-Item -Path "\\H-0136-502W74\c$\ARWStore\" -Recurse
Remove-Item -Path "\\H-0174-033N97\c$\ARWStore\" -Recurse
$Get4x4_Vol1 = Measure-Command { .\Get-ARWStoreFolder.ps1 -Verbose -restorePath $RestorePath -LogicalPath "\" -Recurse -Volume $Volume1 }
$Update4x4 = Measure-Command { .\Update-ARWStore.ps1 -Verbose -Volume $Volume1 }