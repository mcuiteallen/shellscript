
cd C:\Users\admin\curl-7.64.0-win64-mingw\bin
$count=0

For($i = 1; $i -le 30; $i++)
{
    $date=date
	$result=.\curl -s -w "%{http_code}" -o /dev/null  http://localhost/Education --connect-timeout 10
	echo $result $count
	if($result -ne "302" -and $result -ne "200"){
		echo $date >> result.txt
		echo "error" >> result.txt
	    $count += 1
		sleep 2
	}else{
	    sleep 2
	}
	if($count -ge 25){
	    Stop-Service -Name W3SVC
		sleep 2
		Start-Service -Name W3SVC
		$count=0
		echo $date >> result.txt
		echo "already restart">> result.txt
		curl  -Headers @{"Content-Type"="application/json"}  -Method Post -Body '{"toEmail":"ecntpc-alert.idv@insynerger.com","subject":"[ECNTPC Portal Error]", "body":"Already restart~ Please Check"}'  https://mc.insynerger.com/api/deploy/alert/mail -UseBasicParsing
		break
	}
}
Exit