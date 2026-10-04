# İçerik veri hattı

> **Status**: Designed (pending review)
> **Author**: Kullanıcı + ajanlar
> **Last Updated**: 2026-10-04
> **Last Verified**: 2026-10-04
> **Implements Pillar**: Oynanış değerleri koddan değil veriden gelir (kodlama standardı); 1243 (dönem ve ton)

## Summary

İçerik veri hattı, oyundaki her oynanış değerinin ve oyuncuya görünen her metnin tek kaynağıdır. İçerik, tipli Godot Resource dosyaları (`.tres`) olarak `res://data/` altında durur; metinler anahtarla başvurulur ve tek dil (Türkçe) tablosundan çözülür. Oyun açılırken katalog bir kez yüklenir, doğrulanır ve oturum boyunca salt okunur kalır.

> **Quick reference** — Layer: `Foundation` · Priority: `MVP` · Category: `Core` · Key deps: `Yok (yukarı akış)`

## Overview

Bu sistem kodla içeriği ayırır: kapıya gelen karakterler, sohbet ağaçları, barların başlangıç ve sınır değerleri, köy ve gün ayarları kodda değil veride yazılır. Kod yalnız "hangi kayıt, hangi alan" sorar. Böylece tasarımcı bir karakteri, bir sohbet satırını ya da bir eşiği kodu açmadan değiştirir; testler de gerçek içerik yerine küçük örnek kataloglarla çalışır. Sistem şemaları tek başına belirlemez: her kayıt türünün alanlarını o türün sahibi olan sistem (Karakter kadrosu, Sohbet, Barlar…) tanımlar. Bu belge kayıtların nerede durduğunu, nasıl adlandırıldığını, nasıl yüklenip doğrulandığını ve metin anahtarlarının nasıl çözüldüğünü tanımlar.

## Detailed Design

### Core Rules

