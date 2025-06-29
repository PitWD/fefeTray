#!/bin/bash
URL="blog.fefe.de"
fileREF="./fefe.ref"
fileTMP="./fefe.tmp"
fileLOG=""                  # Optional log file, e.g. fileLOG="./fefe.log"
filePIPE="./fefe.pipe"
iconERROR="./fefe_RED.png"
iconWAIT="./fefe_GREY.png"
iconNEW="./fefe_GREEN.png"
trayIcon="$iconERROR"
interval=1800               # seconds

scriptPID=$$
rm "$filePIPE" > /dev/null 2>&1
rm "$fileTMP" > /dev/null 2>&1

GetPage() {
    # fetch page, removes HTML tags, trims whitespace,
    # filters empty lines, and limit size to the first 25 lines.
    curl -s "$URL" \
        | sed 's/<[^>]*>//g' \
        | sed 's/^[ \t]*//;s/[ \t]*$//' \
        | grep -v '^$' \
        | head -n 25
}
CheckPage() {
    GetPage > "$fileTMP"
    if [ "$trayIcon" != "$iconNEW" ] || [ ! -s "$fileREF" ] || [ ! -s "$fileTMP" ]; then
        # Don't change icon while blog-update and fileREF exists
        # "Open Blog" and "Reset" removes fileREF and indicates "user got the update"
        if [ -s "$fileTMP" ]; then
            trayIcon="$iconWAIT"
        else
            trayIcon="$iconERROR"
        fi
    fi
    if [ ! -f "$fileREF" ]; then
        cp "$fileTMP" "$fileREF"
        if [ "$fileLOG" != "" ]; then
            # Log only if fileLOG exists
            if [ -n "$fileTMP" ]; then
                echo "$(date): Init OK." | tee -a "$fileLOG"
            else
                echo "$(date): Init NOK." | tee -a "$fileLOG"
            fi
        fi
    else
        urlDIFF=$(diff --unified=0 "$fileREF" "$fileTMP")
        if [ -n "$urlDIFF" ]; then
            if [ "$fileLOG" != "" ]; then
                # Log only if fileLOG exists
                echo "$(date): Change:" | tee -a "$fileLOG"
                echo "$urlDIFF" | tee -a "$fileLOG"
            fi
            cp "$fileTMP" "$fileREF"
            trayIcon="$iconNEW"
        else
            if [ "$fileLOG" != "" ]; then
                # Log only if fileLOG exists
                echo "$(date): No change." | tee -a "$fileLOG"
            fi
        fi
    fi
    rm "$fileTMP"
}

mkfifo $filePIPE
exec 3<> $filePIPE
yad --notification \
    --listen \
    --image="$trayIcon" \
    --text="$strINFO" <&3 &

yadPID=$!

echo "menu:\
Open Blog!bash -c 'rm $fileREF && xdg-open https://$URL &'|\
Stop!bash -c 'rm $filePIPE && kill $yadPID && kill $scriptPID'|\
Reset!bash -c 'rm $fileREF'" >&3

while true; do
    CheckPage
    case "$trayIcon" in
        "$iconERROR")
            strINFO="Error fetching updates!"
            ;;
        "$iconWAIT")
            strINFO="Waiting for updates..."
            ;;
        "$iconNEW")
            strINFO="New updates available!"
            ;;
    esac
    echo "icon:$trayIcon" >&3
    echo "tooltip:$strINFO" >&3
    sleepTime=${interval}
    while [ -f "$fileREF" ] && [ "$sleepTime" -gt 0 ]; do
        # sleep only while fileREF exists
        sleep 1
        ((sleepTime -= 1))
    done
done
