# ES-GECM-01: Kod ve Sistem Notu

## Kod Gerekir mi?
- **HAYIR / ÇOK AZ.**
- Diyalog ağacı doğrudan Parley (`data/parley/koy/koylu_muhabbet_es.ds`) veya akşam sohbetleri veri yapısına (`data/sohbetler/aksam_konulari.json`) bağlanabilir.
- Eğer eşin ıhlamur vermesi `nobet_yorgunlugu` değerini düşürecekse:
  - Mevcut `EsIliskisiAction` (`src/diyalog/actions/es_iliskisi_action.gd`) veya `Hane` sistemi (`src/koy/hane.gd`) zaten `Oturum` sinyalleriyle dinlenmektedir.
  - İnce adaptör çağrısı: `Oturum.nobet_yorgunlugu = maxi(0, Oturum.nobet_yorgunlugu - 1)`.
- **Kimin İşi?:** Kod tarafı gerekirse Cursor / Kalfa. Diyalog ve metin tarafı Antigravity.
