#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# ===================================================================
# Configuration
# ===================================================================
# !! Update these values if they are different for your setup. !!
KEYCLOAK_URL="http://localhost:8080"
REALM="notes_realm"
CLIENT_ID="notes_client"
API_URL="http://localhost:3000"

# User credentials as requested
USERNAME="user"
PASSWORD="Passw0rd!"

# Number of notes to create
TOTAL_NOTES=900

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ===================================================================
# Sample Data (Using simple arrays for compatibility)
# ===================================================================

# English (en)
TITLES_en[0]="Meeting Notes"
CONTENTS_en[0]="Discussed Q3 strategy and new product features."
TITLES_en[1]="Shopping List"
CONTENTS_en[1]="Milk, bread, eggs, and coffee."
TITLES_en[2]="Project Idea"
CONTENTS_en[2]="A new app for tracking personal habits."

# French (fr)
TITLES_fr[0]="Notes de réunion"
CONTENTS_fr[0]="Discussion de la stratégie Q3 et des nouvelles fonctionnalités."
TITLES_fr[1]="Liste de courses"
CONTENTS_fr[1]="Lait, pain, œufs et café."
TITLES_fr[2]="Idée de projet"
CONTENTS_fr[2]="Une nouvelle application pour suivre les habitudes personnelles."

# German (de)
TITLES_de[0]="Besprechungsnotizen"
CONTENTS_de[0]="Q3-Strategie und neue Produktfunktionen besprochen."
TITLES_de[1]="Einkaufsliste"
CONTENTS_de[1]="Milch, Brot, Eier und Kaffee."
TITLES_de[2]="Projektidee"
CONTENTS_de[2]="Eine neue App zur Verfolgung persönlicher Gewohnheiten."

# Spanish (es)
TITLES_es[0]="Notas de la reunión"
CONTENTS_es[0]="Discutimos la estrategia Q3 y las nuevas características del producto."
TITLES_es[1]="Lista de la compra"
CONTENTS_es[1]="Leche, pan, huevos y café."
TITLES_es[2]="Idea de proyecto"
CONTENTS_es[2]="Una nueva aplicación para seguir hábitos personales."

# Italian (it)
TITLES_it[0]="Appunti della riunione"
CONTENTS_it[0]="Discussa la strategia Q3 e le nuove funzionalità del prodotto."
TITLES_it[1]="Lista della spesa"
CONTENTS_it[1]="Latte, pane, uova e caffè."
TITLES_it[2]="Idea di progetto"
CONTENTS_it[2]="Una nuova app per monitorare le abitudini personali."

# List of languages to cycle through
LANGUAGES=("en" "fr" "de" "es" "it")
# Number of sample data entries per language (0, 1, 2)
DATA_COUNT=3

# ===================================================================
# Reusable Functions
# ===================================================================

###
# Creates a new note via the API
# @param $1: Auth Token
# @param $2: Note Title
# @param $3: Note Content
# @param $4: Language Code
###
create_note() {
  local TOKEN="$1"
  local TITLE="$2"
  local CONTENT="$3"
  local LANG_CODE="$4"

  # Use jq to safely escape the text for a JSON payload
  local CLEAN_TITLE=$(echo "$TITLE" | jq -R -s '.')
  local CLEAN_CONTENT=$(echo "$CONTENT" | jq -R -s '.')

  # Make the API call
  # We use -o /dev/null to discard the body, and -w "%{http_code}" to get the status
  local HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    "$API_URL/notes" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
          "title": '"$CLEAN_TITLE"',
          "content": '"$CLEAN_CONTENT"',
          "languageCode": "'"$LANG_CODE"'"
        }')

  # Check the status code
  if [ "$HTTP_STATUS" -eq 201 ]; then
    echo -e "  ${GREEN}Success (201):${NC} Created note in '$LANG_CODE' (Title: $TITLE)"
  else
    echo -e "  ${RED}Error ($HTTP_STATUS):${NC} Failed to create note in '$LANG_CODE'"
  fi
}


# ===================================================================
# Main Script Logic
# ===================================================================

echo -e "${YELLOW}Starting bulk note generation script...${NC}"

# 1. Get the authentication token just once

###
# Authenticates with Keycloak using the user credentials
# Echos the access token on success, or exits on failure.
###
echo -e "${YELLOW}Step 1: Authenticating with Keycloak as '$USERNAME'...${NC}"

# Use cURL to post credentials and get a token
TOKEN_RESPONSE=$(curl -s -X POST \
  "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=$CLIENT_ID" \
  -d "username=$USERNAME" \
  -d "password=$PASSWORD")

# Use jq to parse the access token from the JSON response
TOKEN=$(echo $TOKEN_RESPONSE | jq -r .access_token)

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo -e "${RED}Error: Failed to get access token.${NC}"
  echo "Response: $TOKEN_RESPONSE"
  exit 1
fi

echo -e "${GREEN}Successfully authenticated. Got access token.${NC}\n"
# This is the "return" value of the function
#echo "$TOKEN"

echo -e "${YELLOW}Starting to create $TOTAL_NOTES random notes...${NC}"

# 2. Loop to create notes
for i in $(seq 1 $TOTAL_NOTES); do
  # Pick a random language from the list
  RANDOM_LANG_INDEX=$((RANDOM % ${#LANGUAGES[@]}))
  LANG=${LANGUAGES[$RANDOM_LANG_INDEX]}

  # Pick a random data sample for that language
  RANDOM_DATA_INDEX=$((RANDOM % DATA_COUNT))

  # Select the correct title and content based on the language
  # This 'case' statement replaces the associative array
  case "$LANG" in
    "en")
      TITLE="${TITLES_en[$RANDOM_DATA_INDEX]}"
      CONTENT="${CONTENTS_en[$RANDOM_DATA_INDEX]}"
      ;;
    "fr")
      TITLE="${TITLES_fr[$RANDOM_DATA_INDEX]}"
      CONTENT="${CONTENTS_fr[$RANDOM_DATA_INDEX]}"
      ;;
    "de")
      TITLE="${TITLES_de[$RANDOM_DATA_INDEX]}"
      CONTENT="${CONTENTS_de[$RANDOM_DATA_INDEX]}"
      ;;
    "es")
      TITLE="${TITLES_es[$RANDOM_DATA_INDEX]}"
      CONTENT="${CONTENTS_es[$RANDOM_DATA_INDEX]}"
      ;;
    "it")
      TITLE="${TITLES_it[$RANDOM_DATA_INDEX]}"
      CONTENT="${CONTENTS_it[$RANDOM_DATA_INDEX]}"
      ;;
  esac

  # Add the note number to the title
  TITLE_WITH_NUM="$TITLE (Note #$i)"

  # Print progress (using -n to avoid newline)
  echo -n "[$i/$TOTAL_NOTES] "

  # 3. Call the create_note function
  create_note "$TOKEN" "$TITLE_WITH_NUM" "$CONTENT" "$LANG"

  # Optional: Add a small sleep to avoid overwhelming the server
  # sleep 0.1
done

echo -e "\n${GREEN}Demonstration complete. Created $TOTAL_NOTES notes.${NC}"
