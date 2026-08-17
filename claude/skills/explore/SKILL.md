---
name: explore
description: Guided exploration of a new technical topic via strict L0–L3 layering — one-paragraph gist, component map, then per-branch descent on request only. Each step ends with a menu of candidate questions. Ends with a scored recall recap and a persistent mental-model doc. Use when the user invokes /explore <topic>, or says they want to "learn", "explore", or "understand" a new tool, system, concept, or codebase.
---

# Explore — layered topic exploration (v0.8)

Guide the user through a new technical topic. Primary enemy: **overwhelm at the start**. Never dump breadth and depth at once. The per-step budget (below) is the anti-overwhelm guarantee — it never grows, no matter how much you could anticipate.

## 0. Setup (one exchange)

Ask only two things, in one message:
1. **Goal** — why this topic? (evaluate it / use it / operate it / pure understanding). Every later descent is judged against this.
2. **Prior anchors** — 1–2 things they already know that are adjacent (used for comparisons).

If a previous exploration doc exists in `~/notes/explorations/`, run a 2-minute **warm-up recall** on the most recent topic first:
1. Ask the user to reproduce its L1 map from memory, score it (`recall: X/Y nodes`), append the score to that topic's doc.
2. **Parked-term sweep**: quiz each still-PARKED term from that doc ("define <term> in one line"). Pass → status RESOLVED(warm-up <date>); fail → stays PARKED and becomes a first-choice descent candidate for this session's menu.

Then state the layer contract: "I'll give L0, then an L1 map. You pick which branch to descend. Nothing expands until you ask."

## 1. Layer rules

| Layer | Content | Hard limits |
|---|---|---|
| L0 | One-paragraph gist: what it is, what problem it kills, one anchor comparison | ≤5 sentences, **≤7 new terms total**, each new term bolded on first use |
| L1 | Component map as an ASCII diagram + one line per component | One screen. No mechanism explanations yet. |
| L2 | Mechanisms of ONE branch the user picked | Other branches stay collapsed. ≤7 new terms again. |
| L3 | Internals/edge cases of one L2 element | Only on explicit request. Warn if it doesn't serve the stated goal. |

Rules that apply at every layer:
- **Budget is hard**: max 7 new terms and one screen per layer-step, regardless of anticipation. If the honest explanation needs more, split the step.
- **Term-closed clarifications**: when the user asks what a term means, define it using ONLY already-introduced terms or plain language — a clarification must never import new unknown terms. If an honest definition needs deeper concepts, answer: "that lives at L2/L3 of <branch> — park it or descend?" Guide the user's side too: drill a term only if it blocks the current layer (load-bearing); never clarify a clarification — second unknown term ⇒ park both and return to track. Parked terms usually self-resolve on descent.
- **Descent is user-driven**: never auto-descend.
- **The menu**: end every layer-step with (a) the branch list and (b) 2–3 **candidate questions** the user might ask next. Anticipation improves menu *selection and ordering*, never step *volume* — a learned question becomes one menu line, its answer stays behind the user's pick.
- **Menu learning / promotion ladder**: a question the user asked unprompted once → future menu candidate. A question class recurring across ≈every topic → answered unprompted inside the layer template — and something else gets demoted, because the budget stays constant.
- **Goal guard**: if a requested descent doesn't serve the stated goal, say so in one line, offer to park it — but obey an override without argument.
- **Parking lot**: the user says "park <term>" (or the two-deep rule triggers it) → append it to the doc's parked table immediately, with context. **Resolve-on-descent**: when a later descent reaches a parked term, announce "resolves parked: <term>" and flip its status.
- **Diagram delivery**: the user works in a plain terminal. Draw every diagram as ASCII/Unicode box-drawing in a plain code fence, ≤ ~80 columns. No mermaid fences in responses; mermaid is allowed only inside the saved doc.
- Anchor to the user's stated prior knowledge when a comparison genuinely fits; skip forced analogies.

## 2. Recap ritual (mandatory before ending)

When the user says they're done (or the session is clearly wrapping up):
1. Ask them to **reconstruct the L1 map from memory** — component names + edges, rough text form is fine.
2. Diff their reconstruction against the real map. Report: ✅ correct, ❌ missing, 🔀 wrong relationship.
3. **Store the score** in the doc header: `recap: X/Y nodes, Z edges wrong`. Scores are the outer loop's evidence — never skip storing them.
4. Every ❌/🔀 becomes an entry in the doc's *Weak spots* section.

If the user refuses the recap, note that in the doc.

## 3. Mental-model doc

Write to `~/notes/explorations/<topic-slug>.md` (create the directory if missing). Template:

```markdown
# <Topic>
Goal: <stated goal> | Explored: <date> | Depth reached: <e.g. L2:brokers, L1 elsewhere>
Scores: recap <X/Y nodes> | warm-up recalls: <date: X/Y, ...>

## Gist (L0)
<the final agreed one-paragraph gist>

## Map (L1)
<diagram — mermaid allowed here>

## Mechanisms explored (L2/L3)
<one compact subsection per descended branch — invariants, not narration>

## Weak spots (from recap diff)
- <what the user missed or got wrong>

## Open questions / parked
| Term | Met at | Why parked | Status |
|---|---|---|---|
| <term> | <layer:branch> | <reason> | PARKED / RESOLVED(<how, date>) |
```

## 4. Signal logging (inner loop — micro only)

Signals persist in `LOG.md` next to this file. Log the moment a signal occurs (silently, no announcement). Classify the user's **message**, never their mental state.

Categories:
- `signal` — training data for menu learning, NOT a defect: a topic question the menu didn't offer (gap), or a re-ask. Feeds the promotion ladder in §1.
- `override` — user overrode a rule in this file → my behavior needs fixing.
- `format` — output-format problem (diagram, table, verbosity) → my behavior needs fixing.
- `pace` — explicit overwhelm or boredom ("too much", "skip this", "slow down").

Entry format: `| YYYY-MM-DD | type | one-line observation | OPEN |`

At session end, review OPEN entries with the user → each becomes an applied micro-Δ (version bump), or WONTFIX. Never delete entries.

**Scope limit**: this path may change wording, format, menus, and pacing ONLY. It may never change the methodology (the L0–L3 architecture, budget, recap design). Methodology changes belong exclusively to the outer loop: after ~every 5 explorations, the user invokes `/explore-review` (see the explore-review skill), which writes proposals to `PROPOSALS.md` in this directory. Apply nothing from there without the user's explicit approval.
