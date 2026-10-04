# Session State

- **Task**: girdi-ve-odak-gezinmesi GDD
- **Status**: Complete — Designed (pending /design-review in a fresh session)
- **File**: design/gdd/girdi-ve-odak-gezinmesi.md
- **Sections**: Summary, Overview, Detailed Design (Core Rules 1–22, States, Interactions), Formulas (F1 mod değişimi, F2 tekrar), Edge Cases, Dependencies, Acceptance Criteria (48), Open Questions
- **Decisions**: tek odak (hover=normal stil, mouse_entered→grab_focus); kısayollar her zaman iki adımlı; Esc yalnız `geri`, `menu` = P/Start; gamepad kısayolu MVP'de yok; bozuk tuş ataması oyunu durdurmaz
- **Pending user confirmation**: gamepad kısayolu yok; bozuk atama dosyası davranışı
- **Previously done**: oyun-durumu-ve-gun-dongusu (#1), icerik-veri-hatti (#2) — both Designed, pending review
- **Next**: Karakter kadrosu (#4 in design order)

- **Current**: karakter-kadrosu GDD skeleton created. Decisions: 6 named (Miraen, Sorhan, Thessra foreign + 3 local), adsız sınıf figürleri fill nights, one return rule per named character. Waiting on narrative-director + systems-designer drafts.
