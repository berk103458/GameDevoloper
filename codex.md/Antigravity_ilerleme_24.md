# Antigravity İlerleme 24 — Denetim Listesi Düzeltmeleri (15 Kasım 2026)

Dal: `claude/festive-volta-li1sfm`
Kaynak: `docs/ANTIGRAVITY_DENETIM_LISTESI.md`

## Kalfa'ya Bırakılanlar (Alınmayacak / `[x]` Yapılmayacak)
- `ANL-EPI-01`: alınmadı — Kalfa
- `KAP-18`: alınmadı — Kalfa
- `YAP-03`: alınmadı — Kalfa
- `KVR-SES-01`: alınmadı — Kalfa

## İşlem Günlüğü

### Madde 1 — `OGR-33` (`TAM`)
- **Değişiklikler:**
  - `src/sistemler/nihai_son.gd`: `son(o, s)` en başına `o == null` güvenlik denetimi + `SonKilidi.kilitli_mi(o)` kontrolü yerleştirilerek ilk 6 gecede (`gun < 6`) beş nihai sonun tamamı kilitlendi.
  - `tests/unit/kvr/nihai_son_test.gd`: Beş nihai sonun her biri (`tekfur_haraccisi`, `ertugrul_obasi`, `beyin_uc_koyu`, `ahi_kasabasi`, `uc_tutundu`) ayrı ayrı `gun = 5` ve `son_metni()` dönüşüyle test edildi; `gun = 6` açılışı doğrulandı.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `OGR-33` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/kvr/nihai_son_test.gd` → `NIHAI SON: GEÇTİ` (`RC=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/ilk_saat_test.gd` → `ILK SAAT: GEÇTİ (0 hata)` (`RC=0`)
  - `Godot.exe --headless --path . res://tests/oto/nihai_son_kontrol.tscn` → `NIHAI SON UI: GEÇTİ` (`RC=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 2 — `OMR-17` (`TAM`)
- **Değişiklikler:**
  - `src/sistemler/oturum.gd`: `son_kaydi := SonKaydi.new()` ve `son_verisi_isle(son_verisi)` eklendi; `kaydet()` içinde `son_kaydi.kayda_yaz(veri)`, `kayittan()` içinde `o.son_kaydi.kayittan_oku(veri)` bağlandı (eski kayıtlarda `"son"` yoksa boş kalır).
  - `src/arayuz/ana.gd`: `_son_goster(son)` içinde `son != &"demo"` iken `son_metni` + `epilog` paketi `oturum.son_verisi_isle` ve `SonKaydi.kayda_son_ekle(oturum.kaydet(), kayit_paketi)` ile işlendi (`kayit.sil()` korundu).
  - `src/arayuz/koy_hud/hafiza_defteri_baglantisi.gd` & `src/sistemler/hafiza_defteri.gd`: `kaynak_derle` `oturum.son_kaydi.kayda_yaz(kaynak)` ekler; `_not_sayfasi` ve `son_kaydi_oku` ile kayıtlı son/epilog Bölüm 39 defterinden yeniden okunur.
  - `tests/unit/sistemler/son_kaydi_test.gd`: Gerçek `Oturum`, `HafizaDefteri` ve `Ana._son_goster` tarama sınamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `OMR-17` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/son_kaydi_test.gd` → `SON KAYDI (OMR-17): GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/hafiza_defteri_test.gd` → `HAFIZA DEFTERI (HFZ-01…32): GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/nihai_son_kontrol.tscn` → `NIHAI SON UI: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kvr/kayit_surum_kapisi_test.gd` → `KAYIT SÜRÜM KAPISI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 3A — `KOP-04` (`TAM`)
- **Değişiklikler:**
  - `src/soz/karar_donusu.gd`: `oku(ham)`, `kapi_kararini_yaz(o, gelen, karar, ek)` ve `spawn_ekle(o, sonuc)` eklendi; kapı kararları tek `Oturum.gecikmeli_kuyruk` içinde `sonraki_spawns` ile birleşip yinelenmeden tutuluyor ve vadesi gelen canlı spawnlar kapı sırasına ekleniyor.
  - `src/sistemler/oturum.gd`: `gecikmeli_kuyruk` alanı, `karar_ver` içinde `KararDonusu.kapi_kararini_yaz`, `gece_kuyrugu` içinde `KararDonusu.spawn_ekle`, `kaydet`/`kayittan` serileştirmesi eklendi.
  - `tests/unit/soz/karar_donusu_test.gd`: Gerçek `Oturum.karar_ver` -> `gecikmeli_kuyruk` -> `kaydet/kayittan` -> `gece_kuyrugu` tek-kuyruk ve spawn zinciri sınamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `KOP-04` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/soz/karar_donusu_test.gd` → `TEST PASS: karar_donusu_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kvr/kvr_test.gd` → `KVR TEST: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 3B — `DYL-08` (`TAM`)
