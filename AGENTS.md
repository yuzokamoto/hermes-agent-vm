# AGENTS.md

## Purpose

This repository is the source of truth for configuring one complete Hermes Agent workstation on Ubuntu Desktop inside VMware Workstation Pro.

It does not provision, clone, schedule, inventory, snapshot or orchestrate virtual machines.

## Operating rules

1. Read `README.md`, this file, and relevant files under `docs/` before changing workstation or runtime behavior.
2. Prefer declarative configuration over manual instructions.
3. Keep scripts idempotent: repeated runs must not corrupt or duplicate state.
4. Never commit secrets, credentials, tokens, private keys, generated `.env` files, runtime sessions, logs or user memory.
5. Keep `HERMES_HOME` separate from the repository checkout.
6. Use the official Hermes installer unless a documented architectural decision explicitly replaces it.
7. Use APT for system packages and mise for user-space runtimes and CLIs.
8. Preserve the three-day minimum release-age policy unless a reviewed exception is documented.
9. Make the smallest coherent change and update documentation in the same change.
10. Run `make validate` before publishing changes.
11. Treat VMware snapshots and recovery as external manual operations, not repository-managed behavior.

## Repository layout

- `bootstrap/`: idempotent workstation installation steps.
- `config/`: versioned, non-secret shell and tool configuration.
- `hermes/`: managed Hermes policies, profiles and workstation context.
- `scripts/`: validation, configuration and workstation maintenance commands.
- `evals/`: prompt and provider regression evaluation configuration.
- `docs/`: architecture, operations and decisions.
- `references/`: source URLs and research notes.

## Change acceptance criteria

A change is complete when:

- configuration is understandable without chat history;
- a human can reproduce it from a fresh Ubuntu Desktop VM;
- an LLM can identify prerequisites, commands, expected outputs and rollback steps;
- validation passes;
- no VM-orchestration artifacts or secret material are present.
