# Kapı Muhafızı — kare kare 2D UI animasyonu planı

Aday listesi ve üretim kaydı. Cep arama / ulak parşömeni kalıbının diğer oyuncu anlarına yayılması. Hepsi 2D UI'dir; 3D karakter, kapı yürüyüşü veya sahne animasyonu bu belgenin dışında kalır.

İlk plan: `origin/claude/festive-volta-li1sfm` @ `c71ac995` (23 Kas 2026, Europe/Istanbul). A1–A6 üretimi 23 Kas 2026'da `muharrir-anim` dalında bağlandı.

Amaç, Ahmet'in beğendiği iki mevcut örneğin (cep arama, ulak parşömeni) kalıbını başka oyuncu anlarına yaymak. Hepsi 2D UI'dir; 3D karakter, kapı yürüyüşü veya sahne animasyonu önerilmez.

---

## 1. Mevcut kalıp

| | Cep arama | Ulak parşömeni |
|---|---|---|
| Kod | `src/arayuz/kapi/cep_arama_animasyonu.gd` (`CepAramaAnimasyonu`) | `src/arayuz/koy_hud/ulak_parsomen_animasyonu.gd` (`UlakParsomenAnimasyonu`) |
| Bağlantı | `heybe_paneli.gd` açılışta otomatik oynar, bitince çizime solur | `kapi_acilis_paneli.gd` tıklanınca oynar; berat metni son karede Label olarak belirir |
| Kareler | 5 varyant × 8 kare | 1 dizi, 9 kare + ayrı `ulak_asker.png` |
| Yol | `assets/ui/kapi/cep_arama/<varyant>/kare_01.png` … `kare_08.png` | `assets/ui/ulak/parsomen/kare_01.png` … `kare_09.png` |
| Boyut | 1152×864, opak RGB, tam sahne | 1152×864, opak RGB, tam sahne |
| Süre | `KARE_SURE` 0,16 sn, `SON_TUTMA` 0,28 sn (~1,4 sn) | `KARE_SURE` 0,15 sn, `SON_TUTMA` 0,18 sn (~1,4 sn) |
| Tetik | Panel açılınca `oyna()` | Sol tık; oynarken tık yutulur |
| Yedek | Dosya yoksa `olustur()` null döner, eski heybe çizimi bozulmaz | Dosya yoksa eski düz yazı paneli kurulur |

Ortak kod kalıbı (yeni işler bunu kopyalar):

- `class_name …Animasyonu extends TextureRect`
- `signal bitti`
- `const KOK`, `kare_%02d.png`, `static func olustur()` — en az 2 kare yoksa `null`
- `oyna()` zamanlayıcıyla kare değiştirir, sonda `bitti` yollar
- Metin görsele gömülmez; runtime Label olarak son karenin üstüne solur
- `mouse_filter` ve `STRETCH_KEEP_ASPECT_CENTERED` / `COVERED` + `EXPAND_IGNORE_SIZE`
- Oyun içi gösterim boyutu kodda ayarlanır (cep 620×600 alana sığar); kaynak tuval 1152×864 kalır

Üretim yöntemi (örneklerle aynı):

- Grok Bot `GenerateImage`, kare kare, özgün 13. yüzyıl Anadolu sınır kapısı üslubu
- Aynı kamera, ışık ve nesne konumu; yalnız hareket değişir
- Opak RGB tam sahne (yeşil zeminli ikon değil)
- Yazı, rakam, damga ibaresi ve UI metni karelere işlenmez (zar yüzü hariç, aşağıda)
- Onay sonrası `assets/ui/<yer>/<ad>/kare_01.png` … diye işlenir

### Bu planın dışında tutulanlar

Üretilmiş, tekrar önerilmez:

- Cep / kese arama (5×8 kare) — heybe açılışı
- Ulak parşömeni (9 kare + asker) — ilk gece beratı

