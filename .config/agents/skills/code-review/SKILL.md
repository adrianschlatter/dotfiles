---
name: code-review
description: Coordinate reviews from all available stakeholder guidelines, reconcile findings, and report them by severity.
allowed-tools: Task, Read, Grep, Glob, Bash
---

# Coordinated Code Review

Review the requested code or repository using every stakeholder guideline
stored alongside this `SKILL.md`. Discover the guideline files at runtime: use
each Markdown file in this skill directory except `SKILL.md` itself. Do not rely
on a fixed number of files or on particular filenames. Treat each file as a
separate stakeholder's review criteria; derive a concise stakeholder label from
its title/content (using its filename as a fallback). The goal is to find
actionable issues in the requested scope, not to produce a checklist of every
guideline topic.

## Orchestration

1. Establish the review scope from the user's request. If they do not specify a
   scope, review the current changes (working tree and branch diff, with enough
   surrounding code to verify findings); do not imply that the whole repository
   was reviewed. Use read-only inspection by default. Run tests or scanners only
   when relevant, safe, and reasonably scoped.
2. Build the review roster from all discovered guideline files. If the roster
   is empty, report that no guidelines were found and do not claim a review was
   completed. If a coordinator/sub-agent orchestration capability is available,
   start one coordinator agent and give it the scope, roster, and complete
   instructions in this skill. The coordinator must launch one independent
   stakeholder sub-agent per guideline, in parallel. Each stakeholder must read
   its assigned guideline, inspect the same review scope, and return candidate
   findings with evidence. The coordinator aggregates the results and produces
   the final report; it must not substitute its own review for stakeholder
   reviews.
3. If no coordinator agent can be started, perform a distinct review pass for
   every discovered guideline yourself **in turn**, then reconcile their
   findings. Never silently omit a guideline.
4. If sub-agents are available but the coordinator cannot delegate, use the
   same sequential passes yourself. Never silently omit a guideline.

### Stakeholder instructions

Each stakeholder should:

- Review only the requested scope, following its assigned guideline and
  examining relevant surrounding code/configuration/docs as needed.
- Return only concrete, actionable findings. For each, include a concise title,
  observation, consequence/impact, exact evidence (file and line or reproducible
  behavior), suggested remediation, and a proposed severity.
- Separate verified defects from uncertain concerns. State uncertainty and
  assumptions; do not invent evidence, test results, user behavior, or project
  intent.
- Avoid duplicating findings belonging to another stakeholder unless the same
  issue has a distinct, material impact under that stakeholder's criteria.
- Do not make changes to the code. Avoid destructive actions and avoid testing
  against systems outside the repository or without authorization.

## Reconcile findings

After all guideline reviews finish, the coordinator must:

1. **Validate** candidate findings against the available evidence and the
   requested scope. Drop unsupported speculation and clearly label any
   remaining uncertainty. Preserve the stakeholder source(s) for each finding.
2. **De-duplicate** findings that describe the same underlying issue, even if
   phrased differently or discovered in different files. Combine their impacts
   and evidence into one finding; retain separate entries only when they are
   independently actionable or have materially different consequences.
3. **Detect contradictions.** Look for incompatible recommendations or
   assessments about the same behavior, including different assumptions about
   intended behavior, compatibility, security controls, or user workflows.
   Record the competing positions and the stakeholders involved.
4. **Resolve trade-offs with the relevant stakeholders.** Send the competing
   findings, relevant evidence, and any known constraints back to only the
   stakeholders involved. Ask them to verify their assumptions and propose a
   recommendation that accounts for both impacts. Do not have a stakeholder
   adjudicate outside its expertise. If they cannot reach a supported
   resolution, report the disagreement, rationale, and viable options explicitly
   rather than choosing arbitrarily. In sequential fallback mode, revisit the
   relevant guideline passes and compare their reasoning in the same way.
5. **Normalize severity** consistently across all sources, using the highest
   severity justified by evidence and impact:
   - **Critical** — credible, severe impact requiring immediate attention.
   - **High** — substantial security, data, availability, or core-workflow harm.
   - **Medium** — meaningful but limited impact, or a problem with a practical
     workaround.
   - **Low** — minor impact, polish, or a lower-risk improvement.
   Do not inflate severity based only on a guideline's own ranking. If the
   evidence cannot support a severity confidently, say so and explain why.
6. Sort the final findings from highest to lowest severity, then by impact
   within each severity. Do not include an empty placeholder finding for a
   category with no issues.

## Final report

Begin with a brief scope statement and review mode (coordinated or sequential),
including any important limitations. Then present findings in severity order.
Use this format for every finding:

```markdown
### <ID>. [Severity] Concise issue title

- **Observation:** What is wrong, stated precisely.
- **Consequence:** The concrete risk or user/maintainer impact, including
  relevant conditions and likelihood where known.
- **Evidence:** File path and line range, or concise reproducible evidence.
  Distinguish observed facts from assumptions; do not cite evidence that was
  not checked.
- **Remediation:** A specific, proportionate fix or next step.
- **Stakeholders:** The stakeholder label(s) derived from the relevant
  guideline file(s).
```

If stakeholders disagree, add **Trade-off** with the competing positions,
relevant constraints, any agreed recommendation, and unresolved alternatives.
If there are no validated findings, say so plainly and mention any material
coverage limitations. Do not claim that a clean review proves the code is free
of defects.
