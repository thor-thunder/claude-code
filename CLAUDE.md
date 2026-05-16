# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Claude Code is a command-line agentic coding tool that helps developers execute routine tasks, understand codebases, and manage git workflows. This repository contains the official Claude Code distribution and a collection of 13 official plugins that extend Claude Code functionality through custom commands, specialized agents, and automation hooks.

## Repository Structure

**Key directories:**

- `/plugins` — Official Claude Code plugins that extend functionality. Each plugin is a self-contained package with its own README, commands, agents, skills, and hooks.
- `/.claude-plugin/` — Plugin marketplace configuration (`marketplace.json`) that describes all bundled plugins.
- `/.claude/commands/` — Custom commands specific to this repository (issue triage, dedupe, commit workflows).
- `/scripts/` — Utility scripts for GitHub automation and issue management (TypeScript and shell scripts).
- `/.github/workflows/` — GitHub Actions workflows for issue triage, duplicate detection, and lifecycle management.

**Plugin marketplace schema:** `.claude-plugin/marketplace.json` defines all plugins with their metadata, descriptions, source paths, and categories (development, productivity, learning, security).

## Plugin Architecture

Each plugin follows this structure:
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata (name, version, author)
├── README.md                # Comprehensive plugin documentation
├── commands/                # Slash commands (e.g., /feature-dev)
├── agents/                  # Specialized agents for complex workflows
├── skills/                  # Expert Skills that agents use (reusable logic)
├── hooks/                   # Event handlers (SessionStart, PreToolUse, Stop)
└── .mcp.json                # MCP server integrations (optional)
```

Plugins export agents and skills that appear in Claude Code's autocomplete and can be invoked by users or other plugins. Hooks allow plugins to react to events and modify Claude Code's behavior.

## Key Plugins

- **agent-sdk-dev** — Create and validate Claude Agent SDK projects (`/new-sdk-app`).
- **feature-dev** — Structured 7-phase feature development workflow (`/feature-dev`).
- **code-review** — Automated multi-agent PR review with confidence scoring (`/code-review`).
- **commit-commands** — Streamlined git operations (`/commit`, `/commit-push-pr`).
- **pr-review-toolkit** — Specialized agents for comments, tests, error handling, types, and code simplification.
- **plugin-dev** — Toolkit for building new Claude Code plugins (`/plugin-dev:create-plugin`).
- **hookify** — Create custom hooks to prevent unwanted behaviors (`/hookify`).
- **ralph-wiggum** — Iterative AI loops for autonomous task completion (`/ralph-loop`).
- **security-guidance** — Security reminder hook that warns about command injection, XSS, eval, and other patterns.
- **frontend-design** — Production-grade frontend interfaces with bold design choices.
- **explanatory-output-style** / **learning-output-style** — Output style variants with educational context.
- **claude-opus-4-5-migration** — Automated code migration from Sonnet 4.x and Opus 4.1.

## Common Development Tasks

### Understanding a Plugin

1. Read the plugin's README.md in `/plugins/{plugin-name}/` for overview and features.
2. Examine `.claude-plugin/plugin.json` for metadata and version.
3. Check `/commands/` for slash commands users can invoke.
4. Check `/agents/` for specialized agents.
5. Check `/skills/` for reusable logic (often the core of a plugin).
6. Check `/hooks/` for event-driven behavior (SessionStart, PreToolUse, Stop, etc.).

### Testing a Plugin

Plugins are typically tested by invoking their commands or agents in Claude Code:
```bash
/plugin-name:command-name
# or ask an agent to do something it specializes in
```

For skill-based plugins, trigger the agent that uses the skill by describing the desired outcome.

### Modifying a Plugin

1. Locate the relevant component (command, agent, skill, or hook).
2. Edit the file in place — plugin structure is self-contained, so changes are isolated.
3. Test by invoking the modified command or agent in Claude Code.
4. Ensure README.md is updated if behavior changes.

### Adding a New Plugin

Use the `plugin-dev` plugin: `/plugin-dev:create-plugin`. This guided 8-phase workflow scaffolds a new plugin with the correct structure, metadata, and examples.

## Repository-Specific Commands

Custom commands for this repository are defined in `/.claude/commands/`:

- **commit-push-pr** — Stage changes, create a commit, push to a new branch, and open a PR.
- **dedupe** — Find up to 3 likely duplicate GitHub issues using parallel agents and keyword search.
- **triage-issue** — Analyze issues and apply appropriate labels (bug, enhancement, needs-repro, needs-info, invalid, etc.).

These commands use GitHub API automation via `./scripts/gh.sh` and `./scripts/edit-issue-labels.sh`.

## GitHub Automation

`/scripts/` contains utilities for GitHub automation:

- `gh.sh` — Wrapper for `gh` CLI with restricted subcommands (issue view, issue list, search issues, label list).
- `comment-on-duplicates.sh` — Post duplicate detection comments to issues.
- `edit-issue-labels.sh` — Add/remove labels from issues.
- TypeScript utilities (`auto-close-duplicates.ts`, `sweep.ts`) — Run via GitHub Actions workflows.

Workflows in `/.github/workflows/` automate issue triage, duplicate detection, lifecycle management (auto-close stale issues), and label management.

## Marketplace Configuration

The `.claude-plugin/marketplace.json` file is the source of truth for all bundled plugins. It lists:
- Plugin name, version, and description
- Author information
- Source path (relative to repo root)
- Category (development, productivity, learning, security)

This configuration is used by Claude Code to discover and load plugins.

## Adding a Plugin to the Marketplace

1. Create the plugin in `/plugins/{plugin-name}/` with the standard structure.
2. Add an entry to `.claude-plugin/marketplace.json` with metadata and source path.
3. Update `/plugins/README.md` to include the new plugin in the plugins table.
4. Ensure the plugin has a comprehensive README.md.

## Versioning and Releases

- Individual plugins have `version` fields in `.claude-plugin/plugin.json`.
- The marketplace itself has a `version` in `marketplace.json`.
- `CHANGELOG.md` tracks all updates (repository uses automated changelog updates via git commits).

## Key Files for Reference

- **Plugin marketplace:** `.claude-plugin/marketplace.json`
- **Plugin documentation index:** `/plugins/README.md`
- **Repository commands:** `/.claude/commands/`
- **GitHub automation:** `/.github/workflows/` and `/scripts/`
- **Main README:** `/README.md` (user-facing overview)

## Development Environment

The repository uses:
- **Bun** runtime (evident from scripts using `#!/usr/bin/env bun`)
- **TypeScript** for automation scripts
- **Shell scripts** for GitHub API wrappers
- **GitHub Actions** for CI/CD

No npm dependencies are required to browse or document plugins. Individual plugins may have their own build/test setup documented in their README.
