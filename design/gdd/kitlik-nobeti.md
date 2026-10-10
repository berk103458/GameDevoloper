# Kıtlıkta kışla nöbetçisi ambara — KRI-14

## Overview
Erzak tükenince etkin nöbetçiler kışladan ambar kapısına yönelir. KRI-06 kıtlık isyanının açık yüzeyine (`KitlikIsyani.durum().kitlik_gece_sayisi` ve o gecenin `kitlik_isyani` olayı) bağlanır; ikinci kıtlık/yağma motoru değildir.

## Player Fantasy
Ambar boşalınca muhafızlar halkın karşısına dikilir: malı korurlar ama aç halkla çatışmanın bedeli moraldir.

## Detailed Rules
- **İlk kıtlık gecesi** (`kitlik_gece_sayisi == 1`, tetiklenmemiş) ve en az bir etkin nöbetçi varsa: gece raporunda uyarı — nöbetçiler ambara yöneldi, erzak gelmezse yarın arbede.
- **Yağma gecesi** (KRI-06 tetik) ve nöbetçi varsa **arbede**: nöbetçi başına %25 (tavan %100) oranında yağmalanan mal ambara geri alınır (ambar kapasitesi sınırında); köydeki herkes −3, nöbetçiler ek −5 moral. Tek rapor satırı.
- Etkin nöbetçi koşulu `KoyYonetimi.etkin_muhafiz_sayisi` ile aynıdır. Nöbetçi yoksa bu madde sessizdir; KRI-06 davranışı değişmez. Erzak varken etki yok.
- RNG yok; yeni kayıt alanı yok (KRI-06 son gece makbuzu tekrarları önler).

## Formulas
`oran = min(1, nobetci × 0.25)`; `geri[tur] = floor(yagma[tur] × oran)`; `moral_halk −= 3`, `moral_nobetci −= 3 + 5`.

## Dependencies
`KoyYonetimi.gece` (tek satır, `_isyan` sonrası), `IflasYoneticisi.olay_metin`. Ayar: `data/koy/kitlik_nobeti.json`.

## Acceptance Criteria
Birim: `tests/unit/kvr/kitlik_nobeti_test.gd`; akış: `tests/oto/kitlik_nobeti_kontrol.gd`.
