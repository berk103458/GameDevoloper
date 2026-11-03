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

### Parti 2: Söz Sistemi — Yeni Diyalog Motoru & Sorgu Eylemleri (Faz 2)
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

### Parti 3: Söz İçeriği & Karakterlerin Yeniden Yazımı (Faz 3)
- `YAZ-02`: Üslup rehberi (YAZ-16, YAZ-20, YAZ-21, YAZ-22, YAZ-24, YAZ-25, YAZ-26).
- `YAZ-03`: Karakter ses kartı (YAZ-30, YAZ-33).
- `YAZ-04`: Yazım hattı (YAZ-35, YAZ-39).
- `YAZ-05`: Pilot karakterler (YAZ-45, YAZ-47).
- `YAZ-06`: Toplu yeniden yazım (30 CHR + 10 yeni ziyaretçi, YAZ-65).
- `YAZ-07`: Söz doğrulayıcı ve önizleme aracı.
- `YAZ-08`: Köy içi sohbetler (YAZ-70, YAZ-74).
- `YAZ-09`: Hikâye çekirdekleri ve kadro özgünlük denetimi (YAZ-79).
- `YAZ-10`: İnceleme modu ve kapsam taraması (YAZ-83, YAZ-87).

### Parti 4: Köy İçi Sevilen Yüz & Çınar Meclisi Metinleri (Faz 4 & Faz 2-3)
- `SEV-01` … `SEV-07`: Boş gün, ateşe gelen tanıdık yüz, köydeki iz, tek istek, bağlar, isim sorma, veda.
- `MCL-02` … `MCL-09`: Çınar meclisi şikayet ve karar sesleri, eş/usta sözü.

### Parti 5: Muhafızın Hanesi, Sabah Satırları & Sofra Metinleri (Bölüm 36 - HAN)
- `HAN-01` … `HAN-48`: Hane sabah satırları, eşin meslek sözleri, misafir konuşmaları, sofra diyalogları.

### Parti 6: Söylenti, Dedikodu & Kamuoyu Ağı Metinleri (Bölüm 37 - SOY)
- `SOY-01` … `SOY-50`: Söylenti şablonları, kapıdan giren haberler, dedikodu taşıyıcıları, doğrulama satırları.

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

