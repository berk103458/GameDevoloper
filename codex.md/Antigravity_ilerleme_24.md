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


### Madde 7 — `HAN-01` (`TAM`)
- **Değişiklikler:**
  - `src/koy/hane.gd`: `ev_id`, `uyeler`, `ocak_durumu`, `son_sofra_gunu` alanları eklendi ve serileştirildi; `sofra_kur(gun)` `son_sofra_gunu` güncelliyor; `acilis_hanesinden_turet(y, mevcut, acilis_hanesi)` eski kayıtta `"hane"` yokken `ACL-01` kuruluşundan hane ve eş bilgisini türetiyor.
  - `src/koy/koy_yonetimi.gd`: `var hane := Hane.new()` eklendi; `kaydet()` içine `"hane": hane.kayit_verisi_al()` yazıldı; `kayittan()` `"hane"` varsa `kayit_verisi_yukle`, yoksa `Hane.acilis_hanesinden_turet` çağırıyor.
  - `src/sistemler/acilis_senaryosu.gd`: `kur` ve `yukle` akışları `o.yonetim.hane` alanını gerçek kuruluş verisiyle senkronize ediyor.
  - `tests/unit/koy/hane_test.gd`: Gerçek `Oturum` + `AcilisSenaryosu.kur` + `KoyYonetimi.kaydet/kayittan` + `"hane"` silinmiş eski kayıttan türetme sınamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `HAN-01` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/koy/hane_test.gd` → `PASS: HAN-01..52 Muhafiz Hanesi testi basariyla tamamlandi.` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/acilis_senaryosu_test.gd` → `AÇILIŞ SENARYOSU: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kayit/soz_kayit_test.gd` → `SÖZ KAYDI: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor


### Madde 8 — `KOP-03` (`TAM`)
- **Değişiklikler:**
  - `src/kapi/hastalik_teshis_adaptoru.gd`: `bakis_verisi_kur(g)` ve `bolge_bak(e, g, bolge, ek_baglam)` eklendi; `eylem(...)` içindeki `HastalikIncele`, `BakisYuz`, `BakisEller` ve `chr_bagla(...)` içindeki `GorselIz`, `ChrBakisYuz`, `ChrBakisEller` doğrudan gerçek `Bakis.bak(...)` çağrısıyla `"yuz"` / `"eller"` bakış satırlarını üretip kapı kayıt defterine ve `IpucuYoneticisi`'ne bağlıyor (ayrı teşhis düğmesi 0, karanlıkta 0 belirti/ipucu).
  - `tests/unit/kapi/kop03_bakis_hastalik_test.gd`: `HastalikTeshisAdaptoru.bolge_bak` & `eylem` (`BakisYuz`/`BakisEller`, karanlıkta 0 ipucu, `BAKIS_META` gerçek `Bakis` nesnesi) doğrulaması eklendi.
  - `tests/unit/kvr/hastalik_teshis_test.gd` & `tests/oto/hastalik_teshis_kontrol.gd`: `YAP-01` (`sifahane` K2 ön koşulu) uyumu ve gerçek `KapiEkrani` UI `BakisYuz`/`BakisEller` doğrulaması eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `KOP-03` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/kapi/kop03_bakis_hastalik_test.gd` → `KOP03 BAKIS HASTALIK: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/bakis_test.gd` → `TEST PASS: bakis_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kvr/hastalik_teshis_test.gd` → `KAPI HASTALIK TEŞHİSİ: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/hastalik_teshis_kontrol.tscn` → `KAPI HASTALIK UI: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor


### Madde 9 — `DIY-14` (`TAM`)
- **Değişiklikler:**
  - `src/sistemler/oturum.gd`: `karar_ver` içinde adlı ziyaretçilerde `KisiHafizasi.kaydet_olay` ile `karar_gecmisi` kalıcı hafızaya yazıldı ve dönüş sözlüğüne `hafiza_yazildi` / `dedikodu_yazildi` eklendi.
  - `src/arayuz/kapi_ekrani.gd`: `HATIRLANMA_NOTU` bağlandı; `_hatirlanma_notu_al()` ile ayar senkronlu tek `HatirlanmaNotu` düğümü ekrana eklendi, `_karar_ver` sonunda tek satır `hatirlanma_notunu_bildir(...)` ile hafıza/dedikodu yazıldığında 2 sn `"Bu hatırlanacak"` bildirimi açılıyor.
  - `tests/oto/hatirlanma_notu_kontrol.{gd,tscn}`: Gerçek `Oturum` + `KapiEkrani._karar_ver` üzerinden `HatirlanmaNotu` görünürlüğü, tıklama ile kapanış ve ayar kapalıyken gizli kalma doğrulamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `DIY-14` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/kapi/hatirlanma_notu_test.gd` → `HATIRLANMA NOTU: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/hatirlanma_notu_kontrol.tscn` → `HATIRLANMA NOTU UI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/kisi_hafizasi_test.gd` → `KISI HAFIZASI: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/chr_kapi_kontrol.tscn` → `CHR KAPI UI: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor



### Madde 10 — `SOY-01` (`TAM`)
- **Değişiklikler:**
  - `src/sistemler/soylenti_agi.gd`: `dogru_kayit_mi(olay_id)` ve `dogru_kayitlar()` eklendi (`Dedikodu` imzaları korundu).
  - `src/sistemler/dis_hat_kapisi.gd`: `OMR-39` üzerinde `soylenti_dogru_haber_var_mi(o, olay_id)` eklendi (`dogru == false` sahte haberler eleniyor).
  - `tests/unit/kayit/soz_kayit_test.gd`: `_soy01_soylenti_kaynak_ve_dogruluk` ile `Oturum.kaydet/kayittan` gidiş-dönüşü, eski kayıtta varsayılan (`kaynak == ""`, `dogru == true`) ve `dogru == false` reddi doğrulandı.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `SOY-01` → `TAM`.
- **Hedefli test çıktıları (son satırlar):**
  - `Godot.exe --headless --path . -s res://tests/unit/kayit/soz_kayit_test.gd` → `SÖZ KAYDI: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/kvr/soylenti_agi_test.gd` → `PASS: SOY-01..50 Soylenti Agi kapanis testi basariyla gecti.` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/soylenti_koprusu_test.gd` → `SÖYLENTİ KÖPRÜSÜ: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/dedikodu_test.gd` → `DEDIKODU: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor



