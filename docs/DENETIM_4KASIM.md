# Kapı Muhafızı — Kalite ve Tutarlılık Denetim Raporu (DENETIM-01)

**Tarih:** 4 Kasım 2026  
**Denetleyen:** Paralel Antigravity Ajanı D (Kaşif)  
**Çalışma Dalı:** `agy/paralel-D`  
**Hedef Dal:** `claude/festive-volta-li1sfm`  
**Denetlenen Maddeler:** ES-GECM-01, ANL-DON-01, SOY-SON-01, MECLIS-ARA-01, Karar 1.1 (Banu Hatun İttifakı) ve Karar 3 (Vebalı Sabi Çift Son).

---

## 1. Yönetici Özeti ve Genel Değerlendirme

Ana ajanın 4 Kasım sabahı geliştirdiği 4 temel anlatı maddesi ile Karar 1.1 ve Karar 3 uygulamaları satır satır denetlenmiştir. 

- **Anlatı Derinliği ve Dil:** Dönem dili (13. yüzyıl Selçuklu ucu, halk ağzı, Ahilik ve oba terminolojisi) son derece başarılı ve atmosferiktir.
- **Bayrak ve Sistem Uyumu:** Karar bayrakları, ziyaretçi geri dönüş tetikleyicileri ve söylenti kapanış fonksiyonları kod ve veri katmanında tam bir uyum içindedir.
- **Graf Bütünlüğü:** Tüm Parley (`.ds`) dosyaları üzerinde Python tabanlı tam dolaşım (reachability/traversal) testi koşulmuş, hiçbir kopuk düğüm, tanımsız slot veya ulaşılamayan dal bulunmadığı teyit edilmiştir.
- **Düzeltilen Hatalar:** 
  1. `meclis_davalari.ds` içindeki Aydoğdu vs Molla Şükrü mera davası, henüz verilmemiş olan Karar 2 ile çelişmeyecek şekilde tamamen nötrleştirilmiştir.
  2. `koylu_muhabbet_es.ds` içinde Muhafız'ın eşine hitap ederken sehven "beyim" dediği 3 replik "hatunum" olarak düzeltilmiştir.
  3. İngilizce Parley dosyalarında Türkçe kalan `character` adları (`Muhafız` / `Eş`), dosya standardı olan `Gatekeeper` ve `Spouse` ile eşitlenmiştir.
  4. `diyalog_01_20.json` (EN) Ziyaretçi 24 sorgusunda, kabul yanıtının erken kopyalanması sonucu oluşan mantık hatası düzeltilmiştir.

---

## 2. Özel İnceleme: Molla Şükrü vs Aydoğdu Mera Davası & Karar 2 Uyumu

### Durum ve Tespit Edilen Risk
`docs/KARAR_SECENEKLERI.md` dosyasına göre Ahmet, Karar 2'yi (Molla Şükrü) henüz vermemiştir (BEKLİYOR):
- **Seçenek 2.1 (Aleni Mahkeme & Ceza):** Molla Şükrü'nün sahte mühür ve beratı halkın gözü önünde kanıtlanır, beratı yakılır, kendisi Karaca Usta'nın körüğünde cezalı çalıştırılır (`sukru_sahte_muhur_kanitlandi`, `sukru_cezali_demirhane`).
- **Seçenek 2.2 (Pragmatik İttifak):** Muhafız Şükrü ile el altından anlaşarak sahte deftercilikle vergi kaçırır.

`data/parley/koy/meclis_davalari.ds` içindeki mevcut metinde Aydoğdu:  
*"Molla Şükrü ise beylik divan nizamını ve kütük kaydını savunur."*  
Muhafız'ın 2. hüküm seçeneğinde:  
*"Vakıf beratı esastır; ... divan kütüğü bozulmasın."*  
Molla Şükrü ise:  
*"Divan nizamını korudun muhafız; defter tamamdır."* demektedir.

**Çelişki:** Eğer Ahmet Seçenek 2.1'i seçerse, Şükrü'nün vakıf beratı zaten sahte çıkmış ve yakılmış olacaktır; dolayısıyla mecliste meşru bir Divan temsilcisi gibi konuşması ve Muhafız'ın onun vakıf beratını esas alması hikâye açısından açık bir anakronizm ve tutarsızlık yaratırdı.

