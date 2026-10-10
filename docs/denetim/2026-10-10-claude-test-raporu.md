# Claude Test Raporu — ROADMAP HAR-12 … SYS-20 denetimi

**Tester:** Claude (Berk tarafı) · **Başlangıç:** 10 Ekim 2026 · **Dal:** `claude/festive-volta-li1sfm`
**Kapsam:** 9–10 Ekim'de kapanan maddeler (HAR-12 … KRI-08) ve otonom döngüyle gelecek KRI-09 … SYS-20.
**Rol dayanağı:** AGENTS.md › Roller — "Claude (Berk) … Codex'in işinin test ve onayını da o yapar."

## Yöntem

Projenin kendi QA skill'leri (`.claude/skills/`) yöntem olarak izlendi:

| Skill | Bu denetimde kullanımı |
|---|---|
| `test-evidence-review` | Her madde için test kanıtı derecesi: ADEQUATE / INCOMPLETE / MISSING |
| `test-gap-audit` | Davranış bazlı eksik kapsam (kayıt/yükleme, gizli bilgi sızıntısı, RNG) |
| `bug-report` | Hata kaydı biçimi: BUG-ID, önem (S1–S4), tekrar üretme, kanıt, düzeltme |
| `smoke-check` / `regression-suite` | `tools/sanity_check.py` tam paket + düzeltilen her hataya regresyon testi |

Her madde için kontrol listesi:
1. **Yapıldı mı?** ROADMAP `[x]` ↔ commit içeriği ↔ kod gerçekten bağlı mı.
2. **Kural uyumu:** yeni dosya + ince adaptör; korumalı çekirdek dosyada minimal satır; ikinci sistem yok; `metinler.csv` değişmedi; asset üretilmedi; gizli kimlik/CHR sırrı/Clue sızmıyor.
3. **Test kanıtı:** birim + gerçek akış otomasyonu; kayıt/yükleme; sanity listesinde.
4. **Tam sanity:** `tools/sanity_check.py` 0 hata, SCRIPT ERROR / Parse Error yok.
5. **Görünür Godot incelemesi:** gerçek pencerede vitrin sahnesi + ekran görüntüsü (`work/vitrin/`, commit edilmez).

## Kanıt tablosu (HAR-12 … KRI-08)

| Madde | Commit | Kim | Birim test (assert) | Akış testi (assert) | Kayıt/yükleme | Tam sanity | Görünür Godot | Kanıt |
|---|---|---|---|---|---|---|---|---|
| HAR-12 | `3411594` | Codex · Claude | 23 | 12 | ✔ | 275/0 | — (UI testi) | ADEQUATE |
| HAR-13 | `f21177d` | Codex · Claude | 23 | 21 | ✔ | 277/0 | ✔ Harita › Hisar | ADEQUATE |
| HAR-14 | `90a9b8e` | Codex · Claude | 29 | 20 | ✔ | 279/0 | ✔ Pazar + harita | ADEQUATE |
| HAR-15 | `d12a577` | Codex · Claude | 46 | 23 | ✔ | 281/0 | ✔ Köylü kartı | ADEQUATE |
| KRI-01 | `cfbb668` | Codex → Claude | 30 | 10 | ✔ | 283/0 | ✔ Kuluçka/belirti | ADEQUATE |
| KRI-02 | `109491d` | Codex · Claude | 66 | 21 | ✔ | 285/0 | ✔ Karantina kartı | ADEQUATE |
| KRI-03 | `0a808a2` | Codex · Claude | 42 | 18 | ✔ | 287/0 | ✔ Şifahane paneli | ADEQUATE |
| KRI-04 | `e0c1366` | Codex · Claude | 51 | 20 | ✔ | 289/0 | ✔ Meydan kuyusu | ADEQUATE |
| KRI-05 | `88d8a9a` | Codex · Claude | 40 | 31 | ✔ | 291/0 | ✔ Cenaze kararı | ADEQUATE |
| KRI-06 | `0fbfd00` | Codex · Claude düzeltti | 41 | 27 | ✔ | 293/0 | ✔ İsyan raporu | ADEQUATE |
| KRI-07 | `a2f1116` | Codex · Claude | 53 | 40 | ✔ | 295/0 | ✔ Meclis oyu | ADEQUATE |
| KRI-08 | `faff1d7` | Codex (otonom) · Claude | 56 | 26 | ✔ | 297/0 | ✔ Söylenti kartı | ADEQUATE |

Assert sayıları test dosyalarındaki `_kontrol/dene/assert` çağrılarıdır (yalnız varlık değil, davranış iddiası).

## Bulunan hatalar ve düzeltmeler

