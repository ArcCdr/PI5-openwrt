#!/bin/sh

# Paths to files
BANNER_FILE="/etc/banner"
LOGO_FILE="mylogo.txt"

# Downloads custom logo
wget -O $LOGO_FILE https://raw.githubusercontent.com/ArcCdr/PI5-openwrt/refs/heads/main/mylogo.txt

# Check if the logo file exists
if [ ! -f "$LOGO_FILE" ]; then
    echo "Error: Logo file '$LOGO_FILE' does not exist."
    exit 1
fi

# Check if the banner file exists
if [ ! -f "$BANNER_FILE" ]; then
    echo "Error: Banner file '$BANNER_FILE' does not exist."
    exit 1
fi

# Extract everything below the first dashed line
TAIL_CONTENT=$(awk '/^-----------------------------------------------------/ {found=1} found' "$BANNER_FILE")

# Check if the dashed line was found
if [ -z "$TAIL_CONTENT" ]; then
    echo "Error: No dashed line found in the banner file."
    exit 1
fi

# Replace the content of the banner with the new logo and the tail content
{
    cat "$LOGO_FILE"  # Add the new logo
    echo "$TAIL_CONTENT"  # Add everything below the dashed line, including the dashed lines
} > "$BANNER_FILE"

echo "Banner updated successfully!"