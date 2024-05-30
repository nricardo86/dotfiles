#!/usr/bin/env bash
ARG=("$@")

xrandr_opts=()

monitor=()

NOW=$(date +%H | bc)

for i in $(xrandr | sed -n 's/^\([^ ]*\).connected.*/\1/p'); do
    monitor+=($i)
done

while getopts "i g: m: b: l d h" opt 2>/dev/null; do
    case ${opt} in
    i)
        echo "Init Monitor Config!!"
        echo ""

        for i in ${monitor[@]}; do
            reso=$(xrandr | grep $i -A1 | tail -n1 | awk '{print $1}')
            xrandr --output $i --primary --mode $reso
            echo "Monitor: $i"
            echo "Brightness: $(xrandr --verbose | grep $i -A5 -m1 | grep "Brightness" | awk '{print $2}')"
            echo "Resolution: $reso"
            echo ""
        done

        position=${POSITION:='right'}
        count=${#monitor[@]}
        while [ $count -gt 1 ]; do
            ((count--))
            xrandr --output ${monitor[$(($count - 1))]} "--$position-of" ${monitor[$count]}
            echo "Monitor ${monitor[$(($count - 1))]} right of ${monitor[$count]}"
        done
        ;;
    h)
        echo "Options"
        echo "-i Init Monitor Config"
        echo "-l List Monitor"
        echo "-m Select Monitor"
        echo "-b Brightness"
        echo "-d Day Mode only"
        echo "-g Gamma"
        exit 0
        ;;
    l)
        echo "Connected Monitors:"
        for i in ${monitor[@]}; do
            echo $i
        done
        ;;
    d)
        if [ -e $HOME/.monitor-opts-day ]; then
            rm $HOME/.monitor-opts-day
            dunstify "Day Mode Only disable!"
            echo "Day Mode Only disable!"
        else
            touch $HOME/.monitor-opts-day
            echo "Day Mode Only enable!"
            dunstify "Day Mode Only enable!"
        fi
        ;;
    m)
        if [[ ${monitor[@]} =~ ${ARG[OPTIND - 2]} ]]; then

            unset monitor
            monitor=${ARG[$OPTIND - 2]}
        else
            echo 'Device not found!'
            dunstify 'Device not found!'
            exit 1
        fi
        ;;
    g) GAMMA_OPT=${ARG[$OPTIND - 2]} ;;
    b) BRIGHTNESS_OPT=${ARG[$OPTIND - 2]} ;;
    \?)
        echo "Invalid Options"
        dunstify "Invalid Options"
        exit 1
        ;;
    esac
done

for i in "${monitor[@]}"; do
    if [[ ! -n $GAMMA_OPT ]]; then
        if [[ "$NOW" -le 5 || "$NOW" -gt 17 ]]; then
            GAMMA_OPT=night
        else
            GAMMA_OPT=day
        fi
        if [ -e $HOME/.monitor-opts-day ]; then
            GAMMA_OPT=day
        fi
    fi
    case $GAMMA_OPT in
    night) GAMMA='1:0.78:0.55' ;;
    day) GAMMA='1:1:1' ;;
    *) GAMMA=${ARG[$OPTIND - 2]} ;;
    esac
    xrandr_opts+=("--gamma $GAMMA")

    current=$(xrandr --verbose | grep $i -A5 -m1 | grep "Brightness" | awk '{print $2}')
    if [[ -n $BRIGHTNESS_OPT ]]; then
        case $BRIGHTNESS_OPT in
        +) BRIGHTNESS=$(echo $current + 0.1 | bc) ;;
        -) BRIGHTNESS=$(echo $current - 0.1 | bc) ;;
        *) BRIGHTNESS=$BRIGHTNESS_OPT ;;
        esac
    else
        BRIGHTNESS=$current
    fi
    xrandr_opts+=("--brightness $BRIGHTNESS")
    xrandr --output $i ${xrandr_opts[@]}
done

#{ 1.00000000,  0.18172716,  0.00000000, }, /* 1000K */
#{ 1.00000000,  0.42322816,  0.00000000, },
#{ 1.00000000,  0.54360078,  0.08679949, },
#{ 1.00000000,  0.64373109,  0.28819679, },
#{ 1.00000000,  0.71976951,  0.42860152, },
#{ 1.00000000,  0.77987699,  0.54642268, },
#{ 1.00000000,  0.82854786,  0.64816570, }, /* 4000k */
#{ 1.00000000,  0.86860704,  0.73688797, },
#{ 1.00000000,  0.90198230,  0.81465502, },
#{ 1.00000000,  0.93853986,  0.88130458, },
#{ 1.00000000,  0.97107439,  0.94305985, },
#{ 1.00000000,  1.00000000,  1.00000000, }, /* 6500K */
#{ 0.95160805,  0.96983355,  1.00000000, },
#{ 0.91194747,  0.94470005,  1.00000000, },
#{ 0.87906581,  0.92357340,  1.00000000, },
#{ 0.85139976,  0.90559011,  1.00000000, },
#{ 0.82782969,  0.89011714,  1.00000000, },
#{ 0.80753191,  0.87667891,  1.00000000, },
#{ 0.78988728,  0.86491137,  1.00000000, }, /* 10000K */
#{ 0.77442176,  0.85453121,  1.00000000, },
