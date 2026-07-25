# AGENTS.md

## Purpose

This repository is the source of truth for reproducible Hermes Agent VM deployments.

## Operating rules

1. Read `README.md`, this file, and relevant files under `docs/` before changing infrastructure or runtime behavior.
2. Prefer declarative configuration over manual instructions.
3. Keep scripts idempotent: running them repeatedly must not corrupt or duplicate state.
4. Never commit secrets, credentials, tokens, private keys, generated `.env` files, runtime sessions, logs, or user memory.
5. Keep `HERMES_HOME` separate from the Hermes source checkout.
6. Use the official Hermes installer unless a documented architectural decision explicitly replaces it.
7. Pin infrastructure inputs where practical; document intentional floating versions.
8. Make the smallest coherent change and update documentation in the same change.
9. Run `make validate` before proposing or publishing changes.
10. Record important architectural choices under `docs/decisions/`.

## Repository layout

- `config/`: versioned, non-secret configuration templates.
- `docs/`: architecture, operations, and decisions.
- `infra/`: cloud and VM provisioning definitions.
- `scripts/`: installation, validation, deployment, and maintenance commands.
- `references/`: source URLs and research notes.

## Change acceptance criteria

A change is complete when:

- configuration is understandable without chat history;
- a human can reproduce it from a fresh VM;
- an LLM can identify prerequisites, commands, expected outputs, and rollback steps;
- validation passes;
- no secret material is present.
