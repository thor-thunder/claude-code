# Skill Structure and File Organization

## Directory Structure

Claude Code skills follow a standardized directory structure for consistency and progressive disclosure:

```
plugin-name/skills/skill-name/
├── SKILL.md                  # Required: Main skill definition
├── references/               # Optional: Detailed documentation
│   ├── patterns.md
│   ├── advanced.md
│   └── api-reference.md
├── scripts/                  # Optional: Utility scripts
│   ├── validate.sh
│   ├── setup.py
│   └── helper.js
├── examples/                 # Optional: Working code examples
│   ├── example1.sh
│   ├── example2.json
│   └── README.md
└── assets/                   # Optional: Resource files
    ├── template.html
    ├── icon.png
    └── config.json
```

## File Purposes

### SKILL.md (Required)

The main skill definition file containing:

**Frontmatter (YAML):**
```yaml
---
name: skill-name
description: This skill should be used when...
version: X.Y.Z
allowed-tools: Tool1, Tool2, Tool3
---
```

**Body (Markdown):**
- Overview of the skill's purpose
- When to use it
- Step-by-step procedures
- Links to references, scripts, and examples
- Best practices and considerations
- Common issues and solutions

**Guidelines:**
- Keep under 2,000 words
- Use imperative/infinitive form
- Reference supporting files clearly
- Include examples of expected usage

### references/ Directory (Optional)

Documentation files loaded on-demand when Claude determines they're helpful:

**Common files:**
- `patterns.md` - Design patterns and common approaches
- `advanced.md` - Advanced techniques and edge cases
- `api-reference.md` - API documentation and specifications
- `migration.md` - Version migration and upgrade guides
- `troubleshooting.md` - Known issues and solutions
- `domain-knowledge.md` - Domain-specific information

**Benefits:**
- Keeps SKILL.md lean
- Detailed content loaded only when needed
- Can each be large (2,000-5,000+ words)
- Topic-focused for easy navigation

### scripts/ Directory (Optional)

Executable utility scripts for automation and validation:

**Common types:**
- **Validation scripts** (`.sh`, `.py`) - Check configurations, validate syntax
- **Setup scripts** (`.sh`, `.ps1`) - Initialize environments, install dependencies
- **Helper scripts** (`.js`, `.py`) - Process data, transform formats
- **Automation scripts** (`.sh`, `.py`) - Perform repetitive tasks

**Requirements:**
- Must be executable: `chmod +x script.sh`
- Include proper shebang: `#!/bin/bash`, `#!/usr/bin/env python3`
- Well-commented for clarity
- Should work independently or with minimal context

**Example:**
```bash
#!/bin/bash
# Validates skill import structure
set -e

skill_dir="$1"
[[ -f "$skill_dir/SKILL.md" ]] || { echo "✗ SKILL.md not found"; exit 1; }
echo "✓ Skill structure valid"
```

### examples/ Directory (Optional)

Working code examples that users can copy and adapt:

**What to include:**
- Complete, runnable scripts
- Configuration file examples
- Template files with sample data
- Real-world usage scenarios
- Working solutions to common problems

**Naming convention:**
- `example-1-basic.sh` - Simple, introductory example
- `example-2-advanced.sh` - Complex, feature-complete example
- `example-config.json` - Sample configuration
- `README.md` - Guide to examples

**Guidelines:**
- Each example should be self-contained
- Include comments explaining key concepts
- Test examples before including
- Show realistic, practical usage

### assets/ Directory (Optional)

Resource files used in output, not loaded into context:

**Types of assets:**
- **Templates** (HTML, Markdown, JSON)
- **Images** (PNG, SVG, JPG)
- **Stylesheets** (CSS, SCSS)
- **Fonts** (TTF, WOFF)
- **Documents** (PDF, DOCX)
- **Boilerplate code** (starter templates)

**Usage:**
- Files are read from disk when needed
- Not loaded into Claude's context window
- Can be large without affecting performance
- Ideal for binary files and large templates

## File Naming Conventions

### SKILL.md
- Always `SKILL.md` (capitalized)
- Located in skill root directory
- One per skill

