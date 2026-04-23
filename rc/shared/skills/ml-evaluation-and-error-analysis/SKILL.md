---
name: ml-evaluation-and-error-analysis
description: Evaluate classical ML models with robust error analysis, threshold tuning, calibration, and subgroup checks.
disable-model-invocation: true
---

# ML Evaluation and Error Analysis

Use this skill when validating model improvements or investigating failures.

## When Not to Use

- Early exploration before a baseline exists.
- Situations where candidate and baseline are not evaluated on comparable data.

## Inputs Required

- Dataset split definition and leakage controls.
- Primary metric aligned with business objective.
- Baseline model results for comparison.

## Evaluation Checklist

- Report aggregate metrics on validation and test sets.
- Report uncertainty for primary metrics (confidence intervals or repeated-fold variance).
- Build confusion matrix or equivalent error decomposition.
- Analyze top error buckets with concrete feature patterns.
- Evaluate subgroup performance for fairness and stability, including worst-group behavior.
- Ensure subgroup slices have minimum support; flag underpowered slices.
- Tune decision threshold against explicit business cost tradeoffs and operating constraints.
- Check calibration quality where probabilities are consumed (for example ECE/Brier/reliability curve).

## Decision Rule

- Recommend go/no-go with explicit risk statement.
- Reject improvements that do not beat baseline with stable evidence.
- Reject candidates with critical subgroup regression or unacceptable calibration/threshold tradeoffs.

## Output Format

1. Baseline vs candidate metrics
2. Error bucket analysis
3. Subgroup and calibration findings
4. Threshold recommendation
5. Go/no-go decision and risks
