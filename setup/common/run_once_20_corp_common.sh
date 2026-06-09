#!/bin/bash
# Corp common setup (runs on both Linux and Mac if inside Google corp network)

if [ -d "/google/bin" ]; then
  echo "Installing hi-project..."
  /google/bin/releases/hi-project/public/install_hi -Y
fi
