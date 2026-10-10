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
KRI-11 kapatıldı (10 Ekim 2026). Görev düzeni: Claude yönetir/doğrular, Codex uygular.

### Sonraki plan
KRI-12 — Codex'e verilir; sanity + görünür Godot incelemesi + commit/push + iki kopya/remote/ROADMAP doğrulaması.

### Güncel durum
- Kanonik `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper`, ayna `C:\Users\ds\Documents\GitHub\GameDevoloper`; dal `claude/festive-volta-li1sfm`.
- KRI-11: tam sanity 304 PASS / 0 hata / 20 gece. `.import` ve `work/` pakete dahil edilmez.

### Kural
Bu projede her çalıştığında **önce** bu dosyayı ve `AGENTS.md`’yi oku. Her **commit** ve **pull** sonrası bu dosyadaki durum bölümünü güncelle. ROADMAP’te kapattığın adımları `[x]` yap ve satır sonuna `(Claude)` yaz.

Ajan listesi ve kitleri: docs/AJAN_KITLERI.md. Kalfa = Ahmet'in Codex'i (Berk'in Codex'i değil); kimlik: codex.md/Kalfa.md. Başka ajanın [/] sahipliğine dokunma.

### Roller

Bu not mevcut işleyişi bozmaz. Berk tarafında Claude ile Codex arasındaki iç dağıtım kendi aralarında sürer. 9 Ekim 2026’da Ahmet’in onayıyla roller şöyle durur:

- **Muharrir** (Ahmet’in Grok Bot asistanı) sessiz koordinatördür. Ajanların günlük işine karışmaz. Blokları ajanlar arasında bölüştürür, çakışma ve kural uyumunu denetler, pull ve uyum raporlarını yazar. Duyurular `docs/MUHARRIR_RAPORU.md` başındadır; orada yazan bölüşüm ve uyarı geçerlidir.
- **Claude (Berk)** zor ve kapsamlı işleri alır; Codex’in işinin test ve onayını da o yapar.
- **Codex (Berk)** kolay ve orta işleri alır. Zor iş Claude’da kalır; bu, süregelen düzendir.
- **Kalfa** (Ahmet’in Codex’i) Muharrir’in verdiği ayrı bloğu alır. İmzası `(Kalfa)` olur.
- **Cursor ajanları** Muharrir’in verdiği düzeltme ve doğrulama işlerini alır.

Başka ajanın `[/]` sahipliğine dokunulmaz. Bir blok değişikliği gerekirse not `docs/MUHARRIR_RAPORU.md` başına düşülür.

11 Ekim akşamına kadar koordinasyon notu: `docs/KOORDINASYON_DEVIR.md`.

Anlık iletişim: Ajan Masası = GitHub issue #11. Her turun başında `gh issue view 11 --comments` ile son yorumlar okunur; sana (@Codex/@Claude/@Kalfa/@Muharrir/@Cursor) yazılmışsa `gh issue comment 11 --body "[Gönderen → Alıcı] [ETIKET] konu: içerik"` ile cevaplanır. Sahiplik yine ROADMAP `[/]` ile durur; token paylaşılmaz. Mesajlar sade Türkçe ve tek konudur. Başlık `[Gönderen → Alıcı] [ETIKET] konu`. Etiketler: SORU, CEVAP, UYARI, SORUN, BITTI, DEVIR. SORUN’da ne olduğu, hangi dosya veya madde yazılır; insan kararı gerekiyorsa @ahmetbtopcu ve @berk103458 etiketlenir. Çözülen konu `[ÇÖZÜLDÜ]` ile biter. Ayrıntı issue #11’deki ikinci yorumdadır.
