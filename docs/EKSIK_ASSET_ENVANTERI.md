# Kapı Muhafızı — Eksik asset envanteri

**Tarih:** 7 Ekim 2026  
**Dal tabanı:** `claude/festive-volta-li1sfm` @ `ec23ee9` (`feat(EKO-13): expose tool wear and verify last-tool production`)  
**Yapan:** Cursor — yalnız tarama. Görsel, ses, model üretilmedi; oyun kodu değiştirilmedi.  
**Eski liste:** `production/eksikler/` 4 Ekim notlarıdır. O tarihten sonra yürüyüş GLB’leri, duygu klipleri, CHR foley ve ekonomi SVG’leri geldi. Bu dosya güncel taramanın kaydıdır.

Bu belge üretim brief’idir. Aynı dosya adı konunca oyun yolu değişmez; yeni ad önerilen yerlerde kod henüz o yolu yüklemez.

## Ajanlar için kullanım (Ahmet kuralı, 8 Ekim 2026)

Ajanlar asset üretmez ve indirmez (bkz. `AGENTS.md` → "Asset kuralı"). Mekaniği kutu/düz renk yer tutucuyla bitir, ihtiyaç duyduğun asseti bu dosyaya yaz.

- Yeni satırı en alttaki **"G. Ajan eklemeleri"** tablosuna ekle; mevcut A–D bölümlerini yeniden yazma.
- Sütunlar: `ID` (ör. `ANI05-KOYUN`) · `ROADMAP` (madde kodu) · `Ne` (asset adı) · `Tür / format` (glTF, PNG, WAV, OGG, animasyon klibi…) · `Yer tutucu yolu` (kodun şu an yüklediği yer tutucu: kutu sahnesi, sabit veya `BoxMesh` kuran scriptin `res://` yolu) · `Anahtar kelimeler (TR + EN)` · `Öncelik` (yukarıdaki tablo: kritik / yüksek / orta / düşük / ileri) · `Ekleyen` (Codex, Claude, Cursor, Gemini…).
- Aynı asset zaten A–D'de varsa yeni satır açma; o satırın ROADMAP sütununa madde kodunu ekle.
- ROADMAP'te sonraki maddeye geçmeden önce bu tabloyu aynı commit'te güncelle. Asset gerekmediyse commit mesajına veya status dosyana "asset gerekmedi" yaz.

## Nasıl tarandı

- `ROADMAP.md` açık maddeleri (ANI, TUC, MEV, CAS, ODA, HAR, KRI, SYS-16…20, EKO-14/15).
- Yüklenen yollar: `Sanat`, `Ses`, `Dunya3B`, `Pbr`, `GirisVarliklari`, `KaynakGostergesi`, `EsyaSimgesi`, `KarakterModel`, `KapiCercevesi`, `KoyYonetimSahnesi._bina_dugumu`, olay `.tres` `ses`/`muzik` alanları.
- Disk: `assets/art`, `assets/ses`, `assets/model`, `assets/ui/koy`, `assets/font`, `assets/ph`, `assets/palette`.
- Yer tutucu üreticiler: `tools/art/uret_yer_tutucu.py`, `tools/art/gemini_uret.py`, `tools/ses/ses_uret.py`.

## Durum ve öncelik

| Durum | Anlam |
|---|---|
| yok | Beklenen dosya diskte yok |
| placeholder | Dosya var; prosedürel yer tutucu veya düz renk/kutu |
| yarım | Dosya veya sistem var; dönem, isim veya kapsam uymuyor |
| bozuk yol | Kodun aradığı `res://` yolu diskte yok |

| Öncelik | Anlam |
|---|---|
| kritik | Menü veya kapı gecesi bu varlık olmadan düzgün açılmaz / okunmaz |
| yüksek | Kapı sorgu, heybe, diyalog, köy HUD şu an oynanırken görünür |
| orta | Köy sahnesi ve ekonomi; oyun açılır, kimlik zayıf kalır |
| düşük | Kullanılmayan dosya, mağaza, ince cila |
| ileri | ROADMAP maddesi kodlanmadı; varlık şimdiden planlanır |

Anahtar kelimeler Türkçe + İngilizce, üretim araması içindir: dönem, ruh hali, kullanım.

## Özet

| Öncelik | Ne eksik |
|---|---|
| kritik | Kapı karar ikonları, imleç ve bilgi arka planları yer tutucu PNG. Kapı/menü müziği ve SFX prosedürel WAV. Kapı kanadı Avrupa kalesi PBR + kutu; Selçuklu uç kapısı değil. |
| yüksek | 44 yürüyen modelde `gergin` klibi yok. CHR’lerin yarısında `ofke` veya `panik` yok. 14 adlı/sınıf modelinde duygu klibi yok. CHR poz anahtarları `Idle`/`Stressed`/`Panic` dosyaya bağlı değil. Heybe ve el eşyası çizim/kutu. 30 CHR’nin ayrı portresi yok. Köyde yeni yapılar genel ahşap kutu. |
| orta | Kürk SVG yok. Yapı kartı ikonları kulübeye düşüyor. Ambar kervansaray modeli. Gözetleme kulesi yok. Hayvan, olay kişisi, çocuk modeli yok. |
| düşük | Çatlayan bar PNG’leri, meşale FX, kalabalık silueti kod tarafından yüklenmiyor. Palet dosyası, logo, pencere simgesi yok. |
| ileri | ANI silah/rutin, TUC tüccar/hayvan, MEV kar/yağmur, CAS divan, ODA oda, HAR harita, KRI salgın, SYS son ekranları. |

## Oyunda olup bu listede “eksik” sayılmayanlar

Bunlar gerçek dosya. Yeniden üretme brief’i değiller.

