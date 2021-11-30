#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

/bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/tagschema.sh
sudo chmod +x *.sh
checkDead=$(cat result.out |  grep Dead  | awk '{print $1}')
if [ -z ${checkDead} ]
then
    updatetime=$(date | sed -e "s/:/-/g" | sed -e "s/ /_/g")
    sudo ./tagschema.sh -newtagver ${newtagver} -updatetime ${updatetime} -version ${version} -infactoryfrontend ${infactoryfrontend} -inems ${inems} -inpark ${inpark} -cs ${cs} -gee ${gee} -ns ${ns} -chart ${chart} -edge ${edge} -infactorybackend ${infactorybackend} -ecbj ${ecbj} -ica ${ica} -statistic ${statistic} -statisticcache ${statisticcache} -authcenter ${authcenter} -simplerule ${simplerule}
	sudo curl --header "Content-Type: application/json" --request POST --data '{"messages":[{"type":"text","text":"Hello"}]}' http://alert-line.insynerger.com:7788/api/deploy/alert/line/notify
    sudo curl --header "Content-Type: application/json" --request POST --data '{"messages":[{"type":"text","text":"自動打包測試成功!以下是安裝包下載位置:"}]}' http://alert-line.insynerger.com:7788/api/deploy/alert/line/notify
    sudo curl --header "Content-Type: application/json" --request POST --data '{"messages":[{"type":"text","text":"ftp://download.insynerger.com:2100/productfile/replaceme/InsynergerRun.sh"}]}' http://alert-line.insynerger.com:7788/api/deploy/alert/line/notify
else
	sudo curl --header "Content-Type: application/json" --request POST --data '{"messages":[{"type":"text","text":"Hello"}]}' http://alert-line.insynerger.com:7788/api/deploy/alert/line/notify
    sudo curl --header "Content-Type: application/json" --request POST --data '{"messages":[{"type":"text","text":"自動打包測試有模組佈署不成功喔!!檢查一下吧"}]}' http://alert-line.insynerger.com:7788/api/deploy/alert/line/notify
fi
