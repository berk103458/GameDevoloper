# Üçlü divan hükmü — CAS-07

## Overview
Mevcut divanda gözlenmiş gerçek fiile tek zindan, sürgün veya infaz kararı uygulanır.

## Player Fantasy
Köy güvenliği ile halk morali arasında sonuçları görünen bir karar vermek.

## Detailed Rules
Tek hüküm makbuzu KoyYonetimi metadata'sında saklanır. Zindan kişi nüfusunu korur, iş/üretim/nöbet/vergi ve gizli suç uygunluğunu kaldırır; normal gıda, sağlık ve ölüm döngüsü sürer. Ev ve iş slotu boşalır. Sürgün mevcut surgun API'si ve husumet kaydıyla ayrılır; infaz sağlık0 ile gerçek nüfustan çıkarır. İkisi de adli kadroda kalıcı ayrılmıştır. Tek karar sonrası divan kapanır ve mevcut köy yenilenir.

## Formulas
Denge varsayımı: zindan kapasite2, asayiş riski−5/moral−2; sürgün−3/−3; infaz−8/−6. Asayiş0–100, moral mevcut sınırlarla. İkinci kasa, stok harcaması veya zar yok. Tutuklu işçi vergisi üretmez, gerçek gıda tüketir. Mevcut evsiz grubun soyut ısınma hesabı korunur; ikinci hücre ekonomisi eklenmez.

## Edge Cases
Gizli niyet gözlenen fiil sayılmaz; itiraf şart değildir. Ölmüş/ayrılmış/dış görevde kişi, bitmiş oyun, tekrar hüküm veya dolu hücre reddedilir. Dolu hücre sürgün/infaz seçeneğini kapatmaz. Kayıt türetilen zindanda bayrağını tek makbuzdan kurar, sahte bayrağı siler; eski kayıt boş makbuzla çalışır. Makbuz ayrılmış kişinin kararını korur.

## Dependencies
DivanHukmu ve DivanHukumPaneli mevcut divana ince çağrılar; mevcut YasRolleri, CirakEgitimi, GizliEgilimler, KuyuZehirleme ve vergi uygunluğu dar kapılar. KoyYonetimi optional save/load. KoyYonetimSahnesi tek DivanZindanGorseli çağrısı; koy_halk_hareketi mantığı değişmez. CAS08 intikam ve CAS10 yanlış suçlama ayrı açık maddeler.

## Tuning Knobs
data/divan_hukmu.json sosyal delta ve kapasite. Gerçek zindan kapısı asseti G CAS07-ZINDAN kaydında; kapıda tek BoxMesh/Label3D işareti, dışarıdaki mevcut tutuklu modeli gizlenir. Asset üretimi/indirme yok.

## Acceptance Criteria
Üç karar gerçek kişi/kadroya yalnız bir kez; stok/kasa/RNG koruması, kayıt dönüşü, kapasite/bozuk kayıt, gece tüketimi ve suç/iş reddi. Headless/native aynı üç düğme, kapanış/hız/kamera restore, tutuklu görünürlük ve kutu; ilgili regresyonlar ve iki ds kopyası.
