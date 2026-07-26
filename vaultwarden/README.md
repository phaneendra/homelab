# Vaultwarden

A self-hosted password manager with support for SSH and HTTPS. It's designed to be easy to use and secure.

## Quick Start

### 1. Copy the environment template

```bash
cp .env.example .env
```

### 2. Generate secure password for DB

Generate strong, random secrets for your installation:

```bash
# Generate VAULTWARDEN_DB_PASSWORD (16 characters alpha numeric)
openssl rand -hex 16
```

### 3. Generate secure string for ADMIN TOKEN

Use a temporary, self-destroying Docker container directly on your Proxmox Docker VM terminal:

```bash
# Generate a random Argon2id token string for VAULTWARDEN_ADMIN_TOKEN
docker run --rm -it vaultwarden/server:latest /vaultwarden hash

```
The console will print your fully compiled Argon2id token string

### 4. Edit the .env file

Open the `.env` file in your preferred editor:

```bash
nano .env  # or vim, code, etc.
```

Replace the placeholder values with the secrets you generated above.

### 5. Start the services

```bash
docker compose up -d
```

### 6. Verify everything is running

```bash
# Check container status
docker compose ps

# View logs
docker compose logs -f vaultwarden

# Access the application
# Open http://localhost:3552 in your browser
```

## Environment Variables

### Required Secrets

These **MUST** be set in your `.env` file before starting:

| Variable | Description | How to Generate |
|----------|-------------|-----------------|
| `VAULTWARDEN_DB_PASSWORD` | Used for PG db to store all vaultwarden data | `openssl rand -hex 16` |
| `VAULTWARDEN_ADMIN_TOKEN` | Randomly generated token for admin access | `/vaultwarden hash` |

### Optional Configuration

These have sensible defaults but can be customized:

| Variable | Default | Description |
|----------|---------|-------------|
| `VAULTWARDEN_DOMAIN` | `vaultwarden.yourdomain.com` | Domain name for the application |
| `VAULTWARDEN_ADMIN_TOKEN` | `admin_token` | Admin token for authentication `openssl rand -hex 32`|
| `VAULTWARDEN_SIGNUPS_ALLOWED` | `false` | Allow signup initially allow signups, but you should change this later in the admin panel |
| `VAULTWARDEN_INVITATIONS_ALLOWED` | `false` | Allow invitations |

## Important Notes
Disable open user registration after setting up your account. This can be done via the /admin web panel, if enabled, or by adjusting the config.json file. Alternatively via environment variables.

⚠️ Note: The WebSockets service for live sync has been integrated in the main HTTP server, which means simpler proxy setups that don't require a separate rule to redirect WS traffic to port 3012.