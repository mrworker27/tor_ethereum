#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ONION_SERVICE_DIR="./onion_service"
ONION_SECRET_KEY_FILE="$1"

echo -e "${YELLOW}Changing onion address...$NC"

if [[ -n "$ONION_SECRET_KEY_FILE" ]]; then
	if [ -d "$ONION_SERVICE_DIR" ]; then
		read -p "Onion service directory alredy exists, current secret key will be overriden! Are you sure? [Y/n] " answer
		answer=${answer,,}

		if [[ "$answer" == "y" || -z "$answer" ]]; then
			echo -e "${GREEN}✓ Onion address is changed!$NC"
		else
			echo "Aborted."
			exit 1
		fi
	fi

	mkdir -p $ONION_SERVICE_DIR
	chmod 700 $ONION_SERVICE_DIR

	rm -f $ONION_SERVICE_DIR/hs_ed25519_public_key
	rm -f $ONION_SERVICE_DIR/hostname
	cat "$ONION_SECRET_KEY_FILE" >$ONION_SERVICE_DIR/hs_ed25519_secret_key
else
	echo "Usage: $0 [onion secret key file (usually hs_ed25519_secret_key)]"
	exit 1
fi