### Madde 11 — `DYL-01` (`TAM`)
- **Değişiklikler:**
  - `src/soz/celiski.gd`: Yeni `Celiski` çekirdeği (`{a, b, dal, guc}` çiftleri, `CeliskiYuzlesme` geri uyumu, tek kayıtta `"Göster"` kilidi, kendisiyle eşleşme engeli, aynı yanlış çift engeli, yanlışta `tansiyon +1`, `guven -2`, `sabir -1`, 3 yanlıştan sonra ziyaret boyu `"Göster"` kapanışı, `yardim_acik_mi` ile ilk 3 gün kuralı).
  - `src/arayuz/kapi/beyan_defteri_paneli.gd`: Yeni `BeyanDefteriPaneli` (kaynak etiketli kayıt satırları, çözülen çiftlerin işaretlenip kilitlenmesi, 2 kayıt seçerek `"Göster"` tetiği).
  - `src/soz/soz_motoru.gd` & `src/soz/celiski_yuzlesme.gd`: `celiskiler` yükleme, `celiski()` ve `celiski_yuzlestir(...)` delegasyonu, `celisir_ile` desteği.
  - `src/sistemler/chr_sorgusu.gd`, `src/arayuz/chr_diyalog_paneli.gd`, `src/arayuz/chr_kapi_adaptoru.gd`, `src/arayuz/kapi_ekrani.gd`: CHR düğüm repliklerinin `BeyanDefteri` & `Celiski` kaydına yazılması, `gerekli_ipuclari` hedeflerinin `Celiski` çiftlerine bağlanması, 4. günden itibaren hazır yüzleş düğmesi yerine `"Göster · Beyan Defteri"` panelinden yüzleşme dalına geçiş.
  - `tests/unit/soz/celiski_goster_test.gd` & `tests/oto/celiski_goster_kontrol.{gd,tscn}`: `SozMotoru` + `ChrSorgusu` + gerçek `KapiEkrani`/`BeyanDefteriPaneli` UI doğrulamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `DYL-01` → `TAM`.
