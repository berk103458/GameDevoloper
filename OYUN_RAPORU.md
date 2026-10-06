# Kapı Muhafızı — Oyun Raporu (yerel)

**Dal:** `claude/festive-volta-li1sfm` @ `de421a6` (origin ile eşit)
**Tarih:** 6 Ekim 2026 ~21:30 Europe/Istanbul
**Kural:** Commit/push yok. Bu dosya yerel kalır.

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

