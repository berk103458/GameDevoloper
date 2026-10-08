# Kapı Muhafızı — Oyun Raporu (yerel)

**Dal:** `claude/festive-volta-li1sfm` @ `de421a6` (origin ile eşit)
**Tarih:** 6 Ekim 2026 ~21:30 Europe/Istanbul
**Güncel talimat:** Değişiklikler iki yerel kopyada biriktirilir; Ahmet commit demeden stage/commit/push yapılmaz. Aşağıdaki önceki ortam raporu tarihsel bağlamdır.

---

## 1) Pull özeti (tam pull)

### Remote / yerel dallar
| Dal | Yerel HEAD | Remote | Not |
|---|---|---|---|
| `claude/festive-volta-li1sfm` (ana) | `de421a6` | eşit | FF: `5c56065` → `de421a6` (**3 commit**) |
| `claude/keen-cerf-42meo7` | `198397c` | eşit | Yeni commit yok |
| `cursor/chr-001-sati-4019` | `6401514` | eşit | FF 1 commit (`fd94690` → `6401514`) |

`git fetch --all --prune` yapıldı. Yedek klasör (`_import_yedek_*`) oluşturulmadı / yok.

### Festive'e gelen 3 commit
1. `3550088` — `d` — Köy HUD/hareket paketi: Cinzel font, `assets/ui/koy/*.svg`, `KaynakGostergesi` + `YapiKarti`, `KoyHalkHareketi` / `KoyRotasi`, QA kanıtları, `meshy_erisim.py`, `AGENTS.md` ekleri, `metinler.csv` HUD anahtarları.
2. `0f12879` — `d` — `AGENTS.md` genişleme + `CLAUDE.md` / `ReadmeGrok.md` küçük ekler.
3. `de421a6` — `docs: enforce automatic commits after development` — otomatik commit yetkisi notu; conflict marker temizliği.

### Diğer dal unique
- **keen:** festive'te olmayan Manor Lords / hayvan / HUD commitleri zaten önceki WIP'te (unstaged) birleştirilmiş; bu pull'da yeni remote commit yok.
- **chr-001:** `6401514` yalnızca `.meshy-api-key` ekler (API anahtarı; festive çalışma ağacına **alınmadı**, sadece local ref güncellendi).

### Pull sırası / WIP
1. CR/LF + festive+keen WIP → `stash -u`
2. `git merge --ff-only origin/claude/festive-volta-li1sfm`
3. Diğer local branch ref'leri remote'a hizalandı
4. `stash pop` → çakışmalar birleştirildi (her iki taraf korundu): `tema.gd`, `karakter_model.gd`, `koy_yonetim_sahnesi.gd`, `metinler.csv`
5. Festive `KaynakGostergesi` + WIP `KoyKaynakSeridi` ayrı dosyalarda tutuldu
6. Engelleyen tracked `.import` CR/LF temizlendi; commit yok

### Working tree (özet)
- HEAD festive ile sync.
- Unstaged WIP (festive+keen entegrasyon) duruyor: `koy_ekrani`, `koy_yonetim_sahnesi`, `karakter_model`, `oturum`, `tema`, `renkler`, `dunya3b`, `meshy_uret`, `metinler.csv`, session-logs.
- Untracked: Kenney/arayüz varlıkları, `koy_hud/*` WIP panelleri, `koy_sahnesi.gd` kalıntı, `koy/ai`, görsel arazi/atmosfer/dekor, `koy_kamerasi`, `OYUN_RAPORU.md`, vb.

---

## 2) OYUN_RAPORU güncellendi mi?

**Evet** — yol: repo kökü `OYUN_RAPORU.md` (untracked, commit edilmedi).
Tam yol: `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi\OYUN_RAPORU.md`

---

## 3) Gemini 20 maddelik ROADMAP vs güncel kod

| # | Madde | Durum | Kanıt |
|---|---|---|---|
| 1 | Köy Yönetim Çekirdeği (KoyYonetimi + KoyYonetimSahnesi) | **VAR** | `src/koy/koy_yonetimi.gd` `KoyYonetimi`; `src/dunya/koy_yonetim_sahnesi.gd` `KoyYonetimSahnesi`; sinyaller `koy_ekrani.gd` (`devam_istendi`, `oturum_bitti`). Kalıntı: untracked `koy_sahnesi.gd` (ana yol değil). |
| 2 | koy_nufusu / nufus_yoneticisi demografi | **KISMİ** | `src/sistemler/koy_nufusu.gd` `KoyNufusu` var. `nufus_yoneticisi.gd` yok. |
| 3 | src/koy/binalar/ BinaTemel | **KISMİ** | `src/koy/binalar/` ve `BinaTemel` yok. Yerine `KoyBinasi` + `BinaKatalogu` + `BinaDekoratoru`. |
| 4 | gece_sonu() / gece_raporu Dictionary | **VAR** | `Oturum.gece_sonu() -> Dictionary`; dönüşte `rapor` anahtarı. Ayrı `gece_raporu` adı yok. |
| 5 | Kapı diyalog + tansiyon 0–10, diyalog_yoneticisi.gd | **KISMİ** | `data/diyalog/diyalog_01_20.json` + Oturum düzleştirme. `diyalog_yoneticisi.gd` yok. Tansiyon yalnız `karakterler/CHR_*.md` tasarımında. |
| 6 | Ipucu/Clue_* / ipucu_yoneticisi.gd | **YOK** | Yönetici dosyası yok; `Clue_*` yalnız MD'lerde. UI `ipucu` Label'ları yardım metni. |
| 7 | Karar matrisi dörtlü / karar_uygulayici.gd | **KISMİ** | `karar_uygulayici.gd` yok. Mantık: `Oturum.karar_ver` — kabul / harc / rusvet / kisla. |
| 8 | NPC kuyruk spawn turn offsets | **VAR** | `KapiEkrani._kuyruk` + `KapiSahnesi.kuyruk_doldur`; `i * ILERLEME_GECIKMESI` (0.35s). |
| 9 | karakter_model + _klip_onbellek + kur/yuru | **VAR** | `karakter_model.gd`: `kur`, `yuru`, `_klip_onbellek`; ayrıca `yurume_oynat` / `yurumeyi_durdur`. |
| 10 | Dunya3B, koy_kamerasi.gd | **VAR** | `dunya3b.gd` `Dunya3B`; `koy_kamerasi.gd` `KoyKamerasi`. |
| 11 | cevre_yoneticisi.gd meşale/ışık | **KISMİ** | `cevre_yoneticisi.gd` yok. `Dunya3B.mesale_kur(...)` var. |
| 12 | HUD KoyKaynakSeridi / KaynakKarti | **KISMİ** | Festive `KaynakGostergesi` + `YapiKarti`; WIP `KoyKaynakSeridi`. `KaynakKarti` adı yok. |
| 13 | Zaman hızı UI vs mantıksal tur | **VAR** | `ZamanKontrol` + `Engine.time_scale`; ekonomi `_geceye_gec` ile ayrı. |
| 14 | oturum koy_akce vs muhafiz_akce | **YOK** | Bu alan adları yok. Tek `akce` (`KoyYonetimi` / `Oturum.akce`). |
| 15 | guvenli_kayit KAYIT_SURUMU migration | **KISMİ** | `GuvenliKayit` var (tmp/bak). `KAYIT_SURUMU := 2` — eşleşmezse red; adım adım migration yok. |
| 16 | ses.gd _klip_onbellek dinamik audio | **KISMİ** | `ses.gd` kendi `_onbellek` ile yükler; `_klip_onbellek` `KarakterModel`'de (Ses clear eder). |
| 17 | metinler.csv yerelleştirme MISSING_KEY | **KISMİ** | `metinler.csv` var. `MISSING_KEY` string yok; `Katalog._anahtar_dogrula` eksikleri listeler. |
| 18 | otomatik_oyuncu.gd headless 20 tur | **KISMİ** | `tests/oto/otomatik_oyuncu.gd` + headless atlama var; sabit 20 tur yok. |
| 19 | Düşük donanım / memory_free | **YOK** | `src/` içinde yok. |
| 20 | tools/sanity_check.py veya .sh | **YOK** | `tools/` altında `sanity_check` yok. |

**AGENTS.md:** **VAR** (repo kökü; pull ile güncellendi).

---

## 4) Kısa özet (Gemini)

| Durum | Adet | Maddeler |
|---|---|---|
| **VAR** | 6 | 1, 4, 8, 9, 10, 13 |
| **KISMİ** | 10 | 2, 3, 5, 7, 11, 12, 15, 16, 17, 18 |
| **YOK** | 4 | 6, 14, 19, 20 |

AGENTS.md ayrıca **VAR** (20 maddeden bağımsız).

### Gemini'nin abarttığı noktalar
- İsimli dosya enflasyonu: `diyalog_yoneticisi`, `ipucu_yoneticisi`, `karar_uygulayici`, `cevre_yoneticisi`, `BinaTemel`, `nufus_yoneticisi`, `KaynakKarti`, `sanity_check` — çoğu yok veya farklı adla mevcut.
- Tansiyon/Clue sistemi MD'lerde dolu; **koda bağlı değil**.
- `ses._klip_onbellek` ve `MISSING_KEY` birebir yok (benzer mekanizma farklı isimle var).
- `koy_akce` / `muhafiz_akce` ayrımı yok.
- "20 tur headless" abartı; otomatik oyuncu var, tur sayısı sabit değil.
- `memory_free` yok.

### Eksik kalan öncelikler
1. Diyalog runtime: tansiyon 0–10 + Clue/ipucu motorunu tasarım MD'lerinden koda bağlamak.
2. Karar katmanı: `karar_uygulayici` ayırmak veya `karar_ver` dörtlüsünü net dokümante etmek.
3. Kayıt migration: `KAYIT_SURUMU` için gerçek yükseltme yolu.
4. `sanity_check` + isteğe bağlı düşük donanım yolu.
5. Bina maddesini `KoyBinasi`/`BinaKatalogu` ile hizalamak veya `BinaTemel` eklemek.
6. `koy_sahnesi.gd` kalıntısını ana yola sokmama (AGENTS).

---

## Pull sonrası festive yenilikleri (diskte)

- `KaynakGostergesi`, `YapiKarti`
- `KoyHalkHareketi`, `KoyRotasi`
- `assets/ui/koy/*`, Cinzel, `data/koy_hareket.json`
- QA `production/qa/evidence/koy-hud/`
- Testler: `koy_hud_kontrol`, `koy_hareket_kontrol`, `koy_rotasi` unit

WIP birleşimi: `halk_hareketi` + `_hayvanlar`/`_dekor`/`_gorunum` aynı `KoyYonetimSahnesi` içinde.

---

## Yenilik notu — ROADMAP.md

**Eklendi:** repo köküne ROADMAP.md (nihai Master Yol Haritası).
Kapsam: Bölüm 0–12 + Bölüm 2.5 (KVR) + SYS-09 anahtar standardı (replik/seçenek/heybe CSV isimlendirme).


---

## Yenilik notu — codex.md ajan günlüğü kuralı

**Eklendi:** `AGENTS.md` içine «Codex çalışma günlüğü ve ROADMAP işaretleme» kuralı (Muharrir hariç tüm ajanlar).
**Klasör:** `codex.md/` (klasör adı tam olarak `codex.md`); örnek rapor: `codex.md/Muharrir.md`.
Her commit/pull sonrası ajan kendini tanıtır, durum/plan yazar; ROADMAP’te kapanan adımları işaretler `(ajan)`.

---

## Yenilik notu — Claude / Codex / Gemini günlükleri

**Eklendi:** `CLAUDE.md` durum bölümü, `GEMINI.md`, `codex.md/Codex.md`.
Üç model için tanıt + durum + commit/pull sonrası güncelleme + ROADMAP `(Claude|Codex|Gemini)` işareti.
AGENTS yönlendirme notu: Claude→CLAUDE.md, Codex→codex.md/, Gemini→GEMINI.md; Muharrir kural dışı (isteğe bağlı).


## Codex — KVR-01 (6 Ekim 2026)

KarakterVerisi: entity_id, ad, sinif, fraksiyon, en_erken_tur sözleşmesi; eski id/en_erken_gece adaptörleri korunuyor. KVR Resource roundtrip ve mevcut 30 karakter regresyon testi başarılı.

Sıradaki: KVR-02. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-02 (6 Ekim 2026)

Şecere ve gündüz/gece davranışı kaynak anahtarlarıyla Resource alanlarına bağlandı; kayıt/yükleme ve veri izolasyonu testi geçti.

Sıradaki: KVR-03. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-03 (6 Ekim 2026)

obje_1/obje_2 sözlükleri ve StringName ipucu erişim adaptörü eklendi; iki ipucu roundtrip ve geçersiz nesne testleri geçti.

Sıradaki: KVR-04. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-04 (6 Ekim 2026)

Görsel hata ipucu, başlangıç tansiyonu ve poz anahtarları eklendi; 3/4 ve 7/8 eşikleri ile özelleştirilmiş animasyon Resource testi geçti.

Sıradaki: KVR-05. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-05 (6 Ekim 2026)

Düğüm/seçenek sözleşmesi, SYS-09 uyumlu metin anahtarları ve hedef/delta doğrulaması eklendi; kaynak izolasyonu ve bozuk zincir testleri geçti. CSV ve KAP-01 değiştirilmedi.

Sıradaki: KVR-06. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-06 (6 Ekim 2026)

Dört standart Flag sözlüğü ve sorgu başına izole kopya eklendi; bool tip/eksik/yabancı bayrak ve izolasyon testleri geçti.

Sıradaki: KVR-07. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-07 (6 Ekim 2026)

Beş kararın beş stat etkisi, kişisel akçe ve eşya alanları eklendi; eski bar API korunarak tip ve rüşvet ayrımı testleri geçti.

Sıradaki: KVR-08. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-08 (6 Ekim 2026)

Tipli gecikmeli olay dizisi ve pozitif tur/bina/olay/stat doğrulaması eklendi; negatif debuff roundtrip ve bozuk olay testleri geçti.

Sıradaki: KVR-09. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-09 (6 Ekim 2026)

Dört karar spawn sözlüğü ve kanonik CHR kimliği/pozitif offset doğrulaması eklendi; zincir roundtrip ve geçersiz veri testleri geçti.

Sıradaki: KVR-10. Yerel çalışma; commit/push yapılmadı.


## Codex — KVR-10 (6 Ekim 2026)

CHR derleyicisi 30 sayfayı doğrulayıp ayrı chr_runtime kaynakları üretiyor; 5 Python testi, 30 Resource kabul testi ve headless import geçti. Kaynak başlangıç tansiyonu 1–3 korunuyor; 93 harici spawn ID henüz kaynak sayfası olmayan referans olarak raporlanıyor. CSV/JSON kilidine dokunulmadı.

Sıradaki: KAP-04. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-04 (6 Ekim 2026)

CHR ziyaretine ayrı sorgu hafızası ve nişan inceleme paneli bağlandı; gerçek düğme tıklaması, tekrarlı inceleme ve ziyaret izolasyonu testi geçti. Mevcut heybe/JSON akışı korunuyor.

