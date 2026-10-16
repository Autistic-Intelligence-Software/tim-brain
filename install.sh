#!/usr/bin/env bash
# Tom.0 Brain Bundle — one-click installer (macOS / Linux)
# Installs Ollama (if missing), downloads your chosen AI model, and sets up
# the start script. Your PC becomes Tom.0's free local "brain" — no API key,
# no per-message cost.
set -euo pipefail

echo "=============================================="
echo "  Tom.0 Brain Bundle — installer"
echo "=============================================="
echo

# ---- 1. Ollama ----
if command -v ollama >/dev/null 2>&1; then
  echo "[1/3] Ollama already installed ($(ollama --version 2>/dev/null || echo ok))"
else
  echo "[1/3] Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
  echo "      Ollama installed."
fi

# ---- 2. Model choice ----
echo
echo "[2/3] Choose your brain model:"
echo "  1) dolphin-llama3  — uncensored, best quality (~4.7 GB)  [recommended]"
echo "  2) dolphin-phi     — uncensored, light, weaker PCs (~1.6 GB)"
echo "  3) llama3.1        — standard (has safety guardrails) (~4.7 GB)"
echo "  4) qwen2.5:3b      — standard, light, weaker PCs (~1.9 GB)"
printf "Pick 1-4 [1]: "
read -r choice
case "${choice:-1}" in
  1) MODEL="dolphin-llama3" ;;
  2) MODEL="dolphin-phi" ;;
  3) MODEL="llama3.1" ;;
  4) MODEL="qwen2.5:3b" ;;
  *) echo "Invalid choice."; exit 1 ;;
esac

echo "      Downloading model: $MODEL (this takes a while on first run)..."
ollama pull "$MODEL"
echo "$MODEL" > .tomo-model
echo "      Model ready."

# ---- 3. Start script ----
cat > start-brain.sh << 'EOF'
#!/usr/bin/env bash
# Starts your Tom.0 brain (Ollama serving the installed model).
set -euo pipefail
cd "$(dirname "$0")"
MODEL="$(cat .tomo-model 2>/dev/null || echo dolphin-llama3)"
echo "Starting Tom.0 brain (model: $MODEL)..."
echo "Local API: http://localhost:11434"
echo
echo "NEXT STEPS (one time):"
echo "  1. Expose this PC to the internet, e.g.:  ngrok http 11434"
echo "  2. In the Tom.0 dashboard, set AI provider = Custom endpoint,"
echo "     model = $MODEL, endpoint URL = your tunnel URL."
echo "  3. Keep this window open while you want Tom.0 to use your brain."
echo
ollama serve
EOF
chmod +x start-brain.sh

echo
echo "[3/3] Done! Run ./start-brain.sh whenever you want Tom.0 to use your PC."
echo "      First-time setup continues in the README (tunnel + dashboard step)."
