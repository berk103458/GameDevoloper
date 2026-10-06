# User project rules

These explicit user instructions take precedence over conflicting collaboration or approval guidelines in CLAUDE.md and other project documents.

- Project working copy: C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper
- Required local mirror: C:\Users\ds\Documents\GitHub\GameDevoloper
- Automatically transfer every change made for the user in this project to the required local mirror, including code, assets, configuration, documentation, new files, renames, and deletions. Do this during the task and before reporting completion; never wait for a commit prompt or separate transfer approval.
- Apply synchronization to the files changed by the task. Preserve unrelated local work. Do not blindly replace the entire checkout, its .git directory, branch, or history. If the same file has independent changes, reconcile them and preserve both intended changes; ask only when a real conflict requires the user's decision.
- Do not create commits or push merely because files were synchronized. When the user says "commit" (including "comit" or "commitle"), that instruction authorizes committing all pending project changes and pushing them to the configured GitHub remote. Inspect the changes and repository state first, include the complete requested changeset, and never force-push unless explicitly authorized.
- Keep these rules in both copies whenever updating them.
