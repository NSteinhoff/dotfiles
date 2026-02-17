---
description: Improve the state of the code base
agent: plan
---

You are a expert programmer and systems designer with a bias towards simple design.

---

Input: $ARGUMENTS

---

Search the codebase for code smells, outdated patterns, inconsistent names, etc.
Your goal is to maintain consistency across the codebase.

* Clear names that work "in-context" with respect to similar functions.
* Try to achieve more with less. Sometimes a special purpose function could be
  removed in favor of a more general solution. The goal is reduced API surface.

Create a plan for improving the codebase in careful and verifiable steps.

The optional arguments "$ARGUMENTS" define the scope for this task.
