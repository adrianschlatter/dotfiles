# STABILITY REVIEW PROCEDURE


## Goal

Evaluate whether software behaves correctly and predictably across normal,
boundary, and failure conditions, and whether it can recover without crashing,
corrupting state, or disrupting users. Produce prioritized findings and
recommendations for later remediation.


## Scope and Output

- **Scope:** source code, APIs/CLI/UI, state and persistence, concurrency,
dependencies, runtime configuration, tests, and operational recovery paths.
- **Output:** prioritized findings with evidence, affected behavior, impact,
reproduction conditions, and recommended remediation.


## Stability Review Topics (highest to lowest priority)

### 1) Crashes, Unhandled Exceptions, and Process Lifecycle

**Why it matters**

A crash can interrupt critical work, lose in-flight state, or make a service
unavailable.

**Questions to ask**

- Can realistic inputs or environmental conditions reach unhandled exceptions,
  panics, assertion failures, or unsafe termination paths?
- Are startup, shutdown, cancellation, and restart paths safe and repeatable?
- Do background tasks and child processes report failures rather than silently
  terminating or leaving work incomplete?

**Tools to use**

- Runtime logs, crash reports, and core-dump analyzers
- Static analyzers and linters for exception/panic and resource-lifecycle paths
- Process supervisors and health-check tooling

**Tests to run**

- Startup/shutdown and restart-cycle tests
- Fault-path tests for expected exceptions and failed child processes
- Repeated execution tests to detect intermittent termination

**Documentation to review**

- Process lifecycle and graceful-shutdown behavior
- Crash reporting and restart policies
- Known limitations and supported runtime environments


### 2) Input Boundaries, Invariants, and State Correctness

**Why it matters**

Invalid or unexpected values can violate assumptions and cause incorrect results,
corrupted state, or later failures.

**Questions to ask**

- Are inputs validated at trust and module boundaries, including null, empty,
  malformed, oversized, and out-of-range values?
- Are important invariants explicit and preserved across every state transition?
- Do code paths fail safely rather than continuing with partially valid data?

**Tools to use**

- Type checkers and static analysis (`mypy`, `pyright`, CodeQL)
- Property-based and schema-validation tools
- Assertions or invariant checks in tests and debug builds

**Tests to run**

- Boundary-value and malformed-input tests
- Property-based tests for core invariants
- Regression tests for previously observed incorrect states

**Documentation to review**

- Input schemas and validation contracts
- Domain invariants and state-machine diagrams
- Data format and compatibility guarantees


### 3) Error Handling, Failure Isolation, and Partial Operations

**Why it matters**

Failures are inevitable; poor containment can turn a local error into broad
outage or inconsistent results.

**Questions to ask**

- Are errors handled at the appropriate boundary, with neither silent
  suppression nor accidental process-wide failure?
- Can partial operations leave files, records, or external resources in an
  inconsistent state?
- Are fallback behavior and retry limits safe, explicit, and observable?

**Tools to use**

- Fault-injection and dependency-stubbing frameworks
- Logs, traces, and error-reporting dashboards
- Transaction and consistency analyzers where applicable

**Tests to run**

- Injected failures at each step of multi-step operations
- Retry, timeout, and fallback-path tests
- Verification of rollback or cleanup after partial failure

**Documentation to review**

- Error-handling conventions and failure contracts
- Transaction and compensation behavior
- Operational response and recovery runbooks


### 4) Persistence, Data Integrity, and Recovery

**Why it matters**

A process that stays alive but loses or corrupts data is still unstable.

**Questions to ask**

- Are writes atomic or recoverable if interrupted, and are durability
  expectations clear?
- Can schema changes, interrupted migrations, or incompatible data cause
  irreversible damage?
- Are backups, restore paths, and consistency checks available for important
  data?

**Tools to use**

- Database integrity and migration tools
- Filesystem/database fault-injection tools
- Backup verification and restore-drill tooling

**Tests to run**

- Process termination during writes and migrations
- Upgrade/rollback tests using representative old data
- Backup restoration and post-restore consistency checks

**Documentation to review**

- Persistence, transaction, and durability guarantees
- Migration and rollback procedures
- Backup retention and recovery objectives


### 5) Concurrency, Synchronization, and Ordering

**Why it matters**

Races and deadlocks may produce rare crashes, hangs, or inconsistent state
that are difficult to reproduce in production.

**Questions to ask**

- Are shared mutable state and resource ownership synchronized correctly?
- Can lock ordering, blocking calls, or callbacks cause deadlocks or starvation?
- Are cancellation and concurrent shutdown safe, and is event ordering relied
  on explicitly rather than accidentally?

**Tools to use**

- Thread/race detectors and concurrency sanitizers
- Deadlock diagnostics and thread/task dumps
- Concurrency-focused static analysis

**Tests to run**

- Stress and repeated parallel execution tests
- Race tests with controlled scheduling or synchronization barriers
- Concurrent cancellation, shutdown, and resource-contention tests

**Documentation to review**

- Thread-safety and ownership contracts
- Locking and event-ordering rules
- Concurrency limits and runtime assumptions


