# Yozlaşma yetenek ağacı — ODA-05

## Overview
Göz Yumma → Haraç Kesme bağlı seçimleri, aynı odada kişisel akçeyle açılır. Tek optional Oturum seçim/gece makbuzu; aynı rüşvet dağıtımı ve sabah raporu kullanılır.

## Player Fantasy
Muhafız kişisel kazancı artıran seçimlerin kamu adaleti ve esnaf morali üzerindeki bedelini görür.

## Detailed Rules
Göz Yumma: 10 kişisel akçe, en az4 tecrübe ve20 yozlaşma. Haraç Kesme: önce Göz Yumma, 15 kişisel akçe, en az8 tecrübe ve20 yozlaşma. Alım koşulları tıklamada yeniden doğrulanır; tam bedel yalnız bir kez. Açılmış seçim kayıtta kalır, puan düşüşü bedeli geri vermez. Göz Yumma yalnız mevcut rüşvet akçesini artırır; eşya/stat/source değişmez.

Haraç, gerçek gece kapanışı başında hazır işyerine atanmış, çocuk olmayan, hayatta ve köydeki esnaftan tahsil edilir. İşsiz/inşa çalışanı/tutsak/dış görev/ölü/başka sınıf hariçtir. Gelir, mevcut verginin de kullandığı soyut köylü gelir modelindeki ayrı zorlayıcı tahsilattır; kamu kasasından aktarım değildir, kişi cüzdanı oluşturulmaz. Tahsil edilen kişilerde moral bedeli, gelir varsa tek adalet bedeli uygulanır. Son gece makbuzu tekrar işlemi önler. Bilanço kişisel net geliri, aynı rapor açıklaması haraç ve bedeli gösterir.

## Formulas
Rüşvet = taban + floor(taban×0.5); mevcut kişisel int64 bakiye sınırına sığar. Günlük haraç = uygun gerçek esnaf sayısı×1 akçe. Tahsil edilen esnaf morali −3; gelir varsa adalet −2. Haraç toplamı ODA-04 yozlaşmasına akçe başına1 eklenir. Bunlar veri ayarlı denge varsayımlarıdır; temel kamu vergi/stat sonuçları tekrarlanmaz.

## Edge Cases
Eski kayıt boş seçimdir. Bilinmeyen/önkoşulsuz kayıt elenir; bozuk gece/toplam alanı varsayılandır. Aynı gece sıfır uygun kişide de makbuz tutulur; sonra eklenen işçi geriye dönük tahsil edilmez. Dış görevden dönen gerçek esnaf sonraki gecelerde yeniden uygundur. Terminal/taşma halinde işlem yoktur. Oda kapanınca mevcut HUD bakiyeyi yeniden okur; alınan yetenek silinmez. JSON tam seçim/gece/toplamı korur.

## Dependencies
MuhafizYetenekleri tek helper; Oturum'a optional alan, kabul rüşveti/gece/kayıt için ince bağlantılar. OdaYetenekPaneli mevcut oda listesi; kasa/terazi yeniden okunur. IflasYoneticisi olay metnine tek özel haraç adaptörü, CSV değiştirilmez. MuhafizTerazisi aynı makbuzu okur; ikinci skor veya ekonomi yok.

## Tuning Knobs
data/muhafiz_yetenekleri.json bedeller/eşikler/önkoşul/bonus ve haraç akçe/moral/adalet. data/muhafiz_terazisi.json harac_agirlik. Asset gerekmedi, envanter G kontrol edildi; kutu oda ve mevcut düğmeler.

## Acceptance Criteria
Gerçek karar sayacı, koşul/önkoşul/kişisel ödeme/çift tıklama, gerçek CHR rüşvet bonusu ve kaynak immutable. Tek gerçek esnaf tahsilatı, hariç kişiler, inşa/ertesi gece/dönen görevli/terminal, kayıt idempotansı. Gerçek gece/bilanço/typed rapor; native oda alımı ve mevcut ekonomi/oda/divan/gece testleri.
