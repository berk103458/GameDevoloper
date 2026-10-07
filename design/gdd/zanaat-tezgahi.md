# Zanaat tezgâh hareketi — ANI-08

## Overview
Mevcut demirhane/atölye/çivi ocağı/tamir sundurması ve fırın çalışanları çekiç veya kürek döngüsüne geçer.

## Player Fantasy
Gerçek üretim koşulları uygunken köyün zanaat işlerinin görülebilmesi.

## Detailed Rules
Yalnız gündüz hazır binada fiziksel çalışan, iş/kaza/grev engeli yoksa adaydır. Gerçek seçili reçete girdisi ve boş depo olmadan çalışmaz. Mevcut A* tezgâh ön hücresini kullanır; erişilemezse vurma/pisirme açılmaz. Hareket varınca mevcut DurusDuzeltici içinde dov/pisir dalıyla başlar; gerçek sağ el kemiği alet soketidir. Dinlenme/faz/görev değişiminde özgün CHR el görünürlüğü geri gelir. Fırın yeni enum eklemez: mevcut Esnaf/genel çalışan atanabilirliği korunur.

## Formulas
Çekiç salınımı = sin(zaman × vurus_hizi) × vurus_genlik. Kürek salınımı = sin(zaman × kurek_hizi) × kurek_genlik. İş/dinlenme süreleri mevcut koy_hareket.json kullanır. Görsel döngü reçete girdisini tüketmez, stok veya beceri ilerletmez.

## Edge Cases
Danışman yaşlı ağır işte alet sallamaz. Eksik gerçek el kemiğinde soket uydurulmaz. Kapalı ön cephe duvar içinden yürütülmez. Tür değişiminde aynı kişi eski çekici taşımaz. Gece ve dinlenmede alet temizlenir; girdisiz fırın durur. Ortak ekonomi ve UZM-01…05 sınıflandırma/uyum/eğitim/kaza korunur.

## Dependencies
ZanaatTezgahi, KoyHalkHareketi/KoyRotasi, DurusDuzeltici/ElEsyasi, mevcut üretim reçeteleri, YasRolleri ve kaza/grev/kan davası engelleri.

## Tuning Knobs
data/zanaat_tezgahi.json: bina türü/hareket eşlemesi, düz kutu örs/fırın/alete ait boyut ve renkler, kol hedefleri ve döngü hızı/genliği. Yer tutucular tek kur/_kur noktasından değişir. Asset üretimi/indirme yapılmaz, eksikler docs/EKSIK_ASSET_ENVANTERI.md içindedir.

## Acceptance Criteria
Gerçek reçete, girdisizlik, faz, danışman/inşaat ve kayıt/RNG birimi. Gerçek iki bina UI: el soketi, varınca döngü, dinlenme/gece temizliği, tür değişimi, unsuz fırın. Native kutu tezgâh ve hareket, kaynak/ayna import, önceki rutin/açılış ve 20 gece duman testi.
