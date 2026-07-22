# HomeLab

A collection of self-hosted services and infrastructure configurations for my personal home lab environment. This repository contains Docker Compose configurations, deployment scripts, and documentation for various services.

## Overview

This repository serves as the central configuration hub for my home lab infrastructure, emphasizing:
- **Infrastructure as Code**: All service configurations are version-controlled
- **Security Best Practices**: Secrets management using environment variables
- **Docker-First Approach**: Containerized services for easy deployment and management
- **Documentation**: Comprehensive setup guides for each service

## Deployment

Services are deployed and managed via **Portainer GitOps**:

1. Push changes to this repository on GitHub
2. Portainer polls GitHub every 5 minutes and automatically pulls changes and redeploys affected stacks
3. For immediate deployment (e.g. during troubleshooting), trigger a manual **Force Update** in Portainer

Environment variables are stored per-stack in Portainer — not in `.env` files on the host.

## Maintenance

### Backing Up Data

```bash
cd <service-directory>
docker compose down
tar -czf backup-$(date +%Y%m%d).tar.gz /mnt/shared-storage/docker-stacks/<service-name>
docker compose up -d
```

### Monitoring

```bash
# View all running containers
docker ps

# Check specific service logs
cd <service-directory>
docker compose logs -f

# View resource usage
docker stats
```

## Services

### Traefik
Reverse proxy and TLS termination layer. Creates the shared `traefik` Docker network used by services that need to be exposed via domain names.

- **Location**: [`/traefik`](traefik/)
- **Access**: `10.0.5.5` (macvlan — dedicated LAN IP), dashboard at `https://<TRAEFIK_DOMAIN>/dashboard/`
- **Documentation**: See [traefik/README.md](traefik/README.md)
- **Deploy first** — other services depend on the `traefik` network

### Arcane
Self-hosted application management platform for homelabs.

- **Location**: [`/arcane`](arcane/)
- **Port**: 3552
- **Documentation**: See [arcane/README.md](arcane/README.md)

### Termix
Web-based terminal emulator for remote system access.

- **Location**: [`/termix`](termix/)
- **Port**: 8090
- **Documentation**: See [termix/README.md](termix/README.md)

### n8n
Self-hosted workflow automation platform. Connects apps, APIs, and services via a node-based visual editor, with PostgreSQL for persistent workflow state.

- **Location**: [`/n8n`](n8n/)
- **Access**: `https://<N8N_DOMAIN>` (via Traefik, LAN only)
- **Port**: 5678 (direct access)
- **Documentation**: See [n8n/README.md](n8n/README.md)

### Uptime Kuma
Self-hosted uptime monitoring for services via HTTP/HTTPS, TCP, DNS, and more.

- **Location**: [`/uptime-kuma`](uptime-kuma/)
- **Access**: `https://<UPTIME_KUMA_DOMAIN>` (via Traefik)
- **Documentation**: See [uptime-kuma/README.md](uptime-kuma/README.md)


### Home Assistant
Open-source home automation platform. Connects to thousands of devices and services — lights, sensors, locks, cameras, media players — and runs automations entirely locally without cloud dependency.

- **Location**: [`/homeassistant`](homeassistant/)
- **Access**: `https://<HOMEASSISTANT_DOMAIN>` (via Traefik) and `http://<host-ip>:8123` (direct, for companion app)
- **Documentation**: See [homeassistant/README.md](homeassistant/README.md)

### Calibre
Calibre desktop GUI (KasmVNC) and Calibre-Web for ebook library management and browser-based reading.

- **Location**: [`/calibre`](calibre/)
- **Ports**: 8085/8086 (Calibre desktop GUI), 8081 (Calibre content server), 8083 (Calibre-Web)
- **Documentation**: See [calibre/README.md](calibre/README.md)

### Changedetection.io
Website change detection and monitoring with full JavaScript rendering via Playwright/Chrome.

- **Location**: [`/changedetection`](changedetection/)
- **Port**: 5000
- **Documentation**: See [changedetection/README.md](changedetection/README.md)

### Dozzle
Real-time Docker log viewer. Streams container logs to a browser UI — stateless, no log storage.

- **Location**: [`/dozzle`](dozzle/)
- **Access**: `https://<DOZZLE_DOMAIN>` (via Traefik)
- **Documentation**: See [dozzle/README.md](dozzle/README.md)

