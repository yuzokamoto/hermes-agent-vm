# hermes-agent-vm

Reproducible, versioned configuration for provisioning and operating Hermes Agent virtual machines.

## Goals

- Rebuild a VM from source-controlled configuration.
- Keep instructions readable by humans and LLM agents.
- Make changes reviewable, testable, and reversible.
- Keep secrets outside the repository.

## Current scope

The repository currently provides a cloud-agnostic Hermes bootstrap and validation layer. Cloud-specific infrastructure will be added after selecting the provider and target VM shape.

Hermes is installed through its official installer. Runtime data lives under `HERMES_HOME` (default: `~/.hermes`) and must remain outside this repository checkout.

## Requirements

- Linux VM or compatible environment
- Git
- curl
- GNU Make

The official Hermes installer manages its own Python, Node.js, `uv`, ripgrep, ffmpeg, source checkout, and virtual environment.

## Usage

```bash
git clone https://github.com/yuzokamoto/hermes-agent-vm.git
cd hermes-agent-vm

make bootstrap
hermes setup
make validate
```

`make bootstrap` installs Hermes when absent and runs `hermes update` when it is already present. It intentionally skips interactive setup so credentials are never encoded in provisioning scripts.

## Commands

```bash
make bootstrap  # install or update Hermes
make validate   # inspect repository safety and run hermes doctor
make deploy     # bootstrap, then validate
```

## Repository contract

- `AGENTS.md` defines how automated agents must work in this repository.
- `docs/` contains architecture and operational decisions.
- `config/` contains declarative, non-secret configuration templates.
- `scripts/` contains idempotent operational scripts.
- `infra/` will contain cloud and VM provisioning definitions.
- `references/` records external sources used by the project.

## Security

Never commit credentials, API keys, private keys, tokens, generated `.env` files, Hermes sessions, logs, or memory. Use `.env.example` only to document non-secret settings, and use `hermes setup` or a cloud secret manager for credentials.
