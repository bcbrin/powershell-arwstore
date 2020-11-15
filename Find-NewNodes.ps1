$Computers = Get-ADComputer -Filter {Name -like "H-0167*"} | Select -ExpandProperty Name 
$max = 4

$i = 0

 
foreach ($Computer in $Computers) {
    if(Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
        Write-Output $Computer
        $i++
        if($i -eq $max) {
            break
        }
    }
}