- Font: `assets/font/Alegreya-wght.ttf`, `Alegreya-Italic-wght.ttf`, `Cinzel-wght.ttf`.
- Gök: `assets/ph/gok/satara_night_no_lamps_4k.hdr`, `kloofendal_48d_partly_cloudy_puresky_2k.hdr`, `kloppenheim_06_puresky_2k.hdr`.
- Kapı PBR: `medieval_wood`, `bark_willow`, `castle_wall_varriation`, `brown_mud_rocks_01`, `snow_02`, `aerial_rocks_02`, `snow_field_aerial`, `muddy_tracks` ve glTF varil, sandık, kaya, kütük, kuru dal, `large_castle_door`.
- Yürüyüş: `assets/model/karakter/*_yuru.glb` — 30 CHR + 14 adlı/sınıf (her biri yaklaşık 2,5–5 MB).
- Köy GLB: `yapi/cadir`, `ev`, `kapi`, `kervansaray`, `pazar_tezgahi`; `nesne/agac`, `araba`, `cuval_yigini`, `kaya`, `kazik_cit`, `kuyu`, `mesale`, `okuz`.
- HUD SVG (CC BY, `assets/ui/koy/`): `akce`, `gida`, `odun`, `tas`, `kereste`, `alet`, `cadir`, `kulube`, `ambar`, `avci`, `tomruk`, `bugday`, `un`, `kirec`, `harc`, `cevher`, `demir`.
- `Hud.STOKLAR` bu SVG’leri yükler. Kürk şeritte yok.

---

## A. Kritik — menü ve kapı

### A1. Kapıda yüklenen 2D ikonlar — placeholder

Üretici: `tools/art/uret_yer_tutucu.py`. Boyutlar `tools/art/gemini_uret.py` tablosuyla aynı. 48×48 ikonlar 440–843 bayt; illüstrasyon değil, düz palet lekesi. Format: PNG, ikili alfa, palet 7 hex (`#0D0F14` `#4A6B8A` `#3D2E24` `#C4843A` `#06070A` `#B8C2CC` `#24364A`).

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| UI-KARAR-KABUL | Kapı kabul düğmesi. `kapi_ekrani.gd` `icon_decision_accept_48`. KAP-13. | placeholder | `res://assets/art/ui/icon_decision_accept_48.png` | açık kapı, kabul, open wooden gate, frontier night, ink icon, 48px | kritik |
| UI-KARAR-RET | Ret ve el koyma. `reject`. | placeholder | `res://assets/art/ui/icon_decision_reject_48.png` | kapalı kapı, sürgü, barred gate, reject, ink icon | kritik |
| UI-KARAR-RUSVET | Rüşvet ve harç. `bribe`. | placeholder | `res://assets/art/ui/icon_decision_bribe_48.png` | deri kese, sikke, coin pouch, bribe, no numerals | kritik |
| UI-KARAR-KISLA | Kışla / zindan. `barracks`. | placeholder | `res://assets/art/ui/icon_decision_barracks_48.png` | mızrak, yuvarlak kalkan, spear shield, barracks | kritik |
| UI-KESE-DOLU | Rüşvet şeridi. `icon_bribe_pouch_full_48`. | placeholder | `res://assets/art/ui/icon_bribe_pouch_full_48.png` | dolu kese, bağcık, full leather pouch, ash tie | kritik |
| UI-IMLEC | Menü ve kapı imleci, ok ve el aynı doku. `ana.gd`. | placeholder | `res://assets/art/ui/ui_cursor_arrow_32.png` | kül ok, sol üst uç, mouse arrow, 32px, ink outline | kritik |

Not: Ayrı el imleci yok. `CURSOR_POINTING_HAND` aynı oku kullanır. İstenirse `ui_cursor_hand_32.png`, 32×32 PNG.

### A2. Bilgi ekranı arka planları — placeholder

`bilgi_ekrani.gd` `3d_*` değilse `assets/art/env/<ad>.png` yükler. Perde ve sonlar çoğu zaman `3d_koy` / `3d_kapi` kullanır; varsayılan hâlâ `env_menu_bg`.

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| ENV-MENU | Başlık / bilgi varsayılanı. 1920×1080. | placeholder | `res://assets/art/env/env_menu_bg.png` | gece uç, kapalı kapı, tek meşale, title screen, no text, cold blue | kritik |
| ENV-KAPI | Kapı bilgi kadrajı. 1140×1000. | placeholder | `res://assets/art/env/env_gate_scene_bg.png` | içeriden palisat, toprak yol, uzak kuyruk, papers-please framing, night | yüksek |
| ENV-KOY-2D | Köy bilgi kadrajı. 1920×1000. Sahne 3B olduğu için ikincil. | placeholder | `res://assets/art/env/env_village_bg.png` | küçük kervansaray, pazar örtüsü, gece, no people | orta |

### A3. Kapı ve menü sesi — hepsi placeholder

`tools/ses/ses_uret.py`: 44,1 kHz, 16-bit, mono WAV. Aynı adla gerçek kayıt konur. Betik yeniden çalışırsa kaydın üstüne yazar.

Menü `Ses.dongu_baslat` → `muzik_gece_dongu` + `ortam_mesale_dongu`. Kapı kararı `sfx_onay`, `sfx_kese`, `sfx_kapi_acilir` / `sfx_kapi_kapanir`, `sfx_adim`, `sfx_secim`, `sfx_olay`. Tansiyon katmanı `muzik_chr_sakin|gergin|panik` (`tansiyon_muzigi.gd`, SYS-03).

