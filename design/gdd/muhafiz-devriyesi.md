# Muhafız devriyesi — ANI-02

## Overview
Mevcut halk hareket kuyruğunda kapı, hazır kışla ve işlevli sur kuleleri arasında görsel nöbet döngüsü.

## Player Fantasy
Oyuncu muhafızların köyün savunma hattını dolaştığını ve gece meşaleli nöbeti sürdürdüğünü görür.

## Detailed Rules
Mevcut MuhafizMaasi.aday görev sınıflaması kullanılır. Hedef sırası kapı, hazır kışlalar, dört köşe kulesidir. Asker kimliği başlangıç sırasını dağıtır. Varıştan sonra yapılandırılan bekleme süresi dolunca sonraki hedefe mevcut A* ve kare başına rota bütçesiyle yürünür. Gece ve akşam da devriye sürer; görev bırakınca olağan halk rutini geri gelir. Her sur kulesinin ahşap platformu mevcut yapı köküne eklenir; nöbetçi yerde kule önüne gider, platforma çıkma animasyonu yoktur.

## Formulas
Sonraki sıra = (geçerli sıra + 1) modulo durak sayısı. Bekleme gerçek delta toplamıdır, oyun gecesi hesaplaşması değildir. Kalıcı yorgunluk/maaş hesabı mevcut modelde kalır.

## Edge Cases
Sur yoksa veya tamamen yanmışsa kule durakları/görselleri yoktur. İnşa halindeki kışla seçilmez. Erişilemeyen hedefler mevcut A* ile atlanır; tüm hedefler kopuksa asker yerinde bekler. Yapı/atama yenilemesi ve faz değişimi hedefi tekrar planlar. Kalıcı kayıt/RNG değiştirilmez.

## Dependencies
MuhafizDevriyesi, KoyHalkHareketi, KoyRotasi, MuhafizMaasi. KoyYonetimSahnesi yalnız kule dekoratörü çağrısıyla genişler. İkinci hareket/ekonomi/HUD yoktur; ANI-01 meşaleleri aynen çalışır.

## Tuning Knobs
data/muhafiz_devriyesi.json: durak süresi, kule yükseklik/genişlik, direk/platform/korkuluk ölçüsü ve renk. Mevcut yürüyüş hızı ve rota bütçesi koy_hareket.json'dan gelir.

## Acceptance Criteria
Durak kapsamı, hazır/yanmış filtreleri, kopuk alan ve salt okunur plan birimi. Gerçek sahnede animasyonlu yürüyüş, gece üç tür durağı tam dolaşma, dört kule ve görev bırakma. Kayıt/RNG aynı; rota/maaş/donanım regresyonları, açılış/API, native görüntü ve izole 20 gece geçer.
