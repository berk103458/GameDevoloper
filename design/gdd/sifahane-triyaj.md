# Şifahane yatak kapasitesi ve triyaj — KRI-13

## Overview
Şifahane yatakları dolunca açıkta bekleyen hastalar ve köyün morali çöker; tedavi sırası en ağır hastayı öne alır. Yatak = mevcut KRI-02 karantina kontenjanı, tedavi = mevcut `SaglikYoneticisi.tedavi`; ikinci yatak/tedavi sistemi yoktur.

## Player Fantasy
Salgın büyürken Şifahane'nin sınırı hissedilir: her yatak dolu, kapıda inleyen hastalar var. Oyuncu ikinci Şifahane, hekim ya da bina seviyesiyle yatak açmalı.

## Detailed Rules
- **Triyaj:** Gece tedavisi köylüleri sağlık artan sırayla (eşitlikte kimlik) dolaşır; sınırlı hekim kontenjanı en ağır hastaya gider. RNG yok.
- **Yatak:** Hekimli işleyen Şifahane başına mevcut karantina kontenjanı (taban 2, seviye ile en çok 4).
- **Çöküş:** Tedaviden sonra işleyen yatak > 0, boş yatak = 0 ve belirtisi açık, tedavi edilmemiş, karantinada olmayan köydeki hasta varsa: her bekleyen ek 3 sağlık, köydeki herkes 2 moral kaybeder; gece raporuna tek satır.
- Gizli kuluçka bekleyen sayılmaz (ifşa yok). Şifahane hiç yoksa bu madde ceza üretmez (mevcut hastalık kaybı geçerli). Ölüm denetimi mevcut sağlık döngüsündedir.

## Formulas
`yatak = Σ KarantinaYoneticisi.kapasite(b)`; çöküş koşulu `yatak > 0 ∧ bos = 0 ∧ |bekleyen| > 0`; `saglik' = max(0, saglik − 3)`; `moral' = max(0, moral − 2)`.

## Dependencies
`SaglikYoneticisi.tedavi` (sıra çağrısı), `KoyYonetimi.gece` (tek satır), `IflasYoneticisi.olay_metin`. Ayar: `data/koy/sifahane_triyaj.json`.

## Acceptance Criteria
Birim: `tests/unit/kvr/sifahane_triyaj_test.gd`; akış: `tests/oto/sifahane_triyaj_kontrol.gd`.