1. **Veride olan, kodda olmaz.** Oynanış değeri (eşik, oran, sayı, süre) ya da oyuncuya görünen Türkçe metin kodda yazılmaz. Kodda yalnız motor sabitleri ve kayıt kimlikleri (`id`) bulunur.
2. **Biçim: tipli Resource.** Her kayıt türünün bir `class_name` betiği vardır (ör. `KarakterVerisi extends Resource`); alanlar `@export` ile ve tipli tanımlanır (tipsiz `Array`/`Dictionary` yok, bkz. `deprecated-apis.md`). Her kayıt ayrı bir `.tres` dosyasıdır.
3. **Yer: tür başına klasör.** `res://data/<tur>/<id>.tres` — ör. `data/karakterler/`, `data/sohbetler/`, `data/barlar/`, `data/ayarlar/`. Klasör listesi tür sahibi sistemler tasarlandıkça büyür; her türün klasörü bir kez tanımlanır.
4. **Kimlik.** Her kayıtta `id: StringName` vardır; küçük harf, ASCII, `snake_case` (Türkçe harf yok: `ahmet`, `kervan_bekcisi`). `id` kendi türü içinde tektir ve dosya adına eşittir. Kayıtlar birbirine **yol değil `id`** ile başvurur.
5. **Metin anahtarları.** Kayıtlar metni değil anahtarı taşır: `<tur>.<id>.<alan>` (ör. `karakter.ahmet.ad`, `sohbet.ahmet_ilk.s3`). Arayüz metinleri `arayuz.<ekran>.<alan>` kullanır. Türkçe karşılıklar tek bir tablodadır: `res://data/metin/metinler.csv` (UTF-8, sütunlar `keys,tr`), Godot çeviri içe aktarımıyla yüklenir ve `tr()` ile çözülür. Tek yerel: `tr`. Yeni dil eklemek yalnız yeni sütun eklemektir.
6. **Büyük harf kuralı.** Metin kodda `to_upper()` ile büyütülmez (Türkçe i/İ sorunu, sanat kitabı). Büyük harf gerekiyorsa tabloda öyle yazılır.
7. **Tek yükleme.** Katalog oyun açılışında, *Menü* gösterilmeden önce bir kez tüm kayıtları yükler ve tür başına `id → kayıt` sözlüğü kurar. Oturum içinde yeniden yükleme yoktur.
8. **Salt okunur.** Yüklenmiş kayıtlar değiştirilmez. Değişen her şey (köy nüfusu, bar değeri, kimin kabul edildiği) sahibi olan sistemin çalışma durumundadır. Kayıt dosyası oyun sırasında yazılmaz.
9. **Erişim katalog üzerinden.** Sistemler kayıtlara yalnız katalog aracılığıyla erişir: `getir(tur, id)` ve `hepsi(tur)`. Katalog açılışta bir kez kurulur ve ihtiyaç duyan sistemlere verilir (bağımlılık enjeksiyonu); testler kendi küçük kataloğunu kurar. Sistemler `load("res://data/...")` çağırmaz.
10. **Bulunamayan açıkça bildirilir.** `getir` olmayan bir `id` için varsayılan kayıt uydurmaz: boş döner ve geliştirme hatası kaydeder. Ne yapılacağına çağıran sistem karar verir.
11. **Doğrulama yüklemede.** Katalog yüklenirken her kaydı denetler (ayrıntı: Edge Cases): tekrarlanan `id`, dosya adı ≠ `id`, yanlış türde dosya, olmayan `id`'ye başvuru, tabloda olmayan ya da boş metin anahtarı, boş zorunlu alan, ve kayıt türünün sahibi olan belgenin koyduğu aralık kuralları. Her tür kendi doğrulama kuralını kendi betiğinde taşır; katalog yalnız çağırır ve hataları toplar.
12. **Hatada oyun başlamaz.** Doğrulama tüm hataları toplar (ilkinde durmaz). Bir hata bile varsa katalog *Hatalı* olur: geliştirme sürümünde hataların listesi gösterilir; dağıtım sürümünde kısa bir hata ekranı gösterilir ve oturum başlatılamaz. Sessiz düzeltme yoktur. Aynı doğrulama test paketinde de koşar, böylece hatalı içerik dağıtım sürümüne ulaşmaz.
13. **İçerik sürümü.** Katalogda bir tam sayı `icerik_surumu` bulunur (`data/ayarlar/icerik.tres`). İçerik, eski kayıtları bozacak biçimde değiştiğinde bir artırılır. Kaydet / yükle (16) bu sayıyı kayda yazar; uyuşmazlıkta ne olacağına 16 karar verir.
14. **Kayıtlar `id` taşır.** Kayıt dosyası (save) Resource değil `id` saklar; yüklemede kayıtlar katalogdan `id` ile geri alınır.

### States and Transitions

| Durum | Giriş | Çıkış | Bu durumda |
|---|---|---|---|
| **Yüklenmedi** | Program başlar | Açılış yüklemeyi başlatır → *Yükleniyor* | `getir`/`hepsi` çağrısı geliştirme hatasıdır |
| **Yükleniyor** | Açılış | Doğrulama bitti: hata yok → *Hazır*; ≥1 hata → *Hatalı* | Oyun durumu (1) *Menü*'ye geçmez |
| **Hazır** | Hatasız doğrulama | Yok (program kapanana dek) | Salt okunur erişim |
| **Hatalı** | ≥1 doğrulama hatası | Yok (içerik düzeltilip program yeniden açılır) | Hata listesi/ekranı; oturum başlatılamaz |

Geçişler tek yönlüdür; *Hazır* ve *Hatalı* son durumlardır.

### Interactions with Other Systems

| Sistem | Ne alır | Yön |
|---|---|---|
| Oyun durumu ve gün döngüsü (1) | Katalog *Hazır* olmadan *Menü*'ye geçmez; *Hatalı*'da hata kancası. Kendi ayar değerleri (ör. kuyruk bekleme süresi) `data/ayarlar/` altındadır | 2 → 1 |
| Karakter kadrosu (5) | `KarakterVerisi` türünün sahibi; alanları 5 tanımlar | 2 ↔ 5 |
| Varış kuyruğu (4) | Karakter `id`'leri ve geri dönüş kurallarının değerleri | 2 → 4 |
| Sohbet (6) | `SohbetVerisi` türünün sahibi; satırlar metin anahtarıdır | 2 ↔ 6 |
| Barlar (8) | Bar tanımları (başlangıç, sınırlar) | 2 ↔ 8 |
| Rüşvet hakları (9) | Hak sayısı (demo: 3) veridir | 2 → 9 |
| Köy nüfusu (10), Köy yapıları (11), Köyün oturması (13), Sonlar (15) | Kendi tür ve ayar kayıtları | 2 → |
| Kaydet / yükle (16) | `icerik_surumu`; kayıtta `id` saklanır | 2 → 16 |
| HUD (19), Sohbet ve karar arayüzü (18), Menüler (21) | Metin anahtarları `tr()` ile çözülür | 2 → |

