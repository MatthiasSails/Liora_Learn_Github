# CLAUDE.md — Liora_Learn_Github

Project-level instructions for Claude Code when working in this repository.

---

## Purpose

Learning sandbox for Git and GitHub workflows — part of the Liora / DataScientest Data Engineering Bootcamp.

This is **not** a production repo. It exists to practice:

- branching, merging, rebasing
- pull requests and code review
- remotes, fetch, pull, push semantics
- conflict resolution
- repository configuration (`.gitignore`, `LICENSE`, README)

---

## Working style

- **Experiments are welcome.** Force-pushes, rewritten history, weird branches — all fair game here.
- **Don't worry about pretty commit messages.** Optimize for learning, not aesthetics.
- **Mistakes are the point.** When something breaks, debug it; that's the lesson.

---

## What this repo is not

- Not a place for secrets, credentials, or anything you'd care about losing.

---

## Repo-Struktur

```
corolla-run/          # nginx-Webapp (Toyota Corolla dodge game)
portainer-agent/      # Portainer Agent Stack + Cloudflare DDNS Script
mongodb/              # MongoDB 7.0 Stack (DataScientest Training)
docs/                 # Projektdokumentation und Zukunftspläne
```

## Deployed app: corolla-run

This repo also contains a real Docker-based web app that runs on Liora_VM:

```
corolla-run/
├── Dockerfile          # nginx:alpine image
├── docker-compose.yml  # port 8080, restart unless-stopped
├── deploy.sh           # pull from GitHub + docker compose up on Liora_VM
└── index.html          # Toyota Corolla dodge game (single-file HTML/CSS/JS)
```

**Live URL:** http://liora-vm.matthiaskoehler.com:8080

**Deploy after a change:**
```bash
git push
bash corolla-run/deploy.sh
```

Das deploy.sh nutzt den SSH-Alias `Liora_VM` (konfiguriert in `~/.ssh/config` auf dem Mac).

**Note:** The repo is public on GitHub — required so the VM can `git clone` without credentials.

## Infrastructure: Liora_VM

- **Hostname:** `liora-vm.matthiaskoehler.com` (Cloudflare DDNS, aktualisiert alle 5 min per Cron)
- **DDNS-Script:** `portainer-agent/cloudflare-ddns.sh`, Token in `~/.cf_ddns_token` auf der VM
- **Portainer Agent** läuft auf Port 9001 (`portainer-agent/docker-compose.yml`)
- **AWS Security Group:** `de_terminal` — wird von DataScientest verwaltet, kein Zugriff für Schulungsteilnehmer. Port 9001 ist nicht von außen erreichbar, daher kein Anschluss an Home-Portainer möglich. Siehe `docs/portainer-on-vm.md` für den Plan.

---

## MongoDB Stack

```
mongodb/
├── docker-compose.yml   # mongo:7.0, Port 27017, Volume ./sample_training
└── deploy.sh            # pull + docker compose up auf Liora_VM
```

**Deploy:**
```bash
git push
bash mongodb/deploy.sh
```

**Verbinden:**
```bash
mongosh 'mongodb://<user>:<password>@liora-vm.matthiaskoehler.com:27017'
```

Credentials sind Training-Defaults (DataScientest, siehe docker-compose.yml) — kein Produktiveinsatz.

---

## Common practice scenarios

```bash
# Try a branch
git checkout -b experiment/foo
echo "test" > file.txt
git add file.txt && git commit -m "test"
git push -u origin experiment/foo

# Merge or rebase back
git checkout main
git merge experiment/foo
# or
git rebase main

# Clean up
git branch -d experiment/foo
git push origin --delete experiment/foo
```

---

## When in doubt

Break it intentionally, then fix it. That's the curriculum.
