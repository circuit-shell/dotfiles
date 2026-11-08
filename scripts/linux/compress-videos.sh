#!/bin/bash

# Current directory where the script will run
DIRECTORY="."

# Common video extensions to search for
EXTENSIONS=("mp4" "mkv" "avi" "mov" "flv" "wmv")

# Arrays to keep track of processed files for the summary and later actions
declare -a ORIGINAL_FILES
declare -a COMPRESSED_FILES

TOTAL_ORIGINAL_SIZE=0
TOTAL_COMPRESSED_SIZE=0
COUNT=0

# Step 1: Count total files to process for the progress indicator
echo "Scanning directory for video files..."
TOTAL_FILES=0
for ext in "${EXTENSIONS[@]}"; do
    while read -r file; do
        if [[ "$file" != *"_compressed.mp4" ]]; then
            ((TOTAL_FILES++))
        fi
    done < <(find "$DIRECTORY" -maxdepth 1 -type f -iname "*.$ext")
done

if [ $TOTAL_FILES -eq 0 ]; then
    echo "No videos found to compress."
    exit 0
fi

echo "Found $TOTAL_FILES videos to process. Starting..."

# Step 2: Process videos
for ext in "${EXTENSIONS[@]}"; do
    find "$DIRECTORY" -maxdepth 1 -type f -iname "*.$ext" | while read -r file; do
        
        # Skip files that are already compressed by this script
        if [[ "$file" == *"_compressed.mp4" ]]; then
            continue
        fi

        ((COUNT++))
        base_name=$(basename "$file")
        name_no_ext="${base_name%.*}"
        file_dir=$(dirname "$file")
        
        # Output file path with _compressed suffix
        compressed_output="$file_dir/${name_no_ext}_compressed.mp4"
        
        echo ""
        echo "=================================================="
        echo " Progress: [$COUNT/$TOTAL_FILES] "
        echo " Compressing: $base_name"
        echo "=================================================="
        
        # Get original file size in bytes
        orig_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")
        
        # Run FFmpeg with clean progress output (-stats) and hide unnecessary banners (-v error)
        ffmpeg -nostdin -v error -stats -i "$file" -vcodec libx264 -crf 23 -acodec aac "$compressed_output" -y
        
        # Check if FFmpeg exited successfully (exit code 0)
        if [ $? -eq 0 ]; then
            echo -e "\n---> [OK] Compression successful for: $base_name"
            
            # Get compressed file size in bytes
            comp_size=$(stat -c%s "$compressed_output" 2>/dev/null || stat -f%z "$compressed_output")
            
            # Save data to files temporarily (since while loops run in a subshell)
            echo "$file" >> /tmp/orig_files.txt
            echo "$compressed_output" >> /tmp/comp_files.txt
            echo "$orig_size" >> /tmp/orig_sizes.txt
            echo "$comp_size" >> /tmp/comp_sizes.txt
        else
            echo -e "\n---> [ERROR] Compression failed for $base_name. Removing incomplete file."
            [ -f "$compressed_output" ] && rm "$compressed_output"
        fi
    done
done

# Read data back if any files were processed
if [ -f /tmp/orig_files.txt ]; then
    mapfile -t ORIGINAL_FILES < /tmp/orig_files.txt
    mapfile -t COMPRESSED_FILES < /tmp/comp_files.txt
    
    while read -r size; do TOTAL_ORIGINAL_SIZE=$((TOTAL_ORIGINAL_SIZE + size)); done < /tmp/orig_sizes.txt
    while read -r size; do TOTAL_COMPRESSED_SIZE=$((TOTAL_COMPRESSED_SIZE + size)); done < /tmp/comp_sizes.txt
    
    # Clean up temp files
    rm /tmp/orig_files.txt /tmp/comp_files.txt /tmp/orig_sizes.txt /tmp/comp_sizes.txt
fi

# Convert sizes to Megabytes for readability
ORIG_MB=$(echo "scale=2; $TOTAL_ORIGINAL_SIZE / 1048576" | bc)
COMP_MB=$(echo "scale=2; $TOTAL_COMPRESSED_SIZE / 1048576" | bc)
SAVED_MB=$(echo "scale=2; ($TOTAL_ORIGINAL_SIZE - $TOTAL_COMPRESSED_SIZE) / 1048576" | bc)

# Calculate percentage saved
if [ $TOTAL_ORIGINAL_SIZE -gt 0 ]; then
    SAVED_PCT=$(echo "scale=2; (($TOTAL_ORIGINAL_SIZE - $TOTAL_COMPRESSED_SIZE) / $TOTAL_ORIGINAL_SIZE) * 100" | bc)
else
    SAVED_PCT=0
fi

# Print Space Saving Summary
echo -e "\n=================================================="
echo "                COMPRESSION SUMMARY               "
echo "=================================================="
echo -e "Original Size:\t\t$ORIG_MB MB"
echo -e "Compressed Size:\t$COMP_MB MB"
echo -e "Space Saved:\t\t$SAVED_MB MB ($SAVED_PCT%)"
echo "=================================================="

# Menu prompt (restoring stdin connectivity for user input)
echo -e "\nWhat would you like to do next?"
echo "1) Keep all files (Do nothing, keep both original and _compressed files)"
echo "2) Delete originals only (Keep compressed files with the '_compressed' suffix)"
echo "3) Delete and Rename (Delete originals, rename compressed files to match original names)"
echo -n "Choose an option [1-3]: "
read -r OPTION < /dev/tty

case $OPTION in
    1)
        echo "Keeping all files. Done!"
        ;;
    2)
        echo "Deleting original files..."
        for orig in "${ORIGINAL_FILES[@]}"; do
            echo "Removing: $orig"
            rm "$orig"
        done
        echo "Done!"
        ;;
    3)
        echo "Deleting originals and renaming compressed files..."
        for i in "${!ORIGINAL_FILES[@]}"; do
            orig="${ORIGINAL_FILES[$i]}"
            comp="${COMPRESSED_FILES[$i]}"
            
            base_orig=$(basename "$orig")
            name_no_ext="${base_orig%.*}"
            file_dir=$(dirname "$orig")
            final_target="$file_dir/${name_no_ext}.mp4"
            
            echo "Processing: $base_orig"
            rm "$orig"
            mv "$comp" "$final_target"
        done
        echo "Done!"
        ;;
    *)
        echo "Invalid option. No files were deleted or renamed."
        ;;
esac
