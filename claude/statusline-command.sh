#!/bin/bash
# Claude Code status line: context window remaining + rate limit usage

input=$(cat)

remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

DIM=$'\033[2m'
RESET=$'\033[0m'

parts=()

if [ -n "$remaining" ]; then
  parts+=("$(printf 'Ctx %.0f%% left' "$remaining")")
fi

if [ -n "$five" ]; then
  parts+=("$(printf '5h %.0f%%' "$five")")
fi

if [ -n "$week" ]; then
  parts+=("$(printf '7d %.0f%%' "$week")")
fi

output=""
for i in "${!parts[@]}"; do
  if [ "$i" -gt 0 ]; then
    output+=" | "
  fi
  output+="${parts[$i]}"
done

if [ -z "$output" ]; then
  output="Ctx: n/a"
fi

printf '%s%s%s' "$DIM" "$output" "$RESET"
