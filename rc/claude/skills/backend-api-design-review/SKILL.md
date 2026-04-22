---
name: backend-api-design-review
description: Review HTTP API endpoint contracts for method semantics, status/error consistency, authorization boundaries, idempotency, and test gaps.
---

# Backend API Design Review

Use this skill for HTTP endpoint contract design or review.

## When to Use

- New API endpoint or endpoint contract changes.
- Status code and error model design.
- Idempotency, retries, or pagination behavior design.

## When Not to Use

- Internal-only refactors with no contract change.
- Database migration-only work.
- Frontend-only changes.

## Apply Checklist

- Model resources with nouns and stable URI patterns.
- Use HTTP methods semantically (`GET`, `POST`, `PUT`/`PATCH`, `DELETE`).
- Define request/response contracts explicitly, including required fields.
- Standardize error shape and map domain errors to clear status codes.
- Add pagination/filter/sort conventions for list endpoints.
- Require idempotency strategy for non-idempotent writes where retries may happen.
- Confirm authentication and authorization checks and input validation boundaries.
- Mark contract changes as breaking or non-breaking, and define compatibility plan.
- Define non-functional behavior for timeout budget, rate limits, and correlation IDs.

## Test Expectations

- Contract tests for response shape and status codes.
- Validation tests for malformed and boundary inputs.
- Authorization tests for allowed/denied actor paths.
- Pagination/filter tests for deterministic behavior.

## Output Format

1. Contract decisions
2. Risks or ambiguities
3. Test coverage gaps
4. Compatibility notes (only for contract changes)
