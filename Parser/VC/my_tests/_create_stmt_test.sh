#!/bin/bash

OUTPUT_FILE="all_stmt.vc"

# Clear or create the output file
> "$OUTPUT_FILE"

# Find all files ending with stmt.vc, ignoring .vct and .vcu
FILES=$(find . -type f -name "*stmt.vc" ! -name "*.vct" ! -name "*.vcu" ! -name "$OUTPUT_FILE")

if [ -z "$FILES" ]; then
  echo "No files matching *stmt.vc found."
  exit 1
fi

for FILE in $FILES; do
  echo ">> Appending: $FILE"
  cat "$FILE" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
done

echo "Done! All content written to $OUTPUT_FILE"