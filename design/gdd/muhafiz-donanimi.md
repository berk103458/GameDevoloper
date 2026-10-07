# Muhafız donanımı — ANI-01

## Overview
Mevcut köy asker modellerinin elinde kılıç/mızrak ve gündüz kalkan, gece meşale görünür. Ekonomi ve kayıt değişmez.

## Player Fantasy
Oyuncu görevli muhafızları ve gece nöbetini sahnede ayırt eder.

## Detailed Rules
MuhafizMaasi.aday mevcut asker sınıflamasını kullanır. Çift kimlik kılıç, tek kimlik mızrak taşır. Gerçek RightHand/LeftHand kemikleri mevcut ElEsyasi bağlantısıyla izlenir. Gece sol elde kalkan yerine meşale görünür. En fazla dört gölgesiz dinamik ışık açılır; bütçe dışındaki meşale alevi görünmeye devam eder. Görev bitince önceki CHR eşyalarının görünürlüğü aynen geri gelir.

## Formulas
Işık enerji = taban × (1 + titreşim × sin(zaman × hız)). Silah seçimi kimlik modulo 2; oyun RNG kullanılmaz.

## Edge Cases
Eksik iskelet/el kemiğinde donanım kurulmaz; fallback'a sahte kemik eklenmez. Sahne yenilemesi donanımı çoğaltmaz. Silinen karakterle donanım da silinir. Görünür otuz model sınırı mevcut halk sistemine aittir.

## Dependencies
MuhafizDonanimi, KoyHalkHareketi'nin iki ince çağrısı, KarakterModel, ElEsyasi, MuhafizMaasi ve Dunya3B malzemeleri. İkinci animasyon/HUD/köy sistemi yoktur.

## Tuning Knobs
Gece fazları, ışık bütçesi/menzili/enerjisi/titreşimi ve tüm parça renk/ölçüleri data/muhafiz_donanimi.json içindedir. Basit prosedürel prop geometrisi kullanılır; savaş veya eşya ekonomisi eklenmez.

## Acceptance Criteria
El pozu takibi, iki silah, faz değişimi, ışık bütçesi, özgün görünürlüğün geri yüklenmesi ve eksik kemik birim testi. Gerçek Meshy askerleriyle sahne testi: tekrar yenileme, dört ışık, kayıt/RNG değişmezliği, görev bırakma. Native gece görüntüsü ve tam sanity/izole 20 gece geçer.
