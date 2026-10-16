# Tim Brain Bundle 🧠

Turn your own PC into a **free local AI brain** for the [Tim Discord bot](https://tim.rivaleclipse.dev) — no API key, no per-message cost, your conversations never leave your machine except to reach Discord.

This is the same idea as Tim's bring-your-own-key setup, minus the key: instead of paying OpenAI / Google / Anthropic, you run the model yourself with [Ollama](https://ollama.com).

## What you need

- A PC (Windows, macOS, or Linux) that stays on while you want Tim to use it
- ~5 GB free disk for the recommended model (~2 GB for the light models)
- 8 GB RAM minimum (16 GB recommended for the full-size models)

## Install (one step)

**Windows:** download this repo (Code → Download ZIP), unzip, double-click **`install.bat`**.

**macOS / Linux:** download, unzip, then in a terminal inside the folder:

```bash
bash install.sh
```

The installer will:
1. Install Ollama if you don't have it
2. Let you pick a model (uncensored or standard, full-size or light)
3. Download the model
4. Create your **`start-brain`** script

## Run it

**Windows:** double-click **`start-brain.bat`**.
**macOS / Linux:** `./start-brain.sh`

Keep that window open while you want Tim thinking with your PC.

## Connect it to Tim (one time)

Tim runs in the cloud, so it needs a way to reach your PC:

1. Expose Ollama's port with a tunnel, e.g. [ngrok](https://ngrok.com): `ngrok http 11434`
   (or Tailscale if you prefer — anything that gives your PC a public HTTPS URL)
2. Open the **Tim dashboard** → your server → **AI provider**
3. Provider = **Custom endpoint**, model = the name you picked (e.g. `dolphin-llama3`), endpoint URL = your tunnel URL
4. Save. Tim now thinks with your PC. 💬

## Models

| Model | Style | Size | Best for |
|---|---|---|---|
| `dolphin-llama3` | Uncensored | ~4.7 GB | Best quality, zero guardrails (recommended) |
| `dolphin-phi` | Uncensored | ~1.6 GB | Weaker PCs, still uncensored |
| `llama3.1` | Standard | ~4.7 GB | Best quality with safety guardrails |
| `qwen2.5:3b` | Standard | ~1.9 GB | Weaker PCs |

To switch models later, just run `ollama pull <name>` and update the `.tomo-model` file (or re-run the installer).

## Notes

- Everything runs on **your** hardware. Nothing here phones home to us.
- Uncensored models have no safety guardrails — pair them with Tim's filter level and content-type toggles to taste.
- Your PC must be on and `start-brain` running for Tim to reply. If it's offline, Tim will report the brain is unreachable until you start it (or switch the server back to an API provider).
