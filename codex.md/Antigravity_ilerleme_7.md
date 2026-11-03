# Antigravity İlerleme Dosyası — Görev 7

- **Ajan Adı:** Antigravity
- **Görev:** Görev 7 — ROADMAP Diyalog, Karakter, Anlatı ve Metin Maddelerinin Tamamlanması
- **Çalışma Dalı:** `feature/diyalog-yeniden-yazim`
- **Başlangıç Zamanı:** 4 Kasım 2026 02:35
- **İlke:** AGENTS.md kurallarına tam uyum; Kalfa ve Cursor PR alanlarına (ekonomi, inşaat, girdi kodları) dokunmadan, diyalog/metin/karakter/söylenti/anlatı alanındaki tüm maddeleri parti parti tamamlama, test etme, commit ve push etme.

---

## 1. Festive Merge ve Durum
- `origin/claude/festive-volta-li1sfm` dalı `feature/diyalog-yeniden-yazim` dalına merge edildi (commit `06402fcd`).
- `data/metin/metinler.csv` çakışması iki tarafın da içeriği korunarak çözüldü.
- `tools/metin_dogrula.py` ve `tools/soz_tasarimi_dogrula.py` testleri 0 hatayla çalıştırıldı (PASS).

---

## 2. Antigravity Alanındaki ROADMAP_2 Maddeleri Listesi

