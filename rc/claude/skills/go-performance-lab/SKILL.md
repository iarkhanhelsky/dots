---
name: go-performance-lab
description: Investigate and fix Go latency, CPU, or memory regressions with benchmark and profile evidence.
disable-model-invocation: true
---

# Go Performance Lab

Use this skill when performance regresses or optimization is requested.

## When Not to Use

- No measurable performance target or regression signal.
- Refactors with no expected runtime impact.

## Reproducibility Checklist

- Use stable machine/load state and keep benchmark target fixed.
- Record Go version, commit SHA, OS/arch, CPU model, and `GOMAXPROCS`.
- Use repeated samples before making claims.

## Process

1. Reproduce issue with a stable benchmark or load scenario.
2. Capture baseline metrics (latency, throughput, alloc/op, B/op).
3. Collect profile evidence (`pprof`) before changing code.
4. Implement the smallest high-impact change.
5. Re-run the same benchmarks/profiles and compare before vs after.
6. Use statistical comparison for benchmark deltas.

## Evidence Requirements

- Benchmark output before and after.
- Statistical comparison output (`benchstat`) for benchmark runs.
- Profile hotspot evidence (`top` plus symbol-level `list` or flamegraph summary).
- Clear statement of metric deltas and tradeoffs.

## Suggested Commands

```sh
go test -run=^$ -bench=<target> -benchmem -count=10 -benchtime=1s ./path/to/pkg > before.txt
go test -run=^$ -bench=<target> -cpuprofile=cpu.out -memprofile=mem.out ./path/to/pkg
go tool pprof -top cpu.out
go tool pprof -list <func> cpu.out
go tool pprof -top mem.out
go test -run=^$ -bench=<target> -benchmem -count=10 -benchtime=1s ./path/to/pkg > after.txt
benchstat before.txt after.txt
```

Optional PGO loop:

```sh
go build -pgo=default.pgo ./...
```

Use PGO only with representative profile data.

## Output Format

1. Baseline metrics
2. Bottleneck diagnosis
3. Change and rationale
4. Post-change metrics
5. Residual risks
