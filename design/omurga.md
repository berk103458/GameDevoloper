# Omurga — iki perde ve beş son

OMR-01. Oyunun ana iskeleti tek belgede. Her perdenin **sorusu**, **baskısı** ve **kapanış koşulu** kodda nerede duruyorsa oraya bağlanır. Bu belge yeni koşul eklemez; kodda olmayan bir koşul burada yazılmaz. Referanslar `dosya::ad` biçimindedir ve `tests/tools/test_omurga.py` her birinin kodda gerçekten bulunduğunu tarar.

Sayılar belgeye yazılmaz, dosyada okunur: bu belge yalnız alanın adını verir. Denge değişince belge değişmez.

## Perde 1 — Kapı açılır, köy kurulur

- **Soru:** Bu uç köyünü kimlerle kuracaksın? Kapıya gelen her kişi bir karar; kabul edilen köye yerleşir, geri çevrilen yolda kalır.
- **Perde göstergesi:** `src/sistemler/oturum.gd::perde` — `yonetim.agalik` kapalıyken 1.
- **Baskı:**
  - Her gece kapıya gelen sayısı `data/ayarlar/oyun.tres::gece_basina_gelen` (perde 1 dalı: `src/sistemler/oturum.gd::gece_basina_gelen`).
  - Erzak ve tüketim, bar dengesi, vergi (`data/ayarlar/oyun.tres::vergi_araligi`), ordu ve tüccar baskı geceleri (`data/ayarlar/oyun.tres::ordu_baski_gecesi`, `data/ayarlar/oyun.tres::tuccar_baski_gecesi`).