### References
- Lowercase with hyphens: `advanced-patterns.md`
- Descriptive names: `api-reference.md`, `migration-guide.md`
- Related files grouped together: `v1-to-v2.md`, `v2-to-v3.md`

### Scripts
- Lowercase with hyphens: `validate-schema.sh`
- Extension matches interpreter: `.sh`, `.py`, `.js`, `.ts`
- Executable bit set: `chmod +x`
- Descriptive purpose: `setup-environment.sh`, `run-tests.sh`

### Examples
- Numbered for progression: `example-1-basic.sh`, `example-2-advanced.sh`
- Include type in name: `example-config.json`, `example-template.html`
- Optional `README.md` describing all examples

### Assets
- Descriptive names: `logo.png`, `template.html`, `starter-template.zip`
- Organized in subdirectories if many: `assets/images/`, `assets/templates/`

## Frontmatter Metadata

### Required Fields

```yaml
name: skill-name
description: This skill should be used when the user asks to "specific phrase 1", "specific phrase 2". Include concrete scenarios.
```

### Optional Fields

```yaml
version: 0.1.0                    # Semantic versioning
allowed-tools: Read, Bash, Edit   # Tools this skill uses
tags: cli, automation, python     # Searchable tags
```

## Size Guidelines

| Component | Recommended Size | Absolute Maximum |
|-----------|------------------|------------------|
| SKILL.md body | 1,500-2,000 words | 3,000 words |
| Per reference file | 2,000-5,000 words | No limit |
| Per script | 100-300 lines | No limit |
| Per example | 50-200 lines | No limit |
| Total skill directory | Not limited | Not limited |

Keep SKILL.md lean by moving detailed content to references/.

## Progressive Disclosure in Action

### User asks about skill

**Step 1: Load metadata (~100 words)**
```yaml
name: import-skill-assets
description: This skill should be used when...
```
Claude sees: Skill name + brief trigger description

### Skill triggers

**Step 2: Load SKILL.md (~2,000 words)**
Claude reads: Full SKILL.md with core concepts and procedures

### User needs specific details

**Step 3: Load references/ on demand**
Claude reads: `references/advanced-patterns.md` for details
Claude reads: `references/troubleshooting.md` for solutions

### User wants code examples

**Step 4: Load examples/ or scripts/**
Claude reads: `examples/complete-example.sh` or `scripts/validate.sh`

This layered approach keeps cognitive load low while making information available.

## Import Considerations

When importing skills, verify:

- [ ] All directories have proper nesting
- [ ] SKILL.md has valid YAML frontmatter
- [ ] Referenced files in `references/`, `scripts/`, `examples/` exist
- [ ] Scripts have executable bit: `chmod +x`
- [ ] No absolute paths (use relative paths)
- [ ] Markdown formatting is valid
- [ ] File names follow conventions
- [ ] No duplicate files across directories
- [ ] Version number is appropriate
- [ ] Allowed-tools list matches skill content

## Common Patterns

### Minimal Skill
```
skill-name/
└── SKILL.md
```
Simple knowledge with no complex resources.

### Standard Skill (Recommended)
```
skill-name/
├── SKILL.md
├── references/
│   └── detailed-guide.md
└── examples/
    └── working-example.sh
```
Most skills: documentation + examples.

### Complex Skill
```
skill-name/
├── SKILL.md
├── references/
│   ├── patterns.md
│   ├── advanced.md
│   └── api-reference.md
├── scripts/
│   ├── validate.sh
│   └── setup.sh
├── examples/
│   ├── example-1.sh
│   └── example-2.sh
└── assets/
    └── template.html
```
Comprehensive resources: docs + utilities + templates.

## Best Practices

✅ **DO:**
- Keep SKILL.md focused and lean
- Use consistent naming conventions
- Make scripts executable
- Include working examples
- Reference supporting files clearly
- Use relative paths
- Validate structure after importing
- Document changes in commits

❌ **DON'T:**
- Put everything in SKILL.md
- Use absolute paths in files
- Include broken examples
- Skip validation steps
- Mix file types in directories
- Use inconsistent naming
- Create unnecessary subdirectories
