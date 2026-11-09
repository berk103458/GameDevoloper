# SAH kanıt tablosu — Görev 22 (Cursor, 10 Kasım 2026)

Kapsam: ROADMAP_2 Bölüm 44, SAH-01 … SAH-50. SAH-51 ve sonrası Kalfa'nındır; bu tabloda yoktur.

Kural: Bir madde ancak oyun akışında gerçekten çağrılan koda bağlıysa ve o kodu çalıştıran bir test geçiyorsa `[x]` kalır. Yalnız testten çağrılan yardımcı, sabit değer döndüren ya da girdiyi aynen geri veren fonksiyon kanıt sayılmaz.

Denetim festive `469365e4` üzerinde yapıldı. Godot 4.7.2 headless, `--import` sonrası yalnız hedefli testler çalıştırıldı.

## Özet

- `[x]` kalan: 8 madde (SAH-41, 42, 43, 44, 45, 46, 48, 49).
- Geri açılan (`[ ]`, "doğrulanmadı — Görev 22"): 38 madde.
- Zaten `[ ]` olan ve dokunulmayan: SAH-02, 11, 34, 38 (Kalfa bekleniyor).
- Kanıt testi: `tests/unit/dunya/sah_kamera_kanit_test.gd`. Son satır: `SAH KAMERA KANIT: GEÇTİ (31 kontrol)`.
- Testin gerçekten yakaladığı denendi: `yakinlas()` içindeki sınır geçici olarak kaldırılınca test `SAH KAMERA KANIT: KALDI (4 hata / 31 kontrol)` verip 1 ile çıktı. Sınır geri kondu.

## Genel bulgular

- `AyakZemini`, `HareketGecisi` ve `KalabalikYol` sınıflarını oyunda hiçbir betik çağırmıyor. Yalnız kendi testleri `new()` ile kuruyor.
- Görev 21'de `karakter_model.gd` içine eklenen `AyakZemini.kur(self)` bağı, topuğu değil model kökünü `maxf(position.y, 0.0)` ile kırpıyordu. Bu, ayak kemiğini ölçmez. Kapı yolunda arazi en çok −1 cm olduğu için görünür etkisi de yoktu. Üstelik her karakter kurulumunda `sahne.json` diskten yeniden okunuyordu. Bağ Görev 22'de kaldırıldı; `karakter_model.gd`, Görev 21 öncesi hâline döndü.
- `ElEsyasi` (SAH-09…16) ve `KameraSurukleme` (SAH-45…48) içindeki SAH yardımcıları da oyunda çağrılmıyor. `koyde_sarsinti_suresi()` sabit `0.0` döndürüyor.
- `sahne_yol_kamera_test.gd` içinde SAH-41 testi `KameraSurukleme != null` diye bakıyor. SAH-43 testi kendi yerel değişkenini kırpıyor. SAH-44 testi hiçbir şey denetlemeden "geçti" yazıyor. Bu üç madde için kanıt, gerçek köy ekranını kuran yeni testtir.

## Tablo

Sütunlar: istenen davranış, gerçek oyun kodu (dosya:satır), bu kodu çağıran yer, kanıtlayan test ve son satırı, karar.

