# Tester Gelişim Planı — profesyonel QA seviyesi

**Hazırlayan:** Claude (Berk) · **İsteyen:** Muharrir · **Tarih:** 11 Ekim 2026 · **Durum:** PLAN (uygulama başlamadı)
**Kapsam:** Yalnız plan. Oyun koduna, ROADMAP dosyalarına dokunulmadı. Aşağıdaki TST-xx maddeleri ROADMAP'e **eklenmedi**; onay gelince eklenir.

> **1 dakikalık özet.** Tester (DeepSeek v4.1 Flash / EVREN) bugün 7/24 oyun kayıtlarını okuyup hata ve donma yakalayabiliyor, karakter modellerini ölçebiliyor. Ama (1) oyunu **kendi kararıyla oynayamıyor** — rastgele bir otomatik oyuncunun kaydını yorumluyor; (2) **ölçülebilir bir puanı yok** — "iyi/kötü" kanaati var, kıyas ve trend yok; (3) **performans, kayıt bütünlüğü, arayüz taşması, erişilebilirlik** hiç ölçülmüyor. Plan: 15 metrikli kanıta dayalı puan kartı, S/P hata matrisi, 7 oyuncu personası, 14 test türü ve 14 uygulama maddesi (TST-01…TST-14). İlk üç madde (puan kartı, hata yaşam döngüsü, otomatik ölçüm kancaları) tek başına raporların güvenilirliğini ikiye katlar.

---

## 1. Mevcut durum

### Yapabildikleri (kanıtlı)
| Yetenek | Dosya / örnek |
|---|---|
| 7/24 döngü: GitHub'ı 30 sn'de izler, yeni commit gelince tur, yoksa saatlik tur; raporu yayımlar | `~/.codex-tester/tester_dongu.sh`, `docs/tester/turlar/TUR-002.md` |
| 7/24 otomatik oynanış, görünür pencere, sessiz; donma bekçisi (180 sn ilerleme yok → DONMA) | `~/.codex-tester/oyna_surekli.sh`, `work/tester/oyunlar/ozet.tsv` |
| Oyun içi izler: `NABIZ` (ekran/evre değişimi), `OLAY` (kart metni), `DURUM` (iki nüfus kaynağı, sınıflar, akçe, ambar) | `tests/oto/otomatik_oyuncu.gd` |
| Hata/donma bulma ve kök neden izleme | TST-0003 (= BUG-0017, gece rutini null erişimi) doğru kök nedenle bulundu |
| Düzeltme doğrulama | BUG-0016 DOĞRULANDI (birim test + 7/24 kayıt) |
| Karakter muayenesi: 44 model × 7 hareket, ön/yan temas sayfası, ayak/el/boy ölçümü | `tests/oto/karakter_muayene.tscn` |
| Tam sanity (326 kontrol), akış testleri | `tools/sanity_check.py` |

