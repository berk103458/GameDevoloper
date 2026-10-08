# Zanaat sipariş sözleşmeleri — TUC-05

## Overview
Mevcut gezgin tüccar ziyaretinden bir sipariş teklifi türetilir; kabul edilmiş taahhüt tek kalıcı sözleşme defterinde saklanır.

## Player Fantasy
Oyuncu haftaya yetiştirmek için üretimini tüccarın siparişine göre planlar.

## Detailed Rules
Her uzman ziyareti bir teklif verir: Celep 12 un/24 akçe, Nalbur 10 kereste/30, Kumaşçı-Aktar 20 gıda/18, Silah Tüccarı 8 demir/28. Kabul yalnız tüccarın konaklamasında ve en fazla üç açık sözleşme varken mümkündür. Kabul stok/kasa harcamaz; miktar/ödül/vade kabul anında sabitlenir. Aynı ziyaretin teklifi iki günde bir kez kabul edilir. Teklif ve defter mevcut pazar durum satırındaki Sözleşmeler düğmesinden aynı kart altyapısıyla açılır.

## Formulas
Teklif id = uzman id + varış günü. Kabul günü = kaydedilen gün + 1. Vade = kabul günü + sure (7). Açık sayı bekliyor durumundaki sözleşmelerin sayısıdır. İkinci konaklama günü kabul edilirse vade o güne göre başlar.

## Edge Cases
Tüccar yokken yeni kabul yapılamaz; eski taahhüt defterde kalır. Tekrar kabul ve üç açık sipariş sınırı model/UI katmanında doğrulanır. Bozuk miktar/tarih, bilinmeyen ürün/uzman veya durum reddedilir. Eski kayıtta siparisler alanı yoksa boş defter açılır. Panel/RNG değişmez. Teslim/itibar TUC-06, ihlal/faiz TUC-07 kapsamındadır; bu madde onları tamamlandı saymaz.

## Dependencies
SiparisSozlesmeleri saf teklifler ve kabul modeli; GezginTuccarTakvimi tek ziyaret kaynağı. KoyYonetimi optional alan/kayıt için ince adaptör. SiparisSozlesmePaneli mevcut KoyEkrani kartını kullanır; GezginTuccarPazarAdaptoru tek bağlantı. İkinci HUD/kasa/simülasyon yoktur.

## Tuning Knobs
data/siparis_sozlesmeleri.json uzman ürün/miktar/ödül, sure ve azami_aktif. Denge varsayımı testlerle kaydedildi. Asset gerekmedi: yalnız mevcut metin/kart/düğme kullanılır, asset üretimi/indirme veya CSV değişikliği yoktur.

## Acceptance Criteria
Gerçek un teklifi, yedi günlük vade ve UI kabul sinyali; tekrar/kapasite/uzman yokluğu engelleri. Kabul stok/kasa/RNG harcamaz; teklif kaynağı çıktıdan değiştirilemez. Ana kayıt/optional eski alan, tüccar ayrıldıktan sonra defter korunumu; native ekran, ayna import/UI ve eski tüccar/snapshot/20 gece testleri geçer.
