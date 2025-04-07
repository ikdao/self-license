#!/bin/bash

read -p "Enter license code (e.g., 101101SL): " LICENSE_CODE
read -p "Enter project/work name: " PROJECT_NAME
read -p "Enter creator(s) name: " CREATOR_NAME
read -p "Enter a short description: " DESCRIPTION
read -p "Export format? (txt/md): " FORMAT

# Normalize format
FORMAT=${FORMAT,,}
[[ "$FORMAT" != "md" && "$FORMAT" != "txt" ]] && FORMAT="txt"

# Extract the bit code (remove 'SL' suffix)
BIT_CODE="${LICENSE_CODE%SL}"
BIT_LEN=${#BIT_CODE}

# Pad bits with leading zeros if less than 6 bits
while [ ${#BIT_CODE} -lt 6 ]; do
  BIT_CODE="0${BIT_CODE}"
done

# Map bits
BIT_1=${BIT_CODE:0:1}  # Terms & Conditions
BIT_2=${BIT_CODE:1:1}  # Attribution
BIT_3=${BIT_CODE:2:1}  # Accountability
BIT_4=${BIT_CODE:3:1}  # Source Open
BIT_5=${BIT_CODE:4:1}  # Modifications
BIT_6=${BIT_CODE:5:1}  # Commercial Use

LICENSE_TITLE="Self License - ${LICENSE_CODE}"
LICENSE_LINK="https://legal.ikdao.org/license/${LICENSE_CODE,,}"
OUTPUT_FILE="LICENSE.${FORMAT}"

# Start building the license content
LICENSE_TEXT="$LICENSE_TITLE
$PROJECT_NAME - $CREATOR_NAME
~$DESCRIPTION

I/We hereby declare,
"

# --- Terms & Conditions Block ---
if [[ "$BIT_1" == "1" ]]; then
  LICENSE_TEXT+="
Terms and conditions exist or made."

  read -p "Do you want to add custom terms and conditions? (y/n): " CUSTOM_TERMS
  if [[ "$CUSTOM_TERMS" =~ ^[Yy]$ ]]; then
    echo "Enter each term, one per line. Press ENTER on an empty line to finish:"
    TERMS_LIST=""
    while true; do
      read -p "- " TERM
      [[ -z "$TERM" ]] && break
      TERMS_LIST+="- $TERM"$'\n'
    done
    LICENSE_TEXT+="
~ Custom terms:
$TERMS_LIST"
  fi
else
  LICENSE_TEXT+="
No terms and conditions exist or made."
fi

# --- Attribution ---
if [[ "$BIT_2" == "1" ]]; then
  LICENSE_TEXT+="
Attribution exists or made."
else
  LICENSE_TEXT+="
No attribution exists or made."
fi

# --- Accountability ---
if [[ "$BIT_3" == "1" ]]; then
  LICENSE_TEXT+="
Accountability exists or made."
fi

# --- Source Open/Closed ---
if [[ "$BIT_4" == "1" ]]; then
  LICENSE_TEXT+="
Source is open."
else
  LICENSE_TEXT+="
Source is closed."
fi

# --- Modifications ---
if [[ "$BIT_5" == "1" ]]; then
  LICENSE_TEXT+="
Modifications allowed."
else
  LICENSE_TEXT+="
Modifications not allowed."
fi

# --- Commercial/Resell ---
if [[ "$BIT_6" == "1" ]]; then
  LICENSE_TEXT+="
Resell and commercial use allowed."
else
  LICENSE_TEXT+="
Resell and commercial use not allowed."
fi

# --- Closing Section ---
if [[ "$BIT_1" == "1" ]]; then
  LICENSE_TEXT+="

This work is reserved."
elif [[ "$BIT_1$BIT_2$BIT_3" == "000" ]]; then
  LICENSE_TEXT+="

This work is open, free and can be taken as in public domain. Made by, for, of, in common faith. Any or all permissions can be implicitly taken as granted."
fi

# --- License Footer ---
LICENSE_TEXT+="

To know more about this license visit $LICENSE_LINK"

# --- Write to file ---
echo "$LICENSE_TEXT" > "$OUTPUT_FILE"
echo "✅ License generated and saved as $OUTPUT_FILE"
