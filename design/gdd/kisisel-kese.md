# Kişisel kese — EKO-11

## Overview
Köy HUD'unda muhafızın kişisel parası kamu akçesinden ayrı görünür.
## Player Fantasy
Muhafız kamu hazinesiyle kendi kesesini ayrı takip eder.
## Detailed Rules
Gösterge yalnız `muhafiz_akce` okur; rüşvet kararı sonrası mevcut köy sinyaliyle güncellenir. Kamu kasası ve ambarına yazmaz. Kişisel eşyaların toplam adedi açıklamada görünür. Oda yüzeyi bu bileşeni ileride tekrar kullanabilir; ODA maddeleri henüz kapanmaz.
## Formulas
Gösterilen akçe = oturum.muhafiz_akce; eşya adedi = Σ max(0, kayıt.adet).
## Edge Cases
Boş kese 0; büyük bakiyede etiket asgari genişliği korunur. Kayıt yükleme bakiyeyi mevcut çift kasa sözleşmesinden alır. Tekrar çizim para üretmez.
## Dependencies
Oturum çift kasa/kayıt; Hud; KoyNufusu.degisti; KeseGostergesi.
## Tuning Knobs
Ekonomi dengesi eklenmez; font/renk mevcut Tema ve KaynakGostergesi paletini kullanır.
## Acceptance Criteria
Gerçek rüşvet sonrası kişisel bakiye güncellenir, kamu bakiye değişmez; kayıt geri dönüşü ve salt okunur çizim doğrulanır. Native HUD ekran görüntüsünde büyük bakiye okunur.
