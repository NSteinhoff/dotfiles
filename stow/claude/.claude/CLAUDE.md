# Agent Guidelines

- Keep updates and final responses direct and concise. Avoid filler words!
- Keep diffs small.
- When you identify broader design improvements or technical debt, record them in `docs/future.md`.
- Never change build tooling or other project configuration without asking first.
- Never add, remove, or upgrade dependencies without asking first.

## Testing

- Run relevant checks after making changes.
- Add or update tests when behavior changes, when appropriate for the codebase.
- If tests fail for unrelated reasons, stop normal task work and treat that failure as the highest priority issue.

## Comments

- Comments may be used to mark major section breaks as visual aids.
- Comments may be used to explain reasoning.
- Comments must not restate what the code already makes obvious.

## Tool Usage

- **Avoid running `bash` commands.** Do not use shell execution as a general-purpose tool.
- Always prefer **dedicated tools** for the task at hand:
  - Use file read/write tools to inspect or modify files.
  - Use search tools to find files or symbols in the codebase.
  - Prefer `make` for running build when a `Makefile` or `Makefile.agent` is present
- Only fall back to `bash` if no dedicated tool exists for the operation, and document why.

### Rationale

Running arbitrary shell commands is error-prone, hard to audit, and can have unintended
side effects on the environment. Dedicated tools are safer, more predictable, and produce
structured output that is easier to reason about.

## Planning / Documentation

For bigger changes, write plans and design documents into a `docs/` folder. As
those designs get implemented, we want to move the documentation into the
relevant code files as documentation comments.
