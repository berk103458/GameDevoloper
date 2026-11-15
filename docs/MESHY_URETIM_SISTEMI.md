# Meshy üretim sistemi (Kapı Muhafızı)

_Kuran: Cursor ajanı, 15 Kasım 2026. Bu görevde **hiçbir asset üretilmedi, hiç kredi harcanmadı**; hat yalnız kuru çalıştırmayla sınandı._

Ahmet 3D asset'leri Meshy ile üretmeye karar verdi. Bu belge üretimden önce kurulan hattı anlatır:
istem → Meshy görevi → indirme → doğrulama → Godot'a yerleştirme. Hattın tek amacı aynı asset'in iki kez
üretilmesini (kredi kaybı) imkânsız kılmaktır.

## 1. Kısa kullanım

```bash
python3 tools/meshy/meshy_hat.py                       # kuru çalıştırma: plan, mevcutlar, tahmini kredi (anahtar gerekmez)
python3 tools/meshy/meshy_hat.py manifest              # planlardan + diskten + eski daldan manifesti yenile
python3 tools/meshy/meshy_hat.py kuru --oncelik yuksek # seçimin kredi dökümü (ya da --sadece bey cavus, --tur karakter)
python3 tools/meshy/meshy_hat.py gecmis --esle         # Meshy hesabındaki görevleri manifestle eşle (GET, ücretsiz)
python3 tools/meshy/meshy_hat.py uret --gercek --sadece bey --onay-kredi 38   # GERÇEK üretim (kredi harcar)
python3 tools/meshy/meshy_hat.py devam --gercek --sadece bey --onay-kredi N   # yarım kalanı sürdür (yeni POST yok)
python3 tools/meshy/meshy_hat.py dogrula [ID ...]      # üçgen, boy, taban, iskelet ölçümü
GODOT_BIN=godot python3 tools/meshy/meshy_hat.py yerlestir [ID ...]   # Godot --import + klip_ayikla + godot_dogrula
python3 tools/meshy/meshy_hat.py onayla ID --not "..." | reddet ID --neden "..."
python3 -m unittest tests/tools/test_meshy_hat.py      # hedefli test (ağsız, kredisiz)
```

Ajanlar için çalışma sırası ve yasaklar: skill `meshy-uretim`
(`.agents/skills/meshy-uretim/SKILL.md`, Cursor kopyası `.cursor/skills/meshy-uretim/SKILL.md`).

## 2. API anahtarı

- Hat anahtarı şu sırayla arar: `MESHY_API_KEY` ortam değişkeni → repo kökünde `.meshy-api-key` dosyası
  (tek satır; `.gitignore`'da, git'e girmez).
- **Bu kurulumda anahtar yok** (ortam değişkeni de dosya da yok). Kuru çalıştırma, manifest, doğrulama ve
  testler anahtarsız çalışır; `gecmis`, `uret`, `devam` anahtar ister.
- Cursor bulut ajanı için: Cursor Dashboard → Cloud Agents → Secrets → `MESHY_API_KEY`. Yerel Windows için:
  `setx MESHY_API_KEY "..."` ya da `.meshy-api-key` dosyası.
- Anahtar hiçbir çıktıya yazılmaz; hata metinlerinde `msy_***` olarak maskelenir (`ortak.gizle`). Manifestte
  anahtar bulunmadığını test denetler.

## 3. Tekrar üretimi engelleyen katmanlar

Her görev açılışından önce, sırayla:

| # | Engel | Nerede |
|---|---|---|
| 1 | Manifest durumu `mevcut` / `uretiliyor` / `uretildi` / `onaylandi` ise satır üretim seçimine hiç girmez. `reddedildi` yalnız `--yeniden <id>` (açık karar) ile; önceki üretim `onceki_uretimler`e yazılır. | `meshy_hat.secim`, `ortak.KILITLI_DURUMLAR` |
| 2 | Aşamanın (önizleme, doku, iskelet, hareket:\<ad\>) görev kimliği manifestte varsa yeni POST yapılmaz, mevcut görev izlenir. | `meshy_hat._gorev_ac` |
| 3 | Hedef dosya diskte (ya da eski dalda) varsa satır `mevcut` olur; klibin `.res`'i varsa hareket atlanır. | `manifest.kur`, `_hareket_uret` |
| 4 | Meshy hesabının görev geçmişi taranır (text-to-3d, rigging, animations, image-to-3d, remesh, retexture; en yeniden 10 sayfa). Görev adı `KM\|<asset_id>\|<aşama>` ya da **aynı istem** (büyük/küçük harf ve boşluk duyarsız) eşleşirse görev benimsenir. Web arayüzünde elle açılmış görev de istemden yakalanır. Başarısız görev benimsenmez (Meshy krediyi iade eder). | `gecmisle_esle`, `esleme_uygula` |
| 5 | **Yazmadan önce kaydet:** POST'tan önce manifeste `BELIRSIZ@zaman` yazılır. Yanıt gelmezse (zaman aşımı, 5xx, bağlantı) hat **asla tekrar göndermez**; sonraki çalıştırma önce geçmişte arar. Meshy'de idempotency anahtarı olmadığı için tek güvenli yol budur. Gerçekten görev yoksa `--belirsizi-sifirla <id>`. | `_gorev_ac`, `meshy_api.post_gorev` |
| 6 | 4xx yanıtı = görev açılmadı; işaret kaldırılır, satır `planli`ya döner. 402 = kredi/plan yetersiz. | `meshy_api` |
| 7 | Süreç kilidi (`tools/meshy/.uretim.kilit`, O_EXCL): aynı makinede iki üretim aynı anda çalışmaz. | `ortak.UretimKilidi` |
| 8 | Manifestte aynı istem iki üretilecek satırda varsa üretim reddedilir (test de düşer). | `manifest.tekrar_istemleri` |
| 9 | Eski hat (`tools/model/meshy_uret.py`) manifeste yazmadığı için `--kuru` dışında `MESHY_ESKI_HAT_ONAY=1` olmadan çalışmaz. | eski hat `main` |
| 10 | Gerçek üretim: `--gercek` bayrağı, `ayarlar.json` `hesap_plani` = `ucretli`/`ucretsiz`, toplu üretim yerine `--sadece`/`--oncelik` seçimi, bakiye kontrolü, `--onay-kredi` tahmini toplama birebir eşit (ya da etkileşimli yazma), isteğe bağlı `--butce`. | `meshy_hat.uretim` |

