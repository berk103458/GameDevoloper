# Mevsim takvim HUD — MEV-12

## Overview
Mevcut Hud._mevsim etiketi iki satırla genişletilir; ikinci kaynak/HUD paneli veya saat yok.

## Player Fantasy
Oyuncu tek bakışta mevsimi, yılın gününü ve kapı/üretimi etkileyen havayı görür.

## Detailed Rules
Üst satır etkin mevsim, mevsim günü/süresi ve kısa hava; alt satır yıl ve yıl günü/yıl uzunluğu. Mevcut guncelle sinyali kullanılır; yeni kare polling yok. Hava aynı IklimDeneyi kaydı: Açık/Tipi/Kuraklık/Yağmur/Sis. Tooltip sonraki mevsime kalan gün ve deney mevsimi ile gerçek takvim farkını açıklar.

## Formulas
Tüm tarihler MevsimYoneticisi.durum: yıl=floor(gün/(4×süre))+1, yıl günü=gün%(4×süre)+1. Varsayılan yıl28 gün. İkinci hesaplama/kayıt yok.

## Edge Cases
Admin zorlanmış mevsim gün/RNG ilerletmez; yılın gerçek günü korunur. Eski kayıt doğal hava, restore aynı metin. Tek etiket aynı kalır; artan iki satır yüksekliği mevcut PanelContainer tarafından hesaplanır, kaynaklar mevcut yatay scroll içinde kalır.

## Dependencies
MevsimTakvim; Hud tek güncelleme çağrısı, MevsimYoneticisi ve IklimDeneyi. KoyEkrani, CSV, CHR ve kaynak sistemi değiştirilmez.

## Tuning Knobs
Takvim süresi mevcut KoyAyarlari.mevsim_gun; kısa hava adları helper sabiti. Asset gerekmedi; mevcut yazı ve etiket, G envanteri kontrol edildi.

## Acceptance Criteria
Gerçek HUD tüm mevsim/yıl sınırları ve beş hava, Admin gerçek tarih ayrımı, restore ve yan etkisizlik. Tek HUD düğüm sayısı ve etiket ekran/HUD sınırları; native görüntü ve mevcut iklim/gece/kaynak/açılış regresyonu.
