# Provisioning

The first supported deployment target is Hetzner Cloud with Ubuntu 24.04 LTS.

## Prerequisites

- OpenTofu 1.8 or newer
- A Hetzner Cloud project and API token
- An OpenSSH public key
- Your public IPv4 address in CIDR notation, normally `/32`

## Configure

```bash
cp infra/opentofu/terraform.tfvars.example infra/opentofu/terraform.tfvars
```

Edit `terraform.tfvars` and set:

- `ssh_public_key`
- `admin_cidr`
- optional server name, type, image, and location

Export the API token without writing it to disk:

```bash
export HCLOUD_TOKEN='...'
```

## Provision

```bash
make infra-plan
make infra-apply
```

After OpenTofu finishes, use the `ssh_command` output to connect.

Cloud-init creates the `hermes` user, restricts SSH to the configured CIDR, disables password and root login, enables UFW, and installs Hermes non-interactively.

Confirm bootstrap completion:

```bash
cloud-init status --wait
sudo test -f /var/lib/hermes-agent-bootstrap-complete
hermes doctor
```

Complete provider credentials interactively as the `hermes` user:

```bash
hermes setup
```

Credentials and the generated Hermes runtime state remain under `/home/hermes/.hermes` and are not managed by OpenTofu.

## Destroy

```bash
make infra-destroy
```

Review the plan before approving destruction. The VM filesystem and local Hermes state will be deleted unless backed up separately.
