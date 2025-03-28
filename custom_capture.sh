#!/bin/bash
# PromptDA - Stray Scanner Capture Processing Script
# This script processes ZIP files captured with the Stray Scanner App
# Usage: ./process_capture.sh path/to/zip_file.zip

set -e

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: ./process_capture.sh path/to/zip_file.zip"
    echo "Example: ./process_capture.sh zips/8a0A254as804.zip"
    exit 1
fi

# Assign input arguments
ZIP_FILE=$1
OUTPUT_DIR=./results/$ZIP_FILE  # Fixed output directory

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Processing $ZIP_FILE..."
echo "Output will be saved to $OUTPUT_DIR"
echo 

# Step 1: Run inference
echo "Step 1/3: Running PromptDA inference on Stray Scanner data..."
python3 -m promptda.scripts.infer_stray_scan --input_path "$ZIP_FILE" --output_path "$OUTPUT_DIR"
echo "Inference complete."
echo

# Step 2: Generate video with visualization
echo "Step 2/3: Generating visualization frames..."
python3 -m promptda.scripts.generate_video process_stray_scan --input_path "$ZIP_FILE" --result_path "$OUTPUT_DIR"
echo "Visualization frames generated."
echo

# Step 3: Create final video
echo "Step 3/3: Creating final video with ffmpeg..."
VIDEO_OUTPUT="${OUTPUT_DIR}.mp4"
ffmpeg -y -framerate 60 -i "${OUTPUT_DIR}/%06d_smooth.jpg" -c:v libx264 -pix_fmt yuv420p -preset fast "$VIDEO_OUTPUT"
echo "Video processing complete. Output saved to $VIDEO_OUTPUT"
echo

echo "✅ All processing complete!"
echo "  - Raw depth results: $OUTPUT_DIR"
echo "  - Video visualization: $VIDEO_OUTPUT"