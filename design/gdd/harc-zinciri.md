# EKO-05 — Taş, kireç ve harç

## Overview
Taş Ocağı mevcut ham taş üretimini sürdürür. Yeni Kireç Kuyusu iki seçilebilir tarifle taş/yakacak → kireç → harç üretir. Harç yeni Taş Ev ve taş sur seviyelerinin gerçek malzemesidir.

## Detailed Rules
Kireç kuyusu 6 odun/4 taşla, harç gerektirmeden kurulur; iki iş yuvası ve iki gün inşa süresi vardır. Kireç tarifi kişi başına 2 taş/1 odun tüketir, temel 2 kireç üretir. Harç tarifi 2 kireç/2 taş tüketir, temel 4 harç üretir. Mevcut gerçek üretim çarpanları, kesir, ambar kapasitesi, yaş ve grev koşulları uygulanır. Girdi yoksa hiçbir girdi tüketilmez.

Taş Ev 4 odun/18 taş/6 harç, üç gün, altı yatak. Mevcut kulübe/ambar/atölye ahşap yapıların temel taşı maliyetleri korunur; bunlar yeni taş duvarlı evin yerine geçirilmez. Normal bina hasar alanı eklenmez. Yeni türler mevcut genel yapı görselini kullanır; özel sanat modeli bu pakette yok.

Sur 0→1 mevcut ahşap çit ve akçe taksitidir. Seviye 2 son taksitinde 16 taş/8 harç, seviye 3 son taksitinde 24 taş/12 harç ayrıca harcanır. Önceki taksitler yalnız akçe biriktirir; son taksitte rezerv veya malzeme eksikse ödeme/seviye/stok değişmez. UI bedeli bütün taksitler boyunca açıklar ve eksik son taksiti devre dışı bırakır; model de yeniden doğrular.

## Formulas
Çıktı mevcut üretim formülü ile temel reçete miktarı × kişisel/bina verimidir. Malzeme son taksitte bir kez düşülür; erken taksit başına yeniden harç tüketilmez. Bina yıkımı kaydedilmiş harcanan malzemeler üzerinden mevcut iade oranını kullanır.

## Edge Cases
Eski kayıtlar yeni stokları sıfırla başlatır; mevcut taş, yapılmış bina ve sur seviyeleri korunur, geçmiş inşaat için borç çıkarılmaz. Kuyunun kuruluşunda harç bağımlılığı olmadığı için başlangıç kilitlenmez. Kireç yokken harç üretimi ham taşı harcamaz. Son taksit başarısız olursa kısmi ödeme korunur. İkinci tıklama yeni seviye taksitidir; önceki malzemeler ikinci kez düşülmez. Taş ocağının eski tarif kimliği korunur.

## Dependencies
BinaKatalogu/KoyYonetimi mevcut gerçek üretim ve inşaat, Kaynaklar toplam ambar, JSON güvenli kayıt; YasRolleri/MeslekGrevi; YapiKarti, tarif seçimi ve sur taksit arayüzü. CSV SYS-09 koruması nedeniyle okunur etiketler ince adapterden gelir.

## Tuning Knobs
Bütün yeni miktarlar data/koy/harc_zinciri.json içinde açık denge varsayımıdır; mevcut sur akçe dengesi değişmez.

## Acceptance Criteria
Gerçek gece kireç/harç, gerçek taş ev malzeme düşümü ve eksik harç reddi; surun son taksitinde atomik malzeme/akçe/seviye değişimi; eski/yeni JSON; gerçek UI tarif ve sur düğmeleri; native görüntü, import ve tam regresyon geçmeden ROADMAP kapatılmaz.
