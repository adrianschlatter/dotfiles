# MAINTENANCE REVIEW PROCEDURE

## Goal

Evaluate a software repository for maintainability, extendability,
composability, understandability, and overall engineering quality, then produce
prioritized issues and recommendations for follow-up work.


## Scope and Output

- **Scope:** source code, architecture boundaries, dependency graph, tests,
  docs, CI/CD quality gates, contribution process, and operational artifacts.
- **Output:** prioritized findings with evidence, impact, effort estimate, and
  recommended improvements.


## Maintenance Review Topics (highest to lowest priority)

### 1) Code Structure, Modularity, and Architectural Boundaries

**Why it matters**

Clear boundaries and modular design reduce change risk and speed up feature
delivery.

**Questions to ask**

- Are responsibilities separated cleanly (domain, orchestration, I/O, UI/API)?
- Are modules cohesive and loosely coupled, or do they rely on hidden
  cross-dependencies?
- Are dependency directions consistent with the intended architecture?

**Tools to use**

- Static architecture/dependency tools (`pydeps`, `import-linter`, `deptry`,
  Graphviz)
- IDE/LSP symbol and call hierarchy tools
- Code map and package structure visualization

**Tests to run**

- Architectural constraint checks (layering/import rules)
- Change-impact smoke tests across module boundaries
- Mutation or contract tests for critical interfaces

**Documentation to review**

- Architecture decision records (ADRs)
- High-level component diagrams
- Module ownership and boundary definitions


### 2) Readability, Naming, and Local Understandability

**Why it matters**

Readable code lowers onboarding time and defect rates.

**Questions to ask**

- Are names expressive and consistent across modules?
- Are functions/classes small enough to understand without deep context
  switching?
- Is control flow straightforward, or dominated by nesting, flags, and side
  effects?

**Tools to use**

- Linters/style tools (`ruff`, `flake8`, `pylint`)
- Complexity analyzers (`radon`, Sonar rules)
- Review bots highlighting readability and duplication concerns

**Tests to run**

- Static quality gate checks (complexity, duplication thresholds)
- Dead code checks and unreachable path checks
- Focused refactor-regression tests for high-complexity areas

**Documentation to review**

- Style guide and coding conventions
- Naming guidelines
- Review checklist for readability and clarity


### 3) Testing Strategy, Coverage Quality, and Reliability

**Why it matters**

Sustainable maintenance depends on fast, trustworthy feedback.

**Questions to ask**

- Do tests validate behavior, edge cases, and failure modes, not just happy
  paths?
- Is test coverage meaningful in critical code, including integration
  boundaries?
- Are tests deterministic, fast, and isolated from external flakiness?

**Tools to use**

- Test runners and coverage tools (`pytest`, `coverage.py`, `pytest-cov`)
- Flakiness detectors and retry analytics
- Mutation testing (`mutmut`, `cosmic-ray`) where feasible

**Tests to run**

- Unit, integration, and contract test suites
- Regression tests for recently fixed defects
- Parallel and repeated runs to detect flaky tests

**Documentation to review**

- Test strategy and quality gate policy
- Definition of done and release criteria
- Historical defect postmortems linked to missing tests


### 4) Documentation Quality and Knowledge Accessibility

**Why it matters**

Good documentation preserves context and reduces institutional bottlenecks.

**Questions to ask**

- Can a new contributor understand purpose, setup, architecture, and workflows
  quickly?
- Are docs synchronized with current code and commands?
- Are rationale and tradeoffs documented (not only usage snippets)?

**Tools to use**

- Markdown/doc linters (`markdownlint`, Vale)
- Link checkers (`lychee`, `markdown-link-check`)
- Docs build tooling and spell-checkers

**Tests to run**

- Documentation build checks in CI
- Link integrity and example-command verification
- Onboarding dry run using docs only

**Documentation to review**

- README, CONTRIBUTING, architecture docs
- API/CLI reference docs and runbooks
- Change logs and migration guides


### 5) API/Interface Design and Composability

**Why it matters**

Stable, composable interfaces enable reuse and safer extension.

**Questions to ask**

- Are interfaces minimal, explicit, and backward-compatible where required?
- Can components be combined without fragile ordering or hidden state?
- Are extension points clear (plugins, hooks, adapters, strategy objects)?

**Tools to use**

- Public API diff tools
- Type/interface checkers (`mypy`, `pyright`)
- Contract/schema validators (OpenAPI/JSON Schema tools)

**Tests to run**

- Backward-compatibility tests for public APIs
- Consumer-driven contract tests
- Composition tests chaining real workflows end to end

**Documentation to review**

