---
name: Goal Creation
description: This skill should be used when the user asks to "create a goal", "set a /goal", "write a goal", "structure a goal", "define goals", "goal with boundaries", "multi-phase goal", or wants to use the /goal command effectively with clear finish lines and verification methods.
version: 0.1.0
---

# Goal Creation for Claude Code

## Purpose

The `/goal` command in Claude Code provides a structured way to define tasks with clear success criteria. A well-crafted goal keeps work focused and verifiable by breaking down ambiguous requests into concrete, measurable outcomes.

This skill helps create effective goals that guide Claude's work until completion, with automatic verification and clear boundaries.

## What Makes a Good Goal

Every effective goal has three key elements:

### 1. A Clear Finish Line
Define what "done" looks like in concrete, verifiable terms. Not an aspiration or direction, but a specific, testable outcome.

**Example finish lines:**
- "the signup form works on mobile and desktop"
- "Lighthouse score is above 90"
- "the endpoint returns valid JSON with user data"

**Avoid vague finish lines:**
- ❌ "make the site better" (Claude can't judge "better")
- ❌ "improve performance" (undefined improvement level)
- ❌ "refactor the code" (no measurable endpoint)

### 2. A Way to Verify
Specify how to check whether the finish line is reached. The verification method should be something Claude can evaluate independently.

**Example verification methods:**
- "test it loads on mobile and desktop"
- "run Lighthouse and check the score"
- "run the test suite"
- "verify the response with curl"

**Why it matters:**
Verification prevents ambiguity about whether work is complete. Without it, Claude might ask "are we done yet?" repeatedly.

### 3. Boundaries
Define what should stay untouched. Boundaries prevent scope creep and clarify what's out of scope.

**Example boundaries:**
- "don't modify the homepage design"
- "don't change existing database schema"
- "don't update dependencies beyond patch versions"

**When boundaries need phases:**
Complex goals often require multiple phases to properly define boundaries. Use separate phases when:
- Different types of work have different scope limits
- Boundaries shift after the first phase completes
- Safety or verification methods differ between phases

**Example multi-phase goal:**
```
/goal [Phase 1: build form] until [form submits without errors], 
verified by [running test suite], while [don't modify CSS], 
or stop after [30 turns]

/goal [Phase 2: add validation] until [form validates all inputs], 
verified by [manual testing all edge cases], while [keep form layout unchanged], 
or stop after [20 turns]
```

## Goal Template

Use this template to structure effective goals:

```
/goal [task] until [finish line], verified by [check], 
while [boundaries], or stop after [limit]
```

### Template Parameters

- **`[task]`** - The work to do (short, action-oriented)
- **`[finish line]`** - Concrete, measurable success criteria
- **`[check]`** - How to verify the finish line is reached
- **`[boundaries]`** - What to avoid or leave unchanged
- **`[limit]`** - Stop after N turns (prevents infinite loops)

### Examples of Effective Goals

✅ **Good: Clear and verifiable**
```
/goal build the contact form, until the form validates email and submits to /api/contact, 
verified by testing it on mobile and desktop, while don't modify the homepage design, 
or stop after 15 turns
```

✅ **Good: Multi-phase with boundaries**
```
/goal [Phase 1: fetch data] until the API returns user data with timestamps, 
verified by logging the response and checking for all required fields, 
while don't modify the database schema, or stop after 10 turns
```

✅ **Good: Performance-focused**
```
/goal optimize the homepage, until Lighthouse score is above 90, 
verified by running Lighthouse and reporting the final score, 
while don't change the existing layout or DOM structure, 
or stop after 20 turns
```

### Examples to Avoid

❌ **Vague finish line**
```
/goal make the site better
```
Claude can't judge what "better" means.

❌ **No verification method**
```
/goal refactor the code until it's cleaner, verified by Claude's judgment
```
Claude can't verify its own judgment reliably.

❌ **No boundaries**
```
/goal build a dashboard, until it shows all metrics
```
Without boundaries, the scope might expand infinitely.

## Using Goals in Practice

### Starting a Goal
Use `/goal` to define what done looks like before Claude starts working:

```
/goal [task description] until [specific success criteria], verified by [how to check]
```

### Checking Progress
Use `/goal` (without arguments) to check the current goal status:

```
/goal
```

Claude will show the current goal, progress made, and next steps.

### Resuming After Interruption
Use `--resume` to continue a goal after stopping:

```
--resume
```

This keeps Claude focused on the same finish line without redefining the goal.

### Clearing a Goal
Use `/goal clear` to stop the current goal:

```
/goal clear
```

Use this when the goal is complete, needs redefinition, or circumstances change.

## Multi-Phase Goals

For complex work, split into multiple phases when:

1. **Different verification methods needed** - Phase 1 might verify with unit tests, Phase 2 with integration tests
2. **Scope boundaries shift** - Phase 1 avoids the database, Phase 2 builds the database integration
3. **Safety changes** - Phase 1 is exploratory (can modify anything), Phase 2 is conservative (specific boundaries)
4. **Progressive disclosure** - Complete Phase 1 fully before defining Phase 2

**Structure multi-phase work:**
```
/goal [Phase 1: foundation] until [X works], verified by [test Y], while [boundary Z]

[After Phase 1 completes]

/goal [Phase 2: enhancement] until [A works], verified by [test B], while [boundary C]
```

## Additional Resources

### Examples

Working goal examples in `examples/`:
- **`examples/form-validation.goal`** - Frontend form with testing
- **`examples/api-integration.goal`** - Backend integration with verification
- **`examples/multi-phase.goal`** - Complex goal split across phases

### Reference Materials

For deeper understanding:
- **`references/goal-patterns.md`** - Common patterns and anti-patterns
- **`references/verification-methods.md`** - How to write effective verification checks

## Common Patterns

### Verification Pattern: Testing
Use test suites as your verification method:
```
/goal add user authentication, until login works with valid credentials, 
verified by running the test suite and all auth tests pass
```

### Verification Pattern: Manual Testing
Use manual checks for UI/UX work:
```
/goal fix mobile responsive layout, until the layout looks correct on phones, 
verified by testing on mobile browser and checking all elements align properly
```

### Verification Pattern: API Response
Use API responses as verification:
```
/goal fetch user data from API, until the endpoint returns user id and email, 
verified by calling the endpoint and confirming response structure
```

### Boundary Pattern: Don't Touch Design
Prevent unwanted design changes:
```
/goal add dark mode support, until dark mode works on all pages, 
verified by testing with dark mode enabled, while don't modify colors or spacing
```

### Boundary Pattern: Schema Locked
Prevent database changes:
```
/goal optimize queries, until query response time < 100ms, 
verified by performance testing, while don't modify the database schema
```

## Best Practices

✅ **Do:**
- Make finish lines measurable and testable
- Include specific verification methods (not "seems good")
- Add boundaries to prevent scope creep
- Use realistic turn limits (5-30 turns depending on complexity)
- Define one clear outcome per goal
- Split multi-phase work explicitly

❌ **Don't:**
- Set vague finish lines ("make it better", "clean code")
- Skip verification methods or use subjective judgment
- Forget boundaries (leads to scope creep)
- Make goals too large (50+ turns needed)
- Mix multiple unrelated outcomes in one goal
- Leave boundaries ambiguous
