# Cursor — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Cursor — Godot doğrulama ve ince adaptör. Bu turda yalnız BUG-15.

## Şu an üzerinde çalışılan
BUG-15 üzerindeyim. Heybe paneli açıkken tıklamanın 3B kapı sahnesine sızıp sızmadığı doğrulanıyor; panel yeniden yazılmıyor.

## Sonraki plan
`heybe_paneli.gd` içindeki `mouse_filter` yeterliyse otomatik tıklama kanıtı; yetmezse tek satırlık adaptör. KAP-02/03, EKO-14, BUG-03 ve CSV’ye dokunulmayacak.

## Güncel durum
- Dal: `cursor/bug-15-heybe-click-3e1a` (taban `claude/festive-volta-li1sfm`).
- Kod okundu: `HeybePaneli._ready` `Control.MOUSE_FILTER_STOP` atıyor. Kanıt testi henüz koşulmadı.
