# hermes-agent-vm

Reproducible, versioned configuration for provisioning and operating Hermes Agent virtual machines.

## Goals

- Rebuild a VM from source-controlled configuration.
- Keep instructions readable by humans and LLM agents.
- Make changes reviewable, testable, and reversible.
- Keep secrets outside the repository.

## Repository contract

- `AGENTS.md` defines how automated agents must work in this repository.
- `docs/` contains architecture and operational decisions.
- `config/` contains declarative agent, prompt, and policy configuration.
- `scripts/` contains idempotent operational scripts.
- `infra/` contains infrastructure and machine provisioning definitions.
- `references/` records external sources used by the project.

## Commands

```bash
make bootstrap
make validate
make deploy
```

The commands are placeholders until the target cloud, operating system, and deployment model are selected.

## Security

Never commit credentials, API keys, private keys, tokens, or generated `.env` files. Use `.env.example` only to document required variables.
