#!/bin/bash
set -e

# Configuration - add or remove versions as needed
VERSIONS=("9.1.2" "9.0.5" "8.19.2" "8.18.5")
BASE_URL="https://download.elastic.co/cloud-enterprise/versions"

# Check if download tool is available
if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
elif command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl"
else
    echo "Error: Neither wget nor curl found. Please install one of them."
    exit 1
fi

echo "Starting download of ${#VERSIONS[@]} ECE Stack Pack versions..."

# Download each version
for VERSION in "${VERSIONS[@]}"; do
    STACK_PACK_URL="${BASE_URL}/${VERSION}.zip"
    STACK_PACK_FILE="${VERSION}.zip"
    
    echo "Downloading ECE Stack Pack version ${VERSION}..."
    
    if [ "$DOWNLOAD_CMD" = "wget" ]; then
        wget -O "./${STACK_PACK_FILE}" "${STACK_PACK_URL}"
    else
        curl -L -o "./${STACK_PACK_FILE}" "${STACK_PACK_URL}"
    fi
    
    if [ $? -eq 0 ]; then
        echo "✓ Downloaded ${STACK_PACK_FILE} successfully!"
    else
        echo "✗ Failed to download ${STACK_PACK_FILE}"
        exit 1
    fi
    echo ""
done

echo "All downloads completed successfully!"
echo "Downloaded files:"
ls -la *.zip 2>/dev/null || echo "No zip files found"
