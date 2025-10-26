#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ONION_SECRET_KEY_FILE=""

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

TOR_BIN=$(which tor)

# Create a systemd service file
echo -e "\n${YELLOW}Creating systemd service file${NC}"
cat >tor-ethereum.service <<'EOF'
[Unit]
Description=Tor hidden service for Ethereum
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$PWD
ExecStart=$TOR_BIN -f $PWD/configs/torrc
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
TimeoutSec=60
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Replace variables in service file
sed -i.bak "s|\$TOR_BIN|$TOR_BIN|g" tor-ethereum.service
sed -i.bak "s|\$USER|$USER|g" tor-ethereum.service
sed -i.bak "s|\$PWD|$PWD|g" tor-ethereum.service
rm tor-ethereum.service.bak

echo -e "${GREEN}✓ Created tor-ethereum.service${NC}"
echo ""
echo "To install as a systemd service"
echo "  sudo cp tor-ethereum.service /etc/systemd/system/"
echo "  sudo systemctl daemon-reload"
echo "  sudo systemctl enable tor-ethereum"
echo "  sudo systemctl start tor-ethereum"
