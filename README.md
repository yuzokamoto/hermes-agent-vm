# hermes-agent-vm

A reproducible, security-conscious Hermes Agent workstation for Ubuntu Desktop running in VMware Workstation Pro.

## Supported baseline

- Ubuntu Desktop 24.04 or 26.04 LTS amd64
- VMware Workstation Pro on Windows 11
- Recommended VM: 8 vCPU, 16 GB RAM, 150 GB thin-provisioned disk, UEFI, NAT and 3D acceleration
- Default Ubuntu GNOME desktop; this repository does not replace the desktop environment

The repository configures one workstation. It does not provision, clone, schedule or orchestrate virtual machines.

## What this repository configures

- Ubuntu updates, unattended security updates, SSH, firewall and VMware guest integration
- Bash, tmux, Git/GitHub CLI and common Unix development tools
- `mise` as the user-space runtime and CLI manager
- Node.js, npm, Codex CLI, Claude Code and Promptfoo through `mise`
- a three-day minimum release age for ecosystem-managed tool installation
- Docker from Ubuntu packages when enabled
- Hermes Agent through its official installer
- managed Hermes safety policy, project context and profile contract
- restic backup for Hermes state, workspaces and durable knowledge
- verification and safe-suspend procedures

## First run

Install Ubuntu Desktop, open a terminal and run:

```bash
git clone https://github.com/yuzokamoto/hermes-agent-vm.git
cd hermes-agent-vm
cp .env.example .env
nano .env
make validate
make bootstrap
sudo reboot
```

After reboot:

```bash
cd ~/hermes-agent-vm
make configure
make verify
```

Provider credentials and OAuth sessions must remain in their own credential stores. Do not add them to `.env` or Git.

## Operations

```bash
make verify
make backup
make safe-suspend
make eval
make validate
```

Run `make safe-suspend` before suspending or shutting down a guest that holds active project state.

## Supply-chain policy

- APT remains the authority for system packages.
- `mise` manages user-space runtimes and AI CLIs.
- `mise install --minimum-release-age 3d` avoids releases published during the previous three days.
- SLSA verification remains enabled for mise backends that support it.
- Package-manager install scripts are avoided where a signed APT package is available.
- Versions are intentionally constrained by major release in `mise.toml`; update them through reviewed repository changes.

The age gate reduces exposure to newly compromised releases, but it is not a substitute for lockfiles, provenance, signatures, least privilege and review.

## Security model

- Production access is disabled by policy unless explicitly approved.
- Destructive changes, external messages, purchases and credential changes require approval.
- Hermes memory is not the sole source of truth; durable decisions belong in project repositories and backups.
- Secrets remain in scoped provider stores or interactive OAuth sessions, not Git.
