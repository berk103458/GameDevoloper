# Gözcü kulesi ve erken uyarı — HAR-06

## Overview
Var olan nobetci_kulesi CHR hedef türü gerçek maliyetli tek çalışanlı yapı verisiyle genişletilir. Aynı savunma yapı kartı ve harita Hisar bilgi alanı kullanılır; yeni bina/kuyruk/HUD motoru yoktur. HAR-13 ayrıntılı kafile/heyet özeti tamamlayıcısı henüz kapanmış sayılmaz.

## Player Fantasy
Sağlıklı gözcü yoldaki gelişleri bir gün önceden öngörür; muhafız ertesi nöbet için hazırlanır. Yol gözlemi gizli eşya, suç veya karakter statı açmaz.

## Detailed Rules
Dış JSON varsayımı:2x2 hücre,8 odun/4 taş/2 kereste/10 kamu akçesi,2 gece inşa,1 gözcü yuvası. Hazır kulede atanmış sağlıklı yetişkin çalışırsa öngörü açılır; hastalık/uyuklama/zindan/dış görev/iş reddi engeldir. Mevcut yaş/atama kuralları kullanılır. Kule işi üretim vermez; yeni maaş veya asayiş bonusu eklenmez.

## Formulas
Öngörü izole Oturum JSON kopyasında gerçek gece_sonu ve gece_kuyrugu üzerinden üretilir. Oyun ve bina Resource ayarları özel kopyalanır, katalog salt okunur paylaşılır. Sonuç yalnız en fazla8 public isim ve sınıftır; ikinci kuyruk saklanmaz, kaynak gün/RNG/kadro/defter/kasa/Resource değişmez. Gösterilen tarih kaynak gun+2 bir tabanlı ertesi gündür.

## Edge Cases
Kule yok, inşa halinde, çalışan yok veya terminalse kapalı. Simülasyonda gece terminali oluşursa yalnız genel belirsizlik gösterilir, neden/özel olay/gizli veri açıklanmaz. Sonraki gerçek gece veya olay kararı değişirse öngörü değişebilir; kesin varış garantisi değildir. Aynı kaynakta tekrar/JSON aynı öngörüyü verir; aynı gece kararıyla gerçek sonraki kuyruk eşleşir. Zindan/çocuk/hasta engeli gerçek modelden okunur. CHR hedef adı/katalog eşlemesi korunur; bedelsiz hedef inşası geri gelmez.

## Dependencies
GozcuKulesi katalog helper ve GozcuOngoru izole runtime helper. BinaKatalogu'nda tek ek çağrı; MeslekYapilari ad/açıklama guard'ı; YapiKarti tek ColorRect ikon seçimi; KoyYonetimSahnesi'nde tek kutu çağrısı; CevreHaritasi Hisar metnine tek öngörü çağrısı. KoyYonetimi/Oturum/koy_halk_hareketi/CSV/CHR veri kaynakları değiştirilmez.

## Tuning Knobs
Yapı maliyeti/süre/slot/boyut, sağlık_min, azami_aday ve insan metinleri dış JSON. Kutu boyutu/renk aynı dış kaynaktan okunur. Asset üretimi/indirme yok; HAR06-KULE ve HAR06-IKON envanter G içinde. Gerçek model/ikon tek GozcuKulesiGorseli helper üzerinden değiştirilebilir.

## Acceptance Criteria
Eski katalog verisi, gerçek kurulum/maliyet, hazır/atanmış/hasta/çocuk/zindan, bir gün öngörü, public-only çıktı, tam runtime/RNG ve ayar/katalog koruması, tekrar/JSON/gerçek sonraki kuyruk. Aynı savunma kartı ve inşa kipi, gerçek BoxMesh, aynı harita/kapalı durum ve saf okuma; native/headless/ayna ve CHR/köy/kayıt/harita regresyonu.
