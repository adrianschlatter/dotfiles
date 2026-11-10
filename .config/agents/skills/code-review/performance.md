# PERFORMANCE REVIEW PROCEDURE


## Goal

Evaluate whether software responds quickly enough for its important use cases
and uses CPU, memory, I/O, and other resources efficiently where that affects
real user experience, throughput, or operating cost. Identify measured or
credible bottlenecks, not speculative opportunities to optimize. Produce
prioritized findings and recommendations for later remediation.


## Scope and Output

- **Scope:** source code, algorithms, data access, startup and interactive
  paths, concurrency, runtime configuration, benchmarks, and operational
  telemetry.
- **Output:** prioritized findings with evidence, affected workloads, measured
  or estimated impact, and recommended improvements.


## Performance Review Topics (highest to lowest priority)

### 1) User-Critical Latency and Responsiveness

**Why it matters**

Delay in frequent or blocking workflows directly harms user productivity and
confidence.

**Questions to ask**

- Are startup, first-use, common commands, API calls, and interactive actions
  within appropriate latency targets?
- Do UI/event-loop or request paths perform long work synchronously when it
  could be safely deferred or streamed?
- Are slow operations visible to users through progress, cancellation, or
  incremental results when appropriate?

**Tools to use**

- Request tracing and latency dashboards (OpenTelemetry, APM)
- Startup and command timers
- Browser/UI responsiveness and event-loop profiling tools

**Tests to run**

- Latency measurements for representative user workflows
- Cold-start and warm-start comparisons
- Responsiveness tests during large or slow operations

**Documentation to review**

- User-facing latency targets and SLOs
- Core workflow definitions and acceptance criteria
- Historical performance regressions and user-reported delays


### 2) Measurement, Profiling, and Evidence Quality

**Why it matters**

Optimization without evidence wastes effort and can make code harder to
maintain without improving real outcomes.

**Questions to ask**

- Are claims about slowness tied to a representative workload and repeatable
  measurements?
- Do measurements separate CPU, waiting, I/O, allocation, and network costs?
- Are targets and baselines focused on meaningful user or system outcomes
  rather than vanity metrics?

**Tools to use**

- Language/runtime profilers and flame graphs
- Benchmark harnesses with stable datasets and environments
- APM, tracing, and resource telemetry

**Tests to run**

- Repeatable benchmarks with warm-up and variance accounted for
- Before/after profiling of identified hot paths
- Performance regression checks against agreed baselines

**Documentation to review**

- Benchmark methodology and workload descriptions
- Performance budgets, baselines, and SLO definitions
- Prior optimization decisions and trade-offs


### 3) Algorithmic Complexity and Data-Structure Choices

**Why it matters**

An inefficient algorithm can turn ordinary growth in input size into severe
latency or CPU cost.

**Questions to ask**

- Do common operations have appropriate complexity for realistic data sizes?
- Are repeated scans, sorting, parsing, or recomputation avoidable on hot paths?
- Are data structures suited to access patterns, including lookup, update, and
  ordering needs?

**Tools to use**

- CPU profilers and call-count instrumentation
- Complexity/static analysis tools
- Benchmark generators for representative and worst-case inputs

**Tests to run**

- Scaling benchmarks across increasing input sizes
- Tests for adversarial or highly skewed input distributions
- Regression tests for identified high-cost operations

**Documentation to review**

- Expected input sizes and growth assumptions
- Data model and access-pattern documentation
- Performance-critical algorithm notes


### 4) CPU Utilization and Avoidable Work

**Why it matters**

Unnecessary computation wastes energy and capacity, and can make other work
less responsive, especially under load.

**Questions to ask**

- Are hot loops doing redundant work, excessive polling, repeated conversions,
  or expensive work when results are unchanged?
- Is CPU-intensive work placed appropriately (and bounded) so it does not
  starve latency-sensitive tasks?
- Is parallelism used only where it improves real elapsed time without
  excessive synchronization or contention?

**Tools to use**

- CPU profilers and per-thread utilization tools
- Sampling traces and scheduler diagnostics
- Load-test dashboards for CPU saturation and run-queue pressure

**Tests to run**

- CPU profile under realistic idle, typical, and peak workloads
- Tests for polling, batching, and caching behavior where relevant
- Concurrency benchmarks comparing serial and parallel execution

**Documentation to review**

- CPU/resource budgets and workload expectations
- Scheduling, worker-pool, and background-task policies
- Relevant profiling reports and optimization rationale


### 5) I/O, Network, and Database Efficiency

**Why it matters**

Excessive or poorly batched I/O increases response time, load, and dependency
cost even when the CPU is mostly idle.

**Questions to ask**

- Are there N+1 queries, chatty network calls, small unbatched writes, or
  unnecessary full scans?
- Are connection pools, caching, streaming, and batching appropriate for the
  workload and consistency requirements?
- Do synchronous I/O waits block unrelated requests or interactive work?

**Tools to use**

- Database query analyzers and `EXPLAIN` plans
- Network tracing and request-count instrumentation
- I/O and storage profilers

**Tests to run**

- Query-count and request-count tests for common flows
- Benchmarks with realistic latency and data volume
- Load tests for pool saturation and concurrent I/O

**Documentation to review**

- Data access patterns and query conventions
- Network/API limits and service latency assumptions
- Cache consistency and connection-pool configuration


