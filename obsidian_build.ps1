$p0=$($args[0])
$p1=$($args[1])
$p2=$($args[2])
$p3=$($args[3])
$p4=$($args[4])
Remove-item -force "C:\Users\BvSsh_VirtualUsers\$p1\$p0.zip"
Remove-item -force -R "C:\Users\BvSsh_VirtualUsers\$p1\$p0"
Copy-item -force "C:\Users\BvSsh_VirtualUsers\$p0.zip" "C:\Users\BvSsh_VirtualUsers\$p1"
cd "C:\Users\BvSsh_VirtualUsers\$p1"
unzip .\"$p0.zip"
Stop-Service -Name "$p3"  -Force
if($? -eq "True") { Write-Host "$p3 is success stop" `n} else { Write-Host "false" `n}
ping 8.8.8.8
Remove-item -force "C:\apps\$p4\$p4\$p0.jar"
ping 8.8.8.8
Copy-Item -Force "C:\Users\BvSsh_VirtualUsers\$p1\$p4\$p4\$p0.jar" "C:\apps\$p4\$p4"
Remove-item -force -R "C:\apps\$p4\$p4\config"
Copy-Item -Force -R "C:\Users\BvSsh_VirtualUsers\$p1\$p4\$p4\config\" "C:\apps\$p4\$p4"
cd "C:\apps\$p4\$p4\config"
Remove-item -force "C:\apps\$p4\$p4\config\application.yml"
Rename-Item $p2 application.yml
Start-Service -Name  $p3
if($? -eq "True") { Write-Host "$p3 is success start" `n} else { Write-Host "false" `n}
Remove-item -force "C:\Users\BvSsh_VirtualUsers\$p0.zip"
