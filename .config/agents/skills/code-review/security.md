# SECURITY REVIEW PROCEDURE


## Goal

Identify security vulnerabilities, weaknesses, and hardening opportunities in a
software repository, then produce prioritized findings and recommendations for
later remediation.


## Scope and Output

- **Scope:** source code, build/deploy configuration, dependencies, tests,
  infrastructure-as-code, runtime settings, and operational documentation.
- **Output:** prioritized findings with evidence, impact, likelihood, affected
  assets, and recommended remediation.


## Security Review Topics (highest to lowest priority)

### 1) Secrets and Credential Exposure

**Why it matters**

Exposed secrets can lead to immediate compromise.

**Questions to ask**

- Are API keys, tokens, passwords, private keys, or certificates committed
  anywhere (including history)?
- Are secrets hardcoded in code, scripts, CI variables, containers, or sample
  configs?
- Are secret rotation and revocation procedures documented?

**Tools to use**

- `gitleaks`, `trufflehog`, `detect-secrets`
- Git history inspection (`git log`, `git grep`)
- CI secret scanners (GitHub Advanced Security, GitLab Secret Detection)

**Tests to run**

- Secret scan of working tree and full commit history
- Validation that pre-commit/CI secret checks fail on seeded test secrets

**Documentation to review**

- `.env` usage docs, configuration guides, runbooks
- CI/CD variable management docs
- Incident response and credential rotation procedures


### 2) Authentication and Session Security

**Why it matters**

Broken auth enables unauthorized access to protected resources.

**Questions to ask**

- Are authentication flows robust (MFA, token expiry, secure password
  handling)?
- Are session tokens protected against fixation, replay, theft, and weak
  invalidation?
- Are account lockout, brute-force protections, and secure recovery
  implemented?

**Tools to use**

- Manual code review and threat modeling
- Dynamic testing tools (Burp Suite, OWASP ZAP)
- Unit/integration tests around auth boundaries

**Tests to run**

- Login brute-force/rate-limit tests
- Session lifecycle tests (creation, refresh, revoke, logout)
- Negative tests for bypass attempts and privilege confusion

**Documentation to review**

- Authentication architecture docs
- Session/token policy and identity provider configuration
- User lifecycle and access recovery procedures


### 3) Authorization and Access Control

**Why it matters**

Improper authorization leads to data exposure and privilege escalation.

**Questions to ask**

- Is authorization enforced server-side for every sensitive action?
- Are object-level checks present (IDOR prevention)?
- Is least privilege applied across roles, services, and environments?

**Tools to use**

- Manual authorization matrix review
- API testing tools (Postman/newman, Burp, ZAP)
- Policy-as-code checks (OPA/conftest where applicable)

**Tests to run**

- Role-based access tests (positive and negative)
- Horizontal/vertical privilege escalation tests
- Endpoint and resource ownership enforcement tests

**Documentation to review**

- RBAC/ABAC design docs
- IAM policies and role definitions
- Data ownership and tenancy model documentation


### 4) Dependency and Supply Chain Risk

**Why it matters**

Vulnerable or tampered dependencies can compromise trusted builds.

**Questions to ask**

- Are dependency versions pinned, reviewed, and updated regularly?
- Are known CVEs present in direct/transitive dependencies?
- Are build artifacts and packages verified (signatures/checksums/provenance)?

**Tools to use**

- `pip-audit`, `safety`, `npm audit`, `osv-scanner`, `syft`, `grype`
- SBOM tooling and dependency graph analyzers
- SLSA/provenance checks where available

**Tests to run**

- Automated vulnerability scans in CI
- Reproducible build checks (if supported)
- Verification of lockfile integrity and tamper resistance

**Documentation to review**

- Dependency management policy
- Third-party risk acceptance process
- Build provenance and artifact signing documentation


### 5) Input Validation and Injection Resistance

**Why it matters**

Injection flaws can enable code execution, data theft, or integrity loss.

**Questions to ask**

- Is all untrusted input validated, normalized, and safely encoded?
- Are database, shell, template, and deserialization contexts protected?
- Are parser boundaries and unsafe eval/exec patterns avoided?

**Tools to use**

- SAST tools (Semgrep, CodeQL, Bandit)
- DAST/fuzzing tools (ZAP, ffuf, boofuzz, hypothesis-based tests)
- Language/framework security linters

**Tests to run**

- SQL/NoSQL/command/template injection payload tests
- Malformed input and boundary fuzz tests
- File upload parsing and content-type spoofing tests

**Documentation to review**

- API schema/validation standards
- Secure coding standards for input handling
- Framework hardening guides