### Yapamadıkları — kör noktalar
| # | Kör nokta | Somut örnek |
|---|---|---|
| K1 | **Kendi kararıyla oynayamıyor.** Oyunu oynayan, kabul oranına göre rastgele basan bot. Denge yargısı bot stratejisiyle kirleniyor. | 108–114 arası 7 oyunun 7'si kötü sonla bitti; bunun oyundan mı bottan mı olduğu ayırt edilemiyor. Köprü (ADM-16) henüz yok. |
| K2 | **Puan ve kıyas yok.** Raporlar kanaat; tur tur karşılaştırılabilir sayı yok, dış oyunlara kalibrasyon yok. | `GELISIM_RAPORU.md` girişleri "ölçülmedi" alanlarıyla dolu. |
| K3 | **Performans ölçülmüyor.** FPS, kare süresi, bellek, yüklenme süresi hiç kaydedilmiyor. | Admin'deki `PerformansSeridi` yalnız ekranda; logda yok. |
| K4 | **Kayıt/yükleme bütünlüğü** yalnız birim testlerinde; gerçek uzun oyunda kaydet→yükle→aynı gidiş karşılaştırması yok. | BUG-0013 (Devam köy fazını kaybediyordu) testlerden değil denetimden çıktı. |
| K5 | **Arayüz taşması / okunabilirlik / erişilebilirlik** ölçülmüyor; tek çözünürlük (1280×720). | Uzun kart metinlerinin kesilip kesilmediği bilinmiyor. |
| K6 | **Ses** hiç test edilmiyor (kullanıcı isteğiyle `--audio-driver Dummy`); hangi sesin çaldığı da kaydedilmiyor. | — |
| K7 | **Diyalog kalitesi** elle dilim okumaya bağlı; otomatik yazım/yapaylık taraması yok. | `metinler.csv` ~1700 satır; şimdiye kadar taranan 0. |
| K8 | **Çevre/harita** için otomatik ölçüm yok (havada nesne, iç içe geçme); yalnız ekran görüntüsü. | — |
| K9 | **Tester'ın kendi güvenilirliği:** test aracı hatasını oyun hatası sandı; tüm Godot süreçlerini kapattı; büyük görselle 429 alıp 40 dk işi kaybetti; Windows'ta dosya yaması zorlandı. | TST-0001 (aslında Claude'un DURUM satırı), Tur 2 ilk deneme kaybı. |
| K10 | **Kimlik karışıklığı:** bulgu `TST-0001` (4 hane) ile bu plandaki madde `TST-01` (2 hane) ve denetim `BUG-0016` yan yana. | Öneri: bulgular `TST-0001` kalır, maddeler `TST-01`; raporda daima tam biçim yazılır. |

---

## 2. Test türleri

| Tür | Yöntem | Araç | Sıklık | Çıktı |
|---|---|---|---|---|
| Fonksiyonel + regresyon | Her yeni commit'te değişen maddenin GDD'sine karşı kenar durumlar; düzeltilen her hata için regresyon testi var mı | sanity, akış testleri, `regression-suite` skill | Her commit turu | Tur raporu "Değişenler" + TST bulgusu |
| Smoke (duman) | Açılış→menü→yeni oyun→kapı→köy→gece→kaydet→devam; 20 gece duman | `DUMAN_TESTI_20=1`, acilis kontrolü | Her tur başı (≤5 dk) | GEÇTİ/KALDI tek satır; KALDI = S1 |
| Keşif (exploratory) | 60 dk'lık **charter**: "X'i Y ile Z amacıyla keşfet" (ör. "Divanı kanıtsız hükümle zorla, haksızlık zincirini bul"); not, kanıt, bulgu | Köprü (TST-05) + admin paneli | Turda 1 charter | Charter kaydı: hedef, süre, bulunanlar, kapsanmayan |
| Soak (uzun süre) | 7/24 oyun; saatlik bellek/FPS eğrisi, donma, sızıntı | `oyna_surekli.sh` + PERF izi (TST-03), `soak-test` skill | Sürekli; günlük özet | Günlük soak tablosu: oyun sayısı, donma, bellek eğimi |
| Denge ve ekonomi | Persona başına ≥20 oyun; son dağılımı, gece başı akçe/ambar/huzur eğrisi, hep-kazanan strateji | `tools/tester_istatistik.py` (TST-04), `balance-check` | Haftalık + denge commit'inde | Eğri tablosu + [DENGE] ONR |
| İlerleme / softlock | Her ekranda "basılabilir düğme yok ama ilerleme yok" tespiti; her olay kartının çıkışı var mı | `SECENEKSIZ` izi (TST-03), donma bekçisi | Sürekli | DONMA/KILIT olayı → anında Claude |
| Kayıt/yükleme bütünlüğü | Rastgele gecede kaydet→yeni süreçte yükle→N gece aynı tohumla iki dal; JSON + oyun gidişi karşılaştır | `kayit_ikizi` (TST-06) | Günde 10 ikiz | Fark raporu; fark = S2 |
| Kenar durumlar | Sınır değer listesi: 0 nüfus, 0 erzak, tavan akçe, eş zamanlı 3 kriz, perde geçiş gecesi ölüm, 11/12. gece kayıt | Admin enjektörleri + köprü | Turda 3 kenar | Kenar tablosu: girdi, beklenen, gerçek |
| Performans | FPS min/ort/%1 düşük, kare süresi, bellek, sahne yükleme süresi; 30+ köylüde ölçüm | PERF izi (TST-03) | Her oyunda otomatik | Tur başına performans satırı; eşik aşımı = S2/S3 |
| Görsel ve animasyon | Karakter muayenesi (ayak/el/boy, eksik klip, el eşyası çakışması) + çevre taraması (havada/iç içe nesne) | `karakter_muayene.tscn`, `cevre_muayene` (TST-08) | Haftalık tam, commit'te ilgili model | Model başı uyarı + temas sayfası |
| Arayüz ve okunabilirlik | Taşan/kesilen metin, üst üste binen panel, minimum yazı boyu, 3 çözünürlük (1280×720, 1920×1080, 2560×1440) ve metin ölçeği | `arayuz_tarayici` (TST-09) | Haftalık + arayüz commit'inde | TASMA listesi + ekran görüntüsü |
| Erişilebilirlik | Renk körlüğü simülasyonu (yalnız renkle verilen bilgi var mı), yalnız klavyeyle tam oyun, metin ölçeği en büyükte okunurluk, okuma hızı ayarı | Köprü (klavye), shader önizleme | Aylık + ilgili commit | Kontrol listesi (geçti/kaldı/ölçülemedi) |
| Yerelleştirme | Türkçe yazım/ek uyumu, `[KEY_NOT_FOUND]`, `%d` kalıntısı, eksik/fazla anahtar, Türkçe karakter (ı İ ş ğ) font kapsaması, taşan Türkçe metin | `metin_dogrula.py` + `metin_tarayici` (TST-10) | Her metin commit'i + haftalık tam | Anahtar listesi + önerilen düzeltme |
| Diyalog ve anlatı tutarlılığı | Karakter sesi tutarlılığı, aynı gün çelişki, ölü/ayrılmış karakterin anılması, olay metni ↔ koşul uyumu (ör. asker yokken okçu olayı), yapay duran replik | OLAY/DURUM izleri, `metin_tarayici` yapaylık kuralları, elle okuma | Turda bir karakter / olay grubu | [DIYALOG] bulgu: anahtar, metin, öneri |

---

## 3. Oyuncu personaları ve rotaları
Her persona, köprü (TST-05) üzerinde bir **politika** olarak çalışır; aynı tohumlarla karşılaştırılır.

| Persona | Davranış | Rota (ne test eder) |
|---|---|---|
| **Acemi** | Menüleri okur, ipucuna tıklar, yanlış karar verir, geri dönmeye çalışır | İlk 10 dakika: anlaşılırlık, öğretici eksikliği, ilk ölüm/iflas ne kadar erken |
| **Min-max'çı** | Ekonomiyi en iyiler: her rüşveti alır, en kârlı yapıları sıralar, işçiyi verime göre atar | Hep-kazanan strateji, ekonomi kaçağı, kaynak tavanı |
| **Hikâye odaklı** | Her soruyu sorar, her heybeyi inceler, CHR dallarını sonuna kadar izler | Diyalog derinliği, dal kapsaması, anlatı tutarlılığı, softlock |
| **Exploit avcısı** | Aynı düğmeye çift basar, kaydet-yükle istismarı, 3× hızda spam, sınır değerleri zorlar | Çift ödeme, kaydet-yükle kazancı, yarış durumu |
| **Sabırsız** | Diyalogu atlar, 3× hızda oynar, raporu okumaz | Bilgi kaçırınca cezalandırılıyor mu, hızda animasyon/olay bozulması |
| **Katı muhafız** | Herkesi reddeder, rüşvet almaz | Düşük nüfus yolu oynanabilir mi, hangi sona gider |
| **Merhametli** | Herkesi kabul eder | Kalabalık köy: performans, açlık-salgın sarmalı, 2. perde zamanlaması |

---

## 4. Puanlama sistemi

### Kurallar
1. **Kanıtsız puan yok.** Her puanın yanında kanıt (log yolu, ekran görüntüsü, adım listesi veya sayı). Kanıt yoksa `ölçülemedi`.
2. **Yaranmak yasak.** Ölçek, yayımlanmış ticari oyunlara göredir; "bizim proje için iyi" diye puan yükseltilmez. **7 ve üzeri = ticari bir oyunda kabul edilebilir kalite.** 10 verilmez (kıyas oyunlar bile her alanda 10 değildir).
3. **Kalibrasyon oyunları:** Papers, Please (kapı/karar döngüsü, belge ve ipucu okunurluğu), Manor Lords (köy yönetimi, köylü animasyonu, çevre), Disco Elysium (diyalog ve karakter sesi), Frostpunk ve This War of Mine (kıtlık/ahlak ikilemi, denge), RimWorld (olay üretimi ve tekrar oynanabilirlik). Her puan gerekçesinde **hangi oyunun hangi yönüne** göre verildiği bir cümleyle yazılır.
4. Bir metrik bir turda ölçülmediyse önceki puan **taşınmaz**; `ölçülemedi` yazılır, trendde boşluk görünür.
5. Puanlar `docs/tester/PUAN_KARTI.csv`'ye (`tur,tarih,commit,metrik,puan,kanit,kalibrasyon`) eklenir; tur raporunda önceki tura göre fark tablosu (▲/▼/=) zorunludur.

### Metrikler ve rubrikler (0–10)
| # | Metrik | 2 | 5 | 7 | 9 |
|---|---|---|---|---|---|
| 1 | **Kararlılık** | Saatte bir çökme/donma; ilerleme kaybı | Oyun başına 1+ SCRIPT ERROR ya da donma; ilerleme genelde korunur | 10 oyunda ≤1 hata, donma yok | 50+ oyunda 0 çökme/donma/hata |
| 2 | **Oynanış döngüsü** | Kararlar anlamsız, döngü 10 dk'da tükenir | Döngü çalışır ama kararların sonucu hissedilmez | Kapı→köy→gece döngüsü merak uyandırır, kararların izi görünür (Papers, Please ölçüsünde değilse de yakın) | Her gün yeni gerilim; "bir gün daha" etkisi |
| 3 | **Denge** | Tek strateji her zaman kazanır ya da hiç kazanılmaz | Birkaç strateji var ama biri baskın; bir kaynak hep 0 | Persona sonuçları farklı ve makul; baskın strateji yok | Her yolun bedeli ve ödülü dengeli; uç stratejiler bile oynanabilir |
| 4 | **Zorluk eğrisi** | Ani duvar ya da hiç zorluk yok | İlk günler kolay, sonra ani çöküş (ör. 2. perdede huzur hızla dibe) | Kademeli artan baskı; kayıp öngörülebilir nedenli | Frostpunk gibi: baskı artarken oyuncu araç kazanır |
| 5 | **Anlatı** | Olaylar bağlamsız, tekrar eden | Olaylar mantıklı ama birbirine bağlanmıyor | Kararlar sonradan geri döner; sonlar oyunun gidişini yansıtır | Kişisel, hatırlanan hikâyeler doğuyor |
| 6 | **Diyalog kalitesi** | Yazım hatası, yapay/şablon replik yaygın | Doğru ama düz; karakterler aynı konuşuyor | Dönem dili, karakter sesi ayırt edilir, az yapaylık | Disco Elysium ölçüsünde canlı, alt metinli |
| 7 | **Karakter özgünlüğü** | Model/ses/kişilik birbirinin kopyası | Görünüş farklı, davranış aynı | Her adlı karakterin belirgin hedefi, sırrı, tepkisi var | Karakterler oyuncu kararını hatırlar ve tavır değiştirir |
| 8 | **Görsel tutarlılık** | Yer tutucu kutular baskın, stil karışık | Ana sahneler tutarlı, kenarlar yarım | Mevsim/ışık/stil tutarlı; göze batan yer tutucu az | Manor Lords ölçüsünde bütünlüklü çevre |
| 9 | **Animasyon** | T-pozu, kayma, havada duran karakter sık | Yürüyüş var ama ayak kayıyor; hareket klipleri eksik | Yürüyüş/duruş inandırıcı; eksik klip az; el eşyası çakışmaz | Duygu hareketleri bağlama göre, geçişler pürüzsüz |
| 10 | **Arayüz / UX** | Taşan metin, kaybolan düğme, ne yapacağı belirsiz | İşlevsel ama kalabalık; geri bildirim eksik | Her eylemin geri bildirimi var; bilgi aranmadan bulunur | Papers, Please gibi arayüz oyunun kendisi olur |
| 11 | **Ses** (yer tutucu durumu ayrıca not edilir) | Ses yok ya da hatalı tetikleniyor | Temel efektler var, çoğu yer tutucu | Ortam + efekt + müzik yerinde; eksikler az | Ses gerilimi taşıyor (tansiyon müziği vb.) |
| 12 | **Performans** | <20 FPS ya da bellek sürekli artıyor | 30 FPS ort., ağır sahnede takılma | ≥60 FPS ort., %1 düşük ≥40, yükleme <5 sn | Her koşulda akıcı, uzun oyunda bellek düz |
| 13 | **Yerelleştirme (Türkçe)** | `[KEY_NOT_FOUND]`, bozuk karakter, çeviri kokusu yaygın | Eksik anahtar birkaç tane, ek/yazım hataları ara sıra | Yazım hatasız, doğal Türkçe, taşma yok | Dönem diline özen; yazar elinden çıkmış gibi |
| 14 | **Tekrar oynanabilirlik** | Her oyun aynı gidiyor | Olay havuzu tekrar ediyor; 3. oyunda bıkkınlık | Persona/tohum değişince farklı yollar ve sonlar | RimWorld gibi her oyun ayrı hikâye |
| 15 | **İlk 10 dakika** | Ne yapacağı anlaşılmıyor, ilk ekranda takılma | Anlaşılıyor ama yavaş/sıkıcı başlangıç | 10 dk içinde temel döngü öğrenilir ve merak oluşur | Papers, Please açılışı gibi: hemen içine çeker |

**Genel not:** 15 metriğin ağırlıksız ortalaması değil; **en düşük 3 metriğin ortalaması** "sürüm notu" olarak da yazılır (zayıf halka görünür kalsın).

### Her raporda zorunlu iki bölüm
- **En kötü 5 sorun:** önem sırasıyla, her biri kanıt ve S/P derecesiyle.
- **Bir oyuncu bunu neden bırakır?** En olası 3 bırakma anı (ör. "5. gecede akçe 1'e düşüp azille bitince oyuncu nedenini anlamaz") — persona ve kanıtla.

---

## 5. Hata yönetimi

### Önem (S) × Öncelik (P)
| Önem | Tanım | Örnek |
|---|---|---|
| **S1 Kritik** | Çökme, ilerleme kaybı, kayıt bozulması, kalıcı softlock | BUG-0016 kapı softlock'u |
| **S2 Büyük** | Mekanik yanlış, son ulaşılamaz, sürekli hata spam'i, ciddi performans düşüşü | BUG-0017 kare başı SCRIPT ERROR |
| **S3 Orta** | Yanlış sayı/metin, geçici görsel bozulma, iş görür geçici çözüm var | eksik metin anahtarı |
| **S4 Küçük** | Kozmetik, yazım | çift boşluk |

**Öncelik** (ne kadar hızlı): **P1** hemen (7/24 akışı bozuyor ya da sürüm engelliyor), **P2** bu tur, **P3** bu hafta, **P4** fırsat oldukça. Önem teknik etkidir, öncelik iş kararıdır; ikisi ayrı yazılır (ör. `S3/P1`: yazım hatası ama ilk ekranda).
Mevcut P0–P3 eşlemesi: P0→S1/P1, P1→S2, P2→S3, P3→S4.

### Zorunlu yeniden üretme biçimi
```
Kimlik · S?/P? · [KATEGORİ] · Madde · Başlık
Ortam: commit, tohum, kabul oranı/persona, çözünürlük, mod (pencereli/headless)
Ön koşul: (kayıt dosyası ya da admin ile kurulan durum)
Adımlar: 1) … 2) … 3) …
Beklenen: (kaynağı: GDD/ROADMAP satırı)
Gerçek: (sayı, metin, ekran görüntüsü)
Tekrar oranı: x/y deneme (en az 3 deneme; 1/3 altı "kararsız")
Kanıt: log/görsel yolları
Kopya kontrolü: aranan anahtar kelimeler + bulunan benzer kayıtlar
```

### Kopya kontrolü
Yeni kayıt açmadan önce BULGULAR + `docs/denetim/` içinde dosya adı, fonksiyon adı ve hata metniyle arama; eşleşme varsa yeni kayıt değil **not** eklenir. Test aracından kaynaklanan hata (ör. TST-0001) `[ARAÇ]` etiketiyle ayrılır ve oyun hatası sayılmaz.

### Yaşam döngüsü
`AÇIK → DÜZELTİLDİ (commit) → DOĞRULANDI (Tester, aynı adımlarla + regresyon testi) → KAPANDI`
Yan yollar: `YENİDEN AÇILDI`, `KOPYA (→ kimlik)`, `TASARIM GEREĞİ (gerekçe, karar sahibi)`, `ARAÇ HATASI`.
**Kural:** Hiçbir kayıt Tester doğrulaması olmadan KAPANDI olamaz; düzelten (Claude/Codex) yalnız DÜZELTİLDİ'ye kadar götürür.

---

## 6. Çıkış kriterleri
| Seviye | Engelleyen açık hatalar | Puan eşikleri | Diğer |
|---|---|---|---|
| **Oynanabilir** | Açık S1 = 0 | Kararlılık ≥5, İlk 10 dk ≥4 | Smoke GEÇTİ; 10 ardışık 7/24 oyunda donma yok; her son en az bir kez görüldü |
| **Alfa** | S1 = 0, S2 ≤ 3 (hepsi P2+ planlı) | 15 metriğin hiçbiri <4; Kararlılık ≥7; Denge ≥5 | 50 ardışık oyun 0 çökme; kayıt ikizi farkı 0; tüm personalar en az bir sona ulaşıyor |
| **Beta** | S1 = 0, S2 = 0, S3 ≤ 15 | Hiçbiri <6; ortalama ≥7; en düşük üçün ortalaması ≥6 | 7 gün soak'ta bellek eğimi düz, FPS ≥60 ort.; Türkçe taraması %100 satır; erişilebilirlik kontrol listesi geçti |

---

## 7. Otomasyon genişletmesi (yeni dosya + ince adaptör)
Hepsi `tests/oto/` ve `tools/` altında; oyun koduna dokunan tek kalem ADM-16 köprü adaptörüdür (zaten planlı).

| Kanca / ölçüm | Nerede | Ne üretir |
|---|---|---|
| `PERF` izi | `tests/oto/olcum/performans_izi.gd` (otomatik oyuncuya eklenen çocuk düğüm) | Her 10 sn: FPS, kare ms, statik/video bellek, düğüm sayısı; sahne geçişinde yükleme süresi |
| `SECENEKSIZ` izi | `tests/oto/olcum/ilerleme_izi.gd` | Ekranda etkin düğme yok + 20 sn değişim yok → anında olay (softlock adayı, ekran adıyla) |
| `KAYIT_FARK` / kayıt ikizi | `tests/oto/kayit_ikizi.tscn` | Rastgele gecede kaydet → yeni oturumda yükle → aynı tohumla N gece iki dal; JSON ve gün sonu farkı |
| `SES` izi | `tests/oto/olcum/ses_izi.gd` (Ses autoload'unun `cal` çağrısını dinleyen sarmalayıcı, Dummy sürücüde bile) | Hangi ses ne zaman istendi, eksik dosya |
| `TASMA` taraması | `tests/oto/arayuz_tarayici.gd` | Kesilen/taşan Label, ekran dışı Control, üst üste binen etkileşimli alan; 3 çözünürlük |
| Çevre muayenesi | `tests/oto/cevre_muayene.tscn` | Köy/kapı sahnesindeki MeshInstance3D'lerin zemine göre yüksekliği (havada/gömülü), kesişen AABB'ler, yer tutucu (BoxMesh/CapsuleMesh) sayımı ve konumları |
| Karakter muayenesi genişletme | `tests/oto/karakter_muayene.gd` | + ayak kayması (yürürken ayak hızı ↔ gövde hızı), el eşyası–gövde kesişimi |
| Metin tarayıcı | `tools/tester_metin_tarama.py` | Yazım kuralları, `[KEY_NOT_FOUND]`/`%d`, tekrar eden cümle, yapaylık kalıpları (noktalı virgül, "X değil, Y", modern kelime listesi), Türkçe karakter font kapsaması |
| İstatistik | `tools/tester_istatistik.py` | `ozet.tsv` + oyun loglarından son dağılımı, gece başı eğriler, persona kıyası, puan kartı trend tablosu |
| Köprü politikaları | `tools/tester_oyuncu.py --politika <persona>` (ADM-16) | Persona oyunları, JSONL durum dökümü |
| Tester güvenliği | `~/.codex-tester` döngüsü | Görsel boyut sınırı, artımlı rapor, süreç PID kuralı, 429'da geri çekilme |

---

## 8. Rapor biçimi
Her tur raporunun **en üstü** (1 dakikada okunur):
```
TUR N · tarih · commit · test edilen: … · süre
Durum: 🟢/🟡/🔴 (kural: açık S1 → 🔴; S2 → 🟡)
Üç cümle: en önemli değişiklik, en büyük risk, sonraki adım.
Puan kartı: 15 metrik tek satırda + önceki tura göre ▲▼= (ör. Kararlılık 6▲, Denge 3=, …)
En kötü 5 sorun (tek satır her biri)
Oyuncu neden bırakır? (3 madde)
```
Altında ayrıntı: test türleri, kanıtlar, persona sonuçları, bulgu listesi. **Teknik terim kuralı:** her terim ilk geçtiğinde parantezle sade Türkçesi yazılır (ör. "softlock (oyuncunun ilerleyemediği kilit)", "soak (saatlerce aralıksız çalıştırma)").

---

## 9. Uygulama adımları (öneri — ROADMAP'e eklenmedi)
| Madde | İş | Kabul kriteri | Bağımlılık | Boyut |
|---|---|---|---|---|
| **TST-01** | Puan kartı: 15 metrik, rubrik, kalibrasyon kuralı rehbere; `PUAN_KARTI.csv` ve tur raporu üst bölümü şablonu | 2 ardışık turda tüm metrikler puanlı ya da "ölçülemedi"; her puanda kanıt yolu ve kalibrasyon cümlesi; fark tablosu var | — | S |
| **TST-02** | Hata yönetimi: S/P matrisi, zorunlu tekrar biçimi, kopya kontrolü, yaşam döngüsü, `[ARAÇ]` etiketi; BULGULAR şablonu güncelleme | Yeni her kayıt biçime uyuyor; KAPANDI'ların hepsinde Tester doğrulaması var | — | S |
| **TST-03** | Ölçüm kancaları: PERF, SECENEKSIZ, SES izleri; donma bekçisine bağlantı | 7/24 oyunlarda her 10 sn PERF satırı; yapay softlock testinde SECENEKSIZ olayı 25 sn içinde | — | M |
| **TST-04** | İstatistik aracı: son dağılımı, eğriler, persona kıyası, puan trendi | `ozet.tsv`'den tek komutla tablo; günlük özet otomatik GELISIM_RAPORU'na | TST-01 | M |
| **TST-05** | Persona politikaları (7 persona) | Her persona 10 oyun oynar; sonuç dağılımları birbirinden farklı | ADM-16 köprüsü | M |
| **TST-06** | Kayıt ikizi | Günde 10 ikiz; bilinen bir kayıt hatası (eski BUG-0013 senaryosu) yakalanıyor | — | M |
| **TST-07** | Keşif charter sistemi: charter şablonu + 20 başlangıç charter'ı | Her tur 1 charter raporu (hedef, kapsanan, kapsanmayan, bulgu) | TST-01 | S |
| **TST-08** | Çevre muayenesi + karakter muayenesine ayak kayması ve el eşyası kesişimi | Bilinen örnek (Aydoğdu yayının gövdeden geçmesi) otomatik uyarı veriyor | — | M |
| **TST-09** | Arayüz tarayıcı, 3 çözünürlük + metin ölçeği | Bilerek uzatılmış bir metin TASMA olarak yakalanıyor | — | M |
| **TST-10** | Metin tarayıcı (yazım, anahtar, yapaylık, font kapsaması) | `metinler.csv` %100 tarandı; bulgu listesi anahtar + öneri biçiminde | — | M |
| **TST-11** | Erişilebilirlik kontrol listesi + renk körlüğü önizlemesi + yalnız klavye oyunu | Liste her maddede geçti/kaldı/ölçülemedi | ADM-16 (klavye) | S |
| **TST-12** | Smoke + çıkış kriteri değerlendirmesi: her tur başı smoke, haftalık "oynanabilir/alfa/beta" kararı | Haftalık raporda seviye kararı ve engelleyen hata listesi | TST-01, TST-02 | S |
| **TST-13** | Tester güvenilirliği: görsel boyut/sayı sınırı, artımlı rapor, PID kuralı, 429 geri çekilme, Windows'ta güvenli dosya yazma yöntemi rehbere | 10 ardışık turda iş kaybı 0, yabancı süreç kapatma 0 | — | S |
| **TST-14** | Kalibrasyon seti: her metrik için kıyas oyunlardan örnek açıklamalar ve "7 nedir" örnek kartları | Rehberde 15 metriğin her biri için kıyas notu; iki ayrı tur aynı oyuna ±1 puan veriyor (tutarlılık) | TST-01 | S |

**Önerilen sıra:** TST-13 → TST-01 → TST-02 → TST-03 → TST-12 → TST-06 → TST-10 → TST-08 → TST-09 → TST-04 → TST-07 → TST-14 → (ADM-16 sonrası) TST-05 → TST-11.

**Asset:** Bu plan asset gerektirmez. Muayenede görülen eksik hareket klipleri (CHR modellerinde `gergin`, adlı karakterlerde konuşma/duygu klipleri) `docs/EKSIK_ASSET_ENVANTERI.md`'ye işlendi.
