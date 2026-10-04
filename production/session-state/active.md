# Session State

- **Task**: karakter-kadrosu GDD
- **Status**: Complete — Designed (pending /design-review in a fresh session); QA findings applied (34 ACs)
- **File**: design/gdd/karakter-kadrosu.md
- **Decisions**: 6 named (Miraen, Sorhan, Thessra, Karaca Usta, Aydoğdu, Saruca Hatun); adsız sınıf şablonları; F1 azalan dönüş p0=0.6 d=0.5 k_azami=4; F2 2–4 gece; F3 Sorhan 3 / Saruca 2; kaldı/gitti eşlemesi Karar (7)'ye; two RNG streams (dönüş, ad)
- **Open**: Osmanoğulları anakronizmi (Sonlar 15); imza şekilleri art-director onayı bekliyor
- **Previously done**: #1 oyun durumu, #2 içerik veri hattı, #3 girdi ve odak — Designed
- **Next**: Ayarlar ve erişilebilirlik (17) — user requested; then Barlar (8)
- **Done**: ayarlar-ve-erisilebilirlik GDD (#17) — Designed; MVP subset: ses, ekran modu, metin ölçeği, belirme hızı; VS: tuş atama, iki adımlı onay, imleç, azaltılmış hareket, ekran okuyucu. QA applied (24 ACs, injected storage + window adapter, key classes etkin/bilinen-pasif/bilinmeyen).
- **Next**: Barlar (8)

## Prototype: kapi-dongusu-concept
- **Phase**: 6 — Playtest debrief (built, auto-run OK on Godot 4.7.2 under xvfb; waiting for user to play)
- **Path**: Engine (Godot), separate project in prototypes/kapi-dongusu-concept/
- **Hypothesis**: Önce sohbet sonra karar → kararlar ağır, bar kırılınca "bir gece daha"
- **Assumptions**: bars break at 0 and 10; rüşvet/kışla = kaldı; rüşvet hakkı auto-spent
- **Tooling**: Godot 4.7.2 linux binary at /tmp (session-local), xvfb-run + opengl3 for screenshots