### Uygulanan Çözüm (Nötrleştirme)
Dava silinmemiş; Karar 2 hangi yöne giderse gitsin tam uyum sağlayacak şekilde **şahsi divan otoritesinden bağımsız, yazılı kütük ile oba kadim hakkı** zeminine çekilmiştir:
- **Aydoğdu Repliği (`node:rep_mera`):**  
  *Eski:* "...Molla Şükrü ise beylik divan nizamını ve kütük kaydını savunur."  
  *Yeni (TR):* "...Kâtip Şükrü kâğıt sallayıp 'pınar eski vakıf mülküdür, sürü yaklaşamaz' der; kütükteki eski kaydı öne sürer!"  
  *Yeni (EN):* "...Scribe Sukru brandishes an old deed declaring the spring is endowment property; he insists on ancient ledger entries over our customary rights!"
- **Muhafız 2. Hükmü (`node:opt_mera_h2`):**  
  *Eski:* "Vakıf beratı esastır; ... divan kütüğü bozulmasın."  
  *Yeni (TR):* "Yazılı kütük esastır; sürü aşağı vadideki dereden sulansın, köyün mülk kaydı bozulmasın."  
  *Yeni (EN):* "The written register must prevail; let the flocks water at the lower creek in the valley, that property records remain intact."
- **Molla Şükrü Yanıtı (`node:rep_mera_h2`):**  
  *Eski:* "Divan nizamını korudun muhafız; defter tamamdır..."  
  *Yeni (TR):* "Hükmün kütüğe böyle yazılır muhafız; defter tamamdır. Lakin Aydoğdu obası diş biler."  
  *Yeni (EN):* "Your verdict shall be recorded in the register, sentry; the ledger is secure. Yet the Avsar clan departs resentful."
- **Eylem Tanımı (`node:act_mera_h2`):**  
  "Kâtip Düzeni" / "Scribe Authority" -> "Yazılı Kütük Nizamı" / "Register Order".

Bu sayede:
- Ahmet Karar 2.1'i (Aleni Mahkeme ve Demirhane Cezası) seçse dahi, Şükrü mecliste resmi kadı edasıyla değil, köyün yazıcısı olarak kaydı tutan kişi olarak yer alır; kütük kaydı köy mülkünü koruma kararı olarak kalır.
- Ahmet Karar 2.2'yi seçse dahi, defter nizamı korunmuş olur.
- Karar henüz verilmemişken de oyun dünyasında hiçbir tezat oluşmaz.

---

## 3. Madde Bazlı Kalite ve Denetim Bulguları

### 3.1. ES-GECM-01: Eşin Geçmişi ve Anlatı Yayları
- **İncelenen Dosyalar:** `data/parley/koy/koylu_muhabbet_es.ds`, `data/parley/en/koy/koylu_muhabbet_es.ds`, `data/soz/aksam_konulari.json`, `data/soz/en/aksam_konulari.json`.
- **Dil ve Ton:** Eski köyün Tekfur tarafından yakılması, karda kaçış ve çizmelerin verilmesi, Turna ve Dursun üzerinden çocuksuzluk hüznü, nöbette kırağı tutan sakala kaynatılan ıhlamur ve çam balı sahneleri edebi açıdan yüksek kalitededir.
- **Düzeltme (Dil Hatası):** `koylu_muhabbet_es.ds` içinde Muhafız'ın eşe hitap ettiği 3 diyalog seçeneğinde sehven "beyim" denildiği tespit edildi:
  - `node:opt_z_banu`: "...sınır nöbetine durdu beyim." -> "...sınır nöbetine durdu **hatunum**."
  - `node:opt_z_veba_sifa`: "...humması düşmüş beyim..." -> "...humması düşmüş **hatunum**..."
  - `node:opt_z_veba_kayip`: "...ayaza yenik düştü beyim..." -> "...ayaza yenik düştü **hatunum**..."
- **İngilizce Parite:** `aksam_konulari.json` ve Parley dosyalarındaki tüm başlık ve replikler eksiksiz İngilizceye aktarılmıştır. İngilizce Parley dosyasındaki `character` alanları `Gatekeeper` ve `Spouse` olarak düzeltilmiştir.

