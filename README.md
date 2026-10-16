# Antigravity CLI + Orca: Two-Tier Multi-Agent Orchestration Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Antigravity](https://img.shields.io/badge/Google%20Antigravity-CLI%20Ready-4285F4)](https://antigravity.google)
[![Orca](https://img.shields.io/badge/Orca-Orchestration-orange)](https://orca.dev)
[![Biome](https://img.shields.io/badge/Biome-Auto--Healing-60A5FA)](https://biomejs.dev)
[![ast-grep](https://img.shields.io/badge/ast--grep-Precision%20AST-F59E0B)](https://ast-grep.github.io)
[![agent-browser](https://img.shields.io/badge/Vercel-agent--browser-black)](https://agent-browser.dev)

A production-grade, high-throughput multi-agent development architecture for **[Google Antigravity CLI (`agy`)](https://antigravity.google)** and **[Orca](https://orca.dev)**.

This setup establishes a structured two-tier orchestration hierarchy: it decouples top-level task intake and dispatch from project-level architecture, enforces **mandatory subagent delegation**, provides **Universal Tool Availability** (`ast-grep`, `biome`, `agent-browser`, `ripgrep`), prevents test loops with **Zero-Redundancy Verification Rules**, and slashes token consumption by pairing **Ponytail** (anti-overengineering) with **Caveman** (ultra-compressed communication).

---

## Architecture Overview

```
                      +------------------------------------------+
                      |                 TIER 1                   |
                      |   Floating Terminal / Global Dispatcher  |
                      |          (Orca Lead Coordinator)         |
                      +--------------------+---------------------+
                                           |
                        orca orchestration dispatch --inject
                                           |
                                           v
                      +------------------------------------------+
                      |                 TIER 2                   |
                      |     Worktree Lead Project Orchestrator   |
                      |           (Antigravity CLI Lead)         |
                      +----+-----------+-----------+-----------+-+
                           |           |           |           |
             invoke_subagent           |           |           invoke_subagent
                           v           v           v           v
            +----------------+   +-----------+   +---------------+   +----------------+
            | worker-gemini  |   |  tester   |   | code-reviewer |   | browser-tester |
            | (Deep Logic &  |   | (Isolated |   | (Read-Only    |   | (Vercel Agent- |
            |  Architecture) |   |   Tests)  |   |  Defect Audit)|   |    Browser)    |
            +----------------+   +-----------+   +---------------+   +----------------+
```

### 1. Tier 1: Floating Terminal (Global Task Intake & Dispatcher)
- **Role**: Coordinates across repositories with total system visibility.
- **Instant Delegation Policy**: The floating terminal coordinator **never** modifies code directly. It immediately dispatches tasks to target project worktrees using Orca.
- **Asynchronous Handoff**: Spawns isolated terminals (`orca terminal create --worktree "path:<worktree_path>" --command "agy --effort high"`), dispatches tasks with lifecycle hooks, and returns control to the user immediately.

### 2. Tier 2: Project Orchestrator (Lead Architect in Worktree)
- **Role**: The technical architect and lead project manager inside each target worktree.
- **Mandatory Subagent Delegation**: The orchestrator **never** performs line-by-line edits or runs test suites directly. The orchestrator:
  1. Deconstructs the specification into modular units of work.
  2. Spawns specialized subagents via `invoke_subagent` / `define_subagent`.
  3. Enforces Zero-Redundancy verification rules.
  4. Returns `worker_done` back to the Tier 1 Orca Orchestrator once verified.

---

## Specialized Subagent Squad

Every subagent is pre-configured with dedicated model parameters, reasoning efforts, and behavioral contracts:

| Subagent | Role | Default Model | Reasoning Effort | Best For |
| :--- | :--- | :--- | :--- | :--- |
| **`worker-gemini`** | Senior Implementer | `Gemini 3.8 Flash` | **High** | Deep logic, architecture, complex refactors, edge-case analysis |
| **`tester`** | Test Engineer | `Gemini 3.7 Flash` | **Medium** | Isolated unit, regression, and component test verification |
| **`code-reviewer`** | Senior Auditor | `Gemini 3.8 Flash` | **Medium** | Read-only diff inspection, defect detection by severity |
| **`researcher`** | Codebase Explorer | `Gemini 3.7 Flash` | **Medium** | Symbol tracing, caller mapping, and official documentation lookups |
| **`browser-tester`** | Browser QA Specialist | `Gemini 3.8 Flash` | **Medium** | Vercel `agent-browser` automation, screenshots, a11y, vitals |

---

## Universal Tool Availability & Shared Access Protocol

Every agent has full, unrestricted access to the complete CLI engineering suite:

- **`ast-grep` (`sg`)**: AST syntax-tree searching, structural code pattern matching, function/class relationship tracing, and multi-file precision refactoring.
- **`biome`**: Ultra-fast formatting and syntax/import/type auto-healing (`biome check --write <path>`).
- **`agent-browser`**: Headless/headed Chrome automation, accessibility-tree snapshots (`agent-browser snapshot -i`), screenshot proof, Web Vitals, and DOM verification.
- **`rg` (ripgrep) & `fd`**: Lightning-fast symbol searching, regex scanning, and filesystem traversal.
- **`orca` CLI**: Worktree terminal creation and asynchronous task coordination.
- **`caveman` & `ponytail` Skills**: Token-compressed output (`caveman`) and anti-overengineering software simplicity (`ponytail`).
- **`caveman-commit` & `git`**: Conventional Commits and clean git staging.

---

## Zero-Redundancy Verification Rules

1. **Never Double-Test:** Either the orchestrator verifies, or the worker verifies — **never both**. If a subagent returns test evidence, accept it and stop immediately.
2. **No Pre-Flight Reruns:** If an error trace is provided in context, do not rerun tests to "reproduce" it. Proceed directly to diagnosis and fixing.
3. **Isolated Test Execution Only:** Run **only the single affected test file** (`pytest tests/test_foo.py` or `npm test -- path/to/test.ts`), **never** the full test suite.
4. **Reuse Past Evidence:** Never rerun a successful test or lint command solely for a newer timestamp.

---

## Safety & Execution Guardrails (Deny Matrix)

The following commands are strictly prohibited across all agents and sessions:
- Destructive deletions: `rm -rf`, `rm -r`, `rmdir` (Use safe, explicit file removal instead).
- Destructive git actions: `git reset --hard`, `git clean -f`, `git push --force`, `git push -f`.
- Low-level disk formatting: `mkfs`, `dd if=`, `format`.
- Uncontrolled fork bombs: `:(){ :|:& };:`.

---

## Quickstart & Installation

### Windows (PowerShell)

```powershell
git clone https://github.com/ItsAtharva9928/antigravity-orca-orchestration.git
cd antigravity-orca-orchestration
.\install.ps1
```

### Linux & macOS (Bash)

```bash
git clone https://github.com/ItsAtharva9928/antigravity-orca-orchestration.git
cd antigravity-orca-orchestration
chmod +x install.sh
./install.sh
```

### Verification

Check that the plugin is detected and active:

```bash
agy plugin list
```

You should see:
```text
Installed plugins:
- multi-agent-orchestrator (enabled, 1.0.0)
    Components: 7 skills, 1 rule
```

---

## License

MIT (c) 2026 Antigravity Multi-Agent Orchestration Contributors.
