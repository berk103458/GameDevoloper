# Kapı Muhafızı — Asset paketi araştırması, 2. tur (Kalfa)

23 Ekim 2026 · Temel sürüm: festive `e98dd7d`. Yalnız araştırma ve belge; asset indirme, satın alma, üretim veya entegrasyon yapılmadı. Oyun kodu, ROADMAP ve aktif envanter durumları korunur.

## Karar için en önemli sonuç

Hazır paketler çevre, genel hareket, alet ve doğal ses katmanlarını destekliyor; özgün CHR ipuçları, adlandırılmış portreler ve gece kapısı arayüzünün tamamını teslim etmiyor. En büyük kazanç birbiriyle örtüşen üç köy paketi almakta değil, **bir çevre ailesi + ortak hareketler + eksik el aletleri + seçilmiş sesler** kurmakta. İndirilebilir olmak, rigli olmak, animasyon içermek ve açık lisanslı olmak ayrı koşullardır.

İlk beş araştırma önceliğim: **KayKit Character Animations (A03)**, **MoCap Central Village Life (ANM15)**, **Avramania Village Builder Premium (CEV07)**, **GameOver Medieval Stylized 3D Props (ESY16)** ve **Leohpaz Ambiences Perspectives (ORT01)**. Bunların tamamı açık lisanslı değildir; K olanlar karşılaştırma/olası tedarik önerisidir. Paketleri oyunla aynı ışık altında denemeden görsel uyum kesinleşmez. Ücretli kaynaklar için alım yapılmadı.

## Önce ihtiyaç ana listesi

[534 kayıtlık numaralı ana liste](asset_envanteri/IHTIYAC_ANA_LISTESI.md), bu raporun tek ölçütüdür. Türler: **99 model grubu, 334 2D teslim yuvası, 37 animasyon, 43 ses, 13 müzik, 8 VFX**. Numaralı ID’ler `İHT-0001…İHT-0534`; kaynak kimlikleri ve hedef dosyalar tabloda bulunur. Kaynaklar aktif envanter, açık 3D görünümü, ikinci prompt paketi, 12 Ekim taraması, 30 CHR metni/runtime kaynağı ve ROADMAP’in asset satırlarıdır.

Bu bir **teslim gereksinimi** sayımıdır: bir grup birkaç model/klip içerebilir; aynı çizim farklı hedef dosyalarda yeniden kullanılabilir. Tam dosya yolu ve açık kaynak alias’ları birleştirildi, farklı ekran ölçülerine ait teslimler korunur. 30 karaktere aynı duygu hareketini 30 kere sayarak kapsam büyütülmedi. Ortak hareket kaynağı ile 44 karakterin retarget/kabul işi ayrıdır. KAPI/KAR çocuk, mezar, kule ve oda/hayvan şemsiye satırları alt teslimlere yönlendirildi.

P0/P1/P2 ilk saat önceliği kaynak akışından çıkarımdır; oynanmış bir saatlik telemetri değildir. Hazır 27 UI PNG’si ve mevcut fontlar da karşılaştırma tabanında yer alır; **534, bugün eksik dosya sayısı değildir**. Oyun deposunun bütün dosyalarının katalog sayımı olduğu da iddia edilmez.

## Hesabın anlamı ve sınırı

- **Tam (t):** yayımlanan içerik, gereksinimin bütün tanımlı bileşenlerine karşılık veriyor; motor kabul testi yapılmış anlamına gelmez.
- **Kısmi (k):** bazı alt parçalar var, diğerleri eksik veya teyitsiz. Bir çekiç, kova+orak+balta+çekiç+fırın küreği grubunu kapatmaz. Kısmi satır kapsam temasına girer, tamamlanmış teslim sayısına girmez.
- **Uyarlamayla (u):** kaynak karşılık var; belirtilen retarget, malzeme, biçim, ölçek veya tema işi gerekiyor. Sadece yeniden adlandırarak tarihî rol yaratılmış sayılmaz.
- Birleşik setlerde aynı ID yalnız bir kez sayılır; tam > uyarlama > kısmi seçilir. Paket sayılarının toplamı birleşik kapsam değildir. Bir ürün iki kategoriyi beslese bile bir kez satın alınır. Bağımsız ürünün bütün modelleri ile ücretsiz alt kümesi karıştırılmaz.
- Uyum puanı ve az/orta/çok iş sınıfı Kalfa’nın tasarım değerlendirmesidir. Az: seçim, ses seviyesi, basit boyut/malzeme; orta: retarget/atlas/9-slice veya modüler kurulum; çok: yeni kıyafet, ciddi siluet değişimi, motor VFX’sini yeniden kurma, LOD/temas işi.
- **Kullanılabilir yüzde:** dosya/öğe listesi eksikse payda veya seçilebilir altküme uydurulmadı. “Hesaplanamadı” yazıldı. Tam listesi olan örneklerde açık kesir verildi; bir ürünün bütün arşivini indirip denemeden her satıra sahte %80 yazmak derin analiz olmaz. Bu turda sayfa açıklaması, yayımlanmış dosya/klip listesi ve metinle sunulan önizleme bilgisi okundu; video dinleme, dönen 3D model denemesi, arşiv açma ve Godot import testi yapılmadı.
- Fiyat `?`: ödeme sayfası/katman görünmedi. Sıfır değildir. Fiyatlar görülen USD tutarıdır; EUR ayrıca belirtilir. Kampanya, vergi, bölge ve koltuk bedeli değişebilir. Set B kalite öncelikli kısa listedir; satın almaya hazır olduğu anlamına gelmez.

## Lisans bulguları: ilk rapora düzeltme

**A:** CC0/CC-BY. **K:** ücretsiz veya ücretli özel ticari lisans. **O:** yeni OFL font alternatifi; **M:** zaten depodaki OFL font. **S:** CC-BY-SA, mevcut A kuralıyla aynı değil. **X:** ticari olmayan/uygunsuz. **Ç:** yayıncının beyanları çelişkili. **?:** izin doğrulanamadı. Ücretsiz fiyat hiçbir zaman A lisans kanıtı değildir.

