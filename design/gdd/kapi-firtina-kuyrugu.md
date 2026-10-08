# Fırtınada kapı bekleyişi — MEV-15

## Overview
Tipi yolun görünür kuyruk alanını daraltır; mevcut mantıksal ziyaretçi listesi, heybe ve kapı karar motoru korunur.

## Player Fantasy
Oyuncu kötü havada uzakta bekleyenlerin giderek artan gerginliğini yönetir; ziyaretçiler kaybolmaz.

## Detailed Rules
Denge/yorum: ROADMAP üç normal gelişi esas alıyor. Festive sahnesinin normal görsel bütçesi6; bu eski API korunur. Normal3 gelen görünür, tipide en çok1 bekleyen model yolda kalır. Etkin kışın altıncı/yedinci günündeki tipide0 bekleyen model, herkes uzakta; sıradaki kişi yine kapıya gelir. Sıfır kapasite kapının karar/ziyaret fonksiyonunu kapatmaz ve NPC silmez. Ağır eşik mevcut mevsim günü ve Admin etkin mevsiminden türetilir; ikinci hava/zaman RNG yok.

Her yeni aktif ziyaretçi kuyruktan alındığında hâlâ bekleyen gerçek NPC'ye1 bekleme tansiyonu eklenir. Aynı adım tekrar edilirse eklenmez. CHR mevcut tansiyon setter/sinyali/panik yönlendirmesiyle güncellenir; kaynak KarakterVerisi/JSON değişmez. Figürler mevcut bilgi etiketinde bekleme baskısını gösterir; ayrı CHR sorgusu veya yeni soru/karar sistemi almaz. Kapı bilgi etiketinde Tipi sırası ve mevcut kişinin bekleme artışı vardır. İki görünür kişi gerektiren sıra olayları daralmada çekilmez.

## Formulas
Normal görünür bütçe=mevcut KUYRUK_GORUNEN6 (standart geliş3). Tipi bütçesi1; etkin kış günü>=6 ve tipi bütçesi0. Bekleme=clamp(eski+1,0,10); CHR tansiyon=mevcut setter(eski+1), panik eşiği mevcut8. Aynı Gelen/adım makbuzu çift uygulamayı engeller.

## Edge Cases
Sıfır modelde sıradaki uzak ad, aynı mantıksal kişiye uygun olarak uzak bekleme listesinden çıkarılır; görünmeyen mükerrer ziyaret oluşmaz. Mevcut sıra/heybe/RNG/para/gün değişmez. Normal havaya yeni gece dönüşte eski bütçe geçerlidir. Aktif ziyaretçi bekleme artışı almaz; son sıradaki kişi kendinden önceki ziyaret sayısınca birikir. Debug tansiyon kilidi setter üzerinden önceliğini korur. Bekleme makbuzu mevcut ziyaret ömrüne aittir; oyunun mevcut kapı akışı gün ortası sorguyu kaydetmez, yeni bir kayıt modeli eklenmedi. Kayıtlı hava/takvim yüklenince aynı kapasite türetilir.

## Dependencies
KapiFirtinaKuyrugu; KapiEkrani hazırlık/bekletme/bilgi/sıra olayı ince çağrıları; KapiSahnesi iki kapasite karşılaştırması ve sıfır uzak sıra tüketimi. IklimDeneyi/MevsimYoneticisi mevcut kaynaklar; ChrSorgusu mevcut tansiyon/panik motoru. KAP-01 JSON ve kararlar değişmez.

## Tuning Knobs
Data/kapi_firtina_kuyrugu.json: tipi_kapasitesi1, agir_kapasite0, agir_kis_gunu6, bekleme_tansiyon1. Asset gerekmedi; mevcut model, tansiyon barı ve bilgi etiketi, G envanteri kontrol edildi. Asset üretimi/indirme yok.

## Acceptance Criteria
Normal3 geliş, tipi1/ağır0, gerçek model ve mantıksal kişi sırası, sıfır kapasitede uzak listenin tüketimi, her ziyaret sonunda tam kalan sayı, normal dönüş. CHR tansiyon/aynı adım tekrar/panik/saf kaynak/RNG; figür bekleme, kayıtlı iklimden aynı kapasite. Gerçek kapı UI/header/native görüntü ve mevcut sıra atlama/CHR/tansiyon/kuyruk/kayıt/20 gece regresyonu.
