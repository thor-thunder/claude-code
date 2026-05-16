---
name: import-skill-assets
description: This skill should be used when the user asks to "import a skill", "copy skill assets", "migrate skill from atomic-agents", "import skill files", or needs to set up skills from external repositories into Claude Code plugins.
version: 0.1.0
---

# Importing Skill Assets for Claude Code Plugins

## Overview

Importing skill assets involves copying skill definitions, references, scripts, and examples from source repositories (like atomic-agents) into Claude Code plugin skill directories. This skill guides the process of properly importing and structuring skills following Claude Code's skill-development standards.

## When to Use This Skill

Import skills when:
- Migrating skills from atomic-agents to Claude Code plugins
- Copying reusable skill patterns between plugins
- Adding reference implementations to plugin skills
- Setting up skill dependencies or shared assets
- Consolidating multiple skills from different sources

## Skill Import Process

### Step 1: Identify Source Skills

Determine which skills to import from the source repository:

```bash
# List available skills in atomic-agents
ls -la /path/to/atomic-agents/.claude/skills/

# For each skill, check its structure
ls -la /path/to/atomic-agents/.claude/skills/{skill-name}/
```

Key files to look for:
- `SKILL.md` - The main skill definition
- `references/` - Documentation and reference materials
- `scripts/` - Executable utilities
- `examples/` - Working code examples
- `assets/` - Resource files (templates, icons, etc.)

### Step 2: Verify Target Location

Ensure target plugin has proper directory structure:

```bash
# Plugin skills should be in: plugin-name/skills/{skill-name}/
mkdir -p /path/to/plugin/skills/import-skill-assets/{references,scripts}
```

### Step 3: Copy Skill Files

Copy skill definition and bundled resources:

```bash
# Copy SKILL.md
cp /path/from/atomic-agents/.claude/skills/{skill-name}/SKILL.md \
   /path/to/plugin/skills/{skill-name}/SKILL.md

# Copy references/ if it exists
if [ -d /path/from/source/skills/{skill-name}/references ]; then
  cp -r /path/from/source/skills/{skill-name}/references/* \
        /path/to/plugin/skills/{skill-name}/references/
fi

# Copy scripts/ if it exists
if [ -d /path/from/source/skills/{skill-name}/scripts ]; then
  cp -r /path/from/source/skills/{skill-name}/scripts/* \
        /path/to/plugin/skills/{skill-name}/scripts/
fi

# Copy examples/ if it exists
if [ -d /path/from/source/skills/{skill-name}/examples ]; then
  cp -r /path/from/source/skills/{skill-name}/examples/* \
        /path/to/plugin/skills/{skill-name}/examples/
fi

# Copy assets/ if it exists
if [ -d /path/from/source/skills/{skill-name}/assets ]; then
  cp -r /path/from/source/skills/{skill-name}/assets/* \
        /path/to/plugin/skills/{skill-name}/assets/
fi
```

### Step 4: Update Frontmatter if Needed

Edit `SKILL.md` frontmatter if the imported skill needs adjustments for the new context:

```yaml
---
name: skill-name
description: Updated description for new context
version: X.Y.Z
---
```

Key adjustments:
- **name**: Keep consistent with source unless renaming
- **description**: Update trigger phrases if context differs
- **version**: Increment if making modifications
- **allowed-tools**: Add/remove tools as needed for plugin

### Step 5: Validate File Structure

Ensure all referenced files exist and paths are correct:

