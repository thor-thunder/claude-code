# Goal Patterns and Anti-Patterns

## Common Effective Patterns

### Pattern 1: Bounded Feature Implementation

**When to use:** Adding a single, well-defined feature with clear acceptance criteria.

**Structure:**
```
/goal [implement feature], until [specific feature works end-to-end], 
verified by [test method], while [don't change existing features or design]
```

**Example:**
```
/goal implement password reset feature, until users can reset password via email link, 
verified by testing the complete flow (request reset, receive email, click link, set new password), 
while don't modify the login page UI, or stop after 25 turns
```

**Why effective:**
- Clear what needs to be built
- Verification includes full flow, not just technical implementation
- Boundaries prevent affecting other features
- Realistic turn limit for feature work

---

### Pattern 2: Performance Optimization with Metrics

**When to use:** Improving performance or efficiency where measurable metrics exist.

**Structure:**
```
/goal optimize [component/system], until [metric target achieved], 
verified by [benchmark/profiling tool], while [maintain current functionality]
```

**Example:**
```
/goal optimize database queries, until average query response time < 50ms, 
verified by running query benchmarks and comparing before/after metrics, 
while don't modify the database schema or API responses, or stop after 20 turns
```

**Why effective:**
- Metrics provide clear, objective finish line
- Verification method is built-in (measurement)
- Boundaries prevent shortcuts that break functionality
- Turn limit allows for iterative optimization

---

### Pattern 3: Bug Fix with Regression Prevention

**When to use:** Fixing a bug while ensuring it doesn't happen again.

**Structure:**
```
/goal fix [bug description], until [bug no longer occurs and test prevents regression], 
verified by [reproducing original issue is now fixed and test passes], 
while [don't modify unrelated code]
```

**Example:**
```
/goal fix user session timeout bug, until sessions persist correctly and don't timeout prematurely, 
verified by creating a test that reproduces the original issue and confirming it now passes, 
while don't modify authentication flow or session configuration, or stop after 15 turns
```

**Why effective:**
- Emphasizes both fix and prevention
- Test creation is part of the finish line
- Boundaries prevent over-engineering
- Verification includes regression testing

---

### Pattern 4: API Integration in Phases

**When to use:** Complex integrations that benefit from phased implementation.

**Phase 1:**
```
/goal [implement API endpoint], until [endpoint accepts requests and returns valid responses], 
verified by [testing with curl/HTTP client], while [use mock data for now], 
or stop after 10 turns
```

**Phase 2:**
```
/goal [connect API to database], until [endpoint returns actual data from database], 
verified by [database queries return expected records and endpoint reflects changes], 
while [don't modify endpoint contract], or stop after 15 turns
```

**Why effective:**
- Separates concerns (endpoint structure vs. data integration)
- Phased boundaries are clearer than one large goal
- Each phase has distinct verification
- Prevents one large, complex goal

---

### Pattern 5: UI/UX Refinement with Manual Verification

**When to use:** Visual or interaction improvements where automated testing is insufficient.

**Structure:**
```
/goal improve [UI component], until [specific UX improvement achieved], 
verified by [manual testing on target devices/browsers], while [don't break existing functionality]
```

**Example:**
```
/goal improve mobile navigation responsiveness, until navigation menu opens/closes smoothly on mobile devices, 
verified by testing on actual mobile devices (iPhone, Android) and checking touch responsiveness, 
while don't change the menu items or navigation structure, or stop after 12 turns
```

**Why effective:**
- Recognizes that some improvements require manual verification
- Specifies target devices for testing
- Boundaries prevent unrelated changes
- Realistic for UX work

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Vague Finish Line

**Example:**
```
/goal refactor the codebase until it's better organized
```

**Why this fails:**
- "Better organized" is subjective
- Claude can't judge what "better" means
- Goal never reaches completion (always room for more improvement)
- Each iteration might interpret "better" differently

**Fix:**
```
/goal extract database logic into repository pattern, 
until all database queries use the repository interface, 
verified by searching codebase and confirming no direct database queries outside repository, 
while don't modify database schema, or stop after 20 turns
```

---

### ❌ Anti-Pattern 2: No Verification Method

**Example:**
```
/goal implement caching, until performance is improved, verified by Claude's judgment
```

**Why this fails:**
- "Claude's judgment" is vague and subjective
- No measurable way to verify completion
- Claude might disagree with itself about when work is done
- Leads to repetitive "are we done yet?" cycles

**Fix:**
```
/goal implement caching for user endpoint, until response time < 100ms, 
verified by load testing with 100 concurrent requests and checking average response time, 
while don't modify endpoint contract, or stop after 15 turns
```