Makineler arası koruma manifestin kendisidir: **her gerçek üretimden hemen sonra
`assets/meshy_manifest.json` ve `.csv` commit/push edilmelidir.** Karakterin ham/iskelet/hareket GLB'leri
`.gitignore` gereği repoya girmez; başka makinede bu dosyalar olmasa da manifest satırı kilitli kalır.

Kesilen iş: görev kimlikleri aşama aşama manifeste yazıldığı için `devam --gercek` kaldığı aşamadan
sürer (önizleme bitti → doku; doku bitti → iskelet; hareketlerden biri bitti → sonraki). İndirme
`.iniyor` geçici dosyasına yapılır, tamamlanınca yerine taşınır. Meshy çıktıları 3 gün saklar; bitmiş
ama indirilmemiş görev 3 gün içinde `devam` ile indirilmelidir.

## 4. Manifest

`assets/meshy_manifest.json` (tam kayıt) ve `assets/meshy_manifest.csv` (tablo görünümü; Godot'ta
`importer="keep"`, çeviri olarak içe aktarılmaz). Elle düzenlenmez; `meshy_hat.py manifest` yeniden kurar,
üretim alanlarını (durum, görev kimlikleri, dosya, sha256, harcanan kredi, doğrulama, günlük) korur.

Başlıca alanlar: `asset_id`, `ad`, `tur` (karakter/yapi/nesne/hayvan/animasyon/topluluk/duzeltme/harici),
`kaynak_plan` ve `plan_kimlikleri` (envanter, ARY-05, `production/eksikler/01`, eski hat), `prompt`,
`prompt_ozeti`, `poly_hedef`, `boy_m`, `olcu`, `doku`, `iskelet`, `hareketler`, `oncelik`, `durum`
(`planli` / `uretiliyor` / `uretildi` / `onaylandi` / `reddedildi` / `mevcut`), `meshy_task_id`,
`meshy_gorevleri` (aşama → görev), `dosya`, `ek_dosyalar`, `sha256`, `kredi_tahmini`, `kredi_harcanan`
(görevin `consumed_credits` alanından), `kaynak` (`Meshy`, `Meshy topluluk`, paket adı), `lisans_notu`,
`topluluk_adayi`, `notlar`, `uretim_gunlugu`.

Kaynaklar:

- `docs/EKSIK_ASSET_ENVANTERI.md` 3D tablosu ve ARY-05 (ROADMAP 2) tablosu — her kimlik
  `tools/meshy/plan_eki.json` `envanter` eşlemesiyle bir kanonik asset'e bağlanır (aynı nesneye ikinci ad
  açılmaz: ör. `EL-CEKIC`, `ANI-ALET`, `ANI11-ALET` → `el_cekic`). Eşlemesiz kimlik kalırsa test düşer.
- `production/eksikler/01-3d-modeller-ve-animasyon.md` — hazır Meshy istemleri.
- `tools/model/meshy_uret.py` `VARLIKLAR` — eski hattın 26 varlığı + CHR_001–030 (hepsi diskte → `mevcut`).
- `tools/meshy/plan_eki.json` `assetler` — envanterde istemi olmayanlar için İngilizce istem, boy, poly, ölçü.
- `design/art/meshy/meshy-secim.json` — 86 Meshy topluluk modeli (CC0, kredisiz indirme; üretilmez).
- Disk taraması (tüm 3D dosyalar) ve `assets/model/hareket/*.res` klipleri.
- Eski dal `claude/keen-cerf-42meo7` (**birleştirilmedi**; `git ls-tree` / `git show` ile salt okunur):
  58 3D dosya; 26'sı festive'deki dosyayla sha256 olarak aynı. Yalnız dalda olan Meshy modeli
  `assets/model/nesne/koyun.glb` → `koyun` satırı `mevcut`, dosya `git:claude/keen-cerf-42meo7:...`
  (almak için satırdaki `git show` notu). Daldaki Kenney eşyası/hayvan dosyaları `dal:` satırlarıdır.

Lisans: Meshy ücretli planda çıktı kullanıcıya aittir (Meshy Terms of Use 3.2); ücretsiz planda
CC BY 4.0'dır ve atıf zorunludur: `Model created with Meshy – CC BY 4.0 License`. Eski hatla üretilmiş
modellerin hangi planla üretildiği repoda kayıtlı değil; `lisans_notu` bunu söyler. Ahmet hesap planını
`tools/meshy/ayarlar.json` `hesap_plani` alanına yazınca yeni satırların notu kesinleşir.

## 5. Kredi tahmini

Fiyatlar `tools/meshy/ayarlar.json`'da, kaynak <https://docs.meshy.ai/en/api/pricing> (15 Kasım 2026):
Text-to-3D önizleme meshy-t2.5 / meshy-6-lite 5, meshy-6 / meshy-7.1 20; doku (refine) 2K–4K 10, 8K 15;
iskelet 5; animasyon 3/aksiyon; remesh 5; retexture 10. Varsayılan model `meshy-t2.5`
(`smart-topology`, `target_polycount` 100–30000), doku 2K PBR.

