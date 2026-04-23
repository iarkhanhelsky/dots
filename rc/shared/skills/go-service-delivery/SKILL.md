---
name: go-service-delivery
description: Apply when changing production Go service runtime behavior across handlers, business logic, or storage boundaries.
---

# Go Service Delivery

Use this skill when changing production Go service behavior.

## When to Use

- HTTP/gRPC handler logic changes.
- Business logic changes that affect runtime behavior.
- Storage, retry, timeout, or cancellation path changes.

## When Not to Use

- Docs, formatting, or rename-only updates.
- CI/config-only changes unrelated to runtime behavior.
- Non-service helper scripts.

## Coding Rules

- Thread `context.Context` through service and storage boundaries with `ctx` as first arg.
- Never store `context.Context` in struct fields and never pass `nil` context.
- Return wrapped errors with `%w`, and use `errors.Is`/`errors.As` for branching behavior.
- Keep APIs small and explicit; prefer simple data structures over clever abstractions.
- Handle timeouts and cancellation at IO boundaries.
- Avoid global mutable state unless guarded and justified.
- Log errors at boundaries; avoid duplicate logs for the same failure path.

## Quality Gates

- Add table-driven tests for business logic and edge cases.
- Add integration tests where contract or persistence behavior changes.
- Add timeout/cancellation tests when context flow changes.
- Keep tests deterministic (no hidden dependency on time/network randomness).
- Run standard checks before finalizing changes.

## Suggested Commands

```sh
go test ./...
go test -race ./...
go vet ./...
```

## Output Format

1. Functional changes
2. Safety and failure-mode notes
3. Test evidence
