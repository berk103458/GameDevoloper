# Adsız diyalog sırası kayıt kalıcılığı — SYS-16

## Overview
`data/diyalog/diyalog_01_20.json` hazır adsız diyalogları oyun başına bir kez, sırayla gelir. Sıra (`Oturum._gemini_sira`) mevcut `diyalog_sira` alanıyla `user://kayit.json`'a (Ana'nın `KayitDeposu`/`GuvenliKayit` yolu) yazılır; "Devam" kaldığı diyalogdan sürer. İkinci alan veya kayıt dosyası yoktur.

## Detailed Rules
- Kayıt köye geçişte (`Ana._koye_git`) yazılır; "Devam" `Oturum.kayittan` ile sırayı geri kurar.
- Okuma `src/sistemler/diyalog_sirasi.gd` ile doğrulanır: 0…100000 tam sayı (veya tam sayı metni); negatif, kesirli, sonsuz, metin/null ve legacy (alan yok) değer 0'a döner. Negatif indeks GDScript dizisinde sondan okuma yapacağından reddedilir.
- Liste bittiyse kayıttan sonra da yeniden başlamaz; adsız gelenler sınıf şablonlarına düşer.

## Acceptance Criteria
Birim: `tests/unit/kvr/diyalog_sirasi_test.gd`; akış: `tests/oto/diyalog_sirasi_kontrol.gd` (gerçek köye geçiş kaydı → yeni Ana "Devam").