`docs/arayuz/GEMINI_EK_2D_URETIM_LISTESI.md` içindeki 10 adet 3–5 karelik, 256 px, `#00FF00` yeşil zeminli ikon dizisi ayrı bir izdir (HUD yapıştırma). Gemini ikon izindeki `zar_d6_roll_*`, `zar_d12_roll_*`, `muhur_bas_*` ve `heybe_ac_*` kareleri artık `assets/art/anim/` altında durur (256×256 RGBA). A1 ve A3 bu mevcut kareleri kullanır, yeniden üretilmez. `heybe_ac_*` cep aramanın ikon karşılığıdır, A2 değildir. A2, A4, A5 ve A6 için tam sahne (1152×864, opak RGB) dizileri üretildi. Çakışan adlar:

- `heybe_ac_*` — cep arama zaten bu işi bitirdi, üretilmesin
- `zar_d6_roll_*` / `zar_d12_roll_*` — ikon izi ilerletilebilir; asıl öneri aşağıdaki masa üstü zar sahnesidir
- `muhur_bas_*`, `kese_sikkesi_*`, `kapi_surgu_*` — ikon izi isteğe bağlı kalır; asıl öneri tam sahne dizileridir

3D oda kasa kapağı (`oda_kasasi_paneli.gd` kapak döndürmesi) ve kapıdaki gelen yürüyüşü (`sahne.gelen_git`) zaten var; bunların 2D kopyası önerilmez. Mini oyun düven/ok dizileri Gemini listesinde duruyor, bu tura alınmadı.

---

## 2. Aday tablosu (22)

Öncelik: oyuncunun bir oturumda kaç kez gördüğü + anın hissi (nesne elle tutulur mu, kararın ağırlığı var mı). Yüksek = her gece tekrar + güçlü ritüel.

