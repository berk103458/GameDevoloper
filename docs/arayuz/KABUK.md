# Kabuk — tema seçilmeden ortak ölçü

`src/arayuz/kabuk.gd` renk, boşluk ve puntoyu tek yerde tutar. `Tema.GOVDE_PX`, `KUCUK_PX` ve `BASLIK_PX` bu sayılara takma addır. `Tema.koy_paneli()` `Kabuk.panel()` döndürür.

Aday paketlerden biri burada seçilmez. Sabah seçilen tema `Kabuk.panel()` ve `Kabuk.zemin()` içinden bütün çağrılara gider. Ekran betikleri ikinci palet açmaz.

Çizim renkleri (menü altını, mühür, heybe derisi, eşya simgesi, harman ve okçuluk halkası, tansiyon üç rengi, HUD uyarı rengi) kabuk zemini değildir. Tarama onları istisna sayar. Liste `tests/tools/test_kabuk.py` içindedir.
