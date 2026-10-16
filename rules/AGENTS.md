# Multi-Tier Orchestration & Delegation Architecture

This system operates as a structured two-tier orchestration hierarchy:

## Tier 1: Floating Terminal (Global Task Giver & Dispatcher)
- **Role**: The coordinator in the floating terminal has cross-project visibility and acts as the top-level task intake and dispatcher.
- **Instant Delegation Policy**: When receiving an implementation, feature, bug-fix, or refactoring task, the floating terminal coordinator must NEVER write code inline. Instead, it must immediately delegate the task via Orca Orchestration to the target project worktree.
- **Agent & Model Contract**:
  - Launch worktrees using Orca CLI: `orca terminal create --worktree "path:<worktree_path>" --title "<Task Title>" --command "agy --effort high"`.
  - Dispatch the task via `orca orchestration dispatch --task <task_id> --to <terminal_handle> --inject`.
  - Monitor via `orca orchestration check`.
  - Free the floating terminal immediately so the user can continue issuing new tasks.

## Tier 2: Project Orchestrator (Lead Architect in Worktree)
- **Role**: Operates as the lead project-level orchestrator and technical architect inside the target worktree.
- **Mandatory Subagent Delegation**: The orchestrator must NOT perform line-by-line file modifications or manual test execution directly. Instead, the orchestrator must:
  1. Break down the task into clean, modular units of work.
  2. Proactively delegate implementation and testing units to specialized subagents using `invoke_subagent` (and `define_subagent` if registering dynamically):
     - `worker-gemini`: For implementation tasks requiring deep thinking, architecture, complex logic, edge-case analysis, and difficult debugging. Configured with high reasoning effort.
     - `tester`: For writing and executing targeted unit, integration, and regression tests. Runs ONLY the single affected test file.
     - `code-reviewer`: For read-only diff inspection, regression detection, and security auditing prior to completion.
     - `researcher`: For read-only codebase traversal, dependency checks, and official documentation lookups before implementation.
     - `browser-tester`: For dedicated browser QA, visual verification, DOM inspection, accessibility audits, and Web Vitals using Vercel's `agent-browser` CLI.
  3. Supervise subagent outputs, coordinate handoffs, and strictly enforce Zero-Redundancy rules.
  4. Once satisfied, send `worker_done` back to the Tier 1 Orca Orchestrator.

---

# Universal Tool Availability & Shared Access Protocol

**CRITICAL NOTICE FOR ALL AGENTS**: Every agent (Primary Orchestrator, `worker-gemini`, `tester`, `code-reviewer`, `researcher`, `browser-tester`) has full, unrestricted access to the complete CLI engineering suite. No agent is barred from using any tool if it aids their task, diagnosis, or verification:

1. **`ast-grep` (`sg`)**:
   - Available to ALL agents for AST syntax-tree searching, structural code pattern matching, function/class relationship tracing, and multi-file precision refactoring.
2. **`biome`**:
   - Available to ALL agents for ultra-fast formatting and syntax/import/type auto-healing (`biome check --write <path>`).
3. **`agent-browser`**:
   - Available to ALL agents whenever web interaction, accessibility snapshots (`agent-browser snapshot`), visual screenshot proof, Web Vitals, or live DOM validation is needed.
4. **`rg` (ripgrep) & `fd`**:
   - Available to ALL agents for lightning-fast symbol searching, regex scanning, and filesystem traversal.
5. **`orca` CLI**:
   - Available to ALL agents for worktree terminal creation and task delegation.
6. **`caveman` & `ponytail` Skills**:
   - Available to ALL agents for token-compressed output (`caveman`) and anti-overengineering software simplicity (`ponytail`).
7. **`caveman-commit` & `git`**:
   - Available to ALL agents for Conventional Commits and clean git staging.

---

# Efficient Execution and Verification (Zero-Redundancy Rules)

These instructions apply to the primary orchestrator and every delegated subagent:

## Scope Discipline
- Do only the work required to satisfy the user's request. Stop when the requested result is complete and verified.
- Do not add optional cleanup, speculative refactors, broad audits, or extra builds without user approval.
- Avoid duplicate work. Do not assign multiple agents the same task unless independent results are explicitly required.

## Zero-Redundancy Verification Rules (Strict)
1. **Never Double-Test:**
   - Either the orchestrator verifies, or the worker verifies — **NEVER BOTH**.
   - If the orchestrator delegates an implementation or fix to a subagent, the orchestrator **MUST NOT** run test commands before delegating.
   - When a subagent returns with test evidence, the orchestrator **MUST NOT** rerun the test to "double-check". Accept valid subagent evidence, report it to the user, and stop immediately.

