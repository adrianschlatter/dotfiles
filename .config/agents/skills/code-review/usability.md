# USABILITY REVIEW PROCEDURE

## Goal

Evaluate a software repository, or the software built from it, for usability
quality across setup, daily use, troubleshooting, and lifecycle operations.
Produce prioritized issues and recommendations for later remediation.


## Scope and Output

- **Scope:** install/upgrade/uninstall paths, CLI/GUI/API interactions,
  docs/help surfaces, diagnostics, defaults, error UX, and release artifacts.
- **Output:** prioritized findings with evidence, user impact, frequency, and
  recommended improvements.


## Usability Review Topics (highest to lowest priority)

### 1) First-Run Experience and Installation

**Why it matters**

If setup fails or is confusing, users churn before reaching value.

**Questions to ask**
 
- Can new users install on supported platforms without tribal knowledge?
- Are prerequisites explicit and validated early with actionable messages?
- Is there a working quick-start path from zero to first successful run?

**Tools to use**

- Clean VM/container environments
- Package/install tools (`pip`, `pipx`, package managers, installers)
- Scripted setup checks and environment validators

**Tests to run**

- Fresh-install tests on each supported OS/runtime
- Copy-paste quick-start verification from docs
- Failure-path tests for missing dependencies/permissions

**Documentation to review**

- README quick-start and install docs
- Platform prerequisites and compatibility matrix
- Troubleshooting/install failure guide


### 2) Core Task Success and Workflow Clarity

**Why it matters**

Users judge usability by how quickly they can complete common tasks.

**Questions to ask**

- Are primary user workflows obvious, short, and consistent?
- Do defaults help users succeed without heavy configuration?
- Are outputs understandable and aligned with user goals?

**Tools to use**

- Task walkthrough scripts and usability heuristics checklist
- Session recording and command history analysis
- Analytics/telemetry dashboards (if available)

**Tests to run**

- Scenario-based end-to-end task completion tests
- Time-to-completion and error-rate benchmarking
- Novice-user dry runs following only provided instructions

**Documentation to review**

- Usage guides and tutorials
- Example projects and sample commands
- Product requirements/user stories for core workflows


### 3) In-Product Help, Introspection, and Discoverability

**Why it matters**

Users need to self-serve answers while working.

**Questions to ask**

- Are help surfaces complete (`--help`, subcommand help, API docs, tooltips)?
- Can users inspect configuration, version, environment, and runtime state
  easily?
- Are command names/options discoverable and logically grouped?

**Tools to use**

- CLI/API documentation generators
- Command inventory tools and shell completion checks
- UX review of in-app help panels and contextual hints

**Tests to run**

- Help coverage tests for every command/option
- Validation of examples embedded in help text
- Introspection command tests (`version`, `config`, `doctor`, status commands)

**Documentation to review**

- Command reference and man pages
- Introspection/diagnostic command docs
- FAQ and self-service support guides


### 4) Error Messages, Recovery, and Troubleshooting UX

**Why it matters**

Good recovery guidance turns failures into solvable events.

**Questions to ask**

- Are errors specific, human-readable, and actionable?
- Do messages include likely cause, next step, and links to docs?
- Can users recover without contacting maintainers?

**Tools to use**

- Error-path test harnesses
- Log and stderr review tools
- Support ticket analysis for repeated confusion patterns

**Tests to run**

- Negative-path tests (invalid args, network failures, bad config)
- Recovery-flow tests after partial failure
- Consistency checks for error formatting/severity

**Documentation to review**

- Troubleshooting section
- Known issues and workaround documentation
- Support runbooks and escalation paths


### 5) Upgrade, Migration, and Backward Compatibility Experience

**Why it matters**

Friction during upgrades causes user distrust and stalled adoption.

**Questions to ask**

- Is upgrading predictable with clear compatibility guarantees?
- Are breaking changes announced with migration steps and examples?
- Are config/data migrations safe, reversible, and validated?

**Tools to use**

- Version comparison and changelog analyzers
- Migration test fixtures and rollback scripts
- API/CLI compatibility diff tools

**Tests to run**

- In-place upgrade tests from supported prior versions
- Rollback tests to previous stable release
- Backward-compatibility tests for critical commands/APIs

**Documentation to review**

- Release notes/changelog
- Migration guides and deprecation policy
- Version support policy (LTS, EOL timelines)


### 6) Uninstallation, Cleanup, and Reversibility

