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

## SOY-23 — Bağlam sorgusunda söylenti anahtarları (15 Kasım 2026)

Ne yapıldı: Ağdaki her kayıt, konuşan karakter için DIY-09 bağlamına yazılır. Tek yardımcı `SoylentiBaglami.baglama_yaz` `baglam_sorgusu_al` okur; ikinci söylenti kaydı açmaz. Anahtarlar düzdür: `soylenti.<olay_id>.duydu`, `.dogru`, `.kaynak`. SatirSecici koşulu ilk noktadan böldüğü için iç içe sözlük yetmez. Olay kimliği kayıttan kayda değiştiği için veri dalı `soylenti_duydu` özetine bakar (karakter en az bir kaydı duyduysa true). Duyan köylüde "Duydum ki…" dalı seçilir; duymayanda dal seçilmez. Cümle `soz.soylenti.duydum_ki` anahtarındadır (TR+EN). Kart okuması ağı kurmaz. Eski kayıt biçimi değişmedi.

Oyuna bağlantı: `KoyluKarti` → `NeDuydun.ekle` ("Ne duydun?") → `duydum_ki_metin` → `duydum_ki_sec` → `sohbet_baglami` → `SoylentiBaglami.baglama_yaz` → `SoylentiAgi.baglam_sorgusu_al`. Ağ `SoylentiKoprusu.ag` ile oturumdadır. Seçilen cümle, köylünün kendi sürümünün üstüne yazılır.

Değişen dosyalar:
- `src/soz/soylenti_baglami.gd` (yeni)
- `src/koy/ne_duydun.gd` (ince adaptör)
- `src/soz/satir_secici.gd` (`soylenti.` ve `soylenti_duydu` geçerli koşul)
- `data/soz/soylenti_duydum.json` (yeni)
- `data/metin/metinler.csv` ve üretilen `metinler.tr.translation`, `metinler.en.translation`
- `tests/unit/sistemler/soylenti_baglam_test.gd` (yeni)
- Yeni betiklerin `.uid` dosyaları duruyor.

Test:
- `godot --headless --path . -s tests/unit/sistemler/soylenti_baglam_test.gd` → `SOY-23 GECTI`, çıkış kodu 0.
- `godot --headless --path . -s tests/unit/kvr/soylenti_agi_test.gd` → `PASS: SOY-01..50 Soylenti Agi kapanis testi basariyla gecti.`, çıkış kodu 0.
- `godot --headless --path . -s tests/unit/sistemler/ne_duydun_test.gd` → `NE DUYDUN: GEÇTİ`, çıkış kodu 0.
- `godot --headless --path . -s tests/unit/soz/satir_secici_test.gd` → `SATIR SECICI: GEÇTİ (0 hata)`, çıkış kodu 0.
- `--import` sonrası `project.godot` değişmedi. SCRIPT ERROR yok. Tam sanity koşulmadı.

Asset gerekmedi.

kota: kota görünmüyor

Bu makinede `C:\Users\ds\Documents\GitHub\GameDevoloper` kopyası yok; eşitlendi denmez. Durum: kod ve testler festive'e push edildi; madde ROADMAP_2'de `[/] (Cursor-Berk)` kalır, `[x]` Usta doğrulamasından sonra.

## SOY-26 — "Bu hatırlanacak" söylentide de çıkar (15 Kasım 2026)

Ne yapıldı: Oyuncu çınar meclisinde söze "doğru" ya da "yalan" deyip ağa muhafız düğümü yazınca DIY-14 notu bir kez çıkar. Tetik anahtarı `soylenti_muhafiz`; kural `HatirlanmaNotu` listesindedir, ikinci not sistemi yok. Metin mevcut `UI_BU_HATIRLANACAK` anahtarıdır. `nitele` boş dönerse (aynı konuya ikinci kez) not açılmaz. Ayar `hatirlanma_notu` kapalıyken not gizlenir, düğüm yine kayda yazılır. Akşam sohbeti (DYL-07) muhafız düğümü yazmıyor; `nitele` yalnız meclis düğmesinden çağrılıyor. Kayıt biçimi değişmedi.

Oyuna bağlantı: `CinarMeclisPaneli.ac` → `SoylentiHukmu.ekle` → `meclis_soylenti_nitele_*` → `SoylentiKoprusu.nitele` (`muhafiz_dugumu`) → `HatirlanmaNotuBaglantisi.bildir` → `HatirlanmaNotu.secim_bildir`. Köy ekranında not yoksa aynı sınıftan tek örnek açılır.

Değişen dosyalar:
- `src/arayuz/kapi/hatirlanma_notu.gd` (tetik listesine `soylenti_muhafiz`)
- `src/arayuz/kapi/hatirlanma_notu_baglanti.gd` (yeni)
- `src/arayuz/koy_hud/soylenti_hukmu.gd` (nitelik düğmesi)
- `tests/unit/sistemler/soylenti_hatirlanma_test.gd` (yeni)
- Yeni betiklerin `.uid` dosyaları duruyor.

Test:
- `godot --headless --path . -s tests/unit/sistemler/soylenti_hatirlanma_test.gd` → `SOY-26 GECTI`, çıkış kodu 0.
- `godot --headless --path . -s tests/unit/kapi/hatirlanma_notu_test.gd` → `HATIRLANMA NOTU: GEÇTİ (0 hata)`, çıkış kodu 0.
- `godot --headless --path . -s tests/unit/sistemler/soylenti_muhafiz_test.gd` → `SÖYLENTİ MUHAFIZ: GEÇTİ`, çıkış kodu 0.
- `--import` sonrası `project.godot` değişmedi. SCRIPT ERROR yok. Tam sanity koşulmadı.

Asset gerekmedi.

kota: kota görünmüyor

Bu makinede `C:\Users\ds\Documents\GitHub\GameDevoloper` kopyası yok; eşitlendi denmez. Durum: kod ve testler push edilecek; madde `[/] (Cursor-Berk)` kalır, `[x]` Usta doğrulamasından sonra.
