set -gx EDITOR nvim
set -gx BROWSER brave-browser-stable
set -gx TERM tmux-256color

set -gx fish_user_paths \
  $HOME/.local/bin \
  $HOME/.bin \
  $HOME/.pbin \
  $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin \
  $HOME/.config/tmux/plugins/tmuxifier/bin

if type -q exa
  abbr ls "exa --icons"
  abbr l "exa --icons -lg"
  abbr la "exa --icons -lag"
end

abbr za "zathura"
abbr aptr "sudo apt autoremove --purge (deborphan)"
abbr apti "sudo apt install"
abbr aptu "sudo apt update && sudo apt upgrade"
abbr wttr "curl wttr.in/"
abbr rsync "rsync -avhP"
abbr cal "ncal -C"
abbr cb "xsel -bc && xsel -pc && xsel -sc"
abbr xcp "xclip -sel clipboard"
abbr nmc "nmcli --ask"
abbr wtf6 "curl -fSs6 myip.wtf/json | jq"
abbr wtf "curl -fSs4 myip.wtf/json | jq"
abbr dd "dd status=progress"
abbr s "du -hcs"
abbr free "free -mh"
abbr lpbln "ssh bln lp -o fit-to-page"
abbr lp "lp -o fit-to-page"
abbr b "batcat"
abbr df "df -hT"
abbr mkdir "mkdir -pv"
abbr bose "bluetoothctl connect 4C:87:5D:A1:3A:D2"
abbr jbl "bluetoothctl connect B8:F6:53:E6:78:C8"
abbr newKey 'gpg-connect-agent "scd serialno" "learn --force" /bye'
abbr reloadAgent 'gpg-connect-agent reloadagent /bye'
abbr feh 'feh --scale-down'
abbr o 'open'
abbr fm 'ranger'
abbr wq 'sudo wg-quick'
abbr um 'udisksctl mount -b'
abbr uu 'udisksctl unmount -b'
abbr fmu 'fusermount -u'
abbr tat 'tmux at -t'

if test -z (pgrep ssh-agent)
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

if status is-login
  if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1  ]
   exec startx /usr/bin/i3
  end
end

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

rmdir $HOME/Desktop 2>/dev/null

zoxide init fish | source
. $HOME/.asdf/asdf.fish
eval (tmuxifier init - fish)
# eval "$(oh-my-posh init fish --config $HOME/.config/ohmyposh/zen.toml | source)"
fzf_configure_bindings
