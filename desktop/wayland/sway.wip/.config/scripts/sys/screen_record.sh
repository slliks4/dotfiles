#!/bin/bash
# screen_record.sh toggle | toggle-mic | stop

record_folder=~/Videos/Recordings
mkdir -p "$record_folder"
stamp=$(date +'%Y-%m-%d || %H:%M:%S').mp4
record_file="$record_folder/$stamp"
pid_file="/tmp/wf-recorder.pid"

is_recording() {
    [[ -f "$pid_file" ]] && kill -0 "$(cat $pid_file)" 2>/dev/null
}

case "$1" in
  toggle)
    if is_recording; then
      kill -INT "$(cat $pid_file)" && rm "$pid_file"
      notify-send -t 1500 "樂  Recording stopped"
    else
      region=$(slurp) || exit
      wf-recorder -g "$region" -f "$record_file" &
      echo $! > "$pid_file"
      notify-send -t 1500 "雷  Screen recording started"
    fi
    ;;

  toggle-mic)
    if is_recording; then
      kill -INT "$(cat $pid_file)" && rm "$pid_file"
      notify-send -t 1500 "樂  Recording stopped"
    else
      region=$(slurp) || exit
      wf-recorder -g "$region" -a -f "$record_file" &
      echo $! > "$pid_file"
      notify-send -t 1500 "  Screen + Mic recording started"
    fi
    ;;

  stop)
    if is_recording; then
      kill -INT "$(cat $pid_file)" && rm "$pid_file"
      notify-send -t 1500 "樂  Recording stopped"
    fi
    ;;

  *)
    echo "Usage:"
    echo "  $0 toggle         # start/stop recording"
    echo "  $0 toggle-mic     # start/stop with mic"
    echo "  $0 stop           # just stop"
    ;;
esac
