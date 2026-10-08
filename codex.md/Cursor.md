# Cursor — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Cursor — Godot doğrulama ve ince adaptör. Bu turda KAP-02, KAP-03, BUG-11 ve TUC-11/14 notu.

## Şu an üzerinde çalışılan
KAP-02 ve KAP-03 `[x] (Cursor)`. BUG-11 eski notu düzeltildi. TUC-11/14 notları duruyor. MEV-01 satırına yazılmadı. Yeni dosya ve ikinci sistem yok. TUC/MEV/CAS kaynak dosyalarına dokunulmadı.

## Sonraki plan
Festive PR. Yeni özellik yok. ODA-01 açılınca TUC-11 tekrar yazılmaz.

## Güncel durum
- Dal: `cursor/roadmap-gap-verify-0b16`, taban `claude/festive-volta-li1sfm` (`59cbcc5`). Kilit `29a71c6`.
- KAP-02 `[x] (Cursor)`: `tansiyon_yoneticisi.gd` yok. Aralık ve `tansiyon_delta` `ChrSorgusu` içinde; gösterge KAP-12. KAP-11 `ipucu_yoneticisi.gd` duruyor.
- KAP-03 `[x] (Cursor)`: panel `src/arayuz/heybe_paneli.gd`. Kart açılışta 0.3→1. İpucu kartı KAP-14. BUG-15 testi `tests/unit/heybe/heybe_tik_test.gd`.
- MEV-01 festive `59cbcc5` üzerinde zaten `[x] (Codex)`. Satır geri alındı; üzerine yazılmadı. MEV/TUC/CAS kaynak dosyalarına dokunulmadı.
- BUG-11 notu: "BUG-08 hâlâ açık" silindi. BUG-08 kapalı.
- TUC-14 notu: TUC-02 alış bitti; TUC-14 aynı `lojistik.hayvanlar` kaydının geri satışı ve çarpanı. İkinci sürü yok.
- TUC-11 notu: kaçak mal pazar kartı envanteri. 3B oda ODA-01 `[ ]`; bağımlılık yazıldı.
- Asset gerekmedi. `C:\Users\ds\Documents\GitHub\GameDevoloper` ve Ahmet `Kapı_Muhafizi` bu ortamda yok; eşitlendi denmez.
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
