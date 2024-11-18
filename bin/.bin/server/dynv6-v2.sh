#!/usr/bin/env bash

#tokens+=('token_key')

ipv6_addr=$(curl -fSsk https://ipv6.text.myip.wtf)

for token in ${tokens[*]}; do
	zoneID=$(curl -X GET \
		-s --connect-timeout 10 \
		-H "Accept: application/json" \
		-H "Authorization: Bearer $token" \
		"https://dynv6.com/api/v2/zones" | jq -r .[].id)

	resultv6=$(curl -X GET \
		-s --connect-timeout 10 \
		-H "Accept: application/json" \
		-H "Authorization: Bearer $token" \
		"https://dynv6.com/api/v2/zones/$zoneID/records")

	recordID=$(echo $resultv6 | jq -r .[].id)

	if [[ ! "$(echo $resultv6 | jq -r .[].data)" == "$ipv6_addr" ]]; then
		curl -X PATCH \
			-s --connect-timeout 10 \
			-H "Authorization: Bearer $token" \
			-H "Accept: application/json" \
			--json $(printf '{"data":"%s"}' $ipv6_addr) \
			"https://dynv6.com/api/v2/zones/$zoneID/records/$recordID"
	fi
done
