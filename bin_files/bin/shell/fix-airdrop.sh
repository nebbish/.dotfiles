#!/usr/bin/env bash

echo "Restarting Airdrop-related services..."
#sudo pkill bluetoothd
sudo pkill sharingd
#sudo pkill mDNSResponder
#killall cfprefsd
echo "Done."