- **Hedefli test çıktıları:**
  - `Godot.exe --headless --path . -s res://tests/unit/soz/celiski_goster_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/celiski_goster_kontrol.tscn` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/celiski_yuzlesme_test.gd` → `TEST PASS: celiski_yuzlesme_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/beyan_defteri_test.gd` → `TEST PASS: beyan_defteri_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/soz_motoru_test.gd` → `TEST PASS: soz_motoru_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/chr_kapi_kontrol.tscn` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor



### Madde 12 — `YAZ-02` (`TAM`)
- **Değişiklikler:**
  - `data/soz/yasak_kelimeler.txt`: `Roadmap-2/USLUP_REHBERI.md` §3 modern yasak sözlerinin tamamı (`aslında`, `kesinlikle`, `harika`, `mükemmel`, `inanılmaz`, `problem`, `stres`, `travma`, `sistem`, `organize`, `okey`) eklendi.
  - `tools/soz_dogrulayici.py`: `yasak_kelimeler_oku`, `metni_tara` ve `replik_uyarilari` eklendi (yasak söz uyarısı üretir, listeden satır silmez; `dogrula()` dosyayı denetler).
  - `tests/tools/test_uslup_kapisi.py`: Rehber modern sözlerinin tamamının listede olduğu, `"aslında"` içeren repliğin 1 uyarı üretip satırı silmediği, `yapaylik.js` kural sayısının 14 olduğu, ikinci üslup dosyası ve dışa aktarımda `dogaclama` bulunmadığı doğrulandı.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `YAZ-02` → `TAM`.
- **Hedefli test çıktıları:**
  - `python tests/tools/test_uslup_kapisi.py` → `Ran 3 tests in 1.082s / OK` (`RC=0`)
  - `python tests/tools/test_soz_kapi.py` → `Ran 39 tests in 9.162s / OK` (`RC=0`)
  - `python tools/soz_dogrulayici.py` → `YAZ-07 DOGRULAMA: 30 karakter ses karti ve 11 yasak kelime eksiksiz gecti.` (`RC=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/uslup_test.gd` → `TEST PASS: uslup_test.gd` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor



### Madde 13 — `OGR-03` (`TAM`)
- **Değişiklikler:**
  - `src/kapi/zar_ipucu.gd`: `ZarIpucu.uygula(ilk_saat, guncel_gece)` ve `ZarIpucu.oturumda_goster(o, ayarlar)` eklendi (`ayarlar != null` kontrolü ve `o.ipucu_kaydi` + `ilk_saat_kancasi.ipucu`/`arac` bağlantısı); `ilk_atis_ipucu` kanonik `uygula`'ya bağlandı.
  - `src/sistemler/ilk_saat.gd`: `zar_ipucu_kontrol(guncel_gece)` doğrudan `ZarIpucu.uygula(self, guncel_gece)`'ya bağlandı.
  - `src/arayuz/chr_diyalog_paneli.gd`: Zar atışı sonrası `ZarIpucu.oturumda_goster(oturum, ayarlar)` çağrısı ve `"ZarIpucuNotu"` göstergesi bağlandı.
  - `tests/unit/sistemler/ilk_saat_test.gd`: Gerçek `Oturum` + `Oturum.kaydet`/`Oturum.kayittan(kat, z_kayit)` + `ZarIpucu.oturumda_goster` doğrulamaları eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `OGR-03` → `TAM`.
- **Hedefli test çıktıları:**
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/ilk_saat_test.gd` → `ILK SAAT: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/chr_kapi_kontrol.tscn` → `CHR KAPI UI: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/celiski_goster_kontrol.tscn` → `CELISKI GOSTER UI: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor


### Madde 14 — `OGR-14` (`TAM`)
- **Değişiklikler:**
  - `src/kapi/defter_tanitimi.gd`: `celiski_yakalandi_mi(celiski, motor, defter, sorgu)` ve `oturumda_kontrol_et(o, ayarlar, celiski, motor, defter, sorgu, ekran)` eklendi; `o.ipucu_kaydi` (`ogretici.kapi.beyan_defteri`) ile kayıt/yükleme kalıcılığı ve tek seferlik `ilk_saat_kancasi.ipucu` + ekran bildirimi bağlandı.
  - `src/arayuz/chr_kapi_adaptoru.gd`: `beyan_defteri_dugmesi(...)` görünürlüğü `DefterTanitimi.oturumda_kontrol_et` ile bağlandı (`kademeli_hud` açıkken çelişki öncesi 0, çelişkide 1; `sorgu.ipucu_bulundu`, `sorgu.replik_basladi` ve `bpanel.yuzlesildi` sinyallerinde güncellenir, `tree_exited` ile koparılır).
  - `src/sistemler/chr_sorgusu.gd`: `_ipucu_servisi.ipucu_bulundu` lambdası `weakref(self)` ile düzeltildi (çıkışta kaynak sızıntısı 0).
  - `tests/oto/celiski_goster_kontrol.gd` & `tests/unit/sistemler/ilk_saat_test.gd`: Çelişki öncesi gizli / sonrası görünür, tek seferlik ipucu ve kayıt/yükleme gidiş-dönüş kontrolleri eklendi.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `OGR-14` → `[x]` `TAM`.
- **Hedefli test çıktıları:**
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/ilk_saat_test.gd` → `ILK SAAT: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . -s res://tests/unit/soz/celiski_goster_test.gd` → `TEST PASS: celiski_goster_test.gd` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/celiski_goster_kontrol.tscn` → `CELISKI GOSTER UI: GEÇTİ` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/chr_kapi_kontrol.tscn` → `CHR KAPI UI: GEÇTİ` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor


