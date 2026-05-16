---
name: Skill Development
description: This skill should be used when the user wants to "create a skill", "add a skill to plugin", "write a new skill", "improve skill description", "organize skill content", or needs guidance on skill structure, progressive disclosure, or skill development best practices for Claude Code plugins.
version: 0.1.0
---

# Skill Development for Claude Code Plugins

Skills are modular packages that extend Claude's capabilities with specialized knowledge and workflows. Think of them as "onboarding guides" for specific domains—they transform Claude from general-purpose into a specialized agent equipped with procedural knowledge.

Skills provide:
- Specialized workflows and multi-step procedures
- Tool integrations and API guidance  
- Domain expertise and company knowledge
- Bundled resources (scripts, references, assets)

## Skill Structure

Every skill needs SKILL.md (required) and optional bundled resources:

```
skill-name/
├── SKILL.md (required, 1,500-2,000 words)
├── references/       (detailed docs, loaded as needed)
├── examples/         (working code to copy/adapt)
└── scripts/          (utilities and tools)
```

**SKILL.md frontmatter:**
- `name` — Skill name
- `description` — Third-person trigger phrases ("This skill should be used when...")
- Body: Core concepts, workflows, resource pointers (lean, imperative form)

**Bundled resources:**
- `references/` — Documentation (schemas, patterns, advanced techniques). Large files (2,000-5,000+ words) load as needed
- `examples/` — Working code users can copy or adapt
- `scripts/` — Utility scripts for validation, testing, automation

## Progressive Disclosure

Skills use three-level loading to manage context efficiently:

1. **Metadata** (name + description) — Always in context
2. **SKILL.md body** — When skill triggers (target 1,500-2,000 words)
3. **Bundled resources** — As needed (no size limit)

## Skill Creation Workflow

1. **Understand use cases** — Identify concrete examples of skill usage and what resources will be needed (scripts, references, assets)

2. **Create structure** — Make skill directory with SKILL.md and needed subdirs:
   ```bash
   mkdir -p skills/skill-name/{references,examples,scripts}
   touch skills/skill-name/SKILL.md
   ```

3. **Write frontmatter** — Third-person description with specific trigger phrases:
   ```yaml
   description: This skill should be used when the user asks to "specific phrase 1", "specific phrase 2"...
   ```
   
   ✅ Good: `"create a hook", "add a PreToolUse hook", "validate tool use"`  
   ❌ Bad: `"working with hooks"` (vague, not third-person)

4. **Write SKILL.md body** — Use imperative/infinitive form (verb-first, no "you"):
   - Core concepts and workflows
   - Essential patterns with examples
   - Pointers to references/examples/scripts
   - Target 1,500-2,000 words

5. **Build bundled resources** — Create references/, examples/, scripts/ as needed:
   - `references/` — Detailed docs, patterns, troubleshooting
   - `examples/` — Working code to copy or adapt
   - `scripts/` — Utilities and validation tools

6. **Validate** — Confirm:
   - Frontmatter includes third-person specific triggers
   - SKILL.md is lean and imperative form
   - All referenced resources exist and are complete
   - No duplication between SKILL.md and references

7. **Test** — Run the skill manually on expected trigger queries and verify it loads correctly

## Writing Style

**Imperative/infinitive (correct):**
```
To create a hook, define the event type.
Configure the MCP server with authentication.
Validate settings before use.
```

**Second person (incorrect):**
```
You should create a hook by defining...
You need to configure the MCP server...
```

**Key principle:** Write for another Claude instance, not a human. Focus on procedural knowledge and reusable patterns.

## Plugin Skills in Claude Code

**Location:** Skills live in `plugin-name/skills/skill-name/` with auto-discovery from SKILL.md files

**Distribution:** Skills are part of the plugin—no separate packaging. Users get skills when they install the plugin.

**Testing:** Install plugin locally and ask questions that should trigger the skill:
```bash
cc --plugin-dir /path/to/plugin
```

## Examples from Plugin-Dev

Study existing skills as templates for best practices:

**hook-development skill**
- Triggers: "create a hook", "add a PreToolUse hook"  
- 1,651-word SKILL.md with 3 references/, 3 examples/, 3 scripts/
- Progressive disclosure with working utilities

**agent-development skill**
- Triggers: "create an agent", "agent frontmatter"  
- 1,438-word SKILL.md with system prompts and complete examples
- References include Claude Code's AI generation prompt

**goal-creation skill** (See `/goal` docs)
- Triggers: "create a goal", "set a /goal", "structure goals"
- 689-word SKILL.md with lean core concepts
- References for patterns and verification methods

## Content Organization (Progressive Disclosure)

| Where | What | Size |
|-------|------|------|
| **SKILL.md** | Core concepts, essential workflows, pointers to resources | 1,500-2,000 words |
| **references/** | Detailed patterns, edge cases, troubleshooting, advanced techniques | 2,000-5,000+ words each |
| **examples/** | Working code to copy or adapt | Variable |
| **scripts/** | Validation tools, testing helpers, automation | Executable |

## Validation Checklist

**Before finalizing:**

| Category | Check |
|----------|-------|
| **Structure** | SKILL.md has frontmatter with name + description; referenced files exist |
| **Trigger phrases** | Third-person; specific ("create X", "add Y"); not vague |
| **Content quality** | Imperative form; 1,500-2,000 words; details in references/ |
| **Progressive disclosure** | Core in SKILL.md; details in references/; code in examples/; tools in scripts/ |
| **Testing** | Skill triggers on expected queries; no duplication; references load |

## Common Mistakes

**❌ Weak triggers:** `"Provides guidance for hooks"` (vague)  
**✅ Strong triggers:** `"create a hook", "add a PreToolUse hook", "validate tool use"`

**❌ Too much in SKILL.md:** 8,000-word monolith loading everything  
**✅ Right approach:** 1,500-2,000 words in SKILL.md + detailed references/

**❌ Second person:** `You should create...`, `You need to configure...`  
**✅ Imperative:** `Create the hook...`, `Configure the server...`

**❌ Missing resource references:** SKILL.md with no pointers to references/ or examples/  
**✅ Clear pointers:** "See `references/patterns.md` for detailed patterns"

## Skill Complexity Templates

**Minimal** (simple knowledge only)
```
skill-name/
└── SKILL.md
```

**Standard** (recommended for most skills)
```
skill-name/
├── SKILL.md (1,500-2,000 words)
├── references/ (detailed content)
└── examples/ (working code)
```

**Complete** (complex domains with utilities)
```
skill-name/
├── SKILL.md
├── references/ (patterns, advanced, edge cases)
├── examples/ (multiple working examples)
└── scripts/ (validation, testing, automation)
```

## Best Practices Snapshot

**✅ DO:**
- Use third-person triggers ("This skill should be used when...")
- Include specific phrases ("create X", "add Y")
- Keep SKILL.md lean (1,500-2,000 words)
- Move details to references/
- Write imperative/infinitive form
- Point to bundled resources clearly
- Include working examples
- Study plugin-dev's skills as templates

**❌ DON'T:**
- Use vague triggers or second person
- Put everything in SKILL.md
- Include broken examples
- Leave resources unreferenced

## Reference Resources

**Study these plugin-dev skills:**
- `hook-development` — Progressive disclosure, utilities, and validation scripts
- `agent-development` — AI generation, system prompts, complete examples
- `goal-creation` — Lean core concepts, detailed references

For complete skill-creator methodology, see `references/skill-creator-original.md`
