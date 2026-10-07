# Kamu iflası ve tefeci baskını — EKO-10

## Overview
Gerçek kamu bakiyesi üç gece üst üste negatif kapanırsa tefeci kamu malına el koyar. Kamu açığı para erişimcisinde ve kayıtta korunur; muhafızın kişisel kesesi ayrı kalır.

## Player Fantasy
Oyuncu kamu açığını vergi veya satışla kapatmayı, aksi halde üretim/barınma varlığı kaybetmeyi göze alır. Gece raporu ve akçe tooltip sonucu açıklar.

## Detailed Rules
Sayaç gecenin bütün gelir/giderlerinden sonra güncellenir. Negatif kapanış sayacı artırır; sıfır veya pozitif kapanış seriyi sıfırlar. Üçüncü negatif gece kesintisiz seri için bir kez tefeci baskını olur. En yeni kimlikli kamu yapısı iadesiz çıkarılır. Çalışanları boşa, sakinleri evsiz kalır; kış görev referansları, ızgara, üretim kesirleri ve ambar kapasitesi gerçek modelde temizlenir. Yapı yoksa dış konfigürasyon sırasındaki ilk mevcut kamu stokundan en fazla tanımlı miktar alınır. Hiç mal yoksa rapor bunu açıklar. El koyma borcu silmez ve kişisel kasayı/eşyaları almaz. Aynı seride tekrar baskın yok; toparlanmadan sonra yeni borç serisi yeniden tetiklenebilir.

## Formulas
Sayaç = bakiye < 0 ise min(eşik, sayaç + 1), aksi halde 0. Eşik = data/koy/iflas.json içindeki 3. Bakiye gerçek signed kamu hesabıdır; gelir negatif açığı gerçek miktarı kadar azaltır, sıfıra yuvarlayıp borç silmez. Kişisel kese ve stoklar eski sıfır alt sınırını korur.

## Edge Cases
Aynı gece çağrısı yinelenmez. Eski kayda iflas geçmişi uydurulmaz; optional doğrulanmış JSON sayaç/son gün/tek baskın korumasını taşır. Bozuk sayaç/gün güvenli varsayılana döner. El konulan yapının hayalet üretim kesri kalmaz; yıkım yolu eski malzeme iadesini korur. Kamu/kişisel erişimciler ayrıdır. İflas gözlemi gün/RNG/kaynak değiştirmez. Bu ekonomik baskın olayı özel tefeci modeli veya savaş animasyonu eklemez.

## Dependencies
IflasYoneticisi, KoyYonetimi.gece ve ortak bina çıkarma adaptörü; Oturum.koy_akce signed bakiye; HUD akçe uyarısı; gerçek gece raporu ince metin adaptörü. CSV anahtarlarını veya başka ajanın diyalog çekirdeğini değiştirmez.

## Tuning Knobs
Data/koy/iflas.json negatif gece eşiği ve yapısız kamu stok el koyma miktarları/sırası. Varsayım: tek seride en fazla bir bina, yoksa ilk stoktan en fazla 5 birim.

## Acceptance Criteria
Gerçek ilk iki/üçüncü gece, kamu erişimcisinde negatif bakiye, iadesiz yapı/ızgara/iş/artık temizliği, yapısız stok, kişisel kese ayrımı, tek baskın/reset, eski/yeni/bozuk JSON ve restore sonrası aynı üçüncü gece; gerçek gece düğmesi/rapor ve native ekran; tüm regresyon ve 20 gece.
