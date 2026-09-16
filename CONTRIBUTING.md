# Contributing

Thanks for contributing to Open Local AI Platform.

## Development setup

```bash
git clone https://github.com/YOUR_USERNAME/open-local-ai-platform.git
cd open-local-ai-platform
cp .env.example .env
make up        # start core services
make health    # verify everything is running
make validate  # validate compose files
```

### Linting

```bash
make lint          # lint shell scripts (requires shellcheck)
make validate      # validate all compose files
```

## Development rules

- Keep services optional when they are not required by the core platform.
- Prefer documented upstream images and official installation paths.
- Do not commit secrets, credentials, private model files, or personal data.
- Update docs when Compose variables or service ports change.
- Validate Compose files before opening a PR.

## Adding a new service

1. Choose which layer it belongs to (core, coding, or productivity).
2. Add the service definition to the appropriate compose file with:
   - `restart: unless-stopped`
   - Healthcheck
   - `security_opt: [no-new-privileges:true]`
   - `cap_drop: [ALL]` (add back only what's needed)
   - `logging` with rotation (`max-size: 10m`, `max-file: 3`)
   - `deploy.resources.limits` for memory
   - Appropriate network
3. Add a port variable to `.env.example` with a comment.
4. Add the service to `scripts/healthcheck.sh`.
5. Update the relevant documentation (`README.md`, `docs/OPERATIONS.md`, etc.).
6. Run `make validate` to ensure compose files are valid.
7. Run `make lint` to check shell scripts.

## Commit conventions

- Use imperative mood: "Add feature" not "Added feature"
- Keep commits focused: one logical change per commit
- Reference issues when applicable: "Fix #123"

## Pull request checklist

- [ ] Compose files validate (`make validate`)
- [ ] Shell scripts pass lint (`make lint`)
- [ ] Documentation updated
- [ ] No secrets committed
- [ ] New service has a documented purpose and resource footprint
- [ ] Security implications documented
- [ ] Healthcheck added for new services
