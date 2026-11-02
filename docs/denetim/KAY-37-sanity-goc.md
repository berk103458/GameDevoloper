## 2 Kasım 2026 — KAY-37 tamamlandı (Kalfa)

KAY-03 kayit_gocu_soz_test.gd mevcut tests/unit keşfiyle zaten sanity paketine giriyordu. İkinci çağrı/runner eklenmedi; keşif satırına açıklama ve mevcut runner testine tam bir kez listelenme, doğru dosya, headless ve başarı işareti denetimi eklendi. Asset gerekmedi. kota görünmüyor.

Kanıt: python -B -m unittest discover -s tests/tools -p test_sanity_check.py: 12 test geçti. work/kay37_goc.log: gerçek KAY-03 fixtürü geçti. Tam sanity çalıştırılmadı. GDScript/sahne değişmedi; önceki temiz headless import geçerli. ds yolları yok, eşitlenmedi. Söz motoru beklemede, diğer ajan sahiplikleri korunur.

