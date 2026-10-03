#!/usr/bin/env bash
# Installs the game-dev and coding Claude Code plugins used by this project.
# Run from the repo root on a machine with the `claude` CLI: bash scripts/install-claude-plugins.sh
set -u

marketplaces=(
  anthropics/claude-plugins-official
  gamedev-skills/awesome-gamedev-agent-skills
  alirezarezvani/claude-skills
  anthropics/skills
)

plugins=(
  # Game development
  gamedev@awesome-gamedev-agent-skills                  # router + 74 skills: Godot, Unity, Unreal, Phaser, three.js, Bevy, Roblox, genres
  unity@claude-plugins-official                         # Unity's official plugin
  unreal-engine-skills-for-claude-code@claude-plugins-official  # Epic's Unreal Editor MCP + skills

  # Coding workflow
  superpowers@claude-plugins-official                   # TDD, systematic debugging, plans, subagent-driven dev
  feature-dev@claude-plugins-official
  code-review@claude-plugins-official
  pr-review-toolkit@claude-plugins-official
  code-simplifier@claude-plugins-official
  commit-commands@claude-plugins-official
  security-guidance@claude-plugins-official
  frontend-design@claude-plugins-official
  context7@claude-plugins-official                      # up-to-date library/engine docs
  playwright@claude-plugins-official                    # browser testing for web games
  hookify@claude-plugins-official
  skill-creator@claude-plugins-official
  claude-md-management@claude-plugins-official
  mcp-server-dev@claude-plugins-official

  # Language servers (C# for Unity/Godot, C++ for Unreal, Lua for LOVE/Roblox, ...)
  csharp-lsp@claude-plugins-official
  clangd-lsp@claude-plugins-official
  lua-lsp@claude-plugins-official
  typescript-lsp@claude-plugins-official
  pyright-lsp@claude-plugins-official
  rust-analyzer-lsp@claude-plugins-official

  # alirezarezvani/claude-skills (engineering subset)
  engineering-skills@claude-code-skills
  engineering-advanced-skills@claude-code-skills
  karpathy-coder@claude-code-skills
  zero-hallucination-coder@claude-code-skills
  code-tour@claude-code-skills
  pw@claude-code-skills

  # Anthropic example skills (webapp-testing, mcp-builder, ...)
  example-skills@anthropic-agent-skills
)

for m in "${marketplaces[@]}"; do
  claude plugin marketplace add "$m" || echo "!! marketplace failed: $m"
done

for p in "${plugins[@]}"; do
  claude plugin install "$p" --scope project || echo "!! plugin failed: $p"
done
