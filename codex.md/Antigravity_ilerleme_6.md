# Antigravity İlerleme Dosyası — Görev 6

- **Ajan Adı:** Antigravity
- **Görev:** Görev 6 — Yeni Ziyaretçiler ve Köy Olayları (Bölüm B), Ardından Son Okuma ve Üslup Cilası (Bölüm A)
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 01:45
- **İş Sırası:** Ahmet'in direktifi gereği önce Bölüm B (Yeni Ziyaretçiler ve Köy Olayları), ardından Bölüm A (Son Okuma ve Üslup Cilası).

---

## Bölüm B — Yeni Kapı Ziyaretçileri ve Köy Olayları

### Analiz: Mevcut Durum ve Eksik Ziyaretçi Tipleri
Mevcut 20 kapı diyaloğu (`diyalog_01` – `diyalog_20`), CHR kartları (`chr_001` – `chr_030`) ve 13. yüzyıl Anadolu Selçuklu uç beyliği atmosferi incelendi:
- **Mevcut Yapı:** Rençberler, zanaatkarlar (demirci kalfası, kalaycı, fırıncı, saraç, nalbant), kışla kaçkını veya yenik askerler ve çobanlar ağırlıktadır.
- **Eksik Tipler:**
  1. *Kalenderi / Gezgin Derviş:* Yaylaları gezen, dünya malına tamah etmeyen, obaların ahvalini ve Moğol dumanını haber veren bilge sufi.
  2. *Kervancı / Şüpheli İpek Tüccarı (Moğol Casusu Şüphesi):* Kaftanı çamurlu, safran ve ipek satan, boynunda gizli Moğol payzası taşıyan hesapçı Şark tüccarı.
  3. *Sancak İnzibat Çavuşu (Firari Avcısı):* Mühürlü celp fermanıyla kışla firarilerini arayan, kaba, rüşvetçi ve tehditkâr kışla çavuşu.
  4. *Vebalı / Zehirli Humma Taşıyan Kadın ve Kucağındaki Kundak:* Obası kırılmış, kendisi ölüm döşeğinde, bebeğini köyün sütannesine emanet etmek isteyen fedakar ana (merhamet ve salgın riski imtihanı).
  5. *Kaçak Fırın/Han Çırağı (Akraba Habercisi Çocuk):* Fırından dayak yiyip kaçan, `diyalog_01`'deki rençber Hamza'nın "öldü" sandığı öz yeğeni.
  6. *Gezgin Otacı / Sahte Cerrah:* Kurutulmuş ot ve merhem satan, afyon şurubuyla köylüyü uyutup soymayı planlayan şarlatan tıp talebesi.
  7. *Yalancı Şahit / Azledilmiş Fitneci Kâtip:* Mahkemeden kovulmuş, sahte vakıfnamelerle köyün tarlalarına çökmeye çalışan, kâtip Hasan Çelebi'nin eski hasmı.
  8. *İntikam Peşindeki Harami Bacısı:* Kalkanlı ve hançerli Türkmen savaşçı kadın; `diyalog_20`'deki nalbantın nalladığı öldürülen harami beyinin intikamını arayan savaşçı.
  9. *Geri Çevrilen Kervanın Habercisi / Kıtlık Mağduru:* Dün gece kapıdan kovulan mültecilerin dağda kurtlara yem olduğunu yüzümüze vuran, ambarı açtırmak için kurnazca pusu kuran haberci.
  10. *Muhafızın Uzak Akrabası (Yeğen / Kan Bağı Sınavı):* Muhafızın çocukluk obasından kaçan, peşinde voyvoda atlıları olan genç akraba kız; eşin ve muhafızın kan bağı sınavı.

---

### Parti 1 & 2: 10 Yeni Kapı Ziyaretçisi ve Eş Düşünceleri (Tamamlandı)

`data/diyalog/diyalog_01_20.json` tablosuna 10 yeni ziyaretçi eklendi (toplam 30 ziyaretçi); her biri için derin, tekrarsız ve önceki olaylar/ziyaretçilerle organik bağlı sorgu ağaçları kuruldu:

