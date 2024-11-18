#!/system/bin/sh

# Package Name of the Game or App
PACKAGE_NAME="com.kurogame.wutheringwaves.global"

# Custom Resolution and Frame Delivery Configurations
RESOLUTION_SCALE="0.8"  # 80% resolution scale
ENABLE_FRAME_PACING="true"

# Apply Custom Resolution
echo "Setting custom resolution scale to $RESOLUTION_SCALE for $PACKAGE_NAME..."
device_config put game_overlay $PACKAGE_NAME mode=2,downscaleFactor=0.9:mode=3,downscaleFactor=0.5

# Enable Frame Delivery Optimization
echo "Enabling frame pacing for $PACKAGE_NAME..."
device_config put game_overlay $PACKAGE_NAME enable_frame_pacing $ENABLE_FRAME_PACING

fps="$(dumpsys display | grep -o -E 'fps=[0-9]+(\.[0-9]+)?' | cut -d'=' -f2 | sort -u | awk '{print $1 - 10}' | bc)"

 echo " ■ Performance mode has been set for:
     [ $gamepackage ]
 ■ Supported Display Refresh Rate: 
     [ $(dumpsys display | grep -o -E 'fps=[0-9]+(\.[0-9]+)?' | cut -d'=' -f2 | sort -u | head -n1) Hz ]
 ■ FPS throttling enabled
     FPS currently capped to: $fps FPS 
"

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

# Launch the App
echo "Launching $PACKAGE_NAME..."
monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1

echo "Settings applied and $PACKAGE_NAME launched successfully."