### Parti 1: Açılış ve Eş Akşam Diyalogları (Faz 1)
- `ACL-03`: Akşam sohbeti — eş günün kararlarını konuşur (gece raporu öncesi, ağırlık tablosu, atlanabilir).
- `DYL-07`: Akşam eşle konuşmak (ACL-03'ün ayrıntılı tasarımı, meslek varyantları, terazi/moral etkisi).

### Parti 2: Söz Sistemi — Yeni Diyalog Motoru & Sorgu Eylemleri (Bölüm 16 & 25) — TAMAMLANDI
- **Maddeler:** `DIY-01a`, `DIY-02`, `DIY-03`, `DIY-04`, `DIY-05`, `DIY-06`, `DIY-07`, `DIY-10`, `DIY-16`, `DIY-17`, `DIY-18`, `DYL-01`, `DYL-02`, `DYL-03`, `DYL-04`, `DYL-05`, `DYL-08`, `DYL-09`, `DYL-10`, `DYL-11`, `DYL-12`, `DYL-13`, `DYL-14`, `DYL-15`, `DYL-16`, `DYL-74` (Toplam 26 madde).
- **Uygulanan Dosyalar:**
  - `docs/SOZ_SEMASI.md`, `data/soz/_sema.json`, `data/soz/kurallar.json`, `data/soz/ornek_durust.json`, `data/soz/ornek_koruma_yalani.json`, `data/soz/ornek_hatali.json`.
  - `src/soz/soz_semasi.gd`: Konuşma dosyası doğrulayıcısı, derinlik tavanı (12), izinli etki anahtarları ve çekirdek kuralı.
  - `src/soz/soz_dugumu.gd` & `src/soz/soz_motoru.gd`: Düğüm yürütücü, kilit kontrolleri (tansiyon, ipucu, bayrak, panik, Final_Ret, karar kısıtı), tekil etki uygulaması, güven/korku/sabır takibi.
  - `src/soz/konu_merkezi.gd`: Selam öncesi konu kısıtı, sabit konu başlıkları, karar çubuğu kilidi.
  - `src/soz/beyan_defteri.gd`: Karakter beyanlarının kaydı ve listelenmesi.
  - `src/soz/celiski_yuzlesme.gd`: İki beyanın veya kanıtın eşleşmesiyle yüzleşme düğümünün açılması.
  - `src/soz/bakis.gd`: Bölgelere (yüz, eller, çarık, kese) bakış, ışık kontrolü, sabır maliyeti.
  - `src/soz/yemin.gd`: 4 tutum (eder, kıvranır, rahat, reddeder), tansiyon/güven etkisi, tekil ceza.
  - `src/soz/muhafiz_yalani.gd`: Sezgi zarı kontrolü, [Yalan] etiketi, güven/tansiyon değişimi, `dogru: false` kaydı.
  - `src/soz/soz_verme.gd`: Süreli söz verme, tutulunca güven +3, tutulmayınca güven -5 ve dedikodu/terazi kaydı.
  - `src/soz/karar_donusu.gd`: Kapı kararlarının gün farkına göre geri dönüşü (çete intikamı, vicdan azabı, akraba gelişi).
  - `src/soz/beyin_denetcisi.gd`: Sancak müfettişinin şüphe ve azil riski hesaplaması.
  - `tools/metin_karsilastir.py`: Eski ve yeni metin yan yana karşılaştırma aracı.
  - `docs/ORNEK_DEFTERI.md`: 13. yy zümre replik ve ton kalıpları.
  - `Roadmap-2/soz_agaci/duzenleyici.js` & `tests/tools/test_soz_duzenleyici.py`: Ağaç görsel düzenleyici kütüphanesi.
  - `data/soz/gecis.json`: 30 karakter için eski diyalog geçiş tablosu.
  - `tests/soz/altin/yusuf_altin_01.json`: Yusuf altın oynanış kayıt dosyası.
- **Testler:** 12 GDScript birim testi ve Python testleri 0 hatayla geçti:
  - `sema_test.gd`, `soz_motoru_test.gd`, `konu_merkezi_test.gd`, `derinlesme_test.gd`, `sira_sabri_test.gd`, `beyan_defteri_test.gd`, `celiski_yuzlesme_test.gd`, `sir_ikilem_test.gd`, `guven_korku_test.gd`, `soz_kesme_test.gd`, `gecis_test.gd`, `bakis_test.gd`, `yemin_test.gd`, `muhafiz_yalani_test.gd`, `soz_verme_test.gd`, `karar_donusu_test.gd`, `beyin_denetcisi_test.gd`, `cekirdek_varyant_test.gd`, `kor_okuma_test.gd`, `muhafiz_tip_tarama_test.gd`, `yan_yana_bakis_test.gd`, `altin_oynanis_test.gd`, `eylem_kadraji_test.gd`, `test_soz_duzenleyici.py`.
- **Asset Durumu:** `DYL02-AYRINTI-*`, `DYL03-YEMIN`, `DYL09-DENETCI` envanterde yer tutucu kayıtlıdır. Asset gerekmedi.

- `DIY-01a`: Söz veri şeması — konuşma dosyası biçimi.
- `DIY-02`: Söz motoru çekirdeği — düğüm yürütücü.
- `DIY-03`: Selam önce, hikâye sonra — konu merkezi.
- `DIY-04`: Derinleşme katmanları — aynı konuda üstelemek yeni bilgi açar.
- `DIY-05`: Sıra sabrı — sohbetin zaman bedeli.
- `DIY-06`: Beyan defteri — karakterin söyledikleri kayda geçer.
- `DIY-07`: Çelişki ve yüzleşme — yalan, kanıtla ortaya çıkar.
- `DIY-10`: Sır ve ikilem dalları — neden sakladığı.
- `DIY-16`: Eski diyalog yollarının kapatılması — yeniden yazılan içerik devreye girer.
- `DIY-17`: Güven ve korku ayrı ölçülür.
- `DIY-18`: Söz kesme, karşı soru ve muhafızın beyanı.
- `DYL-01`: Çelişkiyi yüzüne vurmak.
- `DYL-02`: Bakmak — konuşmadan süzmek.
- `DYL-03`: Yemin ettirmek.
- `DYL-04`: Muhafız da yalan söyler.
- `DYL-05`: Söz vermek — tutulan ve tutulmayan söz.
- `DYL-08`: Kararın sonradan dönüşü.
- `DYL-09`: Beyin denetçisi — sorgulanan muhafız.
- `DYL-10`: Aynı karakter, farklı oyun.
- `DYL-11`: Kör okuma testi.
- `DYL-12`: Muhafız tipleriyle tarama.
- `DYL-13`: Eski ve yeni metni yan yana görmek.
- `DYL-14`: Kaynaklı örnek defteri.
- `DYL-15`: Sitede düzenleme.
- `DYL-16`: Ortak test dosyaları.
- `DYL-74`: Kapalı eylem sebebi bir kelimedir.

### Parti 3: Söz İçeriği & Karakterlerin Yeniden Yazımı (Bölüm 19 - YAZ) — TAMAMLANDI
- **Maddeler:** `YAZ-02`, `YAZ-16`, `YAZ-20`, `YAZ-21`, `YAZ-22`, `YAZ-24`, `YAZ-25`, `YAZ-26`, `YAZ-03`, `YAZ-30`, `YAZ-33`, `YAZ-04`, `YAZ-35`, `YAZ-39`, `YAZ-05`, `YAZ-45`, `YAZ-47`, `YAZ-06`, `YAZ-65`, `YAZ-07`, `YAZ-08`, `YAZ-70`, `YAZ-74`, `YAZ-09`, `YAZ-79`, `YAZ-10`, `YAZ-83`, `YAZ-87` (Toplam 28 madde).
- **Uygulanan Dosyalar:**
  - `docs/YAZIM_HATTI.md`: Model istemi, üretim adımları, doğrulama, inceleme ve onay akışı; eski diyalogların taşınmama kuralı.
  - `data/karakter_ses_kartlari.json`: 30 karakter için özgün ses kartları; meslek, ağız, korku, örnek cümle (hiçbir iki kart aynı ağzı tarif etmez).
  - `tests/fixtures/pilot_karakterler.json`: Sivaslı rençber ve iki karakter için sır içermeyen dürüst pilot veri.
  - `data/soz/kadro_ozgunluk.json`: Sır çekirdeği kotası (%50 altı) ve kişi adlarının çevrilmeme kuralı.
  - `tools/soz_dogrulayici.py`: Ses kartları ve kurallar için komut satırı doğrulayıcısı.
  - `tools/kapsam_taramasi.py`: Karakter kapsamı ve tekil motor doğrulaması.
- **Testler:** 7 GDScript birim testi ve Python araçları 0 hatayla geçti:
  - `uslup_test.gd`, `ses_karti_test.gd`, `pilot_test.gd`, `toplu_yazim_test.gd`, `koy_ici_sohbet_test.gd`, `ozgunluk_denetimi_test.gd`, `kapsam_taramasi_test.gd`.
  - `soz_dogrulayici.py`, `kapsam_taramasi.py`.
- **Asset Durumu:** Asset gerekmedi.

- `YAZ-02`: Üslup rehberi (YAZ-16, YAZ-20, YAZ-21, YAZ-22, YAZ-24, YAZ-25, YAZ-26).
- `YAZ-03`: Karakter ses kartı (YAZ-30, YAZ-33).
- `YAZ-04`: Yazım hattı (YAZ-35, YAZ-39).
- `YAZ-05`: Pilot karakterler (YAZ-45, YAZ-47).
- `YAZ-06`: Toplu yeniden yazım (30 CHR + 10 yeni ziyaretçi, YAZ-65).
- `YAZ-07`: Söz doğrulayıcı ve önizleme aracı.
- `YAZ-08`: Köy içi sohbetler (YAZ-70, YAZ-74).
- `YAZ-09`: Hikâye çekirdekleri ve kadro özgünlük denetimi (YAZ-79).
- `YAZ-10`: İnceleme modu ve kapsam taraması (YAZ-83, YAZ-87).

### Parti 4: Köy İçi Sevilen Yüz & Çınar Meclisi Metinleri (Bölüm 25a & 27) — TAMAMLANDI
- **Maddeler:** `SEV-01`, `SEV-02`, `SEV-03`, `SEV-04`, `SEV-05`, `SEV-06`, `SEV-07`, `MCL-02`, `MCL-03`, `MCL-04`, `MCL-05`, `MCL-06`, `MCL-07`, `MCL-08`, `MCL-09` (Toplam 15 madde).
- **Uygulanan Dosyalar:**
  - `src/koy/sevilen_yuz.gd`: Boş gün tespiti, ateşe gelen tanıdık yüz, kişisel iz bırakma, tek istek üretimi, köylü bağları (dostluk/husumet), isim sorma kartı ve helallik veda mekanizması.
  - `src/koy/meclis_sesi.gd`: Karar şikayeti metni, eş/usta özel sözü, oy uygulama (adalet, moral, asayiş), meclis takvimi, karar gerekçesi, ağırlık sıralaması, hayatta olma kontrolü ve yasaklı eylem denetimi.
  - `tests/unit/koy/sevilen_yuz_test.gd`: SEV-01..07 tüm kurallarının birim testleri (PASS).
  - `tests/unit/koy/cinar_meclisi_genisletme_test.gd`: MCL-02..09 tüm kurallarının birim testleri (PASS).
- **Testler:** Godot headless ile 3/3 test hatasız geçti (`meclis_sesi_test.gd`, `sevilen_yuz_test.gd`, `cinar_meclisi_genisletme_test.gd`). Doğrulayıcılar PASS.
- **Asset Durumu:** Asset gerekmedi.

- `SEV-01` … `SEV-07`: Boş gün, ateşe gelen tanıdık yüz, köydeki iz, tek istek, bağlar, isim sorma, veda.
- `MCL-02` … `MCL-09`: Çınar meclisi şikayet ve karar sesleri, eş/usta sözü.

### Parti 5: Muhafızın Hanesi, Sabah Satırları & Sofra Metinleri (Bölüm 36 - HAN) — TAMAMLANDI
- **Maddeler:** `HAN-01` … `HAN-46`, `HAN-48`, `HAN-52` (Toplam 48 madde; HAN-47, HAN-49, HAN-50, HAN-51 Claude kapsam bekçisi tarafından önceden kapatılmıştır).
- **Uygulanan Dosyalar:**
  - `data/soz/hane_sabah_satirlari.json`: 6 meslek için (dokumacı, ebe, fırıncı, bostancı, sütçü, yün eğirici) hava, ambar, duyum ve kalıntı sabah satırı havuzları; USLUP kurallarına tam uyumlu replikler.
  - `src/koy/hane.gd`: Sabah satırı üretimi, meslek çıktısı adaptörü (`is_ciktisi_al`), haftalık sofra döngüsü (`sofra_kur`), muhafız maaşı (`maas_al`), rüşvet engelleme (`rusvet_engelle`), misafir ağırlama ve olayları (`misafir_al`), yetim alma kapasitesi (en çok 2 yetim, `yetim_al`), eş duyumu ve ipucu üretimi (`duyum_dinle`), eve dönüş zihin yankısı (`eve_donus_satiri`), eş ölümü sonrası 4 kancanın sıfırlanması (`es_olumu`), ve KAY zincirine uyumlu serileştirme (`kayit_verisi_al`, `kayit_verisi_yukle`).
  - `tests/unit/koy/hane_test.gd`: HAN-52 kapanış testi: 3 gün hane döngüsü (sabah satırı, üretim, sofra, hediye bırakan misafir, duyum ipucu kancası), eş ölümü sonrası 4 kancanın 0 olması, yetim sınırı ve KAY zinciri restorasyon kontrolü (PASS).
- **Test Sonucu:** Godot headless ile 1/1 test hatasız geçti. `tools/metin_dogrula.py` ve `tools/soz_tasarimi_dogrula.py` PASS.
- **Asset Durumu:** `DYL07-OCAK` envanterde kayıtlıdır. Asset gerekmedi.

### Parti 6: Söylenti, Dedikodu & Kamuoyu Ağı Metinleri (Bölüm 37 - SOY) — TAMAMLANDI
- **Maddeler:** `SOY-01` … `SOY-30`, `SOY-32` … `SOY-46`, `SOY-48`, `SOY-50` (Toplam 47 madde; SOY-31, SOY-47, SOY-49 Claude kapsam bekçisi tarafından önceden kapatılmıştır).
- **Uygulanan Dosyalar:**
  - `data/soylenti.json`: Yayılım hızı (azami 4), bozulma oranı (0.0875), kamuoyu eşiği (%40), ağ ve kamuoyu ömürleri, bar etkileri, asgari nüfus (5), iyi olaylar ve 3 bozulma kalıbı (ad kayması, yer kayması, abartı).
  - `src/sistemler/soylenti_agi.gd`: Söylenti ağı yöneticisi: dedikodu kaydına kaynak ve doğruluk ekleme (`soylenti_ekle`), gece ilerlemesi ve ağ yayılımı (`gece_ilerlet`), kaynak güvenilirlik puanı ve kelimesi (`guvenilirlik_al`, `guvenilirlik_degistir`, `guvenilirlik_kelimesi`), kamuoyu konusu olma ve meclis şikayeti seçimi (`meclis_sikayeti_sec`), divan hükmüyle kamuoyunun sıfırlanması (`divan_hukmu_ver`), kaynak susturma (`sustur`), bağlam sorgusu (`baglam_sorgusu_al`), defter sayfası (`soylenti_sayfasi_al`), HUD şeridi (`kamuoyu_hud_satiri_al`), ve KAY serileştirmesi (`kayit_verisi_al`, `kayit_verisi_yukle`).
  - `tests/unit/kvr/soylenti_agi_test.gd`: SOY-50 kapanış testi: 7 adım tek koşu (tanıklı rüşvet -> 3 gece yayılım -> %40 eşiğiyle kamuoyu oluşması -> bar -1 bir kez -> meclis şikayeti seçimi -> divan hükmüyle kamuoyunun 0 olması -> yanlış kopya ve kaynak güvenilirliğinin -1 düşmesi), küçük köyde susma (SOY-40), defter sayfası (SOY-29) ve KAY zinciri restorasyonu (PASS).
- **Test Sonucu:** Godot headless ile 1/1 test hatasız geçti. `tools/metin_dogrula.py` ve `tools/soz_tasarimi_dogrula.py` PASS.
- **Asset Durumu:** Asset gerekmedi.

### Parti 7: Ana Hikâye Omurgası, Perde Geçişleri, Son ve Epilog Metinleri (Bölüm 34 - OMR & KOP)
- `OMR-07` … `OMR-18`: Perde geçiş konuşmaları, "Köy oturdu" kadrajı, 5 sonun epilog metinleri.
- `KOP-01`, `KOP-02`, `KOP-06`, `KOP-07`, `KOP-08`: Divan konuşması, heyet sahnesi, yozlaşma sözleri, tüccar pazarlık diyaloğu.

---

## 3. Parti Parti İlerleme Kaydı

### Parti 1: Açılış ve Eş Akşam Diyalogları (ACL-03 & DYL-07) — TAMAMLANDI
- **Maddeler:** `ACL-03` ve `DYL-07`
- **Uygulanan Dosyalar:**
  - `data/soz/aksam_konulari.json`: 10 ağır/gündelik karar konusu, her biri için 2-4 eş repliği, 3 meslek varyantı (dokumacı, fırıncı, ebe), 3 muhafız cevabı (savunmak, kabul_etmek, susmak), terazi/moral etkileri ve ipucu anahtarları.
  - `src/koy/aksam_sohbeti.gd`: Ağır kararlar arasından ağırlık ve ziyaret sırasına göre seçim, meslek satırı ekleme, ertesi gece tekrarı önleme, atlama desteği, eş hafızası (`_es_hafizasi`) kaydı.
  - `tests/unit/koy/aksam_sohbeti_test.gd`: Ağır kararlı gecede 1 kez açılma, ertesi gece 0 açılma, atlamanın bar değiştirmemesi, eş ölüyken tetik 0, meclis gecesi 0, yasaklı kalp/ses olmaması doğrulandı (PASS).
  - `tests/unit/koy/aksam_konu_test.gd`: En yüksek ağırlıklı olayın seçimi, eşitlikte ziyaret sırası büyük olanın seçilmesi, ağırlığı 0 olanın seçilmemesi, cevap işleme ve eş hafızası doğrulandı (PASS).
- **Test Sonucu:** Godot headless ile 2/2 test hatasız geçti. `tools/metin_dogrula.py` ve `tools/soz_tasarimi_dogrula.py` PASS.
- **Asset Durumu:** `DYL07-OCAK` envanterde kayıtlı (`docs/EKSIK_ASSET_ENVANTERI.md`), yer tutucu çerçeve kullanıldı. Asset gerekmedi.

