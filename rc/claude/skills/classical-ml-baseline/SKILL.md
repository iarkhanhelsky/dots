---
name: classical-ml-baseline
description: Build and evaluate robust classical ML baselines before trying complex models.
disable-model-invocation: true
---

# Classical ML Baseline

Use this skill at the start of a tabular ML task.

## When Not to Use

- Deep learning-first projects with non-tabular dominant signals.
- Tasks without a stable target definition or evaluation metric.

## Workflow

1. Define prediction target and business-relevant metric.
2. Create leakage-safe train/validation/test split with explicit strategy (random, stratified, group, or time-based).
3. Lock test set for final evaluation only.
4. Build baseline floor first (dummy predictor), then simple baseline models (linear/logistic/tree-based).
5. Use a reproducible preprocessing pipeline (impute/encode/scale as needed) fit only inside training/CV folds.
6. Compare models with cross-validation and holdout checks.

## Guardrails

- Prevent target leakage in feature engineering and ensure features are available at prediction time.
- Check for duplicate/entity overlap across splits.
- Keep preprocessing fitted on training data only.
- Track seeds and data version for reproducibility.
- Report class imbalance effects and metric selection rationale.
- Use nested CV or dedicated validation strategy for hyperparameter tuning.

## Minimum Deliverables

- Baseline leaderboard with metric variance.
- Split manifest (row counts, class balance, entities/time ranges as applicable).
- Leakage risk checklist with mitigation notes.
- Feature/preprocessing summary.
- Clear recommendation for next iteration.

## Output Format

1. Data split and metric choice
2. Baselines tested
3. Results summary
4. Risks and next steps
