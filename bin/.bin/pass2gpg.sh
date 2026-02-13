#!/usr/bin/env bash
# https://github.com/drduh/pwd.sh/blob/master/pwd.sh
#set -x  # uncomment to debug
set -o errtrace
set -o nounset
set -o pipefail
umask 077
export LC_ALL="C"

pass_echo="${PWDSH_ECHO:=*}"

dest=${1:-pwd}

get_pass() {
  # Prompt for a password.

  password=""
  prompt="  ${1}"
  printf "\n"

  while IFS= read -p "${prompt}" -r -s -n 1 char; do
    if [[ ${char} == $'\0' ]]; then
      break
    elif [[ ${char} == $'\177' ]]; then
      if [[ -z "${password}" ]]; then
        prompt=""
      else
        prompt=$'\b \b'
        password="${password%?}"
      fi
    else
      prompt="${pass_echo}"
      password+="${char}"
    fi
  done
}

encrypt() {
  # Encrypt with GPG.

  secret="${1}"

  gpg --armor --batch \
    --symmetric --yes --passphrase-fd 3 \
    --output "${2}" "${3}" 3< \
    <(printf "%s" "${secret}") 2>/dev/null
}

write_pass() {
  get_pass "Password for Symmetric Encrypt: "
  IFS=$'\n'
  index=3
  for i in $(find $HOME/.password-store/ -type f -name '*.gpg'); do
    IFS='/' read -r -a array <<<"$i"
    limit=$((${#array[@]} - 1))
    count=$((${#array[@]} - ((${#array[@]} - 4))))
    folder=()
    folder+="./$dest/"
    while [ $count -lt $limit ]; do
      folder+="${array[$count]}/"
      ((count++))
    done
    mkdir -p $folder
    echo "encrpyting: $folder${array[$limit]}"
    userpass=$(gpg -d --quiet --batch $i)
    printf '%s\n' "${userpass}" | encrypt "${password}" "${folder}${array[$limit]}" -
  done
}

password=""
write_pass
