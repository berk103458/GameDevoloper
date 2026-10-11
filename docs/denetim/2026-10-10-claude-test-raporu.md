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

| BUG-0007 | S3 | SYS-16 | Bozuk/negatif `diyalog_sira` kaydı `_gemini[-1]` ile listenin sonundan diyalog okuturdu | Düzeltildi | `src/sistemler/diyalog_sirasi.gd` doğrulama · `f350af5` |
| BUG-0008 | S3 (regresyon) | KRI-13/15 | Triyaj ve ot toplama `hekim_ilac_kontrol` eski tedavi sırası/afyon varsayımını bozdu (tam sanity yakaladı) | Düzeltildi | Test senaryosu yeni davranışa göre · `6ea6972` |
| BUG-0009 | S2 (regresyon) | SYS-19 | Başlangıçsız agalik kaydı yüklemede farklı başlıyordu → kayıt devamı JSON eşitliği bozuldu (`levent_firari` testleri) | Düzeltildi | Geçersiz başlangıç −1, sonraki gece işaretlenir · `6ea6972` |
| BUG-0010 | S3 | SYS-20 | Güvenlik çoğu oyunda yüksek olduğundan "Beyin Uç Köyü" diğer sonları eziyordu (akış testi yakaladı) | Düzeltildi | Bey sonu: ferman ya da Güvenlik ≥70 + ≥3 etkin nöbetçi · `4981688` |

## Açık öneriler (hata değil)

- **ADV-01 (HAR-15, UX):** "Güvenlik … savunma hazırlığı +N" satırı köylü kartının alt kısmında; kaydırmadan görünmüyor. Kartın üst bölümüne taşınması önerilir.
- **ADV-02 (ADM-14 debug):** "Kuyu zehri" debug enjektörü herkese açık `hasta` bayrağı verir; bu, Şifahane hekimini de çalışamaz kılar (KRI-08 vitrininde `hekim etkin: false`). Debug aracı için beklenen davranış; gerçek KRI-04 kirlenmesinde tifo yalnız su içenlere ve olasılıkla düşer.
- **ADV-03 (eski kayıt):** BUG-0001 düzeltmesi yeni kabulleri düzeltir; eski kayıtlarda zaten `usta_demirci` almış CHR köylülerinin bayrağı göç ettirilmez (kayıt göçü ayrı karar ister).

- **ADV-04 (KRI-09, süreç):** Codex KRI-09 commit'inde sanity altyapısını da değiştirdi (`python_test_runner.py`, `acilis_denetimi.py --filesystem`, `api_sozlesmesi.py --manifest` + `api_sozlesmesi_baseline.json`, sanity kilidi). İncelendi: hata yakalama zayıflamadı (manifest bildirimi birebir karşılaştırır, dosya sistemi taraması izlenmeyen yeni dosyaları da kapsar). Not: korumalı API'de bilinçli bir değişiklik artık manifestin de güncellenmesini ister.
- **ADV-06 (KRI-11, UX):** "Teşhis ibresi" satırı her incelemede (yüz, heybe) konuşma kaydına tekrar yazılıyor; bilgi doğru, yalnız tekrar ediyor.
- **ADV-07 (SYS-18/20, tasarım):** Atıl bayrak sonuçları ve nihai son eşikleri `data/atil_bayraklar.json` / `data/nihai_sonlar.json` içinde; denge için Berk'in gözden geçirmesi önerilir.
- **ADV-05 (KRI-10, tasarım):** Kenetlenme bonusu, belirtisiz (gizli kuluçkadaki) bir enfeksiyon varken de verilmez. Kim olduğu söylenmez ama "bonus gelmedi" dolaylı ipucu olabilir; tasarım kararı olarak Berk'e bırakıldı.

## Otonom döngüden gelecek maddeler (KRI-09 … SYS-20)

Bu bölüm her yeni madde yayınlandıkça aynı kontrol listesiyle doldurulur.

| Madde | Commit | Birim/Akış | Tam sanity | Görünür Godot | Bulgu |
|---|---|---|---|---|---|
| KRI-09 | `e0fde8c` | 43 / 17 assert, kayıt ✔ | 302/0 | ✔ 6 köylüden düşük sadakatli 4 leventten tavan 3'ü kaçtı, sadık levent kaldı; Güvenlik 92→56; 2. kriz gecesinde ikinci dalga yok; kartta chr_/Clue_ sızıntısı yok | ADEQUATE · ADV-04 |
| KRI-10 | `5e16532` | 36 / 17 assert, kayıt ✔ | 302/0 | ✔ Kireçle temizlik + iyileşme gecesi tek "Toplumsal kenetlenme": Sadakat 50→58, Refah 40→50; makbuz kapandı | ADEQUATE · ADV-05 |
| KRI-11 | `c1b0fec` | birim + kapı akışı, kayıt ✔ | 304/0 | ✔ Codex ekranları: belirti, teşhis ibresi, kabulde karantina şartı | Codex başlattı, Claude tamamladı · ADV-06 |
| KRI-12 | `acbf185` | 8 / 4 assert, kayıt ✔ | 319/0 | ✔ "Açlık ve hastalık" rapor satırı | ADEQUATE · metin düzeltildi (`54f9f08`) |
| KRI-13 | `81a7d96` | 15 / 7 assert, kayıt ✔ | 319/0 | ✔ "Şifahane dolu" satırı, triyaj | ADEQUATE · BUG-0008 |
| KRI-14 | `6ebb1b0` | 10 / 6 assert, kayıt ✔ | 319/0 | akış testi (uyarı → arbede) | ADEQUATE |
| KRI-15 | `8afee73` | 10 / 4 assert, kayıt ✔ | 319/0 | ✔ "Şifalı ot" satırı | ADEQUATE · BUG-0008 |
| SYS-16 | `f350af5` | 8 / 2 assert, kayıt ✔ | 319/0 | akış testi (gerçek Devam) | ADEQUATE · BUG-0007 |
| SYS-17 | `31ccc4f` | mantık testi | 319/0 | — (veri) | ADEQUATE |
| SYS-18 | `00866b7` | 12 assert, kayıt ✔ | 319/0 | — (rapor satırı birim testte) | ADEQUATE |
| SYS-19 | `f8bb296` | 10 assert, kayıt ✔ | 319/0 | — (mevcut perde kartı) | ADEQUATE · BUG-0009 |
| SYS-20 | `4981688` | 18 / 3 assert | 319/0 | ✔ Son ekranı "Ahi Kasabası" + epilog | ADEQUATE · BUG-0010 |

