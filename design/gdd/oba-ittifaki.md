# Ertuğrul Obası ittifakı — HAR-07

## Overview
Mevcut Pazar kartında buğday karşılığı at veya alp takası; ilk başarılı işlem kalıcı ittifak bayrağı oluşturur. Yeni para, hayvan veya nüfus sistemi yoktur.

## Player Fantasy
Hisarın tahıl fazlası obanın atı ve savunma iş gücüyle değerlendirilir. Barınak ve yatak planlaması takasın gerçek sınırıdır.

## Detailed Rules
Gün başına toplam bir takas. 20 buğday bir damızlık at; 30 buğday stat6 bir alp. At mevcut beygir lojistik kaydına eklenir ve öküz/inek ile aynı hazır ahır yerlerini paylaşır. Alp normal asker sınıfında adı olmayan gerçek köylü kabul edilir; hazır yatak kapasitesi tüm nüfustan büyük olmalıdır. Alp otomatik muhafız atanmaz; aynı atama akışıyla çalışır. Bu paket otomatik üreme veya yeni soy kaydı eklemez.

## Formulas
at_uygun = hazır ortak ahır kapasitesi > ortak hayvan sayısı. alp_uygun = hazır yatak kapasitesi > nüfus. Her ikisi için gerçek buğday>=ilgili bedel, son_takas_günü<gerçek gün ve terminal olmayan köy. Tam preflight sonrası Kaynaklar.harca, mevcut lojistik +1 veya KoyYonetimi.kabul ve Oturum._koy_esitle; iki kasa/RNG değişmez.

## Edge Cases
Ahır inşaatta, dolu ortak ahır, eksik buğday, yatak yok, bilinmeyen tür, terminal veya aynı gün ikinci seçim tüm durum korunarak reddedilir. Okuma saf; JSON aynı günlük makbuzu/ittifak/hayvan/köylüyü korur. Optional eski kayıt boş makbuzla açılır; bozuk gün alanı normalleştirilir. Diplomasi pazar kartında soyut mevcut bağlantıdır; ayrı NPC geliş kuyruğu veya Celep ziyaret şartı uydurulmaz. Eski Celep alım/satım sistemi ve fiyatı değişmez.

## Dependencies
ObaIttifaki + data/oba_ittifaki.json; optional Oturum alanı/save/load üç ince bağlantı. ObaIttifakPaneli mevcut GezginTuccarPazarAdaptoru'nda tek çağrı. KoyEkrani/KoyYonetimi/koy_halk_hareketi/CSV/CHR değişmez; kayıt sürümü3. Aynı CelepHamdullah kapasite ve lojistik beygir anahtarı, aynı normal asker verisi.

## Tuning Knobs
Bedeller20/30, alp stat6, gün başına tek değişim ve ilk başarılı takasla ittifak denge varsayımlarıdır. Bedeller/stat/metinler dış JSON. Yeni asset gerekmedi; mevcut BoxMesh beygir yer tutucusu ve normal köylü görünümü kullanılır. TUC02-BEYGIR envanter G satırı HAR-07 için de doğrulanır; üretim/indirme yok.

## Acceptance Criteria
Gerçek buğday azaltımı, ortak tür kapasitesi, inşaat/yatak/terminal atomik ret, iki kasa/RNG korunması, günlük iki tür ortak sınırı, ertesi gün/JSON/legacy/bozuk makbuz, gerçek asker kabul sayacı ve köy köprüsü. Aynı pazar iki gerçek düğmesi, yenileme/disabled, native/headless/ayna ve mevcut kayıt/nüfus/lojistik/kapı regresyonu.