- **Değişiklikler:**
  - `src/soz/karar_donusu.gd`: `AZAMI_GUNLUK_DONUS = 2`, `ilerlet(o, r)`, `defter_donusleri(o)`, `_karakter_durumu` ve `_etki_uygula` eklendi. Günde en çok 2 dönüş işlenir, fazlası aynı kuyrukta ertesi güne kalır; ölen/giden yalnız `haberci` kanalına düşer; `bar` etkisi bir kez uygulanır; tanıklı dönüş dedikoduya 1 satır düşer, tanıksız düşmez; `SAB-01` sabah defterine yazılmaz.
  - `src/sistemler/oturum.gd` & `src/arayuz/koy_hud/hafiza_defteri_baglantisi.gd`: `gece_sonu()` içinde `KararDonusu.ilerlet(self, r)` ve defterde `"dyl08"` bağlantısı kuruldu.
  - `tests/unit/soz/karar_donusu_test.gd`: Gerçek `Oturum.gece_sonu()` ile 2/gün sınırı, ölen kişinin haberci kanalı, ertesi gece sıfır bar tekrarı, tanıklı/tanıksız dedikodu ve 0 `SAB-01` yazımı test edildi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `DYL-08` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/soz/karar_donusu_test.gd` → `TEST PASS: karar_donusu_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/hafiza_defteri_test.gd` → `HAFIZA DEFTERI (HFZ-01…32): GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/kisi_hafizasi_test.gd` → `KISI HAFIZASI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 4 — `ZAR-04` (`TAM`)
- **Değişiklikler:**
  - `src/kapi/sorgu_zari.gd`: `degistiricili_sonuc(...)` ile `ZarDegistiricileri.hesapla` sonucu doğrudan `SorguZari.sonuc` eşiğine bağlandı.
  - `src/sistemler/chr_sorgusu.gd`: `zar_baglami`, `yaklasim_degistiricisi(secenek, ek_baglam)` ve `basari_olasiligi(degistirici)` / `secenek_sec(indeks, ek_baglam)` eklendi.
  - `src/arayuz/chr_kapi_adaptoru.gd` & `src/arayuz/chr_diyalog_paneli.gd`: `Oturum`'dan (`MuhafizTerazisi`, `GrupItibari`, asker durumu, bulunan kanıt) bağlam kurulup zar atılmadan önce her aktif değiştirici satırı ayrı satırda gösterildi.
  - `tests/unit/kapi/zar_degistirici_test.gd`: `SorguZari.degistiricili_sonuc`, `ChrSorgusu` ve `ChrDiyalogPaneli` ön-liste sınamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `ZAR-04` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/kapi/zar_degistirici_test.gd` → `ZAR DEGISTIRICI TEST: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kvr/chr_sorgu_test.gd` → `CHR SORGU: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kapi/zar_tur_test.gd` → `ZAR TUR TESTI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 5 — `DYL-06` (`TAM`)
- **Değişiklikler:**
  - `src/koy/koylu.gd`: `is_gucu: float = 1.0` eklendi ve optional kaydet/kayittan desteğine alındı.
  - `src/koy/koy_yonetimi.gd`: `_uret` günlük bina üretiminde `clampf(k.is_gucu, 0.0, 1.0)` çarpanı uygulandı, `gece()` sonunda `k.is_gucu = 1.0` sıfırlandı.
  - `src/sistemler/gelen.gd`: `diller: PackedStringArray = []` eklendi.
  - `src/soz/dil_engeli.gd`: `uygun_tercumanlar` `saglik > 0` korundu; `gelen_dilleri`, `oturum_ortak_dil_var_mi`, `oturum_dugme_sayisi`, `oturumda_tercuman_cagir` (`sabir -2`, `is_gucu = 0.5` idempotent, `es_id` eş denetimi) eklendi.
  - `src/arayuz/kapi_ekrani.gd`: `_sohbet_goster` içinde ortak dil yoksa max 2 başlangıç konusu ve koşullu `TercumanCagir` düğmesi, `_soru_sor` içinde `DilEngeli.satir_coz` ve `_karar_ver` içinde `dil_notlari` kaydı bağlandı.
  - `tests/unit/soz/dil_engeli_test.gd`: gerçek `Oturum`, `KoyYonetimi._uret` (%50 üretim düşüşü + gece sıfırlama), `sabir -2` ve `saglik == 0` sınamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `DYL-06` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/soz/dil_engeli_test.gd` → `DIL ENGELI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/denge/aclik_uretim_test.gd` → `AÇLIK ÜRETİM: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/ilk_saat_test.gd` → `ILK SAAT: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/chr_kapi_kontrol.tscn` → `CHR KAPI UI: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 6A — `ACL-03` (`TAM`)
