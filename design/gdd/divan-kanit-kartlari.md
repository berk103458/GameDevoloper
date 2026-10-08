# Divan kanıt kartları — CAS-14

## Overview
Mevcut DivanSorguPaneli, kapıda bulunan Clue kimliklerini kaynak açıklamalı kartlar olarak gösterir. Aynı duruşma ve keşif kaydı kullanılır.

## Player Fantasy
Muhafız, ziyaretçide bulduğu nişanı, yükü ve fiziksel izi duruşmada okuyup sunar.

## Detailed Rules
DivanKanitKarti yalnız DivanKanit.durum içindeki geçerli bulunan kimlikler için üretilir. Başlık ve açıklama DivanKanit.ipuclari üzerinden kaynak KarakterVerisi'nden okunur. Sun düğmesi mevcut DivanKanit.sun işlemini çağırır; sunulan veya itiraf edilmiş kart yeniden sunulamaz. Bulunmamış ve başka kişiye ait kanıt görünmez. Kartlar mevcut kaydırılabilir divan listesinde kalır; ayrı panel veya veri deposu açılmaz.

## Formulas
Görünen kart sayısı = geçerli bulunan kimlik sayısı. Sunulan kimlikler bulunanların altkümesidir. CAS-06 sorgu eşiği ve gerçek gözlenmiş fiil şartı korunur.

## Edge Cases
Boş keşifte kart yoktur. Kişi değiştirme ve yeniden çizme önceki kart düğümlerini kaldırır. Uzun kaynak açıklamaları satır kaydırır; listede dikey kaydırma kullanılır. Kartın sunulması para, stok, zar, kaynak Resource veya kapı bayraklarını değiştirmez. Duruşma kapanırken mevcut kamera, hız ve kişi pozu geri gelir.

## Dependencies
src/kapi/divan_kanit_karti.gd yeni çizim helperidir. src/kapi/divan_sorgu_paneli.gd tek helper çağrısı içerir. DivanKanit, DivanEkrani, Tema ve CAS-05 meydan bağlantısı korunur. KAP-02/03 Cursor tarafından kapatılmıştır; kart sunumu bu motorları değiştirmez.

## Tuning Knobs
Mevcut Tema.KUCUK_PX ve panel stili; sorgu dengesi data/divan_sorgusu.json içinde kalır. Yeni görsel, model veya ses gerekmedi; asset gerekmedi, envanter G kontrol edildi.

## Acceptance Criteria
Gerçek CHR_001 kapı incelemelerinden üç kaynak kart oluşur; kart açıklamaları kaynakla aynıdır. Nişan ve yük sunumu, tek itiraf, tekrar ve JSON sözleşmeleri geçer. Headless/native gerçek divan, kamera/hız/poz geri dönüşü ve ayna kopyası doğrulanır.
