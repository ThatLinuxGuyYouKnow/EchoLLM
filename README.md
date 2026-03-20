# EchoLLM

<p align="center">
  <img src="assets/icon.png" alt="EchoLLM Logo" width="120"/>
</p>

<p align="center">
  <strong>The best AI models, all in one place.</strong>
</p>

<p align="center">
  <img src="assets/demo.png" alt="EchoLLM Demo" width="700"/>
</p>

<p align="center">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Built_with-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20iOS%20%7C%20Android-555?style=for-the-badge" alt="Platform">
  <a href="#license"><img src="https://img.shields.io/badge/License-Apache%202.0-6e5494?style=for-the-badge" alt="License"></a>
</p>

---

EchoLLM is a privacy-focused desktop client for chatting with multiple AI providers. Your API keys stay on your device — nothing is sent to third-party servers.

## Supported Models

<p>
  <a href="https://ai.google.dev/"><img src="https://img.shields.io/badge/Google-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Google"></a>
  <a href="https://openai.com/"><img src="https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white" alt="OpenAI"></a>
  <a href="https://www.anthropic.com/"><img src="https://img.shields.io/badge/Anthropic-D4A574?style=for-the-badge&logo=anthropic&logoColor=white" alt="Anthropic"></a>
  <a href="https://x.ai/"><img src="https://img.shields.io/badge/xAI-000000?style=for-the-badge&logo=x&logoColor=white" alt="xAI"></a>
</p>

| Model | Provider | Context | Input | Output |
|-------|----------|---------|-------|--------|
| **Gemini 3 Pro** | Google / DeepMind | 1M | $2/M | $12/M |
| **Gemini 3.0 Flash** | Google / DeepMind | 1M | $0.50/M | $4/M |
| **Gemini 2.5 Pro** | Google / DeepMind | 1M | $1.20/M | $8/M |
| **Gemini 2.5 Flash** | Google / DeepMind | 1M | $0.40/M | $3/M |
| **GPT-5.2** | OpenAI | 400K | $5/M | $25/M |
| **GPT 4.1** | OpenAI | 128K | $3/M | $18/M |
| **GPT 4o** | OpenAI | 128K | $2/M | $15/M |
| **Claude Opus 4.6** | Anthropic | 1M (beta) | $5/M | $25/M |
| **Claude 4.5 Sonnet** | Anthropic | 200K | $3/M | $15/M |
| **Claude 4.0 Sonnet** | Anthropic | 400K | $4/M | $20/M |
| **Grok 3** | xAI | 512K | $0.80/M | $0.30/M |
| **Grok 3 mini** | xAI | 64K | $0.20/M | $1.50/M |
| **Grok 4 Fast** | xAI | 2M | $0.50/M | $3/M |

## Features

- **Multi-model chat** — Switch between 13 models from 4 providers in a single conversation
- **Local key management** — API keys stored securely on-device via GetStorage
- **Persistent chat history** — Conversations saved locally with Hive
- **Markdown rendering** — Full markdown support with syntax highlighting in responses
- **Configurable font size** — Adjust text scale from 80% to 150%
- **Send on Enter** — Toggle Enter-to-send behavior
- **Model browser** — View model details including context window, pricing, and capabilities

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.6+)
- API key from at least one supported provider

### Run from source

```bash
git clone https://github.com/thatlinuxguyyouknow/EchoLLM.git
cd EchoLLM
flutter pub get
flutter run -d linux    # or macos, windows
```

### Install from Snap

```bash
snap install echollm
```

## Tech Stack

| | |
|---|---|
| **State Management** | Provider |
| **Local Storage** | Hive (chat history), GetStorage (preferences & keys) |
| **Markdown** | flutter_markdown |
| **Fonts** | Google Fonts (Ubuntu) |
| **HTTP** | http package |



## License

Apache-2.0