Quaternius ürün sayfaları CC0 yazmaya devam ediyor; [genel lisans sayfası](https://quaternius.com/license.html) ise **28 Ağustos 2026 tarihli QAL v1.0** ve ham assetlerin yeniden dağıtım yasağını gösteriyor. Önceden edinilen dosyalar için geriye yürümez maddesi var. Dolayısıyla bu rapor eski CC0 edinimini geçersiz ilan etmiyor; **yeni tedarikte paket/sürüm lisansı kanıtlanmadan koşulsuz A saymıyor**. İlk rapordaki genel açık lisans önerisi bu nedenle şartlıdır. Quaternius dışı Poly Pizza aynasında da dosyanın hangi lisansla edinildiği saklanmalı.

[MoCap Central EULA](https://mocapcentral.com/pages/licensing) 21 Ekim 2026 güncellemesinde ticari kullanım, üç teknik/yaratıcı ekip üyesi ve ek ekip lisansı; ham dağıtım ve AI eğitimi sınırlamaları içeriyor. Retarget veya tek seferlik ekran incelemesi ile eğitim ayrı düzenlenmiş. [JDSherbert şartları](https://jdsherbert.itch.io/terms-and-conditions) atıf istiyor ve ham dosyaları public/open-source repoda paylaşmayı açıkça yasaklıyor. K paket için bitmiş oyun kullanımı, herkese açık ham GitHub yüklemesi izni diye yorumlanamaz.

[Godot’un resmî biçim rehberi](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) glTF/GLB’yi öneriyor; FBX ufbx ile içeri alınabiliyor. OBJ iskelet/animasyon sağlamaz. Blend yolu kurulu Blender gerektirir. Unity prefab/shader veya Unreal Niagara dosyası Godot sahnesi değildir; model/doku ihracı ve yeniden kurulum ayrıca değerlendirilir.


## Sayım ve kapsam sonucu

İncelenen yeni aday: **191**; ilk turdan yeniden değerlendirilen **51 farklı kaynak / 52 eski kategori kaydı** (E10=C06 aynı ürün). Toplam **242 farklı ürün/koleksiyon/kaynak**. Font ailesi, tekil doku, tekil model ve hesap içi katalog aşağıda ayrıca tanımlıdır; hepsi çok öğeli paket değildir.

| Yeni aday kategorisi | Açılan aday |
|---|---:|
| Çevre | 15 |
| Karakter | 15 |
| Animasyon | 18 |
| Hayvan | 16 |
| Eşya | 17 |
| UI | 20 |
| VFX | 15 |
| Ortam sesi | 15 |
| Foley | 15 |
| UI sesi | 15 |
| Müzik | 15 |
| Mırıltı | 15 |

| Ölçüt | Sayı / oran |
|---|---:|
| İhtiyaç ana listesi | 534 |
| Önerilen karma seçki: potansiyel temas | 116 / 534 = %21.7 |
| Bunun tam / kısmi / uyarlama ayrımı | 116 (2 tam / 53 kısmi / 61 uyarlamayla) |
| Kısmi hariç, tam veya uyarlama sonrası kapanmaya aday | 63 / %11.8 |
| Seçkide yalnız A + mevcut OFL fontları: temas | 62 / %11.6 |
| Bütün adayların birleşik temas üst sınırı | 186 / %34.8 |
| Önerilen seçkide tamamen açık | 418 |
| İncelenen hiçbir adayla eşleşmeyen | 348 |
| Bu araştırmada indirilen / entegre edilen / fiilen kapatılan | 0 / 0 / 0 |

Karma seçki fiyatı: **243.89 USD + 2.49 GBP**. Bu bir kesin satın alma toplamı değildir: fiyatı/lisansı belirsiz ürünler açıkça bırakılmıştır. Vergi, lisans koltuğu ve bağımsız yüklenici ek bedelleri dahil değildir. Kamuya açık ham repo dağıtım izni K sınıfında varsayılmaz.

| Tür | Toplam | Önerilen temas | Tam | Kısmi | Uyarlama | Temas oranı |
|---|---:|---:|---:|---:|---:|---:|
| 3D model | 99 | 39 | 0 | 14 | 25 | %39.4 |
| 2D | 334 | 15 | 0 | 7 | 8 | %4.5 |
| animasyon | 37 | 17 | 0 | 8 | 9 | %45.9 |
| ses | 43 | 31 | 2 | 16 | 13 | %72.1 |
| müzik | 13 | 7 | 0 | 7 | 0 | %53.8 |
| VFX | 8 | 7 | 0 | 1 | 6 | %87.5 |

## Kategori sıralamaları ve alternatifler

Sıra: temas edilen benzersiz ihtiyaç sayısı azalan; eşitlikte uyarlama işi az→orta→çok, sonra uyum puanı. Sıfır temaslı veya lisansı elenen adaylar, yapılan taramanın nedenleri görülebilsin diye listenin sonunda tutuldu. Bunlar tedarik önerisi değildir.


### Çevre

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [CEV04](#cev04) — Medieval Village/Town Interior/Exterior MEGA Pack! | 16: 0/3/13 | 8/10 | orta | K ticari; ürün lisansı ayrıca | 66 |
| 2 · [CEV07](#cev07) — Village Builder - Low Poly 3D Asset Pack | 11: 0/1/10 | 8/10 | orta | K Premium; Free CC0 | 9.99 |
| 3 · [CEV03](#cev03) — KayKit - Medieval Hexagon Pack | 9: 0/1/8 | 6/10 | çok | A CC0 | 0 |
| 4 · [CEV02](#cev02) — KayKit - Dungeon Pack | 5: 0/3/2 | 7/10 | orta | A CC0 | 0 |
| 5 · [CEV08](#cev08) — Low Poly Medieval Village | 5: 0/2/3 | 7/10 | orta | K JustCreate | 9.99 |
| 6 · [CEV09](#cev09) — Stylized Medieval Village | 4: 0/1/3 | 7/10 | orta | K JustCreate | 59.99 |
| 7 · [CEV06](#cev06) — LOKIT: Low Poly Medieval Village - 200+ Modular Asset Kit | 3: 0/2/1 | 7/10 | orta | A CC0 | 0 |
| 8 · [CEV05](#cev05) — Medieval Village Megapack - Low Poly Refreshed - URP | 3: 0/3/0 | 6/10 | çok | ? Lisans metni görünmedi | 32.20 |
| 9 · [CEV11](#cev11) — Ultimate Modular Ruins Pack | 3: 0/3/0 | 5/10 | çok | Ç CC0/QAL | 0 |
| 10 · [CEV01](#cev01) — KayKit - Forest Nature Pack | 2: 0/1/1 | 8/10 | az | A CC0 | 0 |
| 11 · [CEV12](#cev12) — Nature Kit | 2: 0/2/0 | 7/10 | orta | A CC0 | 0 |
| 12 · [CEV15](#cev15) — Roadside Tales  Fences and Wall Bundle Pack 1-3 LODS | 2: 0/2/0 | 7/10 | orta | ? Ürün lisansı açık değil | 0 |
| 13 · [CEV10](#cev10) — Farm Buildings Pack | 2: 0/2/0 | 6/10 | orta | Ç CC0/QAL | 0 |
| 14 · [CEV14](#cev14) — Modular Cave Kit | 2: 0/2/0 | 5/10 | çok | A CC0 | 0 |
| 15 · [CEV13](#cev13) — Graveyard Kit | 0: 0/0/0 | 2/10 | çok | A CC0 | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [CEV01](#cev01), [CEV02](#cev02), [E04](#e04) | 10 (0 tam / 7 kısmi / 3 uyarlamayla) | 0.00 USD | 21 kategori-aday açığı: İHT-0358, İHT-0359, İHT-0360, İHT-0361, İHT-0363, İHT-0364, İHT-0365, İHT-0366, İHT-0367, İHT-0369, İHT-0370, İHT-0372, İHT-0373, İHT-0375, İHT-0377, İHT-0388, İHT-0397, İHT-0420, İHT-0421, İHT-0425, İHT-0427 |
| B: [CEV04](#cev04), [CEV15](#cev15) | 16 (0 tam / 3 kısmi / 13 uyarlamayla) | 66.00 USD | 15 kategori-aday açığı: İHT-0339, İHT-0347, İHT-0358, İHT-0360, İHT-0363, İHT-0364, İHT-0366, İHT-0367, İHT-0369, İHT-0373, İHT-0375, İHT-0376, İHT-0388, İHT-0411, İHT-0421 |
| C: [CEV07](#cev07), [CEV01](#cev01) | 13 (0 tam / 2 kısmi / 11 uyarlamayla) | 9.99 USD | 18 kategori-aday açığı: İHT-0339, İHT-0347, İHT-0358, İHT-0359, İHT-0360, İHT-0361, İHT-0363, İHT-0367, İHT-0373, İHT-0375, İHT-0378, İHT-0388, İHT-0410, İHT-0411, İHT-0414, İHT-0420, İHT-0421, İHT-0427 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Karakter

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [KAR01](#kar01) — Medieval Characters Pack — Low-Poly Rigged Medieval Cast | 7: 0/2/5 | 7/10 | orta | ? Lisans yayımlanmamış | 5 |
| 2 · [KAR02](#kar02) — LOWPO: Villagers NPC – Low Poly Medieval Character Pack | 4: 0/2/2 | 8/10 | orta | K Unity Standard; koltuk türü koşullu | 9.99 |
| 3 · [KAR03](#kar03) — Medieval Village NPC Pack / 6 Rigged Low-Poly Characters / Animated | 4: 0/2/2 | 7/10 | orta | ? Fab lisans seçimi boş | ? |
| 4 · [KAR04](#kar04) — Slavic Medieval Villagers — Modular Low Poly Characters | 3: 0/2/1 | 7/10 | çok | K Unity Standard | 7 |
| 5 · [KAR06](#kar06) — Medieval Pack - Characters | 3: 0/3/0 | 6/10 | çok | K katmana bağlı; doğrulama gerekli | 200 |
| 6 · [KAR13](#kar13) — 3D Medieval Soldier Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 2: 0/0/2 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 7 · [KAR05](#kar05) — LOWPO: Low Poly Medieval Female Characters Pack | 1: 0/0/1 | 7/10 | orta | A CC0 | 0 |
| 8 · [KAR07](#kar07) — 3D Medieval Fantasy Imperial Messenger Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 1: 0/0/1 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 9 · [KAR08](#kar08) — 3D Medieval Diplomat of the Kingdom Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 1: 0/0/1 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 10 · [KAR09](#kar09) — 3D Medieval Royal Tax Collector Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 1: 0/0/1 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 11 · [KAR10](#kar10) — 3D Medieval Wise Old man Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 1: 0/0/1 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 12 · [KAR11](#kar11) — 3D Medieval Blacksmith Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 1: 0/1/0 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 13 · [KAR15](#kar15) — 3D Medieval Fantasy Female Innkeeper Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 1: 0/0/1 | 5/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 14 · [KAR14](#kar14) — 3D Medieval Farmer Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 0: 0/0/0 | 4/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |
| 15 · [KAR12](#kar12) — 3D Medieval Priest Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations | 0: 0/0/0 | 2/10 | çok | K ticari; ham paylaşım yasak | EUR2.99 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [KAR05](#kar05) | 1 (0 tam / 0 kısmi / 1 uyarlamayla) | 0.00 USD | 16 kategori-aday açığı: İHT-0351, İHT-0352, İHT-0353, İHT-0355, İHT-0356, İHT-0357, İHT-0358, İHT-0379, İHT-0390, İHT-0426, İHT-0428, İHT-0431, İHT-0444, İHT-0450, İHT-0455, İHT-0456 |
| B: [KAR02](#kar02), [KAR03](#kar03), [KAR10](#kar10) | 6 (0 tam / 2 kısmi / 4 uyarlamayla) | 9.99 USD + 2.99 EUR + fiyatı doğrulanamayan KAR03 | 11 kategori-aday açığı: İHT-0351, İHT-0352, İHT-0353, İHT-0355, İHT-0356, İHT-0358, İHT-0379, İHT-0444, İHT-0450, İHT-0455, İHT-0456 |
| C: [KAR02](#kar02), [KAR05](#kar05) | 5 (0 tam / 2 kısmi / 3 uyarlamayla) | 9.99 USD | 12 kategori-aday açığı: İHT-0351, İHT-0352, İHT-0353, İHT-0355, İHT-0356, İHT-0358, İHT-0379, İHT-0426, İHT-0444, İHT-0450, İHT-0455, İHT-0456 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Animasyon

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [ANM15](#anm15) — Animation Pack - Village Life | 7: 0/5/2 | 10/10 | orta | K MoCap Central | 79.99 |
| 2 · [ANM02](#anm02) — Animation Pack - Core Motion | 7: 0/2/5 | 9/10 | orta | K MoCap Central | 49.99 |
| 3 · [ANM08](#anm08) — Animation Pack - Greet & Talk | 5: 0/3/2 | 9/10 | orta | K MoCap Central | 64.99 |
| 4 · [ANM03](#anm03) — Animation Pack - Danger | 4: 0/3/1 | 8/10 | orta | K MoCap Central | 79.99 |
| 5 · [ANM05](#anm05) — Animation Pack - Dungeon Life | 4: 0/2/2 | 7/10 | orta | K MoCap Central | 134.99 |
| 6 · [ANM10](#anm10) — Animation Pack - Longsword Vol.1 | 4: 0/2/2 | 6/10 | çok | K MoCap Central | 89.99 |
| 7 · [ANM09](#anm09) — Animation Pack - Idles | 3: 0/1/2 | 9/10 | orta | K MoCap Central | 54.99 |
| 8 · [ANM06](#anm06) — Animation Pack - Fix & Build | 3: 0/2/1 | 8/10 | orta | K MoCap Central | 44.99 |
| 9 · [ANM13](#anm13) — Animation Pack - Sample / FREE | 3: 0/1/2 | 7/10 | orta | K MoCap Central | 0 |
| 10 · [ANM11](#anm11) — Animation Pack - Longsword Vol.2 | 3: 0/2/1 | 5/10 | çok | K MoCap Central | 139.99 |
| 11 · [ANM01](#anm01) — Animation Pack - Blacksmith | 2: 0/1/1 | 9/10 | orta | K MoCap Central | 39.99 |
| 12 · [ANM17](#anm17) — Kaynak | 2: 0/2/0 | 7/10 | orta | K Reallusion Standard | 99 |
| 13 · [ANM16](#anm16) — Carnegie Mellon University - CMU Graphics Lab - motion capture library | 2: 0/2/0 | 6/10 | çok | K CMU özel ücretsiz izin | 0 |
| 14 · [ANM14](#anm14) — Animation Pack - Seated | 1: 0/0/1 | 7/10 | orta | K MoCap Central | 74.99 |
| 15 · [ANM18](#anm18) — Getting Started: Rokoko Studio Motion Library – Rokoko | 0: 0/0/0 | 6/10 | orta | K Rokoko; klip lisansı ayrıca | ? |
| 16 · [ANM04](#anm04) — Animation Pack - Doors | 0: 0/0/0 | 5/10 | orta | K MoCap Central | 49.99 |
| 17 · [ANM12](#anm12) — Animation Pack - Play Lute | 0: 0/0/0 | 5/10 | orta | K MoCap Central | 24.99 |
| 18 · [ANM07](#anm07) — Animation Pack - Grab Loot | 0: 0/0/0 | 4/10 | orta | K MoCap Central | 49.99 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [A03](#a03) | 9 (0 tam / 3 kısmi / 6 uyarlamayla) | 0.00 USD | 18 kategori-aday açığı: İHT-0387, İHT-0408, İHT-0429, İHT-0445, İHT-0446, İHT-0447, İHT-0448, İHT-0449, İHT-0451, İHT-0452, İHT-0454, İHT-0459, İHT-0460, İHT-0461, İHT-0525, İHT-0531, İHT-0532, İHT-0533 |
| B: [ANM02](#anm02), [ANM08](#anm08), [ANM09](#anm09), [ANM15](#anm15), [ANM01](#anm01) | 16 (0 tam / 7 kısmi / 9 uyarlamayla) | 289.95 USD | 11 kategori-aday açığı: İHT-0387, İHT-0399, İHT-0408, İHT-0429, İHT-0448, İHT-0451, İHT-0454, İHT-0455, İHT-0456, İHT-0460, İHT-0461 |
| C: [A03](#a03), [ANM15](#anm15), [ANM09](#anm09) | 17 (0 tam / 8 kısmi / 9 uyarlamayla) | 134.98 USD | 10 kategori-aday açığı: İHT-0387, İHT-0408, İHT-0429, İHT-0446, İHT-0447, İHT-0448, İHT-0451, İHT-0454, İHT-0460, İHT-0461 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Hayvan

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [HYV11](#hyv11) — SI - Animated Farm Animals Pack | 8: 0/3/5 | 8/10 | orta | ? Ticari lisans metni yok | 70 |
| 2 · [HYV12](#hyv12) — Animated Cube Animals - 30 Low Poly Foxes, Wolves, Farm Animals & Big Cats | 7: 0/1/6 | 5/10 | çok | K royalty-free | 29.99 |
| 3 · [HYV13](#hyv13) — Low Poly Farm Animal Pack — 12 Cows, Pigs, Chickens & Livestock | 4: 0/4/0 | 6/10 | orta | K royalty-free | 2.99 |
| 4 · [HYV06](#hyv06) — PSX Animals: Horses | 3: 0/1/2 | 6/10 | orta | K MCSteeg | 2.50 |
| 5 · [HYV05](#hyv05) — Amir - Low-Poly Horses Pack | 2: 0/0/2 | 8/10 | az | K ücretsiz ticari izin | 0 |
| 6 · [HYV02](#hyv02) — Animals Asset Pack | 2: 0/0/2 | 7/10 | orta | A CC0 | 0 |
| 7 · [HYV03](#hyv03) — Farm animals set | 2: 0/2/0 | 6/10 | orta | A CC0 | 0 |
| 8 · [HYV14](#hyv14) — Low World - Forest Animals Kit - Rigged & Animated | 1: 0/0/1 | 8/10 | az | ? Lisans teyidi gerekli | 9.99 |
| 9 · [HYV16](#hyv16) — Dylan — Low Poly Camel | 1: 0/1/0 | 8/10 | orta | A CC-BY; sürüm teyidi gerekli | 0 |
| 10 · [HYV04](#hyv04) — Free Wild Animal 3D Models | 1: 0/1/0 | 6/10 | orta | K Craftpix; koşullu | 0 |
| 11 · [HYV15](#hyv15) — Low Poly PSX Forest Animals v1.2 update! | 1: 0/1/0 | 5/10 | orta | ? Lisans metni yok | 3 |
| 12 · [HYV08](#hyv08) — Gobkit Free Animal Pack Vol.1 — Rigged Low-Poly Creatures (CC0) | 1: 0/1/0 | 2/10 | çok | A CC0 | 0 |
| 13 · [HYV01](#hyv01) — LowPoly Animated Animals | 0: 0/0/0 | 4/10 | orta | Ç CC0/QAL | 0 |
| 14 · [HYV10](#hyv10) — PSX Animals: Farm Pack | 0: 0/0/0 | 4/10 | orta | K MCSteeg | 2.50 |
| 15 · [HYV07](#hyv07) — Animated Low Poly Animals | 0: 0/0/0 | 3/10 | orta | ? Ürün lisansı görünmedi | 2 |
| 16 · [HYV09](#hyv09) — Low Poly Animals | 0: 0/0/0 | 3/10 | çok | A CC0 | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [HYV02](#hyv02), [HYV03](#hyv03), [HYV16](#hyv16) | 4 (0 tam / 2 kısmi / 2 uyarlamayla) | 0.00 USD | 8 kategori-aday açığı: İHT-0379, İHT-0381, İHT-0389, İHT-0402, İHT-0404, İHT-0405, İHT-0409, İHT-0529 |
| B: [HYV11](#hyv11), [HYV14](#hyv14), [HYV16](#hyv16) | 10 (0 tam / 4 kısmi / 6 uyarlamayla) | 79.99 USD | 2 kategori-aday açığı: İHT-0383, İHT-0529 |
| C: [HYV05](#hyv05), [HYV03](#hyv03), [HYV14](#hyv14), [HYV16](#hyv16) | 6 (0 tam / 3 kısmi / 3 uyarlamayla) | 9.99 USD | 6 kategori-aday açığı: İHT-0381, İHT-0383, İHT-0389, İHT-0402, İHT-0405, İHT-0529 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Eşya

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [ESY16](#esy16) — Sorry, you have been blocked | 17: 0/8/9 | 9/10 | orta | K GDM Pro | 20 |
| 2 · [ESY01](#esy01) — KayKit : RPG Tools Bits | 6: 0/4/2 | 8/10 | az | A CC0 | 0 |
| 3 · [ESY04](#esy04) — KayKit : Fantasy Weapons Bits | 4: 0/1/3 | 7/10 | orta | A CC0 | 0 |
| 4 · [ESY02](#esy02) — KayKit : Furniture Bits | 4: 0/4/0 | 5/10 | orta | A CC0 | 0 |
| 5 · [ESY07](#esy07) — Ultimate Furniture Pack | 3: 0/0/3 | 6/10 | orta | Ç CC0/QAL | 0 |
| 6 · [ESY08](#esy08) — Furniture Pack | 3: 0/0/3 | 5/10 | orta | Ç CC0/QAL | 0 |
| 7 · [ESY17](#esy17) — Medieval Props Pack | 3: 0/3/0 | 7/10 | çok | ? Fab lisans seçimi boş | ? |
| 8 · [ESY14](#esy14) — Ultimate House Interior Pack | 3: 0/3/0 | 3/10 | çok | Ç CC0/QAL | 0 |
| 9 · [ESY03](#esy03) — KayKit : Resource Bits | 2: 0/1/1 | 7/10 | az | A CC0 | 0 |
| 10 · [ESY09](#esy09) — Modular Weapons Pack | 2: 0/1/1 | 6/10 | orta | Ç CC0/QAL | 0 |
| 11 · [ESY15](#esy15) — Lowpoly PBR Stone Well | 1: 0/0/1 | 8/10 | az | ? Lisans yok | 0 |
| 12 · [ESY13](#esy13) — Ultimate Crops Pack | 1: 0/1/0 | 7/10 | orta | Ç CC0/QAL | 0 |
| 13 · [ESY06](#esy06) — KayKit : Board Game Bits | 1: 0/1/0 | 3/10 | çok | A CC0 | 0 |
| 14 · [ESY12](#esy12) — Ultimate Food Pack | 0: 0/0/0 | 4/10 | orta | Ç CC0/QAL | 0 |
| 15 · [ESY05](#esy05) — KayKit : Restaurant Bits | 0: 0/0/0 | 3/10 | çok | A CC0 | 0 |
| 16 · [ESY10](#esy10) — Ultimate RPG Pack | 0: 0/0/0 | 3/10 | çok | Ç CC0/QAL | 0 |
| 17 · [ESY11](#esy11) — RPG Essentials Pack | 0: 0/0/0 | 3/10 | çok | Ç CC0/QAL | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [ESY01](#esy01), [ESY03](#esy03), [ESY04](#esy04) | 12 (0 tam / 6 kısmi / 6 uyarlamayla) | 0.00 USD | 16 kategori-aday açığı: İHT-0340, İHT-0347, İHT-0359, İHT-0408, İHT-0410, İHT-0412, İHT-0413, İHT-0414, İHT-0415, İHT-0418, İHT-0420, İHT-0421, İHT-0424, İHT-0425, İHT-0479, İHT-0485 |
| B: [ESY16](#esy16) | 17 (0 tam / 8 kısmi / 9 uyarlamayla) | 20.00 USD | 11 kategori-aday açığı: İHT-0348, İHT-0359, İHT-0387, İHT-0406, İHT-0407, İHT-0412, İHT-0413, İHT-0418, İHT-0420, İHT-0430, İHT-0439 |
| C: [ESY16](#esy16), [ESY01](#esy01) | 18 (0 tam / 9 kısmi / 9 uyarlamayla) | 20.00 USD | 10 kategori-aday açığı: İHT-0348, İHT-0359, İHT-0387, İHT-0406, İHT-0407, İHT-0412, İHT-0413, İHT-0418, İHT-0420, İHT-0439 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### UI

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [UI14](#ui14) — Pixel Adventure Book UI: Fantasy RPG Kit | 14: 0/12/2 | 6/10 | çok | K ticari; ham paylaşım yasak | 9.99 |
| 2 · [UI06](#ui06) — Dark Ages UI - Pixel Art Asset Pack | 12: 0/9/3 | 6/10 | çok | K Hypnobius | 0 |
| 3 · [UI10](#ui10) — Assets: UI RPG Game Interface [Lite Version] | 6: 0/4/2 | 7/10 | orta | A CC0 | 4.35 |
| 4 · [UI13](#ui13) — Free Fantasy Game GUI | 6: 0/5/1 | 6/10 | orta | K yazar ticari izni; koşullu | 0 |
| 5 · [UI11](#ui11) — Fantasy Game UI + icon collection | 6: 0/5/1 | 6/10 | çok | K SunGraphica atfı | 0 |
| 6 · [UI07](#ui07) — 6000 Fantasy Icons | 5: 0/2/3 | 8/10 | orta | K ticari; AI eğitimi yasak | 9.99 |
| 7 · [UI08](#ui08) — 5600+ Ultimate Pixel Art Fantasy RPG Icon Pack | 5: 0/3/2 | 5/10 | çok | K Clockwork Raven | 20 |
| 8 · [UI09](#ui09) — Free Medieval Fantasy UI Pack | 3: 0/3/0 | 5/10 | çok | K ücretsiz ticari | 0 |
| 9 · [UI02](#ui02) — UI User Interface MEGA PACK | 3: 0/3/0 | 3/10 | çok | K ücretli; Free kişisel | 2.40 |
| 10 · [UI01](#ui01) — Fantasy UI User Interaface | 2: 0/2/0 | 4/10 | çok | K ToffeeCraft | 0 |
| 11 · [UI03](#ui03) — UI User Interface Pack - Medieval - Mega Version | 2: 0/2/0 | 4/10 | çok | K ToffeeCraft | 0 |
| 12 · [UI04](#ui04) — UI User Interface Pack - Medieval | 2: 0/2/0 | 3/10 | çok | K ToffeeCraft | 0 |
| 13 · [UI05](#ui05) — UI User Interface Mini Medieval Fantasy Pack | 2: 0/2/0 | 3/10 | çok | K ücretli; Free kişisel | 1.90 |
| 14 · [UI16](#ui16) — notoserif | 1: 0/0/1 | 9/10 | az | O OFL1.1 | 0 |
| 15 · [UI17](#ui17) — ebgaramond | 1: 0/0/1 | 8/10 | az | O OFL1.1 | 0 |
| 16 · [UI18](#ui18) — crimsonpro | 1: 0/0/1 | 8/10 | az | O OFL1.1 | 0 |
| 17 · [UI19](#ui19) — almendra | 1: 0/0/1 | 7/10 | az | O OFL1.1 | 0 |
| 18 · [UI20](#ui20) — Metal 032 | 1: 0/0/1 | 8/10 | orta | A CC0 | 0 |
| 19 · [UI15](#ui15) — Fantasy Map Assets Pack Lite | 1: 0/1/0 | 7/10 | orta | A CC-BY4 Amanz | 0 |
| 20 · [UI12](#ui12) — Fantasy RPG UI Kit — Free | 0: 0/0/0 | 2/10 | çok | ? Lisans ve içerik yok | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [U02](#u02), [U04](#u04), [U03](#u03), [U01](#u01), [U06](#u06) | 14 (0 tam / 7 kısmi / 7 uyarlamayla) | 0.00 USD | 25 kategori-aday açığı: İHT-0007, İHT-0198, İHT-0284, İHT-0287, İHT-0288, İHT-0289, İHT-0290, İHT-0297, İHT-0298, İHT-0299, İHT-0300, İHT-0301, İHT-0302, İHT-0303, İHT-0304, İHT-0305, İHT-0306, İHT-0307, İHT-0308, İHT-0311, İHT-0323, İHT-0328, İHT-0331, İHT-0334, İHT-0337 |
| B: [UI10](#ui10), [UI11](#ui11), [UI14](#ui14), [UI16](#ui16) | 21 (0 tam / 18 kısmi / 3 uyarlamayla) | 14.34 USD | 18 kategori-aday açığı: İHT-0007, İHT-0198, İHT-0294, İHT-0307, İHT-0308, İHT-0311, İHT-0315, İHT-0317, İHT-0318, İHT-0319, İHT-0321, İHT-0323, İHT-0326, İHT-0327, İHT-0328, İHT-0331, İHT-0334, İHT-0520 |
| C: [U02](#u02), [U04](#u04), [U03](#u03), [UI20](#ui20), [U01](#u01), [U06](#u06) | 15 (0 tam / 7 kısmi / 8 uyarlamayla) | 0.00 USD | 24 kategori-aday açığı: İHT-0007, İHT-0284, İHT-0287, İHT-0288, İHT-0289, İHT-0290, İHT-0297, İHT-0298, İHT-0299, İHT-0300, İHT-0301, İHT-0302, İHT-0303, İHT-0304, İHT-0305, İHT-0306, İHT-0307, İHT-0308, İHT-0311, İHT-0323, İHT-0328, İHT-0331, İHT-0334, İHT-0337 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### VFX

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [VFX08](#vfx08) — Particle Effect Texture Essentials | 5: 0/5/0 | 8/10 | orta | ? Ticari lisans ayrıca | 9 |
| 2 · [VFX02](#vfx02) — Particle FX | 5: 0/0/5 | 6/10 | orta | A CC-BY4 Raphael Hatencia | 3.99 |
| 3 · [VFX12](#vfx12) — Retro Particles & Lens Flares for Unreal Engine | 4: 0/4/0 | 3/10 | çok | ? Ürün şartı ayrıca | 29.99 |
| 4 · [VFX14](#vfx14) — Particle Pack | 2: 0/2/0 | 8/10 | az | A CC0 | 0 |
| 5 · [VFX01](#vfx01) — Brackeys' VFX Bundle | 2: 0/2/0 | 8/10 | orta | A CC0 | 0 |
| 6 · [VFX04](#vfx04) — 1000 Free Game Assets | 2: 0/2/0 | 7/10 | orta | A CC0 | 0 |
| 7 · [VFX05](#vfx05) — Textures for particles 3 | 2: 0/2/0 | 4/10 | çok | ? Ticari kullanım açık değil | 0 |
| 8 · [VFX13](#vfx13) — Smoke Particles | 1: 0/1/0 | 8/10 | az | A CC0 | 0 |
| 9 · [VFX15](#vfx15) — Light Masks | 1: 0/1/0 | 8/10 | az | A CC0 | 0 |
| 10 · [VFX06](#vfx06) — Particle FX - Smoke | 1: 0/0/1 | 6/10 | orta | A CC-BY4 Raphael Hatencia | 3.99 |
| 11 · [VFX07](#vfx07) — Particle FX - Ice/Snow | 1: 0/0/1 | 6/10 | orta | A CC-BY4 Raphael Hatencia | 1.99 |
| 12 · [VFX03](#vfx03) — Smoke FX | 1: 0/1/0 | 5/10 | orta | K özel ticari | 0 |
| 13 · [VFX10](#vfx10) — Ultimate Cartoon VFX MEGA PACK - Unity Prefabs | 0: 0/0/0 | 2/10 | çok | K CartoonCoffee | 98 |
| 14 · [VFX11](#vfx11) — Cartoon VFX Essentials - Unity Prefabs | 0: 0/0/0 | 2/10 | çok | K CartoonCoffee | 59.99 |
| 15 · [VFX09](#vfx09) — Cartoon Comic FX Pack | 0: 0/0/0 | 1/10 | çok | ? Demo; asset lisansı doğrulanmadı | ? |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [VFX01](#vfx01), [VFX13](#vfx13), [VFX14](#vfx14), [VFX15](#vfx15) | 4 (0 tam / 4 kısmi / 0 uyarlamayla) | 0.00 USD | 4 kategori-aday açığı: İHT-0150, İHT-0153, İHT-0154, İHT-0156 |
| B: [VFX02](#vfx02), [VFX06](#vfx06), [VFX07](#vfx07), [VFX08](#vfx08) | 8 (0 tam / 2 kısmi / 6 uyarlamayla) | 18.97 USD | 0 kategori-aday açığı: — |
| C: [VFX02](#vfx02), [VFX07](#vfx07), [VFX13](#vfx13), [VFX15](#vfx15) | 7 (0 tam / 1 kısmi / 6 uyarlamayla) | 5.98 USD | 1 kategori-aday açığı: İHT-0156 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Ortam sesi

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [ORT15](#ort15) — Cozy SFX Complete — 1,305 Cute Game Sound Effects & Seamless Ambience Loops (Free Lite) | 9: 0/9/0 | 7/10 | orta | K ticari; AI-assisted ses | 4.99 |
| 2 · [ORT06](#ort06) — Fantasy Ambiences - ambience pack | 8: 0/6/2 | 9/10 | az | K Andrea Baroni | 9 |
| 3 · [ORT04](#ort04) — Minifantasy - Forgotten Plains Audio Pack | 7: 0/5/2 | 8/10 | az | K Leohpaz | 0 |
| 4 · [ORT01](#ort01) — Ambiences and Perspectives SFX | 6: 0/4/2 | 9/10 | az | K Leohpaz ticari | 2.99 |
| 5 · [ORT02](#ort02) — Butterfly - Looped Ambience Sounds Pack | 6: 0/6/0 | 7/10 | orta | ? Ticari izin teyidi yok | 0 |
| 6 · [ORT10](#ort10) — Plethora Of Game Sounds | 6: 0/6/0 | 7/10 | orta | ? Lisans belirsiz | 0 |
| 7 · [ORT09](#ort09) — Ambiences | 5: 0/3/2 | 8/10 | az | ? Ayrı PDF lisansı | EUR5 |
| 8 · [ORT11](#ort11) — Ethereal Solitude - SFX Starter Pack Vol.1 | 5: 0/4/1 | 7/10 | az | K royalty-free; Limen_dev atfı | 0 |
| 9 · [ORT12](#ort12) — COTTAGE | 3: 0/3/0 | 6/10 | orta | ? Lisans yok | EUR2.99 |
| 10 · [ORT05](#ort05) — Free City & Nature Sounds | 2: 0/2/0 | 6/10 | orta | ? Ticari kapsam teyidi gerekli | 0 |
| 11 · [ORT08](#ort08) — Fantasy Sound Pack | 2: 0/2/0 | 6/10 | orta | A CC-BY4 Nathan Gibson | 9.99 |
| 12 · [ORT14](#ort14) — Free Water Stream Sounds | 1: 0/1/0 | 8/10 | az | A CC-BY4 Gregor Quendel | 0 |
| 13 · [ORT07](#ort07) — Audio Elk / Ambience Collection | 0: 0/0/0 | 5/10 | orta | S CC-BY-SA4 | 0 |
| 14 · [ORT03](#ort03) — PSX Ambient Pack | 0: 0/0/0 | 1/10 | çok | K ticari yorum izni | 0 |
| 15 · [ORT13](#ort13) — Letters & Memories - Royalty Free Ambience and SFX | 0: 0/0/0 | 1/10 | çok | S CC-BY-SA4; ek ifade çelişkili | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [S02](#s02), [ORT14](#ort14) | 5 (1 tam / 4 kısmi / 0 uyarlamayla) | 0.00 USD | 20 kategori-aday açığı: İHT-0464, İHT-0468, İHT-0469, İHT-0471, İHT-0476, İHT-0477, İHT-0478, İHT-0479, İHT-0480, İHT-0485, İHT-0486, İHT-0487, İHT-0489, İHT-0491, İHT-0494, İHT-0495, İHT-0496, İHT-0497, İHT-0511, İHT-0512 |
| B: [ORT01](#ort01), [ORT06](#ort06), [ORT09](#ort09) | 9 (0 tam / 7 kısmi / 2 uyarlamayla) | 11.99 USD + 5.00 EUR | 16 kategori-aday açığı: İHT-0468, İHT-0469, İHT-0471, İHT-0476, İHT-0477, İHT-0478, İHT-0479, İHT-0480, İHT-0485, İHT-0486, İHT-0487, İHT-0491, İHT-0494, İHT-0495, İHT-0496, İHT-0497 |
| C: [S02](#s02), [ORT01](#ort01), [ORT04](#ort04) | 9 (1 tam / 6 kısmi / 2 uyarlamayla) | 2.99 USD | 16 kategori-aday açığı: İHT-0464, İHT-0468, İHT-0469, İHT-0476, İHT-0477, İHT-0478, İHT-0479, İHT-0480, İHT-0486, İHT-0487, İHT-0491, İHT-0495, İHT-0496, İHT-0497, İHT-0511, İHT-0512 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Foley

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [FOL14](#fol14) — Medieval Combat SFX Free - Sword, Bow & Shield Sampler | 8: 0/7/1 | 8/10 | az | A CC-BY4 heyheythere | 0 |
| 2 · [FOL01](#fol01) — 400 Sounds Pack | 5: 0/5/0 | 7/10 | orta | K ticari; ham yeniden satış yasak | 0 |
| 3 · [FOL08](#fol08) — FOLEY SOUNDS HORROR PACK / 150 foleys and sounds | 3: 0/3/0 | 5/10 | orta | ? Ticari izin net değil | 0 |
| 4 · [FOL06](#fol06) — Charcoal Sample Pack | 2: 0/2/0 | 9/10 | az | K ticari; WangleLine | 0 |
| 5 · [FOL09](#fol09) — Door SFX | 2: 0/2/0 | 8/10 | az | ? Lisans sorusu açık | 5 |
| 6 · [FOL15](#fol15) — Household Interior Foley – Free Sound Effects Pack (80+ Sounds) | 2: 0/2/0 | 7/10 | az | K royalty-free | 0 |
| 7 · [FOL10](#fol10) — Game Footsteps | 1: 0/0/1 | 8/10 | az | K Epic Stock Media; tam EULA teyidi | 23.20 |
| 8 · [FOL07](#fol07) — Card Sound Effects | 1: 0/1/0 | 7/10 | az | ? Ürün lisansı görünmedi | 9.99 |
| 9 · [FOL11](#fol11) — Footsteps SFX Free - Walk, Run & Sneak Footstep Sampler | 1: 0/0/1 | 7/10 | az | A CC-BY4 heyheythere | 0 |
| 10 · [FOL12](#fol12) — Footsteps - Sound Effects Pack | 1: 0/1/0 | 7/10 | az | ? Tam ticari izin arşivde | 0 |
| 11 · [FOL02](#fol02) — Audio Elk / Foley Sessions Vol. 1 | 1: 0/1/0 | 6/10 | orta | S CC-BY-SA4 | 0 |
| 12 · [FOL05](#fol05) — The Sounds of the Kitchen - FREE Sample Pack | 1: 0/1/0 | 5/10 | orta | K yazar yorum izni; koşullu | 0 |
| 13 · [FOL13](#fol13) — Noisevember 24 FREE Sound Pack | 0: 0/0/0 | 3/10 | orta | ? Lisans yok | 0 |
| 14 · [FOL03](#fol03) — Foley SFX | 0: 0/0/0 | 3/10 | çok | ? Lisans metni ayrıca | 12.96 |
| 15 · [FOL04](#fol04) — Audio Elk / Foley Sessions - Household Foley Vol. 1 | 0: 0/0/0 | 2/10 | çok | S CC-BY-SA4 | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [S01](#s01), [FOL11](#fol11), [FOL14](#fol14) | 11 (0 tam / 7 kısmi / 4 uyarlamayla) | 0.00 USD | 6 kategori-aday açığı: İHT-0464, İHT-0472, İHT-0473, İHT-0477, İHT-0479, İHT-0480 |
| B: [FOL09](#fol09), [FOL10](#fol10), [FOL07](#fol07), [FOL06](#fol06) | 6 (0 tam / 5 kısmi / 1 uyarlamayla) | 38.19 USD | 11 kategori-aday açığı: İHT-0472, İHT-0473, İHT-0475, İHT-0478, İHT-0479, İHT-0480, İHT-0485, İHT-0492, İHT-0499, İHT-0500, İHT-0515 |
| C: [S01](#s01), [FOL11](#fol11), [FOL14](#fol14), [FOL06](#fol06) | 12 (0 tam / 8 kısmi / 4 uyarlamayla) | 0.00 USD | 5 kategori-aday açığı: İHT-0472, İHT-0473, İHT-0477, İHT-0479, İHT-0480 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### UI sesi

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [UIS13](#uis13) — User Interface Sound Effects 4 - Universal Sound Effects | 4: 0/4/0 | 7/10 | az | K ELVGames/Pegonthetrack | 3.99 |
| 2 · [UIS10](#uis10) — [SFX] Wooden UI Sound Effect Pack | 3: 0/1/2 | 9/10 | az | K JDSherbert | GBP2.49 |
| 3 · [UIS09](#uis09) — lolurio's FREE Cozy Game UI SFX Pack | 3: 0/3/0 | 7/10 | az | A CC-BY4 Lolurio | 0 |
| 4 · [UIS02](#uis02) — [SFX] Ultimate UI Sound Effect Pack | 3: 0/3/0 | 6/10 | az | K JDSherbert | GBP4.99 |
| 5 · [UIS15](#uis15) — User Interface Sound FX - Medieval Collection | 3: 0/3/0 | 7/10 | orta | ? Lisans şartı görünmedi | 49.99 |
| 6 · [UIS04](#uis04) — Shapeforms Audio Free Sound Effects | 3: 0/3/0 | 5/10 | orta | K ticari; tam lisans bağlantılı | 0 |
| 7 · [UIS03](#uis03) — Universal UI/Menu Soundpack | 2: 0/1/1 | 8/10 | az | A CC-BY4 Nathan Gibson | 0 |
| 8 · [UIS08](#uis08) — 50 Menu Interface SFX | 2: 0/2/0 | 5/10 | orta | A CC-BY4 ColorAlpha | 0 |
| 9 · [UIS11](#uis11) — SoupTonic's sound SFX Pack 1 - UI menu sounds | 2: 0/2/0 | 5/10 | orta | A CC-BY4 Souptonic | 0 |
| 10 · [UIS05](#uis05) — RPG Essentials SFX - Free! | 2: 0/2/0 | 4/10 | orta | K Leohpaz | 0 |
| 11 · [UIS07](#uis07) — Retro RPG 100 UI Sound Effects | 2: 0/2/0 | 4/10 | orta | K Leohpaz | 3.49 |
| 12 · [UIS12](#uis12) — User Interface Sound Effects 1 - Universal Sound Effects | 1: 0/1/0 | 6/10 | az | K ELVGames/Pegonthetrack | 4.99 |
| 13 · [UIS14](#uis14) — User Interface Sound Effects 3 - Universal Sound Effects | 1: 0/1/0 | 6/10 | az | K ELVGames/Pegonthetrack | 3.99 |
| 14 · [UIS01](#uis01) — [SFX] Pixel UI Sound Effect Pack | 0: 0/0/0 | 2/10 | çok | K JDSherbert | GBP4.99 |
| 15 · [UIS06](#uis06) — Echoes: Audio Super Kit | 0: 0/0/0 | 2/10 | çok | ? PDF lisans teyidi gerekli | EUR11.97 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [UIS03](#uis03), [UIS09](#uis09), [S07](#s07) | 3 (0 tam / 2 kısmi / 1 uyarlamayla) | 0.00 USD | 3 kategori-aday açığı: İHT-0470, İHT-0479, İHT-0495 |
| B: [UIS10](#uis10), [UIS13](#uis13) | 4 (0 tam / 2 kısmi / 2 uyarlamayla) | 3.99 USD + 2.49 GBP | 2 kategori-aday açığı: İHT-0479, İHT-0495 |
| C: [UIS03](#uis03), [UIS10](#uis10) | 3 (0 tam / 1 kısmi / 2 uyarlamayla) | 0.00 USD + 2.49 GBP | 3 kategori-aday açığı: İHT-0470, İHT-0479, İHT-0495 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Müzik

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [MUZ02](#muz02) — Resonance Vol. 2: Instruments of the Middle East | 7: 0/7/0 | 8/10 | orta | ? Ürün lisansı ayrıca | 19.99 |
| 2 · [MUZ07](#muz07) — Ethnic Music of Ancient Desert (Egyptian) | 7: 0/7/0 | 8/10 | orta | K royalty-free | 16.75 |
| 3 · [MUZ05](#muz05) — Medieval Music Pack | 7: 0/7/0 | 7/10 | orta | K JSM | 19.99 |
| 4 · [MUZ06](#muz06) — Persian Nights - Battle Music Pack | 5: 0/5/0 | 6/10 | orta | K ticari ürün izni | 5.99 |
| 5 · [MUZ04](#muz04) — Desert Wasteland & Oasis RPG Music Pack - 23 Traditional Oud Tracks | 3: 0/3/0 | 8/10 | az | K ticari; AI-assisted | 9.99 |
| 6 · [MUZ08](#muz08) — MEDIEVAL BARD MUSIC – Fantasy RPG Soundtracks | 3: 0/3/0 | 7/10 | orta | K royalty-free | 30.15 |
| 7 · [MUZ03](#muz03) — Middle East Instrumental Arabian Soul Music Pack | 2: 0/2/0 | 5/10 | orta | K ticari; fiyat çelişkisi | 9.99 |
| 8 · [MUZ11](#muz11) — Complete Darbuka Sample Pack | 1: 0/1/0 | 8/10 | orta | K Abbara EULA | 19 |
| 9 · [MUZ14](#muz14) — Complete Qanun Sample Pack | 1: 0/1/0 | 8/10 | orta | K Abbara EULA | 43.69 |
| 10 · [MUZ13](#muz13) — Complete Classical Kemençe Sample Pack | 1: 0/1/0 | 7/10 | orta | K Abbara EULA | 33.45 |
| 11 · [MUZ12](#muz12) — Complete Bowed Tanbur Sample Pack | 1: 0/1/0 | 6/10 | çok | K Abbara EULA | 28.94 |
| 12 · [MUZ15](#muz15) — Medieval Music | 0: 0/0/0 | 3/10 | çok | ? Fab lisans alanı boş | 0 |
| 13 · [MUZ01](#muz01) — Desert Music Pack [Game Music] | 0: 0/0/0 | 2/10 | çok | X yalnız ticari olmayan | 0 |
| 14 · [MUZ09](#muz09) — Blessing of the Dustland | 0: 0/0/0 | 2/10 | çok | ? Ticari şart yok | 0 |
| 15 · [MUZ10](#muz10) — AridFoothills | 0: 0/0/0 | 2/10 | çok | A CC-BY4 Kevin MacLeod | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [MUZ10](#muz10) | 0 (0 tam / 0 kısmi / 0 uyarlamayla) | 0.00 USD | 7 kategori-aday açığı: İHT-0463, İHT-0465, İHT-0466, İHT-0467, İHT-0502, İHT-0503, İHT-0504 |
| B: [MUZ02](#muz02), [MUZ07](#muz07), [MUZ11](#muz11), [S11](#s11) | 7 (0 tam / 7 kısmi / 0 uyarlamayla) | 55.74 USD | 0 kategori-aday açığı: — |
| C: [MUZ04](#muz04), [MUZ05](#muz05), [S11](#s11) | 7 (0 tam / 7 kısmi / 0 uyarlamayla) | 29.98 USD | 0 kategori-aday açığı: — |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


### Mırıltı

| Sıra / aday | İhtiyaç teması: tam / kısmi / uyarlama | Uyum | İş | Lisans | Fiyat |
|---|---|---:|---|---|---|
| 1 · [MIR01](#mir01) — 500+ Character Voice Audio Files! | 3: 0/3/0 | 8/10 | az | A CC-BY4 Dillon Becker | 0 |
| 2 · [MIR11](#mir11) — Warrior Voice Pack | 3: 0/3/0 | 7/10 | orta | Ç CC0/özel kısıt | 0 |
| 3 · [MIR10](#mir10) — EFFORT SOUNDS (Male) - Audio Pack | 2: 0/2/0 | 5/10 | orta | S CC-BY-SA4 | 0 |
| 4 · [MIR04](#mir04) — Free Voice Clips Pack (Mature Female) | 1: 0/0/1 | 8/10 | az | A CC0 | 0 |
| 5 · [MIR13](#mir13) — [VOX] Male Character Vocal Pack | 1: 0/0/1 | 8/10 | az | K JDSherbert + ATTurtlez | 0 |
| 6 · [MIR05](#mir05) — Generic Male Voice Pack | 1: 0/1/0 | 7/10 | az | K Dan Bosley atfı | 0 |
| 7 · [MIR07](#mir07) — Free Generic Female Voice Pack | 1: 0/1/0 | 7/10 | az | K Rookie atfı | 0 |
| 8 · [MIR08](#mir08) — Jessica's Basic Voice Clips | 1: 0/1/0 | 6/10 | orta | Ç CC-BY4 / eski BY-SA notu | 0 |
| 9 · [MIR14](#mir14) — RPG Male Vocal | 1: 0/1/0 | 6/10 | orta | ? Ticari lisans teyidi | 0 |
| 10 · [MIR02](#mir02) — RPG Voice Starter Pack | 1: 0/1/0 | 5/10 | orta | A CC0 | 0 |
| 11 · [MIR03](#mir03) — Free Voice Clips Pack (Bright Female) | 1: 0/1/0 | 5/10 | orta | A CC0 | 0 |
| 12 · [MIR06](#mir06) — Voice Over Asset - Female, Mid-Range, American | 1: 0/1/0 | 5/10 | orta | ? Lisans yok | 0 |
| 13 · [MIR12](#mir12) — Dialogue Sfx | 1: 0/1/0 | 4/10 | çok | K krediyle kullanım | 0 |
| 14 · [MIR09](#mir09) — Humanoids Grunts SFX Pack | 0: 0/0/0 | 1/10 | çok | K Leohpaz | 3.49 |
| 15 · [MIR15](#mir15) — Custom Voice Resource - CVR | 0: 0/0/0 | 1/10 | çok | X CC-BY-NC-SA | 0 |

**Alternatif setler:** A = önce açık lisans/mevcut kaynak; B = içerik/kalite ağırlıklı; C = daha küçük karma seçim. Her kategoride eksiksiz bir A seti bulunduğu iddia edilmiyor. Özellikle müzikte A seti uygun teslim kapatmıyor; yeni aday adedi uygun aday adedi değildir.

| Set / ürünler | Benzersiz ihtiyaç teması | Fiyat | Kalan kapsam açığı |
|---|---|---|---|
| A: [MIR01](#mir01), [MIR04](#mir04) | 3 (0 tam / 2 kısmi / 1 uyarlamayla) | 0.00 USD | 2 kategori-aday açığı: İHT-0517, İHT-0518 |
| B: [S10](#s10), [S12](#s12), [MIR13](#mir13) | 3 (0 tam / 1 kısmi / 2 uyarlamayla) | 29.99 USD | 2 kategori-aday açığı: İHT-0495, İHT-0497 |
| C: [MIR04](#mir04), [S10](#s10) | 3 (0 tam / 1 kısmi / 2 uyarlamayla) | 19.99 USD | 2 kategori-aday açığı: İHT-0495, İHT-0497 |

Kategori-aday açığı yalnız bu kategoride herhangi bir adayla temas eden ihtiyaç evrenine göredir; oyunun bütün eksikleri değildir. Tam oyun açıkları en sondaki listelerdedir. Set kapsamındaki kısmi satırın kalan alt parçaları, bu fark hesabı sıfır olsa bile açık kalır. A seti CC0/CC-BY dışı yeni OFL font tedarikini veya özel lisansı kendiliğinden onaylamaz.


## Yeni adayların içerik ve ID kanıtları


### Çevre: ürün notları


<a id="cev01"></a>
#### CEV01 — [KayKit - Forest Nature Pack](https://kaylousberg.itch.io/kaykit-forest)

Forest Nature: ücretsiz 100+ ağaç/kaya/çalı/ot; Extra 200+ benzersiz model ve arazi. 1558/1588 toplamı renk varyantı içeriyor, benzersiz model sayısı değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 1 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0423. **Uyarlama:** İHT-0386.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev02"></a>
#### CEV02 — [KayKit - Dungeon Pack](https://kaylousberg.itch.io/kaykit-dungeon-pack)

Dungeon: ücretsiz 200 duvar/zemin/merdiven/kapı ve sandık, masa, sandalye; yatak ve han mobilyaları Extra 7.95 USD katmanında. Oda kurulur; kasa ve tarihî yatak ücretsiz diye sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, GLB, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 3 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0347, İHT-0410, İHT-0411. **Uyarlama:** İHT-0412, İHT-0414.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev03"></a>
#### CEV03 — [KayKit - Medieval Hexagon Pack](https://kaylousberg.itch.io/kaykit-medieval-hexagon)

Medieval Hexagon: demirci, kerestehane, pazar, yel/su değirmeni, maden, kuyu, ev, kışla açıkça listelenmiş. At ve birimler Extra 9.99 USD. Altıgen strateji ölçeği yakın plan köye uyarlanmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **9** = 0 tam + 1 kısmi + 8 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0386. **Uyarlama:** İHT-0360, İHT-0364, İHT-0367, İHT-0372, İHT-0373, İHT-0375, İHT-0377, İHT-0425.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev04"></a>
#### CEV04 — [Medieval Village/Town Interior/Exterior MEGA Pack!](https://emaceart.itch.io/slavica)

Slavica: 800+ model; 100+ yapı/modül, 130 çit/duvar, 127 arazi, 122 bitki; kuyu, araba, sıra, masa ve dolap. İki gövde, 27 karakter prefabı ve 25 klip; custom rig Humanoid değil. Tanıtım ışığı ayrı ürün.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 66 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ürün lisansı ayrıca**.
- Biçim: FBX, GLB. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **16** = 0 tam + 3 kısmi + 13 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0359, İHT-0423, İHT-0427. **Uyarlama:** İHT-0361, İHT-0365, İHT-0370, İHT-0372, İHT-0377, İHT-0378, İHT-0386, İHT-0397, İHT-0410, İHT-0412, İHT-0414, İHT-0420, İHT-0425.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev05"></a>
#### CEV05 — [Medieval Village Megapack - Low Poly Refreshed - URP](https://rg-poly.itch.io/medieval-village-megapack-low-poly-refreshed-urp)

RG Refreshed: 147 model, 150 prefab, ortalama 552 poligon; su Shader Graph ve yaprak/kelebek/güneş VFX Unity URP içindir. Yapıların tek tek adları yayımlanmamış; 147 modeli bütün bina taleplerine yaymadım.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 32.20 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans metni görünmedi**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0372, İHT-0386, İHT-0412. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev06"></a>
#### CEV06 — [LOKIT: Low Poly Medieval Village - 200+ Modular Asset Kit](https://standout7.itch.io/lokit-village)

LOKIT Village: Free 70+ FBX modülü; HEX 200+ GLB/glTF/OBJ; Blend kaynak ve gökyüzü. Ücretsiz ve tam sürüm aynı dosya/biçim değil. Yapı blokları doğrulanıyor; özel fırın/şifahane listesi yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, GLB, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 2 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0339, İHT-0372. **Uyarlama:** İHT-0412.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev07"></a>
#### CEV07 — [Village Builder - Low Poly 3D Asset Pack](https://avramania.itch.io/village-builder)

Avramania Village Builder: Premium 140 model; 12 hazır yapıda demirci, fırın, gözcü kulesi, ambar, beş bölmeli ahır, kuyu. 5 pazar parçası, sundurma ve 2 m modüller. Free yalnız 31 model; aşağıdaki kapsam Premium içindir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Premium; Free CC0**.
- Biçim: FBX, GLB, glTF. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **11** = 0 tam + 1 kısmi + 10 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0370. **Uyarlama:** İHT-0364, İHT-0365, İHT-0366, İHT-0369, İHT-0372, İHT-0376, İHT-0377, İHT-0397, İHT-0412, İHT-0425.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev08"></a>
#### CEV08 — [Low Poly Medieval Village](https://justcreate3d.itch.io/low-poly-medieval-village)

JustCreate Low Poly: 219 prefab: 15 arazi, 62 doğa, 71 eşya, 11 gıda, 51 ev parçası, 9 hazır ev; FBX/GLB ve Blend. İçeri girilebilir evler var; tek tek atölye adları yok. Bağımsız yüklenici ayrı lisans almalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JustCreate**.
- Biçim: FBX, GLB. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 2 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0397, İHT-0414. **Uyarlama:** İHT-0372, İHT-0386, İHT-0412.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev09"></a>
#### CEV09 — [Stylized Medieval Village](https://justcreate3d.itch.io/stylized-medieval-village)

JustCreate Stylized: 10 ev ve 2 renk, modüler iç mekân, demirci ve han. Hayvanlar yalnız Unity/FBX tesliminde; tür/klip listesi yok. Büyülü iksir dükkânı elenir, diğer binaları şifahane saymadım.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 59.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JustCreate**.
- Biçim: FBX. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 1 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0414. **Uyarlama:** İHT-0364, İHT-0372, İHT-0412.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev10"></a>
#### CEV10 — [Farm Buildings Pack](https://quaternius.com/packs/farmbuildings.html)

Quaternius Farm Buildings: 13 FBX/OBJ/Blend yapı; ayrı bina adları yok. Çiftlik etiketi ahır/ağıl içerdiğini tek başına doğrulamıyor; bu nedenle sayı düşük ve kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0369, İHT-0370. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev11"></a>
#### CEV11 — [Ultimate Modular Ruins Pack](https://quaternius.com/packs/ultimatemodularruins.html)

Quaternius Modular Ruins: 90 modül, harabe/zindan, bir animasyonlu karakter ve eşya. Sağlam köy kapısı veya belirli oda tefrişi doğrulanmıyor; duvar/oda modül adayı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0378, İHT-0411, İHT-0412. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev12"></a>
#### CEV12 — [Nature Kit](https://kenney.nl/assets/nature-kit)

Kenney Nature Kit: 330 dosya; ağaç, kaya, yapraklı çevre. Dosya uzantıları ve tür bazlı tam liste ürün metninde yok; ağaç/kaya çeşitlendirmesine kısmi aday, bozkır tür seçimi gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0386, İHT-0423. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev13"></a>
#### CEV13 — [Graveyard Kit](https://kenney.nl/assets/graveyard-kit)

Kenney Graveyard: 90 dosya, animasyon etiketi; Halloween/monster içeriği tarihî mezar değildir. Haçsız yazısız taş ve toplu mezar teslimi doğrulanmadığından kapsama sıfır.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev14"></a>
#### CEV14 — [Modular Cave Kit](https://kenney.nl/assets/modular-cave-kit)

Kenney Modular Cave: 40 dosya ve modüler mağara. Maden iç hacmine aday; giriş, üretim binası veya kazılabilir cevher geometrisi hazır sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0373, İHT-0423. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="cev15"></a>
#### CEV15 — [Roadside Tales  Fences and Wall Bundle Pack 1-3 LODS](https://emaceart.itch.io/roadside-tales-fences-and-wall-bundle-pack-1-3-lods)

Roadside Tales Fences: 127 mesh, 128 prefab; taş/çakıl ve dal/tahta çitler, 4 LOD. FBX, Blend, Godot dosyaları. Tarla sınırı/ağıl çevresi yapılabilir; kale suru tam karşılığı değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ürün lisansı açık değil**.
- Biçim: FBX, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; gerçekçilik veya özel aile farkı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0370, İHT-0378. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Karakter: ürün notları


<a id="kar01"></a>
#### KAR01 — [Medieval Characters Pack — Low-Poly Rigged Medieval Cast](https://fromqcwithgamedev.itch.io/medieval-characters-pack-low-poly-rigged-medieval-cast)

QC Medieval Cast: Full 23; tüccar, demirci, fırıncı, çoban, sütçü, muhafız, kral/kraliçe vb. Free 5 başka altküme. Ortak 25 kemik Mixamo adları, 1700–3300 üçgen FBX; eldeki prop ayrı. Çocuk/yaşlı yok, hazır animasyon beyanı yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 5 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans yayımlanmamış**.
- Biçim: FBX. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 2 kısmi + 5 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0390, İHT-0431. **Uyarlama:** İHT-0351, İHT-0353, İHT-0355, İHT-0356, İHT-0358.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar02"></a>
#### KAR02 — [LOWPO: Villagers NPC – Low Poly Medieval Character Pack](https://assetstore.unity.com/packages/3d/characters/lowpo-villagers-npc-low-poly-medieval-character-pack-379078)

LOWPO Villagers: 7 rigli rol: demirci, avcı, çocuk, çiftçi, oduncu, yaşlı, tüccar; 3 prop çekiç/bıçak/sopa. FBX ve 256² atlas, yaklaşık 1500 poligon; animasyon yok. Single Entity ve Extension Asset alanları çelişkili.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Unity Standard; koltuk türü koşullu**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 2 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0390, İHT-0431. **Uyarlama:** İHT-0357, İHT-0428.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar03"></a>
#### KAR03 — [Medieval Village NPC Pack | 6 Rigged Low-Poly Characters | Animated](https://www.fab.com/listings/ee501952-95f3-4eb6-a01c-fe7394fd6f64?lang=en)

DayDrift NPC: 6 rigli figür; muhafız, kadın/erkek köylü, demirci, gezgin tüccar, kadın otacı. 9–13 bin üçgen, 2K albedo/normal; Idle/Walk/Run/Attack/Death. FBX/Blend. Mağaza fiyat/lisans seçimi okunamıyor; AI üretimi işaretli.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: ? (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Fab lisans seçimi boş**.
- Biçim: FBX, Blend, PNG. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 2 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0390, İHT-0431. **Uyarlama:** İHT-0426, İHT-0427.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar04"></a>
#### KAR04 — [Slavic Medieval Villagers — Modular Low Poly Characters](https://assetstore.unity.com/packages/3d/characters/slavic-medieval-villagers-modular-low-poly-characters-169217)

Slavic Villagers: modüler erkek/kadın ve 23 prefab; 24/25 klip beyanları farklı sayfalarda değişiyor. Custom generic 63 kemik; doğrudan Humanoid sayılmaz. Slavica içinde benzer kişiler zaten var, iki kez ödeme yapılmamalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 7 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Unity Standard**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **7/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 2 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0390, İHT-0431. **Uyarlama:** İHT-0427.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar05"></a>
#### KAR05 — [LOWPO: Low Poly Medieval Female Characters Pack](https://standout7.itch.io/lowpo-female)

LOWPO Female: güncel sayfa Free 3, Pro 5 kadın diyor; eski günlük Free 2. Ortak 512² atlas, Mixamo akışı, rigli; animasyon özellikle dahil değil. Pro GLB/glTF; Free FBX, Blend 9.99 USD.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, GLB, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0427.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar06"></a>
#### KAR06 — [Medieval Pack - Characters](https://jamajurabaev.gumroad.com/l/YIiOG)

Jama Medieval Characters: 3 rigli yaya şövalye, 3 rigli atlı, 1 rigli at; 30 köylü POZLU ve rigsız. 18 atlı/33 yaya poz klip değildir. OBJ/FBX/Blend; 200/1000/2000 USD serbest çalışan/indie/stüdyo katmanları.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 200 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K katmana bağlı; doğrulama gerekli**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0358, İHT-0379, İHT-0428. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar07"></a>
#### KAR07 — [3D Medieval Fantasy Imperial Messenger Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-imperial-messenger-character-rigged-pack-3d-model-with-walk-run-jump)

Les2 Imperial Messenger: tek kadın haberci, 50 bin üçgen; FBX/GLB/Blend; walk/run/kick/die/jump. Köy low-poly bütçesine göre ağır; adında messenger olması tarihî giysiyi doğrulamaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0355.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar08"></a>
#### KAR08 — [3D Medieval Diplomat of the Kingdom Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-diplomat-character-rigged-pack-3d-model-with-walk-run-jump-kick-die)

Les2 Diplomat: tek erkek elçi, 50 bin üçgen ve aynı beş klip. Konuşma/bekleme klibi belirtilmiyor; kıyafet ve LOD gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0353.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar09"></a>
#### KAR09 — [3D Medieval Royal Tax Collector Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-royal-tax-collector-character-rigged-pack-3d-model-with-walk-run-jum)

Les2 Tax Collector: tek tahsildar, 50 bin üçgen ve aynı beş klip. Rol adayını kapatır, Anadolu başlığı/kaftanı ve görüşme pozu uyarlanmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0352.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar10"></a>
#### KAR10 — [3D Medieval Wise Old man Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-old-man-character-rigged-pack-3d-model-with-walk-run-jump-kick-die-a)

Les2 Wise Old Man: tek yaşlı, 50 bin üçgen; yaşlı yürüyüşü yerine standart walk/run/kick/die/jump. Yaş görünümü gövde adaylığı sağlar, ses ve yüz jesti sağlamaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0428.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar11"></a>
#### KAR11 — [3D Medieval Blacksmith Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-blacksmith-character-rigged-pack-3d-model-with-walk-run-jump-kick-di)

Les2 Blacksmith: tek demirci, 50 bin üçgen; çalışma/çekiç klibi yok, yalnız ortak beş hareket. Usta grubunun tek üyesine aday.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0431. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar12"></a>
#### KAR12 — [3D Medieval Priest Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-priest-character-rigged-pack-3d-model-with-walk-run-jump-kick-die-animations)

Les2 Priest: tek rahip, 50 bin üçgen ve ortak beş klip. Rahip kıyafetini derviş diye kullanmak doğru değil; gövde tamamen yeniden giydirilmedikçe eşleşme yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar13"></a>
#### KAR13 — [3D Medieval Soldier Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-soldier-character-rigged-pack-3d-model-with-walk-run-jump-kick-die)

Les2 Soldier: tek asker, 50 bin üçgen, ortak beş klip. Zırh/başlık ve malzeme değiştirme gerekir; özel çavuş rütbesi hazır sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 0 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0358, İHT-0426.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar14"></a>
#### KAR14 — [3D Medieval Farmer Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-farmer-character-rigged-pack-3d-model-with-walk-run-jump-kick-die-an)

Les2 Farmer: tek erkek çiftçi, 50 bin üçgen; orak/tarla işi veya mesleğe özel alet animasyonu yok. Usta/tacir ve eş rollerine uydurulmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **4/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="kar15"></a>
#### KAR15 — [3D Medieval Fantasy Female Innkeeper Character Rigged Pack – 3D Model with Walk, Run, Jump, Kick & Die Animations](https://les2ifsgames.itch.io/3d-medieval-fantasy-female-innkeeper-character-rigged-pack-3d-model-with-walk-ru)

Les2 Female Innkeeper: tek kadın hancı, 50 bin üçgen; ortak beş klip. Eş gövdesine aday, kıyafet değişimi/LOD ve ayrı diyalog klipleri gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Stilize/low-poly; insan oranı, yaş ve dönem kıyafeti kabulü; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0427.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Animasyon: ürün notları


<a id="anm01"></a>
#### ANM01 — [Animation Pack - Blacksmith](https://mocapcentral.com/products/mocap-studio-series-blacksmith)

Blacksmith: tam listede 45 benzersiz klip; Anvil 7, Forge 5, GrindingStone 3. Anvil_02_Hit1/03_Hit2 çekiç ihtiyacına aday. Forge, ekmek fırını küreği değildir; ısınma da sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 39.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **9/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 1 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0396. **Uyarlama:** İHT-0453.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %15.6 = 7/45 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/blacksmith-animation-list). Metinde ayrıştırılan benzersiz klip adı: **45**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm02"></a>
#### ANM02 — [Animation Pack - Core Motion](https://mocapcentral.com/products/core-motion-pack)

Core Motion: ürün 659, açılan ad listesi 579 benzersiz klip; sürüm/payda farkı saklanmadı. Talk_03_Angry, Talk_02_Happy, Listen_01_Generic, yürüyüş/koşu/çömelme ve idle. Üç idle bütün varyantlarda aynı duygu değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 49.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **9/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 2 kısmi + 5 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0446, İHT-0401. **Uyarlama:** İHT-0444, İHT-0445, İHT-0447, İHT-0450, İHT-0524.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %72.2 = 418/579 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/core-motion-animation-list). Metinde ayrıştırılan benzersiz klip adı: **579**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm03"></a>
#### ANM03 — [Animation Pack - Danger](https://mocapcentral.com/products/mocap-studio-series-danger-pack)

Danger: listede 265 klip; Dazed yürüyüş, HandsUp/Kneel teslimiyet, sandalye korkusu, saklanma, sürünme, yas. Korku tepkisi panik döngüsüne kısmi; teslimiyet yalvarma değildir. Uçan/sihirli eylemler elenir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 79.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 3 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0448, İHT-0449, İHT-0459. **Uyarlama:** İHT-0461.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %15.5 = 41/265 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/danger-animation-list). Metinde ayrıştırılan benzersiz klip adı: **265**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm04"></a>
#### ANM04 — [Animation Pack - Doors](https://mocapcentral.com/products/animation-pack-doors)

Doors: 58 karakter etkileşimi ve kapı iskeleti; çift/tek/sürgülü kapı, yumrukla vurma. Ağır ahşap köy kapısının modeli veya gıcırtı sesi yok; sayısal ihtiyaçlara doğrudan eklenmedi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 49.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0 doğrudan ihtiyaç teması: listede kapı etkileşimi var, ana listedeki model/ses teslimine karşılık değil.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/door-animation-list). Metinde ayrıştırılan benzersiz klip adı: **58**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm05"></a>
#### ANM05 — [Animation Pack - Dungeon Life](https://mocapcentral.com/products/mocap-studio-series-dungeon-life-pack)

Dungeon Life: listede 825; TorchHold 44, StandLook 10, Spear/Guard ve SwordShield grupları. Orc/undead/magic elenir; mızrak ve kılıç hareketleri tarihî tutuşa göre ayarlanır. 825 benzersiz performans değil, RM/NoRM tekrarları da var.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 134.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 2 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0387, İHT-0460. **Uyarlama:** İHT-0454, İHT-0455.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %35.4 = 292/825 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/dungeon-life-pack-animation-list). Metinde ayrıştırılan benzersiz klip adı: **825**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm06"></a>
#### ANM06 — [Animation Pack - Fix & Build](https://mocapcentral.com/products/mocap-studio-series-fix-build-pack)

Fix & Build: listede 156; HammerTable, KneelHammer, Pickaxe, Axe, Shovel. Matkap/anahtar/makine işleri elenir. Küreme hareketi model olmadan MEV05 grubunu tam kapatmaz; fırın küreği temasına uyarlama ister.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 44.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 2 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0396, İHT-0408. **Uyarlama:** İHT-0453.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %26.3 = 41/156 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/fix-build-animation-list). Metinde ayrıştırılan benzersiz klip adı: **156**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm07"></a>
#### ANM07 — [Animation Pack - Grab Loot](https://mocapcentral.com/products/grab-loot-pack)

Grab & Loot: listede 198; CupboardMid arama/alma, sandık/kapı kasa etkileşimleri. Özgül kanıtı saklama, yük taşıma ve yular tutma teslimleriyle aynı değil; kapsam sıfır.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 49.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **4/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/grab-loot-animation-list). Metinde ayrıştırılan benzersiz klip adı: **198**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm08"></a>
#### ANM08 — [Animation Pack - Greet & Talk](https://mocapcentral.com/products/mocap-studio-series-greet-talk-pack)

Greet & Talk: sayfa 176, listede 182 benzersiz ad; solo talk/listen ve 110 cm aralıklı eşli A/B jestler. Olumlu/olumsuz tavır mutlaka öfke/sevinç değildir. Eşli klip tek NPC'ye doğrudan takılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 64.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **9/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 3 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0446, İHT-0447, İHT-0449. **Uyarlama:** İHT-0444, İHT-0445.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %84.6 = 154/182 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/greet-talk-animation). Metinde ayrıştırılan benzersiz klip adı: **182**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm09"></a>
#### ANM09 — [Animation Pack - Idles](https://mocapcentral.com/products/mocap-studio-series-idles-pack)

Idles: listede 238; Breathe, Tired, ShiftL/ShiftR, Cold_Loop ve kollar bağlı/duvara yaslanma. Sigara/modern tabela elenir. Cold_Loop ayakta; soğukta yürüyüş veya ateşe el uzatma değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 54.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **9/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 1 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0449. **Uyarlama:** İHT-0444, İHT-0401.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %16.4 = 39/238 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/idles-pack-animation-list). Metinde ayrıştırılan benzersiz klip adı: **238**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm10"></a>
#### ANM10 — [Animation Pack - Longsword Vol.1](https://mocapcentral.com/products/animation-pack-longsword-vol-1)

Longsword 1: 180 pazarlama klibi; üçlü saldırı, death, Challenge/Taunt, yürüyüş ve idle. HEMA uzun kılıç tutuşu Anadolu silahına uyarlanmalı; kabzaya uzanma birebir kanıtlanmıyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 89.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 2 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0460, İHT-0429. **Uyarlama:** İHT-0455, İHT-0456.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %13.7 = 24/175 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/longsword-vol-1-animation-list). Metinde ayrıştırılan benzersiz klip adı: **175**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm11"></a>
#### ANM11 — [Animation Pack - Longsword Vol.2](https://mocapcentral.com/products/animation-pack-longsword-vol-2)

Longsword 2: gelişmiş Ox/Side/Plow guard, saldırı ve locomotion listesi. Bekçi sorgusuna göre fazla kapsamlı ve pahalı; yakın dövüş/tehdit için sınırlı aday.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 139.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 2 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0460, İHT-0429. **Uyarlama:** İHT-0455.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %8.5 = 36/423 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/longsword-vol-2-animation-list). Metinde ayrıştırılan benzersiz klip adı: **423**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm12"></a>
#### ANM12 — [Animation Pack - Play Lute](https://mocapcentral.com/products/mocap-studio-series-play-lute-pack)

Play Lute: listede 11 klip; 3 yerinde çalma, 3 gezerek, 2 danslı, 2 geçiş, 1 selam. Kopuz modeli/eliyle birebir aynı değil. Ana listede bard çalma mekaniği yok; sırf uygun dönem diye ihtiyaç eklenmedi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 24.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0 doğrudan ihtiyaç teması: 11 çalma/geçiş klibi var; bard çalma teslimi ana listede istenmiyor.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/play-lute-animation-list). Metinde ayrıştırılan benzersiz klip adı: **11**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm13"></a>
#### ANM13 — [Animation Pack - Sample | FREE](https://mocapcentral.com/products/mocap-studio-series-sample-pack-free)

Sample Free: 120+ pazarlama klibi; listede Talk_05_Generic, LookAround, ScratchArm ve çok sayıda fantastik/komedi/modern örnek. Tam ücretli paketlerin kapsamı ücretsiz örneğe verilmedi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 1 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0401. **Uyarlama:** İHT-0444, İHT-0445.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %2.3 = 3/129 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/sample-animation-list). Metinde ayrıştırılan benzersiz klip adı: **129**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm14"></a>
#### ANM14 — [Animation Pack - Seated](https://mocapcentral.com/products/mocap-studio-series-seated-pack)

Seated: 250+ oturma/masa klibi; sandalyeye geçiş, sohbet, yeme. Telefon/ofis sandalyesi elenir. Otur-kalk talebine aday; ayakta konuşma ve köy mobilyası teslim etmez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 74.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0451.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %73.8 = 192/260 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/seated-animation-list). Metinde ayrıştırılan benzersiz klip adı: **260**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm15"></a>
#### ANM15 — [Animation Pack - Village Life](https://mocapcentral.com/products/animation-pack-village-life)

Village Life: ürün 314, açılan listede 295 ad; KneesBeg, CarryBasket, CarryInArms, CarryOnBack, Scythe_Cut, Rake_Hoe. Sırt taşıma ve dizde yalvarma güçlü; tırpan orak değildir, sepet taşıma koruyucu sarılma değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 79.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MoCap Central**.
- Biçim: FBX raw + Unity/UE; 30 FPS, klip listesi ayrı açıldı. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **10/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 5 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0452, İHT-0525, İHT-0532, İHT-0531, İHT-0445. **Uyarlama:** İHT-0459, İHT-0533.
- Pakette kullanılabilir oran: Doğrulanmış adlarla ilk seçki alt sınırı: %26.8 = 79/295 benzersiz klip adı. Diğer klipler otomatik uygunsuz değildir; el/ayak teması ve gerçek oyun kabulü ölçülmedi.
- Ayrı açılan [tam klip listesi](https://mocapcentral.com/pages/village-life-animation-list). Metinde ayrıştırılan benzersiz klip adı: **295**. Ürün başlığıyla sayı farkı varsa sürüm farkı çözülmeden büyük sayı esas alınmaz.

<a id="anm16"></a>
#### ANM16 — [Carnegie Mellon University - CMU Graphics Lab - motion capture library](http://mocap.cs.cmu.edu/)

CMU:2605trial,6kategori23altkategori;ASF/AMC/C3D,haricîBVH dönüşümleri. Ticari bitmiş ürüne izin,hamveri yeniden satılamaz;CC0değil. Parmaklar gerçek yakalanmıyor,el/ayak gürültüsü var;tamdosya taraması yapılmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K CMU özel ücretsiz izin**.
- Biçim: ASF/AMC/C3D; BVH haricî dönüşüm. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0450, İHT-0524. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="anm17"></a>
#### ANM17 — [Kaynak](https://actorcore.reallusion.com/3d-motion?asset=studio-mocap-city-life)

ActorCore City Life:travel/chat/walk/interaction yanında telefon;99USD,FBX/BVHticari. İsimli altklipler uygulamada;moderntelefonlar elenir,genelkonuşma/yürüme kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Reallusion Standard**.
- Biçim: FBX, BVH. Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0445, İHT-0524. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="anm18"></a>
#### ANM18 — [Getting Started: Rokoko Studio Motion Library – Rokoko](https://support.rokoko.com/hc/en-us/articles/4410021327121-Getting-Started-Rokoko-Studio-Motion-Library)

Rokoko Motion Library:güncel destek sayfası binlerceklip,ücretsizörnekler ve3–20USD/klip. FBXyalnıziskelet;gövde dahil değil. Hesap/Studioiçinde ad ve lisans seçimi gerekir;belirli ısınma/yağmur klibi bulunmuş sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: ? (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Rokoko; klip lisansı ayrıca**.
- Biçim: FBX (iskelet hareketi). Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı.
- Stil/uyum: Mocap; retarget, el/ayak teması ve tarihî eşya tutuşu; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Hayvan: ürün notları


<a id="hyv01"></a>
#### HYV01 — [LowPoly Animated Animals](https://quaternius.itch.io/lowpoly-animated-animals)

Quaternius eski Animated Animals: 6 hayvan ve Death/Idle/Jump/Run/Walk. Tür adları metinde yok; pig/pug etiketleri koyun/at kanıtı değil. QAL çelişkisi ayrıca duruyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **4/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv02"></a>
#### HYV02 — [Animals Asset Pack](https://styloo.itch.io/animals)

Styloo Animals: köpek, kedi, tavuk, inek, zürafa, kelebek, uğurböceği. Köpekte idle/attack/run/walk, inekte walk/idle. FBX var; GLB açıklaması şüpheli, sonraki günlük düzeltildi diyor. Kangal görünümü uyarlama ister.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 0 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0383, İHT-0403.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv03"></a>
#### HYV03 — [Farm animals set](https://vertexcat.itch.io/farm-animals-set)

Vertexcat Farm: ördek 672, tavuk 536, inek 896, domuz 866, koyun 800 üçgen; vertex renk. Rig/klip beyanı yok. Koyun/inek meshine aday, sürü otlama animasyonu teslim etmez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0380, İHT-0403. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv04"></a>
#### HYV04 — [Free Wild Animal 3D Models](https://free-game-assets.itch.io/free-wild-animal-3d-low-poly-models)

Free Wild Animal: kurt, ayı, geyik, domuz, baykuş, tilki, tavşan, sincap, kirpi; FBX+PNG. Sayfa 10 derken metin 9 tür sayıyor. Kurt yürüyüş/kaçış klibi doğrulanmadı; Craftpix özel lisansı ayrıca okunmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Craftpix; koşullu**.
- Biçim: FBX, PNG. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0409. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv05"></a>
#### HYV05 — [Amir - Low-Poly Horses Pack](https://ahmedamirdev.itch.io/amir-low-poly-horses-pack)

Amir Horses: Free 4 renk, Idle/Walk/Run; FBX/glTF ve yaklaşık 2–4 bin üçgen. Plus 17 renk ve 3 eyer 4.99 USD; Source 5.99 USD. Dört renk dört farklı tür değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ücretsiz ticari izin**.
- Biçim: FBX, glTF, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 0 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0379, İHT-0404.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv06"></a>
#### HYV06 — [PSX Animals: Horses](https://mcsteeg.itch.io/psx-animals-horses)

MCSteeg Horses: 1 at, 3 renk, 2 idle, walk/run/rear; eyer ve yular, FBX/GLB/Blend/PSD. PSX düşük çözünürlük, boyalı köy malzemesine yaklaştırılmalı. Şahlanan at binici klibini sağlamaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 2.50 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MCSteeg**.
- Biçim: FBX, GLB, PSD. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 1 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0529. **Uyarlama:** İHT-0379, İHT-0404.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv07"></a>
#### HYV07 — [Animated Low Poly Animals](https://acornbringer.itch.io/assets-animated-low-poly-animals)

Acorn Animals: kuş, arı, kelebek, ispinoz, ateşböceği, balık, kurbağa, su böceği, kaplumbağa; 3–13 klip/tür. İstenen at/koyun/keçi/deve/köpek/kurt yok; yeni mekanik icat edilmez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 2 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ürün lisansı görünmedi**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **3/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv08"></a>
#### HYV08 — [Gobkit Free Animal Pack Vol.1 — Rigged Low-Poly Creatures (CC0)](https://gobkit.itch.io/gobkit-free-animal-pack)

Gobkit: 10 GLB; fenerbalığı, yarasa, corgi, ördek, suaygırı, denizanası, ornitorenk, Red, gergedan, köpekbalığı. Tüm hareketler tek 120 karelik track; dört parçaya bölünmeli. Corgi Anadolu bekçi köpeği değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: GLB. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0383. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv09"></a>
#### HYV09 — [Low Poly Animals](https://mordrag.itch.io/low-poly-animals)

Mordrag Animals: Blend teslimi ve CC0 var, fakat yazılı tür/rig/klip listesi yok. Hayvan adı tahmin edilmedi; kapsama sıfır, tedarik öncesi içerik dökümü istenir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv10"></a>
#### HYV10 — [PSX Animals: Farm Pack](https://mcsteeg.itch.io/psx-animals-farm-pack)

MCSteeg Farm: 4 model, hepsinde idle/walk, FBX/GLB ve PSD. Tür adları metinde yok; önizleme adını dosya listesi yerine uydurmadım. Sürü otlama ihtiyacı doğrulanmıyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 2.50 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K MCSteeg**.
- Biçim: FBX, GLB, PSD. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **4/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv11"></a>
#### HYV11 — [SI - Animated Farm Animals Pack](https://sheepintry.itch.io/si-animated-farm-animals-pack)

SI Animated Farm: koyun/kuzu 33, keçi/oğlak 37, inek/buzağı 33, at/tay 41 klip; ayrıca domuz/tavuk/ördek ve 62 prop. 80 keçi/84 tavuk sayıları görünüş varyantları. Koç/öküz için cinsiyet ve boynuz ayrıca doğrulanmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 70 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari lisans metni yok**.
- Biçim: FBX. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **8** = 0 tam + 3 kısmi + 5 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0389, İHT-0402, İHT-0405. **Uyarlama:** İHT-0379, İHT-0380, İHT-0381, İHT-0403, İHT-0404.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv12"></a>
#### HYV12 — [Animated Cube Animals - 30 Low Poly Foxes, Wolves, Farm Animals & Big Cats](https://sneznyj.itch.io/cube-animals)

Cube Animals: 30 bloklu tür/varyant, 1180 klip. Farm grubunda inek, koyun, keçi, at, pony, eşek; orman grubunda kurt. Kurt Run/Walk, koyun Eat döngüsü var; koç/öküz yok. Bloklu biçim mevcut köyle ciddi uyarlama ister.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 29.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K royalty-free**.
- Biçim: FBX, GLB, glTF, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 1 kısmi + 6 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0389. **Uyarlama:** İHT-0379, İHT-0380, İHT-0381, İHT-0403, İHT-0404, İHT-0409.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv13"></a>
#### HYV13 — [Low Poly Farm Animal Pack — 12 Cows, Pigs, Chickens & Livestock](https://akochan-lu.itch.io/low-poly-farm-animals-pack-12)

Akochan Farm: 12 statik tür, inek/koyun/at açık; FBX/GLB/OBJ, ortalama 5999 üçgen, ortak atlas. Rig/animasyon belirtilmedi; mesh için kısmi aday.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K royalty-free**.
- Biçim: FBX, GLB, glTF, OBJ. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 4 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0379, İHT-0380, İHT-0403, İHT-0404. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv14"></a>
#### HYV14 — [Low World - Forest Animals Kit - Rigged & Animated](https://silver-delivery.itch.io/low-world-forest-animals-kit-rigged-animated)

Low World Forest: 8 rigli mesh; kurt 1556 yüz, 36 toplam klip. Kurtta idle/walk/run/sleep/attack açık; GLB ve Godot teslimi. Tek atlas. Lisans sorusuna açık şart teyidi gerekiyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans teyidi gerekli**.
- Biçim: FBX, GLB, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0409.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv15"></a>
#### HYV15 — [Low Poly PSX Forest Animals v1.2 update!](https://puszke.itch.io/low-poly-ps1-forest-animals)

PS1 Forest: geyik, karaca, tilki ve üç kurt; güncellemeyle kuş/sincap. Rigli FBX/Blend; belirli walk/run klibi listelenmemiş, kurt grubu kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans metni yok**.
- Biçim: FBX, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0409. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="hyv16"></a>
#### HYV16 — [Dylan — Low Poly Camel](https://sketchfab.com/3d-models/low-poly-camel-e2571167e3d846e59769b61913f1de64)

Dylan Low Poly Camel:4.2bin üçgen/2.3binvertex,indirilebilir CC Attribution. Rig/klip belirtilmedi; kervan devesi meshine kısmi aday. Sketchfab sayfası açıldı; kaynak indirme biçimi hesap akışında teyit edilmeli.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY; sürüm teyidi gerekli**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Low-poly/stilize; tür ve klip ayrı kabul; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0382. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Eşya: ürün notları


<a id="esy01"></a>
#### ESY01 — [KayKit : RPG Tools Bits](https://kaylousberg.itch.io/rpg-tools-bits)

RPG Tools Bits: 45+ ücretsiz model içinde çekiç, balta, kazma, tokmak, örs, el aletleri; 20 ek balıkçılık/kilit açma parçası ücretli. İngiliz anahtarı ve modern fener elenir; fırın küreği/orak doğrulanmıyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 4 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0388, İHT-0395, İHT-0400, İHT-0430. **Uyarlama:** İHT-0342, İHT-0384.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy02"></a>
#### ESY02 — [KayKit : Furniture Bits](https://kaylousberg.itch.io/furniture-bits)

Furniture Bits: 50+ ücretsiz mobilya; tam ad listesi metinde yok, modern eşya ayrımı gerekli. Tek başına tarihî yatak/kütüphane teslim edildi sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 4 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0413, İHT-0414, İHT-0418, İHT-0420. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy03"></a>
#### ESY03 — [KayKit : Resource Bits](https://kaylousberg.itch.io/resource-bits)

Resource Bits: 75+ ücretsiz ahşap, taş, demir, bakır, gümüş, altın, kumaş, yakıt; para/gıda/kaplar Extra 4.99 USD. Kaynak yığını ham blok olabilir; işlenmiş beş demircilik aşaması aynı şey değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 1 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0439. **Uyarlama:** İHT-0350.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy04"></a>
#### ESY04 — [KayKit : Fantasy Weapons Bits](https://kaylousberg.itch.io/fantasy-weapons-bits)

Fantasy Weapons Bits: kılıç, balta, çekiç, yay, asa, kalkan, mızrak. Ücretsiz alt sınır 25+, pazarlama toplamı 40+; büyülü/elemental silahlar elenir. El soketi ve ölçü uyarlaması gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 1 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0387. **Uyarlama:** İHT-0348, İHT-0406, İHT-0407.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy05"></a>
#### ESY05 — [KayKit : Restaurant Bits](https://kaylousberg.itch.io/restaurant-bits)

Restaurant Bits: 140+ pişirme/gıda modeli; çiğ/pişmiş/doğranmış durumlar. Modern mutfak aletleri nedeniyle dönem seçimi gerekli; özgül CHR hediyesi veya fırın yapısı listesi yok, numaralı ihtiyaç kapanmıyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy06"></a>
#### ESY06 — [KayKit : Board Game Bits](https://kaylousberg.itch.io/board-game-bits)

Board Game Bits: Free 75+ benzersiz/162 renkli model; para, piyon, zar, kart ve satranç. Modern iskambil ve fantastik zarlar elenir; proje ihtiyacı kişiye özel mühür/hediye olduğundan doğrudan eşleşme yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: FBX, glTF, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0421. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy07"></a>
#### ESY07 — [Ultimate Furniture Pack](https://quaternius.com/packs/ultimatefurniture.html)

Ultimate Furniture: 20 model; yatak, sandalye, masa adları açık. Tarihî malzeme ve rahat/standart yatak ayrımı uyarlama ister; koltukları divan sırası saymadım.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 0 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0413, İHT-0414, İHT-0418.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy08"></a>
#### ESY08 — [Furniture Pack](https://quaternius.com/packs/furniture.html)

Furniture eski paket: 23 model; yatak, sandalye, masa. Ultimate ile ayrı model ailesi, iki kez satın alma gerekmez. Dönem dışı mobilya ayıklanmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 0 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0413, İHT-0414, İHT-0418.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy09"></a>
#### ESY09 — [Modular Weapons Pack](https://quaternius.com/packs/medievalweapons.html)

Modular Weapons: 24 model; kılıç, hançer, yay, kalkan, çekiç. Mızrak ve meşale bu metinde doğrulanmıyor; silah grubu kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 1 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0387. **Uyarlama:** İHT-0406.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy10"></a>
#### ESY10 — [Ultimate RPG Pack](https://quaternius.com/packs/ultimaterpg.html)

Ultimate RPG: 106 model ve her modelin PNG renderı; tek tek eşya adları/portre karşılıkları açıklanmamış. Paket adıyla 106 ihtiyacı kapatmak mümkün değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend, PNG. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy11"></a>
#### ESY11 — [RPG Essentials Pack](https://quaternius.com/packs/rpg.html)

RPG Essentials: 13 model; kısa tanımın dışında ad listesi yok. Torba, heybe veya envanterin belirli nesnesi teyit edilemedi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy12"></a>
#### ESY12 — [Ultimate Food Pack](https://quaternius.com/packs/ultimatefood.html)

Ultimate Food: 103 yiyecek/tüketim modeli. Belirli tarihî CHR ipucu ve kişisel hediyelerin listesiyle birebir eşleşme yok; kahraman nesne yerine kullanılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **4/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy13"></a>
#### ESY13 — [Ultimate Crops Pack](https://quaternius.com/packs/ultimatecrops.html)

Ultimate Crops: 102 model, beş büyüme evresi. Tarla/bostan grubuna bitki sağlar; tarla sınırı, sürülmüş zemin ve dönem ürün seçimi ayrı iş.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0359. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy14"></a>
#### ESY14 — [Ultimate House Interior Pack](https://quaternius.com/packs/ultimatehomeinterior.html)

Ultimate House Interior: 123 model; kapı/pencere, mutfak/banyo. Modern ev kümesi; tarihî ahşap parçalar seçilmeli. Özgül kasa, kütüphane veya yatak modeli adları yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/QAL**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0412, İHT-0413, İHT-0414. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy15"></a>
#### ESY15 — [Lowpoly PBR Stone Well](https://slaviandr.itch.io/lowpoly-pbr-stone-well)

Stone Well: 998 üçgen, 1024² renk/normal/pürüz haritaları; FBX/OBJ/Blend. Tek kuyu, oyun kuyusu geometrisine iyi aday; lisans yazılmadığı için önerilen lisanslı sete giremez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans yok**.
- Biçim: FBX, OBJ, Blend. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0425.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy16"></a>
#### ESY16 — [Sorry, you have been blocked](https://www.gamedevmarket.net/asset/medieval-stylized-3d-props)

GameOver Medieval Stylized Props:66 mesh; örs,çekiç,balta,kova,un torbası,sandık,masa,sıra,meşale,kuyu,ahşap parçalar. FBX/PNG ve30bonusSFX; sikke/testere/demirci sesleri.20USD ProLicence; kabak/karpuz gibi dönem dışı ürünler seçilmez.

- Kaynak durumu: Web aracı açıldı; doğrudan HTML 403; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 20 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K GDM Pro**.
- Biçim: FBX, PNG; bonus SFX biçimi belirtilmemiş. Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **9/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **17** = 0 tam + 8 kısmi + 9 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0388, İHT-0395, İHT-0400, İHT-0408, İHT-0410, İHT-0421, İHT-0479, İHT-0485. **Uyarlama:** İHT-0340, İHT-0342, İHT-0347, İHT-0350, İHT-0384, İHT-0414, İHT-0415, İHT-0424, İHT-0425.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="esy17"></a>
#### ESY17 — [Medieval Props Pack](https://www.fab.com/listings/b491e76d-36f1-4c41-b3a4-7eb3889a92d6)

Meshingun Medieval Props:90+asset; kılıç,kalkan,mızrak,yiyecek,crate,çit,ateş çukuru,sandalye. UE-only mağaza biçimi; hamFBX/ihracat doğrulanmalı. MedievalVillageMegapack içinde benzer içerik olduğundan iki alım yapılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: ? (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Fab lisans seçimi boş**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli.
- Stil/uyum: Low-poly/stilize; tarihî malzeme ve el soketi seçimi; **7/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0387, İHT-0407, İHT-0410. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### UI: ürün notları


<a id="ui01"></a>
#### UI01 — [Fantasy UI User Interaface](https://toffeecraft.itch.io/fantasy-ui-user-interaface)

Toffee Fantasy UI: 32×32 piksel, bütün öğeler tek sayfada; ticari değiştirme izni, ham paylaşım yasağı. Dört buton hali,9-slice ve hedef çözünürlükler ayrı doğrulanmamış.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ToffeeCraft**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **4/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0287. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui02"></a>
#### UI02 — [UI User Interface MEGA PACK](https://toffeecraft.itch.io/ui-user-interface-mega-pack)

Toffee UI Mega: retro, medieval, horror, cyber, magic, cozy vb temalar;32×32. Free yalnız kişisel, ücretli sürüm ticari; bütün koleksiyonu ücretsiz oyun lisansı sanma. Tekil parça listesi eksik.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 2.40 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ücretli; Free kişisel**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0287, İHT-0293. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui03"></a>
#### UI03 — [UI User Interface Pack - Medieval - Mega Version](https://toffeecraft.itch.io/ui-user-interface-pack-medieval)

Toffee Medieval Pack:32×32 tek sprite sayfası, ticari değiştirme izni. Boyanmış demir/ahşap panel için doğrudan teslim değil; buton ve panel kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ToffeeCraft**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **4/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0287. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui04"></a>
#### UI04 — [UI User Interface Pack - Medieval](https://toffeecraft.itch.io/ui-user-interface-medieval)

Toffee Medieval UI:32×32, son güncelleme Dragon HP bar. Ejderha süsü elenir; dört hal geometrisi ve köşeler teyitsiz. Genel panel/bar tabanı kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ToffeeCraft**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0305. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui05"></a>
#### UI05 — [UI User Interface Mini Medieval Fantasy Pack](https://toffeecraft.itch.io/ui-user-interface-mini-medieval-fantasy-pack)

Toffee Mini Medieval:32×32 tek sayfa;Free kişisel, Paid ticari. Öğelerin tam listesi yok; sadece genel panel/buton kaynağı adayı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 1.90 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ücretli; Free kişisel**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0287. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui06"></a>
#### UI06 — [Dark Ages UI - Pixel Art Asset Pack](https://hypnobius.itch.io/dark-ages-ui)

Dark Ages UI:25 öğe,4 menü çerçevesi autotile, normal/hover buton, scrollbar/statbar,4 küçük ikon ve süs. PNG32×32;pressed/disabled belirtilmiyor. Ticari izni var, ham paylaşım yasak.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Hypnobius**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **12** = 0 tam + 9 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0289, İHT-0290, İHT-0293, İHT-0303, İHT-0304, İHT-0307, İHT-0308, İHT-0331, İHT-0334. **Uyarlama:** İHT-0286, İHT-0287, İHT-0288.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui07"></a>
#### UI07 — [6000 Fantasy Icons](https://poneti.itch.io/6000-fantasy-icons)

Poneti6142:elle boyalı256²PNG;1170meslek/üretim,1715skill,1019silah,1047zırh,500medieval,105yapımalzemesi,537avatar. Büyü/ork/undead elenir;wood/stone/metal/roof/bench sınıfı açık, özgünCHRportreleri değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; AI eğitimi yasak**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 2 kısmi + 3 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0321, İHT-0323. **Uyarlama:** İHT-0317, İHT-0318, İHT-0319.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui08"></a>
#### UI08 — [5600+ Ultimate Pixel Art Fantasy RPG Icon Pack](https://clockworkraven.itch.io/5600-ultimate-pixel-art-fantasy-rpg-icon-pack)

Clockwork5616:tekil PNG+sheet;malzeme, araç, kürek, kumsaati, odun, deri, cevher vb. Renk varyantları benzersiz nesne sayılmaz;pixel stili boyalı ikonla aynı değil. Özel ticari izin.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 20 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Clockwork Raven**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 3 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0198, İHT-0321, İHT-0328. **Uyarlama:** İHT-0317, İHT-0319.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui09"></a>
#### UI09 — [Free Medieval Fantasy UI Pack](https://kibyra.itch.io/free-medieval-fantasy-ui-pack)

Kibyra208:32×32/64×32 saydamPNG, düğme, menü, ikon, HUD/dekor. Ücretsiz ticari amaCC0değil;tekil dört buton hali ve9-slice listesi yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ücretsiz ticari**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **5/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0287, İHT-0293. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui10"></a>
#### UI10 — [Assets: UI RPG Game Interface [Lite Version]](https://wenrexa.itch.io/werdanta03)

Werdanta03:59 saydamPNG ve katmanlı düzenlenebilirPSD;ikon, pencere, switch, panel, bar, menü. MetadataCC0,4.35USDkampanya. Tarihîmalzemeye uyarlama;aktif buton hallerini varsaymadım.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 4.35 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: PNG, PSD. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 4 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0299, İHT-0300, İHT-0305, İHT-0306. **Uyarlama:** İHT-0286, İHT-0293.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui11"></a>
#### UI11 — [Fantasy Game UI + icon collection](https://sungraphica.itch.io/fantasy-game-ui-and-icon-collection)

SunGraphica:244altınikon+UI;menü/ayar/mapselector/itemselector/quest. PNG720p/1080p/4K, ikon128–1024;EPS/AI/PDFkaynak. SunGraphicaatıfveözel ticari izin, parlakaltın yeniden boyanmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K SunGraphica atfı**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 5 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0284, İHT-0286, İHT-0291, İHT-0292, İHT-0337. **Uyarlama:** İHT-0293.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui12"></a>
#### UI12 — [Fantasy RPG UI Kit — Free](https://anastasiiakud.itch.io/fantasy-game-ui-rpg)

Anastasiia FantasyRPG:87MBZIP, AI-assisted grafik. Açıklama/içerik/lisans yazılı değil;resimden bütün öğeleri ve hakları uydurmadım. Kapsama sıfır.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans ve içerik yok**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui13"></a>
#### UI13 — [Free Fantasy Game GUI](https://pzuh.itch.io/free-fantasy-game-gui)

PzUH FantasyGUI:40++buton, pencere/ikon;CDR, SVG, saydamPNG. Yazar ticari kullanıma yorumda izin veriyor;dört butonhali ve9-slice özel hüküm yok. Renk değiştirmeye uygun vektör taban.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K yazar ticari izni; koşullu**.
- Biçim: PNG, SVG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 5 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0286, İHT-0288, İHT-0289, İHT-0290, İHT-0293. **Uyarlama:** İHT-0287.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui14"></a>
#### UI14 — [Pixel Adventure Book UI: Fantasy RPG Kit](https://indigolay.itch.io/pixel-adventure-book-ui-fantasy-rpg-kit)

PixelAdventureBook:183öğe;72UI,96ikon, kalan sayfa bileşenleri.17buton,21control,4panel,8tab;9-slice uygulanmış;PNGkaynak9USDmetni/9.99USDödeme çelişkisi. Unityscript Godot’a taşınmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham paylaşım yasak**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **14** = 0 tam + 12 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0287, İHT-0288, İHT-0289, İHT-0290, İHT-0297, İHT-0298, İHT-0299, İHT-0300, İHT-0301, İHT-0302, İHT-0303, İHT-0304. **Uyarlama:** İHT-0286, İHT-0293.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui15"></a>
#### UI15 — [Fantasy Map Assets Pack Lite](https://amanz.itch.io/fantasy-map-assets-pack-lite)

FantasyMapLite:paperbase, overlay, topography/water, brush, buildingicons, island/mountain/tree, PSD.512–3840px;CC-BY4. Özgün oyun haritası değil, birleştirme tabanı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Amanz**.
- Biçim: PSD. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0284. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui16"></a>
#### UI16 — [notoserif](https://github.com/google/fonts/tree/main/ofl/notoserif)

Noto Serif: OFL1.1 ve resmî METADATA latin-ext doğrulandı. Değişken TTF, sade/okunaklı gövde alternatifi; gerçek Türkçe glif ve küçük ölçü testi yapılmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **O OFL1.1**.
- Biçim: TTF; resmî METADATA/OFL metni açıldı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **9/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0519.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui17"></a>
#### UI17 — [ebgaramond](https://github.com/google/fonts/tree/main/ofl/ebgaramond)

EB Garamond: OFL1.1, Latin-ext ve normal/italik değişken TTF; uzun metne edebî alternatif. Mevcut Alegreya ile birlikte üç gövde fontu karıştırılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **O OFL1.1**.
- Biçim: TTF; resmî METADATA/OFL metni açıldı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0519.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui18"></a>
#### UI18 — [crimsonpro](https://github.com/google/fonts/tree/main/ofl/crimsonpro)

Crimson Pro: OFL1.1, Latin-ext, 200–900 ağırlık normal/italik TTF. Panel açıklamasında okunaklı aday, oyun fontu değiştirilmedi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **O OFL1.1**.
- Biçim: TTF; resmî METADATA/OFL metni açıldı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0519.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui19"></a>
#### UI19 — [almendra](https://github.com/google/fonts/tree/main/ofl/almendra)

Almendra: OFL1.1, Latin-ext; süslü tarihî başlık ailesi. Uzun diyalogta değil, tek başlık ailesi olarak denenmeli.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **O OFL1.1**.
- Biçim: TTF; resmî METADATA/OFL metni açıldı. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0520.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ui20"></a>
#### UI20 — [Metal 032](https://ambientcg.com/view?id=Metal032)

ambientCG Metal032: gri/düz prosedürel PBR, 1K–8K PNG/JPG haritalar. CC0 açık; demirin albedosuna aday, el boyaması ve eskime izi için uyarlama gerekiyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: PNG. Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli.
- Stil/uyum: 2D; piksel/boyalı/vektör/font ayrımı içerik notunda; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0198.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### VFX: ürün notları


<a id="vfx01"></a>
#### VFX01 — [Brackeys' VFX Bundle](https://brackeysgames.itch.io/brackeys-vfx-bundle)

Brackeys VFX: Kenney/Picster/Thomas Iché/CodeManu kaynaklarından dokular, flipbook ve spritesheet; CC0 ve Godot örneği. Alt listesi sayfada yok; duman/kıvılcım şekli tek tek doğrulanmadan hepsi tam sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0155, İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx02"></a>
#### VFX02 — [Particle FX](https://ragnapixel.itch.io/particle-fx)

Particle FX: 73 FX, ateş/kıvılcım/yağmur/duman/sıçrama; PNG kare/sheet ve GIF, 64–150 px. Elektrik/roket/büyü elenir; piksel kenarlar gece kapısı boyasına uyarlanmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Raphael Hatencia**.
- Biçim: PNG, GIF. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 0 kısmi + 5 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0150, İHT-0154, İHT-0155, İHT-0157, İHT-0158.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx03"></a>
#### VFX03 — [Smoke FX](https://jasontomlee.itch.io/smoke-fx)

Smoke FX: sheet/ASE/GIF; duman, ticari değiştirme izni. Sayı ve çözünürlük metinde yok; çizgi platform oyunu stilinde, isli atmosfer için kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K özel ticari**.
- Biçim: ASE, GIF. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx04"></a>
#### VFX04 — [1000 Free Game Assets](https://kronbits.itch.io/particle-pack)

Kronbits Particles: 1000 adet 512² parçacık, CC0. Kategori/tekil şekil listesi yok; hepsine yağmur/kar işlevi atamak doğru değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0155, İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx05"></a>
#### VFX05 — [Textures for particles 3](https://jellyfish0.itch.io/textures-for-particles-3)

Jellyfish Textures 3: 30 adet 512², siyah zemin. Alfa yok; additive/maske çıkarma gerekir. Ticari izin açık değil, ham paylaşım yasak; güvenilir sete giremez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari kullanım açık değil**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **4/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0156, İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx06"></a>
#### VFX06 — [Particle FX - Smoke](https://ragnapixel.itch.io/particle-fx-smoke)

Particle FX Smoke: 46 adet 64² duman, loop ve tek seferlik; bazıları patlama/dash içindir. PNG/ASE/GIF; döngülü sakin duman seçilmeli.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Raphael Hatencia**.
- Biçim: PNG, ASE, GIF. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0157.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx07"></a>
#### VFX07 — [Particle FX - Ice/Snow](https://ragnapixel.itch.io/particle-fx-ice-snow)

Particle FX Ice/Snow: 12 efektin 5'i kar, 7'si buz büyüsü. Yalnız 5/12 (%41.7) dönem bakımından aday; PNG/ASE/GIF. Buz büyüsü oyuna alınmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 1.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Raphael Hatencia**.
- Biçim: PNG, ASE, GIF. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0153.
- Pakette kullanılabilir oran: %41.7 = 5/12: kar efektleri aday; yedi buz büyüsü elendi. Godot kabul oranı değil.

<a id="vfx08"></a>
#### VFX08 — [Particle Effect Texture Essentials](https://reactorcore.itch.io/particle-effect-texture-essentials)

Texture Essentials: 699 benzersiz 512² gri doku, üç çıktı biçimiyle 2097 dosya; ateş, duman, sis, kıvılcım vb. Godot 4 örneği var. 20 katalog sayfası arşivde; oranı 2097 üzerinden hesaplamak hatalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari lisans ayrıca**.
- Biçim: FBX, BVH. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 5 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0150, İHT-0151, İHT-0155, İHT-0156, İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx09"></a>
#### VFX09 — [Cartoon Comic FX Pack](https://laplahce.itch.io/cartoon-fx-pack)

Laplahce Cartoon FX: itch bağlantısı PC demo; Unity URP tam ürün 40+ FX, 60+ doku, VFX Graph ve shader. Demo çalıştırılabilir dosya kaynak asset değildir; tekliften elendi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: ? (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Demo; asset lisansı doğrulanmadı**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **1/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0 önerilen kullanım: demo/motor bağımlılığı ve görsel hedef nedeniyle elendi.

<a id="vfx10"></a>
#### VFX10 — [Ultimate Cartoon VFX MEGA PACK - Unity Prefabs](https://cartooncoffee.itch.io/ultimate-cartoon-vfx-mega-pack)

CartoonCoffee Mega: Unity particle prefab, anime odaklı; 98 USD indirim/200 liste. Modern/fantastik gösteriş ve Unity shader bağımlılığı yüzünden gece kapısına uygun değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 98 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K CartoonCoffee**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0 önerilen kullanım: demo/motor bağımlılığı ve görsel hedef nedeniyle elendi.

<a id="vfx11"></a>
#### VFX11 — [Cartoon VFX Essentials - Unity Prefabs](https://cartooncoffee.itch.io/cartoon-vfx-deluxe-demo)

CartoonCoffee Essentials: Unity prefab + kılıç slash bonusu. PNG/Godot teslimi değil; ham dokular ve lisans izin verse bile efekt yeniden kurulacak. Kaynak kapsamı açık değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 59.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K CartoonCoffee**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0 önerilen kullanım: demo/motor bağımlılığı ve görsel hedef nedeniyle elendi.

<a id="vfx12"></a>
#### VFX12 — [Retro Particles & Lens Flares for Unreal Engine](https://marcis.itch.io/retro-particles-lens-flares)

Retro Particles: 46 Niagara, 15 lensflare ve 71 doku; rain/snow/fire/sparks var. UE paketi ve 1-bit alfa; motor efekti Godot'ta doğrudan çalışmaz, lensflare gece kapısı hedefi değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 29.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ürün şartı ayrıca**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 4 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0153, İHT-0154, İHT-0155, İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx13"></a>
#### VFX13 — [Smoke Particles](https://kenney.nl/assets/smoke-particles)

Kenney Smoke: 70 adet 2D duman/parçacık dosyası; basit ve CC0. Kaynak doku olarak kullanılabilir; Godot'ta emitter/renk ve alfa kurulumu ayrı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0157. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx14"></a>
#### VFX14 — [Particle Pack](https://kenney.nl/assets/particle-pack)

Kenney Particle: 80 dosya, 512². Genel parçacık dokusu; tüm hava olayları için hazır sahne diye sayılmaz. Şekil bazlı seçim gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0155, İHT-0158. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="vfx15"></a>
#### VFX15 — [Light Masks](https://kenney.nl/assets/light-masks)

Kenney Light Masks: 150 ışık maskesi; meşale ışığı lekesine kaynak, gerçek ışık/alev animasyonu veya duman değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: PNG ise doku/atlas; Unity/Niagara/shader sahnesi Godot 4’te doğrudan çalışmaz.
- Stil/uyum: Parçacık/flipbook; piksel/gerçekçi ve motor farkı; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0151. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Ortam sesi: ürün notları


<a id="ort01"></a>
#### ORT01 — [Ambiences and Perspectives SFX](https://leohpaz.itch.io/ambiences-perspectives-sfx)

Ambiences Perspectives: 56 ses; Night Inside/Outside, Rain Roof/Forest, Wind ve River ayrı katman/perspektifler. Lava/horror/sea parçaları elenir; köyün kurt/baykuş/çekiç bileşenleri tam değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Leohpaz ticari**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **9/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 4 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0481, İHT-0482, İHT-0483, İHT-0510. **Uyarlama:** İHT-0489, İHT-0490.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort02"></a>
#### ORT02 — [Butterfly - Looped Ambience Sounds Pack](https://pudretediablo.itch.io/butterfly)

Butterfly Ambience: 14 WAV loop; Bonfire, yağmur, Winter Storm, spring water ve insan konuşmaları. Cafeteria/City gibi çağdaş ortamlar elenir. Ticari lisans soruları var, açık şart teyidi eksik.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari izin teyidi yok**.
- Biçim: WAV, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 6 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0464, İHT-0489, İHT-0490, İHT-0496, İHT-0510, İHT-0512. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort03"></a>
#### ORT03 — [PSX Ambient Pack](https://captnphantom.itch.io/psx-ambient-pack)

PSX Ambient: Blur/Drift/Hollow vb 10 adet altışar dakikalık synth drone. Gerçek köy/doğa ortamı sağlamıyor; soğuk renkli kapak gece ambiyansı kanıtı değil. Ortam kategorisinden elendi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari yorum izni**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **1/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort04"></a>
#### ORT04 — [Minifantasy - Forgotten Plains Audio Pack](https://leohpaz.itch.io/minifantasy-forgotten-plains-sfx-pack)

Minifantasy Forgotten Plains: 37 SFX; dirt/grass/stone adım, water/waterfall, crickets/cicadas/birds/wind, wood/brick vuruşu. İki retro müzik parçası ayrı, tarihî müzik sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Leohpaz**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 5 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0481, İHT-0482, İHT-0483, İHT-0494, İHT-0485. **Uyarlama:** İHT-0471, İHT-0490.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort05"></a>
#### ORT05 — [Free City & Nature Sounds](https://gregor-quendel.itch.io/free-general-ambience-sounds)

General Ambience: 46 field recording, traffic/nature/crowd. Trafik ayıklanmalı, tam ad listesi yok. Nature sözcüğü kurt/baykuş doğrulamaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari kapsam teyidi gerekli**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0496, İHT-0511. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort06"></a>
#### ORT06 — [Fantasy Ambiences - ambience pack](https://cyberleaf.itch.io/fantasy-ambiences)

Fantasy Ambiences: 17 loop/53 dk; Forest Day/Night, Village, Windy Forest, Campfire ve Rain in Town. Astral/Hellish dungeon elenir; köy sesleri kısmi, yağmur/rüzgâr daha doğrudan.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Andrea Baroni**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **9/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **8** = 0 tam + 6 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0464, İHT-0481, İHT-0482, İHT-0483, İHT-0511, İHT-0512. **Uyarlama:** İHT-0489, İHT-0490.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort07"></a>
#### ORT07 — [Audio Elk | Ambience Collection](https://audioelk.itch.io/free-sounds-ambience-collection)

Audio Elk Ambience: alan kayıtları, ham uzun çekimler; CC-BY-SA4. Bu lisans A listesine girmez. Tekil doğal olay listesi yok, kısmi varsayım bile sayılmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **S CC-BY-SA4**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort08"></a>
#### ORT08 — [Fantasy Sound Pack](https://cyrex-studios.itch.io/fantasy-sound-pack)

Cyrex Fantasy: 6 hava ambiyansı +100 oyun/UI/silah sesi. Hava olaylarının adları açık değil; genel hava paketi diye bütün olayları kapatmıyorum.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Nathan Gibson**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0489, İHT-0490. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort09"></a>
#### ORT09 — [Ambiences](https://bleeoop.itch.io/ambiences)

Bleeoop Ambiences: 50 WAV/OGG loop, tam dosya adları var. FIREBurn/Fireplace, RAIN, WIND ve river; tren/fridge/spaceship elenir. Kış/rüzgâr için katman adayları; PDF lisans HTML'de yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR5 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ayrı PDF lisansı**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 3 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0464, İHT-0510, İHT-0512. **Uyarlama:** İHT-0489, İHT-0490.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort10"></a>
#### ORT10 — [Plethora Of Game Sounds](https://ivkrage.itch.io/plethora-of-game-sounds)

Plethora: 146 ses/292 WAV+OGG; natural/room, kâğıt kitap, kumaş, wood/snow adım, kapı, Hammer_Clang. Fridge/keyboard/zipper elenir. Lisans net değil; çok yönlü içerik var ama alım setinde yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans belirsiz**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **6** = 0 tam + 6 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0468, İHT-0469, İHT-0477, İHT-0480, İHT-0485, İHT-0510. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort11"></a>
#### ORT11 — [Ethereal Solitude - SFX Starter Pack Vol.1](https://limen-dev.itch.io/ethereal-solitude-sfx-starter-pack-vol1)

Ethereal Solitude: 59 benzersiz/177 biçim dosyası; 4 rain/river/room ambiyansı,30 adım,25 etkileşim. Grass dışında sneaker/heel/concrete elenir; kâğıt ve gıcırtı kullanışlı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K royalty-free; Limen_dev atfı**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 4 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0468, İHT-0469, İHT-0471, İHT-0477. **Uyarlama:** İHT-0489.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort12"></a>
#### ORT12 — [COTTAGE](https://ambientworlds.itch.io/cottage)

Cottage: 8 uzun OGG yağmurlu/açık gündüz/gece ve birleşik kırsal/şömine ortamı; prosedürel ses. Lisans beyanı yok; atmosfer etiketi tedarik izni değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR2.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans yok**.
- Biçim: OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0464, İHT-0489, İHT-0512. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort13"></a>
#### ORT13 — [Letters & Memories - Royalty Free Ambience and SFX](https://theturtlebox.itch.io/letters-memories)

Letters Memories: 40 synth pad/loop/one-shot, araba motoru da var; CC-BY-SA4 ve sayfa paylaşım ifadeleri çelişkili. Doğal köy ortamı setine alınmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **S CC-BY-SA4; ek ifade çelişkili**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **1/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort14"></a>
#### ORT14 — [Free Water Stream Sounds](https://gregor-quendel.itch.io/free-water-stream-sounds)

Water Streams: 01–10 adlı 10 WAV dere kaydı; CC-BY4. Köy gündüz su katmanını sağlar; çekiç+koyun+su birleşik ortam grubu tam kapanmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Gregor Quendel**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0481. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="ort15"></a>
#### ORT15 — [Cozy SFX Complete — 1,305 Cute Game Sound Effects & Seamless Ambience Loops (Free Lite)](https://aquumgifts.itch.io/cozy-sfx-complete)

Cozy Complete: 1305 ses; 151 farm ve338 UI, güncel Farm 22 Ekim. Free Lite 48 seçki, 1305 ücretsiz değil. Farm tools/crops/workshop, weather/nature ve kapı içerikleri var; özel klip dökümü olmadan geniş gruplar kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 4.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; AI-assisted ses**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Alan kaydı/katmanlı ortam; synth olanlar ayrıca elendi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **9** = 0 tam + 9 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0471, İHT-0477, İHT-0479, İHT-0481, İHT-0485, İHT-0486, İHT-0487, İHT-0489, İHT-0490. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Foley: ürün notları


<a id="fol01"></a>
#### FOL01 — [400 Sounds Pack](https://ci.itch.io/400-sounds-pack)

400 Sounds: 400 WAV, malzeme/wood/metal, adım, insan, kart ve eşya; tamamı Dropbox'ta önizlenebilir. Tekil tarihî kapı/kese/bebek kaydı teyit edilmedi, geniş aileler kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; ham yeniden satış yasak**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 5 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0471, İHT-0477, İHT-0478, İHT-0480, İHT-0485. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol02"></a>
#### FOL02 — [Audio Elk | Foley Sessions Vol. 1](https://audioelk.itch.io/foley-sessions-vol-1)

Foley Sessions 1: 500 benzersiz/1000 iki mikrofon WAV; belt/backpack/gameboy. Yalnız kumaş/deri temasına aday; CC-BY-SA4 nedeniyle A seti dışında.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **S CC-BY-SA4**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0480. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol03"></a>
#### FOL03 — [Foley SFX](https://kronbits.itch.io/foleysfx)

Kronbits Foley: yaklaşık76 WAV ve açık dosya ağacı; mutfak/banyo/mikrodalga/buzdolabı ağırlıklı. Makas/bıçak gibi ham sesler uyarlanabilir; özel envanter ihtiyacı için kanıt yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 12.96 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans metni ayrıca**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol04"></a>
#### FOL04 — [Audio Elk | Foley Sessions - Household Foley Vol. 1](https://audioelk.itch.io/sound-pack-foley-sessions-household-foley-vol-1)

Household Foley1: 86 stereo WAV, tesisat/oda tonları. Modern plumbing tarihî kuyunun sesi değildir; aynı ailenin CC-BY-SA4 şartı var.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **S CC-BY-SA4**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol05"></a>
#### FOL05 — [The Sounds of the Kitchen - FREE Sample Pack](https://amadeusherrera.itch.io/the-sounds-of-the-kitchen)

Sounds of Kitchen: 500+ kapı/çatal-bıçak/pişirme sesi, yazar yorumunda kullanıma izin ve yeniden satış yasağı. Hangi kapı/kâğıt dosyası olduğu yok; metal sürtünmesi kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K yazar yorum izni; koşullu**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0478. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol06"></a>
#### FOL06 — [Charcoal Sample Pack](https://wangleline.itch.io/charcoal-sample-pack)

Charcoal: yanık kömür ve üzerine su kaydı, UCS adları. Oyun/müzikte ticari değiştirme izni. Ocak/yangın katmanı, kapıdaki meşale+rüzgâr birleşimi tam değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; WangleLine**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **9/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0464, İHT-0512. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol07"></a>
#### FOL07 — [Card Sound Effects](https://gravity-sound.itch.io/card-sound-effects)

Card Foley: 103 WAV, 44.1k/16bit; karıştırma, dağıtma, sürme, katlama. Modern iskambilin sertliği parşömenle aynı değil; kâğıt hareketine kısmi aday.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ürün lisansı görünmedi**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0477. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol08"></a>
#### FOL08 — [FOLEY SOUNDS HORROR PACK | 150 foleys and sounds](https://soundsreal.itch.io/horror-sounds-pack-150-free-foleyssounds)

Horror150: açık listede woodcreak/door/chain benzeri fiziksel sesler, ayrıca silah/telefon/monster. Doğal kapı/kâğıt sınırlı; ticari lisans yalnız forum konusu olarak görünüyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari izin net değil**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0468, İHT-0469, İHT-0477. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol09"></a>
#### FOL09 — [Door SFX](https://sound-works-12.itch.io/door-sfx)

Door SFX:120 ses; Wood Door/Dungeon/Chest, ayrıca araba/asansör/fridge. Ahşap açma-kapama adayları, ağır kapı sürgüsü ve bar kırığı ayrıca bulunmalı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 5 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans sorusu açık**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0468, İHT-0469. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol10"></a>
#### FOL10 — [Game Footsteps](https://epicstockmedia.itch.io/game-footsteps)

Game Footsteps:1655 ses,22 yüzey/ayakkabı; dirt/snow/wood/cobblestone. Boot ve sneaker ağırlıklı; çarık/toprak adayını uyarlama ile kapatır. 96k/24 WAV, motor için dönüştürme gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 23.20 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Epic Stock Media; tam EULA teyidi**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0471.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol11"></a>
#### FOL11 — [Footsteps SFX Free - Walk, Run & Sneak Footstep Sampler](https://heyheythere.itch.io/footsteps-sfx-free)

Footsteps Free:30 WAV/OGG; dirt/grass/snow/mud/armour açıkça listeli. CC-BY4; kodla sentez/AI yardımı beyanlı. Lisans uygun ama doğal kayıt kalitesi dinlenmeden kabul edilmez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 heyheythere**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0471.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol12"></a>
#### FOL12 — [Footsteps - Sound Effects Pack](https://nicola-fabro.itch.io/footsteps-sound-effects-pack)

Nicola Footsteps:100 WAV/OGG, grass/snow/stone/water/wood. Concrete ve reverbler ayrılır; çarık toprak yerine grass tabakası kısmi. Özel lisans arşivde, HTML yalnız dağıtım yasağını veriyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Tam ticari izin arşivde**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0471. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol13"></a>
#### FOL13 — [Noisevember 24 FREE Sound Pack](https://zaimtzm.itch.io/noisevember-24-free-sound-pack)

Noisevember: WAV48k/24, WEAPSwrd/MECHLock/FOODEat ve synth/monster. Kılıç olduğu kabzaya dokunma sesini doğrulamaz; özel ihtiyaca eşleşme yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans yok**.
- Biçim: WAV, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **3/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol14"></a>
#### FOL14 — [Medieval Combat SFX Free - Sword, Bow & Shield Sampler](https://heyheythere.itch.io/medieval-combat-sfx-free)

Medieval Combat Free:30 WAV/OGG; kılıç çekme/kına koyma, yay bırakma, zincir zırh, örs, savaş borusu, kasa kırma ve forge loop. CC-BY4, kodla sentez/AI yardımı. İnsan kavga bağırışı veya ahşap kapı barı değil.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 heyheythere**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **8** = 0 tam + 7 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0475, İHT-0478, İHT-0485, İHT-0499, İHT-0500, İHT-0515, İHT-0512. **Uyarlama:** İHT-0492.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="fol15"></a>
#### FOL15 — [Household Interior Foley – Free Sound Effects Pack (80+ Sounds)](https://polarsoundproductions.itch.io/household-interior-foley-free-pack)

Polar Household Free:80+ WAV96k/24, ahşap/gıcırtılı kapı, kilit/anahtar, mobilya. Modern beyaz eşya elenir; 1450 tam koleksiyonun bütün sesleri ücretsiz değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K royalty-free**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Fiziksel kayıt veya belirtilen sentez; malzeme teması; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0468, İHT-0469. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### UI sesi: ürün notları


<a id="uis01"></a>
#### UIS01 — [[SFX] Pixel UI Sound Effect Pack](https://jdsherbert.itch.io/pixel-ui-sfx-pack)

Pixel UI:165 ses, Square/Saw/Sine Cancel/Cursor/Error/Popup/Select;1650 dosya çok biçim/kanal kopyası. Chiptune tınısı gece kapısının fiziksel tahta sesine uymuyor; elendi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: GBP4.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JDSherbert**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis02"></a>
#### UIS02 — [[SFX] Ultimate UI Sound Effect Pack](https://jdsherbert.itch.io/ultimate-ui-sfx-pack)

Ultimate UI:67 benzersiz; Cancel10 Cursor20 Error5 Popup10 Select10 Swipe12. 670 dosya 67 farklı sesin biçimleri; nötr seçki için kısmi aday. Özel lisans public repo ham dosya paylaşımını açıkça yasaklıyor.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: GBP4.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JDSherbert**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **6/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473, İHT-0474. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis03"></a>
#### UIS03 — [Universal UI/Menu Soundpack](https://cyrex-studios.itch.io/universal-ui-soundpack)

Cyrex Universal UI:52 WAV/MP3/OGG; Wood Block/African/Coffee ve modern/retro gruplar. Tahta tık için Wood Block güçlü aday; Nathan Gibson CC-BY4 atfı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Nathan Gibson**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 1 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0473. **Uyarlama:** İHT-0472.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis04"></a>
#### UIS04 — [Shapeforms Audio Free Sound Effects](https://shapeforms.itch.io/shapeforms-audio-free-sfx)

Shapeforms Free:180 WAV; FutureUI/Arcane/SF yanında Mint Coins, Hit&Punch. Modern büyük çoğunluk elenir; para ve fiziksel darbe başka ses ihtiyaçlarına kısmi katkı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; tam lisans bağlantılı**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0470, İHT-0479, İHT-0495. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis05"></a>
#### UIS05 — [RPG Essentials SFX - Free!](https://leohpaz.itch.io/rpg-essentials-sfx-free)

RPG Essentials Free:48 retro SFX; Hover/Confirm/Decline/Denied,4 yüzey adımı ve büyü. Büyüler/retro jingle elenir; tahta UI hedefini sağlamıyor, kısmi nötr ses seçimi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Leohpaz**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **4/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis06"></a>
#### UIS06 — [Echoes: Audio Super Kit](https://pizzadoggy.itch.io/echoes-audio-super-kit)

Echoes:yaklaşık500 SFX/ambiyans/OST,2000ler aksiyon/korku; makineler/elektronik baskın. Demo yalnız önizleme; PDF lisansı ve tekil dosyalar ayrıca gerekli, güvenilir kapsam sıfır.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: EUR11.97 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? PDF lisans teyidi gerekli**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis07"></a>
#### UIS07 — [Retro RPG 100 UI Sound Effects](https://leohpaz.itch.io/100-retro-rpg-ui-sound-effects)

Retro RPG100:Hover10 Confirm10 Dialogue10 vb100 retro ses;10 demo dosyası ticari kullanılabilir. 100'ün tamamını free saymadım. Sakin tarihî malzeme hedefiyle zayıf.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3.49 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Leohpaz**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **4/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis08"></a>
#### UIS08 — [50 Menu Interface SFX](https://coloralpha.itch.io/50-menu-interface-sfx)

Menu Interface50:50 MP3/WAV/FLAC, retro düğme; CC-BY4. Kullanım hakkı uygun, tahta tınısı teyitsiz; sadece işlevsel UI karşılığı kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 ColorAlpha**.
- Biçim: WAV, MP3, FLAC. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis09"></a>
#### UIS09 — [lolurio's FREE Cozy Game UI SFX Pack](https://lolurio.itch.io/lolurios-free-cozy-ui-sfx)

Lolurio Cozy17:4 menü,4 oyun menüsü,5 feedback,4 extra; marimba, piyano, synth. WAV/OGG, CC-BY4; marimba tık fiziksel hedefe yakın, parlak piyano/synth elenir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Lolurio**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473, İHT-0474. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis10"></a>
#### UIS10 — [[SFX] Wooden UI Sound Effect Pack](https://jdsherbert.itch.io/wooden-ui-sfx-pack)

Wooden UI30:Cancel10 Cursor5 Error5 Select5 Confirm5;30 benzersiz/600 çıktı. Ahşap sıcak karakteri hedefle en yakın. JDSherbert atfı ve özel ham paylaşım yasağı korunur.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: GBP2.49 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JDSherbert**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **9/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 1 kısmi + 2 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0474. **Uyarlama:** İHT-0472, İHT-0473.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis11"></a>
#### UIS11 — [SoupTonic's sound SFX Pack 1 - UI menu sounds](https://souptonic.itch.io/souptonic-sfx-pack-1-ui-sounds)

Souptonic12:enter/exit/select/pause/resume/confirm/cancel vb12 WAV/OGG/MP3;CC-BY4. Retro tını olduğu için işlevsel seçki kısmi, tahta ses diye kabul edilmedi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Souptonic**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis12"></a>
#### UIS12 — [User Interface Sound Effects 1 - Universal Sound Effects](https://elvgames.itch.io/user-interface-sound-fx)

ELV UI1:9click, enable/disable, menuopen yanında keypad/robotic/puzzle. Fiziksel tık seçimi kısmi; sci-fi sesler elenir. Atıf zorunlu, AI eğitim ve NFT yasağı var.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 4.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ELVGames/Pegonthetrack**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **6/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis13"></a>
#### UIS13 — [User Interface Sound Effects 4 - Universal Sound Effects](https://elvgames.itch.io/user-interface-sound-fx-4)

ELV UI4:40 ses;7click,3error,4bag,5map,4confirm ve typing. UI onay/odak için kısmi; derikese foley diye bag sesini tam saymadım.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ELVGames/Pegonthetrack**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **4** = 0 tam + 4 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0470, İHT-0472, İHT-0473, İHT-0474. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis14"></a>
#### UIS14 — [User Interface Sound Effects 3 - Universal Sound Effects](https://elvgames.itch.io/user-interface-sound-fx-3)

ELV UI3:40 ses;8click, inventory open/close veitem/typing. Onay sesi listelenmiyor; seçim odak adayı kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ELVGames/Pegonthetrack**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **6/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="uis15"></a>
#### UIS15 — [User Interface Sound FX - Medieval Collection](https://high-impact-media.itch.io/user-interface-sound-fx-medieval-collection)

Medieval UI Collection:400+click/inventory/equip/scroll/notification;49.99USD. Tekil malzeme listesi ve lisans şartı açık değil; pahalı ürün genel UI işleviyle kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 49.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans şartı görünmedi**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Organik tık / retro / sentez; parlak elektronik öğeler elendi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0472, İHT-0473, İHT-0474. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Müzik: ürün notları


<a id="muz01"></a>
#### MUZ01 — [Desert Music Pack [Game Music]](https://kashdanmusic.itch.io/desert-music-pack)

Kashdan Desert:9parça,6loop,3sonlanan;WAV32bit48k. NonCommercial açık;ticari için ayrı sözleşme. Mevcut haliyle öneri ve kapsama dışı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **X yalnız ticari olmayan**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0: mevcut lisans ticari oyuna izin vermiyor.

<a id="muz02"></a>
#### MUZ02 — [Resonance Vol. 2: Instruments of the Middle East](https://limitbreakaudio.itch.io/resonance-vol-2-instruments-of-the-middle-east)

Resonance2:10eser+3varyasyon/13cue/72WAV;Contemplation, Midnight, Illicit, ShadowyPursuit vb. Stem var, loop özellikle seamless değil. OrtaDoğu+orkestra+synth;stem ayıklama ve dikiş gerekir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 19.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ürün lisansı ayrıca**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 7 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0463, İHT-0465, İHT-0466, İHT-0467, İHT-0502, İHT-0503, İHT-0504. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz03"></a>
#### MUZ03 — [Middle East Instrumental Arabian Soul Music Pack](https://moodfrog.itch.io/middle-east-instrumental-music-pack)

MoodFrog ArabianSoul:başlık etnik ama metin yalnız genel atmosfer ve modernambient diyor. Açıklama free, ödeme9.99USD;çelişki. Liste/enstrüman/biçim yok;yalnız gece/sakin tema kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; fiyat çelişkisi**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0463, İHT-0465. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz04"></a>
#### MUZ04 — [Desert Wasteland & Oasis RPG Music Pack - 23 Traditional Oud Tracks](https://nasserblue.itch.io/desert-wasteland-oasis-rpg-music-pack-23-traditional-oud-tracks)

Nasser Oud:23WAV;BedouinNightfall, CaravanDreams, TraditionalMaqam vb tekil dosyalar listeli. AI-assisted ses. Ticari royalty-free izin ve ham paylaşım yasağı var;ud tınısı ney/kopuzun yerine tam sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 9.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari; AI-assisted**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0463, İHT-0465, İHT-0502. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz05"></a>
#### MUZ05 — [Medieval Music Pack](https://joelsteudler.itch.io/medieval-music-pack)

Joel Medieval:20parça:5battle4dungeon3field3theme5town;ud yerinelute/viol/shawm/recorder/harpsichord. OGGloop, theme parçalar sonlanır. JSMticari lisansı;zurna/davul9/8düğün değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 19.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JSM**.
- Biçim: OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 7 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0463, İHT-0465, İHT-0466, İHT-0467, İHT-0502, İHT-0503, İHT-0504. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz06"></a>
#### MUZ06 — [Persian Nights - Battle Music Pack](https://hai-soundworks.itch.io/persian-nights)

PersianNights:15tamWAV/MP3, stem/loop/SFXyok;modernperküsyonbaskın. Gece/kervan/reflectionbölümleri var;kesipdöngülemeişi gerekir. Özgül sonların müziği hazır sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 5.99 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K ticari ürün izni**.
- Biçim: WAV, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **5** = 0 tam + 5 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0463, İHT-0466, İHT-0467, İHT-0503, İHT-0504. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz07"></a>
#### MUZ07 — [Ethnic Music of Ancient Desert (Egyptian)](https://blackmid.itch.io/ethnic-music-of-ancient-desert)

BLACKMID AncientDesert:10eser,6hareketli4rüyalı;21dkWAV44.1k16. Canlı müzisyen iddiası ve geniş doğu paleti var;parça bazlı enstrüman listesi eksik. YouTube-safe vaat, lisansın yerine geçmez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 16.75 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K royalty-free**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **7** = 0 tam + 7 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0463, İHT-0465, İHT-0466, İHT-0467, İHT-0502, İHT-0503, İHT-0504. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz08"></a>
#### MUZ08 — [MEDIEVAL BARD MUSIC – Fantasy RPG Soundtracks](https://blackmid.itch.io/medieval-bard-music-fantasy-rpg-soundtracks)

BLACKMID Bard:15canlıloop,45stem,144WAVtoplamı;ud benzeri lute, harp, zither. Sakinhan/köyadayları, Anadolu motifine uyarlama gerekir;çıktıformatkopyalarını ayrı eser saymadım.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 30.15 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K royalty-free**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0465, İHT-0502, İHT-0503. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz09"></a>
#### MUZ09 — [Blessing of the Dustland](https://ely-robins.itch.io/blessing-of-the-dustlands)

Blessing Dustland:Arabicesintilisaatlikdeğil, kısakoleksiyon;akustik/elektrikpiyanoeşliği. Ticari lisans ve parça dökümü yok;modern piyano odağı nedeniyle elendi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari şart yok**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz10"></a>
#### MUZ10 — [AridFoothills](https://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100437)

AridFoothills:tek3:18eser85bpm;marimba, perküsyon, kontrbas, trombon, tuba, korno. İsmi bozkır olsa da Afrika/bakırüflemeli tını hedefmüziğe uymuyor;CC-BY4olmasına rağmen elendi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Kevin MacLeod**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **2/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0: enstrüman paleti hedefe uygun bulunmadı.

<a id="muz11"></a>
#### MUZ11 — [Complete Darbuka Sample Pack](https://abbarasounds.com/sounds/complete-darbuka-sample-pack)

Abbara Darbuka:1787WAV24bit44.1k,60–155bpm;görünen10örnek4/4. Tam müzik değil, beste katmanı. Kudüm/davul ve9/8zurna düğününü tek başına kapatmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 19 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Abbara EULA**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0467. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz12"></a>
#### MUZ12 — [Complete Bowed Tanbur Sample Pack](https://abbarasounds.com/sounds/complete-bowed-tanbur-sample-pack)

Abbara BowedTanbur:254WAV,48k24bit,5makam21ton;10örnek, Sultanıyegâh/Şehnaz. Modernyaylıtanburun tarihî tını ayıklaması gerekir;ney/kopuz veya bitmişloop değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 28.94 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Abbara EULA**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **6/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0466. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz13"></a>
#### MUZ13 — [Complete Classical Kemençe Sample Pack](https://abbarasounds.com/sounds/complete-classical-kemence-sample-pack)

Abbara Kemençe:656benzersiz771WAV,19makam27ton,48–180bpm. 9/8dahilritimler var;tek başına düğündavulu/zurnası değil. Tam eser değil, kayıt/beste ham maddesi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 33.45 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Abbara EULA**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0466. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz14"></a>
#### MUZ14 — [Complete Qanun Sample Pack](https://abbarasounds.com/sounds/complete-qanun-sample-pack)

Abbara Qanun:425WAV,16makam17ton,60–228bpm;9/8Hicazkâr örneği. Dosya başlığı48k, teknikmetin44.1/48k diyor;kanun nekopuzneneydir. Sakin müziğin katmanına aday.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 43.69 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Abbara EULA**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **8/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0465. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="muz15"></a>
#### MUZ15 — [Medieval Music](https://www.fab.com/listings/9f98ace3-da48-409d-abbf-337189dbd7c2)

Fab MedievalMusic:ücretsiz5parça;Gregorianchant/troubadour/lute/recorder/bagpipe, UEteslimi veAIüretimiişaretli. Kiliseyeözgüchantvebatıfestivalenerjisielendi;hamWAV/lisansseçimitamdoğrulanmadı, kapsama0.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Fab lisans alanı boş**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: Akustik/etnik veya belirtilen karma düzenleme; **3/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

### Mırıltı: ürün notları


<a id="mir01"></a>
#### MIR01 — [500+ Character Voice Audio Files!](https://dillonbecker.itch.io/sdap)

Super Dialogue:500+ WAV,5 erkek/kadın oyuncu;10 grupta Grunting/Shouting/Damage var. İngilizce Greeting/Completion elenir; yetişkin için nonverbal altküme, çocuk/yaşlı karakteri yok.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC-BY4 Dillon Becker**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516, İHT-0495, İHT-0497. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir02"></a>
#### MIR02 — [RPG Voice Starter Pack](https://cicifyre.itch.io/rpg-voice-starter-pack)

Cici RPG Starter:3 kadın ses/90 dosya,30ar; büyü sözcükleri ve attack/damaged/jump/healed tepkileri. CC0 ama konuşma mırıltısı yerine savaş eforu sağlar; çocuk veya yaşlı sesi sayılmaz.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir03"></a>
#### MIR03 — [Free Voice Clips Pack (Bright Female)](https://cicifyre.itch.io/free-voice-clips-pack-bright-female)

Cici Bright:72 WAV; İngilizce karşılama/kısa cevaplar ve3gülme. Gülme kısa duygu için aday; bu 72 dosyanın hepsi mırıltı değildir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir04"></a>
#### MIR04 — [Free Voice Clips Pack (Mature Female)](https://cicifyre.itch.io/free-voice-clips-pack-mature-female)

Cici Mature:57 WAV; ah/eh/uh/gasping açıkça var. Mature/tomboy ses yaşlı demek değil; yetişkin nötr hece altkümesine uyarlanabilir.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **A CC0**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0516.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir05"></a>
#### MIR05 — [Generic Male Voice Pack](https://daniconshow.itch.io/generic-male-voice-pack)

Danicon Male:63 WAV48k/32, duygu sesleri. Ticari kullanım Dan Bosley atfıyla; klip adları açıklamada yok, nötr hece kapsamı kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Dan Bosley atfı**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir06"></a>
#### MIR06 — [Voice Over Asset - Female, Mid-Range, American](https://chinomi.itch.io/voice-over-asset-female-mid-range-american)

Chinomi Female:young adult American;hello/yes/no yanı sıraattack/hurt/running pants. WAV44.1k/16 mono. Ticari lisans açık değil; nötr mırıltı yerine efor sesleri kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Lisans yok**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir07"></a>
#### MIR07 — [Free Generic Female Voice Pack](https://r0o0kie.itch.io/rookie)

Rookie:39 WAV ve her dosyada3take beyanı;greeting/reply/effort/laugh/cry. Ticari izin ve atıf var; sayı ifadesi benzersiz hece sayısı olarak alınmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Rookie atfı**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **7/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir08"></a>
#### MIR08 — [Jessica's Basic Voice Clips](https://jessicarobo.itch.io/jessicas-basic-voice-clips)

Jessica/Kelarima:OGG ve16bitWAV aynı satırlar; giggle/oh gibi nonverbal altküme, İngilizcegameover/choosecharacter elenir. Güncel açıklama CC-BY4, eski yorumlar BY-SA diyor; güncel arşiv lisansı teyit edilmeli.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC-BY4 / eski BY-SA notu**.
- Biçim: WAV, OGG. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir09"></a>
#### MIR09 — [Humanoids Grunts SFX Pack](https://leohpaz.itch.io/humanoids-grunts-sfx-pack)

Humanoids Grunts:138ses Beast/Demon/Giant/Goblin/Gremlin/Orc/Troll/Undead. İnsan yetişkin/yaşlı/çocuk yok. Fantastik ırk paketi tamamen elendi;0/138uygun.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 3.49 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K Leohpaz**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **1/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0 = 0/138: listelenen sekiz türün tamamı fantastik yaratık.

<a id="mir10"></a>
#### MIR10 — [EFFORT SOUNDS (Male) - Audio Pack](https://voicebosch.itch.io/exertion-sounds-male-audio-pack)

VoiceBosch Effort:41erkek efor;zıplama/blok/yumruk/kılıç. CC-BY-SA4 A değildir; diyaloğa nötr mırıltı yerine savaş eforu kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **S CC-BY-SA4**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **5/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **2** = 0 tam + 2 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516, İHT-0497. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir11"></a>
#### MIR11 — [Warrior Voice Pack](https://johncarroll.itch.io/warrior-voice-pack)

Warrior Voice:110+WAV;yorulmuş/öfkeli/mutlu/sorgulayan tepkiler ve savaş. MetadataCC0, açıklama yeniden satış/incorporating yasağı söylüyor; çelişki giderilmeden A sayılmadı.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **Ç CC0/özel kısıt**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **7/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **3** = 0 tam + 3 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516, İHT-0495, İHT-0497. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir12"></a>
#### MIR12 — [Dialogue Sfx](https://ambroggiomusic.itch.io/dialogue-scribble-scrabble-noises-sfx)

Dialogue SFX:15tekli Ah/Huh/Garble/Meh ve retro/honk;Animal Crossing tarzı. İnsan yaş grubu kaydı değil, yüksek/sentetik ses ciddi atmosferi bozar;garble altküme kısmi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K krediyle kullanım**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **4/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir13"></a>
#### MIR13 — [[VOX] Male Character Vocal Pack](https://jdsherbert.itch.io/male-character-vox-pack)

Male VOX:23ses;Mhm1, Sigh3, Grunt6, Punch6, Jump3, Die3, Bruh1. Dört nötr Mhm/Sigh dosyası yetişkin mırıltısına en yakın;modern Bruh elenir. Atıf ve özel lisans.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **K JDSherbert + ATTurtlez**.
- Biçim: WAV, OGG, MP3. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **8/10**. Uyarlama işi: **az**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 0 kısmi + 1 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** İHT-0516.
- Pakette kullanılabilir oran: Nötr yetişkin hece ilk seçkisi: %17.4 = 4/23 (Mhm + üç Sigh). Diğer efor sesleri mırıltı teslimi sayılmadı; işitsel kabul yapılmadı.

<a id="mir14"></a>
#### MIR14 — [RPG Male Vocal](https://konakuma.itch.io/rpg-male-vocal)

Konakuma RPG Male:162soundbite;24grunt,12jump, Japonca/İngilizce barks. Dil içerenler elenir;ticari kullanım ve lisans açıkça adlandırılmamış, ücretsiz sözü yetmez.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **? Ticari lisans teyidi**.
- Biçim: İç uzantı belirtilmemiş; arşiv açılmadı. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **6/10**. Uyarlama işi: **orta**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **1** = 0 tam + 1 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** İHT-0516. **Uyarlama:** —.
- Pakette kullanılabilir oran: Hesaplanamadı: eksiksiz öğe/ad listesi ve kabul edilmiş seçim paydası yok.

<a id="mir15"></a>
#### MIR15 — [Custom Voice Resource - CVR](https://kerstynungervo.itch.io/custom-voice-resource)

Custom Voice Resource:15erkek/kadın tip,100+satır/tip;Follower/Combat/Marriage/ChildInteraction. CC-BY-NC-SA ticari oyuna uygun değil; Child Interaction çocuk seslendirmesi anlamına gelmez. Elendi.

- Kaynak durumu: 200; 23 Ekim 2026’da ürün/üretici metni açıldı. Ücret: 0 (sayısal tutar USD; EUR ayrıca yazılır). Lisans: **X CC-BY-NC-SA**.
- Biçim: WAV. Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli.
- Stil/uyum: İnsan ses kaydı / nonverbal; yaratık/sentetik içerik ayrıca elendi; **1/10**. Uyarlama işi: **çok**; somut nedeni yukarıdaki içerik sınırında.
- İhtiyaç teması: **0** = 0 tam + 0 kısmi + 0 uyarlamayla. **Tam:** —. **Kısmi:** —. **Uyarlama:** —.
- Pakette kullanılabilir oran: %0: ticari olmayan lisans nedeniyle tedarik dışı.

## İlk turun 51 kaynağı: aynı sayısal ölçütle yeniden puanlama

Eski E10 ve C06 aynı Synty ürünüdür; aşağıda yalnız E10 sayılır. İlk turdaki bütün A etiketleri otomatik korunmadı. Özellikle Quaternius, hesap içi Mixamo ve Freesound kapsamları daha ihtiyatlı değerlendirildi.


<a id="a03"></a>
### A03 — [KayKit: Character Animations](https://kaylousberg.itch.io/kaykit-character-animations)

FBX/glTF Rig_Medium/Large, hareket/sosyal/silah/araç setleri ve28yeni tool hareketi. Sneaking ve hammering açık; hedef rigde retarget şart. Fırınküreği grup satırı kısmi.

**9 ihtiyaç** (0 tam / 3 kısmi / 6 uyarlama); **9/10**, iş orta. Tam: —; kısmi: İHT-0399, İHT-0396, İHT-0401; uyarlama: İHT-0444, İHT-0450, İHT-0453, İHT-0455, İHT-0456, İHT-0524.

Ücret 0 · **A CC0** · FBX, glTF, Blend · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a01"></a>
### A01 — [Quaternius: Universal Animation Library](https://quaternius.itch.io/universal-animation-library)

120+ hareket; 8yönlocomotion, jog, sprint, push, crawl, swim, sit, death;RM/NoRM. Free/Pro klip adları ayrışmadığından belirli ücretsiz duygu var denmedi; genel hareketler kısmi.

**5 ihtiyaç** (0 tam / 5 kısmi / 0 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0444, İHT-0450, İHT-0451, İHT-0456, İHT-0524; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · FBX, GLB, Blend · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a02"></a>
### A02 — [Quaternius: Universal Animation Library 2](https://quaternius.itch.io/universal-animation-library-2)

130+ hareket;farming/fishing, combo/parkour/zombie. İkinci kitaplık genel tarım adayı;orak, kar, çekiç ve fırınküreği tekil klip düzeyinde teyitsiz.

**3 ihtiyaç** (0 tam / 3 kısmi / 0 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0452, İHT-0453, İHT-0455; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · GLB, Blend · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a06"></a>
### A06 — [MoCap Online: Mobility](https://mocaponline.com/products/mobility)

Starter35animasyon/59dosya; Pro527+ toplamıyla karıştırılmaz. Walk/jog/crouch/jump/idle/turn. Çarık/zemin teması ve retarget, yağmur/kar ayrı açık.

**3 ihtiyaç** (0 tam / 0 kısmi / 3 uyarlama); **8/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0444, İHT-0450, İHT-0524.

Ücret 3.33 · **K MCO Standard** · FBX, Blend · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a07"></a>
### A07 — [MoCap Online: Park](https://mocaponline.com/products/park)

65dosya;46oturarak19ayakta,35konuşma,8texting4phone örtüşen etiketler. Telefon elenir; konuşma/oturma ihtiyacına aday. Etiketler toplanıp65üzeri benzersiz sayı üretilmedi.

**2 ihtiyaç** (0 tam / 0 kısmi / 2 uyarlama); **6/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0445, İHT-0451.

Ücret 32.49 · **K MCO Standard** · FBX, Blend · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a08"></a>
### A08 — [MoCap Online: Bar Drinking](https://mocaponline.com/products/bar)

112bar/restoran dosyası;48bar48masa16ayakta. Bardak/tutuş ve mobilya yüksekliği uyarlanmalı; konuşma ve oturma adayları.

**2 ihtiyaç** (0 tam / 0 kısmi / 2 uyarlama); **5/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0445, İHT-0451.

Ücret 22.47 · **K MCO Standard** · FBX · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a05"></a>
### A05 — [MoCap Online: Conversation](https://mocaponline.com/products/convo)

28conversation dosyası:9uzun9loop7jest3yön; konuşma parmak ayrıntılı, FBX. Ayakta konuşma için retarget; özgül duygu adı teyit edilmedi.

**1 ihtiyaç** (0 tam / 0 kısmi / 1 uyarlama); **8/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0445.

Ücret 14.99 · **K MCO Standard** · FBX · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a09"></a>
### A09 — [MoCap Online: Office / Desk](https://mocaponline.com/products/desk)

35ofis/masa;16oturma10yürüme7ayakta2geçiş. Modern iş eylemleri ayıklanmalı; genel otur-kalk kısmi, tarihî yazma işi kanıtlanmadı.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **3/10**, iş çok. Tam: —; kısmi: İHT-0451; uyarlama: —.

Ücret 18.99 · **K MCO Standard** · FBX, Blend · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="a04"></a>
### A04 — [Adobe Mixamo](https://www.mixamo.com/)

Mixamo JS/AdobeID içinde; SSS ücretsiz ticari kullanım ve FBX akışını doğruluyor. Hesaba girilmeden named clip listesi görülemedi. Walk/talk/fear etiketleri varsayımla kapsama yazılmadı.

**0 ihtiyaç** (0 tam / 0 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: —; uyarlama: —.

Ücret 0 · **K Adobe** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: FBX varsa SkeletonProfileHumanoid/BoneMap ve retarget; bu tur import yapılmadı. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s01"></a>
### S01 — [rubberduck: 100 CC0 metal and wood SFX](https://opengameart.org/content/100-cc0-metal-and-wood-sfx)

100metal/wood; wooddoorclosing, cracking, breaking, squeak, woodhammer, metalkey/lock. Ağır kapı/bar/mallet için uyarlama; zincir/derikese/bebek yok.

**6 ihtiyaç** (0 tam / 4 kısmi / 2 uyarlama); **9/10**, iş az. Tam: —; kısmi: İHT-0468, İHT-0478, İHT-0499, İHT-0500; uyarlama: İHT-0469, İHT-0485.

Ücret 0 · **A CC0 rubberduck** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s04"></a>
### S04 — [artisticdude: RPG Sound Pack](https://opengameart.org/content/rpg-sound-pack)

artisticdude RPG sesleri CC0;coin/UI/metal, çok sayıda monster/magic. Doğal foley yerine oyunlu tını, para/arayüz altkümesi kısmi.

**3 ihtiyaç** (0 tam / 3 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0472, İHT-0473, İHT-0479; uyarlama: —.

Ücret 0 · **A CC0** · WAV · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s05"></a>
### S05 — [Kenney: RPG Audio](https://kenney.nl/assets/rpg-audio)

KenneyRPG50dosya, foley/footstep/weapon. Dosya adları ürünmetninde yok; belirli çarık/toprak veya yay seçimi teyitsiz.

**3 ihtiyaç** (0 tam / 3 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0471, İHT-0475, İHT-0492; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s06"></a>
### S06 — [Kenney: Impact Sounds](https://kenney.nl/assets/impact-sounds)

KenneyImpact130dosya;impact/foley. Tekil kırılan tahta türü yok; genel darbe sesi kapı barı kırılması diye sayılmadı.

**0 ihtiyaç** (0 tam / 0 kısmi / 0 uyarlama); **6/10**, iş orta. Tam: —; kısmi: —; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c08"></a>
### C08 — [Quaternius: LowPoly Animated Knight](https://quaternius.itch.io/lowpoly-animated-knight)

Tek animasyonlu Avrupa şövalyesi; idle/death/jump/roll/run/walk/attack. Uzak Bizans askerinde zırh değiştirme gerekir.

**5 ihtiyaç** (0 tam / 4 kısmi / 1 uyarlama); **4/10**, iş çok. Tam: —; kısmi: İHT-0444, İHT-0450, İHT-0455, İHT-0456; uyarlama: İHT-0358.

Ücret 0 · **Ç CC0/QAL** · FBX, OBJ, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c01"></a>
### C01 — [Quaternius: Modular Character Outfits — Fantasy](https://quaternius.itch.io/modular-character-outfits-fantasy)

12 kıyafet/62 parça ve üçer doku, humanoid rig. Bütün ücretsiz katman doğrulanmadı; başlık/çarık/kaftan işi gerekiyor. Çocuk ve özgül derviş hazır değil.

**3 ihtiyaç** (0 tam / 2 kısmi / 1 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0390, İHT-0431; uyarlama: İHT-0427.

Ücret 0 · **Ç CC0/QAL** · glTF · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c04"></a>
### C04 — [Quaternius: Ultimate Modular Men Pack — Poly Pizza](https://poly.pizza/bundle/Ultimate-Modular-Men-Pack-ZiH8muWqwQ)

11erkek/24klip; farmer/adventurer/king altkümesi, SWAT/astronot elenir. Bey ve esnaf ancak kıyafet değişimiyle; ana Quaternius lisansı kaynak kökeni nedeniyle ayrıca çelişkili.

**3 ihtiyaç** (0 tam / 3 kısmi / 0 uyarlama); **5/10**, iş çok. Tam: —; kısmi: İHT-0356, İHT-0390, İHT-0431; uyarlama: —.

Ücret 0 · **Ç Poly Pizza CC0 / QAL kaynağı** · FBX, GLB, glTF · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c02"></a>
### C02 — [Quaternius: Universal Base Characters](https://quaternius.itch.io/universal-base-characters)

6 çıplak/taban gövde, regular/superhero/teen; yaklaşık13k üçgen,20saç. Kostüm teslim etmediğinden roller kısmi. Teen 7yaşındakiçocuk sayılmadı.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **7/10**, iş çok. Tam: —; kısmi: İHT-0426, İHT-0427; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c03"></a>
### C03 — [Quaternius: Ultimate Modular Women Pack](https://quaternius.com/packs/ultimatemodularwomen.html)

10modülerkadın ve24klip beyanı. Modern kıyafetler ayıklanmalı; eş gövdesine uyarlama, hazır Anadolu kostümü değil.

**1 ihtiyaç** (0 tam / 0 kısmi / 1 uyarlama); **6/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0427.

Ücret 0 · **Ç CC0/QAL** · FBX, glTF, OBJ, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c05"></a>
### C05 — [Quaternius: RPG Character Pack](https://quaternius.com/packs/rpgcharacters.html)

6rigliRPGkarakter;wizard/monk uzun giysi dervişe kanıt değildir. Tarihî elçi gövdesi için kısmi, gerçek dini kıyafet ayrıca gerekir.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **4/10**, iş çok. Tam: —; kısmi: İHT-0353; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · FBX, glTF, OBJ, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c07"></a>
### C07 — [KayKit: Adventurers](https://kaylousberg.itch.io/kaykit-adventurers)

5ücretsiz/3Extra karakter ve25+ aksesuar. Knight/rogue vb oyuncak oranlı; elf/druid fantastik parçaları elenir. Uzak asker adayı.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **4/10**, iş çok. Tam: —; kısmi: İHT-0358; uyarlama: —.

Ücret 0 · **A CC0** · FBX, glTF, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c10"></a>
### C10 — [Plewr: 3D Rigged Character Model](https://plewr.itch.io/3d-rigged-character)

RigliGLB, Blend veMixamoFBX taban karakter; dönem kostümü yok. Teknik deneme kaynağı, bitmiş oyun karakteri sayılmaz.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **2/10**, iş çok. Tam: —; kısmi: İHT-0426; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="c09"></a>
### C09 — [Quaternius: Ultimate Animated Character Pack](https://quaternius.com/packs/ultimatedanimatedcharacter)

52karışık dönemli rigli karakter; ad listesi mevcut metinde yok. Büyük sayı uygun insan çeşidi kanıtı değil; bu tur yeni ihtiyaç kapatmıyor.

**0 ihtiyaç** (0 tam / 0 kısmi / 0 uyarlama); **2/10**, iş çok. Tam: —; kısmi: —; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · FBX, OBJ, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s11"></a>
### S11 — [Ancient Sounds: Middle Eastern — Free Sample Pack](https://ancient-sounds.com/product/middle-eastern-free-sample-pack/)

AncientSounds24WAVloop, Duduk/Ney/Vocal/Setar/Santur/Kamancheh. Ücretsiz eposta kaydı, royaltyfree. Beste/uzun döngü değil; ney katmanı gece/sakin müziği kısmen destekler.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0463, İHT-0465; uyarlama: —.

Ücret 0 · **K royalty-free** · WAV · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s09"></a>
### S09 — [Abbara: Complete Bendir Sample Pack](https://abbarasounds.com/sounds/complete-bendir-sample-pack)

Bendir938WAV,60–148bpm, görünen4/4ve7/8. Bitmiş müzik değil;bendirparçası, kudüm/davul/zurna9/8teslimi değil. Panik müziğinde kısmi beste katmanı.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0467; uyarlama: —.

Ücret 11.73 · **K Abbara EULA** · WAV · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s10"></a>
### S10 — [Gravity Sound: Character Mumble Voices](https://gravity-sound.itch.io/character-mumble-voices)

GravityMumble288WAV;male/femaleold/adult/young ve giant. Üç yaş ihtiyacına aday;young gerçek çocuk sesi mi açık değil. Dev/komik varyantlar elenir;lisans sayfada ayrıca teyit.

**3 ihtiyaç** (0 tam / 1 kısmi / 2 uyarlama); **9/10**, iş az. Tam: —; kısmi: İHT-0518; uyarlama: İHT-0516, İHT-0517.

Ücret 19.99 · **? Tam ticari lisans teyidi** · WAV · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s12"></a>
### S12 — [moodfrog: Character Mumble & Gibberish Dialogue — 60 Sound Effects](https://moodfrog.itch.io/character-mumble-gibberish-sfx-pack)

MoodFrog60one-shot/120WAV+OGG,5kategori,114sn. Mırıltıgibberish ticari ürün izni var;yaşlı/çocuk ayrımı belirtilmemiş, hepsi aynı60tasarımın iki biçimi.

**3 ihtiyaç** (0 tam / 2 kısmi / 1 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0517, İHT-0518; uyarlama: İHT-0516.

Ücret 10 · **K ticari** · WAV, OGG, MP3 · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s08"></a>
### S08 — [Sonniss: GameAudioGDC arşivi](https://sonniss.com/gameaudiogdc/)

Sonniss: eski sekiz koleksiyonun görünür yıllık tracklistleri ve25sayfalık PDF açıldı;2025yok,2026ayrısayfa. Zincir, kâğıt, ahşapkapı, demirci, yağmur/rüzgâr, kalabalıkkavga/nara somut dosya adlarıyla görülüyor. Bazı GoogleHTMLlisteleri kısaltılmış;tam arşiv yüzdesi bilinmiyor.

**16 ihtiyaç** (2 tam / 8 kısmi / 6 uyarlama); **8/10**, iş orta. Tam: İHT-0489, İHT-0490; kısmi: İHT-0468, İHT-0469, İHT-0476, İHT-0481, İHT-0482, İHT-0483, İHT-0491, İHT-0510; uyarlama: İHT-0477, İHT-0478, İHT-0485, İHT-0495, İHT-0496, İHT-0497.

Ücret 0 · **K Sonniss GDC** · WAV etiketli yayımlanmış tracklist; arşiv biçimleri ve örnekleme oranları dosyaya göre değişiyor · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s02"></a>
### S02 — [Blender Foundation / Lamoot: Ambient Mountain, River, Wind and Forest and Waterfall](https://opengameart.org/content/ambient-mountain-river-wind-and-forest-and-waterfall)

YoFrankie BlenderFoundation dağ/orman/dere/şelale/rüzgâr. CC-BY3. Doğal rüzgâr tam adayı; gece baykuş/kurt ve gündüz çekiç/koyun birleşimi eksik.

**5 ihtiyaç** (1 tam / 4 kısmi / 0 uyarlama); **9/10**, iş az. Tam: İHT-0490; kısmi: İHT-0481, İHT-0482, İHT-0483, İHT-0510; uyarlama: —.

Ücret 0 · **A CC-BY3 Blender Foundation** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s03"></a>
### S03 — [andersmmg: Ambience — Freesound](https://freesound.org/people/andersmmg/packs/29155/)

Freesound Ambience29155; sayfa JS kabuğu ve hesap arayüzü. Bu tur tekil kayıt lisansları/dosya adları alınamadı; önceki koleksiyon puanı koşulluya düşer.

**0 ihtiyaç** (0 tam / 0 kısmi / 0 uyarlama); **5/10**, iş orta. Tam: —; kısmi: —; uyarlama: —.

Ücret 0 · **? Her kayıt lisansı ayrı** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u08"></a>
### U08 — [Kenney: UI Pack — Adventure](https://kenney.nl/assets/ui-pack-adventure)

Adventure UI130dosya;button/panel/slider etiketleri. 4buton hali ve 9-slice ölçüleri teyitsiz; genel panel/kaydırıcı kısmi.

**8 ihtiyaç** (0 tam / 8 kısmi / 0 uyarlama); **6/10**, iş orta. Tam: —; kısmi: İHT-0286, İHT-0287, İHT-0288, İHT-0289, İHT-0290, İHT-0293, İHT-0301, İHT-0302; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u03"></a>
### U03 — [Game-icons.net koleksiyonu](https://game-icons.net/)

Game-icons SVG koleksiyonu; sanatçı bazlı CC-BY3.0. Kaynak/adalet/kapı ikonlarına genel aday fakat tek tek ikon bağlantıları seçilmediği için 24ikonun hepsi kapanmıyor.

**7 ihtiyaç** (0 tam / 7 kısmi / 0 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0315, İHT-0317, İHT-0318, İHT-0319, İHT-0321, İHT-0326, İHT-0327; uyarlama: —.

Ücret 0 · **A CC-BY3** · SVG · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u04"></a>
### U04 — [Kenney: Fantasy UI Borders](https://kenney-assets.itch.io/fantasy-ui-borders)

130+sprite,9-slice pencereler;CC0. Bütün yükleme/imleç/buton halleri değil; panel/kart çerçevesi yeniden boyama adayı.

**5 ihtiyaç** (0 tam / 0 kısmi / 5 uyarlama); **7/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0286, İHT-0291, İHT-0292, İHT-0293, İHT-0294.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u10"></a>
### U10 — [Buch: Golden UI](https://opengameart.org/content/golden-ui)

GoldenUI CC0;dolgu/slider/scrollbar/button etiketleri var. Parlak altın/piksel dili gece kapısı için ters, bütün UI değişimi yerine sınırlı referans.

**4 ihtiyaç** (0 tam / 4 kısmi / 0 uyarlama); **3/10**, iş çok. Tam: —; kısmi: İHT-0301, İHT-0302, İHT-0303, İHT-0304; uyarlama: —.

Ücret 0 · **A CC0** · PNG, PSD · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u02"></a>
### U02 — [PINKCANNON: Game wood panel](https://opengameart.org/content/game-wood-panel)

ElboyalıWoodGamePanel.zip, katmanlı kaynak;CC0. Gecekapısının ahşap hissine en yakın;9-slice köşe/kenar, demir çerçeve ve boyut uyarlaması gerekir.

**3 ihtiyaç** (0 tam / 0 kısmi / 3 uyarlama); **9/10**, iş orta. Tam: —; kısmi: —; uyarlama: İHT-0286, İHT-0293, İHT-0294.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u07"></a>
### U07 — [yd: GUI elements](https://opengameart.org/content/gui-elements)

yd incompleteGUI; map.svg/gui2.svg/Quest.svg/Inventory.svg. Yazar konsept/eksik set diyor; tam oyun arayüzü değildir, menü tabanları kısmi.

**3 ihtiyaç** (0 tam / 3 kısmi / 0 uyarlama); **5/10**, iş çok. Tam: —; kısmi: İHT-0284, İHT-0286, İHT-0293; uyarlama: —.

Ücret 0 · **A CC0** · PSD, SVG · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u09"></a>
### U09 — [Kenney: Cursor Pack](https://kenney.nl/assets/cursor-pack)

180imleç dosyası. Tekil point/grab/busy adları ürünmetninde yok; bu ihtiyaçlar doğrudan tam kapanmıyor. Ok imleci için kısmi.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0007, İHT-0311; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u01"></a>
### U01 — [Alegreya — Google Fonts](https://fonts.google.com/specimen/Alegreya)

Alegreya zaten depoda, edebî gövde yazısı. OFL1.1 açık font lisansı, CC0 değildir. Mevcut font karşılaştırma tabanıdır.

**1 ihtiyaç** (0 tam / 0 kısmi / 1 uyarlama); **9/10**, iş az. Tam: —; kısmi: —; uyarlama: İHT-0519.

Ücret 0 · **M OFL1.1 mevcut** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u05"></a>
### U05 — [Kenney: Cartography Pack](https://kenney.nl/assets/cartography-pack)

85cartography dosyası; map/town/castle ikonları. Özgün köy/kapı coğrafyasını hazır harita olarak kapatmaz; harita tabanına kısmi.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0284; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u06"></a>
### U06 — [Cinzel — Google Fonts](https://fonts.google.com/specimen/Cinzel)

Cinzel mevcut OFL font, Roma yazıtından esin. Başlıklarda alternatif; uzun diyalog metni yerine kullanılmamalı.

**1 ihtiyaç** (0 tam / 0 kısmi / 1 uyarlama); **8/10**, iş az. Tam: —; kısmi: —; uyarlama: İHT-0520.

Ücret 0 · **M OFL1.1 mevcut** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="u11"></a>
### U11 — [ansimuz: Battle Background — Hazy Hills](https://opengameart.org/content/battle-background-hazy-hills-0)

320×208HazyHills piksel arka planı;PNG/PSD+HUD, CC-BY3. Kapı/kandil yok ve 16:9değil; seçilmiş gece kapısı arka planı ihtiyacına karşılık sayılmadı.

**0 ihtiyaç** (0 tam / 0 kısmi / 0 uyarlama); **3/10**, iş çok. Tam: —; kısmi: —; uyarlama: —.

Ücret 0 · **A CC-BY3 ansimuz** · PNG, PSD · Godot 4: PNG/SVG→Texture2D/StyleBoxTexture; font TTF/OTF→FontFile; tema ve Türkçe kontrolü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="s07"></a>
### S07 — [Kenney: Interface Sounds](https://kenney.nl/assets/interface-sounds)

KenneyInterface100dosya;click/button. Tahta/amber gibi görsel dil sese kanıt değil; nötr odak/onay kısmi.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **7/10**, iş az. Tam: —; kısmi: İHT-0472, İHT-0473; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: WAV/OGG varsa AudioStream; loop/mono/normalizasyon kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e03"></a>
### E03 — [Quaternius: Fantasy Props MegaKit](https://quaternius.itch.io/fantasy-props-megakit)

200+ prop, kitap, pazar tezgâhı, sandık, mobilya, sebze ve silah. Ücretsiz alt kümenin dosya adları görülmedi; tanıtımdaki bütün aletler ücretsiz kapsam değil.

**6 ihtiyaç** (0 tam / 6 kısmi / 0 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0347, İHT-0377, İHT-0388, İHT-0414, İHT-0420, İHT-0421; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · FBX, glTF, OBJ · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e02"></a>
### E02 — [Quaternius: Medieval Village MegaKit](https://quaternius.itch.io/medieval-village-megakit)

300+ modül; dış/iç yüzey, duvar, çatı, merdiven. Sürüm bazlı tekil ücretsiz liste yok. Kervansaray/atölye hazır denemez; QAL çelişkisi ilk raporun A etiketini koşullu hale getirir.

**5 ihtiyaç** (0 tam / 3 kısmi / 2 uyarlama); **8/10**, iş orta. Tam: —; kısmi: İHT-0339, İHT-0397, İHT-0378; uyarlama: İHT-0372, İHT-0412.

Ücret 0 · **Ç CC0/QAL** · FBX, glTF, OBJ · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e04"></a>
### E04 — [Kenney: Castle Kit](https://kenney-assets.itch.io/castle-kit)

Castle Kit kapı/sur/kule modülleri; FBX/glTF. İç yüz kanat/pivot ve Anadolu burç ölçüsü doğrulanmadı. Yalnız uyarlanabilir kale modülleri.

**4 ihtiyaç** (0 tam / 4 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0339, İHT-0376, İHT-0378, İHT-0411; uyarlama: —.

Ücret 0 · **A CC0** · FBX, glTF, OBJ · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e10"></a>
### E10 — [Synty: POLYGON — Knights Pack](https://syntystore.com/products/polygon-knights-pack)

Knights çevre ve karakter aynı ürün. Model/FBX, 5 rigli figür; animasyon yok. Batı şövalye üslubu, kule/sur ve asker uyarlaması.

**3 ihtiyaç** (0 tam / 2 kısmi / 1 uyarlama); **5/10**, iş çok. Tam: —; kısmi: İHT-0376, İHT-0378; uyarlama: İHT-0358.

Ücret 29.99 · **K Synty** · FBX · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e05"></a>
### E05 — [Kenney: Survival Kit](https://kenney-assets.itch.io/survival-kit)

Survival Kit kamp/çadır/doğa ailesi. Modern parçalar ayıklanmalı; avcı barınağı ve odun kampı için kısmi. Ateşböceği veya kandil varsayılmadı.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0361, İHT-0363; uyarlama: —.

Ücret 0 · **A CC0** · FBX, glTF, OBJ · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e07"></a>
### E07 — [Quaternius: Ultimate Nature Pack](https://quaternius.com/packs/ultimatenature.html)

150 doğa modeli; ağaç/kaya çeşitlendirme, tür/bozkır seçimi gerekir. Kazılabilir taş yatağı oyun geometrisi değil.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **7/10**, iş orta. Tam: —; kısmi: İHT-0386, İHT-0423; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · FBX, OBJ, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e09"></a>
### E09 — [Xiro: Middle East — Unity Asset Store](https://assetstore.unity.com/packages/3d/environments/urban/middle-east-318547)

Middle East 25 yapılı Unity çevresi, tarihî Anadolu garantisi yok; mesh ihracı ve shader aktarımı koşullu. Pazar ve taş ev için kısmi, kervansaray hazır değil.

**2 ihtiyaç** (0 tam / 2 kısmi / 0 uyarlama); **6/10**, iş çok. Tam: —; kısmi: İHT-0372, İHT-0377; uyarlama: —.

Ücret 30 · **K Unity Standard** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e06"></a>
### E06 — [Quaternius: Medieval Village Pack](https://quaternius.com/packs/medievalvillage.html)

44 model; köy başlığı dışında yazılı bina adları yok. Kuyu/fırın/değirmen içeriyor diye kesinleştirilmedi; kırsal ev grubuna kısmi.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **6/10**, iş orta. Tam: —; kısmi: İHT-0372; uyarlama: —.

Ücret 0 · **Ç CC0/QAL** · FBX, OBJ, Blend · Godot 4: GLB/glTF doğrudan aday; FBX import/Blend→GLB; ölçek, malzeme ve rig kabulü gerekli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e08"></a>
### E08 — [Kenney: Fantasy Town Kit](https://kenney.nl/assets/fantasy-town-kit)

160 dosyalı Fantasy Town; tam model adları/uzantılar yazılmamış. Ev adayı; gece boyalı malzemeye göre oyuncak oranlar.

**1 ihtiyaç** (0 tam / 1 kısmi / 0 uyarlama); **5/10**, iş çok. Tam: —; kısmi: İHT-0372; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.


<a id="e01"></a>
### E01 — [Poly Haven: Satara Night (No Lamps)](https://polyhaven.com/a/satara_night_no_lamps)

Satara gece HDRI'si zaten depoda; lambasız ışık sağlar, resimli gece kapısı arka planı sağlamaz. Ana listede HDRI teslim yuvası yok; mevcut ortam ışığı kaynağı olarak korunur.

**0 ihtiyaç** (0 tam / 0 kısmi / 0 uyarlama); **9/10**, iş az. Tam: —; kısmi: —; uyarlama: —.

Ücret 0 · **A CC0** · İç uzantı belirtilmemiş; arşiv açılmadı · Godot 4: Koşullu: mesh biçimi ve kaynak ihracı teyit edilmeli. Durum 200. Kullanılabilir oran: Hesaplanamadı: tam dosya/öğe seçimi veya arşiv görülmedi.

## Görsel uyum matrisi

Bu matris dosya import sonucu değil; yayımlanmış stil, atlas, oran ve malzeme tanımlarına göre tasarım öngörüsüdür. **✓:** aynı aile; **△:** seçme/yeniden malzeme gerekir; **×:** aynı yakın planda karıştırma önerilmez.

| Birlikte kullanım | KayKit | Quaternius yeni MegaKit | Slavica/LOKIT/Avramania | Synty Knights | PSX hayvan | Gerçekçi PBR | Gece kapısı boyalı UI |
|---|---|---|---|---|---|---|---|
| KayKit | ✓ ortak atlas/ölçek | △ gövde oranı | △ renk ve ölçü | △ yüz/prop oranı | × | × | △ ayrı ekran katmanı |
| Quaternius MegaKit | △ | ✓ kendi aile | △ tek çevre ailesi seç | △ atlas/kenar dili | × | △ pürüz azaltma | ✓ ayrı UI katmanı |
| Slavica/LOKIT/Avramania | △ | △ | △ birbirleriyle otomatik aynı aile değiller | △ | × | △ | ✓ |
| Synty Knights | △ | △ | △ | ✓ | × | × | △ |
| PSX hayvan | × | × | × | × | ✓ kendi aile | × | △ uzak figür |
| Gerçekçi PBR | × | △ | △ | × | × | ✓ | △ aşırı detay azaltma |

Slavica + Slavic Villagers ortak aile, fakat custom rig dönüşümü gerektirir; aynı içeriği iki kez almak gereksiz olabilir. KayKit Tools + KayKit Animations ortak teknik taban sağlar; KayKit figür oranları oyunun ciddi yakın plan insanlarına zorla taşınmamalı. SI/Cube hayvanların sevimli veya bloklu biçimi, gerçekçi insanla aynı yakın planda önerilmez. Amir atları ile düz renk köy ailesi ancak atlas/ışık eşitlemesiyle denenebilir. Önerilen karma seçkide Low World kurt **alternatif/test adayıdır**; lisansı ve sahne uyumu doğrulanmadan aynı köye ekleme kararı yok.

Boyalı gece kapısı UI, piksel UI koleksiyonlarıyla rastgele karıştırılmamalı. Aynı panel ailesi, aynı köşe kalınlığı, aynı dört buton geometrisi korunmalı. 32 px piksel paneli 1080p boyalı panele büyütmek yalnız renk değiştirme işi değildir. PINKCANNON ahşabı ve Kenney kenar modülleri hammadde/referans adayı; hazır hedef tasarım garantisi değildir. UI fontta tek gövde + tek başlık ailesi yeterli.

## Kaynak taramasının genişliği ve erişim sınırları

| Kaynak | Açılan kapsam / sonuç |
|---|---|
| [Kenney](https://kenney.nl/assets) | 14 katalog sayfasında 217 ürün kartı tarandı. Uygun 3D/UI/audio/VFX ürünleri ayrı açıldı; modern şehir/uzay/araç setleri elendi. 217 paketin her arşivinin içi incelendi iddiası yok. |
| [Quaternius](https://quaternius.com/) | Ana katalogda 83 farklı ürün/itch bağlantısı görüldü; ilgili çevre, insan, hayvan, prop ve hareket sayfaları açıldı. CC0/QAL farkı ayrıca araştırıldı. |
| itch.io | medieval/middle-east/desert/arabic/persian/nomad/caravan/tavern/low-poly/stylized yönlerinde ürünler tarandı; tag sayfası ürün kanıtı yerine geçirilmedi. Yeni adayların birincil sayfaları yukarıda. |
| [KayKit](https://kaylousberg.itch.io/kaykit-medieval-hexagon), KayKit Bits | Free/Extra/Source farkı ve bilinen model/klip aileleri karşılaştırıldı. KayKit CC0 ile ücretsiz fiyat birbirinden ayrı kontrol edildi. |
| [Poly Pizza](https://poly.pizza/) | Ana sayfa JS ağırlıklı; ilk turdaki doğrulanmış Modular Men koleksiyonu yeniden açıldı. Arama kabuğundan yeni tür veya lisans uydurulmadı. |
| [Sketchfab deve](https://sketchfab.com/3d-models/low-poly-camel-e2571167e3d846e59769b61913f1de64) | İndirilebilir CC Attribution model; üçgen ve vertex sayıları görülüyor. Rig/klip/ihracat biçimi teyitsiz. Önceki erişilemeyen modeller yerine gerçek açılan aday. |
| [Fab sınırlı ücretsiz](https://www.fab.com/limited-time-free) | 3 Kasım 09:59 ET’ye kadar görünen üç ürün: post-apocalyptic desert, holiday VFX, stone golem. Modern/fantastik içerikler uygun olmadığından bedava diye önerilmedi. Sürekli ücretsiz Medieval Music ayrı açıldı. |
| Unity Asset Store / Synty | Ham mesh/klip ve motor paketi ayrıldı. Bazı Unity açıklama alanları JS yüzünden boş döndü; teknik ayrıntılarda üretici ürün bilgileri/indekslenmiş açıklama koşullu kullanıldı. Single Entity/Extension alanları çelişirse koltuk varsayılmadı. |
| [Humble Software](https://www.humblebundle.com/software) | Canlı katalog açıldı; geçmiş bitmiş kampanyaya bugünkü fiyat yazılmadı. Ürün başına lisans şartı değişir; doğrulanmış ihtiyaç kapsamına eklenmedi. |
| [GameDev Market ürünü](https://www.gamedevmarket.net/asset/medieval-stylized-3d-props) | Doğrudan istek 403; web okuma aracıyla tam içerik,20USD, FBX/PNG ve Pro Licence açıldı.66mesh ve30SFX, soyut“props pack”etiketinden daha güçlü kanıt. |
| [ActorCore City Life](https://actorcore.reallusion.com/3d-motion?asset=studio-mocap-city-life) | Birincil indekslenmiş açıklamada99USD, FBX/BVH ve günlük hareketler; doğrudan HTML boş. İsimli klip listesi hesap akışı dışında teyitsiz. |
| [Rokoko destek](https://support.rokoko.com/hc/en-us/articles/4410021327121-Getting-Started-Rokoko-Studio-Motion-Library) | FBX yalnız iskelet, ücretsiz/3–20USD klip ve Studio içi inceleme koşulları doğrulandı. Hesap açılmadı, klip satın alınmadı. |
| [CMU](http://mocap.cs.cmu.edu/) | Ana kaynakta2605trial, ASF/AMCveharicîBVH bağlantıları ile özel ücretsiz kullanım şartı okundu. Parmak verisi yakalanmıyor. Site toplu tarama yapılmamasını istediğinden veri tabanı crawl edilmedi. |
| [Mixamo SSS](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html) | Ücretsiz ticari kullanımla hesap içi klip seçimi ayrı. Login yapılmadı; yalvarma/yağmur klibi bulunmuş varsayılmadı. |
| OpenGameArt / Freesound | OGA ürün ve lisans alanları yeniden okundu. Freesound29155koleksiyonu JS kabuğu döndürdü; her kayıt ayrı lisanslı olduğu için koleksiyona toptan CC0 atanmadı. |
| [Sonniss arşiv](https://sonniss.com/gameaudiogdc/) ve [2026](https://gdc.sonniss.com/) | 2015–2024arşivindeki bütün görünür tracklist bağlantıları ve2026sayfası açıldı.2025paketi yayımlanmamış;planlanan içerik2026’ya alınmış. Arşiv ZIP’leri indirilmedi. |
| [Pixabay lisans](https://pixabay.com/service/license-summary/) | Doğrudan403, web aracı lisansı açtı. Özel ticari izin, CC0değil;belirli eser/dosya seçilmediği için kapsama0. ContentIDbelirsizliği ayrı kontrol gerektirir. |
| [Zapsplat lisans](https://www.zapsplat.com/license-type/standard-license/) | 8Mayıs2026şartları:BasicMP3/atıf, PremiumMP3+WAV/atıfsız;tek kullanıcı ve ham dosya devri kısıtları. A lisansı değildir. Genel kategori başlığından dönemsel ses sayısı türetilmedi. |
| Incompetech / [Musopen](https://musopen.org/music/) | AridFoothills tekil enstrüman listesiyle elendi. Musopen403; eski eserin bestesi kamu malı olsa da modern icra kaydı kendiliğinden kamu malı değildir. Dönem müziği arşivinden izin tahmin edilmedi. |
| Google Fonts | Dört yeni ailenin resmî OFL.txt ve METADATA.pb dosyaları200ile okundu;Latin-ext işaretleri mevcut. TTF indirilmedi;Türkçe glif/render kontrolü ileri kabul adımı. |
| [Poly Haven](https://polyhaven.com/textures), [ambientCG](https://ambientcg.com/view?id=Metal032) | Kataloglar JS ağırlıklı. Mevcut PolyHavenHDRI/doku referansları korundu, Metal032ürün veCC0lisansı ayrı açıldı. Fotoğrafik PBR doku boyalı UI’yi otomatik karşılamaz. |

### Sonniss’te içerik düzeyinde kontrol

[Yayımlanmış 25 sayfalık tracklist](https://cdn.sonniss.com/storage/2025/05/Tracklist-GDC-GameAudio-Giveaway-Sheet1-1.pdf) içinde Battle Crowd grubunun kavga/nara/uğultusu, kâğıt yırtılması, zincir-metal, ahşap kapı, demirci çekiç ve yağmur/rüzgâr kayıtları görüldü. Bebek kaydı adı, bebek **soluğu** tesliminin kanıtı değil. Çağdaş metro/araç/elektrik ve canavar sesleri elendi.

Yıllık Google tracklistleri görünür hücre düzeyinde okundu; bazı HTML görünümleri listeyi kısaltıyor. Örneğin2017listesinde köy etkinliği ve atlar,2020 listesinde deve sesleri var; bunlar kervan çanı/tekerini veya at nalını ayrı bir kayıt olarak doğrulamaz. Kullanılabilir toplam yüzde, bütün yıl arşivlerinin eksiksiz öğe listesi olmadan verilmedi.2026kaynağı ayrı sayfada; eski sekizli arşiv toplamına gizlice eklenmedi. Güncel [Sonniss lisansı](https://sonniss.com/gdc-bundle-license/) K sınıfındadır.

## Önce ne tedarik edilmeli?

1. **A03 KayKit Character Animations:** ücretsiz CC0 ve ortak hareket/alet kapsamı; önce mevcut karakter rigine uyum sınanmalı. Yeni karakter gövdesi almak şart değil.
2. **CEV07 Avramania Premium veya CEV04 Slavica:** birini çevre omurgası seç. Avramania’nın12hazır yapısı daha açık döküm veriyor;Slavica daha geniş, customrigveeklisansbelirsizliği var. Birlikte bütün evleri karıştırma.
3. **ESY16 GameOver Props:** tek tek adlandırılmış alet/oda/kapı parçaları sayesinde yüksek kapsama;Klisansı ve kaynakrepo dağıtımı ayrıca çözülmeli. ESY01CC0Tools en ucuz ilk alternatifi.
4. **ANM15 Village Life:** yalvarma ve yük taşıma için somut klip kanıtı. Idle/talk bütünlüğü içinANM09/08alternatifi var;başta beş hareket paketi satın almak zorunlu değil.
5. **ORT01 + S01:** katmanlı yağmur/rüzgâr ve fiziksel ahşap/metal. Mevcut ses dosyalarıyla tekrar kontrolü sonrası seçilecek; dosya formatı çoğaltmaları benzersiz kayıt sayılmaz.

Müzikte ilk alım yarışına girmek yerine tek bir akustik tema kabulü yapılmalı. Ud, ney, kopuz, zurna, kudüm aynı enstrüman değildir. Özgül müzik sonları ve9/8davul-zurna düğünü açık kalır. Numune döngüleri bitmiş oyun müziği diye satır kapatmaz.

## Paketlerde bulunamayanlar için üretim/uyarlama yolu

- **2D:** özgün karakter portresi, CHR belgesi/iz/eldeki nesne yakın planı, gece kapısı/harita/son ekranları ve tutarlı buton halleri mevcut tekli NanoBanana briefleriyle üretilir. Saydam kaynak düz#00FF00, sonradan gerçek alfa/16pxpay/9-slice kabulü. Bu araştırmada yeni görsel üretilmedi.
- **Model:** derviş, Anadolu çavuşu, bey, özgül kaftan/başlık, örgü heybe, dokuma tezgâhı, mekanik külçe evreleri için mevcut gövde üstünde insan sanatçı uyarlaması veya lisansı açık yeni model araması gerekir. 3Düretim ajan görevi olarak açılmadı;mekanik yer tutucuyla sürebilir.
- **Animasyon:** sarık düzeltme, yular tutma, koruyucu sepete sarılma ve kanıtı saklama için seçilmiş el/kol katmanı ve nesne teması düzenlemesi;yalnız klip adı benziyor diye kabul yok. Mixamo/ActorCore/Rokoko hesabında bir sonraki seçim bu açık ID’lere göre yapılabilir;bulunmuş klip diye raporlanmadı.
- **Ses/müzik:** çocuk/yaşlı mırıltısında yaş kaydı doğrulanmış özel paket ya da ses sanatçısı;bebek soluğu, kervançanı, çekirge ve özgül foleyde tekil lisanslı kayıt. Düğün ve farklı sonlar için beste/uyarlama briefi gerekir. Genel grunt, synthvefantastik sesle açıklar gizlenmez.
- **Tanımsız SAH grupları:** klip/eşya türü belirlenmeden paket eşleştirmesi veya yüzde kapanışı yapılamaz. Önce kaynak maddede hangi teslimin istendiği açıklığa kavuşmalı;bu araştırmada ROADMAP değiştirilmedi.


## Önerilen karma setin açık ihtiyaçları

Seçki: [CEV07](#cev07), [CEV01](#cev01), [KAR02](#kar02), [KAR05](#kar05), [A03](#a03), [ANM15](#anm15), [ANM09](#anm09), [HYV05](#hyv05), [HYV03](#hyv03), [HYV14](#hyv14), [HYV16](#hyv16), [ESY16](#esy16), [ESY01](#esy01), [U02](#u02), [U04](#u04), [U03](#u03), [UI20](#ui20), [U01](#u01), [U06](#u06), [VFX02](#vfx02), [VFX07](#vfx07), [VFX13](#vfx13), [VFX15](#vfx15), [S02](#s02), [ORT01](#ort01), [S01](#s01), [S08](#s08), [FOL11](#fol11), [FOL14](#fol14), [FOL06](#fol06), [UIS03](#uis03), [UIS10](#uis10), [MUZ04](#muz04), [MUZ05](#muz05), [S11](#s11), [MIR04](#mir04), [S10](#s10). Birleşik sayı **116 (2 tam / 53 kısmi / 61 uyarlamayla)**. Aynı gereksinim iki pakette görünse de bir kez sayılır. **Kısmi temas kapanış değildir**; aynı şekilde uyarlama teslimi yapılmış değildir.


### Seçkide açık: 3D model (60)

İHT-0339 `KAPI-3D-IC`, İHT-0341 `EL-SEPET`, İHT-0343 `EL-KAMCI`, İHT-0344 `EL-KURK`, İHT-0345 `EL-HEYBE`, İHT-0346 `EL-SEPET-BUYUK`, İHT-0348 `EL-ASA`, İHT-0349 `EL-DEGNEK`, İHT-0351 `KAR-CAVUS`, İHT-0352 `KAR-TAHSILDAR`, İHT-0353 `KAR-ELCI`, İHT-0354 `KAR-DERVIS`, İHT-0355 `KAR-HABERCI`, İHT-0356 `KAR-BEY`, İHT-0358 `KAR-TEKFUR-ASKER`, İHT-0359 `YAPI-tarla, bostan`, İHT-0360 `YAPI-hizarhane`, İHT-0361 `YAPI-odunluk`, İHT-0362 `YAPI-tas_ocagi`, İHT-0363 `YAPI-avci`, İHT-0367 `YAPI-degirmen`, İHT-0368 `YAPI-sifahane`, İHT-0371 `YAPI-kirec_kuyusu`, İHT-0373 `YAPI-demir_madeni`, İHT-0374 `YAPI-demir_ocagi`, İHT-0375 `YAPI-muhafiz_kislasi`, İHT-0378 `YAPI-sur 2–3`, İHT-0381 `HYV-KECI`, İHT-0383 `HYV-KOPEK`, İHT-0385 `PROP-TEZGAH`, İHT-0387 `ANI-SILAH`, İHT-0391 `MEV-ZEMIN`, İHT-0392 `MEV-AFET`, İHT-0393 `CAS-GECE`, İHT-0402 `TUC02-OKUZ`, İHT-0405 `TUC02-KOC`, İHT-0406 `HAR10-YAY`, İHT-0407 `HAR10-MIZRAK`, İHT-0411 `CAS07-ZINDAN`, İHT-0413 `ODA01-YATAK`, İHT-0416 `ODA01-KASA`, İHT-0417 `ODA09-KABUS`, İHT-0418 `ODA08-YATAK`, İHT-0419 `ODA08-ASKILIK`, İHT-0420 `ODA08-KUTUPHANE`, İHT-0422 `KRI05-MEZAR`, İHT-0426 `ACL01-MUHAFIZ`, İHT-0432 `YAP05-ODA`, İHT-0433 `DYL02-AYRINTI-*`, İHT-0434 `DYL03-YEMIN`, İHT-0435 `DYL09-DENETCI`, İHT-0436 `SEV03-IZ`, İHT-0437 `SAB03-ORTU`, İHT-0438 `TEZ01-ORTU`, İHT-0439 `TEZ03-HAM`, İHT-0440 `TEZ04-IZ`, İHT-0441 `TEZ05-BICIM`, İHT-0442 `TEZ06-AGIZ`, İHT-0443 `TEZ08-PARCA`, İHT-0523 `SAH-EL-*`.


### Seçkide açık: 2D (319)

İHT-0001 `assets/art/ui/icon_decision_accept_48.png`, İHT-0002 `assets/art/ui/icon_decision_reject_48.png`, İHT-0003 `assets/art/ui/icon_decision_bribe_48.png`, İHT-0004 `assets/art/ui/icon_decision_barracks_48.png`, İHT-0005 `assets/art/ui/icon_bribe_pouch_full_48.png`, İHT-0006 `assets/art/ui/icon_bribe_pouch_empty_48.png`, İHT-0007 `assets/art/ui/ui_cursor_arrow_32.png`, İHT-0008 `assets/art/ui/ui_cursor_hand_32.png`, İHT-0009 `assets/art/env/env_menu_bg.png`, İHT-0010 `assets/art/env/env_gate_scene_bg.png`, İHT-0011 `assets/art/env/env_village_bg.png`, İHT-0012 `assets/art/char/char_miraen_neutral_card.png`, İHT-0013 `assets/art/char/char_miraen_idle_village.png`, İHT-0014 `assets/art/char/char_sorhan_neutral_card.png`, İHT-0015 `assets/art/char/char_sorhan_idle_village.png`, İHT-0016 `assets/art/char/char_thessra_neutral_card.png`, İHT-0017 `assets/art/char/char_thessra_idle_village.png`, İHT-0018 `assets/art/char/char_karaca_usta_neutral_card.png`, İHT-0019 `assets/art/char/char_karaca_usta_idle_village.png`, İHT-0020 `assets/art/char/char_aydogdu_neutral_card.png`, İHT-0021 `assets/art/char/char_aydogdu_idle_village.png`, İHT-0022 `assets/art/char/char_saruca_hatun_neutral_card.png`, İHT-0023 `assets/art/char/char_saruca_hatun_idle_village.png`, İHT-0024 `assets/art/char/char_soldier_01_neutral_card.png`, İHT-0025 `assets/art/char/char_soldier_01_idle_village.png`, İHT-0026 `assets/art/char/char_farmer_01_neutral_card.png`, İHT-0027 `assets/art/char/char_farmer_01_idle_village.png`, İHT-0028 `assets/art/char/char_farmer_02_neutral_card.png`, İHT-0029 `assets/art/char/char_farmer_02_idle_village.png`, İHT-0030 `assets/art/char/char_craftsman_01_neutral_card.png`, İHT-0031 `assets/art/char/char_craftsman_01_idle_village.png`, İHT-0032 `assets/art/char/char_chr_001_neutral_card.png`, İHT-0033 `assets/art/icons/icon_clue_chr_001_obje1.png`, İHT-0034 `assets/art/icons/icon_clue_chr_001_obje2.png`, İHT-0035 `assets/art/char/char_chr_002_neutral_card.png`, İHT-0036 `assets/art/icons/icon_clue_chr_002_obje1.png`, İHT-0037 `assets/art/icons/icon_clue_chr_002_obje2.png`, İHT-0038 `assets/art/char/char_chr_003_neutral_card.png`, İHT-0039 `assets/art/icons/icon_clue_chr_003_obje1.png`, İHT-0040 `assets/art/icons/icon_clue_chr_003_obje2.png`, İHT-0041 `assets/art/char/char_chr_004_neutral_card.png`, İHT-0042 `assets/art/icons/icon_clue_chr_004_obje1.png`, İHT-0043 `assets/art/icons/icon_clue_chr_004_obje2.png`, İHT-0044 `assets/art/char/char_chr_005_neutral_card.png`, İHT-0045 `assets/art/icons/icon_clue_chr_005_obje1.png`, İHT-0046 `assets/art/icons/icon_clue_chr_005_obje2.png`, İHT-0047 `assets/art/char/char_chr_006_neutral_card.png`, İHT-0048 `assets/art/icons/icon_clue_chr_006_obje1.png`, İHT-0049 `assets/art/icons/icon_clue_chr_006_obje2.png`, İHT-0050 `assets/art/char/char_chr_007_neutral_card.png`, İHT-0051 `assets/art/icons/icon_clue_chr_007_obje1.png`, İHT-0052 `assets/art/icons/icon_clue_chr_007_obje2.png`, İHT-0053 `assets/art/char/char_chr_008_neutral_card.png`, İHT-0054 `assets/art/icons/icon_clue_chr_008_obje1.png`, İHT-0055 `assets/art/icons/icon_clue_chr_008_obje2.png`, İHT-0056 `assets/art/char/char_chr_009_neutral_card.png`, İHT-0057 `assets/art/icons/icon_clue_chr_009_obje1.png`, İHT-0058 `assets/art/icons/icon_clue_chr_009_obje2.png`, İHT-0059 `assets/art/char/char_chr_010_neutral_card.png`, İHT-0060 `assets/art/icons/icon_clue_chr_010_obje1.png`, İHT-0061 `assets/art/icons/icon_clue_chr_010_obje2.png`, İHT-0062 `assets/art/char/char_chr_011_neutral_card.png`, İHT-0063 `assets/art/icons/icon_clue_chr_011_obje1.png`, İHT-0064 `assets/art/icons/icon_clue_chr_011_obje2.png`, İHT-0065 `assets/art/char/char_chr_012_neutral_card.png`, İHT-0066 `assets/art/icons/icon_clue_chr_012_obje1.png`, İHT-0067 `assets/art/icons/icon_clue_chr_012_obje2.png`, İHT-0068 `assets/art/char/char_chr_013_neutral_card.png`, İHT-0069 `assets/art/icons/icon_clue_chr_013_obje1.png`, İHT-0070 `assets/art/icons/icon_clue_chr_013_obje2.png`, İHT-0071 `assets/art/char/char_chr_014_neutral_card.png`, İHT-0072 `assets/art/icons/icon_clue_chr_014_obje1.png`, İHT-0073 `assets/art/icons/icon_clue_chr_014_obje2.png`, İHT-0074 `assets/art/char/char_chr_015_neutral_card.png`, İHT-0075 `assets/art/icons/icon_clue_chr_015_obje1.png`, İHT-0076 `assets/art/icons/icon_clue_chr_015_obje2.png`, İHT-0077 `assets/art/char/char_chr_016_neutral_card.png`, İHT-0078 `assets/art/icons/icon_clue_chr_016_obje1.png`, İHT-0079 `assets/art/icons/icon_clue_chr_016_obje2.png`, İHT-0080 `assets/art/char/char_chr_017_neutral_card.png`, İHT-0081 `assets/art/icons/icon_clue_chr_017_obje1.png`, İHT-0082 `assets/art/icons/icon_clue_chr_017_obje2.png`, İHT-0083 `assets/art/char/char_chr_018_neutral_card.png`, İHT-0084 `assets/art/icons/icon_clue_chr_018_obje1.png`, İHT-0085 `assets/art/icons/icon_clue_chr_018_obje2.png`, İHT-0086 `assets/art/char/char_chr_019_neutral_card.png`, İHT-0087 `assets/art/icons/icon_clue_chr_019_obje1.png`, İHT-0088 `assets/art/icons/icon_clue_chr_019_obje2.png`, İHT-0089 `assets/art/char/char_chr_020_neutral_card.png`, İHT-0090 `assets/art/icons/icon_clue_chr_020_obje1.png`, İHT-0091 `assets/art/icons/icon_clue_chr_020_obje2.png`, İHT-0092 `assets/art/char/char_chr_021_neutral_card.png`, İHT-0093 `assets/art/icons/icon_clue_chr_021_obje1.png`, İHT-0094 `assets/art/icons/icon_clue_chr_021_obje2.png`, İHT-0095 `assets/art/char/char_chr_022_neutral_card.png`, İHT-0096 `assets/art/icons/icon_clue_chr_022_obje1.png`, İHT-0097 `assets/art/icons/icon_clue_chr_022_obje2.png`, İHT-0098 `assets/art/char/char_chr_023_neutral_card.png`, İHT-0099 `assets/art/icons/icon_clue_chr_023_obje1.png`, İHT-0100 `assets/art/icons/icon_clue_chr_023_obje2.png`, İHT-0101 `assets/art/char/char_chr_024_neutral_card.png`, İHT-0102 `assets/art/icons/icon_clue_chr_024_obje1.png`, İHT-0103 `assets/art/icons/icon_clue_chr_024_obje2.png`, İHT-0104 `assets/art/char/char_chr_025_neutral_card.png`, İHT-0105 `assets/art/icons/icon_clue_chr_025_obje1.png`, İHT-0106 `assets/art/icons/icon_clue_chr_025_obje2.png`, İHT-0107 `assets/art/char/char_chr_026_neutral_card.png`, İHT-0108 `assets/art/icons/icon_clue_chr_026_obje1.png`, İHT-0109 `assets/art/icons/icon_clue_chr_026_obje2.png`, İHT-0110 `assets/art/char/char_chr_027_neutral_card.png`, İHT-0111 `assets/art/icons/icon_clue_chr_027_obje1.png`, İHT-0112 `assets/art/icons/icon_clue_chr_027_obje2.png`, İHT-0113 `assets/art/char/char_chr_028_neutral_card.png`, İHT-0114 `assets/art/icons/icon_clue_chr_028_obje1.png`, İHT-0115 `assets/art/icons/icon_clue_chr_028_obje2.png`, İHT-0116 `assets/art/char/char_chr_029_neutral_card.png`, İHT-0117 `assets/art/icons/icon_clue_chr_029_obje1.png`, İHT-0118 `assets/art/icons/icon_clue_chr_029_obje2.png`, İHT-0119 `assets/art/char/char_chr_030_neutral_card.png`, İHT-0120 `assets/art/icons/icon_clue_chr_030_obje1.png`, İHT-0121 `assets/art/icons/icon_clue_chr_030_obje2.png`, İHT-0122 `assets/art/icons/icon_esya_akce_64.png`, İHT-0123 `assets/art/icons/icon_esya_arpa_64.png`, İHT-0124 `assets/art/icons/icon_esya_tohum_64.png`, İHT-0125 `assets/art/icons/icon_esya_ekmek_64.png`, İHT-0126 `assets/art/icons/icon_esya_tuz_64.png`, İHT-0127 `assets/art/icons/icon_esya_kumas_64.png`, İHT-0128 `assets/art/icons/icon_esya_bakir_64.png`, İHT-0129 `assets/art/icons/icon_esya_ok_64.png`, İHT-0130 `assets/art/icons/icon_esya_hancer_64.png`, İHT-0131 `assets/art/icons/icon_esya_ilac_64.png`, İHT-0132 `assets/art/icons/icon_esya_yuzuk_64.png`, İHT-0133 `assets/ui/koy/gece_kapisi/kurk.png`, İHT-0134 `assets/ui/koy/gece_kapisi/firin.png`, İHT-0135 `assets/ui/koy/gece_kapisi/degirmen.png`, İHT-0136 `assets/ui/koy/gece_kapisi/sifahane.png`, İHT-0137 `assets/ui/koy/gece_kapisi/ahir.png`, İHT-0138 `assets/ui/koy/gece_kapisi/agil.png`, İHT-0139 `assets/ui/koy/gece_kapisi/demirhane.png`, İHT-0140 `assets/ui/koy/gece_kapisi/kislasi.png`, İHT-0141 `assets/ui/koy/gece_kapisi/maden.png`, İHT-0142 `assets/ui/koy/gece_kapisi/ocak.png`, İHT-0143 `assets/arayuz/ikonlar/uyari_isci_yok.png`, İHT-0144 `assets/arayuz/ikonlar/uyari_hammadde_yok.png`, İHT-0145 `assets/arayuz/ikonlar/uyari_ambar_dolu.png`, İHT-0146 `assets/art/ui/ui_bar_segment_full.png`, İHT-0147 `assets/art/ui/ui_bar_segment_empty.png`, İHT-0148 `assets/art/ui/ui_bar_segment_cracked_01.png`, İHT-0149 `assets/art/ui/ui_bar_segment_cracked_02.png`, İHT-0152 `assets/art/char/crowd_tekfur_spear_01_far.png`, İHT-0159 `assets/art/ui/logo_kapi_muhafizi.png`, İHT-0160 `assets/ui/atmosfer/gece_kapisi/app_icon.png`, İHT-0161 `assets/palette/palette_swatch.png`, İHT-0162 `assets/art/icons/icon_trade_contract.png`, İHT-0163 `assets/art/icons/icon_trade_price.png`, İHT-0164 `assets/art/icons/icon_trade_caravan.png`, İHT-0165 `assets/ui/koy/gece_kapisi/mevsim_ilkbahar.png`, İHT-0166 `assets/ui/koy/gece_kapisi/mevsim_yaz.png`, İHT-0167 `assets/ui/koy/gece_kapisi/mevsim_sonbahar.png`, İHT-0168 `assets/ui/koy/gece_kapisi/mevsim_kis.png`, İHT-0169 `assets/art/ui/divan_kart.png`, İHT-0170 `assets/art/icons/icon_oda_terazi.png`, İHT-0171 `assets/art/icons/icon_oda_yetenek.png`, İHT-0172 `assets/art/icons/icon_oda_yozlasma.png`, İHT-0173 `assets/art/env/oda_epilog.png`, İHT-0174 `assets/art/env/harita_uc.png`, İHT-0175 `assets/art/icons/icon_map_hisar.png`, İHT-0176 `assets/art/icons/icon_map_yol.png`, İHT-0177 `assets/art/icons/icon_map_tekfur.png`, İHT-0178 `assets/art/icons/icon_map_goc.png`, İHT-0179 `assets/art/icons/icon_savunma_okcu_64.png`, İHT-0180 `assets/art/icons/icon_savunma_mizrakli_64.png`, İHT-0181 `assets/art/fx/portrait_symptom_ates.png`, İHT-0182 `assets/art/fx/portrait_symptom_irin.png`, İHT-0183 `assets/art/fx/portrait_symptom_oksuruk.png`, İHT-0184 `assets/art/env/son_tekfur_haraccisi.png`, İHT-0185 `assets/art/env/son_ertugrul_obasi.png`, İHT-0186 `assets/art/env/son_beyin_uc_koyu.png`, İHT-0187 `assets/art/env/son_ahi_kasabasi.png`, İHT-0188 `assets/art/env/son_uc_tutundu.png`, İHT-0189 `assets/art/env/son_epilog.png`, İHT-0190 `assets/art/env/prolog_01.png`, İHT-0191 `assets/art/env/prolog_02.png`, İHT-0192 `assets/art/env/prolog_03.png`, İHT-0193 `assets/art/env/prolog_04.png`, İHT-0194 `assets/art/textures/gece_kapisi/snow_ground_albedo.png`, İHT-0195 `assets/art/textures/gece_kapisi/snow_roof_albedo.png`, İHT-0196 `assets/art/textures/gece_kapisi/flood_water_albedo.png`, İHT-0197 `assets/art/textures/gece_kapisi/burnt_ground_albedo.png`, İHT-0199 `assets/art/textures/gece_kapisi/timber_albedo.png`, İHT-0200 `assets/art/textures/gece_kapisi/paper_albedo.png`, İHT-0201 `assets/art/textures/gece_kapisi/cloth_cover_albedo.png`, İHT-0202 `assets/art/textures/gece_kapisi/tez_agil_albedo.png`, İHT-0203 `assets/art/textures/gece_kapisi/tez_degirmen_albedo.png`, İHT-0204 `assets/art/textures/gece_kapisi/tez_demir_albedo.png`, İHT-0205 `assets/art/textures/gece_kapisi/tez_bez_albedo.png`, İHT-0206 `assets/art/inspect/carik.png`, İHT-0207 `assets/art/inspect/el.png`, İHT-0208 `assets/art/inspect/yara.png`, İHT-0209 `assets/art/inspect/yanik.png`, İHT-0210 `assets/art/textures/gece_kapisi/shaky_line.png`, İHT-0211 `assets/art/decor/harvest_bunting.png`, İHT-0212 `assets/art/decor/harvest_grain_wreath.png`, İHT-0213 `assets/art/decor/harvest_cloth_banner.png`, İHT-0214 `assets/art/icons/icon_stok_afyon.png`, İHT-0215 `assets/art/icons/icon_stok_sargi.png`, İHT-0216 `assets/art/icons/icon_stok_kece.png`, İHT-0217 `assets/art/icons/icon_stok_kumas_stok.png`, İHT-0218 `assets/art/icons/icon_stok_yasak_muhur.png`, İHT-0219 `assets/art/icons/icon_stok_kacak_iksir.png`, İHT-0220 `assets/art/icons/icon_stok_zirh.png`, İHT-0221 `assets/art/icons/icon_stok_yay.png`, İHT-0222 `assets/art/icons/icon_stok_kalkan.png`, İHT-0223 `assets/art/icons/icon_stok_civi.png`, İHT-0224 `assets/art/icons/icon_stok_tirpan.png`, İHT-0225 `assets/art/icons/icon_stok_balta.png`, İHT-0226 `assets/art/icons/icon_stok_su.png`, İHT-0227 `assets/art/icons/icon_stok_saman.png`, İHT-0228 `assets/art/icons/icon_stok_ilac_stok.png`, İHT-0229 `assets/art/icons/icon_stok_heyet.png`, İHT-0230 `assets/art/icons/icon_stok_gozcu_kulesi.png`, İHT-0231 `assets/art/cards/guvercin.png`, İHT-0232 `assets/art/cards/ulak.png`, İHT-0233 `assets/art/env/acilis_ulak.png`, İHT-0234 `assets/art/ui/zar_d6.png`, İHT-0235 `assets/art/ui/zar_d12.png`, İHT-0236 `assets/art/icons/icon_usta_defteri.png`, İHT-0237 `assets/art/icons/icon_ozel_esya.png`, İHT-0238 `assets/art/icons/icon_yasam_aclik.png`, İHT-0239 `assets/art/icons/icon_yasam_yorgunluk.png`, İHT-0240 `assets/art/icons/icon_yasam_moral.png`, İHT-0241 `assets/art/env/secim_bg.png`, İHT-0242 `assets/art/env/koy_hud_bg.png`, İHT-0243 `assets/art/env/yukleme_01.png`, İHT-0244 `assets/art/env/yukleme_02.png`, İHT-0245 `assets/art/env/yukleme_03.png`, İHT-0246 `assets/art/env/yukleme_04.png`, İHT-0247 `assets/art/env/yukleme_05.png`, İHT-0248 `assets/art/env/yukleme_06.png`, İHT-0249 `assets/art/env/yukleme_07.png`, İHT-0250 `assets/art/env/yukleme_08.png`, İHT-0251 `assets/art/env/ocak_arasahne.png`, İHT-0252 `assets/art/inspect/chr_001_trace.png`, İHT-0253 `assets/art/inspect/chr_002_trace.png`, İHT-0254 `assets/art/inspect/chr_003_trace.png`, İHT-0255 `assets/art/inspect/chr_004_trace.png`, İHT-0256 `assets/art/inspect/chr_005_trace.png`, İHT-0257 `assets/art/inspect/chr_006_trace.png`, İHT-0258 `assets/art/inspect/chr_007_trace.png`, İHT-0259 `assets/art/inspect/chr_008_trace.png`, İHT-0260 `assets/art/inspect/chr_009_trace.png`, İHT-0261 `assets/art/inspect/chr_010_trace.png`, İHT-0262 `assets/art/inspect/chr_011_trace.png`, İHT-0263 `assets/art/inspect/chr_012_trace.png`, İHT-0264 `assets/art/inspect/chr_013_trace.png`, İHT-0265 `assets/art/inspect/chr_014_trace.png`, İHT-0266 `assets/art/inspect/chr_015_trace.png`, İHT-0267 `assets/art/inspect/chr_016_trace.png`, İHT-0268 `assets/art/inspect/chr_017_trace.png`, İHT-0269 `assets/art/inspect/chr_018_trace.png`, İHT-0270 `assets/art/inspect/chr_019_trace.png`, İHT-0271 `assets/art/inspect/chr_020_trace.png`, İHT-0272 `assets/art/inspect/chr_021_trace.png`, İHT-0273 `assets/art/inspect/chr_022_trace.png`, İHT-0274 `assets/art/inspect/chr_023_trace.png`, İHT-0275 `assets/art/inspect/chr_024_trace.png`, İHT-0276 `assets/art/inspect/chr_025_trace.png`, İHT-0277 `assets/art/inspect/chr_026_trace.png`, İHT-0278 `assets/art/inspect/chr_027_trace.png`, İHT-0279 `assets/art/inspect/chr_028_trace.png`, İHT-0280 `assets/art/inspect/chr_029_trace.png`, İHT-0281 `assets/art/inspect/chr_030_trace.png`, İHT-0282 `assets/ui/atmosfer/gece_kapisi/main_menu_bg.png`, İHT-0283 `assets/ui/atmosfer/gece_kapisi/interrogation_bg.png`, İHT-0284 `assets/ui/atmosfer/gece_kapisi/map_bg.png`, İHT-0285 `assets/ui/atmosfer/gece_kapisi/loading_bg.png`, İHT-0287 `assets/ui/atmosfer/gece_kapisi/button_normal.png`, İHT-0288 `assets/ui/atmosfer/gece_kapisi/button_hover.png`, İHT-0289 `assets/ui/atmosfer/gece_kapisi/button_pressed.png`, İHT-0290 `assets/ui/atmosfer/gece_kapisi/button_disabled.png`, İHT-0295 `assets/ui/atmosfer/gece_kapisi/hud_strip.png`, İHT-0296 `assets/ui/atmosfer/gece_kapisi/focus_ring.png`, İHT-0297 `assets/ui/atmosfer/gece_kapisi/tab_normal.png`, İHT-0298 `assets/ui/atmosfer/gece_kapisi/tab_selected.png`, İHT-0299 `assets/ui/atmosfer/gece_kapisi/checkbox_off.png`, İHT-0300 `assets/ui/atmosfer/gece_kapisi/checkbox_on.png`, İHT-0301 `assets/ui/atmosfer/gece_kapisi/slider_track.png`, İHT-0302 `assets/ui/atmosfer/gece_kapisi/slider_thumb.png`, İHT-0303 `assets/ui/atmosfer/gece_kapisi/scrollbar_track.png`, İHT-0304 `assets/ui/atmosfer/gece_kapisi/scrollbar_thumb.png`, İHT-0305 `assets/ui/atmosfer/gece_kapisi/loading_track.png`, İHT-0306 `assets/ui/atmosfer/gece_kapisi/loading_fill.png`, İHT-0307 `assets/ui/atmosfer/gece_kapisi/ornament_corner.png`, İHT-0308 `assets/ui/atmosfer/gece_kapisi/ornament_divider.png`, İHT-0309 `assets/ui/atmosfer/gece_kapisi/ornament_emblem.png`, İHT-0310 `assets/ui/atmosfer/gece_kapisi/ornament_seal.png`, İHT-0311 `assets/ui/atmosfer/gece_kapisi/cursor_arrow.png`, İHT-0312 `assets/ui/atmosfer/gece_kapisi/cursor_point.png`, İHT-0313 `assets/ui/atmosfer/gece_kapisi/cursor_grab.png`, İHT-0314 `assets/ui/atmosfer/gece_kapisi/cursor_busy.png`, İHT-0316 `assets/ui/atmosfer/gece_kapisi/icon_erzak.png`, İHT-0320 `assets/ui/atmosfer/gece_kapisi/icon_bez.png`, İHT-0322 `assets/ui/atmosfer/gece_kapisi/icon_nufus.png`, İHT-0323 `assets/ui/atmosfer/gece_kapisi/icon_yatak.png`, İHT-0324 `assets/ui/atmosfer/gece_kapisi/icon_saglik.png`, İHT-0325 `assets/ui/atmosfer/gece_kapisi/icon_moral.png`, İHT-0328 `assets/ui/atmosfer/gece_kapisi/icon_gun.png`, İHT-0329 `assets/ui/atmosfer/gece_kapisi/icon_kabul.png`, İHT-0330 `assets/ui/atmosfer/gece_kapisi/icon_ret.png`, İHT-0331 `assets/ui/atmosfer/gece_kapisi/icon_uyari.png`, İHT-0332 `assets/ui/atmosfer/gece_kapisi/icon_kilit.png`, İHT-0333 `assets/ui/atmosfer/gece_kapisi/icon_geri.png`, İHT-0334 `assets/ui/atmosfer/gece_kapisi/icon_kapat.png`, İHT-0335 `assets/ui/atmosfer/gece_kapisi/icon_ayarlar.png`, İHT-0336 `assets/ui/atmosfer/gece_kapisi/icon_kaydet.png`, İHT-0337 `assets/ui/atmosfer/gece_kapisi/icon_harita.png`, İHT-0338 `assets/ui/atmosfer/gece_kapisi/icon_diyalog.png`, İHT-0521 `GRV02-AYARLAR`, İHT-0522 `GRV04-DURAKLAT`.


### Seçkide açık: animasyon (20)

İHT-0389 `ANI-HAYVAN-SURU`, İHT-0394 `ANI07-ISINMA`, İHT-0398 `ANI09-BUZULME`, İHT-0429 `CAT02-KAVGA`, İHT-0446 `ANM-SEVINC`, İHT-0447 `ANM-OFKE`, İHT-0448 `ANM-PANIK`, İHT-0451 `ANM-OTUR`, İHT-0454 `ANM-NOBET`, İHT-0457 `ANM-YAGMUR-YURU`, İHT-0458 `ANM-KAR-YURU`, İHT-0460 `ANM-TEHDIT`, İHT-0461 `SAH-YORGUN-YURU`, İHT-0462 `SAH-KLIP-*`, İHT-0526 `ANM-IZ-SAKLA`, İHT-0527 `ANM-SARIK-DUZELT`, İHT-0528 `ANM-ASA-VUR`, İHT-0529 `ANM-AT-SAH`, İHT-0530 `ANM-ONE-EGIL`, İHT-0534 `ANM-YULAR-TUT`.


### Seçkide açık: ses (12)

İHT-0470 `SES-KESE`, İHT-0480 `SES-FOLEY-DERI`, İHT-0486 `SES-HASAT`, İHT-0487 `SES-EKIM`, İHT-0488 `SES-KURT`, İHT-0493 `SES-OKSURUK`, İHT-0494 `SES-CEKIRGE`, İHT-0498 `SES-GECE-BITTI`, İHT-0501 `SES-AT`, İHT-0511 `ORTAM-PAZAR`, İHT-0513 `SES-KECI`, İHT-0514 `SES-KOYUN`.


### Seçkide açık: müzik (6)

İHT-0484 `SES-DUGUN`, İHT-0505 `MUZIK-SON-TEKFUR`, İHT-0506 `MUZIK-SON-ERTUGRUL`, İHT-0507 `MUZIK-SON-BEY`, İHT-0508 `MUZIK-SON-AHI`, İHT-0509 `MUZIK-SON-UC`.


### Seçkide açık: VFX (1)

İHT-0156 `assets/art/fx/fx_fog_noise.png`.


## İncelenen hiçbir pakette doğrulanamayan ihtiyaçlar

Burada “yeryüzünde yok” iddiası yoktur. Aşağıdaki ID’ler bu tur açılan adayların hiçbirinde kanıtlanmadı; genel bir paket etiketiyle kapatılmadı.


### Hiç eşleşmeyen: 3D model (31)

İHT-0341 `EL-SEPET`, İHT-0343 `EL-KAMCI`, İHT-0344 `EL-KURK`, İHT-0345 `EL-HEYBE`, İHT-0346 `EL-SEPET-BUYUK`, İHT-0349 `EL-DEGNEK`, İHT-0354 `KAR-DERVIS`, İHT-0362 `YAPI-tas_ocagi`, İHT-0368 `YAPI-sifahane`, İHT-0371 `YAPI-kirec_kuyusu`, İHT-0374 `YAPI-demir_ocagi`, İHT-0385 `PROP-TEZGAH`, İHT-0391 `MEV-ZEMIN`, İHT-0392 `MEV-AFET`, İHT-0393 `CAS-GECE`, İHT-0416 `ODA01-KASA`, İHT-0417 `ODA09-KABUS`, İHT-0419 `ODA08-ASKILIK`, İHT-0422 `KRI05-MEZAR`, İHT-0432 `YAP05-ODA`, İHT-0433 `DYL02-AYRINTI-*`, İHT-0434 `DYL03-YEMIN`, İHT-0435 `DYL09-DENETCI`, İHT-0436 `SEV03-IZ`, İHT-0437 `SAB03-ORTU`, İHT-0438 `TEZ01-ORTU`, İHT-0440 `TEZ04-IZ`, İHT-0441 `TEZ05-BICIM`, İHT-0442 `TEZ06-AGIZ`, İHT-0443 `TEZ08-PARCA`, İHT-0523 `SAH-EL-*`.


### Hiç eşleşmeyen: 2D (295)

İHT-0001 `assets/art/ui/icon_decision_accept_48.png`, İHT-0002 `assets/art/ui/icon_decision_reject_48.png`, İHT-0003 `assets/art/ui/icon_decision_bribe_48.png`, İHT-0004 `assets/art/ui/icon_decision_barracks_48.png`, İHT-0005 `assets/art/ui/icon_bribe_pouch_full_48.png`, İHT-0006 `assets/art/ui/icon_bribe_pouch_empty_48.png`, İHT-0008 `assets/art/ui/ui_cursor_hand_32.png`, İHT-0009 `assets/art/env/env_menu_bg.png`, İHT-0010 `assets/art/env/env_gate_scene_bg.png`, İHT-0011 `assets/art/env/env_village_bg.png`, İHT-0012 `assets/art/char/char_miraen_neutral_card.png`, İHT-0013 `assets/art/char/char_miraen_idle_village.png`, İHT-0014 `assets/art/char/char_sorhan_neutral_card.png`, İHT-0015 `assets/art/char/char_sorhan_idle_village.png`, İHT-0016 `assets/art/char/char_thessra_neutral_card.png`, İHT-0017 `assets/art/char/char_thessra_idle_village.png`, İHT-0018 `assets/art/char/char_karaca_usta_neutral_card.png`, İHT-0019 `assets/art/char/char_karaca_usta_idle_village.png`, İHT-0020 `assets/art/char/char_aydogdu_neutral_card.png`, İHT-0021 `assets/art/char/char_aydogdu_idle_village.png`, İHT-0022 `assets/art/char/char_saruca_hatun_neutral_card.png`, İHT-0023 `assets/art/char/char_saruca_hatun_idle_village.png`, İHT-0024 `assets/art/char/char_soldier_01_neutral_card.png`, İHT-0025 `assets/art/char/char_soldier_01_idle_village.png`, İHT-0026 `assets/art/char/char_farmer_01_neutral_card.png`, İHT-0027 `assets/art/char/char_farmer_01_idle_village.png`, İHT-0028 `assets/art/char/char_farmer_02_neutral_card.png`, İHT-0029 `assets/art/char/char_farmer_02_idle_village.png`, İHT-0030 `assets/art/char/char_craftsman_01_neutral_card.png`, İHT-0031 `assets/art/char/char_craftsman_01_idle_village.png`, İHT-0032 `assets/art/char/char_chr_001_neutral_card.png`, İHT-0033 `assets/art/icons/icon_clue_chr_001_obje1.png`, İHT-0034 `assets/art/icons/icon_clue_chr_001_obje2.png`, İHT-0035 `assets/art/char/char_chr_002_neutral_card.png`, İHT-0036 `assets/art/icons/icon_clue_chr_002_obje1.png`, İHT-0037 `assets/art/icons/icon_clue_chr_002_obje2.png`, İHT-0038 `assets/art/char/char_chr_003_neutral_card.png`, İHT-0039 `assets/art/icons/icon_clue_chr_003_obje1.png`, İHT-0040 `assets/art/icons/icon_clue_chr_003_obje2.png`, İHT-0041 `assets/art/char/char_chr_004_neutral_card.png`, İHT-0042 `assets/art/icons/icon_clue_chr_004_obje1.png`, İHT-0043 `assets/art/icons/icon_clue_chr_004_obje2.png`, İHT-0044 `assets/art/char/char_chr_005_neutral_card.png`, İHT-0045 `assets/art/icons/icon_clue_chr_005_obje1.png`, İHT-0046 `assets/art/icons/icon_clue_chr_005_obje2.png`, İHT-0047 `assets/art/char/char_chr_006_neutral_card.png`, İHT-0048 `assets/art/icons/icon_clue_chr_006_obje1.png`, İHT-0049 `assets/art/icons/icon_clue_chr_006_obje2.png`, İHT-0050 `assets/art/char/char_chr_007_neutral_card.png`, İHT-0051 `assets/art/icons/icon_clue_chr_007_obje1.png`, İHT-0052 `assets/art/icons/icon_clue_chr_007_obje2.png`, İHT-0053 `assets/art/char/char_chr_008_neutral_card.png`, İHT-0054 `assets/art/icons/icon_clue_chr_008_obje1.png`, İHT-0055 `assets/art/icons/icon_clue_chr_008_obje2.png`, İHT-0056 `assets/art/char/char_chr_009_neutral_card.png`, İHT-0057 `assets/art/icons/icon_clue_chr_009_obje1.png`, İHT-0058 `assets/art/icons/icon_clue_chr_009_obje2.png`, İHT-0059 `assets/art/char/char_chr_010_neutral_card.png`, İHT-0060 `assets/art/icons/icon_clue_chr_010_obje1.png`, İHT-0061 `assets/art/icons/icon_clue_chr_010_obje2.png`, İHT-0062 `assets/art/char/char_chr_011_neutral_card.png`, İHT-0063 `assets/art/icons/icon_clue_chr_011_obje1.png`, İHT-0064 `assets/art/icons/icon_clue_chr_011_obje2.png`, İHT-0065 `assets/art/char/char_chr_012_neutral_card.png`, İHT-0066 `assets/art/icons/icon_clue_chr_012_obje1.png`, İHT-0067 `assets/art/icons/icon_clue_chr_012_obje2.png`, İHT-0068 `assets/art/char/char_chr_013_neutral_card.png`, İHT-0069 `assets/art/icons/icon_clue_chr_013_obje1.png`, İHT-0070 `assets/art/icons/icon_clue_chr_013_obje2.png`, İHT-0071 `assets/art/char/char_chr_014_neutral_card.png`, İHT-0072 `assets/art/icons/icon_clue_chr_014_obje1.png`, İHT-0073 `assets/art/icons/icon_clue_chr_014_obje2.png`, İHT-0074 `assets/art/char/char_chr_015_neutral_card.png`, İHT-0075 `assets/art/icons/icon_clue_chr_015_obje1.png`, İHT-0076 `assets/art/icons/icon_clue_chr_015_obje2.png`, İHT-0077 `assets/art/char/char_chr_016_neutral_card.png`, İHT-0078 `assets/art/icons/icon_clue_chr_016_obje1.png`, İHT-0079 `assets/art/icons/icon_clue_chr_016_obje2.png`, İHT-0080 `assets/art/char/char_chr_017_neutral_card.png`, İHT-0081 `assets/art/icons/icon_clue_chr_017_obje1.png`, İHT-0082 `assets/art/icons/icon_clue_chr_017_obje2.png`, İHT-0083 `assets/art/char/char_chr_018_neutral_card.png`, İHT-0084 `assets/art/icons/icon_clue_chr_018_obje1.png`, İHT-0085 `assets/art/icons/icon_clue_chr_018_obje2.png`, İHT-0086 `assets/art/char/char_chr_019_neutral_card.png`, İHT-0087 `assets/art/icons/icon_clue_chr_019_obje1.png`, İHT-0088 `assets/art/icons/icon_clue_chr_019_obje2.png`, İHT-0089 `assets/art/char/char_chr_020_neutral_card.png`, İHT-0090 `assets/art/icons/icon_clue_chr_020_obje1.png`, İHT-0091 `assets/art/icons/icon_clue_chr_020_obje2.png`, İHT-0092 `assets/art/char/char_chr_021_neutral_card.png`, İHT-0093 `assets/art/icons/icon_clue_chr_021_obje1.png`, İHT-0094 `assets/art/icons/icon_clue_chr_021_obje2.png`, İHT-0095 `assets/art/char/char_chr_022_neutral_card.png`, İHT-0096 `assets/art/icons/icon_clue_chr_022_obje1.png`, İHT-0097 `assets/art/icons/icon_clue_chr_022_obje2.png`, İHT-0098 `assets/art/char/char_chr_023_neutral_card.png`, İHT-0099 `assets/art/icons/icon_clue_chr_023_obje1.png`, İHT-0100 `assets/art/icons/icon_clue_chr_023_obje2.png`, İHT-0101 `assets/art/char/char_chr_024_neutral_card.png`, İHT-0102 `assets/art/icons/icon_clue_chr_024_obje1.png`, İHT-0103 `assets/art/icons/icon_clue_chr_024_obje2.png`, İHT-0104 `assets/art/char/char_chr_025_neutral_card.png`, İHT-0105 `assets/art/icons/icon_clue_chr_025_obje1.png`, İHT-0106 `assets/art/icons/icon_clue_chr_025_obje2.png`, İHT-0107 `assets/art/char/char_chr_026_neutral_card.png`, İHT-0108 `assets/art/icons/icon_clue_chr_026_obje1.png`, İHT-0109 `assets/art/icons/icon_clue_chr_026_obje2.png`, İHT-0110 `assets/art/char/char_chr_027_neutral_card.png`, İHT-0111 `assets/art/icons/icon_clue_chr_027_obje1.png`, İHT-0112 `assets/art/icons/icon_clue_chr_027_obje2.png`, İHT-0113 `assets/art/char/char_chr_028_neutral_card.png`, İHT-0114 `assets/art/icons/icon_clue_chr_028_obje1.png`, İHT-0115 `assets/art/icons/icon_clue_chr_028_obje2.png`, İHT-0116 `assets/art/char/char_chr_029_neutral_card.png`, İHT-0117 `assets/art/icons/icon_clue_chr_029_obje1.png`, İHT-0118 `assets/art/icons/icon_clue_chr_029_obje2.png`, İHT-0119 `assets/art/char/char_chr_030_neutral_card.png`, İHT-0120 `assets/art/icons/icon_clue_chr_030_obje1.png`, İHT-0121 `assets/art/icons/icon_clue_chr_030_obje2.png`, İHT-0122 `assets/art/icons/icon_esya_akce_64.png`, İHT-0123 `assets/art/icons/icon_esya_arpa_64.png`, İHT-0124 `assets/art/icons/icon_esya_tohum_64.png`, İHT-0125 `assets/art/icons/icon_esya_ekmek_64.png`, İHT-0126 `assets/art/icons/icon_esya_tuz_64.png`, İHT-0127 `assets/art/icons/icon_esya_kumas_64.png`, İHT-0128 `assets/art/icons/icon_esya_bakir_64.png`, İHT-0129 `assets/art/icons/icon_esya_ok_64.png`, İHT-0130 `assets/art/icons/icon_esya_hancer_64.png`, İHT-0131 `assets/art/icons/icon_esya_ilac_64.png`, İHT-0132 `assets/art/icons/icon_esya_yuzuk_64.png`, İHT-0133 `assets/ui/koy/gece_kapisi/kurk.png`, İHT-0134 `assets/ui/koy/gece_kapisi/firin.png`, İHT-0135 `assets/ui/koy/gece_kapisi/degirmen.png`, İHT-0136 `assets/ui/koy/gece_kapisi/sifahane.png`, İHT-0137 `assets/ui/koy/gece_kapisi/ahir.png`, İHT-0138 `assets/ui/koy/gece_kapisi/agil.png`, İHT-0139 `assets/ui/koy/gece_kapisi/demirhane.png`, İHT-0140 `assets/ui/koy/gece_kapisi/kislasi.png`, İHT-0141 `assets/ui/koy/gece_kapisi/maden.png`, İHT-0142 `assets/ui/koy/gece_kapisi/ocak.png`, İHT-0143 `assets/arayuz/ikonlar/uyari_isci_yok.png`, İHT-0144 `assets/arayuz/ikonlar/uyari_hammadde_yok.png`, İHT-0145 `assets/arayuz/ikonlar/uyari_ambar_dolu.png`, İHT-0146 `assets/art/ui/ui_bar_segment_full.png`, İHT-0147 `assets/art/ui/ui_bar_segment_empty.png`, İHT-0148 `assets/art/ui/ui_bar_segment_cracked_01.png`, İHT-0149 `assets/art/ui/ui_bar_segment_cracked_02.png`, İHT-0152 `assets/art/char/crowd_tekfur_spear_01_far.png`, İHT-0159 `assets/art/ui/logo_kapi_muhafizi.png`, İHT-0160 `assets/ui/atmosfer/gece_kapisi/app_icon.png`, İHT-0161 `assets/palette/palette_swatch.png`, İHT-0162 `assets/art/icons/icon_trade_contract.png`, İHT-0163 `assets/art/icons/icon_trade_price.png`, İHT-0164 `assets/art/icons/icon_trade_caravan.png`, İHT-0165 `assets/ui/koy/gece_kapisi/mevsim_ilkbahar.png`, İHT-0166 `assets/ui/koy/gece_kapisi/mevsim_yaz.png`, İHT-0167 `assets/ui/koy/gece_kapisi/mevsim_sonbahar.png`, İHT-0168 `assets/ui/koy/gece_kapisi/mevsim_kis.png`, İHT-0169 `assets/art/ui/divan_kart.png`, İHT-0170 `assets/art/icons/icon_oda_terazi.png`, İHT-0171 `assets/art/icons/icon_oda_yetenek.png`, İHT-0172 `assets/art/icons/icon_oda_yozlasma.png`, İHT-0173 `assets/art/env/oda_epilog.png`, İHT-0174 `assets/art/env/harita_uc.png`, İHT-0175 `assets/art/icons/icon_map_hisar.png`, İHT-0176 `assets/art/icons/icon_map_yol.png`, İHT-0177 `assets/art/icons/icon_map_tekfur.png`, İHT-0178 `assets/art/icons/icon_map_goc.png`, İHT-0179 `assets/art/icons/icon_savunma_okcu_64.png`, İHT-0180 `assets/art/icons/icon_savunma_mizrakli_64.png`, İHT-0181 `assets/art/fx/portrait_symptom_ates.png`, İHT-0182 `assets/art/fx/portrait_symptom_irin.png`, İHT-0183 `assets/art/fx/portrait_symptom_oksuruk.png`, İHT-0184 `assets/art/env/son_tekfur_haraccisi.png`, İHT-0185 `assets/art/env/son_ertugrul_obasi.png`, İHT-0186 `assets/art/env/son_beyin_uc_koyu.png`, İHT-0187 `assets/art/env/son_ahi_kasabasi.png`, İHT-0188 `assets/art/env/son_uc_tutundu.png`, İHT-0189 `assets/art/env/son_epilog.png`, İHT-0190 `assets/art/env/prolog_01.png`, İHT-0191 `assets/art/env/prolog_02.png`, İHT-0192 `assets/art/env/prolog_03.png`, İHT-0193 `assets/art/env/prolog_04.png`, İHT-0194 `assets/art/textures/gece_kapisi/snow_ground_albedo.png`, İHT-0195 `assets/art/textures/gece_kapisi/snow_roof_albedo.png`, İHT-0196 `assets/art/textures/gece_kapisi/flood_water_albedo.png`, İHT-0197 `assets/art/textures/gece_kapisi/burnt_ground_albedo.png`, İHT-0199 `assets/art/textures/gece_kapisi/timber_albedo.png`, İHT-0200 `assets/art/textures/gece_kapisi/paper_albedo.png`, İHT-0201 `assets/art/textures/gece_kapisi/cloth_cover_albedo.png`, İHT-0202 `assets/art/textures/gece_kapisi/tez_agil_albedo.png`, İHT-0203 `assets/art/textures/gece_kapisi/tez_degirmen_albedo.png`, İHT-0204 `assets/art/textures/gece_kapisi/tez_demir_albedo.png`, İHT-0205 `assets/art/textures/gece_kapisi/tez_bez_albedo.png`, İHT-0206 `assets/art/inspect/carik.png`, İHT-0207 `assets/art/inspect/el.png`, İHT-0208 `assets/art/inspect/yara.png`, İHT-0209 `assets/art/inspect/yanik.png`, İHT-0210 `assets/art/textures/gece_kapisi/shaky_line.png`, İHT-0211 `assets/art/decor/harvest_bunting.png`, İHT-0212 `assets/art/decor/harvest_grain_wreath.png`, İHT-0213 `assets/art/decor/harvest_cloth_banner.png`, İHT-0214 `assets/art/icons/icon_stok_afyon.png`, İHT-0215 `assets/art/icons/icon_stok_sargi.png`, İHT-0216 `assets/art/icons/icon_stok_kece.png`, İHT-0217 `assets/art/icons/icon_stok_kumas_stok.png`, İHT-0218 `assets/art/icons/icon_stok_yasak_muhur.png`, İHT-0219 `assets/art/icons/icon_stok_kacak_iksir.png`, İHT-0220 `assets/art/icons/icon_stok_zirh.png`, İHT-0221 `assets/art/icons/icon_stok_yay.png`, İHT-0222 `assets/art/icons/icon_stok_kalkan.png`, İHT-0223 `assets/art/icons/icon_stok_civi.png`, İHT-0224 `assets/art/icons/icon_stok_tirpan.png`, İHT-0225 `assets/art/icons/icon_stok_balta.png`, İHT-0226 `assets/art/icons/icon_stok_su.png`, İHT-0227 `assets/art/icons/icon_stok_saman.png`, İHT-0228 `assets/art/icons/icon_stok_ilac_stok.png`, İHT-0229 `assets/art/icons/icon_stok_heyet.png`, İHT-0230 `assets/art/icons/icon_stok_gozcu_kulesi.png`, İHT-0231 `assets/art/cards/guvercin.png`, İHT-0232 `assets/art/cards/ulak.png`, İHT-0233 `assets/art/env/acilis_ulak.png`, İHT-0234 `assets/art/ui/zar_d6.png`, İHT-0235 `assets/art/ui/zar_d12.png`, İHT-0236 `assets/art/icons/icon_usta_defteri.png`, İHT-0237 `assets/art/icons/icon_ozel_esya.png`, İHT-0238 `assets/art/icons/icon_yasam_aclik.png`, İHT-0239 `assets/art/icons/icon_yasam_yorgunluk.png`, İHT-0240 `assets/art/icons/icon_yasam_moral.png`, İHT-0241 `assets/art/env/secim_bg.png`, İHT-0242 `assets/art/env/koy_hud_bg.png`, İHT-0243 `assets/art/env/yukleme_01.png`, İHT-0244 `assets/art/env/yukleme_02.png`, İHT-0245 `assets/art/env/yukleme_03.png`, İHT-0246 `assets/art/env/yukleme_04.png`, İHT-0247 `assets/art/env/yukleme_05.png`, İHT-0248 `assets/art/env/yukleme_06.png`, İHT-0249 `assets/art/env/yukleme_07.png`, İHT-0250 `assets/art/env/yukleme_08.png`, İHT-0251 `assets/art/env/ocak_arasahne.png`, İHT-0252 `assets/art/inspect/chr_001_trace.png`, İHT-0253 `assets/art/inspect/chr_002_trace.png`, İHT-0254 `assets/art/inspect/chr_003_trace.png`, İHT-0255 `assets/art/inspect/chr_004_trace.png`, İHT-0256 `assets/art/inspect/chr_005_trace.png`, İHT-0257 `assets/art/inspect/chr_006_trace.png`, İHT-0258 `assets/art/inspect/chr_007_trace.png`, İHT-0259 `assets/art/inspect/chr_008_trace.png`, İHT-0260 `assets/art/inspect/chr_009_trace.png`, İHT-0261 `assets/art/inspect/chr_010_trace.png`, İHT-0262 `assets/art/inspect/chr_011_trace.png`, İHT-0263 `assets/art/inspect/chr_012_trace.png`, İHT-0264 `assets/art/inspect/chr_013_trace.png`, İHT-0265 `assets/art/inspect/chr_014_trace.png`, İHT-0266 `assets/art/inspect/chr_015_trace.png`, İHT-0267 `assets/art/inspect/chr_016_trace.png`, İHT-0268 `assets/art/inspect/chr_017_trace.png`, İHT-0269 `assets/art/inspect/chr_018_trace.png`, İHT-0270 `assets/art/inspect/chr_019_trace.png`, İHT-0271 `assets/art/inspect/chr_020_trace.png`, İHT-0272 `assets/art/inspect/chr_021_trace.png`, İHT-0273 `assets/art/inspect/chr_022_trace.png`, İHT-0274 `assets/art/inspect/chr_023_trace.png`, İHT-0275 `assets/art/inspect/chr_024_trace.png`, İHT-0276 `assets/art/inspect/chr_025_trace.png`, İHT-0277 `assets/art/inspect/chr_026_trace.png`, İHT-0278 `assets/art/inspect/chr_027_trace.png`, İHT-0279 `assets/art/inspect/chr_028_trace.png`, İHT-0280 `assets/art/inspect/chr_029_trace.png`, İHT-0281 `assets/art/inspect/chr_030_trace.png`, İHT-0282 `assets/ui/atmosfer/gece_kapisi/main_menu_bg.png`, İHT-0283 `assets/ui/atmosfer/gece_kapisi/interrogation_bg.png`, İHT-0285 `assets/ui/atmosfer/gece_kapisi/loading_bg.png`, İHT-0295 `assets/ui/atmosfer/gece_kapisi/hud_strip.png`, İHT-0296 `assets/ui/atmosfer/gece_kapisi/focus_ring.png`, İHT-0309 `assets/ui/atmosfer/gece_kapisi/ornament_emblem.png`, İHT-0310 `assets/ui/atmosfer/gece_kapisi/ornament_seal.png`, İHT-0312 `assets/ui/atmosfer/gece_kapisi/cursor_point.png`, İHT-0313 `assets/ui/atmosfer/gece_kapisi/cursor_grab.png`, İHT-0314 `assets/ui/atmosfer/gece_kapisi/cursor_busy.png`, İHT-0316 `assets/ui/atmosfer/gece_kapisi/icon_erzak.png`, İHT-0320 `assets/ui/atmosfer/gece_kapisi/icon_bez.png`, İHT-0322 `assets/ui/atmosfer/gece_kapisi/icon_nufus.png`, İHT-0324 `assets/ui/atmosfer/gece_kapisi/icon_saglik.png`, İHT-0325 `assets/ui/atmosfer/gece_kapisi/icon_moral.png`, İHT-0329 `assets/ui/atmosfer/gece_kapisi/icon_kabul.png`, İHT-0330 `assets/ui/atmosfer/gece_kapisi/icon_ret.png`, İHT-0332 `assets/ui/atmosfer/gece_kapisi/icon_kilit.png`, İHT-0333 `assets/ui/atmosfer/gece_kapisi/icon_geri.png`, İHT-0335 `assets/ui/atmosfer/gece_kapisi/icon_ayarlar.png`, İHT-0336 `assets/ui/atmosfer/gece_kapisi/icon_kaydet.png`, İHT-0338 `assets/ui/atmosfer/gece_kapisi/icon_diyalog.png`, İHT-0521 `GRV02-AYARLAR`, İHT-0522 `GRV04-DURAKLAT`.


### Hiç eşleşmeyen: animasyon (10)

İHT-0394 `ANI07-ISINMA`, İHT-0398 `ANI09-BUZULME`, İHT-0457 `ANM-YAGMUR-YURU`, İHT-0458 `ANM-KAR-YURU`, İHT-0462 `SAH-KLIP-*`, İHT-0526 `ANM-IZ-SAKLA`, İHT-0527 `ANM-SARIK-DUZELT`, İHT-0528 `ANM-ASA-VUR`, İHT-0530 `ANM-ONE-EGIL`, İHT-0534 `ANM-YULAR-TUT`.


### Hiç eşleşmeyen: ses (6)

İHT-0488 `SES-KURT`, İHT-0493 `SES-OKSURUK`, İHT-0498 `SES-GECE-BITTI`, İHT-0501 `SES-AT`, İHT-0513 `SES-KECI`, İHT-0514 `SES-KOYUN`.


### Hiç eşleşmeyen: müzik (6)

İHT-0484 `SES-DUGUN`, İHT-0505 `MUZIK-SON-TEKFUR`, İHT-0506 `MUZIK-SON-ERTUGRUL`, İHT-0507 `MUZIK-SON-BEY`, İHT-0508 `MUZIK-SON-AHI`, İHT-0509 `MUZIK-SON-UC`.


### Hiç eşleşmeyen: VFX (0)

.


## Belge doğrulaması

Ana liste ve paket eşleştirmelerinin sayısal kaynakları aynı klasördeki `arastirma_2_ihtiyaclar.json` ve `arastirma_2_paketler.json` dosyalarıdır. Bunlar araştırma verisidir, oyun kodu değildir. Kaynak HTML önbelleği, üçüncü taraf tam metinleri ve araştırma yardımcıları repoya eklenmedi. ROADMAP, aktif envanter durumları, oyun dosyaları ve assetler değiştirilmedi.