- **Değişiklikler:**
  - `src/koy/aksam_sohbeti.gd`: `durum_al()` / `durum_yukle(v)` ile oturum kayıt serileştirme desteği eklendi.
  - `src/sistemler/oturum.gd`: `_init` içinde `AksamSohbeti.sifirla()`, `gunun_aksam_kararlari`, `aksam_sohbeti_gece`, `_es_bilgisi()`, `_meclis_gecesi_mi()`, `aksam_sohbeti_ekle`, `aksam_sohbeti_hazirla`, `aksam_sohbeti_uygula`, `aksam_sohbeti_atla` ve `kaydet`/`kayittan` eklendi.
  - `src/arayuz/koy_hud/aksam_sohbeti_paneli.gd`: Yeni `AksamSohbetiPaneli` (`ARY-04` `_kart_ac` çerçevesi, cevap düğmeleri + `AksamAtla` düğmesi, kalp/ses yok) eklendi.
  - `src/arayuz/koy_ekrani.gd`: `_geceye_gec()` içinde rapor öncesinde tek satır `AksamSohbetiPaneli.ac(...)` çağrısı ile `_geceye_gec_rapor()` bağlandı.
  - `tests/unit/koy/aksam_sohbeti_test.gd` & `tests/oto/aksam_sohbeti_kontrol.{gd,tscn}`: Gerçek `Oturum` + `KoyEkrani` akşam sohbeti UI tetik, atlama, tekrar=0 ve meclis=0 doğrulamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `ACL-03` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/koy/aksam_sohbeti_test.gd` → `TEST PASS: aksam_sohbeti_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/aksam_sohbeti_kontrol.tscn` → `AKSAM SOHBETI UI: GEÇTİ (0 hata)` (`RC=0`)
  - `Godot.exe --headless --path . res://tests/oto/gece_gecis_kontrol.tscn` → `GECE GEÇİŞİ: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor

### Madde 6B — `DYL-07` (`TAM`)
- **Değişiklikler:**
  - `src/koy/aksam_sohbeti.gd`: `karardan_ekle(...)` (bölünen aile, rüşvet, çocuklu aile reddi, hasta kabulü, yakalanan/tutulan yalan, kaçak asker/yetim kabulü ağırlık tablosuna eşlendi), `konu_sec` `es_gecmis` anı cümlesi ve `gundelik_satir()` eklendi.
  - `src/sistemler/oturum.gd`: `karar_ver` -> `AksamSohbeti.karardan_ekle`; `aksam_sohbeti_hazirla` -> `KisiHafizasi.es_hafizasi_oku(kadro, &"es")`; `aksam_sohbeti_uygula` -> `KisiHafizasi.es_hafizasi_yaz(kadro, &"es", ...)`, `terazi` (`kabul_etti` → `yonetim.adalet +1`, `susmak` → moral 0 + `"kacti"`) ve ertesi gün `es_aksam_ipucu` eklendi.
  - `tests/unit/koy/aksam_konu_test.gd`: Gerçek `Oturum.karar_ver` -> `KisiHafizasi.es` -> terazi/adalet -> ertesi gece geçmiş anma sınamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `DYL-07` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/koy/aksam_konu_test.gd` → `TEST PASS: aksam_konu_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/koy/aksam_sohbeti_test.gd` → `TEST PASS: aksam_sohbeti_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/kisi_hafizasi_test.gd` → `KISI HAFIZASI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/aksam_sohbeti_kontrol.tscn` → `AKSAM SOHBETI UI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor
