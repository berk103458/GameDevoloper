# Haberci güvercin ve ulak — HAR-09

## Overview
Gerçek gece raporundaki açık harita krizleri mevcut OlayVerisi kartına yazılı haber olarak gelir. Moğol haberi güvercin; Tekfur haraç talebi ve çete hareketi ulak anlatısıdır. Aynı olay yüzeyi kullanılır.

## Player Fantasy
Burçta güvercinin mühürlü kâğıdını açmak veya yol tozuyla gelen ulağı dinlemek, çevredeki gelişmeleri hisara bağlar. Haberi okumak ayrı diplomasi veya suç kararı değildir.

## Detailed Rules
Moğol yalnız mevcut HAR02 gerçek5/2/0 gün uyarı raporundan; Tekfur yalnız mevcut HAR03 gerçek haraç raporundan; çete yalnız gerçek baskın/sızma açık kayıp raporundan alınır. Kaynak başına en yeni bekleyen haber tutulur; en fazla üç haber. Aynı gece ikinci toplama yok. Taşkın/casus/fısıltı/ferman mevcut öncelikte kalır; haber genel rastgele olaydan önce gelir. Mevcut oyun akışında gece başına tek olay kartı; ertelenen haberler sonraki gecede seçilebilir. Aynı kaynaktan daha yeni rapor bekleyeni yeniler; ayrı kapı kafile kuyruğu yok.

## Formulas
Tamamlanan no=r.gun+1; no<=son_gece veya terminal ise yazma yok. Son rapor/kaynak kimliği har09_haber_kaynak_no. Okuma seçeneği yalnız0 ve canlı ilk kart kimliğinde geçerlidir; başarı ilk bekleyeni kaldırır. Kaynak aynıysa yeni gün>=eski gün ile birleştirilir. Kartı/kanalı okumak salt okunur, kasa/RNG veya kaynak kriz durumunu değiştirmez.

## Edge Cases
Eski/foreign/terminal/yanlış seçenek atomik ret. JSON pending/makbuz korunur; legacy boş defter; bilinmeyen kaynak, bozuk gün veya boş/4096üstü metin elenir. Haber gizli CHR bayrağına/heybesine/kanıtına bakmaz; çete haberi bir kişinin suçuna kanıt değildir. Haber okununca haraç ödenmez, savaş başlatılmaz ve kaynak karar kartı çözülmez. Aynı kaynak birleştirme eski kartı bayat yapar; ID tekrarından ikinci okuma yok. Tekfur entegrasyon testi mevcut ikinci perde agalik şartını kurar, üretim kuralını değiştirerek ilk perdede talep uydurmaz.

## Dependencies
HaberciAgi ve data/haberci_agi.json. Oturum tek gece helper/öncelik/seçenek/okuma ve optional save/load bağlantıları. KoyEkrani._olay_goster içinde HaberciAnlatiPaneli tek çağrıyla ColorRect+etiket oluşturur. Aynı devam_istendi ve mevcut sonuç kartı. KoyYonetimi/koy_halk_hareketi/CSV/CHR/Ses/kapı kuyruğu ve kayıt sürümü3 değişmez; savaş/diplomasi kaynakları kendi görevlerinde kalır.

## Tuning Knobs
Kanallar/metinler/renkler/kutu_px/azami_metin dış JSON. Kaynak kümesi üç gerçek kriz sınıfıyla sınırlıdır. Gün başına aynı mevcut tek olay kuralı ve kaynak başına birleştirme tercihidir. Fiziksel haberci/kuş görseli üretilmez/indirilmez; mevcut kartta düz renk kutu anlatı yer tutucusu. HAR09-GUVERCIN/HAR09-ULAK envanter G aynı pakette kaydedilir.

## Acceptance Criteria
Gerçek25.gün Moğol ve gerçek ikinci perde6.gün Tekfur gecesi, üç rapor/tek gece/aynı kaynak birleşimi, öncelik/JSON/legacy/bozuk/stale/terminal/gizli ret, kasa/RNG değişmeme. Aynı gerçek kart düğmesi/kutu/okuma/sonuç/devam sinyali; native/headless/ayna. Kapı/ferman/kayıt/Moğol/Tekfur/öngörü/çete ve köy regresyonu.
