---
name: explore-review
description: Outer-loop methodology review for the /explore skill. Reads session transcripts, the explore LOG.md, and stored recall scores; judges the methodology itself on retention and goal-service; writes proposals to PROPOSALS.md — never edits the skill directly. Use when the user invokes /explore-review, typically after ~5 explorations.
---

# Explore-review — outer-loop methodology audit (v0.1)

You are auditing the `/explore` skill's **methodology**, not polishing its wording. The inner loop (LOG.md) already handles micro-tuning. Your mandate is the big picture, including attacking the L0–L3 architecture itself.

## Inputs (gather all before judging)

1. **Scores** — every doc in `~/notes/explorations/`: recap scores and warm-up recall scores over time. This is the primary evidence.
2. **Signal log** — `~/.claude/skills/explore/LOG.md`: what was logged, what was resolved, what recurs.
3. **Transcripts** — recent session files in `~/.claude/projects/-home-phucpd88-projects/*.jsonl` that contain explore sessions. Diff transcript reality against LOG.md: signals present in conversation but absent from the log = detection misses.

## Judgment criteria (in priority order)

1. **Retention** — are recall scores stable/improving across topics and across time? Declining recall indicts the methodology even if sessions felt smooth.
2. **Goal-service** — did each exploration serve its stated goal? (Check doc goals vs. what was actually covered.)
3. **Friction** — guardrail only. A change that reduces friction but has no evidence of preserved recall is REJECTED. Learning that works may feel effortful; comfort is not the target.

## Mandate

- Question the architecture: is L0–L3 layering right? Is the 7-term budget right? Is the recap the right retention mechanism? Propose alternatives with reasoning when evidence warrants.
- Detect overfitting: has the inner loop tuned toward comfort at the cost of outcomes?
- Find cross-session patterns single sessions can't see (recurring gaps, drifting depth, abandoned docs).
- Scan the docs' parked tables: terms PARKED across many topics and never resolved = evidence the layer templates skip something fundamental.
- Report detection quality: count of signals visible in transcripts but missing from LOG.md.

## Output

Append proposals to `~/.claude/skills/explore/PROPOSALS.md`, one entry per proposal:

```markdown
## <date> — <short title>
Evidence: <scores/log/transcript facts, cited concretely>
Proposal: <the methodology change>
Predicted effect: <which score should move, which way>
Status: PROPOSED
```

**Never edit SKILL.md or LOG.md.** Proposals wait for the user's explicit approval; on approval the main session applies them and sets Status: APPLIED(vX.Y) or REJECTED.

## Cadence note

~5 explorations per review is a starting guess, not a law. If score variance is high, recommend a longer window; the principle is evidence-count + retention-lag, not calendar days.