| Satır türü | Aşamalar | Kredi |
|---|---|---:|
| Karakter (iskeletli, 6 hareket) | önizleme 5 + doku 10 + iskelet 5 (yürüme/koşma ücretsiz) + 6 × 3 | 38 |
| Yapı / nesne / hayvan (dokulu) | 5 + 10 | 15 |
| Dokusuz nesne (01 planındaki küçük işaretler) | 5 | 5 |
| Paylaşımlı klip `anim_*` | referans iskelete (`ayarlar.json` `referans_iskelet` = `muhafiz`) 1 × 3 | 3 |
| Eski karakterin eksik klipleri `klip_eksik:*` | yeniden iskelet 5 + eksik hareket × 3 | 11–23 |

Tahmin üst sınırdır: Meshy başarısız görevin kredisini iade eder; gerçek harcama görevden okunup
`kredi_harcanan`'a yazılır.

`klip_eksik:*` satırlarının ön koşulu var: eski karakterlerin iskelet görev kimlikleri yalnız eski
makinedeki `tools/model/durum.json`'da, dokulu statik modeller de repoda yok. Hat bu satırlarda iskelet
görevi bulamazsa **kredi harcamadan durur**. Seçenekler: eski makinedeki `durum.json`'u getirip
`iskelet_kaynagi`nı doldurmak (o zaman yalnız 3/klip), ya da bu karakterleri yeniden üretmek (karar Ahmet'in).

<!-- MESHY_OZET_BASLA -->
_Üreten: `python3 tools/meshy/meshy_hat.py kuru --belgeye-yaz` — 2026-11-15T10:56:27Z. Fiyat kaynağı: https://docs.meshy.ai/en/api/pricing (erişim 2026-11-15)._

| Ölçü | Değer |
|---|---|
| Manifest satırı (toplam) | 531 |
| Zaten var (`mevcut`) | 247 |
| — Meshy modeli (eski hat; festive + keen-cerf) | 58 |
| — Meshy hareket klibi (`assets/model/hareket`) | 120 |
| — yalnız eski dalda (`claude/keen-cerf-42meo7`) | 32 |
| — hazır paket / diğer 3D dosya | 69 |
| Meshy ile üretilecek (`planli`) | 186 |
| **Tahmini toplam kredi (planlı hepsi)** | **2962** |
| Topluluk adayı olan planlı satır / kredisi | 21 / 344 |
| İskelet ön koşullu klip satırı (eski karakterler) | 44 |
| Meshy topluluğundan kredisiz indirilecek (CC0) | 86 |
| Meshy dışı ihtiyaç (düzeltme, VFX, dört ayaklı klip) | 12 |
| Üretimde / üretildi / onaylı / reddedildi | 0 / 0 / 0 / 0 |
| Aynı istemli üretilecek satır grubu | 0 |
| Eşlemesiz envanter kimliği | 0 |

**Türe göre (planlı):**

| Tür | Satır | Tahmini kredi |
|---|---:|---:|
| animasyon | 62 | 706 |
| hayvan | 8 | 120 |
| karakter | 23 | 851 |
| nesne | 67 | 895 |
| yapi | 26 | 390 |

**Önceliğe göre (planlı):**

| Öncelik | Satır | Tahmini kredi | Birikimli kredi |
|---|---:|---:|---:|
| yuksek | 13 | 425 | 425 |
| orta | 159 | 2327 | 2752 |
| dusuk | 14 | 210 | 2962 |

**Öncelik sırası (üretim kuyruğu):**

| # | asset_id | Ad | Tür | Öncelik | Kredi | Plan kimlikleri | Not |
|---:|---|---|---|---|---:|---|---|
| 1 | `bey` | bey | karakter | yuksek | 38 | bey, KAR-BEY |  |
| 2 | `cavus` | cavus | karakter | yuksek | 38 | cavus, KAR-CAVUS |  |
| 3 | `cocuk` | cocuk | karakter | yuksek | 38 | cocuk, KAR-COCUK, KAP17-COCUK |  |
| 4 | `dervis` | dervis | karakter | yuksek | 38 | dervis, KAR-DERVIS |  |
| 5 | `haberci` | haberci | karakter | yuksek | 38 | haberci, KAR-HABERCI |  |
| 6 | `tahsildar` | tahsildar | karakter | yuksek | 38 | tahsildar, KAR-TAHSILDAR |  |
| 7 | `tekfur_askeri` | Tekfur askeri | karakter | yuksek | 38 | KAR-TEKFUR-ASKER | topluluk adayı: B104 |
| 8 | `tekfur_elcisi` | tekfur_elcisi | karakter | yuksek | 38 | tekfur_elcisi, KAR-ELCI |  |
| 9 | `turkmen_bey_adami` | turkmen_bey_adami | karakter | yuksek | 38 | turkmen_bey_adami |  |
| 10 | `yasli` | yasli | karakter | yuksek | 38 | yasli, KAP17-YASLI |  |
| 11 | `kapi_ic` | Kapı iç yüzü | yapi | yuksek | 15 | KAPI-3D-IC |  |
| 12 | `tas_yatagi` | Taş yatağı | yapi | yuksek | 15 | BUG21-TASYATAGI |  |
| 13 | `zar` | Kemik zar (d6) | nesne | yuksek | 15 | ZAR01-ZAR |  |
| 14 | `aktar` | Aktar | karakter | orta | 38 | TUC-TACIR |  |
| 15 | `celep` | Celep (hayvan tüccarı) | karakter | orta | 38 | TUC-TACIR | topluluk adayı: K12, K14 |
| 16 | `denetci` | Beyin denetçisi | karakter | orta | 38 | DYL09-DENETCI |  |
| 17 | `erkek_cirak` | erkek_cirak | karakter | orta | 38 | erkek_cirak |  |
| 18 | `kiz_cirak` | kiz_cirak | karakter | orta | 38 | kiz_cirak |  |
| 19 | `kumasci` | Kumaşçı | karakter | orta | 38 | TUC-TACIR | topluluk adayı: K15 |
| 20 | `muhafiz` | Muhafız (oyuncu) | karakter | orta | 38 | ACL01-MUHAFIZ |  |
| 21 | `muhafiz_esi` | Muhafızın eşi | karakter | orta | 38 | ACL01-ES |  |
| 22 | `nalbur` | Nalbur | karakter | orta | 38 | TUC-TACIR |  |
| 23 | `silah_tuccari` | Silah tüccarı | karakter | orta | 38 | TUC-TACIR |  |
| 24 | `sorhan_karisi` | sorhan_karisi | karakter | orta | 38 | sorhan_karisi |  |
| 25 | `usta` | Usta (zanaatkâr) | karakter | orta | 38 | YAP03-USTALAR |  |
| 26 | `agil` | Ağıl | yapi | orta | 15 | YAPI-agil |  |
| 27 | `ahir` | Ahır | yapi | orta | 15 | YAPI-ahir |  |
| 28 | `ambar` | Ambar | yapi | orta | 15 | YAPI-ambar |  |
| 29 | `atolye` | Atölye | yapi | orta | 15 | YAPI-atolye, demirhane |  |
| 30 | `avci_cadiri` | Avcı çadırı | yapi | orta | 15 | YAPI-avci |  |
| 31 | `cozumleme_odasi` | Çözümleme odası | yapi | orta | 15 | YAP05-ODA |  |
| 32 | `degirmen` | Değirmen | yapi | orta | 15 | YAPI-degirmen | topluluk adayı: O76 |
| 33 | `demir_madeni` | Demir madeni | yapi | orta | 15 | YAPI-demir_madeni |  |
| 34 | `demir_ocagi` | Demir ocağı | yapi | orta | 15 | YAPI-demir_ocagi |  |
| 35 | `demirhane` | Demirhane | yapi | orta | 15 | YAPI-atolye, demirhane |  |
| 36 | `firin` | Fırın | yapi | orta | 15 | YAPI-firin | topluluk adayı: A177, A181 |
| 37 | `gozetleme_kulesi` | gozetleme_kulesi | yapi | orta | 15 | gozetleme_kulesi, YAPI-gozetleme_kulesi, HAR06-KULE | topluluk adayı: A113 |
| 38 | `hizarhane` | Hızarhane | yapi | orta | 15 | YAPI-hizarhane |  |
| 39 | `kirec_kuyusu` | Kireç kuyusu | yapi | orta | 15 | YAPI-kirec_kuyusu |  |
| 40 | `muhafiz_kislasi` | Muhafız kışlası | yapi | orta | 15 | YAPI-muhafiz_kislasi |  |
| 41 | `muhafiz_odasi` | Muhafız odası iç mekânı | yapi | orta | 15 | ODA-ODA, ODA01-ICMEKAN |  |
| 42 | `odunluk` | Odunluk | yapi | orta | 15 | YAPI-odunluk |  |
| 43 | `sifahane` | Şifahane | yapi | orta | 15 | YAPI-sifahane |  |
| 44 | `su_bendi` | Su bendi modülü | yapi | orta | 15 | MEV-AFET |  |
| 45 | `sur_2_palisat` | Sur 2 — palisat ve nöbet yolu | yapi | orta | 15 | YAPI-sur 2–3 | topluluk adayı: O81 |
| 46 | `sur_3_tas` | Sur 3 — kaba taş sur | yapi | orta | 15 | YAPI-sur 2–3 | topluluk adayı: O90, O92 |
| 47 | `tas_ev` | Taş ev | yapi | orta | 15 | YAPI-tas_ev |  |
| 48 | `tas_ocagi` | Taş ocağı | yapi | orta | 15 | YAPI-tas_ocagi |  |
| 49 | `yanik_ev` | yanik_ev | yapi | orta | 15 | yanik_ev |  |
| 50 | `at` | at | hayvan | orta | 15 | at, HYV-AT | topluluk adayı: K05 |
| 51 | `beygir` | Beygir (iş atı) | hayvan | orta | 15 | TUC-HAYVAN, TUC02-BEYGIR |  |
| 52 | `deve` | deve | hayvan | orta | 15 | deve, HYV-DEVE | topluluk adayı: A140 |
| 53 | `inek` | İnek | hayvan | orta | 15 | TUC-HAYVAN, TUC02-INEK |  |
| 54 | `keci` | keci | hayvan | orta | 15 | keci, HYV-KECI | topluluk adayı: A163 |
| 55 | `koc` | Koç | hayvan | orta | 15 | TUC-HAYVAN, TUC02-KOC |  |
| 56 | `kopek` | kopek | hayvan | orta | 15 | kopek, HYV-KOPEK | topluluk adayı: B019 |
| 57 | `kurt` | Kurt | hayvan | orta | 15 | MEV-AFET, MEV10-KURT |  |
| 58 | `agac_02` | Ağaç çeşidi 2 | nesne | orta | 15 | PROP-AGAC-2 |  |
| 59 | `ahi_kusagi` | ahi_kusagi | nesne | orta | 5 | ahi_kusagi |  |
| 60 | `bakim_bezi` | Bakım bezi | nesne | orta | 15 | ISG02-ALETLER |  |
| 61 | `balta` | Balta | nesne | orta | 15 | ANI-ALET |  |
| 62 | `bostan` | Bostan | nesne | orta | 15 | YAPI-tarla, bostan |  |
| 63 | `davul_zurna` | davul_zurna | nesne | orta | 15 | davul_zurna |  |
| 64 | `divan_masasi` | Divan masası | nesne | orta | 15 | CAS05-DIVAN |  |
| 65 | `divan_oturak` | Divan oturağı | nesne | orta | 15 | CAS05-DIVAN |  |
| 66 | `dizili_taslar` | dizili_taslar | nesne | orta | 5 | dizili_taslar |  |
| 67 | `dokuma_tezgahi` | dokuma_tezgahi | nesne | orta | 15 | dokuma_tezgahi, PROP-TEZGAH | topluluk adayı: A236 |
| 68 | `el_asa` | Ahşap asa | nesne | orta | 15 | EL-ASA |  |
| 69 | `el_cekic` | Küçük el çekici / örs çekici | nesne | orta | 15 | EL-CEKIC, ANI-ALET, ANI11-ALET |  |
| 70 | `el_degnek` | Eğri değnek | nesne | orta | 15 | EL-DEGNEK |  |
| 71 | `el_heybe` | Çift gözlü heybe | nesne | orta | 15 | EL-HEYBE |  |
| 72 | `el_kamci` | At kamçısı | nesne | orta | 15 | EL-KAMCI |  |
| 73 | `el_kurk_bohca` | Kürk bohça | nesne | orta | 15 | EL-KURK |  |
| 74 | `el_odun` | İki odun | nesne | orta | 15 | EL-ODUN |  |
| 75 | `el_sandik` | Küçük sandık | nesne | orta | 15 | EL-SANDIK |  |
| 76 | `el_sepet` | Hasır sepet (el / dal sepeti) | nesne | orta | 15 | EL-SEPET, ISG02-ALETLER | topluluk adayı: O51, O01 |
| 77 | `el_sepet_buyuk` | Büyük sırt sepeti | nesne | orta | 15 | EL-SEPET-BUYUK |  |
| 78 | `el_torba` | Keten torba (chr_002) | nesne | orta | 15 | EL-TORBA |  |
| 79 | `fener` | Fener / açık kandil | nesne | orta | 15 | CAS-GECE |  |
| 80 | `firin_agzi` | Fırın ağzı | nesne | orta | 15 | ANI08-TEZGAH |  |
| 81 | `firin_kuregi` | Fırın küreği | nesne | orta | 15 | ANI-ALET, ANI11-ALET |  |
| 82 | `hasta_cadiri` | hasta_cadiri | nesne | orta | 5 | hasta_cadiri |  |
| 83 | `ilac_kutusu` | ilac_kutusu | nesne | orta | 15 | ilac_kutusu |  |
| 84 | `kalkan` | Yuvarlak kalkan | nesne | orta | 15 | ANI-SILAH | topluluk adayı: A002 |
| 85 | `kasa` | Gizli zemin kasası | nesne | orta | 15 | ODA-ODA, ODA01-KASA |  |
| 86 | `kaya_02` | Kaya çeşidi 2 | nesne | orta | 15 | PROP-AGAC-2 |  |
| 87 | `kervan_yuku` | kervan_yuku | nesne | orta | 5 | kervan_yuku | topluluk adayı: O49 |
| 88 | `kilic` | Kılıç (hafif eğri) | nesne | orta | 15 | ANI-SILAH |  |
| 89 | `kirik_kin` | kirik_kin | nesne | orta | 15 | kirik_kin |  |
| 90 | `kirmen` | Kirmen (el iği) | nesne | orta | 15 | ISG02-ALETLER |  |
| 91 | `kova` | Kova (yangın kovası) | nesne | orta | 15 | ANI-ALET, CAS-GECE |  |
| 92 | `kurek` | Ahşap kürek (kar / iş küreği) | nesne | orta | 15 | MEV-ZEMIN, MEV05-KUREK, ISG02-ALETLER |  |
| 93 | `masa` | Muhafız masası | nesne | orta | 15 | ODA-ODA, ODA01-MASA |  |
| 94 | `mesale_el` | El meşalesi / oda meşalesi | nesne | orta | 15 | ANI-SILAH, ODA01-MESALE |  |
| 95 | `mezar` | mezar | nesne | orta | 5 | mezar |  |
| 96 | `mizrak` | Mızrak | nesne | orta | 15 | ANI-SILAH, HAR10-MIZRAK | topluluk adayı: A012 |
| 97 | `mizrak_sehpasi` | mizrak_sehpasi | nesne | orta | 5 | mizrak_sehpasi | topluluk adayı: A016 |
| 98 | `nobet_ocagi` | nobet_ocagi | nesne | orta | 5 | nobet_ocagi | topluluk adayı: O05, A060 |
| 99 | `orak` | Orak | nesne | orta | 15 | ANI-ALET | topluluk adayı: A211 |
| 100 | `ors` | ors | nesne | orta | 5 | ors, PROP-ORS, ANI08-TEZGAH | topluluk adayı: A040 |
| 101 | `sacak` | Saçak | nesne | orta | 15 | ANI09-SACAK |  |
| 102 | `sancak` | sancak | nesne | orta | 5 | sancak |  |
| 103 | `sonen_ates` | sonen_ates | nesne | orta | 5 | sonen_ates |  |
| 104 | `su_kabi` | Su kabı | nesne | orta | 15 | ISG02-ALETLER |  |
| 105 | `tarla` | tarla | nesne | orta | 5 | tarla, YAPI-tarla, bostan |  |
| 106 | `toplu_mezar` | Toplu mezar | nesne | orta | 15 | KRI-MEZAR, KRI05-MEZAR |  |
| 107 | `yatak` | Muhafız yatağı | nesne | orta | 15 | ODA-ODA, ODA01-YATAK |  |
| 108 | `yay` | Kısa Türk yayı | nesne | orta | 15 | HAR10-YAY |  |
| 109 | `yemin_nesneleri` | Yemin nesneleri (ekmek, tuz, kitap) | nesne | orta | 15 | DYL03-YEMIN |  |
| 110 | `zindan_kapisi` | Zindan hücre kapısı | nesne | orta | 15 | CAS07-ZINDAN |  |
| 111 | `anim_buzulme` | Soğukta büzülmüş / karda yürüyüş | animasyon | orta | 3 | ANI09-BUZULME, B4-ILERI-KLIPLER |  |
| 112 | `anim_cekic_vurma` | Çekiç vurma döngüsü | animasyon | orta | 3 | ANI08-HAREKET, B4-ILERI-KLIPLER |  |
| 113 | `anim_dus` | Düşme | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 114 | `anim_firin_kuregi` | Fırın küreği döngüsü | animasyon | orta | 3 | ANI08-HAREKET |  |
| 115 | `anim_idle_agirlik` | Bekleme: ağırlık aktarma | animasyon | orta | 3 | ANI12-IDLE |  |
| 116 | `anim_idle_bakis` | Bekleme: çevreye bakış | animasyon | orta | 3 | ANI12-IDLE |  |
| 117 | `anim_idle_nefes` | Bekleme: nefes | animasyon | orta | 3 | ANI12-IDLE |  |
| 118 | `anim_isinma` | Isınma döngüsü (iki el ateşe) | animasyon | orta | 3 | ANI07-ISINMA |  |
| 119 | `anim_kar_kureme` | Kar küreme | animasyon | orta | 3 | MEV05-KUREK |  |
| 120 | `anim_kavga` | Kapıda itişme / kavga | animasyon | orta | 3 | CAT02-KAVGA |  |
| 121 | `anim_kos` | Koşma | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 122 | `anim_nobet` | Nöbet / mızrağa dayanma | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 123 | `anim_orak` | Orak biçme | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 124 | `anim_otur` | Oturma | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 125 | `anim_saldir` | Saldırı | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 126 | `anim_sinsi_yuru` | Sinsi yürüyüş | animasyon | orta | 3 | ANI10-SINSI |  |
| 127 | `anim_temkinli_bekle` | Temkinli kuytu bekleyiş | animasyon | orta | 3 | ANI10-SINSI |  |
| 128 | `anim_yagmur_yuru` | Yağmurda yürüyüş | animasyon | orta | 3 | B4-ILERI-KLIPLER |  |
| 129 | `klip_eksik:asker` | asker eksik klipler | animasyon | orta | 23 | klip:asker, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 130 | `klip_eksik:aydogdu` | aydogdu eksik klipler | animasyon | orta | 23 | klip:aydogdu, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 131 | `klip_eksik:ayse_baci` | ayse_baci eksik klipler | animasyon | orta | 23 | klip:ayse_baci, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 132 | `klip_eksik:chr_001` | chr_001 eksik klipler | animasyon | orta | 11 | klip:chr_001, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 133 | `klip_eksik:chr_002` | chr_002 eksik klipler | animasyon | orta | 11 | klip:chr_002, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 134 | `klip_eksik:chr_003` | chr_003 eksik klipler | animasyon | orta | 11 | klip:chr_003, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 135 | `klip_eksik:chr_004` | chr_004 eksik klipler | animasyon | orta | 11 | klip:chr_004, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 136 | `klip_eksik:chr_005` | chr_005 eksik klipler | animasyon | orta | 11 | klip:chr_005, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 137 | `klip_eksik:chr_006` | chr_006 eksik klipler | animasyon | orta | 11 | klip:chr_006, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 138 | `klip_eksik:chr_007` | chr_007 eksik klipler | animasyon | orta | 11 | klip:chr_007, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 139 | `klip_eksik:chr_008` | chr_008 eksik klipler | animasyon | orta | 11 | klip:chr_008, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 140 | `klip_eksik:chr_009` | chr_009 eksik klipler | animasyon | orta | 11 | klip:chr_009, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 141 | `klip_eksik:chr_010` | chr_010 eksik klipler | animasyon | orta | 11 | klip:chr_010, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 142 | `klip_eksik:chr_011` | chr_011 eksik klipler | animasyon | orta | 11 | klip:chr_011, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 143 | `klip_eksik:chr_012` | chr_012 eksik klipler | animasyon | orta | 11 | klip:chr_012, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 144 | `klip_eksik:chr_013` | chr_013 eksik klipler | animasyon | orta | 11 | klip:chr_013, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 145 | `klip_eksik:chr_014` | chr_014 eksik klipler | animasyon | orta | 11 | klip:chr_014, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 146 | `klip_eksik:chr_015` | chr_015 eksik klipler | animasyon | orta | 11 | klip:chr_015, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 147 | `klip_eksik:chr_016` | chr_016 eksik klipler | animasyon | orta | 11 | klip:chr_016, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 148 | `klip_eksik:chr_017` | chr_017 eksik klipler | animasyon | orta | 11 | klip:chr_017, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 149 | `klip_eksik:chr_018` | chr_018 eksik klipler | animasyon | orta | 11 | klip:chr_018, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 150 | `klip_eksik:chr_019` | chr_019 eksik klipler | animasyon | orta | 11 | klip:chr_019, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 151 | `klip_eksik:chr_020` | chr_020 eksik klipler | animasyon | orta | 11 | klip:chr_020, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 152 | `klip_eksik:chr_021` | chr_021 eksik klipler | animasyon | orta | 11 | klip:chr_021, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 153 | `klip_eksik:chr_022` | chr_022 eksik klipler | animasyon | orta | 11 | klip:chr_022, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 154 | `klip_eksik:chr_023` | chr_023 eksik klipler | animasyon | orta | 11 | klip:chr_023, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 155 | `klip_eksik:chr_024` | chr_024 eksik klipler | animasyon | orta | 11 | klip:chr_024, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 156 | `klip_eksik:chr_025` | chr_025 eksik klipler | animasyon | orta | 11 | klip:chr_025, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 157 | `klip_eksik:chr_026` | chr_026 eksik klipler | animasyon | orta | 11 | klip:chr_026, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 158 | `klip_eksik:chr_027` | chr_027 eksik klipler | animasyon | orta | 11 | klip:chr_027, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 159 | `klip_eksik:chr_028` | chr_028 eksik klipler | animasyon | orta | 11 | klip:chr_028, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 160 | `klip_eksik:chr_029` | chr_029 eksik klipler | animasyon | orta | 11 | klip:chr_029, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 161 | `klip_eksik:chr_030` | chr_030 eksik klipler | animasyon | orta | 11 | klip:chr_030, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 162 | `klip_eksik:ciftci` | ciftci eksik klipler | animasyon | orta | 23 | klip:ciftci, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 163 | `klip_eksik:ciftci_kadin` | ciftci_kadin eksik klipler | animasyon | orta | 23 | klip:ciftci_kadin, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 164 | `klip_eksik:esnaf` | esnaf eksik klipler | animasyon | orta | 23 | klip:esnaf, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 165 | `klip_eksik:hasan_celebi` | hasan_celebi eksik klipler | animasyon | orta | 23 | klip:hasan_celebi, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 166 | `klip_eksik:karaca_usta` | karaca_usta eksik klipler | animasyon | orta | 23 | klip:karaca_usta, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 167 | `klip_eksik:miraen` | miraen eksik klipler | animasyon | orta | 23 | klip:miraen, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 168 | `klip_eksik:nogay` | nogay eksik klipler | animasyon | orta | 23 | klip:nogay, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 169 | `klip_eksik:saruca_hatun` | saruca_hatun eksik klipler | animasyon | orta | 23 | klip:saruca_hatun, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 170 | `klip_eksik:sorhan` | sorhan eksik klipler | animasyon | orta | 23 | klip:sorhan, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 171 | `klip_eksik:thessra` | thessra eksik klipler | animasyon | orta | 23 | klip:thessra, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 172 | `klip_eksik:yusuf` | yusuf eksik klipler | animasyon | orta | 23 | klip:yusuf, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 173 | `kabus_golgesi` | Rüya gölgesi figürü | karakter | dusuk | 15 | ODA09-KABUS |  |
| 174 | `askilik` | Donanım askılığı | nesne | dusuk | 15 | ODA08-ASKILIK |  |
| 175 | `blok_agiz` | Ağız bloğu | nesne | dusuk | 15 | TEZ06-AGIZ |  |
| 176 | `blok_bicim` | Biçim bloğu | nesne | dusuk | 15 | TEZ05-BICIM |  |
| 177 | `blok_ham` | Ham blok | nesne | dusuk | 15 | TEZ03-HAM |  |
| 178 | `blok_iz` | İz bloğu | nesne | dusuk | 15 | TEZ04-IZ |  |
| 179 | `hediye_bohcasi` | Hediye bohçası | nesne | dusuk | 15 | ODA03-ESYA |  |
| 180 | `iksir_sisesi` | İksir şişesi | nesne | dusuk | 15 | ODA03-ESYA |  |
| 181 | `kisisel_iz` | Kişisel iz (hatıra) | nesne | dusuk | 15 | SEV03-IZ |  |
| 182 | `kutuphane` | Muhafız kütüphanesi | nesne | dusuk | 15 | ODA-ODA, ODA08-KUTUPHANE |  |
| 183 | `muhur` | Mühür | nesne | dusuk | 15 | ODA03-ESYA |  |
| 184 | `rahat_yatak` | Rahat muhafız yatağı | nesne | dusuk | 15 | ODA08-YATAK |  |
| 185 | `teslim_parcasi` | Teslim parçası | nesne | dusuk | 15 | TEZ08-PARCA |  |
| 186 | `tezgah_ortusu` | Tezgâh örtüsü | nesne | dusuk | 15 | SAB03-ORTU, TEZ01-ORTU |  |
<!-- MESHY_OZET_BITIR -->

## 6. Godot'a alma

- Klasörler: karakter `assets/model/karakter/<ad>_yuru.glb` (repoya girer; ham, `_iskelet`, `_kos` ve
  hareket GLB'leri girmez), yapı `assets/model/yapi/`, nesne `assets/model/nesne/`, hayvan
  `assets/model/hayvan/`. Hareket klipleri `tools/model/klip_ayikla.gd` ile
  `assets/model/hareket/<ad>_<hareket>.res` olur; `KarakterModel` bunları `Dunya3B.hareket_yolu()` ile
  yükler (`KarakterModel.HAREKETLER` = bekle, konus, sevinc, ofke, panik, gergin). `anim_*` klipleri bu
  listede olmadığından ayıklayıcı onları atlar; oyun koduna bağlanmaları ayrı iştir.
- İçe aktarma ayarları mevcut `.import` dosyalarıyla aynı tutulur: `nodes/apply_root_scale=true`,
  `nodes/root_scale=1.0`, `meshes/generate_lods=true`, `meshes/create_shadow_meshes=true`,
  `meshes/ensure_tangents=true`, `animation/import=true`, `animation/fps=30`,
  `gltf/embedded_image_handling=1`, `skins/use_named_skins=true`. LOD'u Godot üretir; ayrı LOD dosyası yok.
- Meshy ayarları Godot'a uygun seçildi: `origin_at=bottom` (pivot tabanda), `pose_mode=a-pose`
  (iskelet için), `height_meters` = manifestteki `boy_m`, `remove_lighting=true` (dokuya pişmiş ışık yok).
- Doğrulama iki katmanlı: `tools/meshy/glb_bilgi.py` (bağımlılıksız GLB okuyucu: üçgen, boy, taban,
  kemik, animasyon; hedefle karşılaştırma: poly ≤ %115, boy sapması ≤ %10, taban |y| ≤ 0,05 m) ve
  `tools/meshy/godot_dogrula.gd` (Godot'ta gerçekten yükleniyor mu, aynı ölçüler). İkisi mevcut
  modellerde aynı sonucu verdi (chr_001 1,78 m, yusuf 1,35 m, kuyu 2066 üçgen).

## 7. Kurulan araçlar ve kaynakları

| Araç | Ne için | Kaynak / lisans | Bu kurulumda |
|---|---|---|---|
| Meshy REST API | görev açma, izleme, geçmiş, bakiye | <https://docs.meshy.ai/en/api> (`https://api.meshy.ai/openapi`), `llms.txt`, `openapi.json` | `tools/meshy/meshy_api.py` (bağımlılıksız istemci) |
| Meshy MCP sunucusu `@meshy-ai/meshy-mcp-server` 0.6.11 | Cursor'dan salt okunur sorgu: bakiye, görev listesi, animasyon kitaplığı | <https://github.com/meshy-dev/meshy-mcp-server>, MIT | `.cursor/mcp.json` (`npx -y`, anahtar `${env:MESHY_API_KEY}`); anahtarsız açılıp 28 aracı listelediği doğrulandı. **Üretim araçları kullanılmaz** (manifeste yazmaz). |
| Meshy CLI `meshy-cli` 0.8.6 | elle kontrol (`meshy auth login`, `meshy make --dry-run`) | npm `meshy-cli`, Meshy | belgelendi, kurulmadı (hat buna dayanmaz) |
| Meshy agent skill paketi `meshy-dev/meshy-3d-agent` | genel Meshy skill'leri | <https://github.com/meshy-dev/meshy-3d-agent>, MIT; `npx skills add meshy-dev/meshy-3d-agent` (Node 22.12+) | kurulmadı: kendi üretim akışı manifesti atlar; yerine proje skill'i `meshy-uretim` yazıldı |
| Meshy Godot eklentisi | editörden Meshy'ye köprü | <https://github.com/meshy-dev/meshy-godot-plugin>, MIT, `res://addons/meshy-godot-plugin`, Pro plan | kurulmadı: editör içi üretim manifeste yazmaz; projeye addon eklemek ayrı karar |
| Meshy Blender eklentisi | Blender'dan Meshy'ye köprü | Meshy sitesi (ZIP), Blender 4.2.6+, Pro plan | kurulmadı, aynı nedenle |
| Godot 4.7.2 | başsız içe aktarma ve doğrulama | <https://godotengine.org> | sınamada `/tmp/araclar` altında kullanıldı; komutlar `GODOT_BIN` ile |
| Blender 4.2.6 LTS | ölçek, pivot, decimation (iskeletsiz modeller) | <https://www.blender.org>, GPL | `tools/meshy/blender_hazirla.py`; kuyu.glb üzerinde 2066 → 1000 üçgen, boy 1,2 m, taban 0 sınandı. İskeletli modelde ölçek/pivot bilerek yapılmaz (deri ve yürüme izleri bozulur) |
| glTF Transform CLI 4.5 | GLB inceleme ve sadeleştirme | <https://gltf-transform.dev>, MIT; `npm i -g @gltf-transform/cli` | `gltf-transform inspect x.glb`, `gltf-transform simplify a.glb b.glb --ratio 0.5 --error 0.01` sınandı |

Rig/animasyon eklentisi gerekmedi: iskelet ve animasyon Meshy'nin kendi uçlarıyla (`/v1/rigging`,
`/v1/animations`, ücretsiz `/v1/animations/library` araması) yapılır. Dört ayaklı hayvan klipleri
Meshy'de yok (rig yalnız insansı); bunlar `meshy_disi` satırlarıdır.

## 8. AGENTS.md için öneri (uygulanmadı)

AGENTS.md değiştirilmedi. Asset kuralına eklenmesi önerilen metin:

> **Meshy üretim akışı (Ahmet, Kasım 2026):** 3D model ve karakter klipleri yalnız
> `tools/meshy/meshy_hat.py` ile üretilir; Meshy web arayüzü, MCP üretim araçları, Meshy CLI ve
> Godot/Blender eklentileriyle üretim yapılmaz. Üretimden önce `meshy_hat.py kuru` çıktısı Ahmet'e
> gösterilir; gerçek üretim `--gercek --onay-kredi <tahmin>` ile yapılır ve hemen ardından
> `assets/meshy_manifest.json` + `.csv` commit/push edilir. `mevcut`/`uretiliyor`/`uretildi`/`onaylandi`
> satırı yeniden üretilmez; reddedilen satır yalnız Ahmet'in kararıyla `--yeniden` ile üretilir.
> Yeni 3D ihtiyacı envantere yazılırken `tools/meshy/plan_eki.json`'a da eşlenir. Anahtar
> `MESHY_API_KEY` ya da git dışı `.meshy-api-key`'dedir; hiçbir yere yazılmaz.

## 9. Belirlenemeyenler

- Meshy hesap planı (ücretli/ücretsiz) ve bakiye: anahtar yok. `ayarlar.json` `hesap_plani` = `bilinmiyor`;
  gerçek üretim bu alan doldurulmadan başlamaz.
- Hesabın geçmiş görevleri: anahtarsız listelenemedi. İlk iş `gecmis --esle` olmalı.
- Eski karakterlerin iskelet görev kimlikleri (`tools/model/durum.json`, yalnız eski makinede).
- `anim_*` kliplerinin Meshy kitaplık anahtarları tahmindir (`plan_eki.json` `kitaplik`); ilk gerçek
  çalıştırmada ücretsiz kitaplık aramasıyla doğrulanır, bulunamazsa kredi harcamadan durur.
- Fiyatlar 15 Kasım 2026 sayfasından; değişirse yalnız `ayarlar.json` güncellenir.
