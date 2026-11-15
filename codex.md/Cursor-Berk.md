# Cursor-Berk — Çalışma günlüğü

## Kimlik
Berk'in Cursor ajanı. İmza `(Cursor-Berk)`. Dal: `claude/festive-volta-li1sfm`.

## OGR-39 — 15 Kasım 2026
Eş, akşam sohbetinin ilk üç gecesinde (oyuncu günü 1–3) gün içinde kullanılmayan aracı tek cümleyle anar. Heybe önce gelir; heybe kullanıldıysa cümle beyana döner. İkisi de kullanıldıysa ya da gün 4 ve sonrasındaysa dal 0. Seçim DIY-09 `SatirSecici` kural tablosudur. Kullanım yeni bir sayaçla tutulmaz; kapıdaki mevcut `ilk_saat_kancasi` okunur. Aynı iz, eski kayıtta alan yokken de açılacak şekilde `ilk_saat_iz` olarak kayda yazılır. Eş ölmüşse ve meclis gecesinde sohbet eskisi gibi açılmaz.

Cümleler `es.aksam.ogreti.heybe` ve `es.aksam.ogreti.beyan` anahtarlarındadır. Panel bu cümleyi akşam sohbetinin replik listesinden gösterir.

Oyuna bağ: `KoyEkrani._geceye_gec` → `AksamSohbetiPaneli.ac` → `Oturum.aksam_sohbeti_hazirla` → `EsAksamOgretisi.ekle`.

Değişen dosyalar:
- `src/koy/es_aksam_ogretisi.gd` (yeni)
- `data/soz/es_aksam_ogretisi.json` (yeni)
- `src/sistemler/oturum.gd` (ince çağrı ve kayıt satırı)
- `src/debug/ilk_saat_kancasi.gd` (mevcut izin kayda yazılması)
- `data/metin/metinler.csv` ve üretilen çeviri dosyaları
- `tests/unit/koy/es_aksam_ogretisi_test.gd` (yeni)

Test: `godot --headless --path . -s tests/unit/koy/es_aksam_ogretisi_test.gd` → `OGR-39 GECTI`, çıkış kodu 0. Import hatasız. Tam sanity koşulmadı.

Asset gerekmedi.

Durum: OGR-39 `[x] (Cursor-Berk)` yapıldı, festive'e push edildi. Sonraki plan: Usta'dan gelecek sıradaki madde.

kota: kota görünmüyor

Bu makinede `C:\Users\ds\Documents\GitHub\GameDevoloper` kopyası yok; eşitlendi denmez.