- Public API policy and versioning policy
- Extension/plugin design docs
- Integration examples and compatibility notes


### 6) Dependency Hygiene and Upgradeability

**Why it matters**

Manageable dependencies reduce maintenance drag and upgrade risk.

**Questions to ask**

- Are dependency versions pinned/ranged intentionally and reviewed regularly?
- Are obsolete, duplicate, or unused dependencies present?
- Is upgrade work predictable with lockfiles and changelog tracking?

**Tools to use**

- Dependency analyzers (`pipdeptree`, `deptry`, `poetry show --tree`)
- Update bots (Dependabot/Renovate)
- License and compatibility scanners

**Tests to run**

- Clean-environment install tests
- Incremental dependency bump tests
- Full test suite against updated dependency sets

**Documentation to review**

- Dependency management policy
- Upgrade cadence and support window policy
- Compatibility matrix and deprecation notices


### 7) Error Handling, Observability, and Operability

**Why it matters**

Maintainability includes diagnosing and recovering from failures quickly.

**Questions to ask**

- Are errors handled consistently with actionable messages?
- Do logs and metrics expose enough context to debug production issues?
- Are operational procedures clear for incidents and rollback?

**Tools to use**

- Log quality analyzers and tracing tools
- Runtime dashboards/APM (Prometheus, Grafana, OpenTelemetry)
- CLI smoke scripts and health checks

**Tests to run**

- Failure-path tests (timeouts, partial failures, invalid inputs)
- Alert and runbook drill tests
- Recoverability tests (restart, retry, rollback)

**Documentation to review**

- Logging/monitoring standards
- Incident response and troubleshooting guides
- Operational runbooks and SLO/SLA definitions


### 8) Build, CI, and Automation Quality Gates

**Why it matters**

Consistent automation keeps quality standards enforceable over time.

**Questions to ask**

- Are linting, typing, tests, and packaging checks mandatory in CI?
- Are pipelines reproducible, fast enough, and well scoped to changes?
- Do gates prevent low-quality or breaking changes from merging?

**Tools to use**

- CI pipeline analyzers and workflow linters
- Caching/profiling tools for pipeline performance
- Pre-commit framework and hook tooling

**Tests to run**

- Full CI simulation for PR and mainline paths
- Build/package reproducibility checks
- Quality gate failure-mode tests (intentionally failing lint/tests)

**Documentation to review**

- CI workflow definitions
- Branch protection and merge policies
- Build/release process documentation


### 9) Contribution Workflow and Collaboration Practices

**Why it matters**

Good contribution practices increase throughput and reduce regression risk.

**Questions to ask**

- Is the contribution path clear for new and experienced contributors?
- Are code review expectations explicit (scope, testing, docs, backward
  compatibility)?
- Are ownership, triage, and prioritization processes defined?

**Tools to use**

- Repo governance checks (labels, templates, CODEOWNERS)
- PR analytics (cycle time, rework rate)
- Issue triage dashboards

**Tests to run**

- Dry-run of first contribution from clean clone
- Template compliance checks for PRs/issues
- Review checklist conformance spot checks

**Documentation to review**

- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `CODEOWNERS`
- PR/issue templates
- Maintainer handbook and triage policy


### 10) Technical Debt, Refactoring Readiness, and Lifecycle Management

**Why it matters**

Managed debt and clear lifecycle policies prevent long-term quality decay.

**Questions to ask**

- Is technical debt visible, prioritized, and tied to business impact?
- Are deprecated components tracked with migration plans and deadlines?
- Is there a roadmap for refactoring high-risk hotspots?

**Tools to use**

- Code quality trend dashboards
- Static analysis trend reports
- Issue tagging and debt registers

**Tests to run**

- Baseline quality metric snapshot and trend comparison
- Refactor safety tests around identified hotspots
- Deprecation/migration path validation tests

**Documentation to review**

- Roadmaps and backlog strategy docs
- Deprecation policy and migration guides
- Historical architecture reviews and retrospectives


## Review Process Checklist

1. Define scope, critical quality attributes, and expected maintainability
   outcomes.
2. Review topics in priority order and capture objective evidence.
3. Validate findings with maintainers to separate design intent from accidental
   complexity.
4. Rank issues by impact × frequency × remediation effort.
5. Produce recommendation backlog with owners, estimates, and sequencing.
6. Track follow-up actions and re-review outcomes after implementation.


## Finding Template (recommended)

- **Title**
- **Category** (structure, docs, tests, CI, dependency, etc.)
- **Severity/Priority**
- **Component/Area**
- **Evidence**
- **Impact on maintainability/quality**
- **Recommendation**
- **Estimated effort**
- **Owner**
- **Target milestone**
- **Status**