- **Kapanış (perde 2'ye geçiş):** nüfus `src/veri/koy_ayarlari.gd::agalik_nufus` değerine ulaşınca `src/koy/koy_yonetimi.gd::_asamalar` ağalığı açar (`koy.olay.agalik`). Geçiş gecesinde `src/koy/perde_gecisi.gd::isaretle` 2. perdenin başlangıç gününü yazar (`perde2_baslangic`). Gün sayacı sıfırlanmaz.
- **Bu perdede biten kayıp sonları:**
  - Halk kırıldı: emniyet açıldıktan sonra (`src/koy/koy_yonetimi.gd::emniyet_acik`) nüfus `src/veri/koy_ayarlari.gd::kirilma_nufus` altına düşerse `src/koy/koy_yonetimi.gd::SON_HALK` (`src/koy/koy_yonetimi.gd::_son_denetimi`).
  - İsyan: huzur eşiğin altında kaldıkça her gece bir köylü kaçar; sayaç bitince `src/koy/koy_yonetimi.gd::SON_ISYAN`.
  - Sancak teftişi: yozlaşmış muhafız bulunursa `src/sistemler/sancak_teftisi.gd::SON_AZIL` ya da eşik `data/sancak_teftisi.json::idam_esigi` üstünde `src/sistemler/sancak_teftisi.gd::SON_IDAM`.

## Perde 2 — Ağalık ve dış baskı

- **Soru:** Köy oturdu; şimdi onu Tekfur'a, sancağa ve kendi vicdanına karşı ayakta tutabilecek misin?
- **Perde göstergesi:** `src/sistemler/oturum.gd::perde` — `yonetim.agalik` açıkken 2.
- **Baskı:**
  - Gece başına gelen azalır: `data/ayarlar/oyun.tres::perde2_gece_basina_gelen`.
  - Tekfur haracı her `src/veri/koy_ayarlari.gd::harac_araligi` günde gelir (`src/koy/koy_yonetimi.gd::harac_bekliyor`); cevapsız haraç reddedilmiş sayılır (`src/koy/koy_yonetimi.gd::harac_reddet`) ve Tekfur baskınıyla döner.
  - Baskında `src/koy/koy_yonetimi.gd::tekfur_gucu` savunma gücünü aşarsa köy düşer.
- **Kapanış:** iki yoldan biri.
  - Dayanma: 2. perdede `data/ayarlar/oyun.tres::perde2_hedef_gece` gece dolunca `src/koy/perde_gecisi.gd::denetle` sonu `src/koy/koy_yonetimi.gd::SON_ZAFER` yapar.
  - Savuşturma: `src/veri/koy_ayarlari.gd::zafer_bask_sayisi` baskın savuşturulunca `src/koy/koy_yonetimi.gd::_asamalar` yine `src/koy/koy_yonetimi.gd::SON_ZAFER` yazar.
- **Bu perdede biten kayıp sonu:** baskın kaybedilirse `src/koy/koy_yonetimi.gd::SON_TEKFUR`. Perde 1'in kayıp sonları burada da geçerlidir.

## Kapanış — Beş son

Yalnız zafer beş sondan birine ayrılır; kayıp sonları kendi başlık ve metinleriyle kalır. Seçim `src/sistemler/nihai_son.gd::son` içinde öncelik sırasıyladır, RNG yoktur; eşikler `data/nihai_sonlar.json::esik` içindedir. Göstergeler `src/sistemler/nihai_son.gd::gostergeler` (huzur, adalet, refah, güvenlik, nüfus, yozlaşma).

1. **Tekfur Haraççısı** (`data/nihai_sonlar.json::tekfur_haraccisi`): yozlaşma `data/nihai_sonlar.json::yozlasma` eşiğinde ya da üstünde, veya köy ağalıkta hiç baskı görmeden ve hiç savuşturmadan haraç aralığı kadar gece geçirdiyse (`haraca_boyun`).
2. **Ertuğrul Obası** (`data/nihai_sonlar.json::ertugrul_obasi`): oba ile ittifak kurulduysa (`src/sistemler/oba_ittifaki.gd::muttefik`).
3. **Beyin Uç Köyü** (`data/nihai_sonlar.json::beyin_uc_koyu`): sancağa levent gönderildiyse, ya da güvenlik `data/nihai_sonlar.json::guvenlik_bey` ve etkin muhafız sayısı `data/nihai_sonlar.json::muhafiz_bey` eşiğindeyse.
4. **Ahi Kasabası** (`data/nihai_sonlar.json::ahi_kasabasi`): refah `data/nihai_sonlar.json::refah_ahi` ve adalet `data/nihai_sonlar.json::adalet_ahi` eşiğindeyse.
5. **Uç Tutundu** (`data/nihai_sonlar.json::uc_tutundu`): yukarıdakilerin hiçbiri değilse.

Her sona, kayıp sonları dahil, `src/sistemler/nihai_son.gd::epilog` altı göstergenin değerini ve kademesini (`data/nihai_sonlar.json::yuksek`, `data/nihai_sonlar.json::dusuk`) ekler. Son ekranı `src/sistemler/nihai_son.gd::son_metni` adaptörüyle mevcut başlık/metin sözleşmesini korur.

## Sınırlar

- **Eski kayıtta geçiş (OMR-12):** 2. perdenin başlangıç günü kayıtta yoksa ya da bozuksa `src/koy/perde_gecisi.gd::yukle` onu boşaltır ve geçiş sonraki gece yeniden işaretlenir; oyun anında bitmez. Omurga bu davranışa dokunmaz. Mevcut test: `tests/unit/kvr/perde_gecisi_test.gd` (eski kayıt satırları).
- **Açılış sabittir (OMR-46):** açılış ACL-01/ACL-04'tür; omurganın dallanması oyuncunun kararlarındadır. Omurga verisi açılışı okumaz.
- **Üçüncü perde yoktur (OMR-51):** 2. perde hedef gecesi dolunca oyun biter. Omurga üçüncü perde, ikinci harita ya da yeni son açmaz; `data/nihai_sonlar.json::sonlar` beş sondur, kayıp sonları sabittir.