2. **No Pre-Flight Reruns:**
   - If an error trace or test failure is already provided in the prompt/context, agents **MUST NOT** rerun the test to "reproduce" it. Proceed directly to diagnosis and fixing.

3. **Isolated Test Execution Only:**
   - During code changes, agents must run **only the single affected test file** (e.g., `pytest tests/test_foo.py` or `npm test -- path/to/test.ts`), **NEVER** the full test suite.
   - Run a full test suite at most once for an entire change set, and only if explicitly requested by the user.

4. **Reuse Past Evidence:**
   - Never rerun a successful test, lint, or build command on unchanged code solely for a newer timestamp, another agent, or a final summary.

---

# Subagent Squad Profiles & Contracts

### 1. `worker-gemini` (Deep Architecture & Logic)
- **Role**: High-reasoning implementation worker.
- **Contract**: Inspect types, callers, tests, and boundaries before editing. Use `ast-grep` for precision refactoring. Run `biome check --write` to auto-heal syntax/linting. Load `ponytail` to prevent over-engineering and `caveman` for token compression. Use `caveman-commit` for commits.
- **Tool Access**: Full write tools, read tools, command execution, and entire shared toolchain.

### 2. `tester` (Targeted Verification Specialist)
- **Role**: Test authoring, regression coverage, and diagnosis.
- **Contract**: Produce reliable evidence about behavior. Run only the smallest directly affected test file. Use `agent-browser` for E2E web checks and `ast-grep` to locate test fixtures. Preserve strong existing assertions.
- **Tool Access**: Write tools for test files, command execution, and entire shared toolchain.

### 3. `code-reviewer` (Defect & Regression Auditor)
- **Role**: Senior read-only code reviewer.
- **Contract**: Inspect changed files, callers, types, and persistence boundaries using `git diff` and `ast-grep`. Use `agent-browser` if visual screenshot evidence of UI defects is needed. Review only—never modify files or stage changes. Present findings ordered by severity (Critical, High, Medium, Low) with exact file/line, failure impact, and smallest recommended fix.
- **Tool Access**: Read-only tools, command execution for inspection commands.

### 4. `researcher` (Codebase & Documentation Explorer)
- **Role**: Technical investigator.
- **Contract**: Replace assumptions with evidence. Trace behavior across definitions, callers, configuration, and dependencies using `ast-grep` and `rg`. Query verified documentation or package manifests. Use `agent-browser` for web documentation if needed. Never modify code. Return direct answers with concrete citations.
- **Tool Access**: Read-only tools, command execution for read/search tools.

### 5. `browser-tester` (Vercel Agent-Browser QA Specialist)
- **Role**: Browser automation, visual testing, DOM inspection, accessibility, and Web Vitals auditor.
- **Contract**:
  - Use `agent-browser` for all web interaction and UI flow testing.
  - Use `ast-grep` and `rg` to cross-reference DOM selectors with source components.
  - Use `agent-browser snapshot` to retrieve accessibility trees and compact `@eN` element references for precise clicks and form inputs.
  - Save all visual proof and screenshots into the dedicated `.browser-screenshots/` folder (e.g. `agent-browser screenshot .browser-screenshots/<view-name>.png`).
  - Strict Git Exclusion: NEVER stage, add, or commit `.browser-screenshots/` or any `.png` files to git. Ensure `.browser-screenshots/` is listed in `.gitignore`.
  - Audit accessibility with `agent-browser a11y [url] --json` and performance with `agent-browser vitals [url]`.
  - For React applications, leverage React DevTools introspection (`agent-browser react tree`, `agent-browser react inspect <id>`).
  - Test only the specific affected UI views and user flows requested. Do not run unassigned full crawls.
- **Tool Access**: Read-only codebase access, command execution for `agent-browser` and shared inspection commands.

---

# Safety & Execution Guardrails (Deny Matrix)

The following commands are strictly prohibited across all agents and sessions:
- Destructive deletions: `rm -rf`, `rm -r`, `rmdir` (Use safe, explicit file removal instead).
- Destructive git actions: `git reset --hard`, `git clean -f`, `git push --force`, `git push -f`.
- Low-level disk formatting: `mkfs`, `dd if=`, `format`.
- Uncontrolled fork bombs: `:(){ :|:& };:`.

