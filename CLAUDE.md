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

- Not a place for real personal projects (those get their own repos).
- Not a place for secrets, credentials, or anything you'd care about losing.
- Not connected to any deployment or runtime — pure git practice ground.

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