1. **`diyalog_21` (Seyyid Burhan - Kalenderi Derviş):** Yayla dumanını aşmış, ardıç asalı sufi. `diyalog_04`'teki çobanın geride kalan anasından sağ salim müjdesi getirir (`dervis_mujde_haberi`). Cübbesinin astarında Moğol ulağının cesedinden aldığı ipek fermanı taşır (`mogol_gizli_ferman`).
2. **`diyalog_22` (Hacı Bedreddin - Tebriz İpekçisi):** Çamurlu ipek kaftanlı tüccar. `diyalog_02`'deki Kayserili çuhacıyı kervandan kumaş ve 12 dirhem aşırmakla suçlar (`cuhaci_ortagi_iddiasi`). Kuşağında gümüş Moğol payzası saklar (`mogol_payza_suphesi`).
3. **`diyalog_23` (Sungur Çavuş - Sancak İnzibat Eri):** Mühürlü celp fermanıyla firari avlayan kışla çavuşu. Doğrudan `diyalog_03` (Sivas bozgun askeri) ve `diyalog_06` (silahsız piyade) neferlerini arar; kelle yerine altın rüşvetle şantaj yapar (`inzibat_santaji`, `firari_avcisi_korkutma`).
4. **`diyalog_24` (Gülhatun - Vebalı Ana ve Kundaktaki Bebek):** Obasını kıran kara hummadan kaçıp 3 aylık bebeğini kurtarmak isteyen fedakar ana. Kendisi kireç ocağında tecrite razı olurken sabisini köyün sütannesine emanet etmek ister (`vebali_bebek_emaneti`, `kirec_ocagi_karantina`).
5. **`diyalog_25` (Dursun - Kaçak Fırın Çırağı):** Falakadan kaçan 13-14 yaşlarında oğlan. `diyalog_01`'deki rençber Hamza'nın öldü bildiği öz yeğenidir! Hamza Dayısı ile büyük bir kavuşma dramı yaşar (`hamza_yegen_kavusma`, `yetenekli_firin_ciragi`).
6. **`diyalog_26` (Hekim Lokman - Gezgin Otacı / Sahte Cerrah):** Konya Darüşşifası'ndan kovulmuş, afyon şurubuyla köylüyü uyutmayı hedefleyen şarlatan. `diyalog_11`'deki yaralı köprü nöbetçisinin kangren olan yarasının sorumlusudur (`sahte_hekim_itirafi`, `afyon_merhem_hibesi`).
7. **`diyalog_27` (Molla Şükrü - Azledilmiş Kadı Kâtibi):** Rüşvetten kovulmuş kâtip. Köydeki sürgün kâtip Hasan Çelebi'nin eski hasmıdır; Hasan'ın defterini zimmet belgesi sayar, heybesinde sahte vakıfnameler taşır (`katip_hasan_hasimligi`, `sahte_vakifname_suphesi`).
8. **`diyalog_28` (Banu Hatun - Harami Bacısı / İntikam Savaşçısı):** Kalkanlı Türkmen kızı. Öldürülen harami ağabeyinin atına zehirli çivi çakan `diyalog_20`'deki seyyar nalbantı aramaya gelmiştir (`nalbant_ihanet_iddiasi`, `harami_kislaya_baglilik`).
9. **`diyalog_29` (Kervancı İlyas - Kafile Habercisi):** Dün gece kapıdan çevrilen mültecilerin karda donduğunu yüzümüze vuran öfkeli kervancı. Oyuncunun önceki ret kararlarının acı bedelini yüzüne çarpar; ambardan un ve battaniye yardımı talep eder (`donan_kafile_kurtarma`, `ambardan_yardim_sevk`).
10. **`diyalog_30` (Turna Hatun - Muhafızın Uzak Yeğeni):** Muhafızın ata ocağından kaçan, boynunda aile muskası taşıyan yetim yeğen. Peşinde voyvoda atlıları vardır; `diyalog_25`'teki fırın çırağı Dursun'un ablasıdır (`yegen_turna_siginma`, `yengeden_sefaat_istegi`).

- **Eş Düşünceleri (`data/diyalog/es_kapi_dusunceleri.json`):** 10 yeni ziyaretçinin her biri için `karsilama`, `kritik_soru`, `karar_oncesi`, `karar_kabul` ve `karar_ret` olmak üzere 4 aşamalı eş fısıltıları yazıldı.
- **Doğrulama:**
  - `diyalog_butunluk_test.gd`: 30 kapı diyaloğu, 0 kırık bağ, 0 yetim düğüm, Türkçe karakterler eksiksiz — BAŞARILI (0 hata).
  - `es_yorumu_test.gd`: 30 ziyaretçinin 4 aşamalı eş düşünceleri — BAŞARILI (0 hata).
  - `diyalog_mantigi_test.gd`: GEÇTİ (0 hata).

---

### Parti 3: 8 Yeni Köy Olayı (Tamamlandı)

Köy simülasyonunda kapı kararlarının sonuçları, mevsim ve asayiş durumuna bağlı 8 adet yeni olay (`data/olaylar/*.tres`) oluşturuldu ve `data/metin/metinler.csv` içine 64 anahtar eklendi:

