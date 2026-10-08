# Celep Hamdullah — TUC-02

## Overview
Mevcut pazar ve CekiLojistigi hayvan kaydı dört türü destekler. İkinci hayvan ekonomisi veya kaynak paneli yoktur.

## Player Fantasy
Oyuncu Celep geldiğinde ahırını çeki hayvanlarıyla, ağılını koçlarla doldurur.

## Detailed Rules
Celep'in iki günlük konaklamasında kamu kasasından öküz 40, inek 35, beygir 50, koç 25 akçe karşılığında alınır. İlk üç tür aynı hazır ahır kapasitesini paylaşır (ahır başına iki). Hazır ağılın mevcut dört başlangıç koyununa ek iki koç yeri vardır. Koç çeki bonusu vermez. Beygir mevcut hayvanlı seferin 9 yük / 0.5 gece kuralını kullanır; üretimi çoğaltmaz. Koç üretim/üreme bonusu bu adımda eklenmez. Mevcut Celep takvimi tek zaman kaynağıdır.

## Formulas
Alınabilir = tür tanımlı AND Celep pazarda AND aynı barınak grubunda sayı < tamamlanmış kapasite AND kamu kasası ≥ fiyat. Başarıda kasa fiyat kadar azalır ve mevcut lojistik.hayvanlar[tür] bir artar. Çeki sayısı yalnız ceki:true türlerin toplamıdır.

## Edge Cases
Dolu/bitmemiş barınak, yetersiz kasa veya başka uzman alımı engeller; başarısız işlem kayıt/RNG değiştirmez. Eski kayıt beygir/koç alanını sıfır varsayar. Barınak yıkılınca hayvan kaydı silinmez; yeni alım kapasite düzelene kadar kapalıdır. Fazla hayvan görsel olarak çoğaltılmaz. Eski öküz/inek alım API'si ve çeki kaydı korunur.

## Dependencies
CelepHamdullah saf uzman/barınak kuralları; CekiLojistigi.alinabilir ve sayi ince delegasyon; CekiHayvaniPaneli aynı özet altında CelepPazarAdaptoru çağırır. KoyYonetimSahnesi mevcut bina düğümünde tek CelepHayvanGorseli.kur çağrısı. Mevcut ağıl sürüsü ve üretim yolu korunur.

## Tuning Knobs
data/celep_hamdullah.json uzman kimliği, barınak/çeki türü, ek ağıl yeri, merkezi görsel bütçesi/renk/boyut; data/koy/ceki_lojistigi.json fiyatlar. CelepHayvanGorseli._yer_tutucu tek model değişim noktası: düz renk BoxMesh. Gerçek tür modelleri envanter G'ye yazılmıştır; asset üretilmedi/indirilmedi.

## Acceptance Criteria
İki konaklama günü, başka uzman, kapasite/kasa kapıları, çeki ile koç ayrımı, eski/yeni kayıt roundtrip. Dört gerçek düğme kamu kasasından alır; barınakta dört tür kutusu görünür. Native pazar, ayna import/UI, mevcut lojistik ve 20 gece regresyonu geçer.
