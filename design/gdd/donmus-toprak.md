# Donmuş toprak — MEV-03

## Overview
Festive mevcut kis_durur katalog kuralıyla tarla ve bostanı durdurur. Bu paket eksik kabul kanıtını tamamlar; ikinci üretim sistemi eklemez.

## Player Fantasy
Oyuncu kıştan önce erzak depolar; baharda aynı çiftçiler üretime döner.

## Detailed Rules
Tarla kis_durur=true. Bostan MeslekYapilari.ekler üzerinden tarla verisini kopyalar ve aynı bayrağı korur. KoyYonetimi._uret soğukta iki yapıyı kis bekleme durumuna alır; hiçbir gıda/buğday üretimi veya stok değişikliği olmaz. Mevcut gece kış görev kaydırması ve bahar eski görev dönüşü çalışır. Köy depolanmış gıdayı tüketir. Diğer sanayi/av/hayvan üretimi kendi mevcut kurallarını korur; bütün köy ekonomisi kapatılmaz.

## Formulas
Tarım duruşu = kis_mi() ve katalog.kis_durur. Tarım üretimi duruşta 0; nüfus tüketimi mevcut TuketimDengesi hesabıdır.

## Edge Cases
Bostan buğday tarifi de durur. Yazdaki zorlanmış kar fırtınası aynı soğuk kuralına tabidir. Kayıt yükleme aynı gece raporunu verir. Baharda eski bina/boş slot yoksa mevcut güvenli görev dönüşü uygulanır.

## Dependencies
MeslekYapilari, BinaKatalogu, KoyYonetimi._uret/_kis_kaydirmasi/_bahar_donusu, AtamaOnizlemesi ve mevcut sulama görselliği. Üretim çekirdeği değiştirilmedi.

## Tuning Knobs
Mevcut data/koy/binalar.json kis_durur ve KoyAyarlari mevsim süresi. Asset gerekmedi; envanter G kontrol edildi, üretim/indirme yok.

## Acceptance Criteria
Gerçek tarla/bostan, buğday tarifleri, kış stoksuz üretim, erzak/yakacak tüketimi, restore eşitliği, bahar görev/üretim dönüşü ve kar fırtınası tests/unit/kvr/donmus_toprak_test.gd ile doğrulanır. Tahıl zinciri, mevsim, atama önizlemesi ve sulama kontrolleri korunur.