| # | Ad | Tetikleyen an ve dosya | Ne gösterir | Kare | Boyut | Bağlantı | Öncelik |
|---|---|---|---|---|---|---|---|
| A1 | [x] Zar atışı | Sorgu becerisi (ikna, blöf, gözdağı, gönül alma) ve kapı kavgası zarı. `chr_diyalog_paneli.gd`, `src/kapi/sorgu_zari.gd`, `kapi_kavgasi_paneli.gd`. Şu an yalnız yazı (`ZarSonucu` Label). | Mum ışığında tahta masada kemik zarın yuvarlanıp durması; son karede gelen yüz. d6 ve d12 ayrı varyant klasörü. | 10 | 1152×864 | `CepArama` kalıbı, otomatik `oyna()`. Süre `belirme_baglantisi.zar_ms` ile kısaltılır (`aninda` ≤ 200 ms: son kareye atla). Yazı sonuç, animasyon `bitti` olunca mevcut Label olarak kalır. | Yüksek |
| A2 | [x] Rüşvet kesesi dökümü | Karar `rusvet` veya `elkoy`. `kapi_ekrani.gd` `_karar_ver` içinde `sfx_kese` çalan yer (satır 720–721). Cep arama heybe *açılışıdır*; bu, alınan akçenin dökülmesidir. | Bağlı deri kesenin çözülüp akçenin beze dökülmesi; eller saymaz, yığın belirir. | 8 | 1152×864 | Karar sonucu yazılmadan kısa overlay; `bitti` sonrası mevcut sonuç metni. Dosya yoksa yalnız ses kalır. | Yüksek |
| A3 | [x] Yalan mührü | Heybede astar yoklanınca yalan çıkar. `heybe_paneli.gd` `_muhur_bas` (şu an vektör `Muhur` + tween). | Elin mum mührü ısıtıp kâğıda / heybe kenarına basması; mühür yerinde kalır. Yazı (“Yalan yakalandı”) Label olarak son karede. | 8 | 1152×864 | `_muhur_bas` içinde vektör mühür yerine `olustur()`; yoksa eski tween durur. | Yüksek |
| A4 | [x] Kapı sürgüsü — kabul | Her `kabul` / içeride kalan karar. `kapi_ekrani._karar_ver` + `sfx_kapi_acilir`, `sahne.gelen_git(true)` öncesi. | Demir sürgünün kayması, ahşap kanadın içeri açılması (2D close-up; 3D yürüyüş ayrı durur). | 8 | 1152×864 | Sonuç evresinde kısa overlay, bitince 3D çıkış. Yoksa yalnız ses. | Yüksek |
| A5 | [x] Kapı sürgüsü — ret | Her `ret` / dışarıda kalan karar. Aynı işlev, `sfx_kapi_kapanir`, `gelen_git(false)`. | Sürgünün düşmesi, kanadın kapanması, toz / karanlık. Kabul ile aynı kamera, ters hareket. | 8 | 1152×864 | A4 ile ortak sınıf, `yon = kabul \| ret` veya iki klasör. | Yüksek |
| A6 | [x] Gece raporu / sabah defteri | Köy sabahına geçiş. `koy_ekrani._geceye_gec_rapor`, `gece_raporu_kisa.gd`, `sabah_paneli.gd`. Ayrı sabah sahnesi yok; rapor bir kart. | Kapalı deri defterin açılıp hüküm sayfasının düzülmesi. Satırlar Label olarak son karede. | 9 | 1152×864 | Parşömen kalıbı: tıkla veya otomatik aç, metin solur. Yoksa mevcut yazı kartı. | Yüksek |
| B1 | Yol tezkiresi / evrak | Gelenin kâğıt, ferman veya beratı incelenince. `esya_detay_karti.gd`, CHR obje tıklaması, `sfx_chr_kagit` (`chr_sorgu_sesi.gd`). İlk gece ulağı *değildir*. | Mühürlü yol kâğıdının açılması, iç yüzün boş kalması (metin Label). Yırtık ferman için ayrı son kare varyantı olabilir. | 8 | 1152×864 | Detay kartı açılmadan kısa dizi; `bitti` olunca mevcut açıklama. Ulak parşömeninden farklı nesne (küçük tezker, muhafız eli). | Orta |
| B2 | Hafıza defteri sayfası | Defter açılınca veya sayfa değişince. `hafiza_defteri_ekrani.gd` `kur` / `sayfa_sec`. | Açık defterde sayfanın çevrilmesi; yazı gömülmez. | 6 | 1152×864 | Açılışta bir kez; sonraki sayfalarda kısa 6 kare. Yoksa anında sayfa. | Orta |
| B3 | Köy olay kartı | Gece olayı paneli. `koy_ekrani._olay_goster`, `haberci_anlati_paneli.gd`, `sfx_olay`. | Habercinin katlanmış kâğıdı veya olay kartının açılması. İllüstrasyon varsa son karede boş alan bırakılır (Gemini olay kartları henüz üretilmedi). | 8 | 1152×864 | Kart metninden önce overlay. Yoksa mevcut kart. | Orta |
| B4 | Sancak fermanı | Orta/geç oyun ulak fermanı (asker talebi, teftiş). `sancak_asker_talebi.gd`, `sancak_ulagi.gd` — açılış beratı değil. | Resmî ferman rulosunun mühür kırılarak açılması. Metin Label. | 9 | 1152×864 | Ulak parşömen sınıfının ikinci dizisi (`assets/ui/ulak/ferman/`) veya aynı API, başka KOK. | Orta |
| B5 | Ticaret akçe sayımı | Tüccar anlaşması onaylanınca. `tuccar_alisveris_sekansi.gd`, `pazar_satis_paneli.gd`. | Bez üzerinde akçenin iki yığına ayrılması, elin çekilmesi. | 8 | 1152×864 | Onay düğmesinden sonra, bakiye yazısı güncellenmeden. | Orta |
| B6 | Kayıt mührü | Kayıt yazılınca veya yuva seçilince. `kayit_yuva_karti.gd`, `hizli_kayit.gd`. Ekran görüntüsü yok, kartta gün/nüfus yazar. | Mum mührün kayıt kâğıdına basılması (yalan mühründen daha sakin, resmi). Yazı yok. | 6 | 1152×864 | Yuvanın üstünde küçük overlay; kayıt zaten sessizce yazılıyorsa kısa tut. | Orta |
| B7 | Vicdan terazisi | Muhafız odasında terazi paneli. `oda_terazisi_paneli.gd` (şu an tırnak/bar, tepsiler yok). | Pirinç terazinin bir kefeye yatması (adil / ağır). | 8 | 1152×864 | Panel açılışında bir kez, durduğu kare bakiyeyi temsil eder (iki son kare: dengede / eğik). | Orta |
| B8 | Tansiyon çatlaması | Sorgu tansiyonu sakin → gergin veya gergin → panik. `tansiyon_gostergesi.gd` (şu an ProgressBar). | Cam fanus veya çömlek çatlar, toz kalkar; bar yerinde kalabilir. | 6 | 1152×864, küçük alana sığar | Eşik atlanırken bir kez oynar, döngü değil. `aninda` belirmede atlanır. | Orta |
| B9 | Kapı kavgası gerilimi | Kavga paneli açılınca. `kapi_kavgasi_paneli.gd` (şu an kayıt kutusunu sarsıyor, “yeni asset yok”). | Elin hançer kabzasına gitmesi veya sıra gerilimi; şiddet sahnesi değil. | 7 | 1152×864 | `_ac` sarsıntısından önce kısa dizi. Zar varsa A1 sonra gelir. | Orta |
| B10 | Harita rulosu | Harita modalı açılınca. `harita_ekrani.gd`, `harita_baglantisi.gd`. | Bez haritanın rulo açılması; yer adları ve pinler kodda, karelerde yok. | 8 | 1152×864 | Açılışta bir kez, son kare solarak mevcut haritaya geçer. | Orta |
| C1 | Ana menü kandili | Ana menü görünürken döngü. `menu_ekrani.gd` (3B gece + süs çizimi var). | Kandil alevinin ağır titreşmesi; döngü (son kare ≈ ilk). | 6 | 1152×864, küçük köşe | Sürekli döngü, tık yok. Ağır dosya: import sıkıştırması. | Düşük |
| C2 | Yükleme kandili | Kaynak yükleme katmanı. `varlik_yukleme_paneli.gd`. | Aynı kandil, ilerleme çubuğunun yanında. | 6 | 1152×864 | C1 kareleri paylaşılabilir (`assets/ui/menu/kandil/`). | Düşük |
| C3 | Cenaze örtüsü | Cenaze / yas raporu. `cenaze_raporu.gd`, gece raporundaki yas satırı. | Keten kefenin yavaşça örtülmesi; saygılı, kısa. | 8 | 1152×864 | Rapor kartı açılmadan. Seyrek. | Düşük |
| C4 | Karantina işareti | Karantina paneli veya HUD sayacı ilk kez belirince. `karantina_paneli.gd`, `karantina_hud_sayaci.gd`. | Bez işaretin kapıya / direğe asılması. | 6 | 1152×864 | Bir salgında bir kez. | Düşük |
| C5 | Perde sonu defteri | Perde geçişi özeti. `perde_ozeti.gd`, `bilgi_ekrani.gd`. | Büyük defterin kapanıp mühürlenmesi (açılışın tersi). Metin Label. | 8 | 1152×864 | Özet satırları son karede. Oyunda az görülür, merasim gibi durur. | Düşük |
| C6 | Yeni oyun beratı | Yeni oyun yuvası onaylanınca. `yeni_oyun_ekrani.gd` `_baslat`. | Boş beratın muhafıza uzatılması (ulak açılışının kısa ön-eko’su, askersiz). | 7 | 1152×864 | Yüklemeden hemen önce bir kez. Ulak 9 karesini tekrarlama. | Düşük |