**Why it matters**

Safe cleanup improves trust and operational hygiene.

**Questions to ask**

- Can users fully uninstall without leftover sensitive/config state surprises?
- Are data/config/cache locations clearly documented before removal?
- Are uninstall effects explicit and reversible where feasible?

**Tools to use**

- OS/package manager uninstall tooling
- File-system diff tools before/after uninstall
- Environment cleanup scripts

**Tests to run**

- Uninstall/reinstall cycle tests
- Residual file/process/service detection tests
- Validation of optional data preservation/export paths

**Documentation to review**

- Uninstall and cleanup docs
- Data retention/export instructions
- Backup/restore guidance


### 7) Documentation Usability and Instruction Quality

**Why it matters**

Documentation is a core usability surface, not a side artifact.

**Questions to ask**

- Are instructions concise, accurate, and task-oriented?
- Are examples realistic, copy-pasteable, and maintained?
- Is navigation clear for beginners and advanced users?

**Tools to use**

- Docs linting/spell/link tools (`markdownlint`, `vale`, `lychee`)
- Docs search quality checks
- Readability analysis tools

**Tests to run**

- Documentation example execution tests in CI
- Broken-link and stale-command checks
- New-user onboarding test using docs only

**Documentation to review**

- README, quick-start, tutorial, reference docs
- CONTRIBUTING docs for user feedback channels
- Information architecture/navigation maps


### 8) Accessibility, Internationalization, and Inclusive UX

**Why it matters**

Usability fails when significant user groups are excluded.

**Questions to ask**

- Are interfaces accessible (contrast, keyboard navigation, screen reader
  semantics)?
- Are language, date/time, and locale assumptions documented or configurable?
- Are error/help texts inclusive and understandable to non-experts?

**Tools to use**

- Accessibility scanners (axe, Lighthouse)
- i18n/l10n validation tooling
- Keyboard-only and screen-reader walkthroughs

**Tests to run**

- WCAG-focused audits for applicable interfaces
- Locale and timezone behavior tests
- Plain-language review of top user-facing messages

**Documentation to review**

- Accessibility statement and standards targets
- Localization/internationalization policy
- UX writing guidelines


### 9) Performance Perception and Interaction "Polish"

**Why it matters**

Perceived speed and polish strongly influence user confidence.

**Questions to ask**

- Are startup and common interactions responsive enough for real use?
- Do progress indicators, statuses, and confirmations reduce uncertainty?
- Are output formatting, defaults, and edge-case behaviors polished and consistent?

**Tools to use**

- Profilers and startup timers
- UX consistency checklist
- Snapshot/regression tools for output formatting

**Tests to run**

- Performance smoke tests for common tasks
- Output formatting consistency tests
- Interrupt/resume/cancel interaction tests

**Documentation to review**

- Performance targets/SLOs
- UX acceptance criteria
- Historical bug reports about confusing or rough behaviors


### 10) Feedback Loops, Supportability, and Continuous UX Improvement

**Why it matters**

Usability quality depends on capturing and acting on user feedback.

**Questions to ask**

- Are channels for reporting UX issues visible and easy to use?
- Are usability issues triaged with severity and frequency data?
- Is there a recurring process to validate improvements with users?

**Tools to use**

- Issue tracker dashboards and labeling workflows
- Telemetry and funnel analysis
- Survey/interview templates and feedback systems

**Tests to run**

- UX regression checks on top pain-point journeys
- Trend analysis before/after changes (support tickets, drop-off rates)
- Periodic heuristic evaluation or moderated usability sessions

**Documentation to review**

- Support/feedback policy
- Triage and prioritization process docs
- UX roadmap and past usability review reports


## Review Process Checklist

1. Define target users, critical workflows, platforms, and usability success
   metrics.
2. Execute topic reviews in priority order using scenario-based tasks.
3. Capture reproducible evidence (steps, environment,
   screenshots/logs/outputs).
4. Rank findings by user impact × frequency × fix effort.
5. Produce recommendations with owners, sequencing, and measurable outcomes.
6. Re-test after fixes and track trend improvements over time.


## Finding Template (recommended)

- **Title**
- **Category** (install, help, docs, upgrade, accessibility, polish, etc.)
- **Priority/Severity**
- **User segment affected**
- **Evidence**
- **User impact**
- **Recommendation**
- **Estimated effort**
- **Owner**
- **Target milestone**
- **Status**
