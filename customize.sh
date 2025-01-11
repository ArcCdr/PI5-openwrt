#!/bin/sh

# Paths to files
BANNER_FILE="/etc/banner"
LOGO_FILE="mylogo.txt"

# Downloads custom logo
wget -O $LOGO_FILE https://raw.githubusercontent.com/ArcCdr/PI5-openwrt/refs/heads/main/mylogo.txt

# Check if logo file exists
if [ ! -f "$LOGO_FILE" ]; then
    echo "Error: Logo file '$LOGO_FILE' does not exist."
    exit 1
fi

# Extract content below the first dashed line in the current banner
TAIL_CONTENT=$(awk '/^-----------------------------------------------------/ {flag=1} flag' "$BANNER_FILE")

# Replace the content of the banner with the new logo and the tail content
{
    cat "$LOGO_FILE"  # Add the new logo
    echo "$TAIL_CONTENT"  # Add the rest of the original banner
} > "$BANNER_FILE"

echo "Banner updated successfully!"