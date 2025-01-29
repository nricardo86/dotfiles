set fish_greeting
set -gx EDITOR nvim
set -gx BROWSER brave-browser-stable
set -gx TERM tmux-256color

if type -q exa
  abbr ls "exa --icons"
  abbr l "exa --icons -lg"
  abbr la "exa --icons -lag"
end
abbr za "zathura"
abbr cd "z"
abbr rsync "rsync -avhP"
abbr nmc "nmcli --ask"
abbr wtf "curl --connect-timeout 5 -fSsk https://ipv4.json.myip.wtf 2>/dev/null | jq"
abbr wtf6 "curl --connect-timeout 5 -fSsk https://ipv6.json.myip.wtf 2>/dev/null | jq"
abbr dd "dd status=progress"
abbr cal "ncal -C"
abbr free "free -mh"
abbr bat "batcat"
abbr df "df -hT"
abbr s "du -hcs"
abbr mkdir "mkdir -pv"
abbr newKey 'gpg-connect-agent "scd serialno" "learn --force" /bye'
abbr reloadAgent 'gpg-connect-agent reloadagent /bye'
abbr wq 'sudo wg-quick'
abbr um 'udisksctl mount -b'
abbr uu 'udisksctl unmount -b'
abbr fmu 'fusermount -u'
abbr tat 'tmux at -t'
abbr lp 'lp -o fit-to-page'
abbr lpbln 'ssh bln lp -o fit-to-page'
abbr i "swayimg"
abbr update "sudo apt update && sudo apt upgrade"
abbr install "sudo apt install"
abbr remove "sudo apt autoremove --purge (deborphan)"
#abbr i "kitty +kitten icat "
#abbr icat "kitty +kitten icat"

if test -z (pgrep ssh-agent)
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

if status is-login
  if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]
   exec Hyprland
  end
end

zoxide init fish | source
fzf --fish | source
fzf_configure_bindings
# eval ($HOME/.config/tmux/plugins/tmuxifier/bin/tmuxifier init - fish)
# source $HOME/.asdf/asdf.fish
