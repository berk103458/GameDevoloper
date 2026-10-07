# Ateş başı ritüeli — ANI-07

## Overview
Boşta köylüler akşam/gece mevcut meydan ateşinin çevresinde toplanıp ellerini öne uzatarak ısınır.

## Player Fantasy
Gündüz işi bitmiş köyün geceleri de yaşayan bir topluluk olarak görünmesi.

## Detailed Rules
Yalnız BOSTA görevindeki köylüler katılır. Atanmış çalışanlar mevcut ev rutini, muhafızlar mevcut devriye yolunda kalır. Aynı A* grafiğinde açık hücrelerden ateşe güvenli uzaklıktaki halka seçilir; kuyu yaklaşması boş kalır. Görünür adayların kimlik sırası ayrı duraklar verir. Kapasite veya erişim yoksa mevcut rutin korunur. Isınma durağa varınca başlar, faz/görev değişiminde kapanır. Mevcut DurusDuzeltici içinde ince isin dalı yeni sınıfın iki kol hedefini kullanır; ikinci iskelet sistemi yoktur.

## Formulas
Duraklar: en_yakin ≤ yatay ateş mesafesi ≤ en_uzak, kuyu mesafesi ≥ kuyu_mesafesi. Sıra görünür aday kimliklerinin artan sırasıdır. Önkol hareketi = sin(zaman × salinim_hizi) × salinim; karakter fazı senkron hareketi önler.

## Edge Cases
Yol/ateş halkası kapalıysa duvar içinden geçilmez. Faz değişiminde biriken eski duruş sıfırlanır. Görünür durak sayısından fazla köylü mevcut meydan/ev rutininde kalır. Ocak ikinci kez oluşturulmaz; mevcut ışık ve alevler kullanılır. Görsel halka ekonomi, moral, hava sıcaklığı, kayıt veya RNG değiştirmez.

## Dependencies
AtesBasiRutini, KoyHalkHareketi, KoyRotasi, MuhafizMaasi, SulamaRutini kuyu konumu, mevcut DurusDuzeltici/KarakterModel ve KoyYonetimSahnesi meydan ocağı.

## Tuning Knobs
data/ates_basi_rutini.json: mevcut ateş ofseti, güvenli halka ve kuyu mesafeleri, kol/önkol hedefleri, ısınma salınımı ve hızı. Ekonomik denge değişmez.

## Acceptance Criteria
BOSTA gündüz/akşam/gece, görevli/nöbetçi adaylık ve kayıt/RNG birimi. Gerçek sahnede ayrı güvenli duraklar, varınca isin duruşu, muhafız devriyesi, atanmış işçi ev rutini, gündüz temizliği ve engel kontrolü. Native gece görüntüsü, kaynak/ayna import, açılış ve önceki rutinler ile 20 gece duman testi.