Sıradaki: KAP-05. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-05 (6 Ekim 2026)

Yük/gizli bölme eylemi ayrı ipucu üretiyor; nişanla karışmıyor ve geçersiz indeks reddediliyor. Panel inceleme sırasında alttaki ekranın tıklamalarını engelliyor; UI testi geçti.

Sıradaki: KAP-06. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-06 (6 Ekim 2026)

2D portre tıklaması kaynak fiziksel iz açıklamasını ve görsel ipucunu açıyor; mevcut portre dosyası yeniden kullanılıyor. Üç ipucunun bağımsızlığı ve tekrarlı inceleme testleri geçti.

Sıradaki: KAP-07. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-07 (6 Ekim 2026)

CHR diyalog paneli eklendi; kanıt seçeneği UI ve model katmanında kilitleniyor, herhangi bir geçerli ipucuyla açılıp parlıyor. Kaynak dallar/flaglar ve sessiz koşullu düğümler yürütülüyor; kilit, UI açılma ve sır çözme testleri geçti.

Sıradaki: KAP-08. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-08 (6 Ekim 2026)

Tansiyon 8 panik/Flag_Kilitlendi oluşturuyor, kabul ve harç kapanıyor; yalnız zorunlu ret/kışla/rüşvet kalıyor. UI ve Oturum API engeli ile duygu adaptörü eklendi; eşik, kalıcılık ve yan etkisiz ret testleri geçti.

Sıradaki: KAP-09. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-09 (6 Ekim 2026)

Blöf/ikna olasılığı ayrı Resource kurallarında; tecrübe artırıyor, tansiyon düşürüyor. Denenmiş seçenek yeniden zar atamaz; başarısızlık tansiyon/panik doğuruyor. Deterministik zar, tecrübe ve başarısızlık testleri geçti; tecrübe kayıtla korunuyor.

Sıradaki: KAP-10. Yerel çalışma; commit/push yapılmadı.


## Codex — KAP-10 (6 Ekim 2026)

Replik başında özgün kısa foley ve konuşma animasyonu tetikleniyor; metal/ferman/bebek/kabza/deri/sikke sesleri üretildi. Panel yenilemesi sesi tekrarlamaz; ses dosyaları, eşleme ve tekrar engeli testi geçti.

Sıradaki: EKO-01. Yerel çalışma; commit/push yapılmadı.


## Codex — EKO-01 (6 Ekim 2026)

Kamu/kişisel kasa ayrıldı; eski akce kamu aliası olarak kaldı. Rüşvet ve eşyası muhafıza, el koyma/harç köye gidiyor; şüpheli rüşvetin asayiş etkisi korunuyor. Çift kasa/JSON roundtrip, heybe ve kapı karar testleri geçti.

Sıradaki: SYS-01. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-01 (6 Ekim 2026)

v2 kayıtları v3 çift kasa/mevsim/yeni bina alanlarına derin kopyada göç ediyor; köy/kadro/RNG korunuyor. İdempotent göç, eski JSON yükleme ve bozuk/gelecek sürüm reddi testleri geçti. Köy içermeyen eski v1 biçimi tahmini dönüşüm yerine güvenle reddediliyor.

Sıradaki: SYS-02. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-02 (6 Ekim 2026)

Ana kayıt doğrulanmış tmp üzerinden değişiyor; yedek de bak.tmp ile atomik güncelleniyor. Yarım tmp, bozuk ana dosya ve başarısız yedek rename ana kaydı koruyor. Atomik kayıt, köy yönetimi ve headless import testleri geçti; KayitDeposu aynı güvenli APIye bağlandı.

Sıradaki: Son entegrasyon doğrulaması. Yerel çalışma; commit/push yapılmadı.


## Codex — öncelik paketi son doğrulaması

20 madde kapandı (KVR-01…10, KAP-04…10, EKO-01, SYS-01/02). 15 Godot birim testi + 5 Python testi ve gerçek kapı UI senaryosu geçti. CHR tansiyon 1–3 kararı uygulandı; kaynakta 1 olan beş karakter aynen kaldı. Festive 52cecad docs pull ve ROADMAP uzantıları korundu. CHR UI metinlerinden dahili Clue/Flag kimlikleri ayrıldı; çözülen sır eski köy bayraklarına aktarılıyor.

KVR karar/gecikmeli olay/spawn maddeleri veri şeması kapsamındadır; takip NPC sayfalarının 93 harici kimliği ve gece olaylarının uygulanması ilerleyen runtime paketlerine aittir. Teknik sınırlar: design/technical/chr-runtime.md. Commit/push yapılmadı.


## Codex — SYS-03 (6 Ekim 2026)

Tansiyon 0–3 ney/kopuz, 4–7 yaylı ve 8–10 kudüm/davul temalı özgün üç müzik katmanı eklendi. Eşikler 0.7 saniyede geçiyor; aynı eşik döngüyü yeniden başlatmıyor. Çıkışta sesler duruyor; müzik katmanı ve gerçek kapı UI testleri geçti.

Sıradaki: SYS-04. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-04 (6 Ekim 2026)

Gündüz çekiç/koyun/su, gece meşale/kurt/baykuş temalı özgün döngüler Ambiance→Efekt bus ile bağlandı. Köyün gece fazı sesi değiştiriyor; çıkışta bus geri dönüyor. Faz/idempotent geçiş ve gerçek köy UI/ses kapanışı testleri geçti.

Sıradaki: SYS-05. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-05 (6 Ekim 2026)

Ses.oynat bool API ve optional autoload adaptörü eklendi; eski cal korunuyor. Eksik/null dosya, hazır olmayan havuz, bozuk havuz indeksi ve döngü oynatıcısı güvenle atlanıyor. Yeni güvenli ses ve mevcut ses regresyon testleri geçti.

Sıradaki: SYS-06. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-06 (6 Ekim 2026)

tools/sanity_check.py tek komutta CHR/Python/headless import, 18 Godot birim testi ve 2 izole UI sahnesini çalıştırıyor. Sıfır çıkış koduyla Script Error, eksik tamamlanma işareti veya timeout başarı sayılmıyor; timeout yalnız kendi süreç ağacını kapatıyor. Tam koşu: 0 başarısız.

Sıradaki: SYS-07. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-07 (6 Ekim 2026)

Headless import tarayıcısı hata mesajlarını res://dosya ve satır bilgisiyle JSON/log raporuna çıkarıyor. Script Error ve yükleme hatası süreç 0 olsa da başarısız; warning ayrı tutuluyor. Çoklu tanı/path testi ve gerçek headless tarama geçti.

Sıradaki: SYS-08. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-08 (6 Ekim 2026)

Korumalı kur/yuru/gece_sonu, sinyal payloadları, akce/kayıt sürümü ve klip önbelleği Git tabanına karşı doğrulanıyor. Silme/tip/imza değişimi reddedilir; biçim ve sürüm değeri değişimi serbest. 4 denetçi testi ve gerçek API taraması geçti; sanity komutuna bağlandı.

Sıradaki: SYS-10. Yerel çalışma; commit/push yapılmadı.


## Codex — SYS-10 (6 Ekim 2026)

İzole model koşusu tam 20 geceyi, her gece JSON kayıt roundtrip ve bellek ölçümünü doğruladı; mevcut otomatik oyuncuya yalnız ortam değişkeni adaptörü eklendi. Tam sanity koşusu: 18 Godot birim testi, 3 kabul/duman sahnesi ve Python kontrolleri başarılı; gerçek kullanıcı kayıtları korunur.

Sıradaki: SYS-15. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — SYS-15 (6 Ekim 2026)

DUMAN_TESTI_20 modu sabit 20 iterasyon çalışır ve hem gece hem gün 20 olmadan başarılı çıkmaz. SYS-10 ile aynı doğrulanmış pakettir; normal otomatik oyuncu modu korunur.

Sıradaki: SYS-14. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — SYS-14 (6 Ekim 2026)

Göç motoru açık _v2_v3 adımı ve N→N+1 döngüsüyle ilerliyor; sürüm atlaması/kesirli sürüm güvenle reddedilir. Kişisel alanların korunması, derin kopya, idempotent yükleme ve 20 gecelik JSON dönüşüm testi geçti.

Sıradaki: KVR-12. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KVR-12 (6 Ekim 2026)

CHR bina adı sözlüğü tüm 30 sayfanın gecikmeli hedeflerini katalog türlerine eşliyor; birleşik Ağıl/Ahır iki hedef olarak korunur. Yeni CHR türleri inşa/üretim uygulaması gelene kadar kurulamaz; mevcut 8 yapı verisi aynen kaldı. Bina sözlüğü, köy regresyonu ve headless script taraması geçti.

Sıradaki: KVR-13. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KVR-13 (6 Ekim 2026)

Runtime tansiyonu doğrudan yazım dahil 0–10 sınırında; karar anlık beş stat kopyaları ve koşullu varyantlar −4…+4 sınırında. Kaynak Resource ve kişisel kasa tutarları değişmez. Sınır, sorgu/panik, çift kasa ve headless script testleri geçti.

Sıradaki: KVR-14. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.

---

## Yenilik notu — Gemini döngü 1–7 ROADMAP genişletmesi

**Güncellendi:** ROADMAP.md — Gemini döngü 1–7 birikimi (2026-10-06 Europe/Istanbul).
- Durum: KAP-01 [x]; KVR-04 başlangıç tansiyonu **1–3**; KVR-09 [/] (NPC kuyruk runtime; CHR okuma kaldı); EKO-09 [ ] BEKLEMEDE; SYS-01/10 kısmi + satır kanıtsız uyarısı (tam [x] yok).
- Örtüşme: KAP-15≡BUG-02; BUG-07≡SYS-09; ODA-02≡EKO-01/EKO-11.
- Yeni: KAP/KVR/EKO/SYS/BUG/CAS/ODA **+11…15** (taslak hedef yollar notlu).
- WIP (festive+keen) bu committe **yok**.

---

## Yenilik notu — Gemini döngü 8–10 ROADMAP genişletmesi

**Güncellendi:** ROADMAP.md — Gemini döngü 8–10 birikimi (2026-10-06 Europe/Istanbul).
- Yeni: MEV/HAR/KRI **+11…15** (taslak hedef yollar notlu).
- Örtüşme: MEV-02≡EKO-09 / MEV-11; KRI-14↔KRI-06; KRI-15↔KRI-03.
- HAR-15 [ ] BEKLEMEDE — "kodda var" geri çekildi (formül kanıtsız/taslak).
- KRI (Gemini gerçek çıktı): teşhis ibresi, açlık–sağlık çapraz, yatak/triyaj, nöbetçi ambar, şifalı ot toplama.
- WIP (festive+keen) bu committe **yok**.


## Codex — KVR-14 (6 Ekim 2026)

Null kaynak, eksik/bozuk düğüm, seçenek, bayrak, nesne, animasyon ve karar alanları kaynak verisi değiştirilmeden güvenle okunuyor. Bozuk geçiş/eşya/kasa alanları eylem üretmez; boş profil karar ekranına izin verir. Tam sanity ve ek fallback/çift kasa regresyonu geçti.

Sıradaki: KVR-15. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KVR-15 (6 Ekim 2026)

KarakterVerisi.dogrula ve hata listesi 30 derlenmiş profili yüklemede denetliyor: CHR kimliği, başlangıç tansiyonu 1–3 ve karar/varyant stat tipleri. Geçersiz kaynak Gelen adaptöründe sorguya bağlanmıyor; eski katalog korunur. 30 profil, kaynak 1 değerleri, bozuk profil, sorgu ve headless testleri geçti.

Sıradaki: KAP-11. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KAP-11 (6 Ekim 2026)

IpucuYoneticisi ziyaret başına oturumdan bağımsız Clue kaydı sunuyor; mükerrer kayıt/sinyal, boş anahtar ve Flag reddedilir. ChrSorgusu inceleme adaptörleri bu servisi kullanır; dışa verilen sözlük kopyadır. Servis, gerçek sorgu/UI ve headless testleri geçti.

Sıradaki: KAP-12. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KAP-12 (6 Ekim 2026)

0–10 canlı tansiyon barı Sakin/Gergin/Panik eşik renkleriyle sorgu sinyaline bağlandı; kalıcı kabul kilidi açıklanıyor. Eşik, renk, değer clamp ve sahne çıkışı testleri geçti; gerçek kapı UI headless ve native görüntü kontrolü tamamlandı.

Sıradaki: KAP-13. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KAP-13 (6 Ekim 2026)

Panikte Kabul düğmesi disabled olarak görünür ve gerekçesini gösterir; yalnız ret/kışla/rüşvet etkin kalır. Düğme/kısayol onay yolu ve doğrudan karar API'si kabulü yan etkisiz engeller. Gerçek kapı UI kabul testi ve korumalı API denetimi geçti.

Sıradaki: KAP-14. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KAP-14 (6 Ekim 2026)

Nişan ve yük tıklaması kaynak fiziksel açıklamasını ayrı modal karta açıyor; alttaki girdi durur ve kapatma sorguya döner. Mevcut heybe akışı ve başka ajanın dosyaları korunur. Nişan/yük kartı, gerçek kapı native görüntü ve headless tarama testleri geçti.

Sıradaki: BUG-02. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.

## Codex — Son paket doğrulaması (6 Ekim 2026)

24 Godot birim testi, iki gerçek UI kabul sahnesi ve sabit 20 gece duman koşusu geçti; Python ve korumalı API kontrolleri başarılı. KVR-04 başlangıç sözleşmesi 1–3; CHR_022/024/026/028/030 değerleri 1 korunur. Geliştirmeler PR #3’te, iki yerel kopya eşit. Sıradaki BUG-02/KAP-15 kuyruk senkronu inceleniyor.


## Codex — BUG-02 (6 Ekim 2026)

Sıra atlama kabulünde aynı Gelen ve model erase/push_front ile birlikte öne taşınır, model doğrudan kapı çizgisine yürür. Tekrarlı model adları indeksle taşınır; rüşvet kişisel keseye gider. En az iki kişi koşulu eklendi; gerçek 3D sıra atlama, ret, kasa ve mevcut kuyruk regresyonu geçti.

Sıradaki: KAP-15. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — KAP-15 (6 Ekim 2026)

BUG-02 ile aynı doğrulanmış entegrasyon paketi: gece listesi ve model kuyruğu eşleşir, öne alınan nesne kapıda yeniden yaratılmaz. Yeni gerçek sahne testi sanity paketine bağlandı; korumalı API denetimi geçti.

Sıradaki: BUG-04. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-04 (6 Ekim 2026)

Kapı noktasal gölge atlası en çok 2048; meşale ışık/gölge mesafe sönümü renderer üzerinden ayarlanır, kare başına uzaklık taraması eklenmez. Düşük kalite ve sahne açıkken değişen tercihler korunur; son kapı kapanınca atlas geri döner. Profil/çoklu sahne/ayar testleri, native kapı görüntüsü ve korumalı API denetimi geçti.