| ID | Ne için | Durum | Yol | Süre tahmini | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|---|
| SES-MUZIK-GECE | Varsayılan döngü. Menü, kapı, köy dönüşü. | placeholder | `assets/ses/muzik_gece_dongu.wav` | 60–90 sn dikişsiz | ney, kopuz, hicaz, lonely frontier night, no percussion lead | kritik |
| SES-ORTAM-MESALE | Kapı ortamı. | placeholder | `assets/ses/ortam_mesale_dongu.wav` | 20–40 sn döngü | meşale çıtırtısı, hafif rüzgâr, torch crackle, wind | kritik |
| SES-MUZIK-SAKIN | Tansiyon 0–3. | placeholder | `assets/ses/muzik_chr_sakin.wav` | 15–30 sn | ney, kopuz, calm interrogation | yüksek |
| SES-MUZIK-GERGIN | Tansiyon 4–7. | placeholder | `assets/ses/muzik_chr_gergin.wav` | 15–30 sn | yaylı, tense strings, no jump scare | yüksek |
| SES-MUZIK-PANIK | Tansiyon 8–10. | placeholder | `assets/ses/muzik_chr_panik.wav` | 15–30 sn | kudüm, davul, panic pulse, low drum | yüksek |
| SES-KAPI-AC | Kabul, içeri. | placeholder | `assets/ses/sfx_kapi_acilir.wav` | 0,8–1,5 sn | ağır ahşap gıcırtı, sürgü, heavy timber gate | kritik |
| SES-KAPI-KAPA | Ret. | placeholder | `assets/ses/sfx_kapi_kapanir.wav` | 0,8–1,2 sn | kapı çarpma, bar drop, wood thud | kritik |
| SES-KESE | Rüşvet, heybe, pazar. | placeholder | `assets/ses/sfx_kese.wav` | 0,3–0,6 sn | deri kese, sikke, coin pouch foley | kritik |
| SES-ADIM | Kuyruk adımı. | placeholder | `assets/ses/sfx_adim.wav` | 0,2–0,4 sn, 2–3 varyant | toprak, çarık, dirt footstep | yüksek |
| SES-SECIM | Odak. | placeholder | `assets/ses/sfx_secim.wav` | ~0,06 sn | kısa tahta tık, UI tick | yüksek |
| SES-ONAY | Karar onayı. | placeholder | `assets/ses/sfx_onay.wav` | ~0,15 sn | alçak onay, no fanfare | yüksek |
| SES-OLAY | Olay kartı. | placeholder | `assets/ses/sfx_olay.wav` | ~1 sn | nötr stinger, good or bad işaret yok | yüksek |
| SES-FOLEY-6 | Replik foley. KAP-10. `chr_sorgu_sesi.gd`. | placeholder | `sfx_chr_kabza`, `sfx_chr_bebek`, `sfx_chr_kagit`, `sfx_chr_metal`, `sfx_chr_sikke`, `sfx_chr_deri` | ~0,3 sn | kılıç kabzası, bebek soluğu, parşömen, çapa/zincir, sikke, deri sürtünme | yüksek |

### A4. Kapı gövdesi — yarım

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| KAPI-3D-IC | Bekçi kadrajı. `KapiCercevesi` seviye 0 kütük kutuları; seviye 1+ `Pbr.model("large_castle_door")`. `kapi.glb` köyde, kapı sahnesinin iç yüzünde değil. | yarım | Mevcut: `assets/ph/model/large_castle_door/large_castle_door.gltf`. Beklenen: `assets/model/yapi/kapi_ic.glb` | 13. yy Anadolu uç palisat, içeriden iki kanat, kazık, meşale kolu, no castle portcullis, no gothic, PBR glTF | kritik |
| KAPI-DEMIR | Kapı kuşağı düz `StandardMaterial3D`, doku yok. | placeholder | doku yok; hedef `assets/ph/doku/wrought_iron/` veya kapı GLB içi | dövme demir, mat, wrought iron strap, rough | orta |

---

## B. Yüksek — sorgu, heybe, karakter

### B1. Portre ve görsel iz — placeholder, sınıf tekrarı

`chr_inceleme_paneli.gd` eski `.tres` `portre` alanıyla `Sanat.portre` çağırır: `res://assets/art/char/char_<portre>_neutral_card.png` (600×760). CHR_001–030 çoğu `soldier_01` / `farmer_01` / `farmer_02` / `craftsman_01`. Aynı yüz onlarca kişide tekrarlar. Fiziksel iz (yara, kireç, süt) portrede yok; tıklama metin açar (KAP-06).

Adlı kartlar da yer tutucu: `miraen`, `sorhan`, `thessra`, `karaca_usta`, `aydogdu`, `saruca_hatun`.

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| PORTRE-SINIF-4 | Sınıf kartı, kapı inceleme. | placeholder | `char_soldier_01_neutral_card.png`, `char_farmer_01_neutral_card.png`, `char_farmer_02_neutral_card.png`, `char_craftsman_01_neutral_card.png` | Selçuklu uç, yorgun, kalın mürekkep, tek imza siluet, reigns-scale bust, no text, magenta key | yüksek |
| PORTRE-ADLI-6 | Eski adlı kadro kartı. | placeholder | `char_{miraen,sorhan,thessra,karaca_usta,aydogdu,saruca_hatun}_neutral_card.png` | aynı stil; Miraen kuyruklu keçe külah + kırık kın, Sorhan yular, Thessra başörtüsü ve kutu, Karaca deri tomar + kuşak, Aydoğdu yay, Saruca üçgen başörtüsü | yüksek |
| PORTRE-CHR-30 | Kişiye özel iz. Kod yolu yok; portre kökü sınıf. | yok | öneri: `assets/art/char/char_chr_XXX_neutral_card.png` | CHR sayfasındaki görsel hata, wound, lime, chain scar, milk stain, unique bust | yüksek |
| KOY-FIGUR-2D | `Sanat.koy_figuru` hiç çağrılmıyor. Köy 3B. | placeholder, atıl | `char_*_idle_village.png` 56×120 | küçük köy silueti, idle village | düşük |

### B2. Heybe ve nişan görseli — placeholder

`EsyaSimgesi` kodla çizer (`esya_simgesi.gd`: “Sanat gelirse aynı id ile doku”). Bilinen id: `akce`, `arpa`, `tohum`, `ekmek`, `tuz`, `kumas`, `bakir`, `ok`, `hancer`, `ilac`, `yuzuk`. Tanınmayan id gri daire. KAP-03 paneli ve KAP-14 kartı metin; eşya PNG’si yok.

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| HEYBE-11 | Heybe kartı simgesi. | placeholder | öneri `assets/art/icons/icon_esya_<id>_64.png` | mürekkep ikon, 64px, deri, çuval, ekmek, ok, hançer, ilaç şişesi, yüzük, no text | yüksek |
| NISAN-30 | CHR Obje_1 mühür/ferman/rozet. KAP-04. | yok | öneri `assets/art/icons/icon_clue_chr_XXX_obje1.png` | nişan, mühür, berat, ferman, wax seal, charter, Seljuk frontier | yüksek |
| YUK-30 | CHR Obje_2 çuval/gizli bölme. KAP-05. | yok | öneri `assets/art/icons/icon_clue_chr_XXX_obje2.png` | çuval, saman altı, false bottom, smuggled goods | yüksek |

### B3. El eşyası — prosedürel kutu, GLB yok

`ElEsyasi` ve `data/el_esyalari.json`. Hepsi kutu/silindir. Format hedefi: glTF, avuçta ~0,2–1,5 m, düşük poligon.