```bash
# Verify SKILL.md exists and is valid
test -f /path/to/plugin/skills/{skill-name}/SKILL.md && echo "✓ SKILL.md found"

# Check that all referenced resources exist
grep -o 'references/[^`]*' /path/to/plugin/skills/{skill-name}/SKILL.md | sort -u
grep -o 'scripts/[^`]*' /path/to/plugin/skills/{skill-name}/SKILL.md | sort -u
grep -o 'examples/[^`]*' /path/to/plugin/skills/{skill-name}/SKILL.md | sort -u
```

### Step 6: Validate Script Executability

Ensure scripts are executable and have proper permissions:

```bash
# Make scripts executable
chmod +x /path/to/plugin/skills/{skill-name}/scripts/*.sh
chmod +x /path/to/plugin/skills/{skill-name}/scripts/*.py

# Verify shebangs are correct
head -1 /path/to/plugin/skills/{skill-name}/scripts/*
```

### Step 7: Test the Imported Skill

Test that the imported skill works correctly:

```bash
# Install or point to the plugin
cc --plugin-dir /path/to/plugin

# Ask a query that should trigger the imported skill
# Example: "help me with [skill-name]"

# Verify:
# - Skill loads correctly
# - SKILL.md content displays
# - References load when accessed
# - Scripts execute if called
# - Examples are complete
```

### Step 8: Commit and Document

Create a commit documenting the import:

```bash
git add plugins/plugin-dev/skills/{skill-name}/
git commit -m "Import {skill-name} skill from atomic-agents

- Copy SKILL.md with references and scripts
- Update trigger descriptions for plugin context
- Validate all referenced files exist
- Test skill loading and functionality"
```

## Key Considerations

### File Organization

Maintain proper structure for all imported resources:

```
plugin-name/skills/{skill-name}/
├── SKILL.md              # Always required
├── references/           # Optional: documentation
│   ├── patterns.md
│   └── advanced.md
├── scripts/             # Optional: utilities
│   └── validate.sh
├── examples/            # Optional: working code
│   └── example.sh
└── assets/              # Optional: output resources
    └── template.html
```

### Updating Trigger Descriptions

When importing to a new context, update the description's trigger phrases:

**From atomic-agents source:**
```yaml
description: Release a new version of atomic-agents to PyPI and GitHub. Use when the user asks to "release", "publish", "deploy".
```

**Imported to plugin context:**
```yaml
description: This skill should be used when the user asks to "import a skill", "copy skill assets", "migrate skill from atomic-agents".
```

### Preserving Version History

When importing established skills:
- Keep original version number if making no changes
- Increment patch version if fixing paths
- Increment minor version if adapting content significantly
- Document changes in commit message

### Handling Path Dependencies

Update any hardcoded paths in imported files:

```bash
# Search for absolute paths that may need updating
grep -r "/path/to" /path/to/plugin/skills/{skill-name}/

# Update relative paths if scripts reference other locations
sed -i 's|/old/path|./relative/path|g' /path/to/plugin/skills/{skill-name}/*
```

## Common Issues and Solutions

### Issue: Referenced files don't exist

**Problem:** SKILL.md references `references/skill-structure.md` but file wasn't copied

**Solution:**
1. Verify source file exists: `ls -la /source/skills/{skill}/references/`
2. Copy missing files: `cp /source/skills/{skill}/references/* /target/skills/{skill}/references/`
3. Or update SKILL.md to remove references to missing files

### Issue: Scripts fail with permission errors

**Problem:** Scripts copied but not executable

**Solution:**
```bash
chmod +x /path/to/plugin/skills/{skill-name}/scripts/*.sh
chmod +x /path/to/plugin/skills/{skill-name}/scripts/*.py
```

### Issue: Skill doesn't trigger in Claude Code

**Problem:** Imported skill not showing up in available skills

**Solution:**
1. Verify directory structure: `ls -la /plugin/skills/{skill-name}/SKILL.md`
2. Check SKILL.md has valid frontmatter with `name` and `description`
3. Ensure plugin is properly installed: `cc --plugin-dir /path/to/plugin`
4. Test with explicit trigger: ask about the skill by name

### Issue: References fail to load

**Problem:** SKILL.md references files that can't be found

**Solution:**
1. Check for typos in file references
2. Verify files exist with correct case: `ls -la references/`
3. Update SKILL.md paths to match actual file locations
4. Avoid spaces in filenames

## Progressive Disclosure for Imported Skills

When importing complex skills, maintain progressive disclosure:

1. **SKILL.md (always loaded)** - Core concepts and workflow
2. **references/ (on demand)** - Detailed documentation
3. **scripts/ (on demand)** - Utility code
4. **examples/ (on demand)** - Working code samples

Keep SKILL.md focused (1,500-2,000 words) and move detailed content to references/.

## Validation Checklist

Before considering an import complete:

- [ ] All directories created: `SKILL.md`, `references/`, `scripts/`, `examples/`
- [ ] `SKILL.md` copied and frontmatter updated if needed
- [ ] All referenced files copied and verified
- [ ] Paths updated if absolute paths present
- [ ] Scripts made executable: `chmod +x scripts/<script-name>.sh`
- [ ] Description trigger phrases updated for context
- [ ] All referenced files exist and accessible
- [ ] Skill tests and loads correctly in plugin
- [ ] No duplicate files or orphaned directories
- [ ] Changes committed with descriptive message

## Additional Resources

For more information on skill structure and development, see:
- **`references/skill-structure.md`** - Detailed skill directory structure
- **`scripts/validate-skill-import.sh`** - Automated validation script
- **`examples/import-example.sh`** - Complete import example
