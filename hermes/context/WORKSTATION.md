# Hermes Workstation Context

This machine is a long-lived local VMware workstation for autonomous project work.

## Operating model

- Each project lives under `$WORKSPACE_ROOT/<project>`.
- Each project must have its own Git repository or explicit non-Git justification.
- Use one Kanban board per active project.
- Record architectural decisions and durable project knowledge in the project repository.
- Treat Hermes memory as assistance, not as the only source of truth.

## Provider policy

- Prefer Codex for implementation tasks.
- Prefer Claude for architecture, review, and second opinions.
- Use OpenRouter only for approved fallback or model-specific work.
- Stop and request guidance when all configured providers are unavailable or budget is exhausted.

## Completion contract

A task is complete only when the requested result exists, relevant checks pass, changes are summarized, risks are stated, and the Kanban item is updated.