## Formulas

Bu sistem oynanış sayısı tanımlamaz: taşıdığı her değerin anlamı ve aralığı, değerin sahibi olan sistemin belgesindedir (ör. bar sınırları Barlar'da, hak sayısı Rüşvet hakları'nda). Tek sayısal alanı `icerik_surumu`dur; o bir sayaçtır, ayar değeri değildir (Core Rules 13).

## Edge Cases

- **If iki kayıt aynı türde aynı `id`'yi taşırsa**: ikisi de reddedilir, iki dosya yolu da hatada yazılır, katalog *Hatalı*.
- **If dosya adı `id`'ye eşit değilse** (ör. `ahmet.tres` içinde `id = "mehmet"`): doğrulama hatası. Ad ya da `id` düzeltilene dek oyun başlamaz.
- **If `id` büyük harf, boşluk ya da Türkçe harf taşırsa** (`Ahmet`, `kervan bekçisi`): doğrulama hatası. Sessizce küçük harfe çevrilmez.
- **If bir tür klasöründe başka türden bir Resource ya da yüklenemeyen bir dosya varsa**: doğrulama hatası (dosya yolu ve beklenen tür yazılır).
- **If bir kayıt olmayan bir `id`'ye başvurursa** (ör. sohbet `karakter_id = "ali"`, Ali yok): doğrulama hatası.
- **If bir metin anahtarı tabloda yoksa ya da Türkçe hücresi boşsa**: doğrulama hatası. Oyun içinde ham anahtar oyuncuya hiçbir zaman gösterilmez.
- **If tabloda hiçbir kaydın kullanmadığı anahtar varsa**: hata değil, geliştirme uyarısı (artık metin). Oyun başlar.
- **If CSV UTF-8 BOM ya da CRLF satır sonu taşırsa**: aynı anlamda okunur; hücre başındaki/sonundaki satır sonu karakteri anahtara karışmaz. Türkçe harfler (ç ğ ı İ ö ş ü) bozulmadan gelir.
- **If bir türün klasörü boşsa**: katalog bunu kendi başına hata saymaz. Bir türün en az kaç kayıt istediğini sahibi belirler (ör. Karakter kadrosu "en az 1 karakter" diyebilir); o kural doğrulamada çalışır.
- **If bir alan, sahibi olan belgenin koyduğu aralığın dışındaysa** (ör. bar başlangıcı sınırın üstünde): doğrulama hatası. Değer kırpılmaz.
- **If sohbet kayıtları birbirine döngüyle başvurursa**: katalog döngüyü hata saymaz; döngünün geçerli olup olmadığına Sohbet (6) kendi doğrulama kuralıyla karar verir.
- **If `getir` olmayan bir `id` ile çağrılırsa** (doğrulamadan sonra, ör. eski bir kayıttan gelen `id`): boş döner, 1 geliştirme hatası. Varsayılan kayıt yok.
- **If katalog *Hazır* olmadan `getir`/`hepsi` çağrılırsa**: boş döner, 1 geliştirme hatası.
- **If bir sistem yüklenmiş bir kaydı değiştirmeye çalışırsa**: değişiklik kabul edilmez (kayıtlar salt okunur sunulur); geliştirme sürümünde hata. Bir sistem kayıttan çalışma kopyası isterse `duplicate_deep()` ile kendi kopyasını alır ve kopya kataloğa geri yazılmaz.
- **If oyun sırasında `.tres` ya da CSV dosyası diskte değişirse**: oyun bunu görmez; değişiklik bir sonraki açılışta okunur.
- **If doğrulama birden çok hata bulursa**: ilkinde durmaz, hepsi tek listede gösterilir.
- **If dağıtım sürümünde katalog *Hatalı* olursa**: kısa bir hata ekranı (metin tablodan değil koddan gelir, çünkü tablonun kendisi bozuk olabilir), oturum başlatılamaz, program kapatılabilir.

