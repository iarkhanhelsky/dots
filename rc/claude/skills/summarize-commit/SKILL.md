---
name: summarize-commit
description: Write a comprehensive change summary for commits and PRs, including rationale, solution approach, technical details, decisions, and validation steps.
disable-model-invocation: true
---

# Summarize Commit

Use this skill when preparing a commit message body, PR description, or release note summary.

## When to Use

- User asks for an extensive summary of implemented changes.
- Preparing a high-quality commit/PR explanation for reviewers.
- Capturing engineering context for future maintenance.

## When Not to Use

- Tiny one-line fixes where a short note is sufficient.
- Work that has not been implemented yet.

## Required Structure

Produce the summary with these sections in order:

1. Rationale: what problem existed and why it mattered.
2. Solution: how the change addresses the problem.
3. High-level technical details: key components, flows, and touched areas.
4. Assumptions: tradeoffs, constraints, and why this approach was chosen.
5. Test and validation: how behavior was verified and what remains to validate.

Keep the narrative lightweight and flowing in this sequence. Do not over-expand with unnecessary detail.

## Quality Checklist

- Tie rationale to concrete symptoms, risks, or developer pain.
- Explain design intent, not just a file-by-file diff.
- Highlight behavior changes and compatibility implications.
- Call out assumptions and residual risks explicitly.
- Keep wording clear and reviewer-friendly.
- In test plans, log exact commands and include output snippets.
- Keep output verbatim, but trim to only relevant lines for brevity.

## Optional Commit Step

If the user asks to commit after summarizing:

- Inspect local commit title style with `git log -10 .`.
- Follow the dominant local pattern for the title format.
- In this repository, common formats are:
  - `feat: <message>`
  - `chore: <message>`
  - `fix <message>` or short imperative title
- Choose the type/title that matches the intent of the change.
- Keep the body aligned with the summary structure from this skill.
- Do not commit unless the user explicitly asks for it.

## Example Structure (short and flowing)

Our service calls the flag API to resolve country codes by name. During peak traffic we hit API rate limits. Since we support only a limited country set, repeated upstream calls are unnecessary.

We introduced an in-memory pass-through cache with a reasonable TTL so repeated lookups are served locally while data is refreshed periodically.

The cache is implemented as a small utility object store to keep behavior isolated and testable. The flag-request path now uses the cache in middleware before making external API calls.

Critical decisions:
- Chose in-memory cache over external cache for low complexity and fast rollout.
- Used TTL-based refresh to balance freshness with rate-limit protection.
- Limited scope to country-code lookups only.

Run service:

```sh
<command to run service>
```

Hit endpoint twice:

```sh
curl <url>/api/... 
curl <url>/api/...
```

Check logs/metrics for a single upstream request:

```text
# relevant log lines only
flag_api_request country=DE cache=miss
flag_api_request country=DE cache=hit
```

## Output Template

<rationale>
...

<solution>
...

<high_level_technical_details>
...

<assumptions>
...

<test_and_validation>
commands:
```sh
...
```
relevant output (verbatim, shortened):
```text
...
```
