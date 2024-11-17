# Get the total, available, and used RAM in KB
total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
available_ram_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
used_ram_kb=$(echo "$total_ram_kb - $available_ram_kb" | bc)

# Convert the RAM values to MB
total_ram_mb=$(echo "scale=2; $total_ram_kb / 1024" | bc)
available_ram_mb=$(echo "scale=2; $available_ram_kb / 1024" | bc)
used_ram_mb=$(echo "scale=2; $used_ram_kb / 1024" | bc)

# Calculate the percentages of available and used RAM
available_ram_percent=$(echo "scale=2; $available_ram_kb / $total_ram_kb * 100" | bc)
used_ram_percent=$(echo "scale=2; $used_ram_kb / $total_ram_kb * 100" | bc)

# Calculate the number of "■" characters to represent the bars
total_num_bars=10
available_num_bars=$(echo "$available_ram_percent / 10" | bc)
used_num_bars=$(echo "$used_ram_percent / 10" | bc)

# Total RAM bar (always fully filled)
total_bar=$(printf "%0.s■" $(seq 1 $total_num_bars))

# Available RAM bar
available_bar=$(printf "%0.s■" $(seq 1 $available_num_bars))
available_bar=$(printf "%-10s" "$available_bar")

# Used RAM bar
used_bar=$(printf "%0.s■" $(seq 1 $used_num_bars))
used_bar=$(printf "%-10s" "$used_bar")

# Print the RAM stats
echo "Total RAM:
[ 100.00% ${total_bar} ${total_ram_mb} MB ]"
echo "Available RAM:
[  ${available_ram_percent}% ${available_bar} ${available_ram_mb} MB ]"
echo "Used RAM:
[  ${used_ram_percent}% ${used_bar} ${used_ram_mb} MB ]"