| ID | Kimde | Anahtar kelimeler | Öncelik |
|---|---|---|---|
| EL-TORBA | chr_002 | keten torba, linen sack | orta |
| EL-SEPET | chr_003 | hasır sepet, wicker basket | orta |
| EL-CEKIC | chr_003 | küçük çekiç, hand hammer | orta |
| EL-KAMCI | chr_004 | at kamçısı, horse whip | orta |
| EL-KURK | chr_004 | kürk bohça, fur bundle | orta |
| EL-HEYBE | chr_005, 009, 010 | çift göz heybe, saddlebags | yüksek |
| EL-SEPET-BUYUK | chr_006, 012 | büyük sepet | orta |
| EL-SANDIK | chr_007 | küçük sandık, small chest | orta |
| EL-ASA | chr_008 | ahşap asa, staff | orta |
| EL-DEGNEK | chr_013 | eğri değnek, cane | orta |
| EL-ODUN | chr_001 | iki odun, firewood | orta |

JSON’daki diğer türler (`testi`, `kova`, `capa`, `kazma`, `kilic_bez`, `cuval`, `bohca`, `kile`, `kalbur`, `kabak`, `cubuk`) aynı dosyada tanımlı; atanmış karakter satırı yoksa sahnede görünmez. Yine de heybe/el hattı için aynı glTF ailesi.

### B4. Animasyon klipleri — yarım

`KarakterModel.HAREKETLER`: `bekle`, `konus`, `sevinc`, `ofke`, `panik`, `gergin`. Dosya: `assets/model/hareket/<ad>_<hareket>.res`. Yürüyüş klibi GLB’nin içinde. Eksik klip idle’a düşer (BUG-09/12); oyun çökmez, poz eksik kalır.

CHR kaynak anahtarları `Idle` / `Stressed` / `Panic` (`karakter_verisi.gd`). Bu üç adla `.res` yok. `tansiyon_animasyonu()` sahne oynatıcısına bağlı değil. Stressed karşılığı dosyada `gergin` olmalı; o dosya hiçbir modelde yok.

| Grup | Var | Yok | Öncelik |
|---|---|---|---|
| chr_001, 004, 005, 006, 007, 009, 010 | bekle, konus, sevinc, ofke | panik, gergin | yüksek |
| chr_002, 003, 008, 011–030 | bekle, konus, sevinc, panik | ofke, gergin | yüksek |
| asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | yalnız `*_yuru.glb` | altı duygu klibinin hepsi | yüksek |

Beklenen ad: `assets/model/hareket/<model>_<hareket>.res` (Animation, aynı iskelet, iz eşiği 0,8).  
Anahtar kelimeler: idle breath, talk gesture, joy, anger, panic draw, stressed fidget, Anatolian frontier clothes, no Mixamo T-pose leftover.

İleri klipler (ANI, henüz kod yok): `kos`, `otur`, `orak`, `cekic`, `nobet`, `saldir`, `dus`, `yagmur_yuru`, `kar_yuru`. glTF klip veya `.res`.

### B5. Kapı kuyruğu çeşitliliği

Olay kişilerinin modeli yok. Olay kartı metin (`koy_ekrani.gd`). Köy kalabalığı sınıf modellerine düşer.

| ID | Ne için | Durum | Beklenen | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| KAR-CAVUS | `miraen_cavus` | yok | `assets/model/karakter/cavus_yuru.glb` | Selçuklu çavuş, lamel yelek, keçe börk, gürz | orta |
| KAR-TAHSILDAR | `vergi_tahsildari` | yok | `tahsildar_yuru.glb` | vergi defteri, sikke kesesi, ince kaftan | orta |
| KAR-ELCI | `tekfur_elcisi` | yok | `tekfur_elcisi_yuru.glb` | Bizans uç elçisi, mühürlü tomar, kısa pelerin | orta |
| KAR-DERVIS | `dervis` | yok | `dervis_yuru.glb` | sikke külah, hırka, keşkül, asa | orta |
| KAR-HABERCI | Ahi / Ertuğrul haberi | yok | `haberci_yuru.glb` | tozlu binici kaftanı, mesaj tüpü | orta |
| KAR-BEY | `bey_daveti` | yok | `bey_yuru.glb` | kürklü börk, kuşak, eğri kılıç | düşük |
| KAR-COCUK | Saruca, Sorhan, kalabalık | yok | `cocuk_yuru.glb` | 7 yaş, uzun tunik, yalınayak | orta |
| KAR-TEKFUR-ASKER | Uzak siluet. 2D `crowd_tekfur_spear_01_far.png` atıl. | placeholder 2D, 3B yok | `tekfur_askeri_yuru.glb` veya siluet şerit | konik miğfer, uzun kalkan, mızrak, soğuk mavi siluet | orta |

---

## C. Orta — köy sahnesi, ekonomi UI, ortam sesi

### C1. Yapı görselleri

`koy_yonetim_sahnesi.gd` `_bina_dugumu`. Katalog `model` alanı yalnız çadır ve kulübede yazılı; sahne onu okumaz, `match` kullanır.

