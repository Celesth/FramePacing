#!/system/bin/sh

# Package Name of the Game or App
PACKAGE_NAME="com.kurogame.wutheringwaves.global"

# Custom Resolution and Frame Delivery Configurations
RESOLUTION_SCALE="0.8"  # 80% resolution scale
ENABLE_FRAME_PACING="true"

# Apply Custom Resolution
echo "Setting custom resolution scale to $RESOLUTION_SCALE for $PACKAGE_NAME..."
device_config put game_overlay $PACKAGE_NAME resolution_scale $RESOLUTION_SCALE

# Enable Frame Delivery Optimization
echo "Enabling frame pacing for $PACKAGE_NAME..."
device_config put game_overlay $PACKAGE_NAME enable_frame_pacing $ENABLE_FRAME_PACING

# Launch the App
echo "Launching $PACKAGE_NAME..."
monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1

echo "Settings applied and $PACKAGE_NAME launched successfully."
