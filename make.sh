#!/bin/bash

# -----------------------------
# Self License Generator v2
# Supports flags + interactive
# -----------------------------

show_help() {
cat <<EOF
Usage: $0 [options]

Options:
  --license        License code (e.g., 101 or 010101)
  --project        Project or work name
  --creator        Creator(s) name
  --description    Short description
  --format         Output format (txt or md or 1/2)
  --terms          Add custom terms (true to prompt for them) (only if license starts with 1)
  --help           Show this help message

Example:
  $0 --license 101 --project "My App" --creator "Atma" --description "Test app" --format 2 --terms true
EOF
exit 0
}

# Default values
TERMS_FLAG=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --license) LICENSE_CODE="$2"; shift ;;
        --project) PROJECT_NAME="$2"; shift ;;
        --creator) CREATOR_NAME="$2"; shift ;;
        --description) DESCRIPTION="$2"; shift ;;
        --format) FORMAT="$2"; shift ;;
        --terms) TERMS_FLAG="$2"; shift ;;
        --help) show_help ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# Interactive fallback
[[ -z "$LICENSE_CODE" ]] && read -p "Enter license code (e.g., 101101): " LICENSE_CODE
[[ -z "$PROJECT_NAME" ]] && read -p "Enter project/work name: " PROJECT_NAME
[[ -z "$CREATOR_NAME" ]] && read -p "Enter creator(s) name: " CREATOR_NAME
[[ -z "$DESCRIPTION" ]] && read -p "Enter a short description: " DESCRIPTION
[[ -z "$FORMAT" ]] && read -p "Export format? (1: txt / 2: md): " FORMAT

# Normalize inputs
LICENSE_CODE=$(echo "$LICENSE_CODE" | tr -d '[:space:]')
FORMAT=$(echo "$FORMAT" | tr '[:upper:]' '[:lower:]')

# Support numeric format choice
if [[ "$FORMAT" == "1" ]]; then
  FORMAT="txt"
elif [[ "$FORMAT" == "2" ]]; then
  FORMAT="md"
fi

[[ "$FORMAT" != "md" && "$FORMAT" != "txt" ]] && FORMAT="txt"

# Validate license code format
if ! [[ "$LICENSE_CODE" =~ ^[01]{1,6}$ ]]; then
  echo "❌ Invalid license code. Use only binary digits (e.g., 101 or 010111)"
  exit 1
fi

BIT_CODE="$LICENSE_CODE"
BIT_COUNT=${#BIT_CODE}

# Parse bits
BIT_1=${BIT_CODE:0:1}
BIT_2=${BIT_CODE:1:1}
BIT_3=${BIT_CODE:2:1}
BIT_4=${BIT_CODE:3:1}
BIT_5=${BIT_CODE:4:1}
BIT_6=${BIT_CODE:5:1}

LICENSE_TITLE="Self License - ${BIT_CODE}SL"
LICENSE_LINK="https://legal.ikdao.org/license/${BIT_CODE,,}sl"
OUTPUT_FILE="LICENSE.${FORMAT}"

# Start license text
LICENSE_TEXT="$LICENSE_TITLE
$PROJECT_NAME - $CREATOR_NAME
$DESCRIPTION

I/We hereby declare,"

# Include term statements only if defined
if [[ "$BIT_1" == "1" ]]; then
  LICENSE_TEXT+=$'\n'"Terms and conditions exist or made."

  # Ask for custom terms interactively unless already provided via --terms=false
  if [[ "$TERMS_FLAG" == "true" || "$TERMS_FLAG" == "1" || -z "$TERMS_FLAG" ]]; then
    echo "Enter custom terms and conditions (press ENTER on empty line to finish):"
    TERMS_LIST=""
    while true; do
      read -p "- " TERM
      [[ -z "$TERM" ]] && break
      TERMS_LIST+="- $TERM"$'\n'
    done
    if [[ -n "$TERMS_LIST" ]]; then
      LICENSE_TEXT+=$'\n'"Custom terms:"$'\n'"$TERMS_LIST"
    fi
  fi
fi


if [[ $BIT_COUNT -ge 2 ]]; then
  if [[ "$BIT_2" == "1" ]]; then
    LICENSE_TEXT+=$'\n'"Attribution exists or made."
  elif [[ "$BIT_2" == "0" ]]; then
    LICENSE_TEXT+=$'\n'"No attribution exists or made."
  fi
fi

if [[ $BIT_COUNT -ge 3 ]]; then
  if [[ "$BIT_3" == "1" ]]; then
    LICENSE_TEXT+=$'\n'"Accountability exists or made."
  elif [[ "$BIT_3" == "0" ]]; then
    LICENSE_TEXT+=$'\n'"No accountability exists or made."
  fi
fi

if [[ $BIT_COUNT -ge 4 ]]; then
  if [[ "$BIT_4" == "1" ]]; then
    LICENSE_TEXT+=$'\n'"Source is open."
  elif [[ "$BIT_4" == "0" ]]; then
    LICENSE_TEXT+=$'\n'"Source is closed."
  fi
fi

if [[ $BIT_COUNT -ge 5 ]]; then
  if [[ "$BIT_5" == "1" ]]; then
    LICENSE_TEXT+=$'\n'"Modifications allowed."
  elif [[ "$BIT_5" == "0" ]]; then
    LICENSE_TEXT+=$'\n'"Modifications not allowed."
  fi
fi

if [[ $BIT_COUNT -ge 6 ]]; then
  if [[ "$BIT_6" == "1" ]]; then
    LICENSE_TEXT+=$'\n'"Resell and commercial use allowed."
  elif [[ "$BIT_6" == "0" ]]; then
    LICENSE_TEXT+=$'\n'"Resell and commercial use not allowed."
  fi
fi

# Reserved or public domain note
if [[ "$BIT_1" == "1" ]]; then
  LICENSE_TEXT+=$'\n\n'"This work is reserved."
elif [[ "$BIT_CODE" == "000" ]]; then
  LICENSE_TEXT+=$'\n\n'"This work is open, free and can be taken as in public domain. Made by, for, of, in common faith. Any or all permissions can be implicitly taken as granted."
fi

# --- Link ---
LICENSE_TEXT+=$'\n\n'"To know more about this license visit $LICENSE_LINK"

# Write to file
echo "$LICENSE_TEXT" > "$OUTPUT_FILE"
echo "✅ License saved as $OUTPUT_FILE"