Toplam: 22 aday (6 Yüksek, 10 Orta, 6 Düşük). Yükseklerin kabaca kare yükü: 10+8+8+8+8+9 = 51 kare (zarın ikinci varyantı +10).

---

## 3. Zar yüzü kuralı (A1)

Orta kareler (1–7) genel yuvarlanma, yüz okunmaz. Son 3 kare duran zarı gösterir. d6 için 6, d12 için 12 duruş varyantı gerekir (`kare_08_yuz_1.png` … veya `d6/yuz_N/kare_08.png`). Kod, `sorgu.son_zar["zar"]` değerine göre son kareleri seçer. Pips (nokta) yazı sayılmaz; d12 rakamları zarın kendi yüzüdür, sahne yazısı değil. Sonuç cümlesi (“başarılı / kaldı”) yine Label’dır.

`aninda` belirme hızında dizi atlanır, yalnız doğru yüzün duran karesi gösterilir.

---

## 4. Önerilen üretim sırası

1. A1 zar (önce d6, sonra d12) — her sorguda görünür, şu an hiç görseli yok
2. A2 rüşvet kesesi — beğenilen kese dilinin ikinci cümlesi
3. A3 yalan mührü — mevcut tween’in yerine geçer, heybe ritüelini tamamlar
4. A4 + A5 sürgü — aynı sahneden bir çift; kabul/ret her ziyaretin noktalama işaretidir
5. A6 sabah defteri — her gün bir kez, gün ritüeli
6. B1 evrak, B3 olay, B4 ferman — kâğıt ailesi, parşömen kalıbı tekrar kullanılır
7. Kalan Orta, sonra Düşük

