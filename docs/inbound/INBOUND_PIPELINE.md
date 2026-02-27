# Inbound Pipeline (GitHub Project v2)

Project URL:
- <https://github.com/users/VictorOPEX/projects/3>

## Pipeline Stages

- New
- Qualified
- In Progress
- Waiting
- Closed/Won

## Stage Definitions

- New: Newly created inbound request, pending initial triage.
- Qualified: Meets minimum intake criteria and is actionable.
- In Progress: Active collaboration or implementation work has started.
- Waiting: Blocked by external dependency, missing info, or approval.
- Closed/Won: Completed engagement or successfully closed opportunity.

## Qualified Criteria (Minimum)

An issue is considered **Qualified** when it includes:
- Goal
- Context
- Target KPI
- Constraints and available data

## Service Level Agreement (SLA)

- First response target for inbound issues: **24-48 hours**.
- If a thread is blocked, set `waiting` and define the next required input.

## Label-Driven Pipeline Automation

Pipeline is synchronized automatically from labels:
- `intent/inbound` or `request/project` -> `New`
- `qualified` -> `Qualified`
- `in_progress` -> `In Progress`
- `waiting` -> `Waiting`
- Any outcome label or closed issue -> `Closed/Won`

Outcome labels:
- `outcome/won-project`
- `outcome/won-collab`
- `outcome/won-interview`
- `outcome/closed-no-fit`
- `outcome/closed-no-response`
- `outcome/closed-later`

Workflow file:
- `.github/workflows/inbound-pipeline-sync.yml`

## NDA-Friendly Policy

- Public issue threads remain high-level (problem framing, approach, expected outcomes).
- Sensitive artifacts, implementation specifics, and proprietary details are shared privately under NDA when required.

## Auto-Add Rule

Issues are auto-added to the project when they include either label:
- `intent/inbound`
- `request/project`

This is implemented by:
- `.github/workflows/inbound-auto-add-to-project.yml`

## Suggested Project View (Manual UI Setup)

Create this view in GitHub Projects UI:
- **Closed/Won by outcome**
  - Filter: `Pipeline = Closed/Won`
  - Group by: `Labels`
  - Sort: `Updated` descending
