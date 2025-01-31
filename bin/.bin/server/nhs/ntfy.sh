#!/usr/bin/env bash

dir=/var/tmp/nhs
url="https://ntfy.nasatto.com/ups"

truncate -s 10240 ${dir}/nhs.log

status=($(cat ${dir}/nhs.json | jq .arraybits_status[]))
vbat=$(echo "scale=1;$(cat ${dir}/nhs.json | jq .VDCMED) / 10" | bc)
potRMS=$(echo "scale=1;$(cat ${dir}/nhs.json | jq .POTRMS) * 10" | bc)

if [ -z $status ]; then
	echo "fail"
	exit 1
fi

desligaServer() {
	sendMsg "Desligando Servidor"
	#ssh -i ~/.ssh/id_ed25519 asdf@10.0.4.60
}

sendMsg() {
	curl -fSsk ${url} -u ${auth} -d "$1"
}

if [[ ! -e ${dir}/redeFail && "${status[2]}" == 1 ]]; then
	sendMsg "Falha na rede! Potencia atual: ${potRMS}W"
	touch ${dir}/redeFail
fi

if [[ -e ${dir}/redeFail && "${status[4]}" == 1 ]]; then
	sendMsg "Restauro rede!"
	rm ${dir}/{redeFail,semRedeTimeout}
fi

if [[ ! -e ${dir}/bateriaBaixa && "${status[1]}" == 1 ]]; then
	sendMsg "Bateria Baixa: ${vbat}"
	sendMsg "Potencia Atual: ${potRMS}"
	desligaServer
	touch ${dir}/bateriaBaixa
fi

if [[ -e ${dir}/bateriaBaixa && "${status[1]}" == 0 ]]; then
	rm ${dir}/bateriaBaixa
fi
