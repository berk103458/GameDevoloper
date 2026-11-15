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

## SOY-10 — Kapıda doğrulama (15 Kasım 2026)

Ne yapıldı: Kapıdaki beyan, söylenti ağındaki canlı bir kayıtla çelişirse beyan defterine tek satır düşer. Oyuncu "Köyde başka duydum." deyip Göster'e basar. Kayıt doğruysa çelişki zarsız yüzleşme dalına gider, tansiyon artmaz. Kayıt yanlışsa muhafız yanılır, tansiyon tam +1 artar, yüzleşme açılmaz. Ağda eşleşen kayıt yoksa satır görünmez. Ağ `SoylentiKoprusu.ag` üzerinden okunur; defter açılınca ağ kurulmaz. İkinci defter, ikinci söylenti kaydı ve ikinci çelişki sistemi yok.

Oyuna bağlantı: `KapiEkrani._sohbet_goster` → `ChrKapiAdaptoru.beyan_defteri_dugmesi` ("Göster · Beyan Defteri", gelen kimliği) → `BeyanDefteriPaneli` → `Celiski.kayitlari_al_oturumla` / `Celiski.yuzles` → `SoylentiDogrulama`.

Değişen dosyalar: `src/kapi/soylenti_dogrulama.gd`, `src/soz/celiski.gd`, `src/arayuz/kapi/beyan_defteri_paneli.gd`, `src/arayuz/chr_kapi_adaptoru.gd`, `data/metin/metinler.csv` (ve üretilen `metinler.tr.translation`, `metinler.en.translation`), `tests/unit/soz/soylenti_kapi_dogrulama_test.gd`. Yeni betiklerin `.uid` dosyaları duruyor.

Test: `godot --headless --path . -s tests/unit/soz/soylenti_kapi_dogrulama_test.gd` → `SOY-10 GECTI`, çıkış kodu 0. `godot --headless --path . -s tests/unit/soz/celiski_goster_test.gd` → `TEST PASS: celiski_goster_test.gd`, çıkış kodu 0. `tests/oto/celiski_goster_kontrol.tscn` → `CELISKI GOSTER UI: GEÇTİ`. Tam sanity koşulmadı. Durum: kod ve testler festive'e push edildi; yeni kural gereği ROADMAP_2'de madde `[/] (Cursor-Berk)` olarak kalır, `[x]` Usta doğrulamasından sonra.

Asset gerekmedi.

kota: kota görünmüyor
