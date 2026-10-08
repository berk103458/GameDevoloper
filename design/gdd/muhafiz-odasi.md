# Muhafız odası — ODA-01

## Overview
Mevcut köy eylem sütunundan açılan tek bağımsız iç mekân: yatak, masa, meşale ve zemin kasası. Nesneler JSON ayarlı düz renk kutulardır.

## Player Fantasy
Muhafız, köy yönetiminden kendi odasına çekilir; köy ve kişisel alanın farklı olduğunu görür.

## Detailed Rules
Oda aynı KoyEkrani üzerinde tam ekran modal açılır; SubViewport kendi World3D'sini kullanır. Köy duraklar, oda çizilir. Dön düğmesi veya Escape odayı kapatıp önceki 0/1/2/3 hızını geri getirir. Açık olay, gece geçişi, divan, ikinci oda veya oyun sonunda giriş reddedilir. Oda klavye olaylarını tüketir; alttaki köy kısayolları çalışmaz.

## Formulas
Ekonomi ve zaman etkisi sıfır. Oda açma/kapama Oturum kaydını, kişisel ve kamu akçesini, envanteri, stokları ve RNG durumunu değiştirmez.

## Edge Cases
Başlangıçta duraklatılmış köy dönüşte de duraklar. Ana sahne kapanırken silinen köye hız uygulanmaz. Divan ve oda birbirini engeller. Köy kamerası/mesafesi değiştirilmez. Etiketli kutular görsel yer tutucudur; yatak/kasa işlemleri henüz yoktur, sonraki ODA maddelerinin yüzeyidir.

## Dependencies
src/dunya/muhafiz_odasi.tscn/gd tek nesne değişim noktasıdır. MuhafizOdasiEkrani mevcut temayla oda yüzeyini kurar. MuhafizOdasiBaglantisi köyde tek çağrıyla bağlanır; mevcut DivanBaglantisi modal korumasına oda eklenir. EKO kişisel kasa veya TUC kaçak envanteri tekrar yazılmaz, çift HUD yok.

## Tuning Knobs
data/muhafiz_odasi.json kamera, parça boyutları/yerleri/renkleri. Asset üretilmez veya indirilmez; gereken iç mekân/yatak/masa/meşale/kasa modelleri envanter G'dedir.

## Acceptance Criteria
Gerçek köyde düğme→oda, kutu nesneler/ayrı dünya, tekrar ve divan/olay/terminal reddi, klavye kısayol yalıtımı, Escape/düğme dönüşü ve önceki hız. Kayıt/stok/kasa/RNG değişmez; headless/native oda ve mevcut divan/gece/açılış testleri geçer.
