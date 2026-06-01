set fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
set -gx EDITOR nvim
set -gx BROWSER librewolf
set -gx TERM screen-256color
set -gx MANPAGER "batcat -l man"

if type -q eza
    abbr ls "eza --icons"
    abbr l "eza --icons -lg"
    abbr la "eza --icons -lag"
end
abbr grep "grep --color=auto"
abbr hl "grep -z"
abbr rsync "rsync -avhP"
abbr nmc "nmcli --ask"
abbr wtf "curl --connect-timeout 5 -fSs ipv4.json.myip.wtf 2>/dev/null | jq"
abbr wtf6 "curl --connect-timeout 5 -fSs ipv6.json.myip.wtf 2>/dev/null | jq"
abbr dd "dd status=progress"
abbr cal "ncal -C"
abbr free "free -mh"
abbr df "df -hT"
abbr s "du -hcs"
abbr mkdir "mkdir -pv"
abbr newKey 'gpg-connect-agent "scd serialno" "learn --force" /bye'
abbr reloadAgent 'gpg-connect-agent reloadagent /bye'
abbr wq 'doas wg-quick'
abbr wg 'doas wg'
abbr um 'udisksctl mount -b'
abbr uu 'udisksctl unmount -b'
abbr fmu 'fusermount -u'
abbr lp 'lp -o fit-to-page'
abbr lpbln 'lp -o fit-to-page -d bln'
abbr update "doas apt update && doas apt upgrade -q && flatpak upgrade -y"
abbr install "doas apt install"
abbr remove "doas apt autoremove --purge"
abbr mu mullvad
abbr mus "mullvad status"
abbr muc "mullvad connect"
abbr mud "mullvad disconnect"
abbr msplit "mullvad split-tunnel add $fish_pid"
abbr ta tailscale
abbr tas "tailscale status"
abbr tau "tailscale up"
abbr tad "tailscale down"
abbr dnsgoogle "q @https://dns.google.com"
abbr dnscloud "q @https://dns.cloudflare.com"
abbr i swayimg
abbr img chafa
abbr b batcat
abbr pff "pass ff"
abbr p2fa "pass 2fa"
abbr gp "git add . && git commit && git push"
abbr gs "git status -s"
abbr gd "git diff"
abbr gl "git log --oneline --graph --all"
abbr lg lazygit
abbr fd "fd --type f --hidden --exclude .git --exclude node_modules"
abbr fp "fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p --preview='batcat --color=always {}'"
abbr fe "fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p | xargs nvim"
abbr fileext "find . -type f | awk -F \".\" '{ print \$(NF) }' | sort -u"

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

#initializing zoxide and fzf
zoxide init fish | source
fzf --fish | source
fzf_configure_bindings

#Start Hyprland
if uwsm check may-start >/dev/null && [ "$XDG_VTNR" -eq 1 ]
    exec uwsm start hyprland.desktop
end