Sıradaki: BUG-05. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-05 (6 Ekim 2026)

HUD yalnız görünür aktif uyarı varken işlenir; uyarısız/oturumsuz/gizli HUD set_process(false) ile uyur ve değişimde uyanır. El eşyasının yalnız delta kopyalayan boş _process callbacki kaldırıldı; skeleton_updated ve Node kare süresi kullanılır. Uyanma/gizlenme/renk sıfırlama, kapı/köy UI ve API testleri geçti.

Sıradaki: BUG-06. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-06 (6 Ekim 2026)

Mevcut queue_free akışında sızıntı üretilemedi: gerçek Meshy karakterleriyle 6 kabul/ret rotası ve rota ortasında sahne değişimi sonunda model silindi, orphan sayısı 0 kaldı. Bu lifecycle kontrolü sanity paketine eklendi; üretim akışı gereksiz yeniden yazılmadı.

Sıradaki: BUG-08. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-08 (6 Ekim 2026)

Köy ekranı gece hesaplaşmasını ekran başına tek kilitle yürütür; düğme disabled olur ve hız 1x kalır. 2x başlangıçta tekrar sinyal/metot çağrısı gün, tüketim, kasa veya RNGyi değiştirmedi; rapor kartı korunur. Gerçek üç köylülü UI, headless ve API testleri geçti.

Sıradaki: BUG-11. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-11 (6 Ekim 2026)

BUG-08 ile aynı doğrulanmış koruma: tek geçiş kilidi + disabled gece düğmesi + rapor boyunca 1x. Yeni köy ekranı kendi kilidini alır; Oturum.gece_sonu simülasyon API imzası ve akışı değişmedi.

Sıradaki: BUG-09. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-09 (6 Ekim 2026)

Eksik/silinmiş klip, boş veya silinen AnimationPlayer güvenle atlanır; gerçek idle (adlı kitaplık dahil) bulunur, idle yoksa ilk pozda durulur. Geçerli klip ve kur/yuru APIleri korunur. Fallback, gerçek Meshy ayrılış/orphan, headless ve API testleri geçti.

Sıradaki: BUG-12. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.


## Codex — BUG-12 (6 Ekim 2026)

BUG-09 ile aynı koruma: klip eşlemesi has_animation ile doğrulanır; eksik dosya negatif önbelleğe alınır, bozuk cache değeri Animation olarak dönmez. _klip_onbellek adı/API korunur ve eksik hareket idle fallbacke gider.

Sıradaki: BUG-10. İlgili kontroller ve yerel eşitleme sonrası otomatik commit/push uygulanır.
---

## Yenilik notu — Gemini döngü 11–15 ROADMAP genişletmesi

**Güncellendi:** ROADMAP.md — Gemini döngü 11–15 birikimi (2026-10-07 Europe/Istanbul).
- Yeni: ADM/TUC/UZM/ANI **+11…15** ve SYS-16…20 (taslak hedef yollar notlu); hepsi `[ ]` BEKLEMEDE.
- UZM-15: Gemini A örtüşme notu — Bölüm 5 ANI atama önizlemesi ile birleştir/adaptör; ID silinmedi.
- Örtüşme: ANI-04↔EKO-03, ANI-08↔UZM-01..05; TUC↔EKO-01/EKO-11 çift kasa; SYS-18↔KVR-06.
- Ahmet kararı: **15’te duruldu** — tur 16 YOK.
- WIP (festive+keen) bu committe **yok**.


## Codex — BUG-10 (7 Ekim 2026)

Grafik ayarlarına Normal/Düşük profil ve %50–100 bağımsız 3B ölçek eklendi; ana/alt viewport canlı güncellenir, 2B arayüz ölçeği korunur. Düşük mod CPU/GPU partikülleri ve gerçek shader alev/duman katmanlarını kapatır; normalde asıl emisyon/katmanlar döner, gündüz görünürlüğü korunur. Geç ekleme, disk roundtrip, UI seçim/varsayılan ve bağlantı temizliği testleri geçti; native ayar ekranı görüntüsü kontrol edildi.

Sıradaki: BUG-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — BUG-13 (7 Ekim 2026)

Gerçek kapı sahnesinde kuyruk tweeni ile karar dönüşü çakışınca FOV 46 yerine 28 kalıyordu; yeniden üretildi. Kamera geçişlerinin tek sahibi son istekte eski tween/adımları iptal eder, iptal edilen await askıda kalmaz; kuyruk 28, karar 37 ve normal 46 hedefleri korunur. Çakışma, geri dönüş, bakış hedefi, sahne kapanışı ve korumalı API testleri geçti. BUG-10 sonrası tam sanity: 0 başarısız.

Sıradaki: BUG-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — BUG-14 (7 Ekim 2026)

Sahne geçişinde kısa ses havuzu stop/stream=null ile temizlenir, sıra sıfırlanır ve ses cache referansları bırakılır; sabit altı oynatıcı yeniden kullanılır. Bitmiş efekt streami bırakılır; çalan yeni efekt, müzik ve ortam döngüleri korunur. Sekiz geçiş, havuz boyutu, yeniden kullanım ve referans temizliği testi ile headless import geçti.

Sıradaki: SYS-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — SYS-13 (7 Ekim 2026)

Düşük grafik profiline memory_free adaptörü bağlandı; sahne girişinde/profil değişiminde statik model, malzeme, klip, şekil ve sanat cache referansları bırakılır. Yalnız cachete tutulan Resource serbest kalır; aktif gerçek Meshy karakterinin animasyonları/malzeme kaynakları korunur ve sonraki model yüklemesi çalışır. Tekrarlı temizlik, zayıf referans, canlı model ve grafik regresyon testleri geçti; ölçülmemiş RAM/VRAM tasarrufu miktarı iddia edilmiyor.

Sıradaki: BUG-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — son doğrulama (7 Ekim 2026)

BUG-10 sonrası tam sanity 0 başarısız; sonraki kamera/ses/bellek değişiklikleri kendi testleri, gerçek sıra atlama ve Meshy karakter ömrü (orphan=0), final headless import ve API denetimi ile doğrulandı. Son kullanıcı talimatı: Ahmet commit demeden stage/commit/push yok. BUG-15 başka ajanın aktif heybe paketiyle çakıştığı için açık bırakıldı; BUG-01 giriş yüklemeleri incelemesi sıradaki iştir.


## Codex — BUG-01 (7 Ekim 2026)

Menü/kapı font, model, PBR doku ve shader kaynakları en çok dört load_threaded_request ile hazırlanır; get yalnız LOADED durumunda çağrılır. Gece kuyruğunun gerçek model/klipleri ayrı batch alır; yükleme katmanı girdiyi engeller, sahne ilk iki çizimi örtü altında yapar ve batch referansları sonra bırakılır. Eksik/mükerrer dosya, ana kare döngüsü, gerçek Ana menü→kapı, native görüntü/kapanış, 20 gece ve tam sanity kontrolleri geçti (0 başarısız). Bu optimizasyon her GPUda sıfır takılma/FPS artışı garantisi değildir; kapanışta silinen kesme örtüsü erişimi de korundu.

Sıradaki: ADM-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-01 (7 Ekim 2026)

Global AdminHud CanvasLayer F1/~ ile açılır, ESC ile kapanır; oyun pause/hızını değiştirmez. Kapalıyken işlem yapmaz; açıkken oturum günü ve iki kasayı okur, yardim/durum/temizle komutları ile 100 satır sınırlı geçmiş sunar. Tuş tekrarı, klavye odağı, kare ilerleme, gerçek menü→kapı kalıcılığı, native görüntü/kapanış ve API testleri geçti. BUG-01 sonrası tam sanity 0 başarısız; ilk GPU pipeline hazırlığı için örtü altında iki çizim adımı ve ilgili geçiş testi de doğrulandı.

Sıradaki: ADM-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-02 (7 Ekim 2026)

Konsola Kapıyı bitir→Köy düğmesi ve ayrı atlama adaptörü eklendi. Aktif/bekleyen tekil ziyaretler gerçek Oturum.karar_ver ile rastgele kabul/ret alır; panik kabul edilmez, sonuc uygulanmış Gelen referansı tekrar sayılmaz. Gerçek Ana._koye_git güvenli kayıt ve KoyYonetimSahnesi akışını kullanır; gün/gece tüketimi değişmez. Düğme, aynı nesne tekrarları, karar animasyonu sırasında atlama, tekrar engeli, test slotu, native köy görüntüsü ve API kontrolleri geçti.

Sıradaki: ADM-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-03 (7 Ekim 2026)

Konsola +1/+5/+10 gün gece-sonu kontrolü ve ayrı ZamanMakinesi eklendi. Her gece gerçek üretim/tüketim/kadro APIleri çalışır, raporlar tutulur; olaylar geçerli seçeneklerden rastgele çözülür, mini oyun simülasyonu 0 puan alır. Terminal sonuçta veya geçerli olay seçeneği kalmadığında gerçek ilerleme sayısıyla durur; son/olay ekranı korunur. 1/5/10 doğrudan gece çağrılarıyla tüm kayıt/RNG eşitliği, toplam 16 gün gerçek düğme/kayıt, 2x hız, rapor kilidi, terminal/pending UI ve native görüntü testleri geçti.

Sıradaki: ADM-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-04 (7 Ekim 2026)

İki kasa ve gıda/odun/taş/demir için sayısal artı/eksi enjektör eklendi; kapasite ve sıfır sınırları korunur. Ahmet kararıyla beş stat mevcut modele eşlendi: Refah=kamu akçesi (alias), Erzak=gıda (alias), Güvenlik=100−asayiş riski; Moral/Sağlık her köylüye sınırlı delta, arayüzde ortalama. Boş köyde sahte değer yazılmaz; rapor/olay kilidi ve gerçek güvenli kayıt kullanılır. Model, gerçek düğme/SpinBox girişi, kayıt roundtrip, headless/native ve korumalı API kontrolleri geçti; native panel incelendi. Metin odağında köy kamera kısayolları durur, atmosfer işlemeye devam eder.

Sıradaki: ADM-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-05 (7 Ekim 2026)

Global konsola katalog kimliklerinden NPC seçici eklendi; CHR_001–030 çağrılabilir. Yeni Gelen kuyruğun önüne alınır, zaten bekleyen kişi referansı taşınır; aktif sorgu/model, eski sıra, ziyaret/karar/gün/RNG korunur. Gerçek 3B kuyruk APIsi kullanılır; yükleme/heybe/karar animasyonu sırasında çağrı kilitli. Gezgin tüccar TUC-01 uygulaması gelene kadar açıklamayla devre dışı. Gerçek düğme, 30 kimlik, tekrar/taşıma, model eşleşmesi, modelin kapıda yeniden kullanılması, headless/native ve yükleme sırasında sahne kapanışı kontrolleri geçti. Kapanış testinin bulduğu yükleme etiketi callbacki WeakRef ile düzeltildi; varlık regresyonu geçti. ADM-04 tam sanity: 0 başarısız.

Sıradaki: ADM-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-06 (7 Ekim 2026)

Global Flag/Clue denetçisi aktif CHR ziyaretinin tanımlı Flag anahtarlarını açıp kapatır; Clue kayıtları canlı salt okunur listelenir. CHR Resource, diğer ziyaret ve kilitli JSON diyalog motoru değişmez; bu geçici ziyaret durumu kayda kalıcı diye sunulmaz. Eski ziyaret callbacki yeni sorguya uygulanmaz; kalıcı panik kilidi salt okunur korunur. Açıkken 0.5 saniyede değişiklik denetlenir, kapalıyken process yok; konsol kapanınca panel de kapanır. Model izolasyonu, gerçek checkbox aç/kapat, keşif listesi, stale callback, headless/native görüntü ve API kontrolleri geçti.

Sıradaki: ADM-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-07 (7 Ekim 2026)

Konsola Godot Performance tabanlı FPS, TIME_PROCESS kare ms, son kare Draw Call, statik Godot RAM ve renderer VRAM şeridi eklendi. RAM süreç RSSsi/VRAM kart toplamı gibi sunulmaz; tooltip ölçüm kapsamını açıklar. Headless veya desteklenmeyen grafik/bellek sayaçlarında ölçüm yok gösterilir. Açıkken gerçek zamanla en çok 0.5 saniyede örneklenir; oyun hızı sorgu sıklığını artırmaz, konsol kapalıyken process yok. Gerçek sayaç, headless yokluk, örnekleme sınırı, aç/kapat, konsol regresyonu ve native görüntü kontrolleri geçti. API tanımları resmi Godot Performance dokümanından doğrulandı.

Sıradaki: ADM-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


### ADM-07 ek doğrulama

Native sayaçlar gerçek değerlerle güncellendi. Aralıklı dummy renderer doku hatası sonrası headless threaded batch tek isteğe sınırlandı; gerçek renderer dört isteği korur. Üç ardışık menü→kapı ve varlık regresyonu doğrulandı.


## Codex — ADM-08 (7 Ekim 2026)

İnşaat tamamlama, normal bina/sur seviye atlatma ve yalnız sur için sağlam/hasarlı/yanmış kısayolları eklendi. Ahmet kuralı gerçek modele bağlandı: üretim ×(1+0.25×(N−1)); yatak/depo tabanı +%20/ek seviye, yukarı yuvarlama. Normal binada hasar yok; sur hasarı 0/50/100 savunma payını düşürür ve gerçek 3B görünümü değiştirir. Eski kayıt seviye 1/hasar 0 açılır, yeni alanlar normal güvenli kayıtla korunur. Gerçek üretim/kesir artığı, kapasite/barınma, düğmeler, sur/bina kimlik ayrımı, rapor kilidi, native görüntü ve tüm sanity (20 gece dahil) geçti: 0 başarısız. İki yerel kopya eşitlendi; commit yok.

Sıradaki: ADM-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-09 (7 Ekim 2026)

Üç senaryo gerçek gece döngüsünü çalıştırıyor; kıtlık üretim sonrası gıdayı tüketiyor, baskın tek gecelik ayarla zorlanıyor, veba hasta bayrağı ve sağlık düşüşü stres önayarı (bulaşma/tedavi KRI kapsamı). Model, gerçek UI, native görüntü ve tam sanity/20 gece geçti.

Sıradaki: ADM-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-10 (7 Ekim 2026)

Köy ve kapı sorgusu ayrı atomik JSON snapshot ile geri yükleniyor. Model/RNG, diyalog önbelleği, köy kamerası; kapıda aktif gelen, gerçek bekleyen kuyruk, legacy sorular/ilk karar onayı, konuşma kaydı, heybe eşya/alinan/astar durumu, CHR bayrak/ipucu/tansiyon/düğüm/deneme/64-bit zar ve tek replik durumu korunur. Restore yeni ziyaret/karar/gece üretmez; gerçek modeller doğru sırada kurulur. Açık rapor/olay/inceleme ve yürüyüş önce tamamlanmalı. Normal slot yazılamazsa mevcut oturum korunur. Köy RNG JSON hassasiyet kaybı metinle giderildi; eski sayısal kayıt okunur. Model, gelecek dört gece, yedek/bozuk slot, CHR ve legacy gerçek UI/native, mirror UI ve tam sanity/20 gece geçti: 0 başarısız. Önceki köy-only kapanışı bu turda yeniden açılıp kapı kapsamı tamamlandı.

