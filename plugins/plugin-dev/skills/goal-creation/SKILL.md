---
name: Goal Creation
description: This skill should be used when the user asks to "create a goal", "set a /goal", "write a goal", "structure a goal", "define goals", "goal with boundaries", "multi-phase goal", or wants to use the /goal command with clear finish lines and verification.
version: 0.1.0
---

# Goal Creation for Claude Code

The `/goal` command structures work with measurable success criteria. Effective goals keep Claude focused and verifiable by translating ambiguous requests into concrete, testable outcomes.

## Three Elements of Every Good Goal

**1. A Clear Finish Line**
Define "done" in concrete, testable terms—not aspirational, but specific and measurable.
- ✅ "the form validates email and submits to /api/contact"
- ❌ "make the form better"

**2. A Way to Verify**
Specify how to check completion. Verification must be independent and deterministic.
- ✅ "run the test suite and confirm all tests pass"
- ❌ "verify it looks good"

**3. Boundaries**
Clarify what stays untouched. Boundaries prevent scope creep.
- ✅ "don't modify the homepage design"
- ❌ "keep things reasonable"

## Goal Template

```
/goal [task] until [finish line], verified by [check], 
while [boundaries], or stop after [limit]
```

**Parameters:**
- `[task]` — Short, action-oriented work description
- `[finish line]` — Concrete, measurable success criteria  
- `[check]` — How to verify the finish line is reached
- `[boundaries]` — What to avoid or leave unchanged
- `[limit]` — Stop after N turns (prevents infinite loops)

## Examples

**Good: Frontend feature with clear verification**
```
/goal build contact form, until form validates email and submits to /api/contact, 
verified by testing on mobile and desktop, while don't modify homepage design, 
or stop after 15 turns
```

**Good: Performance with measurable target**
```
/goal optimize homepage, until Lighthouse score is above 90, 
verified by running Lighthouse and reporting final score, 
while don't change existing layout, or stop after 20 turns
```

**Anti-pattern: Vague finish line and verification**
```
/goal make the site better, verified by Claude's judgment
```
Can't judge "better" subjectively.

## Using /goal in Practice

**Start a goal:** Define success criteria upfront
```
/goal [task description] until [specific success criteria], verified by [how to check]
```

**Check progress:** See current goal status and next steps
```
/goal
```

**Resume after stopping:** Continue the same goal
```
--resume
```

**Clear a goal:** Stop and reset
```
/goal clear
```

## Multi-Phase Goals

Split into separate phases when work is too large or has different scopes:

```
/goal [Phase 1: API endpoints] until endpoints return correct data, 
verified by curl requests, while use test environment, or stop after 20 turns

/goal [Phase 2: UI integration] until UI displays API data, 
verified by manual testing, while don't modify API, or stop after 18 turns
```

Use multi-phase when:
- Verification methods differ between stages
- Boundaries shift after phase completion
- Work can be independently tested
- Single goal would exceed 30 turns

## Common Patterns

**Testing verification:**
```
verified by running the test suite and confirming all tests pass
```

**Manual verification (UI/UX):**
```
verified by testing on mobile and desktop browsers
```

**API verification:**
```
verified by calling the endpoint and confirming response structure
```

**Performance verification:**
```
verified by running benchmarks and confirming < 100ms response time
```

**Code structure verification:**
```
verified by grep search confirming all queries use repository pattern
```

## Best Practices

✅ **Do:**
- Make finish lines measurable and testable
- Use specific verification methods
- Add clear boundaries to prevent scope creep
- Use realistic turn limits (5-30 depending on complexity)
- Split multi-phase work explicitly

❌ **Don't:**
- Use vague finish lines ("better", "cleaner", "improved")
- Skip verification or rely on subjective judgment
- Forget boundaries (causes scope creep)
- Make goals too large (30+ turns signals a split is needed)
- Mix unrelated outcomes in one goal

## Additional Resources

**Working examples** in `examples/`:
- `examples/form-validation.goal` — Frontend forms with testing
- `examples/api-integration.goal` — API integration with verification
- `examples/multi-phase.goal` — Complex work split into phases

**Reference guides** in `references/`:
- `references/goal-patterns.md` — Detailed patterns and anti-patterns with decision trees
- `references/verification-methods.md` — 8 verification approaches (testing, performance, manual, API, data, code search, linting, docs)

Consult references for deeper patterns, edge cases, and advanced goal structures.
