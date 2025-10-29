#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SERVICE_DIR="${1:-./onion_service}"

SOCKS_OPTIONS="-x socks5h://127.0.0.1:9050 --connect-timeout 10"
REQUEST="'{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1234}'"
check_onion_service() {
	ONION=$1
	ONION_PORT=$2
	local http_code
	local curl_exit_code
	http_code=$(curl -s $SOCKS_OPTIONS \
	    -X POST \
	    -H "Content-Type: application/json" \
	    -d "$REQUEST" \
	    -o /dev/null \
	    -w "%{http_code}" \
	    "http://$ONION:$ONION_PORT/" 2>/dev/null)

	curl_exit_code=$?
	if [ $curl_exit_code -eq 0 ] && [ "$http_code" = "200" ]; then
	    return 0 # success
	fi

	return 1
}

echo -e "${YELLOW}Checking TOR daemon...$NC"
if ! timeout 1 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/9050" 2>/dev/null; then
	echo -e "${RED}[-] Tor not running on port 9050$NC"
	exit 1
fi
echo -e "${GREEN}[+] Tor is running$NC"

echo -e "${YELLOW}Checking hostname...$NC"
if [[ ! -f "$SERVICE_DIR/hostname" ]]; then
	echo "[-] No hostname file at: $SERVICE_DIR/hostname"
	exit 1
fi

ONION=$(cat "$SERVICE_DIR/hostname")
ONION_PORT="8545"
echo -e "${GREEN}[+] Onion address${NC}:\t\t\t$ONION"

echo -e "${YELLOW}Checking that onion service is reachable...$NC"
if check_onion_service $ONION $ONION_PORT ; then
	echo -e "${GREEN}[+] Ethereum client is reachable${NC}: \t$ONION:$ONION_PORT"
	exit 0
else
	echo -e "${RED}[!] Ethereum client is not yet reachable in TOR network (typical propagation time: 5-10 minutes)$NC"
	exit 1
fi