| Tür | Şu an | Durum | Beklenen dosya | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| cadir | `yapi/cadir.glb` | var (dönem kontrolü ayrı) | aynı yol | keçi kılı kara çadır, Turkmen yurt, not camping tent | orta |
| kulube | `yapi/ev.glb` | var | aynı | toprak dam, kerpiç, mud-brick hut | orta |
| tarla, bostan | düzlem + kutu sap | placeholder | isteğe bağlı `yapi/tarla.glb` | karık, ekin, furrowed field | düşük |
| hizarhane | sundurma kutusu + `dead_tree_trunk_02` | placeholder | `yapi/hizarhane.glb` | hızar, sundurma, saw pit | orta |
| odunluk | aynı sundurma | placeholder | `yapi/orman_kampi.glb` | orman kampı, tomruk, wood camp | orta |
| tas_ocagi | Poly Haven kaya | yarım | `yapi/tas_ocagi.glb` | açık ocak, kama, quarry | orta |
| avci | çadır + sırık | yarım | `yapi/avci.glb` | avcı çadırı, kurutma sırığı | düşük |
| atolye, demirhane | sundurma + sandık | placeholder | `yapi/demirhane.glb` | örs, körük, anvil, no fantasy forge | yüksek |
| ambar | `kervansaray.glb` | yarım | `yapi/ambar.glb` | tahıl ambarı, barn, not caravanserai | yüksek |
| firin | ahşap kutu | placeholder | `yapi/firin.glb` | tandır, kubbesiz toprak fırın | yüksek |
| degirmen | kutu | placeholder | `yapi/degirmen.glb` | su değirmeni, çark, mill wheel | yüksek |
| sifahane | kutu | placeholder | `yapi/sifahane.glb` | küçük şifahane, iki yatak, healer hut | yüksek |
| ahir | kutu | placeholder | `yapi/ahir.glb` | ahır, yemlik, ox stable | yüksek |
| agil | CHR hedefi, kurulamaz, görsel yok | yok | `yapi/agil.glb` | ağıl, taş çevirme, sheep pen | ileri |
| kirec_kuyusu | kutu | placeholder | `yapi/kirec_kuyusu.glb` | kireç kuyusu, lime pit | orta |
| tas_ev | kutu, ikon kulübe | placeholder | `yapi/tas_ev.glb` | yığma taş ev, six beds, rubble stone | orta |
| demir_madeni | kutu | placeholder | `yapi/demir_madeni.glb` | açık maden ağzı, ore pit | orta |
| demir_ocagi | kutu | placeholder | `yapi/demir_ocagi.glb` | eritme ocağı, bloomery | orta |
| muhafiz_kislasi | kutu | placeholder | `yapi/muhafiz_kislasi.glb` | nöbet barakası, mızrak sehpası, not castle | yüksek |
| gozetleme_kulesi | menü `model_var_mi` ile atlar | yok | `assets/model/yapi/gozetleme_kulesi.glb` | dört direkli ahşap kule, merdiven, watchtower | orta |
| pazar_tezgahi | GLB var, sahne kurmuyor | yarım | `assets/model/yapi/pazar_tezgahi.glb` | saz çatı, çuval, market stall | orta |
| kuyu | `nesne/kuyu.glb` sahnede ayrı | var | aynı | taş kuyu, çıkrık | düşük |
| sur 2–3 | kazık çit ölçeklenir, `SurHasarGorseli` | yarım | `yapi/sur_tas.glb`, `yapi/burc.glb` | kaba taş sur, mazgal, no castle crenellation fantasy | orta |

İskele (inşaat) kasıtlı kutu. Ayrı model şart değil.

### C2. İkonlar

`YapiKarti.IKONLAR` dışı türler `kulube.svg` alır: bostan, demirhane, değirmen, şifahane, fırın, ahır, kışla, demir madeni, demir ocağı. `KaynakGostergesi.ikon` `res://assets/ui/koy/<tur>.svg` yükler. Eksik dosya Godot’ta hatalı doku basar.

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| IKN-KURK | Avcı üretimi ve ambar bozulma sırası (`kaynaklar.gd`, `ambar_bakimi.json`). HUD şeridinde yok; pazar metinle yazar. | yok | `res://assets/ui/koy/kurk.svg` | kürk, post, fur pelt, bronze tint, CC-uyumlu tek renk SVG | yüksek |
| IKN-YAPI | Yapı kartı. Hepsi kulübeye düşmesin. | yok | `firin.svg`, `degirmen.svg`, `sifahane.svg`, `ahir.svg`, `agil.svg`, `demirhane.svg`, `kislasi.svg`, `maden.svg`, `ocak.svg`, `kirec_kuyusu` zaten `kirec.svg` | fırın, çark, yatak, ahır, örs, kışla, maden, tek renk SVG 32–48 | orta |
| IKN-UYARI | Görsel plan yolu. Güncel HUD yüklemiyor. | yok | `res://assets/arayuz/ikonlar/uyari_isci_yok.png`, `uyari_hammadde_yok.png`, `uyari_ambar_dolu.png` | uyarı, meşale rengi, no red cross, worker, raw material, full barn | düşük |
| IKN-BAR | Sanat kitabı çatlayan levha. KAP-12 `ProgressBar` kullanır; PNG yüklenmez. | placeholder, atıl | `assets/art/ui/ui_bar_segment_{full,empty,cracked_01,cracked_02}.png` | taş levha, çatlak, ink slab, 22×30 | düşük |
| IKN-KESE-BOS | Dosya var, kod yüklemez. | placeholder, atıl | `icon_bribe_pouch_empty_48.png` | boş kese, kesik çizgi | düşük |
| IKN-MESALE-2D | Köy 3B meşale kullanır. | placeholder, atıl | `assets/art/fx/fx_torch_village_01.png`, `fx_torchlight_patch_village_01.png` | düz alev, amber leke, no glow | düşük |

### C3. Köy ve olay sesi — placeholder, dosya var

Olay `.tres` eşlemesi dolu dosyalara gidiyor (`sfx_kurt`, `sfx_kavga`, `sfx_ruzgar`, `sfx_ok`, `sfx_oksuruk`, `sfx_yagmur`, `sfx_hasat`, `sfx_kalabalik`, `sfx_cekirge`, `sfx_kervan`, `muzik_dugun_dongu`). Eksik yol yok. Hepsi sentez.

| ID | Yol | Ne için | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|
| SES-KOY-GUNDUZ | `ortam_koy_gunduz.wav` | SYS-04 gündüz | çekiç, koyun, su, distant hammer, sheep, stream | yüksek |
| SES-KOY-GECE | `ortam_koy_gece.wav` | SYS-04 gece | meşale, kurt, baykuş, owl, wolf far | yüksek |
| SES-KOY-ESKI | `ortam_koy_dongu.wav` | Eski tek döngü, test hâlâ arar | genel köy gece | düşük |
| SES-DUGUN | `muzik_dugun_dongu.wav` | `dugun.tres`, `bebek.tres` | davul, zurna, 9/8, wedding, no lyrics | yüksek |
| SES-INSAAT | `sfx_insaat.wav` | İnşaat | tokmak, timber mallet | orta |
| SES-HASAT | `sfx_hasat.wav` | Harman, gece raporu | orak, sap, sickle | orta |
| SES-EKIM | `sfx_ekim.wav` | Ekim | tohum, toprak | orta |
| SES-KURT | `sfx_kurt.wav` | Kurt olayı | uzak uluma, wolf howl | orta |
| SES-YAGMUR | `sfx_yagmur.wav` | Tarla yağmuru | yağmur, çatı, rain on earth | orta |
| SES-RUZGAR | `sfx_ruzgar.wav` | Kuraklık, don | bozkır rüzgârı | orta |
| SES-KERVAN | `sfx_kervan.wav` | Kervan | çan, teker, camel bell | orta |
| SES-OK | `sfx_ok.wav` | Okçuluk | yay, ok, bow release | orta |
| SES-OKSURUK | `sfx_oksuruk.wav` | Salgın | öksürük, cough | orta |
| SES-CEKIRGE | `sfx_cekirge.wav` | Çekirge | çekirge, locust | düşük |
| SES-KAVGA | `sfx_kavga.wav` | Hırsızlık | bağırış, scuffle, no gore | orta |
| SES-KALABALIK | `sfx_kalabalik.wav` | Pazar, yangın | pazar uğultusu, crowd murmur | orta |
| SES-SALDIRI | `sfx_saldiri.wav` | Baskın | kısa nara, attack sting | orta |
| SES-GECE-BITTI | `sfx_gece_bitti.wav` | Gün kapanışı | alçak kapanış, night end | orta |
| SES-BAR | `sfx_bar_catlak.wav`, `sfx_bar_kirildi.wav` | Bar çatlak / kırık | taş çatlak, crack, break | orta |
| SES-AT | `sfx_at_nali.wav` | At nalı (dosya var) | nalı, hoof | düşük |