## Dependencies

**Yukarı akış (bu sistemin bağlı olduğu):** Yok — Foundation katmanı. Motor: Godot Resource içe aktarımı ve CSV çeviri içe aktarımı.

**Aşağı akış (bu sisteme bağlı olanlar):**

| Sistem | Bağ | Arayüz |
|---|---|---|
| Oyun durumu ve gün döngüsü (1) | Sert | Katalog *Hazır* olmadan *Menü* yok; *Hatalı* → hata kancası; kendi ayar değerleri `data/ayarlar/` |
| Varış kuyruğu (4) | Sert | Karakter `id`'leri, geri dönüş kuralı değerleri |
| Karakter kadrosu (5) | Sert | `KarakterVerisi` türünün sahibi; alanları ve doğrulama kuralını 5 tanımlar |
| Sohbet (6) | Sert | `SohbetVerisi` türünün sahibi; satırlar metin anahtarı |
| Barlar (8) | Sert | Bar tanımları ve aralıkları |
| Rüşvet hakları (9) | Sert | Hak sayısı veridir (sistem dizininde 9 → 2 bağı eklenmeli) |
| Köy nüfusu (10) | Sert | Köy ayarları |
| Köy yapıları (11) | Sert | Yapı kayıtları (kervansaray, pazar) |
| Köyün oturması (13) | Sert | Oturma eşiği veridir |
| Sonlar (15) | Sert | Son kayıtları ve metinleri |
| Kaydet / yükle (16) | Sert | `icerik_surumu`; kayıtta `id` saklanır |
| Sohbet ve karar arayüzü (18), HUD (19), Menüler (21) | Sert | Metin anahtarları `tr()` ile |
| Ses (22) | Yumuşak | Ses kayıtları ileride veriye taşınabilir |

*Her tür sahibi sistemin belgesi şunları yazmalıdır: tür adı, alanları, en az kayıt sayısı ve doğrulama kuralı (çift yönlü bağımlılık).*

## Acceptance Criteria

> **Gözlem noktaları:** "Hazır/Hatalı" = kataloğun bildirdiği durum. "Hata listesi" = doğrulamanın topladığı kayıtlar (her biri dosya yolu ve kural adı taşır). Testler `res://data/` yerine küçük örnek klasörlerle (fixture) kurulan kataloğu kullanır.

