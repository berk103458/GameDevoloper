# Sinsi gece rutini — ANI-10

## Overview
Mevcut gizli eğilim veya iş sabotaj riski olan köylüler gece ateşten uzak kuytuda bekler; gerçek nöbetçi yaklaşınca yön değiştirir.

## Player Fantasy
Gece köyünde davranışlar gözlemlenebilir; birinin tenhada durması onun kimliğini veya suç işlediğini açıklamaz.

## Detailed Rules
Yalnız gece, sağlıklı ve nöbetçi olmayan risk adayları. GizliEgilimler.risk ve IsMemnuniyeti.sabotaj_riski salt okunur; yeni suç/sabotaj simülasyonu yok. Mevcut açık hücreler içinden meydan/yol dışında, ateşten ve muhafızlardan yeterince uzak hedef seçilir. Başka sinsi köylünün hedefi dolu kabul edilir. En uzak nöbetçi mesafesi önceliklidir; eşitlikte kişi kimliği ile kararlı hücre sırası. Her aday için erişilebilir A* hedefi aranır. Yaklaşan nöbetçi hem kişiyi hem mevcut hedefini tehdit ediyorsa mevcut bütçeli rota kuyruğu yeniden planlar. Güvenli kaçış devam eder. Yağmurda mevcut saçak davranışı önceliklidir; gündüz/akşam eski rutin geri gelir.

## Formulas
Yürüme hızı = önceki hız × sinsi hiz çarpanı. Kuytu uzaklığı ≥ ates_mesafesi; nöbetçi uzaklığı ≥ muhafiz_mesafesi. Kaçış hedefi mevcut konumdan ≥ yer_degistirme. Yeniden planlama aralığı yeniden_planlama saniye. Eşit hücre sırası = (x + y × genişlik + kişi id × sacilim) mod toplam hücre.

## Edge Cases
Nöbetçi yoksa mesafe eşit kabul edilir, kimliğe göre dağılım sürer; RNG kullanılmaz. Ulaşılamayan/kapalı hedef seçilmez; hiçbir uygun hedef yoksa önceki rutin korunur. Hastalık, ağır yara, sıfır sağlık veya muhafız ataması özel davranışı kaldırır. Mevcut gece ışığı kullanılır, ek gölge shaderi/ışık/ikinci HUD üretilmez. Aynı kuyruğun kare başı rota sınırı korunur.

## Dependencies
SinsiGeceRutini, GizliEgilimler, IsMemnuniyeti, MuhafizMaasi, KoyRotasi, AtesBasiRutini, KarakterHavaTepkisi, KoyHalkHareketi ve mevcut KarakterModel.

## Tuning Knobs
data/sinsi_gece.json. Gerçek sinsi yürüyüş klibi gelene dek mevcut yürüyüş yavaşlatılır; tek değişim noktası KoyHalkHareketi._adim / SinsiGeceRutini. Asset ihtiyacı envanter G tablosundadır; yeni asset oluşturulmaz/indirilmez.

## Acceptance Criteria
Gece/gündüz/akşam ayrımı, sağlık/normal/muhafız/risk adayları. Gerçek sahnede ateşten uzak hedef, nöbetçi yaklaşınca rota değişimi, güvenli kaçışın devamı, muhafız yokken kuytu, iki adayın ayrı hedefi ve gündüz dönüşü. Kayıt/stok/RNG ve gizli oyuncu metni korunur; native/ayna, önceki rutinler ve 20 gece geçer.