### Madde 15 — `AYR-22` (`TAM`)
- **Değişiklikler:**
  - `src/arayuz/ana.gd`: `_ready()` içinde `_odak_sesini_kur()` ile `OdakSesi` (`"OdakSesi"`) düğümü bağlandı ve `_notification` içinde `NOTIFICATION_APPLICATION_FOCUS_OUT` / `WM_WINDOW_FOCUS_OUT` / `IN` bildirimleri `OdakSesi`'ne iletildi.
  - `tests/oto/ayarlar_kontrol.gd`: Gerçek `Ana` örneği üzerinde `OdakSesi` çocuğu ve `NOTIFICATION_APPLICATION_FOCUS_OUT` / `IN` ile `ses_ana` kısılma ve geri dönüşü doğrulandı.
  - `docs/ANTIGRAVITY_DENETIM_LISTESI.md`: `AYR-22` → `[x]` `TAM`.
- **Hedefli test çıktıları:**
  - `Godot.exe --headless --path . -s res://tests/unit/sistemler/ayarlar_ek_test.gd` → `AYARLAR EK: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
  - `Godot.exe --headless --path . res://tests/oto/ayarlar_kontrol.tscn` → `AYARLAR KONTROL: GEÇTİ (0 hata)` (`RC=0`, `ERRS=0`)
- Asset gerekmedi.
- kota görünmüyor