### 3.2. ANL-DON-01: Ziyaretçi Geri Dönüş Döngüsü (Echo Visits)
- **İncelenen Dosyalar:** `data/diyalog/diyalog_donusler.json`, `data/diyalog/en/diyalog_donusler.json`, `tests/unit/diyalog/es_gecmis_ve_donusler_test.gd`.
- **Kapsam:** 6 kilit karakterin geri dönüş sekansları:
  1. `donus_sungur_hasim` (Gece 12, `sungur_reddedildi`): Sivas Divanı arama fermanıyla dönüş.
  2. `donus_sungur_muttefik` (Gece 10, `sungur_tatmin_edildi`): Teftiş heyeti ihbarı ve vefa.
  3. `donus_dursun_turna` (Gece 8, `dursun_ve_turna_kabul`): Fırından çıkan ilk sıcak somun.
  4. `donus_lokman_ihanet` (Gece 9, `lokman_kabul`): Karaca Usta ile yüzleşme, afyon ve sahte dirhem.
  5. `donus_banu_zafer` (Gece 14, `banu_ittifak_kabul`): Tekfur çapulcularını püskürtme, at ve mızrak payı.
  6. `donus_behram_vefa` (Gece 11, `behram_kabul`): Kuru incir ve Halep zeytinyağı hediyesi.
- **Doğrulama:** 6 sekansın tamamı soru-cevap, kabul/ret dalları ve sonuç bayrakları ile eksiksizdir. TR ve EN dosyaları birebir örtüşmektedir.

### 3.3. SOY-SON-01: Söylenti Ağının Somut Olaylara Kapanışı
- **İncelenen Dosyalar:** `data/olaylar/soylenti_*.tres` (5 adet), `src/sistemler/soylenti_agi.gd`, `data/metin/metinler.csv`.
- **Eşleşme Tablosu:**
  - `degirmen_un` -> `soylenti_degirmen_kapanis` (Değirmenci Mihali ve kırık oluk)
  - `kuyu_zehir` -> `soylenti_kuyu_kapanis` (Kuyu zehirlenmesi vesvesesi ve palamut yaprağı)
  - `tekfur_altin` -> `soylenti_tekfur_araba_kapanis` (Devrilen altın arabası değil yaşlı katırcının tuzu)
  - `mogol_casus` -> `soylenti_mogol_casus_kapanis` (Samanlıktaki casus değil borçlu rençper)
  - `vebali_kumas` -> `soylenti_vebali_kumas_kapanis` (Çuhacının vebalı kumaşı değil çivit iftirası)
- **Doğrulama:** `soylenti_agi.gd` fonksiyonları (`soylenti_kapanis_olayi_al`, `soylenti_kapanisi_uygula`) test edilmiş; `metinler.csv` içinde 20 yeni anahtarın hem Türkçe hem İngilizce kayıtları doğrulanmıştır. `test_olay_kartlari.py` başarıyla geçmektedir.

### 3.4. MECLIS-ARA-01: Çınar Meclisi İnteraktif Dava Sistemi
- **İncelenen Dosyalar:** `data/parley/koy/meclis_davalari.ds`, `data/parley/en/koy/meclis_davalari.ds`, `tests/unit/kvr/soylenti_ve_meclis_davalari_test.gd`.
- **Kapsam:**
  1. Karaca Usta vs Yusuf (Kırık balta davası - Ahilik körük cezası veya köy kasası tazmini).
  2. Ayşe Bacı vs Gezgin Çuhacı (Bozuk çivit boyası davası - Yün tazminatı veya zarar paylaşımı).
  3. Aydoğdu vs Molla Şükrü (Pınar ve mera davası - Nötr kütük nizamı vs kadim oba hakkı).
  4. Thessra vs Miraen (Frenk tentürgülü vs kadim otacılık - Ortak kireç ocağı şifahanesi).
- **Geliştirme Notu:** İlk 3 davada ikişer seçenekli ahlaki yol ayrımı bulunurken, 4. davada uzlaşmacı tek hüküm (`node:opt_sifa_h1`) yer almaktadır. Bu yapı işlevsel olarak geçerlidir; ileride istenirse gelenekçi otacılığı tercih eden bir 2. seçenek eklenebilir.

