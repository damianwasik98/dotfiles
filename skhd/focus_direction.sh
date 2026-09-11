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

# Windows that merely overlap (e.g. one placed a few px off another due to
# menu bar/chrome differences) shouldn't count as a directional neighbor --
# require a real offset on the primary axis or they're treated as stacked.
threshold=40

target=$(echo "$windows" | jq --argjson fx "$fx" --argjson fy "$fy" --argjson fid "$fid" --argjson threshold "$threshold" --arg dir "$direction" '
  map(select(.id != $fid and .["is-minimized"] == false))
  | map(. + {cx: (.frame.x + .frame.w / 2), cy: (.frame.y + .frame.h / 2)})
  | map(. + {dx: (.cx - $fx), dy: (.cy - $fy)})
  | map(select(
      if $dir == "west" then .dx < -$threshold
      elif $dir == "east" then .dx > $threshold
      elif $dir == "north" then .dy < -$threshold
      else .dy > $threshold
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

if [ -z "$target" ]; then
  # No spatial neighbor (e.g. windows fully stacked on top of each other in
  # float layout, with zero directional offset) -- fall back to cycling
  # through the other windows on this space in a stable order.
  target=$(echo "$windows" | jq --argjson fid "$fid" --arg dir "$direction" '
    [.[] | select(.["is-minimized"] == false) | .id] | sort
    | . as $ids
    | ($ids | index($fid)) as $i
    | if $i == null then empty
      elif ($dir == "east" or $dir == "south")
      then $ids[($i + 1) % ($ids | length)]
      else $ids[($i - 1 + ($ids | length)) % ($ids | length)]
      end
  ')
fi

[ -n "$target" ] && yabai -m window --focus "$target"
