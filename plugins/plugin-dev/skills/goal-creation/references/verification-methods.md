# Verification Methods: How to Check Goal Completion

Effective goals require verification methods that Claude can execute independently. This document covers common verification approaches and when to use each.

## Categories of Verification

### 1. Automated Testing

**Use when:** Code functionality can be tested programmatically.

**Methods:**
- Unit tests
- Integration tests
- End-to-end tests
- Test suite runs

**Examples:**

```
/goal implement password reset, until users can reset password via email, 
verified by running the auth test suite and password reset tests pass
```

```
/goal add user authentication, until login works with valid/invalid credentials, 
verified by running the authentication test suite and all tests pass
```

**Advantages:**
- Deterministic (same result each time)
- No human judgment needed
- Can be run repeatedly
- Builds regression prevention

**Limitations:**
- Requires tests to exist or be written
- May not catch all edge cases
- UI/UX issues might pass tests

**Best for:**
- Backend APIs
- Logic validation
- Database operations
- Library functionality

---

### 2. Performance Measurement

**Use when:** The goal involves metrics like speed, resource usage, or scalability.

**Methods:**
- Benchmark tools
- Load testing
- Profiling output
- Response time measurement
- Memory usage monitoring
- Bundle size analysis

**Examples:**

```
/goal optimize database queries, until query response time < 50ms, 
verified by running performance benchmarks and confirming average query time
```

```
/goal reduce bundle size, until bundle is under 100KB, 
verified by running webpack bundle analyzer and checking final size
```

```
/goal improve Lighthouse score, until score is above 90, 
verified by running Lighthouse and reporting final scores
```

**Advantages:**
- Objective and measurable
- Tools provide exact metrics
- Clear pass/fail threshold
- Prevents performance regression

**Limitations:**
- Requires appropriate tools
- Some environments affect results
- May need baseline for comparison

**Best for:**
- Performance goals
- Optimization work
- Scalability verification
- Resource efficiency

---

### 3. Manual Testing (UI/UX/Visual)

**Use when:** The goal involves user-facing features, visual design, or interaction patterns.

**Methods:**
- Testing in browser
- Testing on devices
- Visual regression checks
- User interaction flows
- Responsive design testing
- Accessibility checks

**Examples:**

```
/goal fix mobile responsive layout, until layout looks correct on phones, 
verified by testing on mobile browser and confirming all sections are properly aligned
```

```
/goal implement dark mode, until dark mode works on all pages, 
verified by enabling dark mode and visually checking all pages render correctly
```

```
/goal improve form validation UX, until validation errors display clearly, 
verified by testing form submission with invalid data and confirming error messages appear
```

**Advantages:**
- Catches visual and interaction issues
- Tests real user experience
- Flexible for subjective improvements
- No test code needed

**Limitations:**
- Subjective interpretation possible
- Harder to document "correct" appearance
- May vary by device/browser
- Requires manual execution

**Best for:**
- UI/UX improvements
- Visual design changes
- Interaction flows
- Responsive design
- Accessibility

**Making manual verification more specific:**

Instead of:
```
verified by testing and confirming it looks good
```

Use:
```
verified by testing on iPhone, iPad, and desktop browser, 
confirming all navigation items are visible and tap targets are at least 44px
```

---

### 4. API Response Validation

**Use when:** The goal involves building or integrating APIs.

**Methods:**
- HTTP requests (curl, Postman, etc.)
- Response structure validation
- Status code verification
- JSON schema validation
- Data consistency checks

**Examples:**

```
/goal build user API endpoint, until endpoint returns user data, 
verified by calling endpoint with curl and confirming response includes id, name, and email
```

```
/goal integrate payment API, until payment processing works, 
verified by making test payment and confirming successful response and transaction record
```

```
/goal add pagination to user list, until pagination works correctly, 
verified by requesting different pages and confirming correct records and page metadata returned
```

**Advantages:**
- Objective and deterministic
- Easy to run repeatedly
- Documents expected response format
- Can be automated

**Limitations:**
- Requires API to be accessible
- Network issues might affect verification
- Needs example requests/responses

**Best for:**
- REST APIs
- GraphQL endpoints
- Third-party integrations
- Webhook implementations

---

### 5. Data Integrity Checks

**Use when:** The goal involves data storage, transformation, or consistency.

**Methods:**
- Database queries
- Data validation checks
- Record count verification
- Data consistency validation
- Migration verification

**Examples:**

```
/goal migrate user data to new schema, until all user records migrated, 
verified by querying database and confirming record count matches original count
```

```
/goal implement user deletion cascade, until deleting user removes all related records, 
verified by deleting test user and confirming no orphaned records remain
```

```
/goal add data validation, until invalid data is rejected, 
verified by attempting to insert invalid records and confirming they are rejected
```

**Advantages:**
- Objective and measurable
- Prevents data loss
- Catches consistency issues
- Deterministic

**Limitations:**
- Requires database access
- May need test data setup
- Complex checks might need custom scripts

**Best for:**
- Database operations
- Data migrations
- Schema changes
- Data validation

---

### 6. Code Search and Structure Validation

**Use when:** The goal involves code organization, refactoring, or pattern adoption.