### Paperless-NGX
Document management system — scan, index, and archive documents with OCR and full-text search.

- **Location**: [`/paperless-ngx`](paperless-ngx/)
- **Access**: `https://<PAPERLESS_DOMAIN>` (via Traefik)
- **Documentation**: See [paperless-ngx/readme.md](paperless-ngx/readme.md)

### Open WebUI
Web UI for interacting with self-hosted LLM models via Ollama.

- **Location**: [`/openwebui`](openwebui/)
- **Access**: `https://<OPENWEBUI_DOMAIN>` (via Traefik)
- **Ollama host**: Remote instance at `<OLLAMA_HOST>:11434`
- **Documentation**: See [openwebui/README.md](openwebui/README.md)

### code-server
Browser-based VS Code development environment.

- **Location**: [`/code-server`](code-server/)
- **Access**: `https://<CODESERVER_DOMAIN>` (via Traefik, LAN only)
- **Documentation**: See [code-server/README.md](code-server/README.md)

### Karakeep
Bookmark and read-it-later service with Meilisearch and browser capture support.

- **Location**: [`/karakeep`](karakeep/)
- **Access**: `https://<KARAKEEP_DOMAIN>` (via Traefik)
- **Documentation**: See [karakeep/README.md](karakeep/README.md)

### Linkwarden
Collaborative bookmark manager with PostgreSQL persistence.

- **Location**: [`/linkwarden`](linkwarden/)
- **Access**: `https://<LINKWARDEN_DOMAIN>` (via Traefik)
- **Documentation**: See [linkwarden/README.md](linkwarden/README.md)

### Readeck
Self-hosted read-it-later service.

- **Location**: [`/readeck`](readeck/)
- **Access**: `https://<READECK_DOMAIN>` (via Traefik)
- **Documentation**: See [readeck/README.md](readeck/README.md)

### Traefik Manager
Web UI for managing Traefik dynamic configuration.

- **Location**: [`/traefik-manager`](traefik-manager/)
- **Access**: `https://<TRAEFIK_MANAGER_DOMAIN>` (via Traefik)
- **Requires**: Traefik API enabled internally
- **Documentation**: See [traefik-manager/README.md](traefik-manager/README.md)

## Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose V2
- Linux host with sufficient storage for container volumes

### General Deployment Pattern

Each service follows a consistent structure:

```bash
# Navigate to service directory
cd <service-name>

# Copy environment template (if exists)
cp example.env .env  # Only for services requiring secrets

# Edit configuration
nano .env  # Customize as needed

# Start the service
docker compose up -d

# Check status
docker compose ps
docker compose logs -f
```

## Repository Structure

```
HomeLab/
├── traefik/                        # Reverse proxy and TLS termination
├── dozzle/                         # Real-time Docker log viewer
├── uptime-kuma/                    # Uptime monitoring (HTTP, TCP, DNS)
├── wud/                            # What's Up Docker — container update notifications
├── paperless-ngx/                  # Document management with OCR
├── calibre/                        # Calibre + Calibre-Web ebook manager
├── changedetection/                # Website change detection and monitoring
├── openwebui/                      # Web UI for Ollama LLM models
├── linkwarden/                     # Bookmark manager
├── karakeep/                       # Bookmark/read-it-later service
├── readeck/                        # Read-it-later service
├── homeassistant/                  # Home automation platform
├── arcane/                         # Application management platform
├── termix/                         # Web-based terminal emulator
├── code-server/                    # Browser-based VS Code
├── forgejo/                        # Self-hosted Git service
├── glance/                         # Modern dashboard with Docker integration
├── semaphore/                      # Ansible/Terraform/OpenTofu UI
├── n8n/                            # Workflow automation platform
├── traefik-manager/                # Traefik dynamic config manager
├── .gitignore                      # Git ignore patterns (protects secrets)
├── LICENSE                         # MIT License
└── README.md                       # This file
```

## Security

### Secrets Management

This repository follows security best practices:

- **Environment Variables**: Secrets are stored in `.env` files (gitignored)
- **Templates**: `example.env` files provide configuration templates
- **Never Committed**: Actual secrets are never committed to version control
- **Unique Per Service**: Each service manages its own secrets

### Protected Files