| Madde | İstenen davranış | Gerçek oyun kodu | Çağıran yer | Kanıt testi ve son satır | Karar |
|---|---|---|---|---|---|
| SAH-01 | 20 adımda topuk tarla/patika/eşikte zeminin altına inmez | Yok. `AyakZemini.zemin_hizala` yalnız `maxf` yapar, topuğu ölçmez; bağ kaldırıldı | — | — | `[ ]` Kalfa bekleniyor |
| SAH-02 | Eğik zeminde iki ayak ayrı yükseklikte | Yok | — | — | `[ ]` (önceden Kalfa bekleniyor) |
| SAH-03 | Ayak kayması adım boyunu aşmaz | Yok. `kayma_esik_altinda_mi` yalnız testten çağrılır | — | — | `[ ]` Kalfa bekleniyor |
| SAH-04 | Duruşta konum kayması eşik altı | Yok. `durus_kayma_esik_alti_mi` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-05 | Eşik ANI-13 ağının hücresi | Yok. `esik_hucrede_mi` bir `in` denetimi, yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-06 | Şükran/diz çökmede taban zeminde | Yok. `taban_zeminde_mi` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-07 | İki kök çarpışma payından yakına girmez | Yok. `aralik_guvenli_mi` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-08 | Muayene aracı en alçak kemik yüksekliğini yazar, eşik altı hata | `tests/oto/karakter_muayene.gd:203-254` (`_olc`, `_uyar`) yalnız uyarı basar; `ayak_muayenesi_yap` (`:258`) araçta çağrılmaz; araç pencere ister | `karakter_muayene.tscn` | — | `[ ]` |
| SAH-09 | Eşya avuçta, göğüs/uylukla kesişmez | `ElEsyasi._guncelle` (`src/dunya/el_esyasi.gd:116`) avucu izler, ama kesişim ölçen kod yok; `kesisiyor_mu` (`:325`) yalnız testten | `Dunya3B._el_esyalari_tak` | — | `[ ]` |
| SAH-10 | Yürürken eşya 2 cm'den fazla gecikmez | `gecikme_uygun_mu` (`:330`) sayı karşılaştırır, yalnız testten | — | — | `[ ]` |
| SAH-11 | Diz çökmede eşya zemine girmez | Yok | — | — | `[ ]` (önceden Kalfa bekleniyor) |
| SAH-12 | Çift eşya omurgayı delmez | `cift_soket_kesisimi_var_mi` (`:340`) yalnız testten | — | — | `[ ]` |
| SAH-13 | Konuşma klibinde soket dolu | `soket_dolu_mu` (`:349`) oyunda çağrılmaz | — | — | `[ ]` |
| SAH-14 | Kapı ve köyde aynı eşya, aynı soket | `Dunya3B._el_esyalari_tak` (`src/dunya/dunya3b.gd:216`) iki sahnede de ortak; ama köyde `HazirKarakterler.koy_adi` (`src/dunya/hazir_karakterler.gd:7`) çocuk/demirci modelini değiştirdiği için satır değişebilir; test yok | `kapi_sahnesi.gd:110`, `koy_halk_hareketi.gd:44` | — | `[ ]` |
| SAH-15 | Çocukta yük ölçeği boy oranında | `cocuk_olcekle` (`:370`) `clampf`, yalnız testten | — | — | `[ ]` |
| SAH-16 | Muayene kesişen eşya türünü yazar | `esya_kesisim_muayenesi_yap` (`karakter_muayene.gd:268`) araçta çağrılmaz | — | — | `[ ]` |
| SAH-17 | Hız üç bant, eşikler `sahne.json`'da | `HareketGecisi.hiz_bandi_bul` oyunda çağrılmaz; `KarakterModel` bant kullanmaz | — | — | `[ ]` Kalfa bekleniyor |
| SAH-18 | Dur→yürü geçişi karışık | `karisim_hesapla` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-19 | Koşu yalnız kovalama/kaçışta | `kosu_acik_mi` liste denetimi, yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-20 | Duruş karesinde ayak cilası | `durus_cila_etkin_mi` = `band == "dur"`, yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-21 | Yokuşta bant aynı, adım kısa | `yokusta_hiz_uyarla` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-22 | Yorgun hız düşer, klip aynı | `yorgun_hiz` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-23 | Sorguda kök hız 0 | `sorgu_hareketi` sabit sözlük döndürür | — | — | `[ ]` Kalfa bekleniyor |
| SAH-24 | Geçiş süresi zorluktan bağımsız | `gecis_suresi(_zorluk)` parametreyi yok sayar | — | — | `[ ]` Kalfa bekleniyor |
| SAH-25 | Ağırlık toplamı 1 | `karisim_agirliklari` `"toplam": 1.0` sabiti döndürür | — | — | `[ ]` Kalfa bekleniyor |
| SAH-26 | Köyde üst gövde konuşur, alt yürür | `ust_konus_alt_yuru` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-27 | Eksik klip idle'a düşer, ağırlığa katılmaz | `eksik_klip_coz` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-28 | ANI-12 ofseti geçişte korunur | `geciste_ofset_koru` girdiyi geri döndürür | — | — | `[ ]` Kalfa bekleniyor |
| SAH-29 | Tezgâhta yürüyüş ağırlığı 0 | `tezgah_klibi_agirlik` sabit sözlük | — | — | `[ ]` Kalfa bekleniyor |
| SAH-30 | Hava tepkisi ayrı katman | `hava_katmani_ekle` girdiyi geri döndürür | — | — | `[ ]` Kalfa bekleniyor |
| SAH-31 | Karışım kayda yazılmaz, yüklemede hızdan kurulur | Bant sistemi oyunda yok; "hızdan yeniden kurulur" kısmı karşılanmıyor | — | — | `[ ]` Kalfa bekleniyor |
| SAH-32 | Aynı karede üç geçişte ortadaki atlanır | `gecis_filtrele` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-33 | Tek yol ağı | `tek_ag_var_mi` parametresiz `true`, oyunda çağrılmaz | — | — | `[ ]` Kalfa bekleniyor |
| SAH-34 | Dolu hücrede komşuya kayar | Yok | — | — | `[ ]` (önceden Kalfa bekleniyor) |
| SAH-35 | Kapı kuyruğu çizgisi | `kuyruk_cizgisi` oyunda çağrılmaz; gerçek kuyruk `KapiSahnesi.kuyruk_yeri` | — | — | `[ ]` Kalfa bekleniyor |
| SAH-36 | Eşikte tek kök | `esik_rezerve_et` oyunda çağrılmaz | — | — | `[ ]` Kalfa bekleniyor |
| SAH-37 | 2 sn sıkışan idle'a düşer | `sikisma_durumu` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-38 | Devriye kalabalığı delmez | Yok | — | — | `[ ]` (önceden Kalfa bekleniyor) |
| SAH-39 | Yol hesabı kare bütçesinde | `butce_asildi_mi` yalnız testten | — | — | `[ ]` Kalfa bekleniyor |
| SAH-40 | Çocuk ve yaşlı aynı ağ | `ag_kimligi` sabit metin döndürür | — | — | `[ ]` Kalfa bekleniyor |
| SAH-41 | Köyde tek kamera rig'i; takip ve sürükleme aynı kamerayı oynatır | `KameraSurukleme.kur` (`src/dunya/kamera_surukleme.gd:16-27`, ikinci bağ `:21`'de reddedilir); `KoyluTakibi.guncelle` (`src/koy/gorsel/koylu_takibi.gd:70-72`) aynı `sahne.kamera`yı yerleştirir | `KoyYonetimSahnesi` (`src/dunya/koy_yonetim_sahnesi.gd:71`); `koylu_karti.gd:11` | `sah_kamera_kanit_test.gd` — `SAH KAMERA KANIT: GEÇTİ (31 kontrol)`; ayrıca `kamera_surukleme_test.gd` — `KAMERA SURUKLEME: GEÇTİ (33 kontrol)` | `[x]` |
| SAH-42 | Tekerlek `sahne.json` alt/üst uzaklığının dışına çıkmaz, zemin delinmez | `KoyYonetimSahnesi.yakinlas` (`koy_yonetim_sahnesi.gd:120-121`) → `KameraSurukleme.uzaklik_sinirla` (`kamera_surukleme.gd:151-155`), sınır `data/ayarlar/sahne.json` `kamera_uzaklik` | Tekerlek olayı: `KoyEkrani._dunya_girdisi` (`src/arayuz/koy_ekrani.gd:244-252`) | `sah_kamera_kanit_test.gd` — 60 tekerlek olayı, iki uç; `SAH KAMERA KANIT: GEÇTİ (31 kontrol)` | `[x]` |
| SAH-43 | Sınır köyün dışına geçmez, yakınlaştırma sınırı genişletmez | `KameraSurukleme._kaydir` (`kamera_surukleme.gd:99-107`) hedefi ızgara köşelerine kırpar; `yakinlas` hedefe dokunmaz | `KameraSurukleme._girdi` (`:61-96`) | `sah_kamera_kanit_test.gd` (köşede yakınlaştırma + sürükleme); `SAH KAMERA KANIT: GEÇTİ (31 kontrol)` | `[x]` |
| SAH-44 | Orta tuş takibi bırakır, bırakınca geri gelmez | `kamera_surukleme.gd:73-79` (`takip.takip = false`); `KoyluTakibi.guncelle` takip kapalıyken hedefe dokunmaz (`koylu_takibi.gd:70`) | `KameraSurukleme._girdi` | `sah_kamera_kanit_test.gd`; `kamera_surukleme_test.gd` (`TAKIP_ANINDA`, `TAKIP_GERI_DONMEZ`) | `[x]` |
| SAH-45 | En yakın uzaklıkta kamera seçili köylünün içine girmez | Alt uzaklık `sahne.json` 14 m (`uzaklik_sinirla`); takip hedefi köylü (`koylu_takibi.gd:71`), kamera `_kamera_yerlestir` (`koy_yonetim_sahnesi.gd:124-130`) | Tekerlek + `KoyluTakibi.sec` | `sah_kamera_kanit_test.gd` — mesafe ≥ `kamera_taban_mesafe` (1.2 m); `SAH KAMERA KANIT: GEÇTİ (31 kontrol)` | `[x]` |
| SAH-46 | Köy yakınlaştırması kapı FOV'unu değiştirmez | Kapı FOV'u `KapiSahnesi.GORUS` (`src/dunya/kapi_sahnesi.gd:10`, `:79`); köy `yakinlas` yalnız `uzaklik`ı değiştirir | `KapiEkrani` / `KoyEkrani` | `sah_kamera_kanit_test.gd` — köyde 30 yakınlaştırma sonrası kapı FOV aynı; `SAH KAMERA KANIT: GEÇTİ (31 kontrol)` | `[x]` |
| SAH-47 | Köyde sarsıntı 0 | `koyde_sarsinti_suresi()` sabit `0.0`; gerçek sarsıntı yolu ölçülmedi | — | — | `[ ]` |
| SAH-48 | Kamera ayarı kayda girmez | `Oturum.kaydet` (`src/sistemler/oturum.gd:781`) kamera alanı yazmaz | Kayıt yolu | `sah_kamera_kanit_test.gd` — tekerlek ve sürükleme sonrası `kaydet()` JSON'u aynı, `uzaklik/kamera/hedef/yon/egim` yok; `SAH KAMERA KANIT: GEÇTİ (31 kontrol)` | `[x]` |
| SAH-49 | Sorguda konuşanın yüzü üç boyda kadrajda, FOV BUG-13 içinde | `KapiSahnesi._ready` kamera (`kapi_sahnesi.gd:76-81`) ve `gelen_yaklas` (`:103-131`, `DURMA` noktası) | `KapiEkrani._siradaki` (`src/arayuz/kapi_ekrani.gd:242`, `:272`) | `sah_kamera_kanit_test.gd` — `chr_006` (çocuk), `chr_001`, `asker` baş kemiği `is_position_in_frustum`; `SAH KAMERA KANIT: GEÇTİ (31 kontrol)` | `[x]` (not: kamera modeli izlemez, sabit kadraj üç boyu da içine alır) |
| SAH-50 | Heybe açıkken kamera modeli örtecek kadar yaklaşmaz | `heybe_ile_mesafe_koru` oyunda çağrılmaz | — | — | `[ ]` |