---

### ❌ Anti-Pattern 3: Missing Boundaries (Scope Creep)

**Example:**
```
/goal build user dashboard, until all metrics are displayed
```

**Why this fails:**
- "All metrics" is undefined
- Scope can expand infinitely as new metrics are discovered
- No boundaries prevent architectural changes
- Could lead to 100+ turn goals

**Fix:**
```
/goal build user dashboard showing profile, activity, and settings, 
until dashboard displays user name, recent activities (last 10), and preference toggles, 
verified by loading dashboard and confirming all three sections display correctly, 
while don't modify the existing header/footer layout or authentication system, 
or stop after 20 turns
```

---

### ❌ Anti-Pattern 4: Multiple Unrelated Outcomes

**Example:**
```
/goal fix authentication and add dark mode, 
until both features work
```

**Why this fails:**
- Mixing unrelated features in one goal is confusing
- Boundaries for one feature might conflict with the other
- Verification becomes complex
- Harder to track progress on either feature

**Fix (two separate goals):**

Goal 1:
```
/goal fix authentication login flow, until users can log in with email and password, 
verified by testing login with test account, while don't modify account creation flow, 
or stop after 15 turns
```

Goal 2:
```
/goal implement dark mode toggle, until users can enable/disable dark mode, 
verified by toggling dark mode and confirming all pages switch themes correctly, 
while don't modify light mode styling, or stop after 12 turns
```

---

### ❌ Anti-Pattern 5: Unrealistic Turn Limits

**Example (too low):**
```
/goal build REST API for users, until all endpoints work, or stop after 3 turns
```

**Why this fails:**
- 3 turns is unrealistic for API work
- Goal will abort mid-implementation
- Frustrating and stops progress unnecessarily

**Example (too high):**
```
/goal refactor codebase, until it's well-structured, or stop after 200 turns
```

**Why this fails:**
- 200 turns allows unlimited work
- No pressure to focus
- Defeats purpose of the goal system

**Realistic turn limits:**
- Simple fixes: 5-10 turns
- Feature implementation: 15-25 turns
- Performance optimization: 15-20 turns
- Complex integration: 25-30 turns
- Never exceed 50 turns (reconsider goal structure)

---

### ❌ Anti-Pattern 6: Subjective Success Criteria

**Example:**
```
/goal write clean code, until the code is well-written, 
verified by code review
```

**Why this fails:**
- "Clean" and "well-written" are subjective
- Code review has no objective criteria
- Multiple people might disagree
- Leads to endless revisions

**Fix:**
```
/goal refactor database access patterns, until all queries use the repository pattern, 
verified by grep search confirming zero direct database calls outside repository, 
while maintain existing API contracts, or stop after 20 turns
```

---

## Pattern Decision Tree

Use this to choose the right pattern for your goal:

1. **Is this a new feature?**
   - Yes → Use "Bounded Feature Implementation" pattern
   - No → Continue to 2

2. **Is this about performance or metrics?**
   - Yes → Use "Performance Optimization with Metrics" pattern
   - No → Continue to 3

3. **Is this fixing a bug?**
   - Yes → Use "Bug Fix with Regression Prevention" pattern
   - No → Continue to 4

4. **Does this require multiple phases?**
   - Yes → Use "API Integration in Phases" or split into multiple goals
   - No → Continue to 5

5. **Does this involve UI/UX changes?**
   - Yes → Use "UI/UX Refinement with Manual Verification" pattern
   - No → Create custom goal with clear finish line, verification, and boundaries

---

## Checklist for Effective Goals

Before setting a goal, verify:

**Finish Line:**
- [ ] Is it measurable? (not "better", "cleaner", "improved")
- [ ] Can Claude verify it reached the finish line?
- [ ] Does it define a specific, concrete outcome?
- [ ] Could someone else understand exactly what success looks like?

**Verification:**
- [ ] Is the verification method concrete and testable?
- [ ] Does it avoid subjective judgment?
- [ ] Can Claude perform the verification independently?
- [ ] Is it deterministic (same result each time)?

**Boundaries:**
- [ ] Are there specific things that should NOT be changed?
- [ ] Would removing a boundary create problems?
- [ ] Are boundaries clear enough to follow consistently?
- [ ] Does each boundary protect something important?

**Scope:**
- [ ] Is this one cohesive outcome or multiple?
- [ ] Is the turn limit realistic?
- [ ] Have unrelated work been split into separate goals?
- [ ] Can the goal be completed in the turn limit?

**Clarity:**
- [ ] Is the goal understandable at a glance?
- [ ] Would someone else interpret it the same way?
- [ ] Are ambiguities resolved with specific examples?