### 6) Memory, Allocation, and Garbage-Collection Pressure

**Why it matters**

Excess allocation and memory growth can increase latency, trigger pauses, or
cause out-of-memory failures.

**Questions to ask**

- Are large or short-lived objects allocated repeatedly on hot paths?
- Do caches, buffers, or retained results have bounds and eviction behavior?
- Does memory usage grow with workload volume or duration when it should
  remain bounded?

**Tools to use**

- Heap/allocation profilers and garbage-collection logs
- Memory leak detectors and RSS monitoring
- Object-retention and heap-dump analyzers

**Tests to run**

- Long-running soak tests with memory tracking
- Allocation benchmarks for hot operations
- Large-input and cache-eviction tests

**Documentation to review**

- Memory limits and runtime/GC configuration
- Cache size, eviction, and retention policy
- Workload size and data-lifecycle expectations


### 7) Concurrency, Parallelism, and Contention

**Why it matters**

Appropriate concurrency can improve throughput and responsiveness; poorly
managed concurrency can increase latency and waste CPU.

**Questions to ask**

- Are worker pools and queues sized for actual capacity, with backpressure
  instead of unbounded work accumulation?
- Do locks, shared state, context switching, or coordination dominate the
  parallel work's benefit?
- Are independent tasks serialized unnecessarily, or is parallelism harming
  predictable latency and resource use?

**Tools to use**

- Thread/task profilers and lock-contention analyzers
- Queue-depth and worker-saturation metrics
- Load generators and concurrency benchmarks

**Tests to run**

- Throughput and tail-latency tests at multiple concurrency levels
- Contention and backpressure tests under overload
- Tests comparing bounded parallelism with serial execution

**Documentation to review**

- Worker, queue, and concurrency-limit configuration
- Throughput and latency objectives
- Parallelism and backpressure design notes


### 8) Caching, Reuse, and Repeated Computation

**Why it matters**

Reuse can reduce repeated work substantially, but unnecessary or incorrect
caching adds complexity and stale-data risk.

**Questions to ask**

- Is expensive work repeated when inputs and results have not changed?
- Would caching or incremental computation materially improve a measured hot
  path at realistic reuse rates?
- Are cache invalidation, memory bounds, and freshness semantics correct?

**Tools to use**

- Tracing and call-count instrumentation
- Cache hit/miss and invalidation metrics
- Benchmarks comparing cached and uncached behavior

**Tests to run**

- Repeated-workload benchmarks with realistic hit rates
- Cache correctness, expiry, and invalidation tests
- Memory and latency tests under cache churn

**Documentation to review**

- Cache freshness and consistency guarantees
- Invalidation and retention policies
- Rationale and evidence for performance-sensitive reuse


### 9) Workload Scaling, Capacity, and Graceful Overload

**Why it matters**

Performance that degrades sharply with users, data, or event volume can make a
system unusable or expensive at the moment it is needed most.

**Questions to ask**

- Do throughput and tail latency scale acceptably over the supported workload
  range?
- Are expensive operations, queue growth, and resource consumption bounded?
- Does the system shed, defer, or reject work predictably before overload
  causes widespread slowdown?

**Tools to use**

- Load/stress testing and capacity-planning tools
- Queue, saturation, and tail-latency dashboards
- Query and service dependency tracing

**Tests to run**

- Load tests at expected and peak traffic/data volumes
- Stress tests beyond capacity to verify bounded degradation
- Capacity tests measuring scaling bottlenecks and recovery after load

**Documentation to review**

- Capacity estimates and supported workload limits
- SLOs and overload behavior
- Scaling and deployment guidance


### 10) Performance Regression, Build, and Runtime Configuration

**Why it matters**

Small regressions accumulate, while inappropriate compiler, runtime, or
production settings can negate sound implementation choices.

**Questions to ask**

- Are performance-sensitive changes measured against a suitable baseline?
- Do builds and runtime settings match the intended deployment and workload?
- Are performance checks stable and scoped to meaningful regressions rather
  than noisy micro-optimizations?

**Tools to use**

- Benchmark CI and regression dashboards
- Build and runtime configuration analyzers
- Compiler/runtime profiling and diagnostic tools

**Tests to run**

- Representative benchmark suite on relevant release builds
- Performance regression tests with noise thresholds
- Configuration and deployment smoke tests under production-like settings

**Documentation to review**

- Release build and runtime configuration
- Benchmark CI policy and regression thresholds
- Known trade-offs and performance change history


## Review Process Checklist

1. Define important workloads, supported sizes, latency/throughput goals, and
   resource constraints.
2. Identify user-visible or operational bottlenecks before proposing
   optimization.
3. Gather reproducible measurements and profile the relevant code path.
4. Rank findings by user impact × frequency × resource cost, accounting for
   implementation risk and complexity.
5. Recommend the smallest justified improvement and specify how to measure its
   effect.
6. Re-run representative benchmarks and correctness tests after remediation.


## Finding Template (recommended)

- **Title**
- **Category** (latency, CPU, I/O, memory, scaling, etc.)
- **Priority/Severity**
- **Component/Workload**
- **Evidence** (profile, benchmark, trace, or reproducible behavior)
- **Measured or estimated impact**
- **Conditions and frequency**
- **Recommendation**
- **Estimated effort**
- **Owner**
- **Target milestone**
- **Status**