### 6) Resource and Handle Lifecycle

**Why it matters**

Leaked or exhausted resources eventually cause hangs, errors, or process failure.

**Questions to ask**

- Are files, sockets, database connections, locks, and temporary resources
  released on success, error, and cancellation paths?
- Can queues, caches, buffers, or open handles grow without a bound?
- Are resource limits and exhaustion behavior explicit and recoverable?

**Tools to use**

- Memory and handle profilers
- Leak detectors and runtime resource metrics
- Container/process limit monitoring

**Tests to run**

- Repeated operation tests with resource usage tracked over time
- Exhaustion tests for file descriptors, connections, memory, and queue limits
- Cleanup verification after exceptions and cancellation

**Documentation to review**

- Resource ownership and cleanup rules
- Runtime capacity and limit configuration
- Leak investigation and remediation runbooks


### 7) External Dependencies, Timeouts, and Network Resilience

**Why it matters**

A slow or unavailable dependency should not make the whole application hang or
fail unpredictably.

**Questions to ask**

- Do network, database, filesystem, and service calls have appropriate
  timeouts and bounded retries?
- Are transient failures distinguished from permanent errors, with safe
  backoff and circuit-breaking where useful?
- Does the application tolerate dependency version or availability changes
  within its stated support range?

**Tools to use**

- Network/service fault simulators
- Dependency health checks and compatibility analyzers
- Distributed tracing and timeout diagnostics

**Tests to run**

- Slow, unavailable, and partially failing dependency tests
- Retry-storm and recovery-after-outage tests
- Compatibility tests against supported dependency versions

**Documentation to review**

- Dependency support matrix and availability assumptions
- Timeout, retry, and fallback policies
- Degraded-mode behavior and incident procedures


### 8) Configuration, Environment, and Compatibility Robustness

**Why it matters**

Unexpected but supported configurations should fail clearly, not trigger
undefined behavior or hidden data loss.

**Questions to ask**

- Are missing, invalid, conflicting, or stale settings detected early with
  safe defaults or actionable errors?
- Are platform, runtime, locale, filesystem, and environment assumptions
  handled explicitly?
- Do upgrades and supported configuration changes preserve expected behavior?

**Tools to use**

- Configuration/schema validators
- Cross-platform and runtime compatibility test matrices
- Environment and dependency drift checks

**Tests to run**

- Tests for absent, malformed, and conflicting configuration
- Supported OS/runtime matrix tests
- Upgrade tests with legacy configuration and data

**Documentation to review**

- Configuration reference and default behavior
- Platform/runtime support policy
- Upgrade, deprecation, and compatibility notes


### 9) Observability, Health, and Failure Detection

**Why it matters**

Undetected degradation lasts longer and can turn a recoverable fault into an
outage.

**Questions to ask**

- Can operators distinguish a healthy process from one that is stuck or unable
  to serve its core function?
- Are important failures, retries, resource pressure, and degraded modes
  observable without exposing sensitive data?
- Do health checks reflect real readiness and avoid causing harmful load?

**Tools to use**

- Metrics, logs, and distributed tracing (OpenTelemetry, Prometheus)
- Health-check and alert validation tools
- Dashboard and alert quality reviews

**Tests to run**

- Health/readiness behavior under dependency failure and overload
- Alert tests for representative failure and recovery events
- Log/metric validation for actionable context and safe redaction

**Documentation to review**

- Monitoring standards and service health definitions
- Alert thresholds, ownership, and escalation paths
- Troubleshooting dashboards and runbooks


### 10) Degradation, Recovery, and Operational Readiness

**Why it matters**

Stable systems limit the scope of faults and return to service predictably.

**Questions to ask**

- Does overload cause controlled degradation, or cascading failure and
  unbounded backlog growth?
- Can the system recover after restart or dependency restoration without
  operator guesswork or duplicate harmful work?
- Are recovery procedures tested against realistic failure scenarios?

**Tools to use**

- Load/fault-injection and chaos-testing tools
- Queue, saturation, and recovery-time dashboards
- Deployment rollback and orchestration tooling

**Tests to run**

- Overload and graceful-degradation tests
- Restart/recovery tests with queued or in-flight work
- Rollback and disaster-recovery exercises

**Documentation to review**

- SLOs, capacity and degradation policy
- Incident response and rollback procedures
- Recovery objectives and postmortems


## Review Process Checklist

1. Define critical behaviors, supported environments, and acceptable failure
   and recovery expectations.
2. Review topics in priority order and identify concrete failure scenarios.
3. Reproduce or test plausible failures safely; capture exact conditions and
   evidence.
4. Rank findings by impact × likelihood, considering scope and recoverability.
5. Recommend proportionate fixes, detection, and recovery improvements.
6. Re-test failure and recovery paths after remediation.


## Finding Template (recommended)

- **Title**
- **Category** (crash, data integrity, concurrency, recovery, etc.)
- **Severity/Priority**
- **Component/Area**
- **Evidence** (code path, reproduction, test output, logs)
- **Failure conditions**
- **Impact**
- **Recommendation**
- **Estimated effort**
- **Owner**
- **Target milestone**
- **Status**