The following files are automatically excluded from version control:
- `.env`, `.env.local`, `.env.*.local` - Environment files with secrets
- `compose.override.yaml` - Docker override files that may contain secrets
- `*.log` - Log files that might contain sensitive information
- IDE and OS-specific files

### Best Practices

1. **Always check before committing**:
   ```bash
   git status  # Verify no .env files are staged
   ```

2. **Generate strong secrets**:
   ```bash
   openssl rand -hex 32  # For encryption keys
   openssl rand -base64 32  # For passwords
   ```

3. **Rotate secrets regularly** - Change passwords and keys quarterly

4. **Backup securely** - Encrypt backups of `.env` files:
   ```bash
   gpg --symmetric --cipher-algo AES256 .env
   ```

## Storage Configuration

Services are configured to use persistent storage at `/mnt/shared-storage/docker-stacks/`:

- **Traefik Certs**: `/mnt/shared-storage/docker-stacks/traefik/certs`
- **Arcane Data**: `/mnt/shared-storage/docker-stacks/arcane`
- **Termix Data**: `/mnt/shared-storage/docker-stacks/termix`
- **Uptime Kuma Data**: `/mnt/shared-storage/docker-stacks/uptime-kuma`
- **WUD Store**: `/mnt/shared-storage/docker-stacks/wud`
- **Dozzle Data**: `/mnt/shared-storage/docker-stacks/dozzle`
- **Calibre Config**: `/mnt/shared-storage/docker-stacks/calibre`
- **Calibre-Web Config**: `/mnt/shared-storage/docker-stacks/calibre-web`
- **Changedetection Data**: `/mnt/shared-storage/docker-stacks/changedetection`
- **code-server Data**: `/mnt/shared-storage/docker-stacks/code-server`
- **Karakeep Data**: `/mnt/shared-storage/docker-stacks/karakeep/data`
- **Karakeep Meilisearch**: `/mnt/shared-storage/docker-stacks/karakeep/meilisearch`
- **Linkwarden Data**: `/mnt/shared-storage/docker-stacks/linkwarden/data`
- **Linkwarden Database**: `/mnt/shared-storage/docker-stacks/linkwarden/db`
- **Open WebUI Data**: `/mnt/shared-storage/docker-stacks/openwebui`
- **Readeck Data**: `/mnt/shared-storage/docker-stacks/readeck/data`
- **Paperless Data**: `/mnt/shared-storage/docker-stacks/paperless/data`
- **Paperless Media**: `/mnt/shared-storage/docker-stacks/paperless/media`
- **Paperless Consume**: `/mnt/shared-storage/docker-stacks/paperless/consume`
- **Paperless Export**: `/mnt/shared-storage/docker-stacks/paperless/export`
- **Paperless Database**: `/mnt/shared-storage/docker-stacks/paperless/db`
- **Paperless Redis**: `/mnt/shared-storage/docker-stacks/paperless/redis`
- **Home Assistant Config**: `/mnt/shared-storage/docker-stacks/homeassistant`
- **Traefik Manager Config**: `/mnt/shared-storage/docker-stacks/traefik-manager/config`
- **Traefik Manager Backups**: `/mnt/shared-storage/docker-stacks/traefik-manager/backups`
- **Traefik Dynamic Config**: `/mnt/shared-storage/docker-stacks/traefik/dynamic`
- **n8n Data**: `/mnt/shared-storage/docker-stacks/n8n/data`
- **n8n Database**: `/mnt/shared-storage/docker-stacks/n8n/postgres`

Ensure this path exists and has appropriate permissions before deploying services.

## Troubleshooting

### Common Issues

**Port conflicts**:
```bash
# Check what's using a port
sudo lsof -i :<port-number>
# or
sudo netstat -tulpn | grep <port-number>
```

**Permission errors**:
```bash
# Check current user/group IDs
id -u  # User ID
id -g  # Group ID

# Update PUID/PGID in .env files accordingly
```

**Container won't start**:
```bash
# View detailed logs
docker compose logs <service-name>

# Verify configuration
docker compose config

# Check for missing environment variables
grep -v '^#' .env | grep -v '^$'
```

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [OWASP Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Phaneendra

---

**Note**: This repository contains configuration files and documentation. Actual secrets and sensitive data are stored locally and never committed to version control.