Sıradaki: ADM-11. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-11 (7 Ekim 2026)

Kasalar paneli: köy ve muhafız bakiyesi ayrı ayarlanır, kişisel keseye akçe eklenir, kese sıfırlama kişisel akçe ve eşyaları temizler. Kamu kasası, geçmiş rüşvet kararları, kadro, kaynaklar, gün ve tüm RNG korunur. Kararlı köy/kapıda gerçek HUD ve güvenli kayıt güncellenir; rapor/olay/heybe/geçiş kilidi doğrudan sinyalle aşılamaz. Girdi 0–1.000.000, toplama 64-bit taşma korumalı; canlı göstergeler yazılmakta olan girdiyi ezmez. Kapalı panel işlemez, konsolla kapanır. Gerçek rüşvet kararı üstüne model/JSON kontrolleri, gerçek SpinBox/düğme/kayıt/kapı/köy testleri, native görüntü, mirror import/UI ve tüm sanity/20 gece geçti: 0 başarısız. CSV değişmedi; commit yok.

Sıradaki: ADM-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-12 (7 Ekim 2026)

İklim denetçisi: otomatik/4 mevsim ve normal/kar fırtınası/kuraklık; gün/RNG ve ortak ayarlar değişmeden zorlanır, doğal takvime reset. Önayar güvenli kayıt ve snapshot'ta korunur; eski kayıtta doğal iklim. Debug denge: kuraklık gıda ×1.5 (yukarı yuvarla), fırtına odun ×2; fırtına mevcut soğuk/tarla kaydırması ve eksik yakacak hasarını çalıştırır. Arazi/çimen kar shaderı, shader ile 600 yağış tanesi ve yoğun sis; düşük profilde dekoratif yağış kapalı. Normalde eski tüketim ve görünüm korunur. Gerçek gece tüketimi/soğuk/tarla, JSON, UI/shader/yağış/HUD/rapor kilidi/reset, native görüntü, mirror import/UI ve tam sanity/20 gece geçti: 0 başarısız. MEV paketleri kapatılmadı; CSV değişmedi, commit yok.

Sıradaki: ADM-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-13 (7 Ekim 2026)

Canlı köylü/zanaat denetçisi: tüm köylüler, gerçek bina ataması ve hareket rutini; üretimle ortak stat/bayrak/açlık/seviye formülü, brüt/gece ve stok/kış/inşaat engelleri. Salt okunur Tree 500 ms yenilenir, kapalıyken işlemez; model/RNG/kayıt korunur. Birim, headless ve native UI, yerel mirror UI ve kapsamlı sanity (20 gece dahil) sıfır hata.

Sıradaki: ADM-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-14 (7 Ekim 2026)

Kriz enjektörü: tek tuş veba (hasta, sağlık −40), köy kuyusu zehri (3 gerçek gece −25 sağlık/hasta), ambar kundaklama (her stok %50 kayıp, yukarı yuvarla). Debug denge varsayımları panelde açık; gün/RNG/kasalar/binalar korunur, normal binaya hasar alanı yok. Zehir süresi güvenli kayıt ve snapshot modelinde korunur; eski kayıtta 0, hatalı alanlar reddedilir. Ölüm/üretim/iyileşme normal gece modelinden; KRI bulaşma/karantina/dezenfeksiyon paketleri kapatılmadı. Rapor/geçiş kilidi, kapalı işlem hijyeni, headless/native gerçek düğmeler, mirror import/UI ve tüm sanity (20 gece dahil) geçti: 0 başarısız; CSV değişmedi.

Sıradaki: ADM-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — ADM-15 (7 Ekim 2026)

Diyalog debug paneli: CHR gerçek düğmelerini ve eski soru API akışını 500 ms arayla yürütür; denenmemiş ilk açık geçiş, döngü/kapalı clue/karar ekranı duruşu, 64 adım sınırı. Karar, gün ve kasa uygulanmaz; ziyaret/modal/stale callback korunur. Ziyaret tansiyonu doğal/2/5/9: ince setter adaptörü ile seçim deltasından önce kilit, 9 mevcut kalıcı panik; kapatma/ayrılma debug kilidini çözer ama panik bayrağını geri almaz. Kaynak JSON, KAP-01 ve CSV değişmedi. Birim, gerçek otomatik UI/düğme/döngü/eski akış, native görüntü, mirror import/UI ve kapsamlı sanity (20 gece dahil) 0 başarısız. SYS-09 bekleyen CSV maddeleri ve diğer ajan heybe işi atlanarak UZM-01 sırada.

Sıradaki: UZM-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-01 (7 Ekim 2026)

ZanaatTuru.Tur: 22 sabit kimlikli meslek (Çiftçi/Bostancı/Çoban/Değirmenci/Kalaycı/Cerrah/Demirci/Asker/Tellal/Kâtip ve kaynak rolleri). 30 CHR birincil gerçek uzmanlığı Bölüm 1 Gerçek_Kimlik üzerinden açık eşleme; maske/suç eğilimi meslek sayılmaz, tanımsız roller Belirsiz. Eski sinif ve zanaat/stat 1–10 ayrı korunur; KarakterVerisi getter, Koylu zanaat_turu ve ince kabul adaptörü, JSON kayıtlarında kararlı enum anahtarı; eski/hatalı kayıtta kimlik/sınıf fallback. Gerçek kapı kabulü cerrah rolünü taşır; köylü denetçisi meslek ve beceriyi birlikte gösterir. Üretim dengesi bu pakette değişmedi (UZM-03). 30 profil, gerçek karar, enum/JSON/eski kayıt, native görüntü, mirror import/unit/UI ve tüm sanity/20 gece 0 başarısız; CSV değişmedi, commit yok.

Sıradaki: UZM-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-02 (7 Ekim 2026)

PasifOzellikler: 30 CHR için Gerçek_Kimlik/geçmiş/postür/davranışa dayalı açık güçlü-zayıf çift matrisi; Gece nöbetçisi/Ağır yük ustası/Hırsızlığa meyilli/Korkak dahil ayrık kataloglar. KarakterVerisi getter ve gerçek köylü kabulünde bağımsız kopya, üretilen köylüde deterministik kişisel çift (RNG tüketmez). Kalıcı JSON/oturum kaydı, eski kayıt fallback ve bozuk matris reddi; kaynak Flag/Clue/JSON/CSV değiştirilmez. Debug köylü tablosunda ayrı güçlü/zayıf sütunlar, yatay taşma düzeltilip native görüntü doğrulandı. Trait verisi bu pakette; meslek çarpanları UZM-03 ve kaza/tutum tüketicileri ilgili paketlerde. 30 profil/kopya ayrımı/gerçek karar/deterministik çeşitlilik/eski-yeni kayıt, native ve mirror import/unit/UI, tüm sanity ve 20 gece 0 başarısız.

Sıradaki: UZM-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-03 (7 Ekim 2026)

MeslekUyumu: uygun meslek/bina ×1.6, uyumsuz ×0.5; belirsiz/genel esnaf nötr, Haydarın kaynak döküm uzmanlığı ayrı korunur. Çarpan gerçek üretim + seviye/flag/açlık formülüne ve salt okunur denetçi önizlemesine ortak bağlandı. Uyumsuz üretimde kişi/gece %10 (denge varsayımı) en çok 1 alet kırılması gerçek model RNGsi ve gece raporunda; alet/girdi yok veya ambar doluysa risk zarı atılmaz. Bostan ve Demirhane artık ayrı kurulabilir üretim türü; Tarla/Atölye bedel-reçete tabanını yeni katalog adaptörüyle kullanır, eski türler ezilmez. Eski tarla/atölye görselleri ince alias, bina adı/açıklaması CSVye dokunmadan okunur. Güncellenen üretim beklentileri ve gerçek stok/kesir/input/alet-RNG/restore/ikinci uzmanlık unit testi, yeni iki bina ve risk tooltip UI, native görüntü, mirror import/unit/UI geçti. Kapsamlı sanity (20 gece dahil) 0 başarısız + ek yeni UI/son risk sınır testi geçti; CSV değişmedi, commit yok.

Sıradaki: UZM-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-04 (7 Ekim 2026)

Usta–çırak eğitimi gerçek ortak üretimden gece başına bir kez ilerler; beş gecede beceri en az 6 ve öğrenilen meslek uygulanır, tam ustalık verilmez. Osman Dayı kaynak ustalığı tanınır; hastalık/girdisizlik/isyan/çalışmama ilerletmez, usta veya bina değişimi yarım sayacı sıfırlar. Sayaç güvenli JSON yüklemeyle korunur ve canlı denetçi ipucunda görünür. Tam sanity 0 hata, beş gerçek gece/kayıt/tek terfi birim testi, native Tree ve ayna import/birim/UI kontrolleri geçti.

Sıradaki: UZM-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-05 (7 Ekim 2026)

IsKazalari yeni dosyası gerçek gece üretimi ve nöbetten uyumsuzluk kazası üretir. Denge varsayımı: fiili uyumsuz üretimde %8, −20 sağlık ve sonraki üç gece mevcut agir_yarali verimi; uyumsuz nöbette %10, −3 moral/+5 asayiş ve o gece etkin muhafız gücü kaybı. Görev yuvası/sayısı/maaş korunur; savunma, husumet ve asayiş yalnız etkin muhafız sayısını kullanır. Geçici kaza güvenli JSON/RNG ile korunur; eski kayıt boş, bozuk süre reddedilir, kaynak yaralı bayrakları silinmez. Çalışmama/isyan/uyumlu işte kaza zarı yok. Gerçek sakatlanma, üç gece, nöbet, maaş, savunma, JSON/RNG ve native canlı tablo testleri; ayna import/birim/UI ve tam sanity (20 gece dahil) geçti: 0 hata. UZM-12 iş duruşu/Şifahane ve UZM-14 yorgunluk ayrı bekleyen paketlerdir; CSV değişmedi.

Sıradaki: UZM-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-06 (7 Ekim 2026)

IsMemnuniyeti yeni dosyası mevcut meslek/atama/moral/pasif veriden kişisel memnuniyet ve isyan eşiği türetir; yeni zorunlu kayıt alanı yok. Denge: fiili uyumlu iş/nöbet +2 moral, uyumsuz −2; nötr/bosta işte bonus yok. Eşik 20, öfkeli/inatçı/kibirli 30, aksi halde dayanıklı 10. Eşik altındaki uyumsuz çalışan kendi üretimini ve etkin nöbetini reddeder; yuva/maaş korunur. Sağlıklı aktif uyumsuz işte sabotaj %2, eşik altında %12, zorla nöbette iki kat; olay en çok 1 alet veya 3 gıda, +3 asayiş/−2 sadakat. Türev UI bilgisi salt okunur; ana köy isyan akışı korunur. Gerçek gece üretim/iş reddi/ambar/moral/eşik/sabotaj, JSON-RNG replay, native canlı Tree ve ayna import/birim/UI testleri; tam sanity (20 gece dahil) 0 hata. CSV değişmedi. Kullanıcı yeni limit devir/geri alma talimatı AGENTS.md ve docs/DEVIR.md olarak iki kopyaya yazıldı.

Sıradaki: UZM-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-07 (7 Ekim 2026)

KanDavasi yeni dosyası açık grup/düşman grup ilişkilerini simetrik değerlendirir; farklı fraksiyon tek başına düşman değildir. Kaynak CHR001/004 aile intikamı ve CHR005 kan davası, CHR007 sancak divanına köy adaptörüyle bağlandı; CHR sözleşmesi değişmedi. Aynı hazır binadaki düşmanlar tüm üretimi durdurur; girdi/alet tüketimi ve üretim risk zarları çalışmaz. Denge: bina/gece tek %20 kavga zarı; her ilgili kişi en çok bir kez −5 sağlık/−4 moral, köy +5 asayiş; gerçek gece raporu. Kişileri ayırınca üretim döner; normal bina bilgi paneli çözümü açıklar ve eski bekliyor alanını doğru filtreler. İlişki optional JSON/old-save fallback; RNG ve sonraki gece replay korunur. Gerçek kapı kabulleri, 3 çalışan/2 çift/tek hasar, genel köy ilişkisi, bozuk kayıt, ayırma, atölyede gerçek girdilerin korunması; native bina paneli/Tree ve ayna import/unit/UI geçti. Tam sanity (20 gece dahil) 0 hata + son girdili atölye ek testi iki kopyada geçti. CSV ve indeksler korunuyor.

Sıradaki: UZM-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-08 (7 Ekim 2026)

YasRolleri kaynakta yaşlı CHR003/008/013 ve şecerede çocuk CHR006 ayrımını taşır; Genç etiketi çocuk yapılmaz. Optional yaş grubu JSON ve eski/hatalı alan fallback; yeni zorunlu CHR alanı yok. Çocuk/yaşlı ağır fiziksel iş ve nöbet kısıtları gerçek atama, üretim, kış kaydırması/bahar dönüşü, inşaat yardımı ve etkin savunmada uygulanır. Nitelikli yaşlı (Osman tarla/Haydar döküm) ağır işi yapmadan usta danışman olur; kendi girdisi/çıktısı yok, yalnız yanındaki fiili üretim gecesi çırak eğitimine sayılır. Sağlıklı yaşlı değirmen danışmanı binaya bir kez %15 üretim bonusu verir; hasta/aç danışman veya ikinci danışman ek bonus sağlamaz. Değirmen yeni ince katalog adaptörüyle kurulabilir; toplu gıda modelinde geçici 2 ham erzak → 3 temel işlenmiş erzak reçetesi (ayrı buğday/un zinciri EKOya bırakıldı); mevcut katalog ezilmedi, özel değirmen görseli eklenmedi ve mevcut genel yapı görseli kullanılır. Salt okunur canlı rol/üretim önizlemesi; gerçek öğütme girdisi, 4.8→5.52 brüt/kesir, yaş blokları/JSON, danışman ile eski beş gece çırak eğitimi, headless/native yeni UI ve ayna import/unit/UI geçti. Tam sanity, yeni yaş UI ve 20 gece dahil 0 hata; CSV değişmedi.

Sıradaki: UZM-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-09 (7 Ekim 2026)

GizliEgilimler yeni dosyası kaynak CHR haydutlarını ve ihtiyaç koşullu fırsatçılığı mevcut gece döngüsüne ince adaptörle bağlar. Gündüz gerçek üretim sürer; gece %20 haydut/%35 aç veya düşük sadakatli fırsatçı girişimi, etkin nöbetçi yakalaması ve çalışanın örtüsü uygulanır. Kayıp kişi/gece en çok 3 mevcut erzak; yakalanmayan fail raporda anonim, yakalanan açık hirsiz kanıtı ve adlandırılmış rapor üretir. Özel sayaçlar JSON/RNG replay ile korunur, bozuk/eski kayıt kaynak varsayılanına döner; yeni CHR025/028/030 hikâyeleri eski hirsiz bayraklarıyla ezilmez. Gizli bilgi yalnız DEBUG denetçisinde; oyuncu bilgisi açık kanıtla sınırlı. Gerçek kapı kabulü/gece üretim-ambar-tüketim/yakalama, tek erzak ve hastalık sınırları, native canlı Tree, ayna import/birim/UI ve tüm sanity (20 gece dahil) 0 hata. CSV değişmedi; stage/commit/push yok.

