#!/usr/bin/env bash

timeout=5
auth="asdf:qwert@"
url="https://ntfy.nasatto.com/ups"

status=($(cat /run/user/1000/nhs.json | jq .arraybits_status[]))

desligaServer () {
	sendMsg "Desligando Servidor"
#	ssh -i ~/.ssh/id_ed25519 asdf@10.0.4.60
}

sendMsg () {
	curl -fSsk ${url} -u ${auth} -d "$1"
}

if [[ ! -e ~/.semRedeTimeout && -e ~/.redeFail && "$(find ~/.redeFail -mmin +$((${timeout} * 60)))" ]]; then
	sendMsg "Sem rede a mais de ${timeout}h"
	touch ~/.semRedeTimeout
	desligaServer
fi

if [[ ! -e ~/.redeFail && "${status[2]}" == 1 ]]; then
	sendMsg "Falha na rede"
	touch ~/.redeFail
fi

if [[ -e ~/.redeFail && "${status[4]}" == 1 ]]; then
	sendMsg "Restauro rede"
	rm ~/{.redeFail,.semRedeTimeout}
fi

if [[ ! -e ~/.bateriaBaixa && "${status[1]}" == 1 ]]; then
	sendMsg "Bateria Baixa"
	desligaServer
	touch ~/.bateriaBaixa
fi

if [[ -e ~/.bateriaBaixa && "${status[1]}" == 0 ]]; then
	rm ~/.bateriaBaixa
fi