Henüz kodun aramadığı sesler (ileri): `muzik_menu`, `muzik_perde2_dongu`, `muzik_saldiri`, `muzik_son_*` (beş son), `ortam_kis_dongu`, `ortam_pazar`, `sfx_yangin`, `sfx_keci`, `sfx_koyun`, `sfx_tekfur_boru`. WAV, aynı klasör.

### C4. Hayvan ve prop

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| HYV-OKUZ | Kapı kağnısı. Dosya var. | var | `assets/model/nesne/okuz.glb` | öküz, yoke | — |
| HYV-AT | Sorhan, Nogay, kervan, TUC, HAR-07 | yok | `assets/model/nesne/at.glb` | steppe horse, felt saddle, idle | ileri |
| HYV-KOYUN | Ağıl, ANI-05, TUC-02 | yok | `koyun.glb` | yün, sheep, low poly | ileri |
| HYV-KECI | Yusuf olayı | yok | `keci.glb` | kara keçi, goat | orta |
| HYV-DEVE | Kervan | yok | `deve.glb` | yüklü deve, camel bales | düşük |
| HYV-KOPEK | Gece köy | yok | `kopek.glb` | kangal, lying dog | düşük |
| PROP-ORS | Demirhane izi | yok | `nesne/ors.glb` | örs, kütük, anvil | orta |
| PROP-TEZGAH | Ayşe / bez | yok | `nesne/dokuma_tezgahi.glb` | kilim tezgâhı, loom | düşük |
| PROP-AGAC-2 | Tek `agac.glb` | yarım | `agac_02.glb`, `kaya_02.glb` | servi, kuru meşe, ikinci kaya | düşük |

### C5. VFX

Kapı alev/duman `src/dunya/alev.gdshader`, `duman.gdshader`. Düşük profilde kapanır (BUG-10). Ayrı sprite sheet yok. Kar/yağmur ADM-12 deneyinde shader + 600 tane; mevsim paketi (MEV-04) için ayrı doku şart değil, parçacık dokusu istenirse:

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| VFX-KAR | MEV-04 / ADM-12 | shader var, doku yok | öneri `assets/art/fx/fx_snow_01.png` | kar tanesi, soft white, 64px | ileri |
| VFX-YAGMUR | MEV, ANI-09, tarla olayı | ses var, damla dokusu yok | `fx_rain_streak_01.png` | ince yağmur çizgisi | ileri |
| VFX-KIVILCIM | ANI-15, BUG-10 | shader | `fx_spark_01.png` | kıvılcım, ember | ileri |
| VFX-SIS | MEV-09 kapı görüşü | sis parametresi var | isteğe bağlı `fx_fog_noise.png` | tipi, sis, blizzard | ileri |

### C6. Palet ve logo

| ID | Ne için | Durum | Yol | Anahtar kelimeler | Öncelik |
|---|---|---|---|---|---|
| PALET | Sanat kitabı 8.13 | yok | `assets/palette/palette.gpl`, `.ase`, `palette_swatch.png` | 7 hex swatch | düşük |
| LOGO | Menü adı düz metin. `project.godot` ikon yok. | yok | `assets/art/ui/logo_kapi_muhafizi.png`, `icon.png` | kelimesiz damga veya sade yazı, gece, meşale, 512 ve 1024 | düşük |

---

## D. İleri — kodlanmamış ROADMAP

Varlık adı öneridir. Kod bu yolları henüz yüklemez. Öncelik sütunu ileri.

