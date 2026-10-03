# Installs the game-dev and coding Claude Code plugins used by this project.
# Run from the repo root: powershell -ExecutionPolicy Bypass -File scripts\install-claude-plugins.ps1
# Same list as scripts/install-claude-plugins.sh.

$marketplaces = @(
  'anthropics/claude-plugins-official',
  'gamedev-skills/awesome-gamedev-agent-skills',
  'alirezarezvani/claude-skills',
  'anthropics/skills'
)

$plugins = @(
  # Game development
  'gamedev@awesome-gamedev-agent-skills',
  'unity@claude-plugins-official',
  'unreal-engine-skills-for-claude-code@claude-plugins-official',

  # Coding workflow
  'superpowers@claude-plugins-official',
  'feature-dev@claude-plugins-official',
  'code-review@claude-plugins-official',
  'pr-review-toolkit@claude-plugins-official',
  'code-simplifier@claude-plugins-official',
  'commit-commands@claude-plugins-official',
  'security-guidance@claude-plugins-official',
  'frontend-design@claude-plugins-official',
  'context7@claude-plugins-official',
  'playwright@claude-plugins-official',
  'hookify@claude-plugins-official',
  'skill-creator@claude-plugins-official',
  'claude-md-management@claude-plugins-official',
  'mcp-server-dev@claude-plugins-official',

  # Language servers
  'csharp-lsp@claude-plugins-official',
  'clangd-lsp@claude-plugins-official',
  'lua-lsp@claude-plugins-official',
  'typescript-lsp@claude-plugins-official',
  'pyright-lsp@claude-plugins-official',
  'rust-analyzer-lsp@claude-plugins-official',

  # alirezarezvani/claude-skills (engineering subset)
  'engineering-skills@claude-code-skills',
  'engineering-advanced-skills@claude-code-skills',
  'karpathy-coder@claude-code-skills',
  'zero-hallucination-coder@claude-code-skills',
  'code-tour@claude-code-skills',
  'pw@claude-code-skills',

  # Anthropic example skills
  'example-skills@anthropic-agent-skills'
)

foreach ($m in $marketplaces) {
  claude plugin marketplace add $m
  if ($LASTEXITCODE -ne 0) { Write-Warning "marketplace failed: $m" }
}

foreach ($p in $plugins) {
  claude plugin install $p --scope project
  if ($LASTEXITCODE -ne 0) { Write-Warning "plugin failed: $p" }
}
