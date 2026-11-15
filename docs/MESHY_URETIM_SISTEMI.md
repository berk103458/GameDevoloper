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
_Üreten: `python3 tools/meshy/meshy_hat.py kuru --belgeye-yaz` — 2026-11-15T18:30:59Z. Fiyat kaynağı: https://docs.meshy.ai/en/api/pricing (erişim 2026-11-15)._

| Ölçü | Değer |
|---|---|
| Manifest satırı (toplam) | 933 |
| Zaten var (`mevcut`) | 649 |
| — Meshy modeli (eski hat; festive + keen-cerf) | 58 |
| — Meshy hareket klibi (`assets/model/hareket`) | 227 |
| — yalnız eski dalda (`claude/keen-cerf-42meo7`) | 32 |
| — hazır paket / diğer 3D dosya | 364 |
| Meshy ile üretilecek (`planli`) | 44 |
| **Tahmini toplam kredi (planlı hepsi)** | **652** |
| Topluluk adayı olan planlı satır / kredisi | 0 / 0 |
| İskelet ön koşullu klip satırı (eski karakterler) | 44 |
| Meshy topluluğundan kredisiz indirilecek (CC0) | 86 |
| Meshy dışı ihtiyaç (düzeltme, VFX, dört ayaklı klip) | 12 |
| Üretimde / üretildi / onaylı / reddedildi | 0 / 0 / 142 / 0 |
| Aynı istemli üretilecek satır grubu | 0 |
| Eşlemesiz envanter kimliği | 0 |

**Türe göre (planlı):**

| Tür | Satır | Tahmini kredi |
|---|---:|---:|
| animasyon | 44 | 652 |

**Önceliğe göre (planlı):**

| Öncelik | Satır | Tahmini kredi | Birikimli kredi |
|---|---:|---:|---:|
| yuksek | 0 | 0 | 0 |
| orta | 44 | 652 | 652 |
| dusuk | 0 | 0 | 652 |

**Öncelik sırası (üretim kuyruğu):**

