#!/usr/bin/env bash
# Focus the nearest window in the given direction (west/east/north/south)
# on the current space, based on actual window frame geometry. Unlike
# `yabai -m window --focus <direction>`, this also works for floating
# windows since it doesn't rely on the bsp tree.
set -euo pipefail

direction="$1"

windows=$(yabai -m query --windows --space)
focused=$(echo "$windows" | jq '[.[] | select(.["has-focus"] == true)][0]')

[ "$focused" = "null" ] && exit 0

fx=$(echo "$focused" | jq '.frame.x + .frame.w / 2')
fy=$(echo "$focused" | jq '.frame.y + .frame.h / 2')
fid=$(echo "$focused" | jq '.id')

target=$(echo "$windows" | jq --argjson fx "$fx" --argjson fy "$fy" --argjson fid "$fid" --arg dir "$direction" '
  map(select(.id != $fid and .["is-minimized"] == false))
  | map(. + {cx: (.frame.x + .frame.w / 2), cy: (.frame.y + .frame.h / 2)})
  | map(. + {dx: (.cx - $fx), dy: (.cy - $fy)})
  | map(select(
      if $dir == "west" then .dx < 0
      elif $dir == "east" then .dx > 0
      elif $dir == "north" then .dy < 0
      else .dy > 0
      end
    ))
  | map(. + {score: (
      if ($dir == "west" or $dir == "east")
      then ((.dx | fabs) + (.dy | fabs) * 2)
      else ((.dy | fabs) + (.dx | fabs) * 2)
      end
    )})
  | sort_by(.score)
  | .[0].id // empty
')

[ -n "$target" ] && yabai -m window --focus "$target"
