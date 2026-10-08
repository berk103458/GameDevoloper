# Cursor — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Cursor — Godot doğrulama ve ince adaptör. Bu turda ROADMAP boşluk doğrulaması: KAP-02, KAP-03, MEV-01, BUG-11, TUC-11, TUC-14.

## Şu an üzerinde çalışılan
KAP-02, KAP-03, MEV-01, BUG-11, TUC-11, TUC-14 `[/] üzerindeyim (Cursor)`. TUC-12 ve Codex'in CAS dosyalarına dokunulmuyor. Yeni özellik yok.

## Sonraki plan
Kod kanıtını yazıp maddeleri `[x] (Cursor)` kapatmak veya kalan gerçek eksiği ROADMAP notuna işlemek.

## Güncel durum
- Dal: `cursor/roadmap-gap-verify-0b16`, taban `claude/festive-volta-li1sfm` (`59cbcc5`). Kilit commit'i bu turda push edilir. Kod henüz değişmedi.
- Önceki BUG-15 dalı `cursor/bug-15-heybe-click-3e1a` → PR #8, taban `ec23ee9` tarihsel kayıttır.
- `src/arayuz/heybe_paneli.gd` satır 34: `mouse_filter = Control.MOUSE_FILTER_STOP`. İlk çocuk `ColorRect` de varsayılan STOP. Üretim koduna satır eklenmedi.
- Kanıt: `tests/unit/heybe/heybe_tik_test.gd` (Godot 4.7.2 headless). Tık `(400, 400)`, panel dikdörtgeni kapıdaki `_dunya` ile aynı `(0, 92, 1140×988)`.
  - Açıkken imleç heybe çocuğunda, dünya `gui_input` 0, 3B `SubViewport` sondası 0.
  - Panel kapanınca aynı nokta `DunyaAlani` kontrolüne ve 3B görüntü kapısına gider (sayaç 1).
- Kapı sahnesinin kendisi tıklamayı `TextureRect` (`MOUSE_FILTER_IGNORE`) üzerinden SubViewport'a iletmez. Test, Godot'nun gerçek 3B tık yolu olan `SubViewportContainer` ile de aynı örtüyü doğrular.
- Bu makinede `C:\Users\ds\Documents\GitHub\GameDevoloper` ve Ahmet'in `Kapı_Muhafizi` kopyası yok; eşitlendi veya fast-forward yapıldı denmez.

## BUG-07 paketi (8 Ekim 2026)

Durum: BUG-07, SYS-09, SYS-11, SYS-12, KVR-11 `[x] (Cursor)`. Başlarken ROADMAP'te `[/] üzerindeyim (Cursor)` kilidi `1e898fd` ile push edildi.
Yeni dosya + ince adaptör: `GuvenliMetin` (yeni), `ana.gd` 1 satır, `katalog.gd` 4 satır, `sanity_check.py` 1 satır. Asset gerekmedi. Tam sanity 0 başarısız.
