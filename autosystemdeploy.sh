#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function deploy {
        cd /home
        sudo rm -rf /home/execute*
        sudo rm -rf /home/InsynergerRun.sh
        sudo rm -rf /home/statedetection.sh
        sudo rm -rf /home/*.out
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeinpark-vm1.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeinfactory-vm1.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeinpark-sta.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeinfactory-sta.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeat.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeinpark-vm2.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/expect-autotest/executeinfactory-vm2.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/productfile/replaceme/InsynergerRun.sh
        sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/statedetection.sh
        sudo chmod +x /home/*.sh

        nohup /home/./executeinfactory-sta.sh  > infactory-sta.out 2>&1
        echo "-------------------infactory-sta & postgresql---------------------"  >> result.out 2>&1
        sleep 400
        /home/./statedetection.sh -type infactory  >> result.out 2>&1
        /home/./statedetection.sh -type postgresql  >> result.out 2>&1  
 
        nohup /home/./executeinfactory-vm2.sh  > infactory-vm2.out 2>&1
        echo "----------------------infactory-vm1&vm2---------------------------"  >> result.out 2>&1
        sleep 60
        /home/./statedetection.sh -type postgresql  >> result.out 2>&1
        nohup /home/./executeinfactory-vm1.sh  > infactory-vm1.out 2>&1
        sleep 400
        /home/./statedetection.sh -type infactory  >> result.out 2>&1

        nohup /home/./executeinpark-sta.sh  > inpark-sta.out 2>&1
        sleep 180
        echo "-------------------inpark-sta & postgresql------------------------"  >> result.out 2>&1
        /home/./statedetection.sh -type inpark  >> result.out 2>&1
        /home/./statedetection.sh -type postgresql  >> result.out 2>&1

        nohup /home/./executeinpark-vm2.sh   > inpark-vm2.out 2>&1
        echo "-----------------------inpark-vm1&vm2-----------------------------"  >> result.out 2>&1
        sleep 60
        /home/./statedetection.sh -type postgresql  >> result.out 2>&1
        nohup /home/./executeinpark-vm1.sh  > inpark-vm1.out 2>&1
        sleep 180
        /home/./statedetection.sh -type inpark  >> result.out 2>&1

        #nohup /home/./executeat.sh  > at.out 2>&1
        #echo "-------------------------at & mysql-------------------------------"  >> result.out 2>&1
        #sleep 180
        #/home/./statedetection.sh -type at  >> result.out 2>&1
        #/home/./statedetection.sh -type mysql  >> result.out 2>&1
        cd /home
        sudo /bin/curl -T result.out -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/productfile/replaceme/log/  --ftp-create-dirs
}
deploy