| ID | Önem | Madde | Özet | Durum | Düzeltme / commit |
|---|---|---|---|---|---|
| BUG-0001 | S2 | (eski, UZM-01/KRI-03 ile görünür oldu) | Gerçek zanaatı olan CHR, eski üçlü sınıftan yanlış usta bayrağı alıyordu: otacı Dudu (CHR_008, esnaf) `usta_demirci` → bina panelinde "usta demirci", demirhanede ×1,3 bonus; Şifahane'de usta değil | **Düzeltildi** | `Oturum._usta_uzmanlik`: CHR zanaatı varsa uzmanlık zanaattan (otacı/cerrah→cerrah, demirci, çiftçi, çoban). Adsız gelen eşlemesi ve sayfadaki gizli ustalık tasarımı korunur. Regresyon: `tests/unit/kvr/usta_uzmanlik_test.gd` · commit: *bu rapor commit'i* |
| BUG-0002 | S2 | KRI-06 | `hud.gd → AmbarKapisiPaneli → KoyEkrani → Ses` statik bağımlılığı `-s` birim testlerinde `SCRIPT ERROR: Identifier not found: Ses` (hud_islem_test FAIL) | Düzeltildi | Panel Node ördek tiplemeye çevrildi · `0fbfd00` |
| BUG-0003 | S4 | KRI-01 | Birim testte geçersiz kervan makbuzu ve `OlayVerisi` Resource referans karşılaştırması (test kurulumu, oyun kodu değil) | Düzeltildi | `cfbb668` |
| BUG-0004 | S4 (süreç) | KRI-03 | Commit başlığında "asset gerekmedi" yazıldı; aslında kutu yer tutucu `KRI03-ILAC` envanterde | Kayıt düzeltildi | ROADMAP/pano/Muharrir notu · `88d8a9a` (commit mesajı force-push gerektirdiği için değiştirilmedi) |
| BUG-0005 | S2 (süreç) | KRI-08 | Codex sandbox `.git` yazamıyor/ağa çıkamıyor; otonom döngü bunu algılamadan 16 turda aynı paketi tekrar doğruladı, Codex limiti boşa gitti, raporlara tekrar eden notlar yazıldı | Düzeltildi | Döngü v2: Codex `work/yayin_hazir.json` bırakır, betik sanity logunu doğrulayıp yayınlar; 2 boş turda durur. Tekrar eden notlar birleştirildi · `faff1d7` |
| BUG-0006 | S3 (altyapı) | KRI-07 | Yeni `class_name` sonrası editör import'u koşulmadan `-s` testi `Identifier not declared` verip kapanmadan asılı kalıyor | Açıklandı | Akış kuralı: yeni sınıftan sonra önce `--editor --import`; sanity zaten import ile başlar |

## Açık öneriler (hata değil)

- **ADV-01 (HAR-15, UX):** "Güvenlik … savunma hazırlığı +N" satırı köylü kartının alt kısmında; kaydırmadan görünmüyor. Kartın üst bölümüne taşınması önerilir.
- **ADV-02 (ADM-14 debug):** "Kuyu zehri" debug enjektörü herkese açık `hasta` bayrağı verir; bu, Şifahane hekimini de çalışamaz kılar (KRI-08 vitrininde `hekim etkin: false`). Debug aracı için beklenen davranış; gerçek KRI-04 kirlenmesinde tifo yalnız su içenlere ve olasılıkla düşer.
- **ADV-03 (eski kayıt):** BUG-0001 düzeltmesi yeni kabulleri düzeltir; eski kayıtlarda zaten `usta_demirci` almış CHR köylülerinin bayrağı göç ettirilmez (kayıt göçü ayrı karar ister).

- **ADV-04 (KRI-09, süreç):** Codex KRI-09 commit'inde sanity altyapısını da değiştirdi (`python_test_runner.py`, `acilis_denetimi.py --filesystem`, `api_sozlesmesi.py --manifest` + `api_sozlesmesi_baseline.json`, sanity kilidi). İncelendi: hata yakalama zayıflamadı (manifest bildirimi birebir karşılaştırır, dosya sistemi taraması izlenmeyen yeni dosyaları da kapsar). Not: korumalı API'de bilinçli bir değişiklik artık manifestin de güncellenmesini ister.
- **ADV-05 (KRI-10, tasarım):** Kenetlenme bonusu, belirtisiz (gizli kuluçkadaki) bir enfeksiyon varken de verilmez. Kim olduğu söylenmez ama "bonus gelmedi" dolaylı ipucu olabilir; tasarım kararı olarak Berk'e bırakıldı.

## Otonom döngüden gelecek maddeler (KRI-09 … SYS-20)

Bu bölüm her yeni madde yayınlandıkça aynı kontrol listesiyle doldurulur.

| Madde | Commit | Birim/Akış | Tam sanity | Görünür Godot | Bulgu |
|---|---|---|---|---|---|
| KRI-09 | `e0fde8c` | 43 / 17 assert, kayıt ✔ | 302/0 | ✔ 6 köylüden düşük sadakatli 4 leventten tavan 3'ü kaçtı, sadık levent kaldı; Güvenlik 92→56; 2. kriz gecesinde ikinci dalga yok; kartta chr_/Clue_ sızıntısı yok | ADEQUATE · ADV-04 |
| KRI-10 | `5e16532` | 36 / 17 assert, kayıt ✔ | 302/0 | ✔ Kireçle temizlik + iyileşme gecesi tek "Toplumsal kenetlenme": Sadakat 50→58, Refah 40→50; makbuz kapandı | ADEQUATE · ADV-05 |
| KRI-11 … SYS-20 | — | — | — | — | Codex limiti 15 Ekim 17:38'e kadar doldu; KRI-11 Codex'te yarım (yerelde `[/]`) |
