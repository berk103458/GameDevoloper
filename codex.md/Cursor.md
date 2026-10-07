# Cursor — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Cursor — Godot doğrulama ve ince adaptör. Bu turda yalnız BUG-15.

## Şu an üzerinde çalışılan
BUG-15 kapandı. Heybe paneli yeniden yazılmadı.

## Sonraki plan
KAP-02/03, EKO-14, BUG-03 ve CSV bu turda bilinçli olarak duruyor. Sıradaki iş Ahmet yönlendirmesine kalır.

## Güncel durum
- Dal: `cursor/bug-15-heybe-click-3e1a` → PR #8, taban `claude/festive-volta-li1sfm` (`ec23ee9`).
- `src/arayuz/heybe_paneli.gd` satır 34: `mouse_filter = Control.MOUSE_FILTER_STOP`. İlk çocuk `ColorRect` de varsayılan STOP. Üretim koduna satır eklenmedi.
- Kanıt: `tests/unit/heybe/heybe_tik_test.gd` (Godot 4.7.2 headless). Tık `(400, 400)`, panel dikdörtgeni kapıdaki `_dunya` ile aynı `(0, 92, 1140×988)`.
  - Açıkken imleç heybe çocuğunda, dünya `gui_input` 0, 3B `SubViewport` sondası 0.
  - Panel kapanınca aynı nokta `DunyaAlani` kontrolüne ve 3B görüntü kapısına gider (sayaç 1).
- Kapı sahnesinin kendisi tıklamayı `TextureRect` (`MOUSE_FILTER_IGNORE`) üzerinden SubViewport'a iletmez. Test, Godot'nun gerçek 3B tık yolu olan `SubViewportContainer` ile de aynı örtüyü doğrular.
- Bu makinede `C:\Users\ds\Documents\GitHub\GameDevoloper` ve Ahmet'in `Kapı_Muhafizi` kopyası yok; eşitlendi veya fast-forward yapıldı denmez.
