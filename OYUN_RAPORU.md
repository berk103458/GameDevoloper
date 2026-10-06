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