Her dizi için kod, cep/parşömen örneği gibi dosya yoksa eski davranışı bozmadan bağlanır. Kontak sayfası ve GIF klon dışında tutulur (`/workspace/gemini_onizleme/`), repoya girmez.

---

## 5. Kısa gerekçe

Oyuncu gece boyunca aynı nesneleri eliyle işler: zar, kese, mühür, sürgü, kâğıt, defter. Beğenilen iki örnek de tam da bu türdendir. Bar, ikon ve 3B yürüyüş zaten var; eksiği, karar anını tutan 2D close-up. Düşük öncelikler süs veya seyrek merasimdir; limit daralırsa C1–C6 bırakılır, A grubu yeter.

---

## 6. A1–A6 üretim durumu (23 Kas 2026)

Ortak kabuk: `src/arayuz/kare_animasyon_kabuk.gd` (`KareAnimasyonKabuk`). `olustur()` en az 2 kare yoksa `null` döner; `oynat_uzerinde` ebeveyn veya düğüm yoksa hemen çıkar. Küçük ikonlar (genişlik ≤ 512) karartılmış perdede ortalanmış 480×480 kutuda oynar.

- [x] **A1 Zar atışı (v2, kodla hareket)** — BG3 tarzı fırlatma, havada dönüş (rotation + ölçek), 2–3 azalan sekişme, sönümlenen sallanma, yüksekliğe göre gölge, çarpışta sarsıntı, sonuç yüzünde parlama. Fırlatma yönü/hızı her atışta rastgele; sonuç `son_zar` / kavga zarından kilitlenir. Temiz yüzler: `assets/ui/kapi/zar_yuz/zar_d6_yuz_1–6.png`, `zar_d12_yuz_1–12.png` (mevcut boyalı gövde + pips/numara). Kod: `src/arayuz/kapi/zar_atisi_animasyonu.gd`. Kanca aynı; `oynat(..., sonuc)`. `aninda` belirmede yalnız sonuç yüzü.
- [x] **A2 Rüşvet kesesi** — 8 kare, 1152×864 opak RGB, `assets/ui/kapi/rusvet_kesesi/kare_01.png`–`08.png`. Kod: `src/arayuz/kapi/rusvet_kesesi_animasyonu.gd`. Kanca: `kapi_ekrani.gd` `_karar_ver` içinde `sfx_kese` sonrası (`rusvet` / `elkoy`).
- [x] **A3 Yalan mührü** — mevcut `assets/art/anim/muhur_bas_01.png`–`04.png` (4 kare, 256×256 RGBA). Kod: `src/arayuz/kapi/yalan_muhur_animasyonu.gd`. Kanca: `heybe_paneli.gd` `_muhur_bas` içinde, kalıcı vektör `Muhur` tween'inden hemen önce. Planlanan 8 karelik tam sahne yerine mevcut ikon seti kullanıldı.
- [x] **A4 Kapı sürgüsü — kabul** — 8 kare, 1152×864 opak RGB, `assets/ui/kapi/surgu/kabul/kare_01.png`–`08.png`.
- [x] **A5 Kapı sürgüsü — ret** — 8 kare, 1152×864 opak RGB, `assets/ui/kapi/surgu/ret/kare_01.png`–`08.png`. A4+A5 ortak sınıf: `src/arayuz/kapi/kapi_surgu_animasyonu.gd`. Kanca: `kapi_ekrani.gd` `_karar_ver` içinde `sfx_kapi_acilir` / `sfx_kapi_kapanir` sonrası, `oynat(self, bool(sonuc["kaldi"]))`.
- [x] **A6 Sabah defteri (v2)** — Kapak sol menteşeden kitap gibi açılır (destek kareleri: `kapali.png`, `kapak_yarim.png`, `kapak_sola.png`, `acik.png`), ardından 1–2 sayfa kodla kıvrılarak çevrilir; gecenin kaydı sağ sayfada Label olarak belirir, görsele gömülmez. Eski 9 karelik “kutu açılır” dizisi kaldırıldı. Kod: `src/arayuz/koy_hud/sabah_defteri_animasyonu.gd`. Kanca: `koy_ekrani.gd` `_geceye_gec_rapor`.