Sıradaki: UZM-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-10 (7 Ekim 2026)

KoyluKartiVerisi/KoyluKarti ve KoyluSecimi yeni dosyaları, mevcut KoyEkrani üzerinde ince adaptörlerle figür tıklaması, nüfus listesi ve yapı çalışanlarından gerçek köylü kartı açar. Mevcut zanaat/beceri, moral/sağlık/sadakat, güçlü/zayıf yön, köye geliş günü ve eğitim geçmişi gösterilir; gizli bayrak/özel hırsızlık sayaçları oyuncuya sızmaz. Uzmanlığa uygun bina önerileri ve meslek uyumuna göre sıralı gerçek yapı seçenekleri, danışman rolü, inşaat/yaş/dolu yuva engelleri; gerçek ata/muhafiz_ata/bosalt API, tıklama anında yeniden doğrulama ve kayıt/yüklemede kalıcılık. Bina adı fallback mevcut CHR sözlüğünü kullanır, CSV değişmez. Yerleşim kipleri korunur; sahne dışında kalan köylülere nüfus listesinden erişilir. Birim/native figür girdi+düğme/UI ve ayna testleri geçti. Tam sanity tek ad eşleme tür hatası buldu; düzeltildi, son import/kart birim/UI yeniden kontrolü 0 hata, tam pakette diğer tüm kontroller ve 20 gece geçti. Her iki indeks boş; stage/commit/push yok.

Sıradaki: UZM-11. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-11 (7 Ekim 2026)

KoyluGelisimYoneticisi yeni dosyası gerçek gece üretim kayıtlarını kullanır; sağlıklı/fiili/fiziksel/mesleğe uygun çalışma her gece 1 XP, her 5 gece Kalfa ve ardından Usta kademesi kazandırır. Denge varsayımı: kazanılmış Kalfa +%10/Usta +%20 kişisel üretim çarpanı; kaynak beceri statı ezilmez, kaynak ustalar tanınır ve mevcut eski kayıt üretimi ilk gün değişmez. Kazanılmış ustalık usta-çırak öğretmen API sine bağlanır; UZM04 beş ortak gece eğitimi korunur. Deneyim meslek bazında optional JSON kayıt, doğrulanan tam sayılar ve aynı-gece koruması; uyumsuz/boşta/hasta/eksik girdi/dolu ambar deneyim kazandırmaz. Gerçek 10 gece terfi, kesir artığıyla gerçek 3.52 üretim, JSON/RNG replay, tam ambar ve demir girdi yokluğu, eski kayıt ve bozuk veri, native canlı kart ve ayna kontrolleri geçti. Tam sanity (yeni gelişim UI ve 20 gece dahil) 0 hata. Belgeler/iki kopya eşitlendi; CSV değişmedi, stage/commit/push yok.

Sıradaki: UZM-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-12 (7 Ekim 2026)

ZanaatKazalari ve Sifahane yeni dosyaları mevcut alet kırma (%10)/iş kazası (%8) zarlarına ince adaptörle bağlandı; ek veya çift kaza zarı yok. Uyumsuz aceminin kırık aleti ve ocak yanığı sonraki bir fiili üretim gecesini durdurur; duruşta reçete girdisi/üretim/XP yok. Ocak yanığı mevcut -20 sağlık/yaralı etkisini kullanır ve ayrı tedavi ihtiyacı taşır. Şifahane yeni kurulabilir hizmet türü: iki iş yuvası, cerrah/otacı başına gecede bir yanık tedavisi, hasta başına 2 erzak; hazır bina/sağlıklı uygun çalışan/çatışmasız/isyan dışı koşulları ve gerçek stok harcaması. Tedavi +20 sağlık ve yalnız bu kazaya ait yaralı bayrağını temizler; kaynak yaralı bayrakları korunur. Optional doğrulanmış JSON kaza kaydı, gece raporu, canlı köylü kartı ve debug duruş bilgisi. Gerçek ocak yanığı/sonraki üretim-girdi duruşu/alet kırma, yetersiz erzak ve isyan tedavi engeli, gerçek Şifahane iyileşmesi, JSON RNG replay, native kart ve ayna kontrolleri; tam sanity (yeni kaza UI/20 gece dahil) 0 hata. Şifahane özel sanat yerine mevcut genel bina görünümü kullanır. CSV değişmedi; stage/commit/push yok.

Sıradaki: UZM-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-13 (7 Ekim 2026)

MeslekGrevi yeni dosyası kaynak CHR007 Şemsettin/kâtip veya açık/gizli soylu-okumuş niteliğinin mesleğe uygun olmayan ağır fiziksel işte yüksek moralde dahi grevini gerçek gece döngüsüne bağlar. Uygun uzmanlık/yaşlı danışman, nöbet ve fiziksel olmayan işler hariç; uygun göreve aktarım veya boşaltma grevi bitirir. Grev üretim/reçete girdisi/XP yi durdurur; denge varsayımı gecede grevci -5 moral/-2 sadakat/+3 asayiş, aynı işyerindeki sağlıklı diğer köylüye -2 moral (çok grevcide bir kez). Mevcut kişisel iş reddi API genişletilir; grev ikinci sabotaj zarı veya çift moral cezası üretmez, genel isyan sırasında ikinci grev cezası yok. Optional doğrulanmış JSON gece geçmişi ve aynı gece koruması; kartta grev açıklaması/atama önuyarısı, debugda gerçek duruş. Gerçek kapı kabulü/gece üretim-girdi-XP duruşu, aynı işyerinde sınırlı/dedup kışkırtma, JSON RNG replay, salt okunur gözlem, uygun görevle çözüm, native Şemsettin kartı ve ayna testleri; tam sanity (grev UI ve 20 gece dahil) 0 hata. CSV değişmedi; stage/commit/push yok.

Sıradaki: UZM-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — UZM-14 (7 Ekim 2026)

NobetYorgunlugu yeni dosyası son gerçek uyanık nöbet gecesini optional JSON alanıyla kaydeder. Ertesi gün mevcut kaza/uyuklama olasılığı ×1.40: uyumsuz yaralanma %8→%11.2, nöbet uyuklaması %10→%14; sıfır riskli uyumlu iş/nöbet davranışı korunur. Nöbetsiz dinlenme gecesinden sonra etki takvimle sona erer; uyuyakalan veya önceki uyuklama süresi o gece devam eden kişi yeni uykusuz vardiya sayılmaz. Sağlık/yaş/iş reddi/duruş koşulları ve gerçek nöbet adayları mevcut API lerden; ek RNG veya kalıcı üretim cezası yok. Kart/debug yorgunluğu ve güncel riski gösterir. Gerçek nöbet ve artırılmış aralıktaki zarla uyuklama/etkin muhafız kaybı, nöbet sonrası yanlış işte gerçek yaralanma, JSON RNG replay, dinlenme/eski-bozuk kayıt ve salt okunur gözlem; native canlı yorgunluk/dinlenme kartı ve ayna testleri geçti. Tam sanity (yorgunluk UI ve 20 gece dahil) 0 hata. CSV değişmedi; stage/commit/push yok.

Sıradaki: UZM-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.

- 7 Ekim 2026: Kullanım %5 kalınca Claude’a devretme ve limit yenilendiğinde Codex’in görevi geri alma kuralı AGENTS.md içinde kalıcı olarak doğrulandı; canlı kalan oran %10/%86, devir henüz yapılmadı.


## Codex — UZM-15 (7 Ekim 2026)

Kart sürüklerken izole model kopyasında gerçek üretim formülüyle yeşil/kırmızı brüt bina verimi, uyum ve danışman sinerjisi önizlenir; canlı RNG/stok/atama değişmez. Bırakma gerçek ata API ile koşulları yeniden denetler; boş hedef ve sonradan kullanılamaz olan bina görevi değiştirmez, kart geri açılır. Birim, gerçek native GUI ve GitHub yerel kopyası kontrolleri geçti; tam sanity ve 20 gece: 0 başarısız. Brüt tahmin net stok/olay sonucu olarak sunulmaz.

Sıradaki: EKO-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.

## Codex — EKO-02 devam ediyor (7 Ekim 2026)

Limit yenilendi; Claude devri erişim nedeniyle gerçekleşmedi. Orman kampı 3 tomruk/kişi üretir; hızar 2 tomruğu 1 kalas (mevcut kereste alanı) veya 3 yakacak oduna işler. Eski tarif kimlikleri ve stoklar korunur; tomruksuz hızar durur. Gerçek gece üretim/girdi, JSON ve çocuk reddi testi geçti; native HUD/sürükleme regresyonu geçti. UI zincir kabulü ve tam sanity tamamlanmadan ROADMAP maddesi kapatılmaz. Stage/commit/push yok.


## Codex — EKO-02 (7 Ekim 2026)

Orman Kampı gerçek katalogdan kurulup çalışan başına 3 tomruk üretir; hızarın mevcut tarif kimlikleri 2 tomruğu 1 kalasa (kereste stok alanı) veya 3 yakacak oduna işler. Ham katalog verisi tarif erişim adaptörüyle korunur; tomruksuz üretim durur. Tomruk HUD/ikon, kamp inşaat kartı, ağır iş yaş/grev adaptörleri eklendi; CSV değişmedi. Gerçek gece, eksik girdi, çocuk reddi, eski/yeni JSON, native Vulkan UI/görsel ve ayna kontrolleri geçti; düzeltilmiş tam sanity/20 gece 0 başarısız. Miktarlar açık denge varsayımıdır; ağaç tükenmesi ve öküz lojistiği sonraki paketlerdir.

Sıradaki: EKO-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — EKO-03 (7 Ekim 2026)

Claude güncel brifingi alındı: açık kod işi yok. Yeni CekiLojistigi hayvan sahipliği, hazır ahır kapasitesi, kervan günü kamu kasasından alım ve tomruk sevkiyat kuyruğunu yönetir. Sefer yükü 3→9, süre 1→0.5 gece; üretim/inşaat çarpılmaz, yük ambar doluyken veya zaman yetmeyince korunur. Eski/yeni JSON, gerçek gece karşılaştırması, alım sınırları, native Vulkan pazar UI/görüntü ve ayna kontrolleri geçti; tam sanity/20 gece 0 hata. ANI-04 görsel rota ve TUC-02 özel celep ayrı paketlerdir; CSV değişmedi.

Sıradaki: EKO-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — EKO-04 (7 Ekim 2026)

TahilZinciri ve dış JSON denge verisiyle tarla/bostan buğday hasadı, değirmende un, Köy Fırınında un+odundan ekmek/erzak zinciri eklendi. Eski erzak/ogutme tarifleri ve gida stok kimliği korunur; unsuz fırın odun da tüketmez. Buğday/un ambar ve HUD ikonları, gerçek tarif seçim UI ve fırın girdi bilgisi eklendi. Gerçek gece, eksik girdi, eski/yeni JSON, native Vulkan UI/görüntü ve ayna kontrolleri geçti; tam sanity/20 gece 0 hata. Lojistik denge değerleri de JSON dosyasına taşındı, sayı türü düzeltildi; ilgili birim ve UI regresyonları tekrar geçti. CSV değiştirilmedi.

Sıradaki: EKO-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — EKO-05 (7 Ekim 2026)

HarcZinciri ve dış JSON denge verisiyle ham taş/yakacak→kireç→harç; harç gerektirmeyen Kireç Kuyusu ve harçlı altı yataklı Taş Ev eklendi. Mevcut ham taş, eski ahşap yapı maliyetleri ve kayıt kimlikleri korunur. Taş sur seviye 2/3 son taksiti gerçek taş/harç tüketir; eksik malzemede kasa, ödenmiş taksit ve seviye korunur. UI bütün taksitlerde bedeli açıklar, eksik son taksiti engeller; model tekrar denetler. Yeni stok/HUD/SVG, tarif seçimi, ağır iş/grev adaptörleri; özel sanat yerine mevcut genel yapı görünümü. Gerçek iki gece, girdisizlik, taş ev bedeli/yıkım iadesi, erken/son/azami taksit, eski-yeni JSON, native Vulkan gerçek UI/görsel ve ayna import/birim/UI geçti. Tam sanity work/sanity_eko05 ve 20 gece: 0 başarısız; ek üçüncü sur/iade birimi iki kopyada tekrar geçti. CSV değişmedi; stage/commit/push yok.

Sıradaki: EKO-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — EKO-06 (7 Ekim 2026)

DemirZinciri ve dış JSON denge verisiyle yeni Demir Madeni cevher çıkarır, Demir Ocağı cevher+yakacakla mevcut demir stoğuna işler; mevcut demirhane/atölye alet üretir. Alet gereken gerçek üretim stok sıfırken ×0.30; gerçek çalışan başına 0.1 kesirli aşınma birikir, tam olunca bir alet tüketir. Yeni üretilen alete geçmiş kullanım borcu yok; duruş/girdisizlik/dolu ambar/boşta iş aşındırmaz. Optional doğrulanmış JSON aşınma alanı, eski demir/alet kimlikleri korunur. Aynı verim formülü gerçek üretim, denetçi ve salt okunur atama önizlemesinde; yeni cevher/demir HUD ikonları, ocak girdi ve aletsiz uyarısı, ağır iş/grev adaptörleri. Gerçek gece zinciri, %70 düşüş/üretim kesri, aşınma/alet tükenmesi, eski-yeni-bozuk JSON ve gözlemde model/RNG korunumu; native Vulkan UI/görsel, ayna import/birim/UI geçti. İlk native koşuda eksik demir SVG bulundu, eklendi ve yeniden sıfır hatayla geçti. Tam sanity work/sanity_eko06 ve 20 gece 0 başarısız; genişletilmiş son birim iki kopyada tekrar geçti. Özel sanat yerine mevcut genel yapı görseli; EKO-13 ayrı paket. CSV değişmedi; stage/commit/push yok.

Sıradaki: EKO-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## Codex — EKO-07 (7 Ekim 2026)

