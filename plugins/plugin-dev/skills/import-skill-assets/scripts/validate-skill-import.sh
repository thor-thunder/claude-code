#!/bin/bash
# Validates skill import structure and contents
# Usage: ./validate-skill-import.sh /path/to/skill

set -e

SKILL_PATH="${1:-.}"
ERRORS=0
WARNINGS=0

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
error() {
    echo -e "${RED}✗ $1${NC}"
    ((ERRORS++))
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    ((WARNINGS++))
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

echo "Validating skill import: $SKILL_PATH"
echo "---"

# Check if directory exists
if [ ! -d "$SKILL_PATH" ]; then
    error "Directory not found: $SKILL_PATH"
    exit 1
fi

# Check SKILL.md exists
if [ ! -f "$SKILL_PATH/SKILL.md" ]; then
    error "SKILL.md not found in $SKILL_PATH"
    exit 1
fi
success "SKILL.md found"

# Validate SKILL.md frontmatter
echo ""
echo "Checking frontmatter..."

if ! head -1 "$SKILL_PATH/SKILL.md" | grep -q "^---$"; then
    error "SKILL.md missing frontmatter start marker (---)"
fi

if ! grep -q "^name:" "$SKILL_PATH/SKILL.md"; then
    error "SKILL.md missing 'name' field"
else
    name=$(grep "^name:" "$SKILL_PATH/SKILL.md" | head -1 | cut -d' ' -f2-)
    success "Found name: $name"
fi

if ! grep -q "^description:" "$SKILL_PATH/SKILL.md"; then
    error "SKILL.md missing 'description' field"
else
    success "Found description field"
fi

# Check for version field
if grep -q "^version:" "$SKILL_PATH/SKILL.md"; then
    version=$(grep "^version:" "$SKILL_PATH/SKILL.md" | head -1 | cut -d' ' -f2-)
    success "Version: $version"
else
    warning "No version field in SKILL.md"
fi

# Check for allowed-tools field
if grep -q "^allowed-tools:" "$SKILL_PATH/SKILL.md"; then
    tools=$(grep "^allowed-tools:" "$SKILL_PATH/SKILL.md" | head -1 | cut -d' ' -f2-)
    success "Allowed tools: $tools"
fi

# Validate markdown body
echo ""
echo "Checking markdown content..."

# Check for markdown heading after frontmatter
if ! tail -n +3 "$SKILL_PATH/SKILL.md" | grep -q "^# "; then
    warning "No top-level heading (# ) found in SKILL.md"
fi

# Check for referenced files in SKILL.md
echo ""
echo "Checking referenced files..."

# Find all references/ mentions
if grep -q "references/" "$SKILL_PATH/SKILL.md"; then
    while IFS= read -r line; do
        # Extract file paths from markdown references
        if [[ $line =~ references/[^\`]*\.md ]]; then
            file=$(echo "$line" | grep -o "references/[^\`]*\.md" | head -1)
            if [ -f "$SKILL_PATH/$file" ]; then
                success "Reference file found: $file"
            else
                error "Reference file not found: $file"
            fi
        fi
    done < "$SKILL_PATH/SKILL.md"
else
    warning "No references/ mentioned in SKILL.md"
fi

# Find all scripts/ mentions (skip glob patterns like *.sh)
if grep -q "scripts/" "$SKILL_PATH/SKILL.md"; then
    while IFS= read -r line; do
        # Skip lines with glob patterns
        if [[ $line =~ scripts/\*\. ]]; then
            continue
        fi
        if [[ $line =~ scripts/[^\`\*].*\.[a-z]+ ]]; then
            file=$(echo "$line" | grep -o "scripts/[^\`\*]*\.[a-z]*" | head -1)
            if [ -n "$file" ] && [ -f "$SKILL_PATH/$file" ]; then
                success "Script file found: $file"
                if [ -x "$SKILL_PATH/$file" ]; then
                    success "  (executable)"
                else
                    warning "  (not executable - run: chmod +x $file)"
                fi
            fi
        fi
    done < "$SKILL_PATH/SKILL.md"
fi

# Find all examples/ mentions (skip comments like "if it exists")
if grep -q "examples/" "$SKILL_PATH/SKILL.md"; then
    while IFS= read -r line; do
        # Skip lines with comments or conditions
        if [[ $line =~ 'if it exists' ]] || [[ $line =~ 'optional' ]]; then
            continue
        fi
        if [[ $line =~ examples/[^\`\*]+ ]]; then
            file=$(echo "$line" | grep -o "examples/[^\`]*" | head -1 | sed 's/[` ]*$//')
            if [ -n "$file" ] && ([ -f "$SKILL_PATH/$file" ] || [ -d "$SKILL_PATH/$file" ]); then
                success "Example file found: $file"
            fi
        fi
    done < "$SKILL_PATH/SKILL.md"
fi

# Check directory structure
echo ""
echo "Checking directory structure..."

if [ -d "$SKILL_PATH/references" ]; then
    ref_count=$(find "$SKILL_PATH/references" -type f | wc -l)
    success "references/ directory with $ref_count file(s)"
else
    warning "references/ directory not found"
fi

if [ -d "$SKILL_PATH/scripts" ]; then
    script_count=$(find "$SKILL_PATH/scripts" -type f | wc -l)
    success "scripts/ directory with $script_count file(s)"

    # Check script executability
    while IFS= read -r file; do
        if [ ! -x "$file" ]; then
            warning "Script not executable: $file (run: chmod +x)"
        fi
    done < <(find "$SKILL_PATH/scripts" -type f -name "*.sh" -o -name "*.py")
else
    warning "scripts/ directory not found"
fi

if [ -d "$SKILL_PATH/examples" ]; then
    example_count=$(find "$SKILL_PATH/examples" -type f | wc -l)
    success "examples/ directory with $example_count file(s)"
else
    warning "examples/ directory not found"
fi

if [ -d "$SKILL_PATH/assets" ]; then
    asset_count=$(find "$SKILL_PATH/assets" -type f | wc -l)
    success "assets/ directory with $asset_count file(s)"
fi

# Check for absolute paths
echo ""
echo "Checking for absolute paths..."

if grep -r "^/" "$SKILL_PATH" --include="*.md" --include="*.sh" --include="*.py" 2>/dev/null | grep -v "^Binary" > /dev/null; then
    warning "Absolute paths found in files (prefer relative paths)"
    grep -r "^/" "$SKILL_PATH" --include="*.md" --include="*.sh" --include="*.py" 2>/dev/null | head -5
fi

# Summary
echo ""
echo "---"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}Validation complete: No errors${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
    fi
    exit 0
else
    echo -e "${RED}Validation failed: $ERRORS error(s)${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}Also found: $WARNINGS warning(s)${NC}"
    fi
    exit 1
fi
