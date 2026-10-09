# Claude Code Game Studios -- Game Studio Agent Architecture

> **Agents:** Before any work, read `AGENTS.md` (Kapı Muhafızı — çoklu ajan ve geliştirici çalışma ilkeleri).

Indie game development managed through 49 coordinated Claude Code subagents.
Each agent owns a specific domain, enforcing separation of concerns and quality.

## Technology Stack

- **Engine**: Godot 4.7.2
- **Language**: GDScript
- **Version Control**: Git with trunk-based development
- **Build System**: SCons (engine), Godot Export Templates
- **Asset Pipeline**: Godot Import System + custom resource pipeline

> **Note**: Engine-specialist agents exist for Godot, Unity, and Unreal with
> dedicated sub-specialists. Use the set matching your engine.

## Project Structure

@.claude/docs/directory-structure.md

## Engine Version Reference

<!-- ENGINE-REFERENCE-IMPORT: the line below is engine-specific. /setup-engine
     rewrites it to @docs/engine-reference/<engine>/VERSION.md for the chosen
     engine, so a Unity or Unreal project stops loading the Godot reference every
     session. It defaults to Godot (the template's example engine); skills that
     need the pinned version read docs/engine-reference/<engine>/VERSION.md on
     demand regardless of this import. -->
@docs/engine-reference/godot/VERSION.md


## Technical Preferences

`project.yaml` at the repo root is the primary config store — engine, specialists,
naming, platform, performance, modes. Skills resolve it via `resolve_config`
(see `.claude/docs/config-resolution.md`).

`.claude/docs/technical-preferences.md` is the **legacy fallback**, read on demand
when a key is absent from `project.yaml`. It is no longer imported here: before
`/setup-engine` runs it is almost entirely `[TO BE CONFIGURED]` placeholders, and
after it runs `project.yaml` holds the real values.

## Coordination Rules

@.claude/docs/coordination-rules.md

## Collaboration Protocol

**User-driven collaboration, not autonomous execution.**
Every task follows: **Question -> Options -> Decision -> Draft -> Approval**

- Agents MUST ask "May I write this to [filepath]?" before using Write/Edit tools
- Agents MUST show drafts or summaries before requesting approval
- Multi-file changes require explicit approval for the full changeset
- No commits without user instruction

See `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` for full protocol and examples.

> **First session?** If the project has no engine configured and no game concept,
> run `/start` to begin the guided onboarding flow.

## Coding Standards

@.claude/docs/coding-standards.md

## Context Management

Read `.claude/docs/context-management.md` on demand — it is a reference, not
session context. Two of its conventions are load-bearing and cited by name
elsewhere in the repo, so they are restated here rather than lost:

- **`production/session-state/active.md` is the session checkpoint.** The file is
  the memory, not the conversation. Read it first after any compaction, crash, or
  `/clear`.
- **Helpers in `.claude/scripts/` emit observations, never verdicts.** A script
  that scores or judges will eventually contradict a mode or override it cannot
  see. (Cited by `artifact-check.sh` and `adr-dep-graph.sh`.)

---

## Claude — Çalışma günlüğü (Kapı Muhafızı)

### Kimlik
Claude — kod / entegrasyon ajanı (Godot GDScript, festive dalı).

### Şu an üzerinde çalışılan
HAR-12 doğrulandı ve kapatıldı (9 Ekim 2026). Görev düzeni: Codex yönlendirir/inceler, Claude uygular (kullanıcı talimatı).

### Sonraki plan
HAR-13 — Gözcü ertesi gün kafile/heyet önizlemesi: mevcut `GozcuOngoru` ve harita bilgi alanı genişletilir; RNG/stok/kasa/makbuz değişmez, gizli CHR kimliği gösterilmez, ikinci öngörü/HUD yok.

### Güncel durum
- Kanonik kopya `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper`, ayna `C:\Users\ds\Documents\GitHub\GameDevoloper`; dal `claude/festive-volta-li1sfm`, HEAD `e95e1dc` (HAR-11).
- HAR-12: birim + headless UI geçti; tam sanity 275 PASS / 0 hata / 20 gece (`work/claude_har12/`). Kod yeniden yazılmadı; asset gerekmedi.
- Commit/push kullanıcı onayı bekliyor. `.import` farkları pakete dahil edilmez.

### Kural
Bu projede her çalıştığında **önce** bu dosyayı ve `AGENTS.md`’yi oku. Her **commit** ve **pull** sonrası bu dosyadaki durum bölümünü güncelle. ROADMAP’te kapattığın adımları `[x]` yap ve satır sonuna `(Claude)` yaz.
