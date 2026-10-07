# Nüfus ve iklim tüketim dengesi — EKO-09

## Overview
Gece tüketimi ile HUD önizlemesi aynı salt okunur ihtiyaç hesabını kullanır. Canlı köylü nüfusu kişi başı erzak ve soğukta kişi başı odun tüketir; kaynak eksikliği gerçek sağlık/ölüm döngüsüne bağlıdır.

## Player Fantasy
Oyuncu büyüyen nüfusun kış ihtiyacını görür ve açlık/donma başlamadan erzak ile yakacak hazırlar.

## Detailed Rules
Çocuk, yetişkin, yaşlı her yaşayan köylü nüfusa dahildir; ev veya evsiz olma sayımı değiştirmez. Normal iklimde kişi başı 1 erzak, soğukta ek 1 odun. Kuraklık mevcut ×1.5 gıda, kar fırtınası mevcut ×2 odun deney çarpanını korur; yaz fırtınası da soğuktur. Eski hane odun tarifine karşı EKO-09 kişi tarifini esas alma kararı otonom yetkiyle belgelenmiştir; eski kis_odun_hane alanı yükleme uyumluluğu için silinmez.

## Formulas
Gıda = ceil(nüfus × gida_kisi × IklimDeneyi.gida_carpani). Odun = soğuksa ceil(nüfus × odun_kisi × IklimDeneyi.odun_carpani), aksi halde 0. Gıda süresi = stok / max(1, gerçek gecelik gıda ihtiyacı). Aç sayısı = ceil(eksik gıda / kişi başı ihtiyaç); en son gelenler aç kalır. Mevcut aclik_saglik/aclik_moral kayıpları ve ertesi gün verim etkisi korunur. Odun yetersizse mevcut soguk_saglik kaybı herkes için uygulanır; sağlık sıfırında gerçek nüfustan çıkarılır ve rapora ölüm yazılır. Ani veya sahte RNG ölümü eklenmez.

## Edge Cases
Boş köy tüketmez. Eski kayıtlar yeni optional alan gerektirmez. Kayıt restore aynı iklim/tüketim/ölüm/RNG sonucunu verir. Bina sayısı veya aynı evde yaşama yakacak hesabını değiştirmez. Önizleme kaynakları veya RNG'yi değiştirmez. Bu nüfus köylü nüfusudur; çeki hayvanının ayrıca bakım sistemi bu pakette eklenmez.

## Dependencies
KoyYonetimi._tuket, _saglik_ve_moral ve gece; Takvim/IklimDeneyi; TuketimDengesi; MevsimTuketimAdaptoru (MEV-11 yüzeyi); gerçek HUD stok kartı. MEV-02'nin özel 1–3 anlık donma olayı burada tamamlanmış sayılmaz.

## Tuning Knobs
Gıda/sağlık/Moral değerleri data/ayarlar/koy.tres; odun_kisi data/koy/tuketim_dengesi.json. Kuraklık/fırtına mevcut iklim deneyi çarpanlarıdır.

## Acceptance Criteria
Her yaş grubu sayımı, normal/kış/fırtına/kuraklık gerçek geceleri; ihtiyaç ile tüketim eşitliği; salt okunur önizleme ve gerçek HUD açıklaması; açlık/donma ölümü ve restore tutarlılığı; boş nüfus/aynı ev sınır durumları; native tooltip görüntüsü; tüm regresyon ve 20 gece.
