---
name: rails-query-performance
description: Diagnose and improve Rails endpoint and query performance using evidence-driven DB and application tuning.
disable-model-invocation: true
---

# Rails Query Performance

Use this skill when Rails endpoints are slow, query-heavy, or allocation-heavy.

## When Not to Use

- Feature-only changes without performance symptoms.
- Changes where baseline metrics cannot be measured.

## Baseline Metrics

Capture these before and after changes:

- Endpoint latency (`p50`/`p95`).
- SQL query count and total query time.
- Allocation/object pressure for the endpoint path.

## Process

1. Measure baseline endpoint/query behavior with a stable workload.
2. Localize bottleneck as DB/query, app/serialization, or transaction/locking issue.
3. Apply minimal targeted fixes.
4. Re-measure with the same workload and validate no behavior regressions.

## Query Checklist

- Detect and remove N+1 patterns with appropriate eager loading.
- Select only required columns (`select`, `pluck`) where possible.
- Verify indexes for frequent filter/sort/join patterns.
- Avoid loading large collections into memory; batch with `find_each` when needed.
- Check transaction scope and locking behavior on write paths.
- Validate key queries with `EXPLAIN (ANALYZE, BUFFERS)` where available.

## Suggested Tools

- Rails logs and query timings
- `EXPLAIN (ANALYZE, BUFFERS)` for key queries
- `ActiveSupport::Notifications` for endpoint/query instrumentation
- `rack-mini-profiler` and `bullet` when available

## Output Format

1. Baseline measurements
2. Hotspot findings
3. Optimizations applied
4. Post-change measurements
5. Follow-up recommendations
