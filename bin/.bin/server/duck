#!/usr/bin/env bash
ISP="Acessoline Telecom"
TOKEN=''
DOMAINS=''

ipv4enable=true
ipv6enable=true
if [ ${ipv4enable} == true ]; then
	ipv4=$(curl --connect-timeout 3 -fSsk https://ipv4.json.myip.wtf 2>/dev/null)
	if [[ "" == "${ISP}" ]]; then
		ipv4_addr=$(echo ${ipv4} | jq -r .YourFuckingIPAddress)
		echo "IPv4: ${ipv4_addr}"
	else
		ipv4enable=false
		ipv4fail=true
	fi
else
	echo "IPv4 Disable"
fi

if [ ${ipv6enable} == true ];then
	ipv6_addr=$(curl --connect-timeout 3 -fSsk https://ipv6.text.myip.wtf 2>/dev/null)
else
	echo "IPv6 Disable"
fi

if [ -z ${ipv6_addr} ]; then
	echo "IPv6 fail"
	ipv6enable=false
else
	echo "IPv6: ${ipv6_addr}"
fi

if [[ ${ipv4enable} == true && ! "$(dig ${DOMAINS}.duckdns.org +short A)" == "${ipv4_addr}" ]]; then
	echo url="https://www.duckdns.org/update?domains=$DOMAINS&token=$TOKEN&ip=${ipv4_addr}" | curl -fSk -K -
fi

if [[ -n ${ipv4fail} ]]; then
	echo url="https://www.duckdns.org/update?domains=$DOMAINS&token=$TOKEN&ip=&clear=true" | curl -fSk -K -
fi

if [[ "${ipv6enable}" == true && ! "$(dig ${DOMAINS}.duckdns.org +short AAAA)" == "${ipv6_addr}" ]];then
	echo url="https://www.duckdns.org/update?domains=$DOMAINS&token=$TOKEN&ipv6=$ipv6_addr" | curl -fSk -K -
fi