KRI-12 … SYS-20: Codex limiti 15 Ekim 17:38'e kadar dolduğu için Claude yazdı (kullanıcı kararı: "Codex limiti bitince Claude çalışır"). Dokuz madde ayrı commit'lerdir; tam sanity birleşik son durumda koşuldu (iki tur: ilki 4 regresyon yakaladı, düzeltmeden sonra 319/0).

## 11 Ekim 2026 — 7/24 oynanıştan çıkan oyun hatası (Claude)

| ID | Önem | Madde | Bulgu | Düzeltme |
|---|---|---|---|---|
| BUG-0016 | P1 · [DONMA] | KAP/CHR sorgusu | 7/24 otomatik oynanışta (oyun 103, 106, 107, 108) CHR sorgusunda kapı kilitlendi: başarısız ikna/blöf denemesi cevabı kalıcı kapatıyor (`chr_sorgusu.gd:46`), kalan cevap ipucu istiyor; panel "Kararını ver"i yalnız hiç seçenek yokken gösterdiğinden (`chr_diyalog_paneli.gd`) inceleme ipucu vermezse oyuncu kapıda sıkışıyordu. | DÜZELTİLDİ (Claude): hiçbir cevap açık değilken `KilitliKarar` "Kararını ver" çıkışı; ipucu bulunursa kanıtlı cevap yine açılır. Regresyon: `tests/unit/kvr/chr_kilit_cikisi_test.gd`. chr_sorgu_test, chr_kapi_kontrol, hastalik_teshis_kontrol GEÇTİ. Tester doğrulaması bekleniyor. |
| BUG-0017 | P1 · [HATA]/[PERFORMANS] | KÖY-05/SYS (sinsi gece rutini) | 7/24 oyun 112 (2. perde, sancak fermanıyla levent gönderimi sonrası): köyden ayrılan/ölen köylünün 3B modeli sahnede kalırken `SinsiGeceRutini.nobetciler` her karede `yonetim.koylu(id)` = null ile `IsKazalari.nobet` çağırdı; 500+ `SCRIPT ERROR: 'is_yeri' on Nil` ve kare başı hata yükü. | DÜZELTİLDİ (Claude): kaydı olmayan model nöbetçi sayılmaz (`src/koy/gorsel/sinsi_gece_rutini.gd`). sinsi_gece_test, sinsi_gece_kontrol, muhafiz_devriyesi_kontrol, sancak_asker_kontrol GEÇTİ. Tester: sonraki 2. perde oyunlarında `is_yeri` hatası sıfır mı doğrula. |
| BUG-0018 | S3 · [DENGE]/[TASARIM] — ROADMAP 2 kapsamı, uygulanmadı | EKO-02 odun zinciri × açılış sırası | Tester Tur 3 kök neden analizi: otomatik oyuncu Orman Kampı (odunluk) kurmadığından 101–117 oyunlarında odun 1. günden 0, köy 5 yapıda donuyor, gıda nüfusa yetişmiyor → 2. perdede kıtlık + huzur çöküşü, 17 oyunda 0 zafer. **Düzeltme (Claude, 04:00, ADM-16 köprü durum dökümüyle):** açılış stoğu 20 odun / 5 taş; Orman Kampı (4 odun, 2 taş) + Hızarhane (6 odun, 2 taş, 1 alet) = 10 odun / 4 taş → önce bu ikisi kurulursa zincir başlar. İlk kayıttaki "açılış ≈9 odun, kesin kilit" iddiası YANLIŞTI (gün 0 satırı ilk inşaattan sonra yazılıyor). Gerçek sorun **strateji tuzağı**: önce çadır/tarla kurulursa odun geri dönüşsüz biter, oyuncu uyarılmaz. | AÇIK — ROADMAP 2 "açılış ekonomisi dengesi" konusu; kullanıcı ROADMAP 2'yi yasakladığı için düzeltilmedi. Tester köprü personalarıyla (ADM-16) "önce odun zinciri" ve "önce barınak" rotalarını ayrı ölçecek. |
