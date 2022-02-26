#!/bin/bash

# Point where's the Godot 3 executable
GODOT=$HOME/.local/bin/godot3-stable

# Change direcotry to server project and run server
cd src-server;
__NV_PRIME_RENDER_OFFLOAD=0 $GODOT &

# Change directory to client project and run client with render offload (nvidia GPU)
cd ../src;
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $GODOT &
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $GODOT