### 3.5. Karar 1.1 (Banu Hatun) & Karar 3 (Vebalı Sabi Çift Son)
- **İncelenen Dosyalar:** `data/diyalog/diyalog_01_20.json`, `data/diyalog/en/diyalog_01_20.json`, `src/kapi/es_yorumu_adaptoru.gd`, `data/diyalog/es_kapi_dusunceleri.json`, `data/parley/koy/koylu_muhabbet_*.ds`.
- **Karar 1.1:** Banu Hatun'un dağdaki 50 atlısıyla ittifak kurulması (`banu_ittifak_kabul`), vadi ordugâhı, +50 savunma ve erzak tüketimi tüm metin ve diyaloglarda kusursuz uygulanmıştır.
- **Karar 3 Çift Dal Mantığı:**
  - `veba_kirec_karantina_basarili` (Şifa dalı): Kapıda kabul yanıtı `kabul_sifa`, eş yorumu `karar_kabul_sifa`, köyde Miraen ve Eş sevinci (+3 Moral).
  - `sabi_vefati_kis_matemi` (Dramatik kayıp dalı): Kapıda kabul yanıtı `kabul_kayip`, eş yorumu `karar_kabul_kayip`, köyde matem (-3 Moral).
  - Adaptör: `src/kapi/es_yorumu_adaptoru.gd` gelen ziyaretçinin açık bayraklarına göre doğru kabul metnini ve eş fısıltısını dinamik olarak devreye almaktadır.
- **Düzeltilen Çeviri Hatası:** `data/diyalog/en/diyalog_01_20.json` dosyasında Ziyaretçi 24'ün 2. sorgu sorusuna verdiği yanıt sehven `kabul_sifa` metninden kopyalanmıştı. Henüz kapıdayken çocuk iyileşmiş gibi duran bu erken replik, orijinal Türkçesindeki şart kipine uygun olarak ("If my child rises to health through Lady Miraen's medicine...") düzeltilmiştir.

---

## 4. Test ve Doğrulama Durumu

1. **Python Metin ve Söz Doğrulayıcıları:**
   - `python tools/metin_dogrula.py`: **PASS** (Tüm CSV anahtarları, format ve çift dil geçerli).
   - `python tools/soz_dogrula.py`: **PASS** (KAY-53 / KAY-38 doğrulaması hatasız).
   - `python tests/tools/test_olay_kartlari.py`: **PASS** (7/7 test başarılı).
   - `python tests/tools/test_metin_dogrula.py`: **PASS** (19/19 test başarılı).
   - `python tests/tools/test_soz_kapi.py`: **PASS** (24/24 test başarılı).
   - `python tests/tools/test_chr_parser.py`: **PASS** (5/5 test başarılı).
   - `python tests/tools/test_metin_ve_surum_sinirlari.py`: **PASS** (8/8 test başarılı).
2. **Parley Graf Bütünlüğü Testi:**
   - `meclis_davalari.ds` (TR & EN): 32 düğüm, 37 kenar, %100 erişilebilir.
   - `koylu_muhabbet_es.ds` (TR & EN): 155 düğüm, 193 kenar, %100 erişilebilir.
   - `koylu_muhabbet_karaca_usta.ds` (TR & EN): 15 düğüm, 17 kenar, %100 erişilebilir.
   - `koylu_muhabbet_miraen.ds` (TR & EN): 18 düğüm, 21 kenar, %100 erişilebilir.
   - Eylem referansları (`koy_moral_action.gd` vb.): Bütün script dosyaları fiziksel olarak mevcut.
3. **JSON Bütünlüğü:**
   - `data/` altındaki tüm JSON dosyaları sözdizimi açısından doğrulanmış ve hatasızdır.

---

## 5. Sonuç

DENETIM-01 kapsamında ana ajanın 4 anlatı maddesi ile Karar 1.1 ve Karar 3 uygulamaları eksiksiz incelenmiş, tespit edilen küçük yazım, hitap, karakter ismi ve İngilizce çeviri hataları giderilmiştir. Ahmet'in bekleyen Karar 2 kararı için `meclis_davalari.ds` nötrleştirilerek tam tutarlılık güvenceye alınmıştır. Kod tabanı temiz, oynanabilir ve ana entegrasyona hazırdır.
