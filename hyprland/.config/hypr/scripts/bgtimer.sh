CONFIG_FILES="$HOME/.bg_timer"

if [ ! -e $CONFIG_FILES ]; then
    touch $CONFIG_FILES
fi

while true; do
    inotifywait -q -e attrib $CONFIG_FILES
    $HOME/.config/hypr/scripts/bgaction.sh
done
