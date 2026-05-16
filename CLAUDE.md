# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Code is an agentic coding tool that lives in your terminal and helps developers execute routine tasks, explain complex code, and handle git workflows through natural language commands. The repository contains:

- **Plugin system**: Extensible framework for custom commands, agents, and MCP servers in `/plugins`
- **GitHub automation**: TypeScript/Bun scripts for issue management and lifecycle automation
- **Official plugins**: Example plugins demonstrating the plugin system capabilities

## Development Setup

### Runtime & Package Management

This project uses **Bun** (all-in-one JavaScript runtime):

- Check installed Bun version: `bun --version`
- Install dependencies: `bun install`
- Run scripts: `bun run <script-path>` (e.g., `bun run scripts/auto-close-duplicates.ts`)

### Running Automation Scripts

All scripts in `/scripts` are Bun TypeScript files marked with `#!/usr/bin/env bun`. They can be executed directly:

```bash
bun run scripts/auto-close-duplicates.ts
bun run scripts/lifecycle-comment.ts
bun run scripts/sweep.ts
```

Scripts require environment variables (set via GitHub Actions or manually):
- `GITHUB_TOKEN` - Authentication for GitHub API
- `GITHUB_REPOSITORY` - Repository in `owner/repo` format
- Script-specific vars documented in each file

## Repository Structure

### `/scripts`
GitHub automation & maintenance scripts:
- **Issue lifecycle**: `auto-close-duplicates.ts`, `sweep.ts`, `lifecycle-comment.ts` - Handle stale/inactive issues
- **Issue interaction**: `comment-on-duplicates.sh`, `edit-issue-labels.sh` - Manage issue comments and labels
- **GitHub CLI wrapper**: `gh.sh` - Restricted shell wrapper around `gh` CLI for safe automation
- **Utilities**: `issue-lifecycle.ts` - Shared configuration for lifecycle labels and timeouts

**Key pattern**: Scripts use GitHub API via `fetch()` with Bearer token auth, or delegate to `gh` CLI.

### `/plugins`
Official Claude Code plugins organized by purpose. Each plugin directory contains:
- `Claude.md` - Plugin-specific guidance
- `/commands` - Custom slash commands (if applicable)
- `/agents` - Custom agent definitions
- `/hooks` - Session/tool lifecycle hooks
- `.claude/` - Plugin configuration and MCP server setup

**Notable plugins**:
- `plugin-dev` - 7 expert skills for building new plugins
- `code-review` - Multi-agent PR review with confidence-based filtering
- `feature-dev` - Structured 7-phase feature development workflow
- `pr-review-toolkit` - Specialized PR review agents for different aspects
- `agent-sdk-dev` - Tools for Claude Agent SDK development

### `/examples`
Reference implementations and sample code.

## Working with the Plugin System

### Understanding Plugins

Each plugin is a self-contained extension that can define:

- **Commands** (`.claude/commands/<name>.md`) - Custom slash commands with detailed context
- **Agents** - Specialized AI agents for specific tasks
- **Hooks** - Pre/post-condition automation (SessionStart, PreToolUse, etc.)
- **MCP Servers** - Tool integrations for extended capabilities

### Plugin Development Pattern

Plugins use declarative YAML frontmatter to define:
- `allowed-tools` - Restricted tool access for security
- `description` - Purpose and usage
- Multi-agent orchestration for complex workflows

Example from `code-review`:
```
allowed-tools: [Bash, Read, Edit, Agent]
description: Automated PR code review using multiple specialized agents
```

## Testing & Validation

### Dry-Run Patterns

Several scripts support dry-run modes to preview changes without executing:
- `scripts/sweep.ts --dry-run` - Preview stale issue closures
- `scripts/backfill-duplicate-comments.ts` - Includes workflow dispatch option

Use dry-run mode to verify behavior before production runs.

### Manual Testing

To test scripts locally:

1. Set required env vars: `export GITHUB_TOKEN=...`, `export GITHUB_REPOSITORY=owner/repo`
2. Run script: `bun run scripts/<name>.ts --dry-run` (if available)
3. Review output before running without `--dry-run`

## GitHub Integration

### Issue Management Scripts

The `/scripts` directory implements GitHub issue lifecycle automation:

1. **Duplicate Detection** (`auto-close-duplicates.ts`): Uses Claude to identify duplicate issues, adds comments with findings
2. **Stale Issue Tracking** (`sweep.ts`): Applies lifecycle labels (needs-repro, needs-info, stale, autoclose) with escalating timeouts
3. **Lifecycle Nudging** (`lifecycle-comment.ts`): Posts friendly reminders before auto-closure

**Important**: These scripts are scheduled via GitHub Actions workflows (`.github/workflows/`) and read issue data from GitHub API.

### Safe GitHub CLI Wrapper

The `./scripts/gh.sh` wrapper restricts `gh` CLI usage to safe operations:

**Allowed commands**:
- `./scripts/gh.sh issue view <number>` — Retrieve issue details
- `./scripts/gh.sh issue list --state open` — List issues with filters
- `./scripts/gh.sh search issues "query"` — Search issues
- `./scripts/gh.sh label list` — List repository labels

**Not allowed**: Commands that create/delete/modify that aren't explicitly listed.

## Architecture Notes

### Multi-Agent Patterns

Several plugins demonstrate effective multi-agent orchestration:

- **Parallel agents**: `code-review` launches 5 Sonnet agents in parallel for different review aspects, then aggregates results
- **Sequential pipelines**: `feature-dev` uses `code-explorer` → `code-architect` → `code-reviewer` in sequence
- **Filtering false positives**: Agents validate results against criteria before surfacing to users

Study these patterns when adding new plugins or agents.

### Environment & Data

- Claude Code respects `.gitignore` and excludes sensitive files from context
- Scripts assume GitHub token auth; failures typically indicate missing `GITHUB_TOKEN` env var
- Issue lifecycle uses configuration in `scripts/issue-lifecycle.ts` (single source of truth)

## Common Tasks

### Add a New GitHub Automation Script

1. Create file in `/scripts/<name>.ts` with shebang: `#!/usr/bin/env bun`
2. Implement using `fetch()` for GitHub API or delegate to `./scripts/gh.sh`
3. Document required env vars at the top
4. Add to relevant GitHub Actions workflow in `.github/workflows/`
5. Test with `--dry-run` if applicable

### Create a New Plugin

1. Use `/plugins/plugin-dev/` for guidance (includes 7 expert skills)
2. Or copy structure from similar plugin (e.g., `code-review` for multi-agent approach)
3. Document in plugin's own `Claude.md`
4. Add to `/plugins/README.md` table

### Debug Issue Lifecycle

Check `scripts/issue-lifecycle.ts` for label configuration, timeouts, and messages. This is the single source of truth for lifecycle behavior.
