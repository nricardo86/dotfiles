set -gx EDITOR nvim
set -gx BROWSER brave-browser-stable
set -gx TERM tmux-256color

#fish_add_path $HOME/.local/bin
#fish_add_path $HOME/.bin

if type -q exa
  abbr ls "exa --icons"
  abbr l "exa --icons -lg"
  abbr la "exa --icons -lag"
end

abbr za "zathura"
abbr cd "z"
abbr wttr "curl wttr.in/"
abbr rsync "rsync -avhP"
abbr nmc "nmcli --ask"
abbr wtf6 "curl -fSs6 myip.wtf/json | jq"
abbr wtf "curl -fSs4 myip.wtf/json | jq"
abbr dd "dd status=progress"
abbr cal "ncal -C"
abbr free "free -mh"
abbr b "batcat"
abbr df "df -hT"
abbr s "du -hcs"
abbr mkdir "mkdir -pv"
abbr newKey 'gpg-connect-agent "scd serialno" "learn --force" /bye'
abbr reloadAgent 'gpg-connect-agent reloadagent /bye'
abbr feh 'feh --scale-down'
abbr wq 'sudo wg-quick'
abbr um 'udisksctl mount -b'
abbr uu 'udisksctl unmount -b'
abbr fmu 'fusermount -u'
abbr tat 'tmux at -t'
abbr lp 'lp -o fit-to-page'
abbr lpbln 'ssh bln lp -o fit-to-page'

if test -z (pgrep ssh-agent)
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# if status is-login
#   if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1  ]
#    exec startx /usr/bin/i3
#   end
# end

if status is-login
  if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]
   exec Hyprland
  end
end

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

zoxide init fish | source
fzf --fish | source
fzf_configure_bindings
# eval (tmuxifier init - fish)
source $HOME/.asdf/asdf.fish
