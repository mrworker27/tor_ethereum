#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# check if Tor is installed
if ! command -v tor &>/dev/null; then
	echo -e "${YELLOW}Tor is not installed. Please install it using:${NC}"
	echo ""

	# detect OS and provide installation instructions
	if [[ "$OSTYPE" == "darwin"* ]]; then
		echo "  brew install tor"
	elif [[ -f /etc/debian_version ]]; then
		echo "  sudo apt-get update && sudo apt-get install tor"
	elif [[ -f /etc/redhat-release ]]; then
		echo "  sudo yum install tor"
	else
		echo "  Please install Tor using your system's package manager"
	fi

	echo ""
	echo "After installing Tor, run this script again."
	exit 1
fi

echo -e "${GREEN}✓ Tor is installed${NC}"
tor --version

# check if torrc exists
if [ ! -f configs/torrc ]; then
	echo -e "${RED}Error: configs/torrc not found${NC}"
	exit 1
fi

mkdir -p tor_data
chmod 700 tor_data

echo -e "${YELLOW}Starting Tor onion service...$NC"
tor -f configs/torrc