MuhafizMaasi dış JSON verisiyle gerçek kurulabilir kışla; kışla çalışanları ve eski muhafız görevi aynı küresel yuva/maaş/savunma sözleşmesinde. Kişi başı mevcut 1 kamu akçesi ve eski maaş borcu birlikte ödenir. Ödenmezse mevcut moral kaybı, gerçek görev bırakma/etkin savunma kaybı ve +10 asayiş; %25 nöbet hattı usulsüz geçişi gizli 2 akçe ledgerı/+8 asayiş üretir, kamu veya oyuncu kişisel kasasına gelir yazmaz, rapor anonimdir. Borçlu yeniden atama savunmayı açmaz; kamu borcu+cari maaş ödenince toparlanır. Optional doğrulanmış JSON bordro, tekrar gece koruması; eski kayıtta borç uydurulmaz. Gerçek savunma kışla kartı/maaş açıklaması; atama önizlemesinde salt okunur etkin nöbet farkı/borç uyarısı. Gerçek gece/maaş, kişisel kasa ayrımı, rüşvet dalı, kayıt, çocuk/yuva sınırı, ödeme ile toparlanma; native Vulkan UI/görsel, ayna import/birim/UI geçti. Tam sanity work/sanity_eko07 ve 20 gece: 0 başarısız; son genişletilmiş bordro ve atama birimleri iki kopyada tekrar geçti. Kışla özel sanat yerine mevcut genel yapı görseli, rüşvet geçişi kapı kuyruğunu değiştirmez; gerçek etkisi asayiş/baskın hesabında. CSV değişmedi; stage/commit/push yok.

Sıradaki: EKO-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; commit talimatına kadar stage/commit/push yapılmaz.


## EKO-08 ilerleme — 7 Ekim 2026
Codex sorumlu. VergiPolitikasi ve dış JSON oranları, gerçek haftalık kamu tahsilatı, Moral etkisi, muafiyet ve aynı gece tekrar koruması; pazar düğmeleri ve optional kayıt uzantısı eklendi. Eski orta oran korunur. Birim eski/yeni/bozuk JSON, gelir/Moral ve salt okunur gözlem kontrolü source/aynada geçti. Native RTX3060 pazar düğmesi ve ekran görüntüsü work/eko08_vergi.png doğrulandı. 378 intended dosya iki kopyada eşitlendi. Tam sanity work/sanity_eko08 canlı süreçte; son gözlem diyalog_deneyi_test PASS, kapanış yok. Kullanıcının Refah eşlemesi sorusuna yanıt bekleniyor: önceki ADM-04 kamu akçesi kararına karşı ağır verginin Refahı azaltması çelişiyor. Bu sözleşme değiştirilmedi. ROADMAP EKO-08 [/] kalır. Son canlı kullanım kısa dönem %27, haftalık %28 kullanılmış; resetler 1791398546 / 1791948615, devir eşiğine ulaşılmadı. Stage/commit/push yok; CSV korunuyor. Festive fetch başarılı, ff-only pull dal ayrışması nedeniyle uygulanamadı.


## EKO-08 doğrulama kontrol noktası
Tam sanity work/sanity_eko08, bütün birimler/gerçek UI senaryoları ve 20 gece: 0 başarısız. Son genişletilmiş gerçek gece/vergi raporu birimi iki kopyada ayrıca geçti; düşük/orta/ağır gerçek pazar düğmelerinin kendi oranını seçmesi ve ayna UI tekrar geçti. Native ekran work/eko08_vergi.png incelendi. Canlı test süreci kalmadı. 379 intended dosya iki kopyada eşit. EKO-08 [/] ve Refah kararı beklemede: mevcut Refah=kamu akçesi sözleşmesi korunuyor, ağır verginin istenen Refah kaybı henüz uygulanmadı. Sıradaki EKO-09 henüz başlatılmadı. CSV ve indeksler korunuyor; stage/commit/push yok.


## EKO-09 ön inceleme — EKO-08 kapanmadan bağımsız kanıt
EKO-08 hâlâ [/] ve kullanıcı Refah kararı bekleniyor. EKO-09 henüz kapanmadı veya ürün kodu değişmedi. Mevcut KoyYonetimi._tuket kişi başı gida_kisi (varsayılan 1) ile Erzak tüketir; soğuk odunu _hane_sayisi × kis_odun_hane × IklimDeneyi.odun_carpani üzerinden hesaplar. Bu, EKO-09 kişi başı +1 Odun tarifinden farklıdır; MEV-11 ise mevcut hane tarifini kullanır. Eksik yakacak bütün köylülere soguk_saglik kaybı, açlık son gelenlere ac bayrağı ve aclik_saglik kaybı verir; _saglik_ve_moral sağlık sıfırında gerçek nüfustan çıkarıp rapora ölüm yazar. Yeni tests/unit/kvr/tuketim_olum_test.gd gerçek gece açlık/donma ölümü, üç kişi üç Erzak ve kayıt restore sonrası aynı ölüm/tüketim/RNG sonucunu doğrular. Source birim geçti. Gelecek EKO-09 uygulaması bu doğrulanan ölüm/kayıt davranışını korumalı; kişi/hane odun sözleşmesi açıklığa kavuşturulmadan madde tamamlanmış sayılmaz. CSV, ürün çekirdeği ve indeksler değiştirilmedi; commit/push yok.


## Kullanıcı yeni yetkisi — 7 Ekim 2026
Kullanıcı tüm projeyi Codex’in otonom geliştirmesini, rutin kararlar için duraksamamasını ve şu ana kadarki bütün Codex işini GitHub’a pushlamasını açıkça istedi. Önceki commit bekleme şartı bu yayın için kaldırıldı. 380 dosyalık değişiklik kümesi eşitleme manifestiyle birebir uyuşuyor, dışarıda bağımsız değişiklik yok; source/ayna HEAD 29a3a6a. Son tam sanity EKO-08 0 hata/20 gece, son tüketim ölüm birimi iki kopyada geçti. EKO-08 hâlâ aktif; yayın tamamlanmış özellikler ile bu açık geliştirme kontrol noktasını birlikte içerir, Refah bitmiş sayılmaz. Açık karar Codex tarafından köylü ekonomik Refahını kamu hazinesinden ayrı ele alarak çözülecek; mevcut kamu/kişisel kasalar korunacak. Commit/push bu kontrol noktası için şimdi uygulanır, teslim kanıtı yayın sonrası doğrulanır.


## Codex — EKO-08 (7 Ekim 2026)

VergiPolitikasi dış JSON düşük/orta/ağır oranlarını gerçek pazar ve haftalık kamu tahsilatına bağlar; eski orta taban, muafiyet ve aynı gece koruması korunur. Kullanıcının otonom tasarım yetkisiyle Refah kamu kasasından ayrı köylü ekonomik yaşam standardı (0–100, dış başlangıç 50) oldu; ağır vergi gelir getirirken Moral/Refah -5, düşük +2. Optional doğrulanmış kişi JSON, ADM-04 enjektör/pazar/köylü kartı gerçek puanı gösterir. Kamu/kişisel kasa ve CHR/CSV isimleri korunur. Source/ayna gerçek vergi/Refah/JSON birimleri ve UI geçti; native RTX3060 ekran incelendi. Tam sanity work/sanity_eko08_refah ve 20 gece: 0 başarısız. Önceki 380 dosyalık kontrol noktası GitHub 3973e30 olarak yayımlandı; yeni karar ADR ile kayıtlıdır.

Sıradaki: EKO-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Claude devri iptal — güncel kullanıcı talimatı
Kullanıcı “Claude’a iş aktarma, sen devam et” dedi. Codex tek sorumlu olarak otonom geliştirmeye devam eder. Eski %5 eşiğinde Claude’a mesaj/devir ve reset sonrası geri alma kuralları kaldırıldı; bu dosyanın önceki devir bölümleri tarihsel kayıttır, çalıştırılmayacak. gamedevoloper-limit-ve-claude-devri otomasyonu PAUSED yapıldı. EKO-09 tam sanity 0 başarısız ve 20 gece geçti; son aynı ev/boş köy birimi source/aynada tekrar geçti. Sıradaki kapanış ve GitHub yayınıdır.


## Codex — EKO-09 (7 Ekim 2026)

TuketimDengesi ve gerçek src/dunya/mevsim_tuketim_adaptoru.gd (MEV-11) ile her yaşayan köylü/yaş grubu kişi başı 1 Erzak, soğukta +1 Odun; kuraklık/fırtına çarpanları ortak hesapta. Önceki hane tarifi EKO-09 kişi sözleşmesine geçirildi, eski ayar alanı uyumluluk için kaldı. Gerçek gece tüketimi, gıda süresi ve HUD tooltip aynı formülü kullanır; açlık/soğuk sağlık ve gerçek ölüm/RNG döngüsü korunur. Üç kişinin aynı gerçek kulübede üç odun tüketmesi, boş nüfus, dört iklim, ölüm ve kayıt restore source/aynada geçti. Native HUD tooltip görüntüsü incelendi, ayna import/UI geçti. Tam sanity work/sanity_eko09 ve 20 gece: 0 başarısız. MEV-11 tamamlandı; MEV-02 özel 1–3 donma olayı ayrıca açık. Claude devir kuralı kullanıcının son talimatıyla iptal edildi; otomasyon PAUSED, Codex devam eder.

Sıradaki: EKO-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — EKO-10 (7 Ekim 2026)

Üç ardışık negatif kamu kapanışında tek tefeci baskını; kamu bina/stok el koyması, özel kese korunması, eski/yeni JSON ve gerçek gece/UI kontrolleri geçti. Tam sanity 0 başarısız, 20 gece dahil; iki kopya doğrulandı. Claude devri iptal, Codex sorumlu.

Sıradaki: EKO-11. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — EKO-11 (7 Ekim 2026)

Kişisel kese HUD eklendi; gerçek rüşvet sinyali, kamu/kişisel ayrımı, eşya adedi, JSON geri dönüşü ve salt okunur çizim UI testinde geçti. Native ekran büyük bakiyeyi okunur gösterdi; çift kasa ve HUD regresyonları geçti. İki eski SVG UTF-8 kodlaması düzeltildi.

Sıradaki: EKO-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — Ajan düzeni kalıcı kayıt (7 Ekim 2026)

Ahmet talimatları codex.md/SOUL.md ve AGENTS.md içine kaydedildi. Festive tek çalışma dalı; olgun paket commit/push, güncel ROADMAP/status ve Ahmet–Muharrir raporu. Yeni Ahmet Windows yolu bu makinede yok; full pull uygulandı denmedi. Claude görev devri iptal kararı korunur.


## Codex — Açılış bağımlılık / eksik commit denetimi (7 Ekim 2026)
Commitli festive arşivinden önbelleksiz import sonrası 20 bağımlılık, gerçek Ana._ready menü, Katalog HAZIR, Ses havuzu ve runtime input testi geçti. kapi_kuyrugu_test.gd.uid içindeki eski merge artığı uzlaştırıldı. Statik UTF-8/BOM/class/UID/sahne/CSV denetimi ve gerçek açılış sahnesi sanity'ye alındı. Ahmet'in `_iskelet`/`EL_KEMIGI` 338–349 hata metni güncel 330 satırlık karakter_model.gd ile uyuşmuyor; eski keen el kodu/buffer farkı incelenmeli, sahte tanım eklenmedi. CSV ve Quest PR #4 değiştirilmedi. Tam dosya/14 madde raporu docs/denetim/2026-10-07-acilis.md; tam regresyon work/sanity_acilis_denetimi 0 başarısız / 20 gece; kaynak/ayna açılış ve statik kontrolleri geçti.


## Codex — EKO-12 (7 Ekim 2026)

Ambar kapasite daralması/restore sınırı, gecelik %2 kalan gıda bozulması, kesir/gece/pending kayıp JSON, mevcut HUD ipucu ve ayrı ziyan raporu. 120 kontrol (düzeltilen dört test tekrar geçti), izole 20 gece, native UI ve ayna import geçti.

Sıradaki: EKO-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — EKO-13 (7 Ekim 2026)

EKO-06 aşınma adaptörü korundu; tarla/taş ocağı/demir madeninde son aletli tam üretim ve sonraki %30 verim doğrulandı. Mevcut alet HUD ipucu gerçek stok/kesir/ortak dengeyi salt okunur gösteriyor. Dört ilgili birim, headless/native UI, kaynak/ayna import ve API denetimi geçti.

Sıradaki: EKO-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Cursor — BUG-03 (7 Ekim 2026)

Rüşvet kabul ve ret kararında diyalog kutusu `anlati.sonuc.rusvet` / `anlati.sonuc.ret` satırını ve varsa çevrilmiş ziyaretçi yanıtını alır; konuşma mevcut `sfx_chr_sikke` veya `sfx_chr_deri` ile tetiklenir. `73f8172` UID denetimiydi, sessizlik ayrı kaldı. Yeni ses, görsel veya model üretilmedi. Ayrı seslendirme dosyası yok. CSV, KAP-02/03, EKO-14 ve SYS-09 validator değişmedi. Godot 4.7.2 headless import hatasız; `karar_replik_test.gd` 0 hata. Ahmet ve ds Windows kopyaları bu makinede yok.

## Cursor — BUG-15 (7 Ekim 2026)

Heybe paneli yeniden yazılmadı. `HeybePaneli` ve zemin `ColorRect` `mouse_filter = STOP`. Headless `heybe_tik_test`: panel açıkken dünya alanı ve 3B görüntü kapısı sol tık almaz, panel kapanınca aynı nokta ikisine de gider. KAP-02/03, EKO-14, BUG-03 ve CSV değişmedi. Windows aynaları bu ortamda yok.

## Codex — EKO-14 (8 Ekim 2026)

Mevcut iki kasa arasında atomik açık kurtarma ve günlük sınırlı, sosyal bedelli zimmet; dış JSON, optional kayıt ve aynı gün restore koruması, mevcut pazar/HUD adaptörü. 123 kontrol/20 gece, native UI ve ayna import geçti.

Sıradaki: EKO-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — EKO-15 (8 Ekim 2026)

gece_sonu dönüşüne salt okunur bilanco: kamu/kişisel açılış-kapanış, gerçek ödenen maaş/vergi, tüm stok hareketleri ve taşma mutabakatı. Önceki gündüz taşması tekrar gider sayılmaz; eski borç ödemesi, restore ve kopya güvenliği geçti. 124 kontrol ve 20 gece hatasız.

Sıradaki: ANI-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-01 (8 Ekim 2026)

Mevcut ElEsyasi soketinde kılıç/mızrak, gündüz kalkan ve gece meşale; dört gölgesiz ışık bütçesi. Gerçek el pozu/özgün CHR görünürlüğü, görev/faz/tekrar yenileme, kayıt-RNG değişmezliği doğrulandı; 126 sanity kontrolü ve izole 20 gece geçti.

Sıradaki: ANI-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-02 (8 Ekim 2026)

Mevcut halk A* kuyruğunda kapı/hazır kışla/işlevli sur kuleleri devriyesi; gece nöbeti, erişilemeyen durakları atlama ve görev bırakınca normal rutin. Dört ahşap platform dekoratörü; 14 ilgili kontrol, izole 20 gece, native RTX3060 ve ayna sahne geçti.

Sıradaki: ANI-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-03 (8 Ekim 2026)

Hazır tarla/bostan çalışanının mevcut A* kuyruğunda kuyu/kova/su arkı/dinlenme döngüsü; gerçek sağ el, dolu kova ve yalnız varışta akış, gece temizliği, JSON ayarları. 14 ilgili kontrol ve izole 20 gece, native RTX3060 görüntüsü ve ayna sahnesi geçti; ekonomi/RNG/kayıt korunur.

