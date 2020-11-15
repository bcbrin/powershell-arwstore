#Import Functions.ps1 
. ".\Functions.ps1"


$fromFolder = "C:\BBRIN\ISOs\"
$rootName = "SW_DVD9_SQL_Svr_Enterprise_Edtn_2012_English_MLF_X17-96957"
$ext = "iso"
$MaxParts = 8

Split-File -fromFolder $fromFolder -rootName $rootName -ext $ext -MaxParts $MaxParts


$fromFolder = "C:\BBRIN\ISOs\Parts\"
Combine-Files -fromFolder $fromFolder -rootName $rootName -ext $ext