| ID | ROADMAP | Ne | Format | Anahtar kelimeler |
|---|---|---|---|---|
| ANI-SILAH | ANI-01, ANI-11 | Kılıç, kalkan, mızrak, meşale soketi | glTF, el kemiği | curved sabre, round shield, spear, torch, BoneAttachment |
| ANI-ALET | ANI-03, ANI-08, ANI-11 | Kova, orak, balta, örs çekici, fırın küreği | glTF | yoke, sickle, axe, peel |
| ANI-HAYVAN-SURU | ANI-04, ANI-05 | Öküz yürüyüş, koyun otlama | glTF klip | ox walk, sheep graze |
| TUC-TACIR | TUC-01…04, 08 | Celep, nalbur, kumaşçı, aktar, silah tüccarı | `karakter/<ad>_yuru.glb` | livestock dealer, black-market arms, felt merchant |
| TUC-HAYVAN | TUC-02, TUC-14 | İnek, koç, beygir | glTF | cow, ram, riding horse |
| TUC-UI | TUC-05, TUC-10 | Sözleşme ve pazar paneli ikonları | SVG/PNG 48 | contract, price, caravan |
| MEV-ZEMIN | MEV-04, MEV-05 | Kar örtüsü, çatı karı, kürek | shader + PNG; `kurek.glb` | snow overlay, roof snow, shovel |
| MEV-AFET | MEV-06, MEV-07, MEV-10 | Su bendi, yangın, kurt sürüsü | glTF + PNG | flood, wildfire, wolf pack |
| MEV-SENLIK | MEV-08 | Hasat şenliği bezeme | PNG/glTF | harvest fair, davul |
| MEV-HUD | MEV-12 | Mevsim ikonu dört adet | `assets/ui/koy/mevsim_{ilkbahar,yaz,sonbahar,kis}.svg` | season icon, bronze |
| CAS-DIVAN | CAS-05, CAS-14 | Divan sahnesi, kanıt kartı | `src` sahne ayrı; görsel `assets/art/ui/divan_kart.png` | court, evidence card |
| CAS-GECE | CAS-02, CAS-04 | Fener, yangın kovası | glTF | lantern, bucket chain |
| ODA-ODA | ODA-01, ODA-08 | Muhafız odası, yatak, masa, kasa, kütüphane | `assets/model/yapi/muhafiz_odasi.glb` + prop | guard room, hidden floor chest, bed |
| ODA-UI | ODA-04…06, ODA-15 | Terazi, yetenek, epilog | PNG 1920×1080 | justice scale, corruption, epilogue Venice / hero |
| HAR-HARITA | HAR-01 | Taşlık Hisar, Karaboran, Tekfur, göç yolu | `assets/art/env/harita_uc.png` | strategic map, no modern border, parchment ink |
| HAR-SAVAS | HAR-10 | Okçu / mızraklı yerleştirme ikonları | PNG 64 | archer slot, spear slot |
| KRI-HASTA | KRI-01, KRI-11 | Ateş, irin, öksürük portre varyantı | PNG kart üstü leke | fever, plague, quarantine |
| KRI-MEZAR | KRI-05 | Toplu mezar, yazısız taş | glTF | unmarked grave |
| SYS-SON | SYS-19, SYS-20 | Beş son + epilog karesi | PNG 1920×1080 | Ertuğrul obası, Ahi, Tekfur haraç, beyin uç köyü, uç tutundu |
| SYS-PROLOG | eski eksik listesi | Kösedağ, kaçış, kapı, 3–4 kare | PNG | prologue, no caption baked in |

EKO-14 ve EKO-15 yeni ikon şart koşmuyor: çift kasa ve bilanço mevcut `akce.svg` ve metinle gidebilir. Ayrı zimmet ikonu istenirse `assets/ui/koy/zimmet.svg`.

---

## E. Bilinçli olarak yazılmayanlar

- KAP-02, KAP-03, EKO-14, BUG-03 ve SYS-09 (`metinler.csv`) bu turda değiştirilmedi. BUG-03 rüşvet repliği sessizliği kod/CSV işidir; `sfx_kese.wav` diskte var.
- `koy_sahnesi` / `KoyYerlesimi` yok ve eklenmedi.
- `production/eksikler/01` “yalnız yürüme klibi var” der. CHR modellerinde dört duygu klibi vardır; eksik olan `gergin` ve modele göre `ofke` veya `panik`.
- `production/eksikler/02` “15 wav” der. Şu an 39 wav var; hepsi hâlâ sentez.
- İskelet `.glb` ve `*_Image_0.jpg` için `.import` artığı görülebilir. Oynatıcı `*_yuru.glb` ve `hareket/*.res` yükler. Bu artıklar ayrı “bozuk oynanış yolu” sayılmadı.

## F. Üretim sırası (kısa)

1. Kapı karar ikonları, imleç, kapı/menü WAV (gerçek kayıt, aynı ad).
2. Selçuklu kapı iç modeli; `large_castle_door` yedeğe kalsın.
3. Her CHR için `gergin` + eksik `ofke` veya `panik`.
4. Heybe/nişan PNG ve kişiye özel portre (KAP-06 izi okunur olsun).
5. Ambar, fırın, değirmen, şifahane, ahır, kışla, demirhane GLB; `kurk.svg`.
6. İleri paketler ancak ilgili ROADMAP maddesi açılınca.

## G. Ajan eklemeleri

Kullanım kuralı dosyanın başında. Her satır bir eksik asset; en yenisi en altta.

