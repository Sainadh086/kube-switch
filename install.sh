#!/bin/bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="ks"
if [ ! -d "$INSTALL_DIR" ]; then
    INSTALL_DIR="/opt/homebrew/bin/"
fi
sudo cp "$SCRIPT_NAME" "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Installation complete."

# uncomment below lines if you want to know the cluster name in terminal
# echo "k1=$(kubectl config current-context | awk -F'/' '{print $2}')" >> ~/.zshrc
# echo "PROMPT2=$PROMPT" >> ~/.zshrc
# echo "PROMPT='$(echo $k1)'$PROMPT2" >> ~/.zshrc