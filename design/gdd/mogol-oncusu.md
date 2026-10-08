# Moğol öncü tehdidi — HAR-02

## Overview
Gerçek oyun gününden kalan yaklaşma süresi ve aynı gece raporunda tek eşik uyarısı. Aynı çevre haritası Hisar bilgi alanına bağlanır. Savaş/ikinci gün motoru yoktur.

## Player Fantasy
Muhafız ufuktaki akın koluna hazırlık için kalan süreyi görür, öncünün sınırda göründüğünü gece haberinden öğrenir.

## Detailed Rules
Dış JSON denge varsayımı: varış30. gün, kalan5/2/0 gün uyarıları. Her gerçek tamamlanan gece r.gun+1 değerlendirilir; ilk iki uyarı yaklaşma, sıfır sınırda görülme haberidir. Sonraki geceler yeni aynı varış uyarısı üretmez. HAR10/12 savaş/heyet kuyruğu ayrı maddelerdir; burada otomatik baskın/hasar/terminal/haraç yoktur.

## Formulas
Kalan=max(0,varis_gunu−gerçek gün). Runtime görünüm gün üzerinden türetilir; ikinci zaman sayacı kaydedilmez. Optional mogol_oncusu {son_gece,uyarilar} yalnız tekrar makbuzu. JSON sayı eşikleri tam sayıya normalize edilir. Varış sonrası negatif gün yok.

## Edge Cases
Eski kayıt boş uyarı defteri; geçmişte atlanmış5/2 eşiği geriye dönük üretilmez, sıfır durumunda ilk geçerli gece tek sınır haberi olabilir. Bozuk/negatif/kesirli/sonsuz/bool uyarılar ve tekrarlar elenir. Mevcut terminal/sancak hükmü sonrası makbuz/olay yazılmaz. Kaydet/yükle tekrar zar üretmez. Para/köy statları/Clue/RNG değiştirilmez.

## Dependencies
MogolOncusu helper + data/mogol_oncusu.json. Oturum optional kayıt alanı/normalizer ve geceye tek çağrı. IflasYoneticisi mevcut typed olay metni; CevreHaritasi aynı Hisar metninde salt okunur çağrı. KoyEkrani ve koy_halk_hareketi değişmez; CSV/CHR kilitlerine girilmez. Kayıt sürümü3 korunur.

## Tuning Knobs
varis_gunu,uyari_kalan,ad ve insan uyarı metinleri. Kaynakta tarih verilmediğinden30 gün varsayımıdır; dünya gerçek zamanına tarih iddiası yok. Asset gerekmedi, G kontrol edildi; HAR01 kutu haritası ve mevcut metin raporu kullanılır, Moğol figürü üretilmedi.

## Acceptance Criteria
Gerçek25/28/30 geceler, ilk/tekrar/ertesi gün/JSON/legacy/bozuk kayıt/terminal; bütçe/stok/RNG değişmez. Tam Oturum gecesi typed sabah kartı5 gün ve aynı harita, sıfır varış/negative clamp; native/headless/ayna ve köy/gece/kayıt/harita regresyonu.