**Methods:**
- Grep/code search
- File structure verification
- Import/export validation
- Pattern matching
- Static analysis

**Examples:**

```
/goal refactor to repository pattern, until all database queries use repository, 
verified by grep search confirming zero direct database calls outside repository folder
```

```
/goal extract config to environment variables, until all secrets use env vars, 
verified by searching codebase and confirming no hardcoded secrets remain
```

```
/goal add TypeScript types, until all functions have type annotations, 
verified by running tsc --noEmit with strict mode
```

**Advantages:**
- Deterministic and reproducible
- Prevents regression
- Documents required changes
- No runtime environment needed

**Limitations:**
- Requires clear structure/pattern
- May need custom grep patterns
- Complex patterns hard to verify

**Best for:**
- Code refactoring
- Pattern adoption
- Configuration changes
- File organization

---

### 7. Linting and Type Checking

**Use when:** The goal involves code quality, types, or style conformance.

**Methods:**
- ESLint results
- TypeScript compiler output
- Prettier formatting
- Static analysis tools
- Type checking

**Examples:**

```
/goal fix TypeScript type errors, until no type errors remain, 
verified by running tsc --noEmit with no output
```

```
/goal enforce consistent code style, until all files pass linting, 
verified by running eslint and confirming no warnings or errors
```

```
/goal add missing TypeScript annotations, until codebase has no implicit any, 
verified by running eslint with no-implicit-any rule enabled
```

**Advantages:**
- Objective and automated
- Deterministic
- Catches many issues
- Industry standard

**Limitations:**
- Requires tool setup
- May have false positives
- Doesn't verify functionality

**Best for:**
- Code quality goals
- Type safety
- Style consistency
- Linting compliance

---

### 8. Documentation and Completeness

**Use when:** The goal involves documentation, comments, or completeness.

**Methods:**
- File existence checks
- Content validation
- Documentation generation
- Coverage reports
- README verification

**Examples:**

```
/goal document API endpoints, until all endpoints have documentation, 
verified by checking API docs exist for all endpoints and include example requests/responses
```

```
/goal add JSDoc comments, until all exported functions have documentation, 
verified by running documentation generator and confirming all exports are documented
```

**Advantages:**
- Clear completion criteria
- Prevents incomplete documentation
- Provides reference material

**Limitations:**
- Documentation quality subjective
- Needs specific format requirements
- Hard to verify usefulness

**Best for:**
- Documentation additions
- API documentation
- Code comment requirements
- README maintenance

---

## Choosing the Right Verification Method

| Goal Type | Best Verification Method | Example |
|-----------|-------------------------|---------|
| New Feature | Test Suite | "run feature tests pass" |
| Bug Fix | Test Suite + Manual | "test reproduces and passes" |
| Performance | Measurement/Benchmark | "Lighthouse score > 90" |
| UI/UX | Manual Testing | "test on mobile and desktop" |
| API | HTTP Requests | "curl endpoint and verify response" |
| Refactoring | Code Search | "grep confirms pattern adopted" |
| Database | Database Queries | "query confirms all records migrated" |
| Type Safety | Type Checker | "tsc --noEmit passes" |
| Code Quality | Linting | "eslint reports no errors" |
| Documentation | File Verification | "all files have README" |

---

## Combining Verification Methods

Complex goals often need multiple verification methods. Combine them with "and":

```
/goal add user authentication, until login works end-to-end, 
verified by running auth tests pass AND manually testing login with test account 
AND confirming user session is created in database
```

```
/goal optimize API performance, until response time improves, 
verified by running benchmarks showing < 100ms average AND running load test with 100 concurrent requests
```

---

## Making Verification Specific and Actionable

### ❌ Too vague:
```
verified by testing thoroughly
```

### ✅ Specific:
```
verified by running the complete user flow (signup → login → profile view → logout) 
on Chrome and Safari, checking that all pages load in under 2 seconds
```

---

### ❌ Unclear:
```
verified by confirming it works
```

### ✅ Clear:
```
verified by making API calls to /api/users endpoint and confirming responses 
include all required fields (id, name, email) with correct data types
```

---

## Anti-Patterns in Verification

### ❌ Subjective Verification

**Bad:**
```
verified by Claude's judgment that tests pass
```

**Good:**
```
verified by running npm test with all tests passing
```

---

### ❌ Unverifiable Claims

**Bad:**
```
verified by knowing the code is good
```

**Good:**
```
verified by running eslint and confirming zero warnings, plus running type checker with no errors
```

---

### ❌ Circular Verification

**Bad:**
```
verified by confirming the goal is complete
```

**Good:**
```
verified by querying database and confirming all 50 user records migrated successfully
```

---

## When to Add Verification Phases

Some goals benefit from multiple verification phases:

```
/goal Phase 1: Build API, until endpoint responds to requests, 
verified by calling endpoint and receiving 200 status code

/goal Phase 2: Add validation, until invalid requests are rejected, 
verified by sending invalid data and confirming 400 status code with error message

/goal Phase 3: Add authentication, until only authenticated users can access, 
verified by calling endpoint without token (401) and with valid token (200)
```

This approach:
- Breaks verification into testable chunks
- Each phase has clear, achievable verification
- Prevents one complex verification step
