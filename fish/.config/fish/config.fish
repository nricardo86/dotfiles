set fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
set -gx EDITOR nvim
set -gx BROWSER librewolf
set -gx TERM screen-256color
set -x MANPAGER "sh -c 'batcat -l man -p'"

if type -q eza
  abbr ls "eza --icons"
  abbr l "eza --icons -lg"
  abbr la "eza --icons -lag"
end
abbr sudo "doas"
abbr hl "grep -z"
abbr za "zathura"
abbr cd "z"
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
abbr update "doas apt update && doas apt upgrade -q && flatpak upgrade"
abbr install "doas apt install"
abbr remove "doas apt autoremove --purge"
abbr msplit "mullvad split-tunnel add $fish_pid"
abbr mu "mullvad"
abbr mus "mullvad status"
abbr muc "mullvad connect"
abbr mud "mullvad disconnect"
abbr dnsgoogle "q @https://dns.google.com"
abbr dnscloud "q @https://dns.cloudflare.com"
abbr dnsnasatto "q @https://dns.nasatto.com"
abbr i "swayimg"
abbr img "chafa"
abbr b "batcat"
abbr pff "pass ff"
abbr gp "git add . && git commit && git push"
abbr gs "git status -s"
abbr gl "git log --oneline --graph --all"
abbr gd "git diff"
abbr lg "lazygit"
abbr fd "fd --type f --hidden --exclude .git --exclude node_modules"
abbr fp "fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p --preview='batcat --color=always {}'"
abbr fn "fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p | xargs nvim"

function gbr --description "Git browse commits"
    set -l log_line_to_hash "echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    set -l view_commit "$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R'"
    set -l copy_commit_hash "$log_line_to_hash | wl-copy"
    set -l git_checkout "$log_line_to_hash | xargs -I % sh -c 'git checkout %'"
    set -l open_cmd "open"

    if test (uname) = Linux
        set open_cmd "xdg-open"
    end

    set github_open "$log_line_to_hash | xargs -I % sh -c '$open_cmd https://github.\$(git config remote.origin.url | cut -f2 -d. | tr \':\' /)/commit/%'"

    git log --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | \
        fzf --no-sort --reverse --tiebreak=index --no-multi --ansi \
            --preview="$view_commit" \
            --header="ENTER to view, CTRL-Y to copy hash, CTRL-O to open on GitHub, CTRL-X to checkout, CTRL-C to exit" \
            --bind "enter:execute:$view_commit" \
            --bind "ctrl-y:execute:$copy_commit_hash" \
            --bind "ctrl-x:execute:$git_checkout" \
            --bind "ctrl-o:execute:$github_open"
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function gpga 
    pkill gpg-agent
    set -x GPG_TTY (tty)
    gpgconf --launch gpg-agent
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent updatestartuptty /bye > /dev/null
    gpg-connect-agent reloadagent /bye
end

#Support gpg-agent
if ! pgrep gpg-agent > /dev/null
    set -x GPG_TTY (tty)
    gpgconf --launch gpg-agent
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent updatestartuptty /bye > /dev/null
    gpg-connect-agent reloadagent /bye
end

#Suport ssh-agent
if ! pgrep ssh-agent > /dev/null
    eval (ssh-agent -c > /dev/null)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end


#initializing zoxide and fzf
zoxide init fish | source
fzf --fish | source
fzf_configure_bindings

#Start Hyprland
if uwsm check may-start > /dev/null && [ "$XDG_VTNR" -eq 1 ]
    exec uwsm start hyprland.desktop 
end