Lisans notu: `docs/arayuz/ANIMASYON_A1_A6_LISANS.md`. Birim testleri: `tests/unit/arayuz/*_animasyonu_test.gd`. Önizleme GIF'leri klon dışındadır (`/workspace/anim_onizleme/`), repoya girmez.

### Bilinen kusurlar ve yeniden üretim

- A1 (eski kare dizisi, **yeniden üretim / v2 ile aşıldı**): `assets/art/anim/zar_d6_roll_01.png` neredeyse boş fildişi küp, pips yok; 02–04 ve d12 karelerinde de yüz işaretleri yoktu, dizi BG3 tarzı fırlatmayı vermiyordu. Eski `zar_*_roll_*` dosyaları durur ama A1 artık kullanmaz. v2: kodla hareket + temiz `zar_d6_yuz_*` / `zar_d12_yuz_*`.
- A2: bazı akçelerde zayıf darphane izi gibi işaretler; orta karelerde hafif kamera açısı kayması.
- A4 (**yeniden üretim adayı**): 01'den sonra üslup biraz daha grafik; 05'te sürgü gövdesinde çentik artifaktı; 06 bir an neredeyse kapalı duruyor, 07–08 yeniden aralanır. v2 turunda el sürülmedi.
- A5 (**yeniden üretim adayı**): 03'te gece yarığı kapanmak yerine biraz genişler; 05–07 sürgü konumu birbirine yakın (kilit hareketi sıkışık). v2 turunda el sürülmedi.
- A6 (eski kare dizisi, **yeniden üretim / v2 ile aşıldı**): 9 karelik dizi kapağı kutu kapağı gibi yukarı kaldırıyor, yan menteşeli kitap açılışı okunmuyordu; ilk 08 denemesinde defter kaybolmuştu. v2: dört menteşe destek karesi + kodla sayfa kıvrımı, eski `kare_01–09` kaldırıldı.

