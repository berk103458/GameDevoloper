## 2 Kasım 2026 — YAZ-89 tamamlandı (Kalfa)

Söz dosyası/hafıza ve yeni optional alanları olmayan eski v2/v3 kayıt gerçek Oturum yolundan açıldı. Köy/gün/RNG korundu; kaynak girdiye veya yeniden kayda yeni Söz dosyası referansı yazılmadı. Mevcut göç yolu güvenilir Callable adımlarını kullanır, kayıttan Söz kaynak yolu okuyup dosya açmaz. Bekleyen ana Söz motoru kurulmadı; bu eski kayıt uyumu regresyonudur. Üretim kodu değişmedi. Asset gerekmedi. kota görünmüyor.

Kanıt: work/yaz89_legacy_son.log ve yaz89_sys14.log geçti. Test yolu tests/unit/sistemler/soz_dosyasi_opsiyonel_test.gd seçildi: kvr/kayit_gocu_test.gd ile aynı dosya adı/runner etiketi çakışması önlendi; mevcut test korunur. Son recovery import yaz89_import_son.log; ilk cache MD5 logu korunur. Tam sanity/görünür pencere yok. ds yolları yok, eşitlenmedi; diğer ajan sahiplikleri korunur.