1. **`kavga_harman` (Harman Yeri Sınır Kavgası):** Rençberler harman taşı için birbirine girer; eşit paylaştırma, para cezası veya ambardan ortak harman tahsisi seçenekleri.
2. **`ambarda_hirsizlik` (Zahire Ambarında Gece Hırsızlığı):** Ambar kilidi kırılır; evleri aratma, Saruca Hatun'un kefaletiyle karşılama veya dedikodu çıkmaması için örtbas etme.
3. **`salgin_fisiltisi` (Kuyu Başında Salgın Fısıltısı):** Kuyu suyundan veba korkusu; kireç döktürüp Miraen'i görevlendirme, karantina çadırı kurma veya nöbeti artırma.
4. **`koy_dugunu` (Yetim Kızın Köy Düğünü):** Demirci kalfası ile yetim Türkmen kızının evliliği; toy aşı verme (moral/adalet patlaması), sade nikah veya kış ortasında yasaklama.
5. **`firari_cenazesi` (Dağ Geçidinde Donan Garibin Cenazesi):** Donan mültecinin cenazesi; köy mezarlığına defnedip helallik verme, kimsesizler vadisine gömme veya subaşıyı bekleme.
6. **`samanlik_yangini` (Gece Samanlık Yangını):** Gece yarısı kundaklama; el birliğiyle söndürme, hendek kazıp evleri kurtarma veya kışla askerini kundakçının peşine salma.
7. **`gece_donu` (Erken Bastıran Gece Ayazı):** Kuru ayaz su arklarını dondurur; tarlada duman tüttürme, acil hasatla ambarı doldurma veya fidanların direncine güvenme.
8. **`harami_elcisi` (Dağ Çetesinden Gelen Tehdit Pusulası):** Çete reisinden haraç tehdidi; kule nöbetini artırıp meydan okuma, kan dökülmesin diye erzak verme veya dere boyunda pusu kurma.

- **Doğrulama:**
  - `tests/unit/olay/yeni_olaylar_test.gd`: 8 olayın tamamı Katalog tarafından yüklendi, 24 seçenek ve 24 sonuç anahtarının çevirisi doğrulandı — BAŞARILI (0 hata).
  - `tests/unit/olay/on_kosul_test.gd`: Koşul ve tetik mekanizması — GEÇTİ (0 hata).
  - `python tools/metin_dogrula.py --kaynak`: PASS (0 hata).
  - `python tools/soz_tasarimi_dogrula.py`: GEÇTİ (0 hata).

---

## Bölüm A — Bütün Metinlerde Son Okuma ve Üslup Cilası

Oyundaki tüm oyuncu metinleri (30 kapı diyaloğu, 18 Parley köy/eş sohbet sekansı, 30 eş kapı düşüncesi, köy olayları, `metinler.csv` ve `docs/YER_TUTUCU_METINLER.csv`) baştan sona tarandı:
- Yazım, noktalama ve Türkçe karakterler denetlendi.
- Dönem dışı modern kelimeler, yabancı kökenli modern terimler (`alarm`, `tempo`) ve yapay formül sözcükleri (`çünkü`, `aslında`, `köyünüzün geleceği`) ayıklandı.
- Karakterlerin seslerinin (Ahilik, dervişlik, rençberlik, Türkmen savaşçılığı, kışla dili) özgünlüğü ve üslup tutarlılığı pekiştirildi.

### Yapılan Üslup ve Düzeltmeler Tablosu

