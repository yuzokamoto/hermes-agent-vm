# hermes-agent-vm

A reproducible, security-conscious local AI-agent workstation for VMware Workstation Pro on Windows 11.

## Supported baseline

- Ubuntu Server 24.04 LTS amd64, minimal installation
- VMware Workstation Pro
- Recommended VM: 8 vCPU, 16 GB RAM, 150 GB thin-provisioned disk, UEFI, NAT and 3D acceleration
- OpenSSH selected during Ubuntu installation

Do not customize the guest manually before running this repository. The bootstrap owns system packages, shell defaults, GUI, development tools and Hermes installation.

## What this repository configures

- apt update/full-upgrade, unattended security updates and firewall
- Bash, tmux, Git/GitHub CLI and common Unix development tools
- optional XFCE desktop with VMware guest integration and browsers
- Node.js 22, Python tooling, uv, Docker, Codex CLI, Claude Code and Promptfoo
- Hermes Agent installed through its official installer
- managed safety policy, project context and profile contract
- restic backup for Hermes state, workspaces and durable knowledge
- verification and safe-suspend procedures

The first milestone deliberately avoids unsupported guessed Hermes configuration keys. Release-specific provider routing, Kanban workers, gateway and dashboard settings are applied only after `hermes setup` and schema verification on the installed stable release.

## First run

```bash
git clone https://github.com/yuzokamoto/hermes-agent-vm.git
cd hermes-agent-vm
cp .env.example .env
nano .env
make bootstrap
sudo reboot
```

After reboot:

```bash
cd hermes-agent-vm
make configure
make verify
```

Complete the interactive logins printed by `make configure`. OAuth/session material must not be stored in `.env` or committed.

## Operations

```bash
make verify
make backup
make safe-suspend
make eval
make validate
```

Always run `make safe-suspend` before suspending or shutting down the VMware guest while it holds active project state.

## Security model

- Production access is disabled by default.
- Destructive changes, external messages, purchases and credential changes require approval.
- WhatsApp should use a dedicated account and an allowlist containing only the owner's personal number.
- Hermes memory is not the sole source of truth; durable decisions belong in project repositories and backups.
- Secrets remain in scoped provider stores or interactive OAuth sessions, not Git.

## Legacy cloud work

The existing `infra/` directory is retained as experimental history. It is not part of the supported local-workstation workflow and may be removed or moved to a separate repository after this baseline is validated.
