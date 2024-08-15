#!/usr/bin/env bash
show=()
if [[ -n $BLOCK_INSTANCE ]]; then
  INTERFACE=$BLOCK_INSTANCE
else
  INTERFACE=$(sudo wg show | grep interface | cut -d" " -f2)
fi

if [[ -n $INTERFACE ]]; then
    show+="WG: "
    show+=$(echo $INTERFACE)
fi

echo "${show[@]}"