| Dosya / Anahtar | Eski Metin (Sorunlu / Dönem Dışı) | Yeni Metin (Tarihsel / Akıcı Türkçe) | Gerekçe / Düzeltme |
|---|---|---|---|
| `metinler.csv` (`sohbet.chr_022.acilis1`) | "...Tarlada tempo tutarım, çocuklara alarm vuruşunu sayarım..." | "...Tarlada usul tutarım, çocuklara tehlike vuruşunu sayarım..." | 13. yy Anadolu davulcusunda modern İtalyanca/Fransızca "tempo" ve "alarm" kelimeleri yerine döneme uygun "usul" ve "tehlike vuruşu" getirildi. |
| `metinler.csv` (`sohbet.chr_022.c11`) | "...Tarla Damı'nda tempo tutarım, Meydan'da alarmı çocuklara sayarım..." | "...Tarla Damı'nda usul tutarım, Meydan'da tehlike vuruşunu çocuklara sayarım..." | "Tempo" -> "usul", "alarm" -> "tehlike vuruşu" düzeltmesi. |
| `metinler.csv` (`sohbet.chr_022.c6`) | "Tempo, alarm, yürüyüş vuruşu bilirim." | "Usul, baskın kösü, yürüyüş vuruşu bilirim." | "Alarm" askeri davul terminolojisinde "baskın kösü" olarak yerlileştirildi. |
| `metinler.csv` (`sohbet.chr_022.c7`) | "Alarm üç kısa bir uzun. Tarla temposu yavaş başlar..." | "Baskın kösü üç kısa bir uzun. Tarla usulü yavaş başlar..." | Dönem ruhuna uygun askeri davul tabiri. |
| `metinler.csv` (`sohbet.chr_022.c8`) | "...Tarla Damı'nda tempo tutarım, çocuklara alarmı sayarım..." | "...Tarla Damı'nda usul tutarım, çocuklara tehlike vuruşunu sayarım..." | Modern terimler temizlendi. |
| `metinler.csv` (`sohbet.chr_022.giris1`) | "...tempo tutmaya gelmiş yorgun bir ocak eri..." | "...usul vurmaya gelmiş yorgun bir ocak eri..." | Anlatıcı metninde üslup cilası. |
| `metinler.csv` (`sohbet.chr_022.s10`) | "Sen tempo arayan değil, davul satmış kaçaksın!" | "Sen usul arayan değil, davul satmış kaçaksın!" | Sorgu cümlesi 13. yy Türkçesine uyarlandı. |
| `metinler.csv` (`sohbet.chr_022.s7`) | "alarm vuruşu kaçtır, tarla temposu nasıl sayılır?" | "baskın vuruşu kaçtır, tarla usulü nasıl sayılır?" | Soru kalıbı döneme oturtuldu. |
| `metinler.csv` (`sohbet.sorhan.c23`) | "Çünkü yolum hep buraya çıkıyor. Bu da bir hesap." | "Zira yolum hep buraya çıkar; bu da bir hesaptır." | Formül "çünkü" bağlacı yerine dönemin klasik bağlacı "zira" getirildi, yüklem güçlendirildi. |
| `metinler.csv` (`sohbet.thessra.c3`) | "...Bana kimse hekim demez; kadınım çünkü." | "...Bana kimse hekim demez; kadın kızı olduğumdan ötürü." | "Çünkü" yapaylığı kaldırıldı, 13. yy halk ağzına uygun hüzünlü ifade getirildi. |

---

## Genel Görev 6 Özeti ve Doğrulama Sonuçları

1. **Bölüm B:**
   - 10 yeni kapı ziyaretçisi (`diyalog_21` – `diyalog_30`) yazıldı ve `data/diyalog/diyalog_01_20.json` içine eklendi (toplam 30 ziyaretçi).
   - Her ziyaretçi için CHR tanımları `docs/DIYALOG_ANA_PLANI.md` envanterine işlendi.
   - 10 yeni ziyaretçinin her biri için `data/diyalog/es_kapi_dusunceleri.json` tablosuna 4 aşamalı eş yorumları yazıldı.
   - Önceki ziyaretçilere ve kararlara (`diyalog_01`, `02`, `03`, `04`, `06`, `11`, `20`, Hasan Çelebi, ret kararları) derin bağlantılar kuruldu.
   - 8 yeni köy olayı (`kavga_harman`, `ambarda_hirsizlik`, `salgin_fisiltisi`, `koy_dugunu`, `firari_cenazesi`, `samanlik_yangini`, `gece_donu`, `harami_elcisi`) oluşturuldu ve `data/metin/metinler.csv` içine 64 yeni anahtar eklendi.
2. **Bölüm A:**
   - Tüm diyalog ve olay metinlerinde son okuma yapıldı, dönem dışı kelimeler ("tempo", "alarm", "çünkü") ayıklandı, `metinler.tr.translation` yeniden derlendi.
3. **Test Sonuçları:**
   - `python tools/metin_dogrula.py --kaynak`: PASS (0 hata)
   - `python tools/soz_tasarimi_dogrula.py`: GEÇTİ (0 hata)
   - `Godot --headless -s tests/unit/diyalog/diyalog_butunluk_test.gd`: BAŞARILI (0 hata, 30 kapı diyaloğu + 18 Parley sekansı)
   - `Godot --headless -s tests/unit/kapi/es_yorumu_test.gd`: BAŞARILI (0 hata, 30 ziyaretçi eş düşüncesi)
   - `Godot --headless -s tests/unit/kvr/diyalog_mantigi_test.gd`: GEÇTİ (0 hata)
   - `Godot --headless -s tests/unit/olay/yeni_olaylar_test.gd`: BAŞARILI (0 hata, 8 yeni olay, 48 seçenek ve sonuç anahtarı)
   - `Godot --headless -s tests/unit/olay/on_kosul_test.gd`: GEÇTİ (0 hata)

GOREV6_TAMAM
