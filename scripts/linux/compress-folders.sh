#!/bin/bash

# Current directory where the script runs
PARENT_DIR="."

# Common video extensions to search for
EXTENSIONS=("mp4" "mkv" "avi" "mov" "flv" "wmv")

# Ensure bc is installed for math calculations
if ! command -v bc &> /dev/null; then
    echo "ERROR: 'bc' utility is required for space calculations. Please install it (e.g., sudo apt install bc)."
    exit 1
fi

echo "Scanning subdirectories..."

# Loop through each item in the parent directory
for dir in "$PARENT_DIR"/*; do
    # Process only if it is a directory
    if [ -d "$dir" ]; then
        echo -e "\n=================================================="
        echo " SCANNING DIRECTORY: $(basename "$dir")"
        echo "=================================================="
        
        # Step 1: Count and list target video files in this folder
        declare -a VIDEOS_TO_PROCESS=()
        TOTAL_VIDEOS=0
        
        for ext in "${EXTENSIONS[@]}"; do
            while read -r file; do
                if [ -n "$file" ] && [[ "$file" != *"_compressed.mp4" ]]; then
                    VIDEOS_TO_PROCESS+=("$file")
                    ((TOTAL_VIDEOS++))
                fi
            done < <(find "$dir" -maxdepth 1 -type f -iname "*.$ext" 2>/dev/null)
        done
        
        if [ $TOTAL_VIDEOS -eq 0 ]; then
            echo "No original videos found in this folder. Skipping..."
            continue
        fi
        
        echo "Found $TOTAL_VIDEOS videos to compress."
        
        # Variables to track size for the current folder
        FOLDER_ORIG_SIZE=0
        FOLDER_COMP_SIZE=0
        CURRENT_VIDEO_INDEX=0
        SUCCESSFUL_COMPRESSIONS=0
        
        # Step 2: Process videos in series
        for file in "${VIDEOS_TO_PROCESS[@]}"; do
            ((CURRENT_VIDEO_INDEX++))
            base_name=$(basename "$file")
            name_no_ext="${base_name%.*}"
            
            # Output file path with _compressed suffix
            compressed_output="$dir/${name_no_ext}_compressed.mp4"
            
            echo ""
            echo "  --> [$CURRENT_VIDEO_INDEX/$TOTAL_VIDEOS] Compressing: $base_name"
            echo "      Using GPU Acceleration (NVIDIA NVENC H.265 at 17x+)..."
            
            # Get original file size
            orig_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")
            
            # High-performance GPU FFmpeg Command
            ffmpeg -nostdin -v error -stats -hwaccel cuda -hwaccel_output_format cuda -i "$file" -vcodec hevc_nvenc -cq 28 -preset p4 -acodec copy "$compressed_output" -y
            
            # Check if FFmpeg completed successfully
            if [ $? -eq 0 ]; then
                echo "      [OK] Finished compressing: $base_name"
                comp_size=$(stat -c%s "$compressed_output" 2>/dev/null || stat -f%z "$compressed_output")
                
                FOLDER_ORIG_SIZE=$((FOLDER_ORIG_SIZE + orig_size))
                FOLDER_COMP_SIZE=$((FOLDER_COMP_SIZE + comp_size))
                ((SUCCESSFUL_COMPRESSIONS++))
                
                # IMMEDIATE CLEANUP: Delete the original large file right away
                echo "      [CLEANUP] Removing original file immediately: $base_name"
                rm "$file"
            else
                echo "      [ERROR] Compression failed. Keeping original and removing incomplete output."
                [ -f "$compressed_output" ] && rm "$compressed_output"
            fi
        done
        
        # Step 3: Print summary for the current folder
        if [ $SUCCESSFUL_COMPRESSIONS -gt 0 ]; then
            # Convert sizes to MB
            ORIG_MB=$(echo "scale=2; $FOLDER_ORIG_SIZE / 1048576" | bc)
            COMP_MB=$(echo "scale=2; $FOLDER_COMP_SIZE / 1048576" | bc)
            SAVED_MB=$(echo "scale=2; ($FOLDER_ORIG_SIZE - $FOLDER_COMP_SIZE) / 1048576" | bc)
            SAVED_PCT=$(echo "scale=2; (($FOLDER_ORIG_SIZE - $FOLDER_COMP_SIZE) / $FOLDER_ORIG_SIZE) * 100" | bc)
            
            echo -e "\n--------------------------------------------------"
            echo " FOLDER SUMMARY: $(basename "$dir")"
            echo "--------------------------------------------------"
            echo -e " Original Space Processed:\t$ORIG_MB MB"
            echo -e " Compressed Space Written:\t$COMP_MB MB"
            echo -e " Total Space Saved:\t\t$SAVED_MB MB ($SAVED_PCT%)"
            echo "--------------------------------------------------"
            echo " Folder processing complete!"
        else
            echo -e "\nNo files were successfully compressed in $(basename "$dir")."
        fi
    fi
done

echo -e "\n=================================================="
echo " ALL DIRECTORIES PROCESSED SUCCESSFULLY WITH GPU!"
echo "=================================================="