Sıradaki: ANI-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.

## Ahmet yerel full pull — 8 Ekim 2026 ~01:10 (Europe/Istanbul)

`git fetch --all --prune`; yalnız festive değişti (`ec23ee9` → `51313e0`, 5 Codex commiti, yazar berk103458). Diğer 9 uzak dal yeni commit almadı ve hepsi yerelde takipte. Yerel 7 commit (PR #7 envanter, PR #6 BUG-03, PR #8 BUG-15) korunarak `origin/festive` merge edildi → yerel `691a5de` (origin'e göre 8 ileri, 0 geri; **push yok**).

Gelenler:
- `7d57fb8` EKO-14 — iki kasa arası acil kurtarma + günlük sınırlı zimmet (`kasa_transferi.gd`, pazar paneline tek satır `KasaTransferPaneli`, Oturum'a optional kayıt alanı).
- `3522842` EKO-15 — gece sonu bilançosu (`gece_bilancosu.gd`, `gece_sonu()` dönüşüne `bilanco` alanı; eski alanlar korunur).
- `05fb593` ANI-01 — muhafızlara kılıç/mızrak/kalkan ve gece meşalesi (`muhafiz_donanimi.gd`, mevcut ElEsyasi soketi).
- `95edcf7` ANI-02 — kapı/kışla/sur kuleleri devriyesi (`muhafiz_devriyesi.gd`, sahneye tek kule dekoratörü çağrısı).
- `51313e0` ANI-03 — çiftçi kuyu → kova → su arkı rutini (`sulama_rutini.gd`, kuyu konumu ayardan).

ROADMAP: EKO-14, EKO-15, ANI-01, ANI-02, ANI-03 `[x] (Codex)`; ANI-04 `[/]` (Codex sıradaki). BUG-03/BUG-15 `[x] (Cursor)` yerelde korunur (origin'de henüz yok; PR #6/#8 açık).

Conflict yalnız doküman: `OYUN_RAPORU.md`, `docs/MUHARRIR_RAPORU.md` (iki taraf alt alta birleştirildi), `codex.md/Codex.md` (Cursor bölümleri korundu, Codex'in tek kontrol noktası EKO-13 → ANI-03 güncel hâliyle alındı). Kod conflict'i yok; BUG-03/BUG-15 dosyalarına Codex dokunmadı.

Doğrulama (yerel Godot 4.7.2 headless): import hatasız; `kasa_transferi`, `gece_bilancosu`, `muhafiz_donanimi`, `muhafiz_devriyesi`, `sulama_rutini`, `karar_replik`, `heybe_tik` testleri GEÇTİ. Conflict marker yok; `koy_sahnesi` / `KoyYerlesimi` / `KoyluAI` geri gelmedi.

## Codex — ANI-04 (8 Ekim 2026)

Mevcut A* kuyruğunda orman kenarı/balta/hızar/kamp döngüsü; gerçek öküz/ahır bütçesi, elle taşıma fallback, varışta balta, gece temizliği. 15 ilgili kontrol ve izole 20 gece, native RTX3060 ve ayna import/sahne geçti; EKO-02/03 kayıt/stoğu/RNG korunur.

Sıradaki: ANI-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-05 (8 Ekim 2026)

CHR ağıl gerçek katalog/üretim adaptörü; dört koyunluk başlangıç sürüsü, aynı A* grafiğinde sabah çayır/akşam kapı dönüşü. Kapı tüm sürü dönünce kapanır; çobansız sürü, yıkım ve kopuk rota güvenli. 134 sanity kontrolü/20 gece, native ve son ayna sahnesi geçti.

Sıradaki: ANI-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-06 (8 Ekim 2026)

Gerçek çalışan/girdi/depo koşullarıyla dönen ahşap çark, el kemiğine bağlı çuval ve erişilebilir ön sundurma durağı; mevcut ekonomi ve kayıt değişmez. 15 ilgili kontrol ve 20 gece, son durak düzeltmesi sonrası headless/native/ayna sahne kontrolü geçti.

Sıradaki: ANI-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-07 (8 Ekim 2026)

Boşta köylüler akşam/gece mevcut ateşte ayrı ve güvenli A* duraklarında ısınır; gerçek iskelette iki el önde, gündüz duruş kapanır. Atanmış çalışan/guard rutinleri korunur. 15 ilgili kontrol/20 gece, native görüntü ve ayna import/sahne geçti.

Sıradaki: ANI-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-08 (8 Ekim 2026)

Gerçek fiziksel çalışan/reçete/girdi/ambar koşullarıyla örs çekiç ve fırın küreği döngüleri; mevcut modifier/el soketi, tek noktada düz kutu yer tutucular. 17 ilgili kontrol ve 20 gece; son alet açı düzeltmesi native/ayna sahnesinde geçti. Envanter G güncel, asset üretilmedi/indirilmedi.

Sıradaki: ANI-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-09 (8 Ekim 2026)

Mevcut iklim sözleşmesine yağmur; aynı A* ile erişilebilir düz kutu saçağa sığınma, muhafız görevini koruma, kar fırtınasında görsel hız ×0.72 ve mevcut modifierde hafif büzülme. Ekonomi/RNG değişmez. Tam 144 kontrol ve izole 20 gece sıfır başarısız; native ve ayna geçti. Envanter G/VFX-YAGMUR güncel; asset üretilmedi/indirilmedi.

Sıradaki: ANI-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.

## Ahmet yerel full pull — 8 Ekim 2026 ~02:05 (Europe/Istanbul)

`git fetch --all --prune`; yalnız festive değişti (`af876a7` → `3fb1810`, 5 Codex commiti, yazar berk103458). Diğer 9 uzak dal yeni commit almadı ve yerel takip dalları uzakla eşit. Yerelde ileri commit yoktu; merge fast-forward oldu, conflict yok.

Gelenler:
- `7a416e7` ANI-07 — akşam/gece boşta kalan köylüler meydan ateşi çevresinde ayrı A* duraklarında ısınır (`src/koy/gorsel/ates_basi_rutini.gd`; meydan ocağı konumu sahnede tek çağrıyla).
- `afe0907` merge — Cursor BUG-03/BUG-15 düzeltmeleri ve 8 Ekim asset kuralı korunarak birleştirildi.
- `8825b61` ANI-08 — örs/çekiç ve fırın küreği döngüleri, düz kutu yer tutucularla (`src/koy/gorsel/zanaat_tezgahi.gd`, `data/zanaat_tezgahi.json`).
- `c7572f8` ANI-09 — yağmurda saçak altına sığınma, kar fırtınasında yavaş ve büzülmüş yürüyüş (`src/koy/gorsel/karakter_hava_tepkisi.gd`; `durus_duzeltici.gd` içinde `hava_egimi`; iklim denetçisine "Yağmur").
- `3fb1810` ANI-09 commitli temiz açılış denetimi notu; asset gerekmedi.

ROADMAP: ANI-07/08/09 `[x] (Codex)`; ANI-10 `[/] (Codex)`. KAP-02/03 `[/]` → `[ ]` (sahipsiz). Yeni png/glb/ogg/wav dosyası yok; envanter G tablosuna ANI07-ISINMA, ANI08-TEZGAH, ANI08-HAREKET, ANI09-SACAK, ANI09-BUZULME eklendi.

Doğrulama (yerel Godot headless): import hatasız; `ates_basi_rutini_test`, `zanaat_tezgahi_test`, `karakter_hava_test`, `karar_replik_test` ile `ates_basi_rutini_kontrol`, `zanaat_tezgahi_kontrol`, `karakter_hava_kontrol`, `acilis_bagimlilik_kontrol` sahneleri GEÇTİ. Conflict marker yok; `koy_sahnesi` / `KoyYerlesimi` / `KoyluAI` geri gelmedi.

## Codex — ANI-10 (8 Ekim 2026)

Mevcut gizli eğilim/sabotaj riskine bağlı gece kuytu ve nöbetçiden kaçış; tek satırlık plan/kare/hız adaptörleri, kayıt/RNG korunur. Tam sanity ve 20 gece sıfır hata, native/ayna geçti. Asset üretimi yok, ANI10-SINSI envanter G kaydı tamam.

Sıradaki: BEKLEME — 05:10 limit yenilenmesi. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.

## Cursor — BUG-07 / SYS-09 / SYS-11 / SYS-12 / KVR-11 (8 Ekim 2026)

Kritik BUG-07 kapandı. Önceden `metinler.csv`'de tek bir anahtar eksik ya da boş olunca Katalog doğrulaması HATALI dönüyor ve oyun "Oyun içeriği yüklenemedi" ekranında kalıyordu; bozuk tırnak bir satırdan sonraki tüm metinleri yutabiliyordu. Artık eksik anahtar uyarı olur, oyun açılır; eksik metin yerine `[KEY_NOT_FOUND] anahtar` görünür ve günlüğe bir kez uyarı düşer. İçe aktarılmış tablo bozuk/eksikse geliştirme kopyasında ham CSV hoşgörülü okunur (kapanmamış tırnak bir sonraki anahtar satırında kesilir, bozuk satır atlanır).

Dosyalar: `src/sistemler/guvenli_metin.gd` (yeni), `Ana._ready` 1 satır, `Katalog._anahtar_dogrula` 4 satır; `tools/metin_dogrula.py` (PR #2 tabanı + KVR-11 biçimi + kod/katalog anahtarı ve yer tutucu sayısı denetimi); `tools/sanity_check.py` içinde `metin-csv` adımı; `docs/METIN_ANAHTAR_STANDARDI.md`; testler `tests/unit/metin/guvenli_metin_test.gd`, `tests/tools/test_metin_dogrula.py`.

Doğrulama: Godot 4.7.2 headless import hatasız; tam `sanity_check` (ANI-10 dahil, 20 gece duman testi dahil) 0 başarısız; ana sahne açılışı hatasız. Asset gerekmedi. `koy_sahnesi`/`KoyYerlesimi`/`KoyluAI` yok.


## Codex — ANI-11 (8 Ekim 2026)

Mevcut zanaat aletleri tek gerçek BoneAttachment3D soketinde; mola/gecede aynı nesne görsel stokta, geri dönüşte yeniden kullanılır. 26 kontrol/20 gece ve native/ayna geçti; G tablosu ANI11-ALET mevcut ihtiyacı referanslıyor, asset üretimi yok. Halk hareketine yeni mantık eklenmedi.

Sıradaki: ANI-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-12 (8 Ekim 2026)

0.1–1.5 saniye kararlı idle ofseti ve mevcut modifierde üç profil; gerçek son kemik pozu farkı doğrulandı. 27 kontrol/20 gece, native/ayna geçti. Yeni klip üretilmedi; G tablosu ANI12-IDLE.

Sıradaki: ANI-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-13 (8 Ekim 2026)

Mevcut patika A* sırası bina/arazi dışı NavigationRegion3D koridorlarına bağlandı; async hazırlık ve güncel güvenli rota yedeği, gerçek kapı/engel sorgusu ve kayıt/RNG korunumu doğrulandı. Asset gerekmedi.

Sıradaki: ANI-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-14 (8 Ekim 2026)

Mevcut köylü kartı seçimine aynı strateji kamerasıyla takip ve tek Label3D ad/zanaat/eylem etiketi bağlandı; WASD/sağ tık/yapı kipi iptali, zoom, figür kaybı, gizli bilgi ve kayıt/RNG korunumu doğrulandı. Asset gerekmedi.

Sıradaki: ANI-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ANI-15 (8 Ekim 2026)

Duman/kıvılcım/su CPUParticles3D mekanikleri hazır bina/gerçek çalışma varışına bağlandı; uzaklık LOD, düşük grafik katmanı, reçete girdisi/gece kapanışı ve kova akışı kaynağı doğrulandı. Yeni asset yok; düz BoxMesh yer tutucuları ve eksik efektler envanter G ANI15-DUMAN/KIVILCIM/SU.

Sıradaki: TUC-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-01 (8 Ekim 2026)

Mevcut kervan 4 gun varis/2 gun konaklama; dort uzman, tek pazar satiri ve kayit gununden saf takvim. 15 kontrol, native ve ayna UI gecti; asset gerekmedi.

Sıradaki: TUC-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-02 (8 Ekim 2026)

Celep konaklamasinda okuz/inek/beygir ahira, koc agila; mevcut lojistik kaydi ve tek pazar korunur. Kapasite/kasa/uzman/kayit ve dort gercek UI islemi gecti. Eksik modeller envanter G TUC02 satirlarinda.

Sıradaki: TUC-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-03 (8 Ekim 2026)

Nalbur ziyaretlik demir/civi/tirpan/balta stogu; tek kasa/ambar ve mevcut HUD. Kalan stok optional kayitta korunur; eski demir API ayni siniri kullanir. 163 kontrol son log denetiminde sifir hata (ilk turda yakalanan dort test duzeltme sonrasi tekrar gecti), native ve ayna UI gecti. Ikonlar envanter G TUC03 satirlarinda.

Sıradaki: TUC-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-04 (8 Ekim 2026)

Kumasci/Aktar mevcut ziyaret stogunda afyon/sargi/kece/kumas satar; tek ambar/HUD. Sifahane basarili tedavisine cift malzeme +5 saglik; oyuncu kontrollu luks dagitimi dusuk Refah once. 27 ilgili kontrol, native ve ayna UI gecti; UTF-8 isim kontrolu eklendi. Ikonlar envanter G TUC04 satirlarinda.

Sıradaki: TUC-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-05 (8 Ekim 2026)

Mevcut ziyaretlerden deterministik siparis teklifi, yedi gun vade ve kalici tek sozlesme defteri. Gercek UI kabul, tekrar/uc acik siniri ve stok/kasa/RNG korunumu; 20 ilgili kontrol, native uzun pazar/defter ve ayna UI gecti. asset gerekmedi.

Sıradaki: TUC-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-06 (8 Ekim 2026)

Tam siparis teslimi tek kamu odulu ve tuccara ozgu itibar verir; cift odul engeli, vade ve sonraki sadakat stogu korundu. Mevcut pazar/defter icerigi sinirli kaydirma, sabit kapanis ve kisa icerikte dogal boy kullanir. 23 kontrol, native ve ayna UI gecti; asset gerekmedi.

Sıradaki: TUC-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-07 (8 Ekim 2026)

Siparis ihlali, tek Refah kaybi, kalici tuccar borcu, faiz ve mevcut defterden kisim/tam kamu odemesi; 23 kontrol native ve ayna UI gecti, asset gerekmedi.

Sıradaki: TUC-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-08 (8 Ekim 2026)

Silah tuccari zirh/yay/kalkan ve tek ziyaretlik kac ak tutsak teklifi; mevcut ambar, kamu kasasi, kabul/barinma yolu. 26 kontrol, native ve ayna UI gecti; G TUC08 ikon ihtiyaclari kayitli.

Sıradaki: TUC-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-09 (8 Ekim 2026)

Ortak mevsim fiyati: odun/erzak kis x3 yaz x0.75; UI ve kamu tahsilati ayni, Tekfur alet farki korunur. 27 kontrol native yaz/kis ve ayna UI gecti; asset gerekmedi.

Sıradaki: TUC-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-10 (8 Ekim 2026)

Tek pazarda kamu/kisisel satis hedefi; mevcut zimmet limit ve sosyal bedeli. 31 kontrol, native ve ayna UI gecti; asset gerekmedi.

Sıradaki: TUC-11. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-11 (8 Ekim 2026)

Kisisel karaborsa ve ayni muhafiz oda envanteri; kamu/ambar ayrimi, ziyaret makbuzu, 33 kontrol native ve ayna UI gecti. G TUC11 ikonlari kayitli.

Sıradaki: TUC-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.

TUC-11 kapanışında 33 kontrol, native/ayna UI geçti; G TUC11 ihtiyaçları kaydedildi. TUC-12 henüz alınmadı. Canlı kullanım %95 kontrol noktası; Claude devri yok. Yalnız commitli temiz açılış denetimi ve ilk materializasyon sınırlaması docs/denetim/2026-10-08-ticaret-acilis.md içindedir.


## Codex — TUC-12 (8 Ekim 2026)

Tek ziyaretlik tuccar kapi makbuzu; resmi bac kamuya, hizli giris rusveti kisisel keseye. Ret/bekleme ticareti kapatir; nufus ve CHR korunur. Tam sanity, final unit, native ve ayna UI gecti; asset gerekmedi.

Sıradaki: TUC-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-13 (8 Ekim 2026)

Mevcut sozlesme tesliminde yuzde 10/20 kisisel komisyon; ayni zimmet siniri ve sosyal bedel, tek stok/odul/itibar. 44 kontrol, native ve ayna UI gecti; asset gerekmedi.

Sıradaki: TUC-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-14 (8 Ekim 2026)

Canli hayvan kamu geri satisi; mevcut kayit/barinak/ceki, tek uretim carpani ve satin alinan koc ayni coban surusunde. 54 kontrol final unit native ve ayna UI gecti. G TUC02-OKUZ/INEK/KOC TUC14 icin guncel; asset uretilmedi.

Sıradaki: TUC-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — TUC-15 (8 Ekim 2026)

Mevcut kislada sureli kervan korumasi: tek kamu pesinati, ayni kisi/atama/bordro, yerel etkin nobet ve gecici Guvenlik azalmasi. 68 kontrol final unit native ve ayna UI gecti; asset gerekmedi.

Sıradaki: MEV-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-01 (8 Ekim 2026)

Dort mevsim/yedi gun ve 28 gunluk yil tek MevsimYoneticisi hesabi; eski Takvim API ince adaptor, gercek gun ve Admin iklimi ayri. 38 kontrol native iklim ve ayna unit gecti; asset gerekmedi.

Sıradaki: MEV-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-02 (8 Ekim 2026)

Single winter fuel accounting, capped cold threshold, existing resource tooltip; 42 checks passed, asset gerekmedi.

Sıradaki: MEV-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-03 (8 Ekim 2026)

Existing field and garden winter production verified, spring assignment return and save parity; 13 checks passed, asset gerekmedi.

Sıradaki: MEV-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-04 (8 Ekim 2026)

Natural winter snow ramp, shared ground/roof shader cover, single box precipitation; 11 regressions plus new UI passed; G inventory recorded.

Sıradaki: MEV-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-05 (8 Ekim 2026)

Heavy snow roof load and idle adult clearing, existing removal and equipment APIs; 52 regressions plus final UI/equipment passed, G inventory recorded.

Sıradaki: MEV-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-06 (8 Ekim 2026)

Spring melt breaks the existing water barrier; shared stone/lime repair and deferred event; 56 checks passed, asset gerekmedi.

Sıradaki: MEV-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-07 (8 Ekim 2026)

Shared well flow and reserve accounting, summer water x2, bounded spark/fire loss; 58 checks plus final overflow/rain/Admin resource passed; G inventory recorded.

Sıradaki: MEV-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-08 (8 Ekim 2026)

Full autumn granary with actual food triggers one annual harvest feast after daily morale costs; existing night report and moral HUD reach 100. Save, repeat, starvation rejection and real UI verified; 62 checks passed, mirror/native passed; asset gerekmedi.

Sıradaki: MEV-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-09 (8 Ekim 2026)

Storm/fog blur only existing CHR visual clue portrait; buttons and text stay readable, evidence unlock unchanged. 69 regression checks: two compatibility failures corrected and final CHR/weather reruns passed; native and mirror UI passed; asset gerekmedi.

Sıradaki: MEV-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-10 (8 Ekim 2026)

Winter wolf raids use existing granary and effective guards; three BoxMesh wolves follow same A* and retreat from torch patrols. 79 regression checks, final gate-test audio cleanup corrected and rerun passed; native/mirror wolf UI passed. G MEV10-KURT recorded; clean committed 343a79d opening passed after known first resource import.

Sıradaki: MEV-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-12 (8 Ekim 2026)

Existing HUD season label now shows year/day and short weather; no second panel or clock. Actual HUD boundaries, five weather presets, forced calendar distinction, restore and no side effects; 21 checks passed, native and mirror UI passed; asset gerekmedi.

Sıradaki: MEV-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-13 (8 Ekim 2026)

Severe winter adds one bounded cold patient using existing negative production flag and health. Burns/cold share persisted daily Sifahane staff slots; own flag cleanup and no double treatment. 91 checks passed, final native readable patient card and mirror import/unit/UI passed; asset gerekmedi.

Sıradaki: MEV-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-14 (8 Ekim 2026)

Shared hay stock from wheat harvest and existing market; once per cold night actual base/owned animal death, production/haul/resale and same herd arrays reflect loss. 98 regression checks plus final unit/native UI and mirror checks passed; G MEV14-SAMAN placeholder registered.

Sıradaki: MEV-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — MEV-15 (8 Ekim 2026)

Storm narrows existing visible gate queue to 1 or 0; all visitors retained in order, waiting NPC stress uses CHR tension/panic. 33 regression checks plus final native and mirror import/unit/UI passed. No assets needed; G checked. MEV-14 clean committed opening cb22bf4 recorded.

Sıradaki: CAS-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-01 (8 Ekim 2026)

Persist bounded hidden night target/actual-action ledger; existing theft and work-sabotage hooks add no extra RNG/damage. Intent is not evidence, only observed real acts exposed. 41 regression checks, final actual-sabotage unit and mirror import/unit passed; asset gerekmedi, G checked.

Sıradaki: CAS-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-02 (8 Ekim 2026)

Existing paid healthy night guard observes actual CAS ledger acts; one persistent report uses the same event card, intent excluded, no repeated loss, JSON and double-click safe; 43 checks, native and mirror passed; asset gerekmedi.

Sıradaki: CAS-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-03 (8 Ekim 2026)

CHR002/009 source tur/decision/stat poisoning uses actual fresh well water and existing health/food/morale once; admission secret snapshot prevents it, public symptoms hide culprit, CAS patrol observes real act; 50 checks plus native/mirror passed; asset gerekmedi.

Sıradaki: CAS-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-04 (8 Ekim 2026)

CHR001/006 source arson targets/timing use one shared existing fire outcome; same reserve water prevents loss, otherwise no-refund real building cleanup and source stock/stats; 52 checks, native and mirror passed, clean eb7e127 opening verified; asset gerekmedi.

Sıradaki: CAS-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-05 (8 Ekim 2026)

Existing square court scene reads only observed CAS acts, one modal and one existing selected figure with temporary box table/benches; pause/camera/pose restore, source evidence not duplicated; 54 checks plus final native/headless/mirror stage test passed, G CAS05-DIVAN.

Sıradaki: CAS-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-06 (8 Ekim 2026)

Actual discovered source Clue IDs continue once in villager save; same court presents only found own clues, two independent pieces incl cargo plus observed act permit one confession; no source/CSV/RNG/cash mutation; 56 checks, final native/mirror passed; asset gerekmedi.

Sıradaki: CAS-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-07 (8 Ekim 2026)

65 checks; one court verdict, jail capacity and consumption, exile/execution actual population, JSON/UI/native/mirror passed; G CAS07-ZINDAN registered.

Sıradaki: CAS-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-08 (8 Ekim 2026)

31 checks; actual third-night single shared raid, JSON and duplicate protection, native/mirror passed; asset gerekmedi.

Sıradaki: CAS-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-09 (8 Ekim 2026)

33 checks plus final actual-night unit; anonymous allegation is not guilt, immutable secrets/RNG/resources, one pending card, JSON/UI/native/mirror passed; asset gerekmedi.

Sıradaki: CAS-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-10 (8 Ekim 2026)

35 checks plus final native/pose/clue regressions; unjust rumor jail, documented sibling departure, public compensation and JSON release passed; asset gerekmedi.

Sıradaki: CAS-11. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-11 (8 Ekim 2026)

36 checks plus final 30-CHR/repeat/foreign/native/mirror; canonical Clue continuation preserves court progress and source; asset gerekmedi.

Sıradaki: CAS-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-12 (8 Ekim 2026)

37 checks; exact poison Clue/4Flag contract, discovered-load-only hint, rawFlag/legacy/JSON and native/mirror passed; asset gerekmedi.

Sıradaki: CAS-13. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-13 (8 Ekim 2026)

38 checks plus final wrong-Clue guard; exact fire Clue/4Flag and shared water, same building card, JSON/native/mirror passed; asset gerekmedi.

Sıradaki: CAS-14. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.

## Muharrir — local full pull + PR #9 hazirlik (8 Ekim 2026, TR)

- Dal: `claude/festive-volta-li1sfm`
- Onceki HEAD (onceki ozet): `59cbcc5`; bu turda origin'den CAS-07..12 fast-forward ile alindi
- Festive (merge oncesi): `6da34ad`
- Alinan: `git fetch --all --prune` + `git merge --ff-only origin/claude/festive-volta-li1sfm` (CAS-07..CAS-12, conflict yok)
- Onceki pull ozeti (59cbcc5'e kadar ANI/TUC/MEV/CAS-01..06) korundu; WIP / `_tmp_*` / stash dokunulmadi; reset/force yok
- Siradaki is: PR #9 (`cursor/roadmap-gap-verify-0b16`) merge — sadece ROADMAP.md, codex.md/Cursor.md, docs/MUHARRIR_RAPORU.md; CAS koduna dokunulmaz

## Muharrir — PR #9 merge tamam (8 Ekim 2026, TR)

- Merge commit: festive uzerinde `merge(PR-9): ROADMAP gap verify KAP-02/03`
- Festive once: `6da34ad` (CAS-12); sonra muharrir pull ozeti + PR #9 merge; push oncesi CAS-13 (`1ae259d`) birlestirildi
- Degisen dosyalar (PR): ROADMAP.md, codex.md/Cursor.md, docs/MUHARRIR_RAPORU.md
- KAP-02 / KAP-03: ROADMAP `[x] (Cursor)`; CAS-13 `[x] (Codex)`; CAS-14 Codex'te
- `python -B tools/metin_dogrula.py --kaynak` PASS
- WIP / `_tmp_*` / stash (godot-import-noise) dokunulmadi; force yok


## Codex — CAS-14 (8 Ekim 2026)

Existing court list displays only discovered source Clue cards and uses the existing submit operation; 39 checks passed, native and mirror UI passed; asset gerekmedi.

Sıradaki: CAS-15. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — CAS-15 (8 Ekim 2026)

Documented existing KAP discovery to village proof continuation ownership; all 30 CHR, repeated/foreign admission, startup source and CSV checks passed; asset gerekmedi.

Sıradaki: ODA-01. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-01 (8 Ekim 2026)

Independent box-placeholder room opened from the existing village actions; 36 checks and final physical-key native/headless/mirror tests passed; ODA01 asset needs recorded in inventory G.

Sıradaki: ODA-02. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-02 (8 Ekim 2026)

Room stash reads the existing personal purse and item count without transfers or duplicate storage; 37 checks and final zero/restore/native/mirror UI passed; asset gerekmedi.

Sıradaki: ODA-03. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-03 (8 Ekim 2026)

Existing personal inventory rendered as read-only room rows and bounded table boxes; 38 checks and final native/mirror, real CHR gift, JSON, empty and long-list tests passed; asset needs in G.

Sıradaki: ODA-04. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-04 (8 Ekim 2026)

Pure justice/corruption view from existing bribe, embezzlement and unpaid injustice receipts; 40 checks and native/mirror passed, actual decisions and repair/JSON boundaries verified; asset gerekmedi.

Sıradaki: ODA-05. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-05 (8 Ekim 2026)

Permanent Goz Yumma and Harac Kesme choices extend the existing purse; 42 checks plus 2 insolvency checks passed, native/mirror and actual night/ledger/JSON/overflow verified; asset gerekmedi.

Sıradaki: ODA-06. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-06 (8 Ekim 2026)

Ayni kalici yetenek agacinda Keskin Bakis/Gonul Bagi: kisisel odeme, gercek CHR/heybe incelemesi ve adalet/yozlasma kosullu mevcut isyan esigi; 57 kontrol onarim tekrar/native/ayna gecti. Asset gerekmedi.

Sıradaki: ODA-07. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-07 (8 Ekim 2026)

Gercek kisisel kasa ve yozlasmadan tek gece teftisi; integer zar/JSON, temiz/bos/bulunamadi/azil/idam, mevcut terminal ve gece raporu/Ana son ekrani; 59+5 kontrol final native/ayna gecti. Asset gerekmedi.

Sıradaki: ODA-08. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-08 (8 Ekim 2026)

Tek kisisel oda/yorgunluk kaydi; gercek karar ve gece, etkin CHR tecrubesi, kisisel yatak/askilik/kutuphane ve gunluk dinlenme; 63 kontrol final gece/native/ayna gecti. G uc model ihtiyaci kayitli, asset uretilmedi.

Sıradaki: ODA-09. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-09 (8 Ekim 2026)

Gercek haksiz ret ve gece olumunden tek vicdan/kabus makbuzu; ayni yorgunluk ve acik ruya kutusu, Clue/kimlik yok; 65 kontrol final native/ayna gecti. G ODA09-KABUS kayitli, asset uretilmedi.

Sıradaki: ODA-10. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-10 (8 Ekim 2026)

Saf tek epilogue: mevcut terazi/kisisel kasa, koyden bagimsiz kader, teftis onceligi; 67 regresyon ve final150/native/ayna gecti. Asset gerekmedi.

Sıradaki: ODA-11. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.


## Codex — ODA-11 (8 Ekim 2026)

EKO01/11 ve ODA02 tek rusvet/kasa sozlesmesi; 6 kaynak/API/gercek kasa/gosterge kontrolu gecti. Ikinci kasa yazilmadi; asset gerekmedi.

Sıradaki: ODA-12. İlgili kontroller sonrası iki yerel kopya eşitlenir; yayın kullanıcının son yetkisine göre yapılır.