- **AC-1 (Logic) Geçerli içerik.** **GIVEN** 2 karakter, 1 sohbet, tüm anahtarları tabloda olan örnek klasör **WHEN** katalog yüklenir **THEN** *Hazır*, hata listesi boş, `hepsi(karakterler)` 2 kayıt döner.
- **AC-2 (Logic) Getir.** **GIVEN** *Hazır* katalog **WHEN** `getir(karakterler, "ahmet")` **THEN** `id == "ahmet"` olan kayıt döner. **WHEN** `getir(karakterler, "yok")` **THEN** boş döner, 1 geliştirme hatası.
- **AC-3 (Logic) Tekrarlanan id.** **GIVEN** aynı `id`'li iki karakter dosyası **WHEN** yükleme **THEN** *Hatalı*, hata listesinde iki dosya yolu da var.
- **AC-4 (Logic) Dosya adı ≠ id.** **GIVEN** `ahmet.tres` içinde `id = "mehmet"` **THEN** *Hatalı*, 1 hata.
- **AC-5 (Logic) Geçersiz id biçimi.** **GIVEN** sırayla `Ahmet`, `kervan bekcisi`, `çoban` **THEN** her birinde *Hatalı*, değer değiştirilmemiş.
- **AC-6 (Logic) Kırık başvuru.** **GIVEN** sohbet `karakter_id = "ali"`, Ali yok **THEN** *Hatalı*, hata kural adı "başvuru".
- **AC-7 (Logic) Eksik metin.** **GIVEN** bir kayıt `karakter.ahmet.ad` anahtarını taşır, tabloda yok; ayrı bir testte var ama `tr` hücresi boş **THEN** her ikisinde *Hatalı*.
- **AC-8 (Logic) Artık metin.** **GIVEN** tabloda kullanılmayan 1 anahtar **THEN** *Hazır*, 1 uyarı, 0 hata.
- **AC-9 (Logic) Tüm hatalar toplanır.** **GIVEN** 3 ayrı hatalı kayıt **THEN** hata listesi 3 kayıt taşır.
- **AC-10 (Logic) Türkçe karakter.** **GIVEN** BOM'lu ve CRLF'li CSV'de `arayuz.test.metin = "Çığ İşi Öğün Şüş"` **WHEN** `tr("arayuz.test.metin")` **THEN** dize birebir aynı döner.
- **AC-11 (Logic) Salt okunur.** **GIVEN** *Hazır* katalog **WHEN** bir sistem alınan kaydın bir alanını değiştirmeye çalışır **THEN** sonraki `getir` aynı kaydı değişmemiş döner.
- **AC-12 (Logic) Hazır öncesi erişim.** **GIVEN** *Yüklenmedi* **WHEN** `getir` **THEN** boş, 1 geliştirme hatası.
- **AC-13 (Logic) Sahip kuralı çalışır.** **GIVEN** bir türün betiği "en az 1 kayıt" kuralı koyar, klasör boş **THEN** *Hatalı*. **GIVEN** kural yok, klasör boş **THEN** *Hazır*.
- **AC-14 (Integration) Menü kapısı.** **GIVEN** katalog *Hatalı* **WHEN** oyun açılır **THEN** Oyun durumu *Menü*'ye geçmez; hata ekranı gösterilir. **GIVEN** *Hazır* **THEN** *Menü* açılır.
- **AC-15 (Integration) Gerçek içerik CI'da.** **GIVEN** depodaki `res://data/` **WHEN** test paketi koşar **THEN** katalog *Hazır* (bu test kırmızıysa birleştirme yok).
- **AC-16 (Logic) Kodda metin ve sayı yok.** **GIVEN** `src/` altındaki `.gd` dosyaları **WHEN** denetim betiği Türkçe harf içeren dize sabitlerini ve `to_upper(` çağrılarını arar **THEN** bulgu yok (hata ekranı metni gibi açıkça işaretlenmiş istisnalar hariç).
- **AC-17 (UI) Hata ekranı.** **GIVEN** dağıtım sürümü, bozuk içerik **WHEN** açılış **THEN** hata ekranı görünür ve okunur; ekran görüntüsü `production/qa/evidence/` altında saklanır.
- **AC-18 (Performance) Yükleme süresi.** **GIVEN** MVP içeriği, hedef PC **WHEN** açılış **THEN** katalog yükleme + doğrulama 1 saniyenin altında.

## Open Questions

1. **İçerik sürümü uyuşmazlığı** — eski kayıt yeni içerikle açılırsa ne olur (reddet / dönüştür)? Kaydet / yükle (16) karar verecek.
2. **Hata ekranı metni** koddadır (tablo bozuk olabilir); Core Rules 1'e tek istisna olarak kabul edildi, AC-16'nın istisna listesi bu kadarla sınırlı kalmalı.
3. **CSV çeviri içe aktarımı ve `StringName` id'ler** Godot 4.7.2'de doğrulanmadı (`docs/engine-reference/godot/` içinde `core.md`/`scripting.md` yok). İlk uygulama hikâyesinde küçük bir deneme ile doğrulanacak.
4. **Sistem dizini düzeltmesi** — Rüşvet hakları (9) bağımlılıklarına 2 eklenecek.
5. **İçerik düzenleme aracı** — `.tres` dosyaları editörde elle mi düzenlenecek, yoksa bir tablo → `.tres` dönüştürücüsü mü yazılacak? Karakter ve sohbet sayısı belli olunca (5 ve 6) karar verilecek.
