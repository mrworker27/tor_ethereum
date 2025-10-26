# Tor for Ethereum

This repo consists of:
1. `configs/torrc` configuration file that can be used to run Ethereum execution client as an onion service
2. Several scripts that will help you to launch and maintain such service

To launch tor daemon locally:
```
./tor.sh
```

To add tor as systemd service:
```
./systemd.sh
```

To change onion address given onion secret key file (usually `hs_ed25519_secret_key`)
```
./vanity_address.sh [path_to_file]
```

**TODO:** acknowledgments (https://github.com/CPerezz/torpc)