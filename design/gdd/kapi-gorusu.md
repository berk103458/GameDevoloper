# Kapı görüşü — MEV-09

## Overview
Mevcut CHR inceleme portresinin görsel izi tipi/siste bulanıklaşır; kapı ve diyalog yeniden yazılmaz.

## Player Fantasy
Muhafız kötü havada portreyi yakından inceleyerek iz arar.

## Detailed Rules
Kar fırtınasında 4, siste 2.5 kaynak piksel yarıçaplı dokuz örnekli filtre. Yalnız mevcut GorselIz portresine uygulanır. İnceleme, nişan/yük, diyalog ve karar düğmeleri, metin açıklamaları ve ipucu açma kuralları korunur; erişilebilir metin bulanıklaştırılmaz. Hava denetçisine eski seçim indeksleri korunarak Sis eklenir. Panel açıldığında aynı kayıt önayarı okunur. Doğal sis/fırtına zamanlayıcısı bu pakette eklenmez; kuyruk daralması MEV-15'tir.

## Formulas
yaricap=clamp(data[kayıtlı hava],0,8); normal/yağmur/kuraklık=0. Merkez ağırlık4, dört eksen2, dört köşe1; toplam16.

## Edge Cases
Materyal panel bazında izoledir; tekrar uygulama ikinci uyarı/materyal üretmez. Normal hava önceki materyali aynen geri verir. Portresiz panel etkilenmez. Yeni sis eski kayıtları bozmaz; gün/RNG/kanıt veya ekonomi değiştirilmez.

## Dependencies
KapiGorusAdaptoru, ChrKapiAdaptoru tek çağrı, mevcut TextureButton ve IklimDeneyi optional kayıt. KAP-01/heybe/CSV/CHR değiştirilmez.

## Tuning Knobs
Data/kapi_gorusu.json yarıçapları. Asset gerekmedi; mevcut portre ve kod shader'ı, yeni görsel/model/ses/klip üretilmedi veya indirilmedi. Envanter G kontrol edildi.

## Acceptance Criteria
Gerçek kapıda fırtına bulanıklığı, portre/nişan tıklaması ve kanıt açılması, idempotentlik, sis restore, normal materyal geri dönüşü; mevcut CHR/iklim/açılış testleri ve native görüntü.
