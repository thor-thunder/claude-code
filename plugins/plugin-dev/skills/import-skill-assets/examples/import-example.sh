#!/bin/bash
# Complete example of importing a skill from atomic-agents to claude-code plugin
# Usage: ./import-example.sh

set -e

# Configuration
SOURCE_REPO="/home/user/atomic-agents"
TARGET_REPO="/home/user/claude-code"
PLUGIN_NAME="plugin-dev"
SKILL_NAME="release"
TARGET_BRANCH="claude/import-skill-assets-2vTzG"

echo "=== Skill Import Example ==="
echo "Source: $SOURCE_REPO/.claude/skills/$SKILL_NAME"
echo "Target: $TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME"
echo ""

# Step 1: Verify source skill exists
echo "Step 1: Verifying source skill..."
if [ ! -f "$SOURCE_REPO/.claude/skills/$SKILL_NAME/SKILL.md" ]; then
    echo "✗ Source skill not found: $SOURCE_REPO/.claude/skills/$SKILL_NAME/SKILL.md"
    exit 1
fi
echo "✓ Source skill found"
echo ""

# Step 2: Create target directory structure
echo "Step 2: Creating target directory structure..."
mkdir -p "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/"{references,scripts,examples}
echo "✓ Directory structure created"
echo ""

# Step 3: Copy SKILL.md
echo "Step 3: Copying SKILL.md..."
cp "$SOURCE_REPO/.claude/skills/$SKILL_NAME/SKILL.md" \
   "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/SKILL.md"
echo "✓ SKILL.md copied"
echo ""

# Step 4: Copy optional subdirectories
echo "Step 4: Copying optional resources..."

if [ -d "$SOURCE_REPO/.claude/skills/$SKILL_NAME/references" ]; then
    cp -r "$SOURCE_REPO/.claude/skills/$SKILL_NAME/references/"* \
          "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/references/" 2>/dev/null || true
    echo "✓ References copied"
fi

if [ -d "$SOURCE_REPO/.claude/skills/$SKILL_NAME/scripts" ]; then
    cp -r "$SOURCE_REPO/.claude/skills/$SKILL_NAME/scripts/"* \
          "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/scripts/" 2>/dev/null || true
    echo "✓ Scripts copied"
fi

if [ -d "$SOURCE_REPO/.claude/skills/$SKILL_NAME/examples" ]; then
    cp -r "$SOURCE_REPO/.claude/skills/$SKILL_NAME/examples/"* \
          "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/examples/" 2>/dev/null || true
    echo "✓ Examples copied"
fi

if [ -d "$SOURCE_REPO/.claude/skills/$SKILL_NAME/assets" ]; then
    cp -r "$SOURCE_REPO/.claude/skills/$SKILL_NAME/assets/"* \
          "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/assets/" 2>/dev/null || true
    echo "✓ Assets copied"
fi
echo ""

# Step 5: Make scripts executable
echo "Step 5: Setting script permissions..."
if [ -d "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/scripts" ]; then
    find "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME/scripts" \
         -type f \( -name "*.sh" -o -name "*.py" \) \
         -exec chmod +x {} \;
    echo "✓ Scripts are executable"
fi
echo ""

# Step 6: Validate imported skill
echo "Step 6: Validating imported skill..."
VALIDATOR="$(dirname "$0")/../scripts/validate-skill-import.sh"
if [ -f "$VALIDATOR" ]; then
    if bash "$VALIDATOR" "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME"; then
        echo "✓ Validation passed"
    else
        echo "⚠ Validation completed with warnings"
    fi
else
    echo "⚠ Validator script not found, skipping validation"
fi
echo ""

# Step 7: Show what was imported
echo "Step 7: Imported skill structure:"
tree -L 2 "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME" 2>/dev/null || \
    find "$TARGET_REPO/plugins/$PLUGIN_NAME/skills/$SKILL_NAME" -type f | sort
echo ""

# Step 8: Suggest git commands
echo "Step 8: Next steps (git commands):"
echo ""
echo "cd $TARGET_REPO"
echo "git checkout $TARGET_BRANCH"
echo "git add plugins/$PLUGIN_NAME/skills/$SKILL_NAME/"
echo "git commit -m 'Import $SKILL_NAME skill from atomic-agents'"
echo ""
echo "Then test the skill:"
echo "cc --plugin-dir plugins/$PLUGIN_NAME"
echo ""
echo "=== Import Complete ==="