| # | asset_id | Ad | Tür | Öncelik | Kredi | Plan kimlikleri | Not |
|---:|---|---|---|---|---:|---|---|
| 1 | `klip_eksik:asker` | asker eksik klipler | animasyon | orta | 23 | klip:asker, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 2 | `klip_eksik:ciftci` | ciftci eksik klipler | animasyon | orta | 23 | klip:ciftci, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 3 | `klip_eksik:ciftci_kadin` | ciftci_kadin eksik klipler | animasyon | orta | 23 | klip:ciftci_kadin, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 4 | `klip_eksik:esnaf` | esnaf eksik klipler | animasyon | orta | 23 | klip:esnaf, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 5 | `klip_eksik:aydogdu` | aydogdu eksik klipler | animasyon | orta | 23 | klip:aydogdu, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 6 | `klip_eksik:ayse_baci` | ayse_baci eksik klipler | animasyon | orta | 23 | klip:ayse_baci, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 7 | `klip_eksik:chr_001` | chr_001 eksik klipler | animasyon | orta | 11 | klip:chr_001, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 8 | `klip_eksik:chr_002` | chr_002 eksik klipler | animasyon | orta | 11 | klip:chr_002, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 9 | `klip_eksik:chr_003` | chr_003 eksik klipler | animasyon | orta | 11 | klip:chr_003, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 10 | `klip_eksik:chr_004` | chr_004 eksik klipler | animasyon | orta | 11 | klip:chr_004, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 11 | `klip_eksik:chr_005` | chr_005 eksik klipler | animasyon | orta | 11 | klip:chr_005, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 12 | `klip_eksik:chr_006` | chr_006 eksik klipler | animasyon | orta | 11 | klip:chr_006, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 13 | `klip_eksik:chr_007` | chr_007 eksik klipler | animasyon | orta | 11 | klip:chr_007, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 14 | `klip_eksik:chr_008` | chr_008 eksik klipler | animasyon | orta | 11 | klip:chr_008, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 15 | `klip_eksik:chr_009` | chr_009 eksik klipler | animasyon | orta | 11 | klip:chr_009, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 16 | `klip_eksik:chr_010` | chr_010 eksik klipler | animasyon | orta | 11 | klip:chr_010, chr_001, 004, 005, 006, 007, 009, 010 | iskelet ön koşulu; klipler: panik, gergin |
| 17 | `klip_eksik:chr_011` | chr_011 eksik klipler | animasyon | orta | 11 | klip:chr_011, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 18 | `klip_eksik:chr_012` | chr_012 eksik klipler | animasyon | orta | 11 | klip:chr_012, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 19 | `klip_eksik:chr_013` | chr_013 eksik klipler | animasyon | orta | 11 | klip:chr_013, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 20 | `klip_eksik:chr_014` | chr_014 eksik klipler | animasyon | orta | 11 | klip:chr_014, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 21 | `klip_eksik:chr_015` | chr_015 eksik klipler | animasyon | orta | 11 | klip:chr_015, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 22 | `klip_eksik:chr_016` | chr_016 eksik klipler | animasyon | orta | 11 | klip:chr_016, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 23 | `klip_eksik:chr_017` | chr_017 eksik klipler | animasyon | orta | 11 | klip:chr_017, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 24 | `klip_eksik:chr_018` | chr_018 eksik klipler | animasyon | orta | 11 | klip:chr_018, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 25 | `klip_eksik:chr_019` | chr_019 eksik klipler | animasyon | orta | 11 | klip:chr_019, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 26 | `klip_eksik:chr_020` | chr_020 eksik klipler | animasyon | orta | 11 | klip:chr_020, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 27 | `klip_eksik:chr_021` | chr_021 eksik klipler | animasyon | orta | 11 | klip:chr_021, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 28 | `klip_eksik:chr_022` | chr_022 eksik klipler | animasyon | orta | 11 | klip:chr_022, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 29 | `klip_eksik:chr_023` | chr_023 eksik klipler | animasyon | orta | 11 | klip:chr_023, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 30 | `klip_eksik:chr_024` | chr_024 eksik klipler | animasyon | orta | 11 | klip:chr_024, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 31 | `klip_eksik:chr_025` | chr_025 eksik klipler | animasyon | orta | 11 | klip:chr_025, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 32 | `klip_eksik:chr_026` | chr_026 eksik klipler | animasyon | orta | 11 | klip:chr_026, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 33 | `klip_eksik:chr_027` | chr_027 eksik klipler | animasyon | orta | 11 | klip:chr_027, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 34 | `klip_eksik:chr_028` | chr_028 eksik klipler | animasyon | orta | 11 | klip:chr_028, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 35 | `klip_eksik:chr_029` | chr_029 eksik klipler | animasyon | orta | 11 | klip:chr_029, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 36 | `klip_eksik:chr_030` | chr_030 eksik klipler | animasyon | orta | 11 | klip:chr_030, chr_002, 003, 008, 011–030 | iskelet ön koşulu; klipler: ofke, gergin |
| 37 | `klip_eksik:hasan_celebi` | hasan_celebi eksik klipler | animasyon | orta | 23 | klip:hasan_celebi, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 38 | `klip_eksik:karaca_usta` | karaca_usta eksik klipler | animasyon | orta | 23 | klip:karaca_usta, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 39 | `klip_eksik:miraen` | miraen eksik klipler | animasyon | orta | 23 | klip:miraen, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 40 | `klip_eksik:nogay` | nogay eksik klipler | animasyon | orta | 23 | klip:nogay, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 41 | `klip_eksik:saruca_hatun` | saruca_hatun eksik klipler | animasyon | orta | 23 | klip:saruca_hatun, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 42 | `klip_eksik:sorhan` | sorhan eksik klipler | animasyon | orta | 23 | klip:sorhan, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 43 | `klip_eksik:thessra` | thessra eksik klipler | animasyon | orta | 23 | klip:thessra, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
| 44 | `klip_eksik:yusuf` | yusuf eksik klipler | animasyon | orta | 23 | klip:yusuf, asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf | iskelet ön koşulu; klipler: bekle, konus, sevinc, ofke, panik, gergin |
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
