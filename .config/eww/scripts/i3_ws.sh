#!/usr/bin/env bash

print_states () {
  workspaces=$(i3-msg -t get_workspaces)
  
  # Map the range 1-9 to check if a workspace exists for each index
  echo "$workspaces" | jq -c '
    [range(1; 10) as $i | 
      (map(select(.num == $i)) | .[0]) as $ws | 
      if $ws then 
        (if $ws.focused then "active" else "used" end) 
      else 
        "empty" 
      end
    ]'
}

# Initial call
print_states

# Subscribe to events
i3-msg -t subscribe -m '[ "workspace" ]' | while read -r event; do
  print_states
done
