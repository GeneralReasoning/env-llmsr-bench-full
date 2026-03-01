# LLM-SR Bench

[![OpenReward Environment](https://img.shields.io/badge/%E2%AD%90%20OpenReward-Environment-f7e6cc)](https://openreward.ai/GeneralReasoning/llmsr-bench-full)

## Description

**LLM-SR Bench** (Large Language Model Symbolic Regression Benchmark) is an environment for evaluating language model agents on scientific equation discovery tasks. Agents are given experimental data and must discover the underlying mathematical equation that describes the relationship between variables. The benchmark is designed to prevent trivial memorization by transforming familiar physical models into uncommon mathematical forms.

This OpenReward implementation is ported from the [Harbor Framework](https://harborframework.com/) by [Ziyu She](https://github.com/SheZiyu).

## Capabilities

- Scientific equation discovery from experimental data
- Symbolic regression and mathematical reasoning
- Data analysis and pattern recognition
- Physical and mathematical modeling across multiple domains
- Autonomous exploration of data files in sandbox environment

## Compute Requirements

Agents are given a sandbox with configurable CPU and memory based on task requirements. Default allocation is 1 CPU and 2GB RAM, scaling up to 4 CPU and 16GB RAM for computationally intensive tasks.

## License

[MIT](https://opensource.org/license/mit)

## Tasks

There is one split in this environment:

- **test**: 240 equation discovery tasks

Tasks span 5 scientific domains:

**Biology (24 tasks)**
- Population Growth (bio_pop_growth): Dynamical systems modeling population dynamics

**Chemistry (36 tasks)**
- Chemical Reactions (chem_react): Reaction kinetics and rate equations

**Physics (155 tasks)**
- LSR-Transform I/II/III (111 tasks): Physics equations from Feynman Lectures transformed into uncommon forms
- Physical Oscillations (44 tasks): Harmonic motion and wave equations

**Materials Science (25 tasks)**
- MatSci: Physical property predictions and materials equations

Each task provides training data (CSV files) with input/output variables. Agents must analyze the data, hypothesize relationships, and write an equation to `/workspace/discovered_equation.txt`. Scalar constants (e.g., `c0`, `k`, `beta`) can be introduced and are automatically fitted during evaluation.

## Reward Structure

This is a dense, verifiable reward environment. Rewards are computed when the agent submits their answer:

- **R²** (coefficient of determination): Primary reward metric, ranges 0.0 to 1.0
- **1.0**: Perfect fit (R² >= 0.95 is rounded to 1.0 to handle numerical precision)
- **0.0**: No predictive power

Additional metrics are logged:
- **MSE**: Mean squared error
- **NMSE**: Normalized MSE (MSE / Var(y_true))
- **n_fitted_params**: Number of auto-fitted constants

No LLM grader is used. Evaluation uses scipy optimization to fit scalar constants, then computes R² on held-out test data.

## Data

Each task contains:
- `train_data.csv`: Training data for equation discovery
- `test_data.csv`: Held-out test data for scoring
- `ood_test_data.csv`: Optional out-of-distribution test data
- `instruction.md`: Task description with variable definitions

Data format: CSV files where the last column is the output variable and earlier columns are inputs. Variable names must be used exactly as they appear in the CSV header.

## Tools

Agents have access to 5 tools:

- **bash**: Execute bash commands in the sandbox
- **view**: View file contents or directory listings (with optional line ranges)
- **str_replace**: Replace strings in files (for editing)
- **create_file**: Create new files with specified content
- **submit_answer**: Submit the discovered equation for evaluation

## Time Horizon

LLM-SR Bench is a multi-turn environment where agents iteratively explore data, test hypotheses, and refine equations before submission.

[Statistics on average tool calls here]

## Environment Difficulty

The original paper reports that the best-performing system achieves 31.5% symbolic accuracy on the benchmark, indicating substantial difficulty in scientific equation discovery.

[Additional statistics on environment difficulty here]

## Other Environment Requirements

LLM-SR Bench requires an OpenReward API key for sandbox access:

- **api_key**: Required in secrets parameter for OpenReward sandbox API

Export it before running:

```bash
export OPENREWARD_API_KEY=your_api_key_here
```

Pass the key via the secrets parameter when creating a session:

```python
async with environment.session(task=task, secrets={"api_key": OPENREWARD_API_KEY}) as session:
```

## Safety

LLM-SR Bench tasks are run in isolated sandbox environments. Agents interact only with pre-defined scientific data files and cannot affect external systems. The environment focuses on mathematical equation discovery and does not involve safety-sensitive domains.

## Citations

This environment implements the LLM-SRBench benchmark. If you use this environment, please cite the original paper:

```bibtex
@inproceedings{shojaee2025llmsrbench,
  title     = {LLM-SRBench: A New Benchmark for Scientific Equation Discovery with Large Language Models},
  author    = {Shojaee, Parshin and Nguyen, Ngoc-Hieu and Meidani, Kazem and Farimani, Amir Barati and Doan, Khoa D and Reddy, Chandan K},
  booktitle = {Proceedings of the 42nd International Conference on Machine Learning (ICML)},
  year      = {2025}
}
```