### 6) Cryptography and Data Protection

**Why it matters**

Weak crypto undermines confidentiality, integrity, and trust.

**Questions to ask**

- Are modern algorithms and secure modes used correctly?
- Is sensitive data encrypted at rest and in transit with proper key
  management?
- Are hashes/salts/nonce usage and certificate validation correct?

**Tools to use**

- TLS scanners (`testssl.sh`, SSL Labs)
- Static checks for crypto misuse (Semgrep/CodeQL rules)
- KMS/HSM configuration review tools

**Tests to run**

- TLS configuration tests (protocols, ciphers, certificate chain)
- Key rotation and revocation workflow tests
- Known-answer tests for crypto implementations (if custom wrappers exist)

**Documentation to review**

- Cryptographic standards and key management policy
- Data classification and retention policy
- Certificate issuance/renewal procedures


### 7) CI/CD and Build Pipeline Security

**Why it matters**

Pipeline compromise can inject malicious code into trusted releases.

**Questions to ask**

- Are CI runners, secrets, and deployment credentials appropriately isolated?
- Are pull requests from forks restricted from secret access?
- Are release processes protected by approvals and signed artifacts?

**Tools to use**

- CI configuration scanners
- IaC/pipeline linting tools
- Signature verification tools (`cosign`, provenance validators)

**Tests to run**

- Simulated untrusted PR pipeline behavior tests
- Verification that protected branches and required checks enforce policy
- Artifact signature verification in release jobs

**Documentation to review**

- CI/CD security model and branch protection policy
- Release management SOPs
- Runner hardening and secret-scoping documentation


### 8) Logging, Monitoring, and Detection

**Why it matters**

Without visibility, attacks go unnoticed and response is delayed.

**Questions to ask**

- Are security-relevant events logged with enough context and integrity?
- Are alerts actionable, tuned, and linked to runbooks?
- Are logs free of sensitive data and protected from tampering?

**Tools to use**

- SIEM queries (Splunk, Elastic, Sentinel)
- Log schema validators
- Detection rule testing frameworks

**Tests to run**

- Security event generation tests (auth failure, policy violation, escalation)
- Alert fidelity tests (false positive/false negative sampling)
- Log redaction and retention validation tests

**Documentation to review**

- Logging standards and retention policies
- SOC runbooks and alert routing procedures
- Incident triage playbooks


### 9) Infrastructure, Runtime, and Configuration Hardening

**Why it matters**

Misconfiguration is a frequent root cause of compromise.

**Questions to ask**

- Are default-deny, least privilege, and network segmentation applied?
- Are container, VM, and host baselines hardened?
- Are debug modes and dangerous flags disabled in production?

**Tools to use**

- IaC scanners (`checkov`, `tfsec`, `kics`)
- Kubernetes scanners (`kube-bench`, `kube-hunter`)
- CIS benchmark tooling and config audit scripts

**Tests to run**

- Config drift detection checks
- Runtime policy enforcement tests
- Network exposure and service enumeration tests

**Documentation to review**

- Environment configuration baselines
- Deployment manifests and IaC modules
- Hardening checklists and exception records


### 10) Business Logic Abuse and Abuse-Case Resilience

**Why it matters**

Logic flaws can bypass technical controls even when code appears secure.

**Questions to ask**

- Can workflows be abused for fraud, quota bypass, or policy evasion?
- Are rate limits, anti-automation, and abuse controls effective?
- Are critical operations protected by step-up checks and auditability?

**Tools to use**

- Threat modeling (STRIDE/LINDDUN where relevant)
- Abuse-case test design, replay tools, and API workflow testing
- Product analytics and anomaly detection queries

**Tests to run**

- End-to-end abuse scenarios across multi-step workflows
- Race-condition and replay tests on sensitive operations
- Quota/limit bypass and economic abuse tests

**Documentation to review**

- Product requirements and workflow diagrams
- Fraud/abuse policies
- Historical incidents and postmortems


## Review Process Checklist

1. Define scope, critical assets, trust boundaries, and threat model.
2. Execute scans/tests per topic in priority order.
3. Validate findings manually to reduce false positives.
4. Score findings by impact × likelihood and map to business risk.
5. Produce remediation recommendations with owners and target timelines.
6. Record compensating controls and residual risk acceptance decisions.


## Finding Template (recommended)

- **Title**
- **Severity** (Critical/High/Medium/Low)
- **Asset/Component**
- **Evidence** (code path, test output, logs)
- **Impact**
- **Likelihood**
- **Recommendation**
- **Owner**
- **Target Date**
- **Status**
