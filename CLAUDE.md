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

The deploy script SSHs into Liora_VM (`ubuntu@liora-vm.matthiaskoehler.com`, key `~/.ssh/data_enginering_machine.pem`), pulls the latest commit, and restarts the container via `docker compose up --build`.

**Note:** The repo is public on GitHub — required so the VM can `git clone` without credentials.

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
