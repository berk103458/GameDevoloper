# Karar: ekonomik Refah ile kamu kasasını ayır

Tarih: 7 Ekim 2026. Durum: kabul edildi (Codex; kullanıcının otonom tasarım yetkisi).

## Bağlam
ADM-04 ilk uyarlamasında Refah kamu akçesinin görünümüydü. EKO-08 ağır verginin kamu gelirini artırırken Moral ve Refahı düşürmesini gerektirir. Aynı bakiyeye iki zıt sonuç yazmak mümkün değildir. Kullanıcı artık rutin tasarım kararlarının Codex tarafından verilmesini istiyor.

## Karar
Refah yaşayan köylülerin 0–100 ekonomik yaşam standardı puanıdır; köy göstergesi kişi puanlarının ortalamasıdır. Kamu akçesi ve muhafızın kişisel kesesi ayrı para hesapları olarak aynen korunur. Yeni/eski kişi başlangıcı dış denge verisinde 50; bozuk puan güvenli başlangıca döner. Vergi tahsilatında düşük +2, orta 0, ağır −5 ekonomik puan; aynı gece koruması ve muafiyet hem geliri hem Moral/Refah etkisini kapsar. Bu puan para birimi veya üretim bonusu değildir.

## Sonuçlar
ADM-04 Refah enjektörü gerçek kişi puanlarını değiştirir, hazineyi değiştirmez. Köylü kartı ve pazar puanı gösterir. Optional kişi kayıt alanı eski kayıtları açar; kasa alanları, CSV/CHR şema isimleri ve beş stat isimleri değişmez. Mevcut karar matrisi stat isimleri korunur; bu paket başka diyalog uygulamasını yeniden yazmaz.

## Doğrulama
Ekonomik puan sınırı/ortalama, kamu kasasının korunması, eski/yeni/bozuk JSON; gerçek haftalık vergi, muafiyet/çift tahsilat; gerçek pazar ve native ekran; bütün regresyonlar ve 20 gece.