| ID | ROADMAP | Ne | Tür / format | Yer tutucu yolu | Anahtar kelimeler (TR + EN) | Öncelik | Ekleyen |
|---|---|---|---|---|---|---|---|
| ANI07-ISINMA | ANI-07 | İki el ateşe uzatılan ısınma döngüsü | glTF / iskelet animasyon klibi | res://src/koy/gorsel/ates_basi_rutini.gd (kol hedefleri; yeni asset dosyası yok) | ateş başı el ısıtma, köylü gece; campfire warm hands villager idle | orta | Codex |
| ANI08-TEZGAH | ANI-08 | Örs ve fırın ağzı | glTF | res://src/koy/gorsel/zanaat_tezgahi.gd (kur: BoxMesh) | ortaçağ örs demirci ocağı fırın; medieval anvil forge oven | orta | Codex |
| ANI08-HAREKET | ANI-08 | Çekiç vurma ve fırın küreği döngüsü | glTF / iskelet animasyon klibi | res://src/koy/gorsel/zanaat_tezgahi.gd (kol: mevcut modifier yer tutucusu) | demirci çekiç vurma fırıncı kürek; blacksmith hammer strike baker peel | orta | Codex |
| ANI09-SACAK | ANI-09 | Yağmurdan korunma saçağı | glTF | res://src/koy/gorsel/karakter_hava_tepkisi.gd (sacak_kur: düz BoxMesh) | ortaçağ ev saçağı yağmur barınağı; medieval eaves rain shelter | orta | Codex |
| ANI09-BUZULME | ANI-09 | Soğukta büzülmüş yürüyüş | glTF / iskelet animasyon klibi | res://src/dunya/durus_duzeltici.gd (hava_egimi: mevcut modifier yer tutucusu) | soğuk köylü büzülmüş yürüme; cold villager hunched walk | orta | Codex |
| ANI10-SINSI | ANI-10 | Sinsi yürüyüş ve temkinli kuytu bekleyiş | glTF / iskelet animasyon klibi | res://src/koy/gorsel/sinsi_gece_rutini.gd + koy_halk_hareketi.gd (_adim: mevcut yürüyüş yavaşlatılır) | gece sinsi köylü temkinli yürüyüş; night villager stealth cautious walk idle | orta | Codex |
| ANI11-ALET | ANI-11 (ANI-ALET mevcut ihtiyaç) | Gerçek çekiç ve fırın küreği; sokete hazır tutma noktası | glTF | res://src/koy/gorsel/zanaat_tezgahi.gd (_kur: mevcut düz kutular); res://src/dunya/karakter_ekipman_yoneticisi.gd (tak: tek soket) | ortaçağ çekiç fırın küreği el soketi; medieval hammer baker peel hand grip socket | orta | Codex |
| ANI12-IDLE | ANI-12 | Üç doğal bekleme döngüsü (nefes / ağırlık aktarma / çevreye bakış) | glTF / iskelet animasyon klibi | res://src/dunya/karakter_bekleme_cesitliligi.gd (acilar: mevcut modifier yer tutucusu) | köylü doğal bekleme nefes ağırlık bakış; villager idle breathing weight shift look around | orta | Codex |
| TUC04-AFYON | TUC-04 | Afyon stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | ortaçağ şifahane afyon; medieval apothecary poppy medicine icon | orta | Codex |
| TUC04-SARGI | TUC-04 | Sargı stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | şifahane bez sargı; medieval linen bandage icon | orta | Codex |
| TUC04-KECE | TUC-04 | Keçe stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | yün keçe kumaş; medieval wool felt icon | orta | Codex |
| TUC04-KUMAS | TUC-04 | Kumaş stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | dokuma kumaş rulosu; medieval woven cloth roll icon | orta | Codex |
| TUC11-MUHUR | TUC-11 | Yasak mühür oda envanteri ikonu | SVG / PNG | res://src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd (ac: düz ColorRect) | yasak mühür; forbidden medieval seal icon | orta | Codex |
| TUC11-IKSIR | TUC-11 | Kaçak iksir oda envanteri ikonu | SVG / PNG | res://src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd (ac: düz ColorRect) | kaçak iksir; contraband potion bottle icon | orta | Codex |
| TUC08-ZIRH | TUC-08 | Zırh stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | ortaçağ zırh; medieval armor icon | orta | Codex |
| TUC08-YAY | TUC-08 | Yay stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | ortaçağ yay; medieval bow icon | orta | Codex |
| TUC08-KALKAN | TUC-08 | Kalkan stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | ortaçağ kalkan; medieval shield icon | orta | Codex |
| TUC03-CIVI | TUC-03 | Çivi stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | ortaçağ çivi; medieval iron nail icon | orta | Codex |
| TUC03-TIRPAN | TUC-03 | Tırpan stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | tırpan tarım aleti; medieval scythe tool icon | orta | Codex |
| TUC03-BALTA | TUC-03 | Balta stok ikonu | SVG / PNG | res://src/arayuz/koy_hud/gezgin_stok_ikonu.gd (ikon: düz ColorRect) | balta oduncu aleti; medieval wood axe icon | orta | Codex |
| TUC02-OKUZ | TUC-02 / TUC-14 | Öküz barınak modeli | glTF | res://src/koy/gorsel/celep_hayvan_gorseli.gd (_yer_tutucu: düz renk BoxMesh; mevcut öküz modeli sonraki asset incelemesinde değerlendirilebilir) | öküz çeki hayvanı; medieval draft ox | orta | Codex |
| TUC02-INEK | TUC-02 / TUC-14 | İnek barınak modeli | glTF | res://src/koy/gorsel/celep_hayvan_gorseli.gd (_yer_tutucu: düz renk BoxMesh; mevcut öküz modeli sonraki asset incelemesinde değerlendirilebilir) | inek ahır; medieval stable cow | orta | Codex |
| TUC02-BEYGIR | TUC-02 | Beygir barınak modeli | glTF | res://src/koy/gorsel/celep_hayvan_gorseli.gd (_yer_tutucu: düz renk BoxMesh; mevcut öküz modeli sonraki asset incelemesinde değerlendirilebilir) | beygir yük atı; medieval pack horse | orta | Codex |
| TUC02-KOC | TUC-02 / TUC-14 | Koç barınak ve sürü modeli | glTF | res://src/koy/gorsel/canli_hayvan_surusu.gd → res://src/koy/gorsel/celep_hayvan_gorseli.gd (_yer_tutucu: düz renk BoxMesh; mevcut öküz modeli sonraki asset incelemesinde değerlendirilebilir) | koç ağıl; medieval sheep ram pen | orta | Codex |
| ANI15-DUMAN | ANI-15 | Fırın/demirhane yumuşak duman atlası | PNG / parçacık atlası | res://src/koy/gorsel/atolye_parcaciklari.gd (_yer_tutucu: gri saydam BoxMesh) | fırın baca duman atlası; oven chimney smoke puff atlas | orta | Codex |
| ANI15-KIVILCIM | ANI-15 | Örs kıvılcım sprite | PNG / parçacık | res://src/koy/gorsel/atolye_parcaciklari.gd (_yer_tutucu: turuncu BoxMesh) | demirci örs kıvılcım; blacksmith anvil spark sprite | orta | Codex |
| ANI15-SU | ANI-15 | Sulama su damlası sprite | PNG / parçacık | res://src/koy/gorsel/atolye_parcaciklari.gd (_yer_tutucu: mavi BoxMesh) | sulama su damlası; irrigation water droplet particle | orta | Codex |

| MEV04-KAR | MEV-04 (VFX-KAR mevcut ihtiyaç) | İsteğe bağlı yumuşak kar tanesi | PNG / parçacık atlası | res://src/debug/iklim_gorseli.gd (tek BoxMesh yağış); res://src/koy/gorsel/cati_kar_ortusu.gdshader (üst yüzey renk geçişi) | yumuşak kar tanesi çatı kar; soft snowflake roof snow overlay | düşük | Codex |
| MEV05-KUREK | MEV-05 | Kar küreme küreği ve temizlik klibi | glTF / iskelet klibi | res://src/koy/gorsel/cati_kar_rutini.gd (tek RightHand soketi, düz BoxMesh sap/ağız) | kar küreme çatı küreği; roof snow clearing shovel animation | orta | Codex |

ANI-08 ANI-ALET mevcut satırı kullanır; örs/fırın/çekiç/kürek düz renk kutu yer tutucularının tek değişim noktası `res://src/koy/gorsel/zanaat_tezgahi.gd` → kur/_kur, denge `data/zanaat_tezgahi.json`. Yeni asset dosyası üretilmedi/indirilmedi.

ANI-09 yağmur efekti mevcut VFX-YAGMUR satırında; yeni doku/ses/parçacık/klip üretilmedi veya indirilmedi. Hava denetçisi yağmur seçimini mevcut kayıt içinde korur; rastgele yağış takvimi MEV paketine aittir.
