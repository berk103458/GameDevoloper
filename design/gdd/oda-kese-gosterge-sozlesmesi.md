# Ortak kişisel kese göstergesi — ODA-14

## Overview
ODA-14 mevcut EKO-11/ODA-02 göstergesinin örtüşme denetimidir. Yeni ortak panel veya ikinci HUD yazılmaz.

## Player Fantasy
Kişisel kesenin bakiyesi köyde ve gizli oda kasasında aynı görünür.

## Detailed Rules
src/arayuz/koy_hud/kese_gostergesi.gd KeseGostergesi.guncelle(Oturum) tek API. Mevcut src/arayuz/hud.gd köy yüzeyi ve src/arayuz/oda_kasasi_paneli.gd oda yüzeyi bu sınıfın örneklerini kullanır. Bakiye tek muhafiz_akce; kamu bütçesi bu göstergeye yazılmaz.

## Formulas
Gösterilen akçe=mevcut kişisel bakiye. Oda kapağı açıldığında ve oda yetenek/geliştirme alımından sonra aynı örnek guncelle çağrısıyla yenilenir. Bir görsel örnek bir para kaydı değildir.

## Edge Cases
Kasa kapağı tekrarı gelir yaratmaz; sıfır kasa okunur. Oda kapanışında mevcut köy HUD'ı güncellenir. Kişisel harcama kamu/ambar/RNG değiştirmez; modal/hız/JSON dönüşü korunur.

## Dependencies
Mevcut Hud, OdaKasasiPaneli, OdaYetenekPaneli, OdaGelistirmePaneli ve KeseGostergesi. ROADMAP taslak hedef yolu yeni dosya üretme zorunluluğu değildir. Core/kod/CSV değiştirilmedi.

## Tuning Knobs
Yeni sayı/denge yok. Asset gerekmedi; envanter G kontrol edildi; mevcut kese gösterge görseli yeniden kullanılır.

## Acceptance Criteria
cift_kasa_test; kese_gostergesi_kontrol; oda_kasasi_kontrol; oda_yetenek_kontrol; oda_gelisim_kontrol ve korumalı API. Aynı gerçek bakiyenin para giriş/harcama/kapak/boş kasa/kayıt sonrası görünümü altı kontrolle doğrulanır.
