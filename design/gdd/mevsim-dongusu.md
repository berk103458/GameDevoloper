# Dört mevsim döngüsü — MEV-01

## Overview
Mevcut oyun günü tek saattir; mevsim hesabının ortak kaynağı MevsimYoneticisi olur. Eski Takvim API'si ince adaptörle korunur.

## Player Fantasy
Oyuncu ilkbahar, yaz, sonbahar ve kışın yedişer gününü planlayarak 28 günlük yılı yönetir.

## Detailed Rules
Varsayılan KoyAyarlari.mevsim_gun=7 ve dört mevsim sırası korunur. Kaydedilen gun 0'dan, görünen gün/yıl/mevsim günü 1'den sayılır. Mevsim geçişi yalnız gerçek gece çözümündeki mevcut gün artışına bağlıdır. Yeni timer, ayrı takvim kaydı veya RNG yoktur. Admin iklim önayarı etkin mevsimi değiştirebilir, gerçek yıl/gün hesabını ezmez. Geçmiş özel pozitif mevsim süresi ayarları desteklenir.

## Formulas
Mevsim = floor(gun / süre) mod 4. Mevsim günü = gun mod süre +1. Yıl günü = gun mod (4×süre) +1; yıl = floor(gun / (4×süre)) +1. Sonraki mevsime kalan = süre - gun mod süre. Vergi hafta başı mevcut gun>0 ve gun mod süre=0 kuralıdır.

## Edge Cases
6→7, 13→14, 20→21, 27→28 sınırları ve sonraki yıllar test edilir. Bozuk sıfır/negatif süre güvenli 7 gün, negatif gün başlangıç kabul edilir; Resource ve kayıt değiştirilmez. Mevsim isim dizisi dört değilse standart sıra kullanılır. Durum takvim_mevsimi/etkin mevsim ve zorlanmis alanıyla deneyin gerçek tarihten ayrıldığını gösterir. Kayıt yüklemede aynı gün/iklim durumu yeniden türetilir.

## Dependencies
src/dunya/mevsim_yoneticisi.gd yeni ortak hesap; src/koy/takvim.gd eski fonksiyonları aynı imzayla yönlendirir. KoyYonetimi, vergi, tüketim, fiyatlar ve mevcut HUD aynı API'lerini kullanır. Mevsim HUD genişlemesi MEV-12, sonraki hava mekanikleri kendi maddeleridir.

## Tuning Knobs
Mevcut data/ayarlar/koy.tres / KoyAyarlari mevsim_gun ve mevsimler; yeni denge dosyası veya saat yoktur. Asset gerekmedi; G tablosunda yeni ihtiyaç yok, üretim/indirme yapılmaz.

## Acceptance Criteria
Varsayılan mevsimler 7'şer gün, yıl 28 gün. Ortak durum ile eski API aynı sınırları verir; sorgu kayıt/RNG değiştirmez. İklim deneyi ve kayıt roundtrip aynı yıl/takvim gününü korur. İlgili vergi/tüketim/kış/fiyat/sipariş/kayıt/Admin iklim/UI ve 20 gece regresyonları geçer.
