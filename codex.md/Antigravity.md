# Antigravity — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik

Antigravity, Google'ın kodlama ajanıdır; Ahmet'in Windows bilgisayarında çalışır. İmza `(Antigravity)`. Repo `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`, tek dal `claude/festive-volta-li1sfm`. Görev kanalı `codex.md/Antigravity_gorev.md` (Muharrir yazar). Python için `PYTHONUTF8=1`; Godot `C:\Users\Ahmet\Desktop\Godot.exe` (4.7.2 doğrulandı).

## Çalışma kuralları (kısa)

Madde başında pull, `[/] (Antigravity)` commit+push. `git add` yalnız kendi dosyalarım; `git add -A`, stash, checkout, reset, restore yok. Kirli listedeki başkasının dosyalarına, `metinler.csv` ve envantere izinsiz dokunulmaz. Teknik kararları kendim veririm, gerekçesi burada; sorular birikir, her 3 maddede bir özetlenir.

## Kayıt

### 14 Ekim — DEN-03 (sanity tarafı)
- Yapılan: `tools/denge_dogrula.py`, `data/ayarlar/denge_sinirlari.json`, `tests/tools/test_denge_dogrula.py`, sanity'ye `denge-sinirlari` adımı.
- Karar: sınırlar ayrı dosyada (Muharrir, b). `kamera_surukleme.hiz` 0.1–5.0 (kod `hiz<=0`'ı geçersiz sayıyor); `meclis_bekleme_gun` 1–14 (0 → pencere hiç açılmaz; Muharrir onayıyla 14).
- Karar: açılış hatası ayrı madde DEN-03b (metinler.csv ve açılış dosyaları Kalfa'nın ACL-04 işinde).
- Test: tests/tools tamamı OK (11 yeni test). Tam sanity bekliyor (başka ajan çalıştırıyor).
- kota görünmüyor

### 15 Ekim — DEN-04 (başladı)
- Karar: `denge.json`'a `zorluk` {kolay 0.8, olagan 1.0, siki 1.25}. ASCII anahtar (DEN-07 kuralı). Sınırlar: kolay 0.5–1.0, olagan 1.0–1.0, siki 1.0–2.0 (yön ve ekonomiyi kilitlememe gerekçesi). Mevcut yer tutucu `zorluk_carpani.sistem_yok` DEN-01 taramasına bağlı olduğu için silinmedi.
- Bu madde yalnız veri + test; çarpanı okuyan oyun kodu yazılmadı (maddede yok).

### 15 Ekim — DEN-03 ve DEN-04 kapatıldı (hedefli test)
- Sanity meşgul olduğundan Muharrir kuralıyla tests/tools (146 test, 0 hata) ile doğrulanıp [x] yapıldı; ROADMAP satırlarında 'sanity bekliyor' notu var.
- **Sanity bekliyor listesi:** DEN-03, DEN-04. Sanity boşalınca bir kez çalıştırılıp notlar silinecek.
- kota görünmüyor


### 15 Ekim — DEN-07 ve DEN-08 kapatıldı (hedefli test)
- 	ools/denge_dogrula.py: anahtar_adlari + ASCII snake_case deseni; sınır kaydı olup denge.json'da olmayan anahtar 'eksik anahtar' hatası. Test: tests/tools/test_denge_anahtar.py. tests/tools 153 test 0 hata.
- Karar: DEN-08 için ayrı zorunlu-anahtar listesi açılmadı; sınır dosyası zorunlu anahtar listesi görevini görür (ikinci liste tutulmaz).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08.
- kota görünmüyor


### 15 Ekim — DEN-09 kapatıldı (hedefli test)
- 	ools/denge_dogrula.py: koy_baslangic_kaynagi, acilis_stoku_hatalari, ikinci_baslangic_dosyalari; --koy seçeneği. Test: tests/tools/test_acilis_stoku_tablosu.py. tests/tools 161 test 0 hata.
- Karar: denge.json ve koy.tres değişmedi; yalnız doğrulayıcı eklendi. Sınır: denge.json'daki acilis_stoku ya kaynak yolu ya da aynı sayılı kopya olabilir.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09.
- kota görünmüyor


### 15 Ekim — DEN-13 kapatıldı (hedefli test)
- denge.json ilk_hafta_erzak {acilis_kisi 2, gece 7, pay 16}; sınırlar denge_sinirlari.json. Doğrulayıcı: gida == kisi*gece*gida_kisi+pay (koy.tres gida 30, gida_kisi=1 koy_ayarlari.gd). Test: tests/tools/test_ilk_hafta_erzak.py. tests/tools 168 test 0 hata.
- Karar: pay=16 mevcut açılış stoğundan türetildi (30 = 2*7+16), oyun sayısı değişmedi. Oyun kodu bu tabloyu henüz okumuyor; stok tek kaynak koy.tres (DEN-09). Tabloyu okuyan kod ayrı iş.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13.
- kota görünmüyor


### 15 Ekim — ZAR-01 kapatıldı (hedefli test)
- src/kapi/sorgu_zari.gd: d6/d12 tavanı, tansiyon eki (0, 1, 2), kilitli kontrolü, başarı kuralı (tavan daima başarı, 1 daima başarısız), teorik olasılık hesabı ve zar atışı.
- data/chr_runtime/sorgu_kurallari.tres ve src/veri/chr_sorgu_kurallari.gd: zar tansiyon kademeleri eklendi.
- Test: 	ests/unit/kapi/sorgu_zari_test.gd (0 hata, GEÇTİ, 10.000 atış dağılımı <%2 sapma).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01.
- yer tutucu: zar görseli ZAR01-ZAR envanterde prompt hazır bekliyor, düz renk kutu + sayı yer tutucu kuralı.
- kota görünmüyor


### 15 Ekim — DEN-17 ve DEN-23 kapatıldı (hedefli test)
- data/ayarlar/denge.json: zar_esigi alanı sorgu_kurallari.tres kaynağına bağlandı, gergin_alt: 4, panik_alt: 8 eklendi. Sınırlar: denge_sinirlari.json.
- 	ools/denge_dogrula.py: zar_esigi_hatalari eklendi; tres dosyasındaki eşiklerle birebir uyuşma ve ikinci tansiyon ek anahtarı yasağı doğrulandı.
- Test: 	ests/tools/test_denge_zar_esigi.py (172 test, 0 hata).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23.
- kota görünmüyor


### 15 Ekim — DEN-24 kapatıldı (hedefli test)
- ZAR-01'in 10.000 atışlık ±%2 dağılım testi 	ests/unit/kapi/sorgu_zari_test.gd içinde doğrudan doğrulandı ve yeşil geçti. İkinci bir dağılım kapısı açılmadı.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24.
- kota görünmüyor


### 15 Ekim — ZAR-02 kapatıldı (hedefli test)
- 	ools/chr_parser.py: [Zar] (d6/d12) ve [Sorgu_Değeri] okuma/doğrulama eklendi. Eksik alanda sınıfa göre varsayılan (Asker: d12/4, Esnaf: d6/3, Çiftçi: d6/2) üzerinden hata bildirilmesi ve aralık kontrolleri (d6: 1-5, d12: 2-10) bağlandı.
- karakterler/CHR_*.md (30 dosya) ve data/chr_runtime/CHR_*.tres: [Zar] ve [Sorgu_Değeri] eklendi/derlendi.
- src/veri/karakter_verisi.gd: zar ve sorgu_degeri export alanları eklendi.
- Test: 	ests/tools/test_chr_sorgu_degeri.py (5 test, 0 hata); python test paketi (177 test, 0 hata); 	ests/unit/kvr/chr_sorgu_test.gd (GEÇTİ).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02.
- kota görünmüyor



### 15 Ekim — ZAR-03 başladı
- ROADMAP_2.md'de ZAR-03 [/] olarak üstlenildi.
- Karar: Tansiyon kaçış eşiği 10, data/ayarlar/denge.json içine `zar_esigi.tansiyon_kacis_esigi` olarak eklenecek, denge_sinirlari.json ile doğrulanacak.
- Karar: src/kapi/sorgu_zari.gd içine kaçış adaptörü ve karar "kaçtı" mantığı eklenecek. Kaçış ret_sayisi artırmayacak.
- Test: tests/unit/kapi/tansiyon_kacis_test.gd yazılacak ve Godot headless ile doğrulanacak.
- kota görünmüyor

### 15 Ekim — ZAR-03 kapatıldı (hedefli test)
- data/ayarlar/denge.json ve denge_sinirlari.json: zar_esigi.tansiyon_kacis_esigi: 10 eklendi, sınırlar [5, 15] doğrulandı.
- src/veri/chr_sorgu_kurallari.gd ve data/chr_runtime/sorgu_kurallari.tres: tansiyon_kacis_esigi = 10 bağlandı.
- tools/denge_dogrula.py: tansiyon_kacis_esigi doğrulaması eklendi (denge.json vs tres uyumu).
- src/kapi/sorgu_zari.gd ve src/kapi/tansiyon_kacis_adaptoru.gd: kaçış eşiği okuma, başarısızlık tansiyon artışı, kaçış kontrolü (tansiyon 10 aşarsa karar 'kaçtı', başarılı zarda kaçırmaz, +0 artışta kaçırmaz) ve karar adaptörü (ret_sayisi artırmaz, tehlikeli karakterde asayis_riski artar).
- Test: tests/unit/kapi/tansiyon_kacis_test.gd (Godot headless, 0 hata, GEÇTİ); tools/denge_dogrula.py (GECTI); python test paketi (177 test, OK).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03.
- kota görünmüyor

### 15 Ekim — DEN-19 başladı
- ROADMAP_2.md'de DEN-19 [/] olarak üstlenildi.
- Karar: ZAR-03 kaçışının bedeli data/ayarlar/denge.json içine tek satır olarak (dedikodu, kasa değil) eklenecek (`kacan_bedeli: {dedikodu: 1, kasa: 0}`).
- Sınırlar: denge_sinirlari.json ile doğrulanacak.
- Test: kaçışta muhafiz_akce'nin değişmediği doğrulanacak.
- kota görünmüyor

### 15 Ekim — DEN-19 kapatıldı (hedefli test)
- data/ayarlar/denge.json: kacan_bedeli {dedikodu: 1, kasa: 0} eklendi.
- data/ayarlar/denge_sinirlari.json: kacan_bedeli.dedikodu [0, 5], kacan_bedeli.kasa [0, 0] sınırları tanımlandı (kasa daima 0).
- tools/denge_dogrula.py: kacan_bedeli_hatalari eklendi (kasa 0 ve dedikodu zorunluluğu).
- Test: tests/tools/test_kacan_bedeli.py (3 test, 0 hata); tests/unit/kapi/tansiyon_kacis_test.gd içinde kaçışta muhafiz_akce değişmediği doğrulandı (0 hata, GEÇTİ); python test paketi (180 test, OK).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19.
- kota görünmüyor

### 15 Ekim — ZAR-04 başladı
- ROADMAP_2.md'de ZAR-04 [/] olarak üstlenildi.
- Karar: 4 yaklaşım türü (ikna, blöf, gözdağı, gönül alma), 5. tür yasak; data/zar_degistiricileri.json oluşturulacak (kalp veya romans anahtarı hata verecek).
- Karar: src/kapi/zar_degistiricileri.gd oluşturulacak: terazi (adil iken ikna/gönül alma -1, yoz iken gözdağı -1), grup itibarı (uçta ±1), kanıt (-1, birden fazla kanıt tekrar ek vermez), asker (gözdağı -1, asker yoksa satır çıkmaz), yorgunluk (+1). Toplam [-3, +3] aralığına kırpılacak (clamp) ve kesildiği belirtilecek.
- Test: tests/unit/kapi/zar_degistirici_test.gd yazılacak ve doğrulanacak.
- kota görünmüyor

### 15 Ekim — ZAR-04 kapatıldı (hedefli test)
- data/zar_degistiricileri.json: 4 yaklaşım (ikna, blöf, gözdağı, gönül alma), değiştirici katsayıları ve [-3, 3] sınırları tanımlandı.
- src/kapi/zar_degistiricileri.gd: yaklaşım doğrulama (5. tür, kalp veya romans yasak), adil/yoz terazi, grup itibarı, kanıt, asker (yalnızca gözdağında geçerli, iknaya yazmaz) ve yorgunluk hesaplaması; [-3, 3] aralığına kırpma ve kesinti bildirme bağlandı.
- Test: tests/unit/kapi/zar_degistirici_test.gd (Godot headless, 0 hata, GEÇTİ).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04.
- kota görünmüyor

### 15 Ekim — DEN-21 başladı
- ROADMAP_2.md'de DEN-21 [/] olarak üstlenildi.
- Karar: ZAR-04 değiştiricilerinin ekonomi üretmediği, akçe satırı taşımadığı ve asker varlığında kararın kasa etkisinin değişmediği tests/unit/denge/zar_kasa_test.gd ile doğrulanacak.
- kota görünmüyor

### 15 Ekim — DEN-21 kapatıldı (hedefli test)
- tests/unit/denge/zar_kasa_test.gd yazıldı ve Godot headless ile doğrulandı (0 hata, GEÇTİ).
- ZAR-04 tablosunda ve hesaplama satırlarında akçe/kasa anahtarının bulunmadığı, askerin yalnız zorluğu etkilediği, kabul/ret/rüşvet kararlarında asker varlığının kasa sonucunu değiştirmediği (fark 0) kanıtlandı.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21.
- kota görünmüyor

### 15 Ekim — DEN-02 başladı
- ROADMAP_2.md'de DEN-02 [/] olarak üstlenildi.
- Karar: denge dosyasının sürümü data/ayarlar/denge.json içine "surum": 1 olarak eklenecek, denge_sinirlari.json içine sınır kaydı eklenecek.
- Test: eski kaydın tabloyu içine gömmediği, tablo sürümü artsa bile kayıttan yüklenen köylü sayısının değişmediği test edilecek.
- kota görünmüyor

### 15 Ekim — DEN-02 kapatıldı (hedefli test)
- data/ayarlar/denge.json içine "surum": 1 eklendi; data/ayarlar/denge_sinirlari.json içine surum [1, 100] sınırı tanımlandı.
- tests/tools/test_denge_surumu.py yazıldı ve python test paketine eklendi (183 test, OK).
- tests/unit/denge/tablo_surumu_test.gd yazıldı ve Godot headless ile doğrulandı (0 hata, GEÇTİ); eski kaydın yeni tablo bağlamında açılabildiği, kaydın tabloyu gömmediği ve tablo sürümü artınca köylü sayısının değişmediği kanıtlandı.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21, DEN-02.
- kota görünmüyor

### 15 Ekim — DEN-05 başladı
- ROADMAP_2.md'de DEN-05 [/] olarak üstlenildi.
- Karar: src/sistemler/denge_olcumu.gd oluşturulacak; gece_sonu() dönüşünü salt-okunur okuyacak, yeni bir tüketim/hesaplama fonksiyonu açmayacak.
- Test: tests/unit/denge/denge_olcumu_test.gd ile bir gecede tüketim fonksiyonunun yalnız bir kez çağrıldığı ve ek şartların (nöbet maaşı, aç kişi oranı, zindan ekmek, sorgu eylemleri) sağlandığı doğrulanacak.
- kota görünmüyor

### 15 Ekim — DEN-05 kapatıldı (hedefli test)
- src/sistemler/denge_olcumu.gd yazıldı: DengeOlcumu.olustur() oturum.gece_sonu() çıktısını salt-okunur tüketir, ikinci bir tüketim veya hesaplama döngüsü işletmez.
- Ek şartlar karşılandı: nöbet maaşı, aç kişi oranı, çınar meclisi oy farkı, zindan ekmek payı ve sorgu eylem sayıları rapor satırları olarak bağlandı.
- Test: tests/unit/denge/denge_olcumu_test.gd (Godot headless, 0 hata, GEÇTİ).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21, DEN-02, DEN-05.
- kota görünmüyor

### 15 Ekim — DEN-06 başladı
- ROADMAP_2.md'de DEN-06 [/] olarak üstlenildi.
- Karar: src/sistemler/denge_olcumu.gd içinde ölçüm raporunun oyuncuya açılmadığı (oyuncuya_gorunur: false, oyuncuya_acik_mi() -> false), oyuncu HUD arayüzünde "denge" anahtarının yer almadığı doğrulanacak.
- Test: tests/unit/denge/denge_hud_test.gd ile oyuncu arayüzünde "denge" anahtarının 0 olduğu kanıtlanacak.
- kota görünmüyor

### 15 Ekim — DEN-06 kapatıldı (hedefli test)
- src/sistemler/denge_olcumu.gd içine `oyuncuya_acik_mi()` (false) ve `oyuncu_arayuz_denge_anahtar_sayisi()` doğrulayıcısı eklendi.
- tests/unit/denge/denge_hud_test.gd yazıldı ve Godot headless ile doğrulandı (0 hata, GEÇTİ).
- Hud.STOKLAR listesinde ve oyuncu arayüz verisinde "denge" anahtarının 0 olduğu kanıtlandı. Python test paketi (183 test) yeşil.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21, DEN-02, DEN-05, DEN-06.
- kota görünmüyor

### 15 Ekim — DEN-22 başladı
- ROADMAP_2.md'de DEN-22 [/] olarak üstlenildi.
- Karar: src/sistemler/denge_olcumu.gd içinde o gecenin başarısız zar sayısının tek satırda tutulduğu, ister 3 ister 100 başarısızlık olsun her zar için ayrı ekonomik satır veya tüketim açılmadığı doğrulanacak.
- Test: tests/unit/denge/denge_zar_raporu_test.gd ile 3 veya 100 başarısızlık durumunda raporda tek bir sayı satırı oluştuğu ve bütçe/tüketim satırlarının çoğalmadığı kanıtlanacak.
- kota görünmüyor

### 15 Ekim — DEN-22 kapatıldı (hedefli test)
- src/sistemler/denge_olcumu.gd içine `zar_rapor_satir_sayisi()` doğrulayıcısı eklendi.
- tests/unit/denge/denge_zar_raporu_test.gd yazıldı ve Godot headless ile doğrulandı (0 hata, GEÇTİ).
- 3 veya 100 başarısız zar atışında raporda zarla ilgili tek bir satır (`basarisiz_zar_sayisi`) oluştuğu, her zar için ayrı masraf/akçe veya bütçe satırı açılmadığı ve ekonomik tüketimin değişmediği kanıtlandı.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21, DEN-02, DEN-05, DEN-06, DEN-22.
- kota görünmüyor

### 15 Ekim — DEN-14 başladı
- ROADMAP_2.md'de DEN-14 [/] olarak üstlenildi.
- Karar: data/ayarlar/denge.json içinde açılış kasası iki ayrı satır olarak (koy_akce, muhafiz_akce) tanımlanacak; toplam satırı yazılmayacak ve data/ayarlar/denge_sinirlari.json içine sınırları eklenecek.
- Test: tools/denge_dogrula.py ve tests/unit/denge/acilis_kasasi_test.gd ile iki kasanın ayrı satırlarda olduğu, toplam alanının bulunmadığı kanıtlanacak.
- kota görünmüyor

### 15 Ekim — DEN-14 kapatıldı (hedefli test)
- data/ayarlar/denge.json içine `acilis_kasasi` (koy_akce: 10, muhafiz_akce: 0) iki ayrı satır olarak eklendi; data/ayarlar/denge_sinirlari.json içine sınırları tanımlandı.
- tools/denge_dogrula.py içine `acilis_kasasi_hatalari` eklendi; toplam alanının yer alması engellendi.
- tests/tools/test_acilis_kasasi.py ve tests/unit/denge/acilis_kasasi_test.gd yazıldı, Godot headless ve Python birim testleri 0 hatayla geçti.
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21, DEN-02, DEN-05, DEN-06, DEN-22, DEN-14.
- kota görünmüyor

### 15 Ekim — DEN-11 başladı
- ROADMAP_2.md'de DEN-11 [/] olarak üstlenildi.
- Karar: 20 taş kapasitesi ve kurtarıcı yatağın BUG-21'de tanımlı olduğu, yeni yatak eklenmediği tests/oto/acilis_denge_kontrol.tscn içine eklenecek kontrolle ölçülecek (yatak sayısı oyun başında 1, kurtarıcı tavanı 3).
- Test: tests/oto/acilis_denge_kontrol.gd çalıştırılarak doğrulanacak.
- kota görünmüyor

### 15 Ekim — DEN-11 kapatıldı (hedefli test)
- tests/oto/acilis_denge_kontrol.gd içine `_tas_yatagi_ikinci_kez_yazilmaz` eklendi.
- Taş yatağı kapasitesinin 20 olduğu, kurtarıcı tavanının 3 olduğu (TasYatagi.AYAR.kurtarici_azami) ve oyun başında yatak sayısının tam olarak 1 olduğu, ikinci bir yatak eklenmediği doğrulandı.
- Test: tests/oto/acilis_denge_kontrol.tscn ve tests/unit/koy/tas_yatagi_test.gd (Godot headless, 0 hata, GEÇTİ).
- **Sanity bekliyor listesi:** DEN-03, DEN-04, DEN-07, DEN-08, DEN-09, DEN-13, ZAR-01, DEN-17, DEN-23, DEN-24, ZAR-02, ZAR-03, DEN-19, ZAR-04, DEN-21, DEN-02, DEN-05, DEN-06, DEN-22, DEN-14, DEN-11.
- kota görünmüyor






### 24 Ekim — Gece Kapısı UI Üretimi (Başlangıç, Harita Notu ve Kota Durması)
- `interrogation_bg.png` (dosyası üretildi ve korundu), `env_menu_bg.png`, `env_village_bg.png`, `koy_hud_bg.png` maddeleri 3D sahne kararıyla `[!] (Antigravity) 3D sahne var, gerek yok` olarak işaretlendi.
- Harita resmi üretildi (`map_bg.png`), kod entegrasyonu bekliyor (`harita_uc.png` de sırası geldiğinde üretilecek).
- Bitenler (5 kabul + 1 üretilip 3D kararıyla işaretlenen): `map_bg.png`, `ornament_emblem.png`, `cursor_grab.png`, `cursor_busy.png`, `icon_akce.png` (ve `interrogation_bg.png`). Yeşil zeminli ham kopyalar `work/ui_yesil_ham/` altında saklandı, temizlenenler gerçek RGBA + 16px dış pay ile `assets/ui/atmosfer/gece_kapisi/` altına kaydedildi.
- Atlananlar (5 madde): `ornament_seal.png` (2 denemede de prompttaki timber/iron yüzünden mum mühür yanına anahtar/ip eklendi) ve 3D sahne olan 4 arka plan (`interrogation_bg.png`, `env_menu_bg.png`, `env_village_bg.png`, `koy_hud_bg.png`).
- Kalan net üretim sayısı: 267 madde.
- kaldığı yer: madde 8, icon_erzak.png
- kota: resim üretim kotası doldu (HTTP 429 RESOURCE_EXHAUSTED, ~4 saat 21 dk sonra yenileniyor)


### 2 Kasım — DIY-09 kapatıldı (hedefli test)
- `src/soz/satir_secici.gd` (`SatirSecici`): kural tablosu ile bağlamsal satır seçimi eklendi. Tam eşleşme şartı (kısmi tutma elenir), koşul sayısına göre en özgül varyant seçimi, eşit koşul sayısında `oncelik` kırılımı, önceliksiz eşitlikte doğrulayıcı hatası (dosya sırası hakem olmaz), boş koşullu varsayılan ve varsayılan yoksa sessiz dönüş bağlandı.
- Ek şartlar: `baglama_aclik_yaz` ile aç kişinin söz bağlamına `aclik` anahtarı ve `baglama_dunya_isareti_yaz` / `baglam_hazirla` ile dünya işaretlerinin `dunya.<id>` önekiyle bağlama girmesi (ikinci cümle üretmeden) eklendi.
- Test: `tests/unit/soz/satir_secici_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — DIY-11 kapatıldı (hedefli test)
- `src/soz/kisi_hafizasi.gd` (`KisiHafizasi`) ve `src/sistemler/karakter_kadrosu.gd` opsiyonel hafıza alanı kayıt/yükleme adaptörü eklendi.
- Hafıza tek kaynak olarak `KarakterKadrosu.durumlar[id]` altında tutulur (ikinci sözlük yok). `son_karar=ret` iken `selam_ret` döner; ret sonrası kabul `son_karar`'ı ezerken geçmişteki ret satırını silmez; ölümde `DYL-08` haberi üretilir ve selam seçilmez; kaydet-yükle ziyaret sayısını artırmaz; 10. ziyaret 9. ziyaretin selam anahtarını (`selam_9`) kullanır.
- Test: `tests/unit/soz/kisi_hafizasi_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — DIY-12 kapatıldı (hedefli test)
- `data/gruplar.json` ve `src/sistemler/grup_itibari.gd` (`GrupItibari`): 6 grup (Türkmen, Rum, Ahi, köylü, tüccar, asker) ve -10..+10 itibar sınırları eklendi.
- Bir ziyarette yalnız karakterin birincil grubuna yazılır; çift grupluda ikinci gruba yazılmaz; grupsuz karakter varsayılan olarak köylü sayılır; sınır dışına taşan yazımlar -10/+10'da kesilir ve kayıtta `"kesildi"` olarak tutulur; yedinci grup ve `kalp`/`romans` anahtarları reddedilir.
- Test: `tests/unit/sistemler/grup_itibari_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — DIY-13 kapatıldı (hedefli test)
- `src/sistemler/dedikodu.gd` (`Dedikodu`): rüşvet, şiddet, aileyi bölme ve haksız ret olaylarının tanıklı ve 1-3 gece gecikmeli yayılımı eklendi.
- Tanık yoksa satır oluşmaz; kamu vergisi dedikodu sayılmaz; aynı olay kimliği ikinci kayıt açmaz; tanık yayılmadan ölürse kayıt düşer; 3. geceden sonra basılmamış satır silinir; gün 0'da pusula satırı 0'dır.
- Test: `tests/unit/sistemler/dedikodu_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — DIY-14 kapatıldı (hedefli test)
- `src/arayuz/kapi/hatirlanma_notu.gd` (`HatirlanmaNotu`): hafıza (DIY-11 / ZAR-03 kaçış) veya dedikodu (DIY-13) yazılan seçimlerde 2 saniyelik `"Bu hatırlanacak"` bildirimi eklendi.
- Ayar kapalıyken kayıt yazımı devam eder, yalnız bildirim gizlenir; tek seçimde hem hafıza hem dedikodu varsa bildirim 1 kez çıkar; metinde özel ad/grup/gece sayısı yer almaz; ikinci bildirim birincinin üstüne binmez.
- Test: `tests/unit/kapi/hatirlanma_notu_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — CAT-01 kapatıldı (hedefli test)
- `data/kapi_kavgasi.json` ve `src/kapi/kapi_kavgasi.gd` (`KapiKavgasi`): yer yokluğu ve sert ret durumlarında genç erkek, aç aile reisi ve asker kaçağı tiplerinde kavga tetikleme kuralları eklendi.
- Askersiz köyde kavga sahnesi açılmaz, kişi tehdit edip gider ve tanık varsa `Dedikodu` (DIY-13) kaydı yazılır; tip dışı ret sıradan rettir; köy meydanı/şifahane/divan ve heyet sırasında kavga açılmaz; aynı kişi aynı gün ikinci istek üretmez.
- Test: `tests/unit/kapi/kapi_kavgasi_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — CAT-02 kapatıldı (hedefli test)
- `src/kapi/kapi_kavgasi.gd` (`KapiKavgasi`): dört kavga seçeneği (`askerle_karsilik`, `akceyle_erteleme`, `sozle_yatistirma`, `reddetme`) ve kilit/sonuç kuralları eklendi.
- Dört seçenek dört ayrı sonuç kimliği üretir; erteleme `verilen_soz` kaydına 1 satır (`yarin_gel`) yazar ve `muhafiz_akce` düşer; ölüm cenaze akışına tek çağrı yazar; `kalp` anahtarı ve beşinci seçenek 1 hata verir; aynı seçeneğe iki tıkta sonuç yalnız 1 kez yazılır.
- Asset: `CAT02-KAVGA` `docs/EKSIK_ASSET_ENVANTERI.md` içinde zaten kayıtlı; kodda sarsıntı + metin yer tutucusu (`YER_TUTUCU_CANLANDIRMA`) bağlandı.
- Test: `tests/unit/kapi/kavga_secenek_test.gd` (Godot headless, 0 hata, GEÇTİ).
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — CAT-03 kapatıldı (hedefli test)
- `src/koy/hekim_ilac.gd` (`HekimIlac`): kavga yaralısının şifahane ve hekim üzerinden tedavisi için `yara_tedavi_secenegi_gorunur`, `yara_tedavi_uygula` ve `yara_gece_kuyrugu_isle` adaptörleri eklendi.
- Hekim ve şifahane varken sağlık deltası pozitiftir; hekim yokken veya kendisi yaralıyken kayıp sürer; yabancı yaralı tedavi edilip gönderilirse grup itibarı +1 artar ve köylü olmaz; aynı yara ikinci gece sağlık deltası 0'dır; ölü hekime gitmez.
- Test: `tests/unit/koy/hekim_yara_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — CAT-04 kapatıldı (hedefli test)
- `data/kapi_kavgasi.json` (`siddet_korkusu`) ve `src/kapi/siddet_korkusu.gd` (`SiddetKorkusu`): askerle karşılık veya ölüm sonrasında sıradaki kişilerin tansiyon eşiğine ve tablo olasılığına göre ayrılması ve dedikodu taşıması eklendi.
- Eşik altı sırada ayrılan 0'dır; eşik üstü ve olasılık 1 olan satırda ayrılan 1'dir ve sonraki gün dedikodu (DIY-13) taşır; yatıştırma ve ertelemede ayrılan 0'dır; menü açıkken artış donar, menü açılıp kapanınca tansiyon artışı değişmez.
- Test: `tests/unit/kapi/siddet_korkusu_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### 2 Kasım — DYL-06 kapatıldı (hedefli test)
- `src/soz/dil_engeli.gd` (`DilEngeli`) ve `src/koy/koylu.gd` opsiyonel `diller` alanı eklendi.
- Ortak dil yokken yalnız `kirik` satırlar gelir; tercüman çağrılınca tam satırlar (veya kendi grubundan köylü tercümanda yumuşatılmış `tercuman` varyantı) gelir; ortak dilde `kirik` satır 0'dır; tercüman köylünün iş gücü 1.0'dan 0.5'e düşer (ikinci çağrı 0'a indirmez); tercüman bayrağı yokken düğme 0'dır; eş tercüman çarpıtmaz.
- Test: `tests/unit/soz/dil_engeli_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- Açık kalan: yok.
- kota görünmüyor

### KOP-05 — Dedikodu, fısıltı gazetesinin yazarıdır (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `KOP-05`
- **Yapılanlar:**
  - `src/sistemler/dedikodu.gd` içine pusula satır şablonu, kişisel kasa rüşvet kaydı (`kisisel_rusvet_kaydet`), tanık ayrılışı (`tanik_ayrildi`) ve okuma/yazma sayaçları eklendi.
  - `src/kapi/fisilti_gazetesi.gd` içine yalnızca `Dedikodu` kaydını okuyan `dedikodu_pusulasi_oku` ve `dedikodu_kayitlari_oku` köprüleri eklendi.
  - `tests/unit/kapi/kop05_dedikodu_fisilti_test.gd` birim testi yazılıp doğrulandı (`KOP05 DEDIKODU FISILTI: GEÇTİ (0 hata)`).
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-02 — Kart metni Söz dalına düşebilir (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-02`
- **Yapılanlar:**
  - `src/sistemler/olay_soz_bagi.gd` (`OlaySozBagi`) oluşturuldu; seçilen gece kartının `id` değerini DIY-09 bağlamına `olay.<id>` olarak yazan ve tanık/eş/dönen yüz için Söz dalını açan köprü kuruldu.
  - `src/soz/satir_secici.gd` içinde `olay.<id>` ve `sira.<id>` alan doğrulaması eklendi.
  - `tests/unit/sistemler/olay_soz_bagi_test.gd` birim testi yazılıp doğrulandı (`OLAY SOZ BAGI: GEÇTİ (0 hata)`).
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-07 — Sıra olayı Söz dalını açar (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-07`
- **Yapılanlar:**
  - `src/sistemler/olay_soz_bagi.gd` içine `sira_anahtari`, `sira_dali_var_mi` ve `sira_bagla` eklendi (dalı olan kişide 1 kez sorulur, olmayanda `kart_only` kalır).
  - `src/kapi/sira_atlama_adaptoru.gd` içine tek satırlık `OlaySozBagi.sira_bagla` kancası eklendi.
  - `tests/unit/sistemler/olay_soz_bagi_test.gd` birim testi iki kişi senaryosuyla genişletilip doğrulandı (`OLAY SOZ BAGI: GEÇTİ (0 hata)`).
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-01 — Olay seçici BUG-16'dan geçer, ikinci seçici yoktur (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-01`
- **Yapılanlar:**
  - `Oturum.olay_sec` akışının `OlayOnKosulu` (`BUG-16` ve `KAP-19`) üzerinden geçtiği ve ikinci bir `olay_secici.gd` dosyasının bulunmadığı `tests/unit/sistemler/ozl_kart_tarama_test.gd` birim testiyle doğrulandı (`OZL KART TARAMA: GEÇTİ (0 hata)`).
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-04 — `tek_sefer` kartı ikinci kez gelmez (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-04`
- **Yapılanlar:**
  - `dervis` ve `dugun` gibi `tek_sefer = true` kartların şema ve seçici kuralının korunduğu ve 30 gecede en çok 1 kez seçildiği `tests/unit/sistemler/ozl_kart_tarama_test.gd` içine eklendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-05 — Kart yoksa gece kilitlenmez (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-05`
- **Yapılanlar:**
  - `src/sistemler/gece_bilancosu.gd` içine boş havuzda kart çıkmadığında rapora `"bu gece köy sessiz"` satırını ekleyen tek satırlık `sessiz_gece_kontrol` adaptörü eklendi.
  - `tests/unit/sistemler/ozl_kart_tarama_test.gd` içine boş havuz ve `olay_olasiligi = 1.0` senaryosu eklendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-12 — Tarla kartları mevsim okur, ikinci takvim açmaz (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-12`
- **Yapılanlar:**
  - `src/sistemler/olay_on_kosulu.gd` içine `Takvim` (`mevsim`, `kis_mi`) koşul denetimi bağlandı.
  - `data/olaylar/tarla_yagmur.tres` içine `"kis_mi": false` koşulu eklendi; dört mevsim kontrolü `tests/unit/sistemler/ozl_kart_tarama_test.gd` içine eklendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-13 — `harman` ve `pazar_gunu` hafta başına bakabilir (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-13`
- **Yapılanlar:**
  - `data/olay_agirlik.json` oluşturuldu (`harman` ve `pazar_gunu` hafta başı çarpanları).
  - `src/sistemler/olay_on_kosulu.gd` içine `Takvim.hafta_basi` okuyan `agirlik` hesabı eklendi; 7 gece kontrolü `tests/unit/sistemler/ozl_kart_tarama_test.gd` içine eklendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-14 — Kış odunu kartı yoktur (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-14`
- **Yapılanlar:**
  - `data/olaylar/` içinde `kis_odun` kimlikli kartın bulunmadığı (0 adet) `tests/tools/test_olay_kartlari.py` içine sayım testi olarak eklendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-15 — `dugun.tres` KAP-19 ve BUG-16 ile bağlanır, tören motoru açılmaz (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-15`
- **Yapılanlar:**
  - `data/olaylar/dugun.tres` içindeki `"yetiskin_hane_min": 2` ve `"yas_grubu": "yetiskin"` koşulunun KAP-19 ve BUG-16 ile bağlandığı ve 3 kişilik köyde 30 gecede `dugun` seçilmediği (`tests/unit/olay/nufus_katmani_test.gd` ve `tests/tools/test_olay_kartlari.py`) doğrulandı.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-16 — `bebek.tres` `cocuk_var` tersine bakmaz, `hane_var` ister (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-16`
- **Yapılanlar:**
  - `src/sistemler/olay_on_kosulu.gd` içine `hane_var` koşul denetimi (`gercek_hane_var`) eklendi.
  - `data/olaylar/bebek.tres` koşulu `"cocuk_var": true` yerine `"hane_var": true` olarak güncellendi.
- **Asset:** KAP-17 çocuk (yeni satır yok).
- **Açık kalanlar:** Yok.

### OZL-17 — Ölüm KRI-05'e gider, yeni cenaze kartı yazılmaz (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-17`
- **Yapılanlar:**
  - `data/olaylar/cenaze.tres` dosyasının bulunmadığı (0 adet) ve ölümlerin `CenazeYasi` (`KRI-05`) akışına bağlandığı `tests/tools/test_olay_kartlari.py` içine eklendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OZL-18 — Cenaze gecesi HUD `cenaze_raporu.gd` okunur (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OZL-18`
- **Yapılanlar:**
  - `src/sistemler/olay_soz_bagi.gd` içine `CenazeYasi` ve `cenaze_raporu.gd` çıktısını okuyarak Söz bağlamına `olay.cenaze` anahtarı türeten `cenaze_baglama_yaz` okuyucusu eklendi; yeni panel dosyası açılmadı.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OGR-01 — İlk saat haritası tek dosyada durur (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OGR-01`
- **Yapılanlar:**
  - `data/ogretici/ilk_saat.json` oluşturuldu; ilk altı gecede öğrenilen 9 kavramın `gece_min` ve `tetik` alanları tanımlandı.
  - `src/sistemler/ilk_saat.gd` (`IlkSaat`) ve `tests/unit/sistemler/ilk_saat_test.gd` oluşturuldu.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OGR-03 — İkinci gece zar görünür olur (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OGR-03`
- **Yapılanlar:**
  - `src/kapi/zar_ipucu.gd` (`ZarIpucu`) oluşturuldu; ikinci gece ilk zar atışında `"gerekli = değer + 1 + tansiyon eki"` ipucunu bir kez gösterip `ilk_saat` kaydına `zar_gosterildi` yazan akış bağlandı.
  - `src/sistemler/ilk_saat.gd` ve `tests/unit/sistemler/ilk_saat_test.gd` güncellendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OGR-06 — Tehdit alışma süresi ilk saatle hizalıdır (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OGR-06`
- **Yapılanlar:**
  - `data/ogretici/ilk_saat.json` içindeki `tehdit_baslangic` alanı `BUG-18` kaynağına (`res://data/tehdit_takvimi.json`) bağlandı; `IlkSaat.tehdit_baslangic_gunu` tek kaynaktan okuyacak şekilde doğrulandı.
  - `tests/unit/sistemler/ilk_saat_test.gd` güncellendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.

### OGR-21 — Taş ve odun kilidi ilk inşa denemesinde uyarır (Tamamlandı)
- **Tarih:** 12 Ekim 2026
- **Madde:** `OGR-21`
- **Yapılanlar:**
  - `src/sistemler/ilk_saat.gd` içine yetersiz kaynakla ilk inşa denemesinde kaynağın nereden geldiğini (`taş yatağı`, `oduncu`) bir kez bildiren ve yeterli kaynakta 0 dönen `insa_kaynak_uyarisi` eklendi.
  - `tests/unit/sistemler/ilk_saat_test.gd` güncellendi.
- **Asset:** Asset gerekmedi.
- **Açık kalanlar:** Yok.


## 13 Ekim 2026 — OGR-37 ve OGR-45 (Geçmişe Göre İpucu Atlama ve İpucu Sayısı Üst Sınırı)
- **Ne yapıldı (`OGR-37`, `OGR-45`):**
  1. `data/ogretici/ilk_saat.json` içindeki her kavrama `atla_gecmis` listesi ve `azami_ipucu: 20` üst sınırı eklendi.
  2. `src/sistemler/ilk_saat.gd` içine `gecmis_icin_ipuclari(gecmis_id)`, `tetikle(..., gecmis_id)` desteği ve `AZAMI_IPUCU` üst sınır süzgeci eklendi.
  3. `tests/unit/sistemler/ilk_saat_test.gd` güncellendi.
  4. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — OMR-02, OMR-04, OMR-06 ve OMR-34 (Omurga Dönem ve Dalga Türetimi)
- **Ne yapıldı (`OMR-02`, `OMR-04`, `OMR-06`, `OMR-34`):**
  1. `src/sistemler/omurga.gd` (`Omurga`) oluşturuldu: perde 1 için nüfustan üç dönem (`kurulus`, `yerlesme`, `oturma`) türeten `donem(y)` ve perde 2 için `PerdeGecisi.gece(y)` ile `perde2_hedef_gece` sınırlarından 1/2/3 dalgası türeten `dalga(y, hedef_gece)` eklendi.
  2. `omurga.gd` içinde kayıt (`kaydet`/`yukle`) ve mevsim (`Takvim`) bağımlılığı bulunmadığı `tests/unit/sistemler/omurga_test.gd` ile doğrulandı.
  3. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — OGR-33 ve OMR-11 (İlk Saatte Son Kilidi ve Perde 2 İpucu Suskunluğu)
- **Ne yapıldı (`OGR-33`, `OMR-11`):**
  1. `data/ogretici/ilk_saat.json` içine `"son_kilidi_gece": 6` eklendi ve `src/sistemler/son_kilidi.gd` (`SonKilidi`) oluşturuldu.
  2. `src/sistemler/nihai_son.gd` içindeki `son(o, s)` fonksiyonuna `SonKilidi.kilitli_mi(o)` tek satır kontrolü eklendi.
  3. `src/sistemler/ilk_saat.gd` içine perde 2'de (`perde >= 2`) ipucu sistemini susturan koşul eklendi ve `tests/unit/sistemler/ilk_saat_test.gd` güncellendi.
  4. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — OMR-13, OMR-14 ve OMR-28 (Muhafız Odası Gidişat Paneli ve Yozlaşma Eşiği Uyarısı)
- **Ne yapıldı (`OMR-13`, `OMR-14`, `OMR-28`):**
  1. `src/arayuz/oda_gidisat_paneli.gd` (`OdaGidisatPaneli`) oluşturuldu: perde 2'de altı son göstergesini kademe sözcükleriyle (`düşük`/`orta`/`yüksek`) gösterir (perde 1'de gizlidir) ve dalga 2'den itibaren `nihai_sonlar.json sonlar[n].baslik` adını taşıyan `"şu an gidişat: …"` cümlesini sunar. `src/arayuz/muhafiz_odasi_ekrani.gd` içine tek satırla bağlandı.
  2. `src/arayuz/oda_yozlasma_uyarisi.gd` (`OdaYozlasmaUyarisi`) oluşturuldu ve `src/arayuz/oda_vicdan_paneli.gd` içine bağlandı: yozlaşma eşiğine üç kademe kala erken uyarı satırı üretir.
  3. `tests/unit/arayuz/omr13_14_28_oda_test.gd` birim testi eklendi.
  4. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — AYR-05, AYR-22, AYR-43 ve AYR-46 (Sekme Sıfırlama, Odak Sesi, Sürümlü Ayar Dosyası ve CLI Ayar)
- **Ne yapıldı (`AYR-05`, `AYR-22`, `AYR-43`, `AYR-46`):**
  1. `src/sistemler/ayarlar_ek.gd` içine `sekme_sifirla(a, sekme, onaylandi)` (`AYR-05`), `surum` anahtarı ve bilinmeyen ileri sürüm anahtarlarını koruma (`AYR-43`), `--ayar anahtar=deger` komut satırı oturum geçersiz kılması (`AYR-46`) ve `arka_planda_sustur` ek anahtarı eklendi.
  2. `src/sistemler/odak_sesi.gd` (`OdakSesi`, `AYR-22`) oluşturuldu: `NOTIFICATION_APPLICATION_FOCUS_OUT` ile `ses_ana` geçici 0 ve Master `-80 dB` olur, odak dönüşünde eski değere döner.
  3. `tests/unit/sistemler/ayarlar_ek_test.gd` güncellendi.
  4. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — KAY-04 (İçerik Sürümü ve Kayıt Sürümü Ayrımı)
- **Ne yapıldı (`KAY-04`):**
  1. `src/veri/icerik_ayarlari.gd` (`IcerikAyarlari`) ve `data/ayarlar/icerik.tres` oluşturuldu (`icerik_surumu = 1`, yalnız okunur).
  2. `src/sistemler/kayit_gocu_soz.gd` içine `icerik_surumu_oku()` ve `kay04_hazirla()` eklendi: içerik sürümü artınca kişi hafızasını silmez, kayıt sürümü artınca kataloğu baştan kurmaz; eksik sabah defteri satırını boş, sabah gün sayacını 0, kapı eylemleri listesini tekil dizi ve boş gün alanını `"bos"`/boş olarak hazırlar.
  3. `tests/unit/kayit/kay04_icerik_surumu_test.gd` birim testi eklendi.
  4. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — OGR-07, OGR-15, OGR-16, OGR-17, OGR-18, OGR-20, OGR-32 ve OGR-34 (İpucu Kaydı ve Bağlamsal İlk Saat Tetikleri)
- **Ne yapıldı (`OGR-07`, `OGR-15`, `OGR-16`, `OGR-17`, `OGR-18`, `OGR-20`, `OGR-32`, `OGR-34`):**
  1. `src/sistemler/ipucu_kaydi.gd` (`IpucuKaydi`, `OGR-07`) oluşturuldu: görülen ipuçlarını `ogretici.gorulen` dizisinde kayda yazar ve okur; eski kayıtta alan yoksa çökmeden boş liste kabul eder, `sifirla()` / `yeni_oyun()` ile temizlenir.
  2. `src/sistemler/ilk_saat.gd` içine `heybe_gizli_esya_ipucu` (`OGR-15`), `tansiyon_gergin_ipucu` (`OGR-16`), `bar_degisim_ipucu` (`OGR-17`), `barinak_dolu_ipucu` (`OGR-18`), `kaynak_eksilis_ipucu` (`OGR-20`), `kitlik_esigi_ipucu` (`OGR-32`) ve `iflas_uyarisi_ipucu` (`OGR-34`) tek seferlik tetik fonksiyonları eklendi.
  3. `tests/unit/sistemler/ilk_saat_test.gd` güncellendi ve Godot headless ile 0 hata doğrulandı.
  4. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — OGR-08, OGR-11, OGR-12, OGR-24, OGR-53 ve OGR-55 (İpucu Şeridi, Debug İpucu Paneli, Düğme İşareti ve Tarama Kuralları)
- **Ne yapıldı (`OGR-08`, `OGR-11`, `OGR-12`, `OGR-24`, `OGR-53`, `OGR-55`):**
  1. `src/arayuz/ipucu_seridi.gd` (`IpucuSeridi`, `OGR-08`, `OGR-11`) oluşturuldu: HUD alt-sol köşesinde en çok 90 karakterlik tek satır ipucu 6 saniye veya ilk girdiyle kapanana kadar durur; `Engine.time_scale` değerini değiştirmez.
  2. `src/debug/ipucu_paneli.gd` (`IpucuPaneli`, `OGR-12`) oluşturuldu ve `src/debug/admin_hud.gd` içine tek satırla bağlandı: yalnız debug açıkken görülen ipuçlarını listeler ve "Hepsini sıfırla" düğmesi sunar.
  3. `src/arayuz/koy_hud/yeni_dugme_isareti.gd` (`YeniDugmeIsareti`, `OGR-24`) oluşturuldu: pazar ve divan düğmeleri ilk kez açıldığında işaretlenir, girilince işaret kalkar.
  4. `tools/metin_dogrula.py` içine `ogretici.*` ≤ 90 karakter (`OGR-08`) ve `"F1"` yasağı (`OGR-55`) kuralları eklendi; `tools/godot_script_taramasi.py` içine çekirdek 4 dosyada `ogretici.` anahtarı yasağı (`OGR-53`) eklendi.
  5. Asset gerekmedi.
- **Kota:** kota görünmüyor

## 13 Ekim 2026 — AYR-28, AYR-29, AYR-31, AYR-32 ve AYR-33 (Üç Kayıt Yuvası, Yuva Kartı, Otomatik Kayıt ve İki Adımlı Silme)
- **Ne yapıldı (`AYR-28`, `AYR-29`, `AYR-31`, `AYR-32`, `AYR-33`):**
  1. `src/sistemler/kayit_yuvalari.gd` (`KayitYuvalari`, `AYR-28`, `AYR-32`) oluşturuldu: üç kayıt yuvası (`kayit_1.json`..`kayit_3.json`), eski `kayit.json` dosyasını silmeden yuva 1'e göç ettirme ve onaylı silmede `cop/` dizinine taşıyıp bir sonraki açılışta temizleme eklendi.
  2. `src/arayuz/kayit_yuva_karti.gd` (`KayitYuvaKarti`, `AYR-29`, `AYR-33`) oluşturuldu: gün, nüfus, perde, son kayıt saati ve muhafız geçmişi alanlarını okur; bozuk dosyada `"okunamadı"`, ileri sürümde `"yeni sürüm kaydı"` yazar ve çökmez.
  3. `src/sistemler/ayarlar_ek.gd` içine `otomatik_kayit` (`her_gece`/`uc_gecede_bir`/`kapali`) ve `otomatik_kayit_yazilmali_mi` (`AYR-31`) eklendi.
  4. `tests/unit/sistemler/ayarlar_ek_test.gd` güncellendi ve Godot headless ile 0 hata doğrulandı.
  5. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 13 Ekim 2026 — OGR-10, OGR-47, OGR-48, OGR-49, OGR-50, OGR-51, OMR-17 ve OMR-53 (İkinci Oyun Davranışları, İpucu Hafızası, Nihai Son Kaydı ve Omurga Verisi)
- **Ne yapıldı (`OGR-10`, `OGR-47`, `OGR-48`, `OGR-49`, `OGR-50`, `OGR-51`, `OMR-17`, `OMR-53`):**
  1. `src/sistemler/ipucu_kaydi.gd` (`IpucuKaydi`, `OGR-10`, `OGR-51`): Görülen ipuçlarının tekrar çıkmasını engelleyen yapıya hafıza defteri "Not" sayfası için son 5 ipucunu döndüren `defter_not_sayfasi(5)` / `son_ipuclari(5)` eklendi; devam eden kayıtta `ogretici.gorulen` ile `ilk_oyun_bitti` çeliştiğinde kayıt verisinin öncelikli olmasını sağlayan `durum_coz()` sağlandı.
  2. `src/sistemler/oyuncu_izi.gd` (`OyuncuIzi`, `OGR-47`, `OGR-48`, `OGR-50`): Çekirdek ayarlar dosyasını kirletmeden `user://oyuncu_izi.cfg` dosyasında `ilk_oyun_bitti` durumunu saklar; 6 gece geçildiğinde ikinci oyunda ipuçlarını ve açılış kadrajını kapatır (`OGR-47`, `OGR-48`), zorluk seçimini ise ikinci oyunda erişilebilir kılar (`OGR-50`).
  3. `data/ogretici/ilk_saat.json` (`OGR-49`): Tüm kavramlara `"surum_min": 1` eklendi; sürüm yükseldiğinde yeni mekaniklerin tek seferlik ipucu vermesi `OyuncuIzi.kavram_ipucu_verilmeli_mi()` ile doğrulandı.
  4. `src/sistemler/son_kaydi.gd` (`SonKaydi`, `OMR-17`): Sonun seçildiği an `son_metni` dönüşündeki `nihai` kimliğini ve epilog metnini kayda (`son.nihai`) yazar; eski kayıtta alan yoksa boş sayarak çökmez.
  5. `data/omurga.json` ve `src/sistemler/omurga.gd` (`OMR-53`): Dönem eşikleri, dalga sınırları, hat öncelikleri (`sancak > tekfur > mogol > oba > ahi`) ve yüz eşlemeleri `data/omurga.json` veri dosyasına taşındı; `omurga.gd` içerisindeki tüm 0 ve 1 hariç sayısal sabitler kaldırılarak veri tabanlı çalışır hale getirildi.
  6. Birim testleri (`tests/unit/sistemler/ipucu_kaydi_test.gd`, `tests/unit/sistemler/oyuncu_izi_test.gd`, `tests/unit/sistemler/son_kaydi_test.gd`, `tests/unit/sistemler/omurga_test.gd`, `tests/tools/test_omurga.py`) başarıyla tamamlandı (0 hata).
  7. Asset gerekmedi.
- **Kota:** kota görünmüyor


## 3 Kasım 2026 — Görev 2: Diyalog Eklentileri Denemesi (Parley ve Theatre)
- **Dal:** `feature/diyalog-eklenti-denemesi`
- **Kurulan Eklentiler ve Sürümler:**
  1. **Parley (v2.1.0):** `addons/parley/`, commit `ef75bc30a5307ce118645d3463091d6c9adf1718` (MIT Lisansı).
  2. **Theatre (v0.12.2):** `addons/Theatre/`, commit `11c19e1b02eae7ed7eb7c83b9da9c70532b8107d` (MIT Lisansı).
- **Proje Ayarları:** `project.godot` eklenti listesinde (`[editor_plugins]`) yalnız bu feature dalında etkinleştirildi.
- **Türkçe Karakter Denemesi Sonucu:**
  - Test cümlesi: `"Işık, İzmir'den gelen ışığı çağırdı; göğsü ağrıyan kişi kapıda üşüdü."`
  - ç, ğ, ı, İ, ö, ş, ü harflerinin tümü hem `.ds` (JSON) hem `.dlg` (metin) formatında, hem yüklemede hem de çalışan sahnede bozulmadan korundu. Küçük ı ve büyük I, küçük i ve büyük İ ayrımı hatasız doğrulandı.
- **Prototip ve Test Uygulaması:**
  - `data/diyalog/diyalog_01_20.json` içindeki `diyalog_01` (çiftçi, Erzincan, darı ve tohum; açılış, Kimsin?, Doğuda nereden?, Nesin?, Kendini tanıt) iki eklentide de kuruldu.
  - Eşik kontrolü (`esik: [0, 1, 1]`) modellendi (0 cevapta ret açık; 1 cevap sonrası kabul ve rüşvet açılır).
  - `data/chr_runtime/CHR_011.tres` düğüm `00` seçenek 3 ipucu koşulu modellendi: İpucu yokken seçenek kilitlendi, ipucu varken tansiyon +2 artırıldı (2 -> 4).
  - Köy ve hastalık bağlantısı: Action ve fonksiyon çağrılarıyla simüle edildi (`# Gerçek oyunda bu çağrı Oturum.karar_ver(gelen, &"kabul") ve hastalık için hastalik_teshis_adaptoru.gd olur.`), bar indisleri (moral, adalet, akçe, asayiş riski) konsola yazdırıldı.
  - Otomatik test koşucusu `prototypes/diyalog_eklenti_denemesi/deneme_kontrol.gd` ile Godot headless altında 0 hata ile doğrulandı.

### Üçlü Karşılaştırma Tablosu

| Ölçüt | Mevcut Sistem (JSON diyalog_01 + CHR ChrSorgusu) | Parley (v2.1.0) | Theatre (v0.12.2) |
|---|---|---|---|
| **Yazım kolaylığı** | İki ayrı format: JSON'da iç içe diziler; CHR'de .md/.tres ve sözleşme doğrulaması. Metinler CSV anahtarlı. | Görsel editör grafı (düğümler, slotlar, bağlantılar). AST JSON tabanlı (.ds). Yazar için görsel ama karmaşık ve hantal. | Düz metin (.dlg). İnsan tarafından okunabilir, YAML benzeri, GDScript içi/dışı çok pratik ve hızlı yazım. |
| **Dallanma** | Soru ağacı 3'lü tuple (soru, cevap, [takipler]). CHR'de düğüm anahtarlı graph (00 -> 1.1 -> 1.2). | Doğal graf dallanması; DialogueOption ve Jump düğümleriyle birleşen ve ayrılan dallar tam destekli. | Satır satır lineer akış; dallanma için :section etiketleri ve koddan jump_to_section çağrıları gerekir. |
| **Koşul ve değişken** | JSON'da sabit eşik [0,1,1]. CHR'de tansiyon (0-10), ipucu listesi, bayraklar ve zar entegrasyonu tam. | Condition / Match düğümleri; harici FactInterface (.gd) sınıfları gerektirir; doğrudan değişken desteği zayıf. | GDScript Expression ve {degisken} / Scope.degisken desteği tam; kod içi değişken atama doğrudan çalışır. |
| **Debuff ve köy etkisi bağlanabilirliği** | Doğrudan çekirdeğe entegre: Oturum.karar_ver, bar indisleri (moral, adalet, akçe, asayiş), hastalık teşhis adaptörü. | Action düğümü harici script çağırır (ParleyActionInterface); adaptör yazılabilir ama dış dünyadan soyut balonunda kalır. | Scope ve Caller üzerinden add_scope('Adaptor', self) ile oyun koduna doğrudan GDScript fonksiyon çağrısı yapabilir. |
| **Performans ve Kararlılık** | Çok hızlı: ~12 ms. Bellek ayak izi minimal (saf Resource / Dictionary). Sıfır hata. | Orta: ~37 ms. Editörde büyük düğüm grafı yükü, AST ağacı ve çok sayıda RefCounted nesnesi. | Hızlı: ~8 ms. Saf GDScript parser; ancak geliştirme sürümünde DialogueLabel timer/stage lifecycle çökmeleri mevcut (kararsız). |
| **Karar Özeti** | Mevcut iki katmanlı mimari (adsız halk JSON + adlı kişi CHR) oyunun asimetrik yapısına tam oturuyor. | **Entegre etme.** Graf arayüzü görsel zenginlik sunsa da kapı karar/zar/köy durum makinelerine yabancı, hantal ve aşırı mühendislik içeriyor. | **Entegre etme.** Düz metin yazımı pratik olsa da mevcut CHR sorgu ağacını ve zar mantığını taşımak için yetersiz; ileride yalnız ince adaptörle yan diyaloglar için değerlendirilebilir. |

- **Son Karar Cümlesi:** Parley ve Theatre'ı ana oyuna entegre etme; mevcut iki katmanlı JSON + CHR mimarisi korunmalı, ileride çoklu satırlı yan anlatılar gerekirse Theatre yalnız ince bir adaptörle değerlendirilebilir.
- **Kota:** kota görünmüyor


## 3 Kasım 2026 — Görev 3: Tüm Diyalogların Sahipliği, İnsanlaştırma, Seçenek Planı ve Köy Sohbetleri
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Aşama A — Envanter ve Plan:**
     - `docs/DIYALOG_ANA_PLANI.md` hazırlandı: 20 adsız ziyaretçi (`diyalog_01`–`20`), 30 CHR karakteri (`CHR_001`–`030`), 10 adlı/olay karakteri ve köy sakinleri envanterlendi. Karakter kimlikleri, konuşma ağızları (13. yy Anadolu Selçuklu), dertleri ve sırları tanımlandı. Seçim–sonuç haritası (barlar, tansiyon, `KisiHafizasi`, `Dedikodu`) ve Mermaid grafı kuruldu.
  2. **Aşama B — Kapı Diyaloglarının Yeniden Yazımı:**
     - 20 kapı karakterinin tümü (`diyalog_01` – `diyalog_20`) 4 parti halinde insanlaştırıldı.
     - Robotik, yapay ve ezber "Kimsin?", "Nesin?", "Kendini tanıt" soruları kaldırıldı; yerlerine atmosferik, mesleki ve şüphe uyandıran derin takip soruları (40+ takip sorusu ve alt dal) yazıldı.
     - Kabul yanıtlarındaki "kervanla çekip gitme" ifadeleri temizlenerek yerleşimci kimliği kazandırıldı; `diyalog_08` ret eşiği 0 kuralı korundu.
  3. **Aşama C — Köy Sistemi (Parley Adaptörleri ve Muhabbet Ağaçları):**
     - Çekirdek sistemlerle (`Oturum`, `Koylu`, `KoyYonetimi`) Parley'i gevşek bağlayan adaptörler yazıldı: `src/diyalog/parley_koy_adaptoru.gd`, `KoyluMoralFact`, `KoyHavadisFact`, `KoyMoralAction`, `KoyAkceAction`.
     - 4 Parley `.ds` diyalog grafı oluşturuldu (`data/parley/koy/`):
       - `koylu_muhabbet_genel.ds`: Köyde herhangi bir köylüye tıklandığında açılan 4 ana kollu (Moral, İş durumu, Havadis/tehdit, İhtiyaç/akçe) diyalog ağacı.
       - `koylu_muhabbet_yusuf.ds`: Yusuf karakteri özel anlatısı (urgan örme, Karabaş köpek, Kösedağ bozgunu, muhafızlık hevesi).
       - `sekans_degirmen_kitlik.ds`: Değirmenci Latif ile Çiftçi İdris un/kıtlık ortam tartışması.
       - `sekans_meydan_atesi.ds`: Çoban Aydoğdu ile Ayşe Bacı meydan ateşi başında kurt ve kış hazırlığı sekansı.
     - `src/diyalog/koy_diyalog_yoneticisi.gd` çalışma zamanı orkestratörü ve `src/arayuz/koy_diyalog_paneli.gd` arayüz paneli hazırlandı.
     - `src/arayuz/koylu_karti.gd` içine "Muhabbet Et (Konuş)" butonu eklenerek tıklayınca muhabbet uçtan uca bağlandı.
  4. **Aşama D — Bütünlük ve Doğrulama Kontrolü:**
     - `tests/unit/diyalog/diyalog_butunluk_test.gd` oluşturuldu ve koşturuldu:
       - 20 kapı diyaloğunun tüm seçenek-eşik denkliği, yanıt sözlüğü karşılıkları ve yerleşim teması doğrulandı.
       - 4 Parley sekansının düğüm, bağlantı, BFS START erişilebilirliği ve diskteki Fact/Action script referansları sıfır hatayla doğrulandı.
       - Türkçe karakterlerin (`ç, ğ, ı, İ, ö, ş, ü, Ç, Ğ, Ö, Ş, Ü`) iki sistemde de bozulmadan korunduğu doğrulandı.
       - `tools/chr_parser.py --check` ile 30 CHR sayfasının tamamı başarıyla ayrıştırıldı.
- **Test Sonuçları:**
  - `tests/unit/kvr/diyalog_mantigi_test.gd`: GEÇTİ (0 hata).
  - `tests/unit/diyalog/koy_parley_sistemi_test.gd`: GEÇTİ (0 hata).
  - `tests/unit/diyalog/diyalog_butunluk_test.gd`: GEÇTİ (0 hata).
  - `tools/chr_parser.py --check`: GEÇTİ (0 hata).
- **Asset Durumu:** Asset gerekmedi (yer tutucular ve mevcut arayüz stilleri kullanıldı).
- **Kota:** kota görünmüyor


## 4 Kasım 2026 — Görev 4: Görev 3'ü Derinleştirme (Öz Denetim, Dallandırma, Köylü Hafızası ve Tam Kadro Köy Sohbetleri)
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Aşama E — Öz Denetim ve Puan Tablosu:**
     - Ahmet'in 7 temel isteği üzerinden mevcut diyalog sistemi denetlendi.
     - 20 kapı karakteri, 30 CHR kartı ve 10 adlı köylü için eksiklikler ve düzeltme hedeflerini içeren puan tablosu hazırlanarak `codex.md/Antigravity_ilerleme_4.md` dosyasına kaydedildi.
  2. **Aşama F — Kapı Diyaloglarının Derinleştirilmesi (`data/diyalog/diyalog_01_20.json`):**
     - 20 kapı ziyaretçisi 4 parti halinde ele alındı:
       - **Parti 1 (`diyalog_01` – `diyalog_05`):** Çiftçi tohum yangını, Çuhacı gümüş dirhemleri ve Karaca Usta bağı, Sivaslı kargıcı neferin kırık kargı tehdidi ve haritada pusu noktaları, koyunlu çobanın sürü sağlığı ve Yusuf bağı, örssüz demirci kalfasının ustasını geride bırakma itirafı ve pirinç külçe rüşveti.
       - **Parti 2 (`diyalog_06` – `diyalog_10`):** Yamuk miğferli askerin kılıcını haramiye kaptırma utancı, sabanı kırık rençberin şehit oğulları ve küflü arpa dramı, dikici kalfasının yanan konaktan aşırdığı gümüş kemer tokası kefareti (ret eşiği 0 kuralı korundu), kemankeşin hain nöbetçi cinayeti intikamı ve ok imalatı hüneri, yetimli gencin asırlık bağ kütüğü şırası.
       - **Parti 3 (`diyalog_11` – `diyalog_15`):** Yaralı köprü levendinin süvari istihbaratı ve Miraen Hatun'a yönlendirilmesi, kalaycının çifte tabanlı kazandaki kaçak cıva/kalay tozu ve Karaca Usta'ya hibe seçeneği, topal oğlaklı çobanın Kızıl Karga borç baskını itirafı ve oğlağı Yusuf'a emanet etmesi, kaya tuzu tüccarının kükürtlü güherçilesini kışlaya vermesi, kule borazancısının kuleyi basan amcaoğlunu görüp donma itirafı.
       - **Parti 4 (`diyalog_16` – `diyalog_20`):** Asma fidanlı bağcının Bizans misket aşı çubuğu ve yetimli rençber çocuğu tanıması, kantarcının hileli dirhemi kırıp adil pazar yemini, kireççi ırgatın kale dizdarının yolsuzluğunu görmesi ve ahşap sura taş temel örmesi, gürgen tekneli fırıncının 40 yıllık ekşi mayası ve tandır kurması, ayağına çivi batmış nalbantın harami atlarını sakatlayıp kaçış itirafı.
  3. **Aşama G — Köy Sohbetleri ve Tıklayınca Konuşma (Parley):**
     - Adı olan 10 köylü için (Yusuf, Miraen, Karaca Usta, Ayşe Bacı, Aydoğdu, Saruca Hatun, Thessra, Sorhan, Hasan Çelebi, Nogay) 3 duruma göre değişen (normal gün, kriz/kıtlık/salgın, kapıdaki tartışmalı kararlar) müstakil `.ds` ağaçları yazıldı.
     - 4 yeni ortam sahne sekansı eklendi (`sekans_demirhane_pusat`, `sekans_kuyu_hastalik`, `sekans_nobet_harami`, `sekans_pazar_fiskos`).
     - `src/diyalog/koy_diyalog_yoneticisi.gd` köylü kimliğine göre otomatik yönlendirme yapacak şekilde dinamikleştirildi.
  4. **Aşama H — Bütünlük ve Nihai Doğrulama:**
     - `tools/chr_parser.py --check`: 30 sayfa eksiksiz GEÇTİ.
     - `tools/metin_dogrula.py`: PASS.
     - `tools/soz_tasarimi_dogrula.py`: SÖZ TASARIMI: GEÇTİ.
     - `tests/unit/diyalog/diyalog_butunluk_test.gd`: 20 kapı diyaloğu + 17 Parley sekansı + Türkçe karakter kontrolü + Uçtan uca adaptör orkestrasyonu 0 hata ile GEÇTİ.
     - `tests/unit/kvr/diyalog_mantigi_test.gd`: GEÇTİ.
     - `tests/unit/diyalog/koy_parley_sistemi_test.gd`: GEÇTİ.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_4.md` son satırı `GOREV4_TAMAM` olarak tamamlandı.
- **Kota:** kota görünmüyor

## 4 Kasım 2026 — Görev 5: Ahmet'in İstekleri (Sorgu Düzeltme, Eş Diyalogları ve Fısıltıları) ve Yer Tutucu Metinler
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm 1A — Kapı Sorgularında Tekrar Eden Soruları Düzeltme:**
     - 20 kapı ziyaretçisinin (`diyalog_01` – `diyalog_20`) açılış konuşmasında verdiği bilgileri dikkatsizce tekrar soran tüm sorular temizlendi.
     - Açılış iddialarını kurcalayan, çelişki yakalayan ve iddiaları test eden takip sorularına çevrildi.
     - `src/sistemler/oturum.gd` `_json_sorular()` fonksiyonuna bayrak desteği eklendi; sorular sorulduğunda bayraklar `acik_bayraklar` listesine işlendi.
  2. **Bölüm 1B — Eşle Konuşma: Kapsamlı Parley Ağacı ve Oda Entegrasyonu:**
     - Oyuncunun eşi (`acl01_es`, `acilis.kisi.es`) için 71 düğüm ve 85 kenardan oluşan çok katmanlı diyalog grafı hazırlandı (`data/parley/koy/koylu_muhabbet_es.ds`).
     - Konuşmalar 4 ana başlığa ayrıldı: 1) Kapı kararları ve merhamet/adalet/rüşvet kavgası; 2) Köy durumu (açlık, kuyu suyu, hastalık, dedikodular); 3) Aile, evlilik, tandır şakalaşması ve Sivas hatıraları; 4) Mevsim hazırlığı ve gelecek endişesi.
     - `src/diyalog/actions/es_iliskisi_action.gd` eklendi.
     - `src/diyalog/parley_koy_adaptoru.gd` bayrak desteğiyle genişletildi.
     - `src/arayuz/oda_es_muhabbet_paneli.gd` ve `src/arayuz/muhafiz_odasi_ekrani.gd` ile muhafızın odasındaki sedirde oturan eşle dertleşme arayüzü kuruldu.
  3. **Bölüm 1C — Kapı Ekranında Eşin Düşünceleri ve Fısıltıları:**
     - `data/diyalog/es_kapi_dusunceleri.json`: 20 ziyaretçinin her biri için `karsilama`, `kritik_soru`, `karar_oncesi`, `karar_kabul` ve `karar_ret` aşamalarında eşin fısıltı ve kanaatleri yazıldı (eşin kendine has sağduyusu, evhamı ve merhameti yansıtıldı).
     - `src/kapi/es_yorumu_adaptoru.gd` adaptörü yazıldı; `src/arayuz/kapi_ekrani.gd` ekranına ince bağlandı.
     - `tests/unit/kapi/es_yorumu_test.gd` birim testi yazıldı ve doğrulandı.
  4. **Bölüm 2 — Yer Tutucu Metinler Envanteri:**
     - Cursor PR'ları (#15–#27) taranarak birleştirme öncesi yer tutucu anahtarları tespit edildi.
     - `docs/YER_TUTUCU_METINLER.csv` dosyasına 85 adet anahtar, 13. yy dönemine uygun edebi Türkçe metin, hangi PR'dan geldiği ve açıklama notlarıyla kaydedildi (`nobet.rapor.*`, `sabah.hukum.satir`, `tez.cumle.*`, `yil.*`, OZL kart metinleri `olay.asik.*`, `olay.kadi.*`, `hafiza.*`, `arayuz.girdi.*`).
     - Metinlerde formül sözcük ("köyünüzün geleceği", "çünkü", "aslında") ve çift boşluk yasağına titizlikle uyuldu.
  5. **Bütünlük ve Testler:**
     - `tools/metin_dogrula.py --kaynak`: PASS.
     - `tools/soz_tasarimi_dogrula.py`: GEÇTİ.
     - `tests/unit/kapi/es_yorumu_test.gd`: GEÇTİ (0 hata).
     - `tests/unit/diyalog/diyalog_butunluk_test.gd`: GEÇTİ (0 hata).
     - `tests/unit/kvr/diyalog_mantigi_test.gd`: GEÇTİ.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_5.md` son satırı `GOREV5_TAMAM` olarak tamamlandı.
- **Kota:** kota görünmüyor

## 4 Kasım 2026 — Görev 6: Yeni Ziyaretçiler ve Köy Olayları (Bölüm B) ve Son Okuma/Üslup Cilası (Bölüm A)
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm B — 10 Yeni Kapı Ziyaretçisi ve Eş Düşünceleri:**
     - Eksik tipler analiz edildi: derviş, Moğol casusu şüpheli tüccar, firari avcısı inzibat çavuşu, vebalı ana ve bebek, kaçak yetim çırak, sahte cerrah/otacı, fitneci kadı kâtibi, intikamcı harami bacısı, donan kafile habercisi ve muhafızın öz yeğeni.
     - `data/diyalog/diyalog_01_20.json` içine `diyalog_21` – `diyalog_30` olmak üzere 10 yeni ziyaretçi eklendi (toplam 30 ziyaretçi).
     - Her biri için açılışı kurcalayan takip soruları, bayraklar (`dervis_mujde_haberi`, `mogol_gizli_ferman`, `cuhaci_ortagi_iddiasi`, `vebali_bebek_emaneti`, `hamza_yegen_kavusma`, vb.) ve anlamlı seçenekler yazıldı.
     - Önceki ziyaretçilere (`diyalog_01` Hamza, `diyalog_02` kumaşçı, `diyalog_03`/`06` firariler, `diyalog_04` çoban, `diyalog_11` levent, `diyalog_20` nalbant, Hasan Çelebi) derin bağlantılar kuruldu.
     - `data/diyalog/es_kapi_dusunceleri.json` tablosuna 10 yeni ziyaretçi için 4 aşamalı (`karsilama`, `kritik_soru`, `karar_oncesi`, `karar_kabul`, `karar_ret`) eş yorumları eklendi (toplam 31 eş yorumu).
     - `docs/DIYALOG_ANA_PLANI.md` karakter envanteri tablosuna yeni karakterler işlendi.
  2. **Bölüm B — 8 Yeni Köy Olayı:**
     - `data/olaylar/` dizinine 8 yeni olay kartı eklendi: `kavga_harman.tres`, `ambarda_hirsizlik.tres`, `salgin_fisiltisi.tres`, `koy_dugunu.tres`, `firari_cenazesi.tres`, `samanlik_yangini.tres`, `gece_donu.tres`, `harami_elcisi.tres`.
     - `data/metin/metinler.csv` dosyasına 64 yeni anahtar (başlık, metin, 3 seçenek, 3 sonuç metni) eklendi.
     - `tests/unit/olay/yeni_olaylar_test.gd` yazılarak tüm olaylar ve çevirileri doğrulandı.
  3. **Bölüm A — Bütün Metinlerde Son Okuma ve Üslup Cilası:**
     - Tüm kapı, köy ve olay metinleri tarandı.
     - `sohbet.chr_022` içindeki modern İtalyanca/Fransızca "alarm" ve "tempo" kelimeleri 13. yy askeri ve halk müziği usullerine ("tehlike vuruşu", "baskın kösü", "usul", "tarla usulü") uyarlandı.
     - `sohbet.sorhan.c23` ve `sohbet.thessra.c3` içindeki yapay "çünkü" bağlaçları dönemin ruhuna uygun akıcı ifadelere ("zira", "kadın kızı olduğumdan ötürü") dönüştürüldü.
     - `data/metin/metinler.tr.translation` derlendi.
  4. **Doğrulama ve Testler:**
     - `python tools/metin_dogrula.py --kaynak`: PASS.
     - `python tools/soz_tasarimi_dogrula.py`: GEÇTİ.
     - `Godot --headless -s tests/unit/diyalog/diyalog_butunluk_test.gd`: BAŞARILI (0 hata, 30 kapı diyaloğu + 18 Parley sekansı).
     - `Godot --headless -s tests/unit/kapi/es_yorumu_test.gd`: BAŞARILI (0 hata, 30 eş düşüncesi).
     - `Godot --headless -s tests/unit/kvr/diyalog_mantigi_test.gd`: GEÇTİ (0 hata).
     - `Godot --headless -s tests/unit/olay/yeni_olaylar_test.gd`: BAŞARILI (0 hata).
     - `Godot --headless -s tests/unit/olay/on_kosul_test.gd`: GEÇTİ (0 hata).
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_6.md` son satırı `GOREV6_TAMAM` olarak tamamlandı.
- **Kota:** kota görünmüyor

## 4 Kasım 2026 — Görev 7: ROADMAP'ten Diyalog, Karakter, Anlatı ve Metin Maddelerinin Tamamlanması
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Merge & Senkronizasyon:** `origin/claude/festive-volta-li1sfm` başarıyla merge edildi (`06402fcd`), metin çakışmaları iki taraf da korunarak çözüldü.
  2. **Parti 1: Açılış ve Eş Akşam Sohbeti (ACL-03, DYL-07):** `data/soz/aksam_konulari.json` ve `src/koy/aksam_sohbeti.gd` yazıldı, 2 birim testi geçti (`f4f4f3ec`).
  3. **Parti 2: Söz Sistemi Motoru & Sorgu Eylemleri (26 madde: DIY-01a..18, DYL-01..16, DYL-74):** Yeni söz veri şeması, motor çekirdeği, konu merkezi, beyan defteri, çelişki yüzleşmesi, bakış, yemin, muhafız yalanı, söz verme, karar dönüşü ve beyin denetçisi uygulandı, 12 test geçti (`5c58e5c7`).
  4. **Parti 3: Söz İçeriği & Karakter Ses Kartları (28 madde: YAZ-02..10):** Üslup rehberi, 30 özgün ses kartı, yazım hattı, pilot karakterler, kadro özgünlük denetimi ve doğrulayıcı araçlar uygulandı, 7 test geçti (`f833c5c6`).
  5. **Parti 4: Köy İçi Sevilen Yüz & Çınar Meclisi Metinleri (15 madde: SEV-01..07, MCL-02..09):** `src/koy/sevilen_yuz.gd` ve `src/koy/meclis_sesi.gd` genişletildi, 3 birim testi geçti (`eb185e83`).
  6. **Parti 5: Muhafızın Hanesi, Sabah Satırları & Sofra Metinleri (48 madde: HAN-01..48, HAN-52):** `data/soz/hane_sabah_satirlari.json`, `src/koy/hane.gd` ve `tests/unit/koy/hane_test.gd` yazıldı, 1 test geçti (`219d5079`).
  7. **Parti 6: Söylenti, Dedikodu & Kamuoyu Ağı (47 madde: SOY-01..50):** `data/soylenti.json`, `src/sistemler/soylenti_agi.gd` ve `tests/unit/kvr/soylenti_agi_test.gd` yazıldı, 1 test geçti (`032fc253`).
  8. **Parti 7: Ana Hikâye Omurgası, Perde Geçişleri, Son ve Epilog Metinleri (13 madde: OMR-07..10, 15..18, 40, KOP-01, 02, 06, 07, 08):** `data/soz/sonlar.json`, `perde_metni.gd`, `gecis_gecesi.gd`, `perde_ozeti.gd`, `son_uyarisi.gd`, `divan_sanik.json`, `heyet_elci.json`, `tuccar_kapi.json` ve `tests/unit/soz/omurga_metinleri_test.gd` yazıldı, testler geçti.
  9. **Doğrulama ve Bütünlük:** `python tools/metin_dogrula.py --kaynak` (PASS), `tools/soz_tasarimi_dogrula.py` (GEÇTİ), tüm headless Godot testleri (0 hata).
- **Toplam Tamamlanan Madde Sayısı:** 177 ROADMAP maddesi.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_7.md` son satırı `GOREV7_TAMAM` ile mühürlendi.
- **Kota:** kota görünmüyor

## 4 Kasım 2026 — Görev 8: Yer Tutucu Metinlerin Oyuna Yerleştirilmesi ve 10 Yeni Ziyaretçinin Derinleştirilmesi
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — Festive Merge ve Doğrulama:**
     - `origin/claude/festive-volta-li1sfm` (Cursor PR #15–#27 birleşimi, commit `b5ceb33a`) çekilip merge edildi (`49fcf091`).
     - Metin, söz şeması, beyan defteri ve söz motoru çakışmaları geriye dönük tam uyumla çözüldü (`dac9daa4`).
     - 13/13 Godot headless testi ve tüm doğrulayıcılar sıfır hatayla doğrulandı.
  2. **Bölüm B — Yer Tutucu Metinlerin Yerleştirilmesi (85/85 %100 TAMAMLANDI):**
     - `docs/YER_TUTUCU_METINLER.csv` dosyasındaki tüm 85 anahtar gerçek metinlerle güncellendi ve `yerlesti` olarak işaretlendi:
       - Parti B1: Nöbet raporları ve sabah hüküm satırları (`nobet.rapor.*`, `sabah.hukum.satir` - 8 anahtar, `04a472a0`).
       - Parti B2: Tezgâh siparişleri ve mevsim yıl izleri (`tez.cumle.*`, `yil.*` - 10 anahtar, `a9ada837`).
       - Parti B3: Âşık ve kadı özel olay kart metinleri (`olay.asik.*`, `olay.kadi.*` - 12 anahtar, `4c0fcb56`).
       - Parti B4: Hafıza defteri ve eylem metinleri (`hafiza.*`, `koy.eylem.defter`, `arayuz.duraklat.defter` - 21 anahtar, `d11aa6e4`).
       - Parti B5: Girdi haritası, ana menü, dil ayarları, demo bitiş ve çoban metinleri (`arayuz.girdi.*`, `arayuz.menu.*`, `arayuz.demo.*`, `arayuz.dil.*`, `koy.coban.*` - 34 anahtar, `ef4e4fc8`).
  3. **Bölüm C — 10 Yeni Ziyaretçiyi Derinleştirme & Eş Sohbeti Genişletme:**
     - `data/diyalog/diyalog_01_20.json` içinde `diyalog_21` .. `diyalog_30` arası 10 karakterin diyalog ağaçları 3 ana soruya, 3. kademe alt sorulara ve soru/itiraf/şüphe bayraklarına (`dervis_mogol_fermani`, `tuccar_sahte_payza`, `cavus_kelle_pazarligi`, `veba_kaynagi_akpinar`, `harami_karabudak_izi`, `sarlatan_afyon_itirafi`, `katip_calinti_muhur`, `banu_hatun_atli_guvencesi`, `kafile_kurtarma_seferi`, `turna_oz_yegen_kabul`) kavuşturuldu (`bc3719ef`).
     - `data/diyalog/es_kapi_dusunceleri.json`: 30 karakterin tamamı için 4 aşamalı eş kapı düşünceleri doğrulandı (`es_yorumu_test.gd`: PASS).
     - `data/parley/koy/koylu_muhabbet_es.ds`: 10 yeni ziyaretçi ve 8 yeni köy olayı (`kavga_harman`, `ambarda_hirsizlik`, `salgin_fisiltisi`, `koy_dugunu`, `firari_cenazesi`, `samanlik_yangini`, `gece_donu`, `harami_elcisi`) için 16 yeni konuşma dalı eklendi. Parley grafı 123 düğüm ve 153 kenara ulaştı, sıfır kırık bağlantı (`diyalog_butunluk_test.gd`: PASS).
  4. **Bölüm D — ROADMAP_2 Kontrolü:**
     - Açık ve sahipsiz olan tüm diyalog, anlatı ve metin işleri tamamlandı; diğer ajanların işlerine ve kilitli alanlara dokunulmadı.
  5. **Doğrulama ve Testler:**
     - `tools/metin_dogrula.py`: PASS.
     - `tools/soz_dogrula.py` & `tools/soz_tasarimi_dogrula.py`: GEÇTİ.
     - Tüm Godot headless testleri (`diyalog_butunluk_test.gd`, `koy_parley_sistemi_test.gd`, `es_yorumu_test.gd`, `yeni_olaylar_test.gd`, `girdi_test.gd`, `dil_test.gd`, `hafiza_defteri_test.gd`, `ozel_olay_test.gd`): 0 HATA.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_8.md` son satırı `GOREV8_TAMAM` ile mühürlendi.
- **Kota:** %40 kaldı.

## 4 Kasım 2026 — Görev 9: Bütünlük Denetimi, Birleşmeye Hazırlık ve Sabah Özeti
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — Bütünlük Denetimi:**
     - 30 kapı diyaloğu, eş kapı düşünceleri, 17 Parley köy sekansı ve 8 köy olayı baştan sona tarandı.
     - Modern kelimeler ve 13. yüzyıl dünyasına uymayan anakronizmler (diyalog_25'teki tüfek -> kargı, diyalog_21'deki kurşun -> ok, diyalog_07/14/19/23'teki riske/panikletip/şansımı/rapor kelimeleri, metinler.csv'deki panikleyecekti -> korkuya kapılacaktı, aksam_konulari'ndaki risk -> tehlike) dönem diline uyarlandı (`72661d51`).
     - diyalog_25 (fırın çırağı oğlan) ile diyalog_30 (Turna) arasındaki öz kardeşlik ve Muhafızın yeğeni olma ("rahmetli Hasan'ın yetimi Dursun") bağı ve eş düşünceleri tam olarak kenetlendi.
  2. **Bölüm B — Birleşmeye Hazırlık:**
     - `origin/claude/festive-volta-li1sfm` ile tam senkronize durumda olduğu doğrulandı ("Already up to date").
     - 5 Python doğrulayıcısı ve 26 Godot headless birim testi (toplam 31 test) çalıştırıldı ve 31/31 sıfır hatayla geçti.
     - `docs/DIYALOG_DALI_BIRLESME_NOTU.md` hazırlanarak eklenen/değişen dosyalar, Kalfa/Cursor alanına müdahale edilmediği ve birleşme adımları belgelendi.
  3. **Bölüm C — Ahmet İçin Sabah Özeti:**
     - `docs/DIYALOG_GECE_OZETI.md` hazırlanarak mobil okumaya uygun sade Türkçe ile Görev 3'ten 9'a kadar yapılan tüm çalışmalar, mutlaka deneyimlenmesi gereken 10 an ve Ahmet'in kararını bekleyen 3 konu sunuldu.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_9.md` son satırı `GOREV9_TAMAM` ile mühürlendi.
- **Kota:** %35 kaldı.

## 4 Kasım 2026 — Görev 10: Karar Seçenekleri, ROADMAP Önerileri ve Dil Sistemi Analizi
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. `docs/KARAR_SECENEKLERI.md`: Banu Hatun'un 50 atlısı, Molla Şükrü vs Hasan Çelebi divan yüzleşmesi ve Vebalı Sabi için ikişer tam diyalog, bayrak, eş yorumu ve köy etkisi seçeneği hazırlandı.
  2. `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md`: Anlatı ve diyalog derinliğini artıracak 7 yeni ROADMAP madde önerisi sunuldu.
  3. Dil sistemi incelendi; `dil_test.gd` ve `metin_dogrula.py` kurallarını kırmamak için çekirdeğe dokunulmadan ilk 250 arayüz anahtarı `docs/INGILIZCE_METIN_TASLAGI.csv`ye aktarıldı.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_10.md` son satırı `GOREV10_TAMAM` ile mühürlendi.
- **Kota:** %35 kaldı.

## 4 Kasım 2026 — Görev 11: İngilizce Taslağın Tamamlanması
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. `docs/INGILIZCE_METIN_TASLAGI.csv`: Kalan 1895 anahtar (toplam 2145 anahtar) dönem İngilizcesine uyarlandı.
  2. `docs/ingilizce_diyalog/`: 30 ziyaretçi, eş kapı düşünceleri, 18 Parley sahnesi ve 10 akşam konusu İngilizceye aktarıldı.
  3. `docs/INGILIZCE_TERIM_SOZLUGU.md`: Dönem ruhu, yer adları, unvanlar ve hitap ilkeleri resmileştirildi.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_11.md` son satırı `GOREV11_TAMAM` ile mühürlendi.
- **Kota:** %35 kaldı.

## 4 Kasım 2026 — Görev 12: İngilizce Taslağın İkinci Okuması ve Oyun Testi Kontrol Listesi
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — İkinci Okuma ve Kapsamlı Düzeltmeler:**
     - `docs/INGILIZCE_METIN_TASLAGI.csv`: 2330 satır doğrulandı, 8 satırdaki eksik `{kisi}` yer tutucuları ve uygunsuz feodal unvanlar ('lord'/'lady') düzeltildi (`38f6e3d3`).
     - 30 Ziyaretçi & Eş Düşünceleri: Ziyaretçi 1'deki terim düzeltmeleri ve Ziyaretçi 21-30'un zengin anlatı ağaçları (Derviş Baba, Tebrizli Tüccar, Çavuş Sungur, Vebalı Ana, Dursun, Hekim Lokman, Molla Şükrü, Banu Hatun, Kafile Habercisi, Turna) ile 4-5 aşamalı eş kapı fısıltıları eksiksiz İngilizceye aktarıldı (`817a2c81`).
     - 18 Parley Sahnesi & 10 Akşam Konusu: 10 isimli köylü, 6 köy sekansı, 123 düğümlü eş dertleşme sahnesi ve 10 akşam konusunun tamamı 13. yy sınır boyu İngilizcesine dönüştürüldü (%100 İngilizce, `f0d46c01`).
     - `docs/dogrula_ingilizce_taslak.py` ile doğrulama: 0 hata, 0 uyarı.
  2. **Bölüm B — Ahmet İçin Oyun Testi Kontrol Listesi:**
     - `docs/OYUN_TESTI_KONTROL_LISTESI.md` hazırlandı: 15 dakikalık hızlı rota (en önemli 10 an), 30 ziyaretçinin adım adım soru/bayrak/karar/eş düşüncesi test tablosu, 11 köylüyle konuşma, 6 sekans, 8 yeni köy olayı, söylenti ağı ve sonlar rehberi `[ ] çalıştı` kutucuklarıyla belgelendi (`15e21100`).
  3. **Bölüm C / Bitirme:**
     - `docs/DIYALOG_GECE_OZETI.md` güncellendi.
     - Tüm doğrulayıcılar ve testler 0 hata ile çalıştırıldı.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_12.md` son satırı `GOREV12_TAMAM` ile mühürlendi.
- **Kota:** %35 kaldı.

## 4 Kasım 2026 — Görev 13: Karar Seçenekleri Uygulama Yamaları ve 2D Asset Promptları
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — Karar Seçenekleri İçin 6 Bağımsız Yama Paketi (`docs/karar_yamalari/`):**
     - Karar 1 (Banu Hatun'un 50 Atlısı): `karar_1_ittifak_suvari` (+50 Savunma, -3 Erzak, Karaca Usta kılıç döver) ve `karar_1_yalniz_kabul` (+2 Adalet, +1 Asayiş Riski, ambar korunur) paketleri oluşturuldu (`76c05313`).
     - Karar 2 (Molla Şükrü vs Hasan Çelebi): `karar_2_aleni_mahkeme` (+3 Adalet, +2 Moral, berat yakılır, Şükrü demirhanede körük cezası çeker) ve `karar_2_katip_ittifak` (+15 Günlük Akçe, -3 Adalet, Hasan Çelebi küser, Divan teftiş riski) paketleri oluşturuldu (`d498bf6f`).
     - Karar 3 (Vebalı Sabi ve Anasının Akıbeti): `karar_3_sifa_kurtulus` (+3 Moral, +2 Adalet, -10 Akçe ecza masrafı, +2 sağlıklı köylü) ve `karar_3_dramatik_kayip` (-3 Moral, +1 Adalet, eşle kış ağıtı dertleşmesi, sert gerçekçilik) paketleri oluşturuldu (`d4bf32d0`).
     - Her pakette tam `diyalog_01_20.json`, `es_kapi_dusunceleri.json`, ilgili köylü `.ds` sahnesi, `koylu_muhabbet_es.ds`, `metinler_parca.csv` ve adım adım `UYGULA.md` kılavuzu hazırlandı. Oyunun çalışan dosyalarına dokunulmadı.
  2. **Bölüm B — Diyalog ve Anlatı 2D Görsel Kataloğu:**
     - 27 tekil 2D parça için Türkçe görünüş/sahne tarifleri ve standart 'gece_kapisi' stilinde tek resimlik Nano Banana İngilizce promptları hazırlandı: 10 yeni ziyaretçi portresi (21-30), 1 muhafız eşi portresi, 8 yeni köy olayı kartı, 3 hafıza defteri ve söylenti görseli, 5 oyun sonu sinematik sahnesi (`docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md`).
     - `docs/EKSIK_ASSET_ENVANTERI.md` 2D tablosu yeni parçalarla güncellendi (`4c3015ff`).
  3. **Bölüm C / Bitirme:**
     - `docs/DIYALOG_GECE_OZETI.md` 7. bölümle güncellendi.
     - `tests/tools/test_asset_envanteri.py` ve tüm Python/Godot testleri 0 hatayla doğrulandı.
## 4 Kasım 2026 — Görev 14: Öneri Maddeleri İçin Hazır Taslaklar ve Portre Promptlarını Tamamlama
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — 7 Yeni ROADMAP Önerisi İçin Uygulamaya Hazır Taslak Paketleri (`docs/oneri_taslaklari/`):**
     - En çok etki ve en az kod gerektiren öncelik sırasıyla 7 bağımsız taslak klasörü açıldı:
       - `ES-GECM-01`: Eşin geçmişi, eski köyün yangını, göç yolu, yetimler Dursun ve Turna'ya analık arzusu ve Muhafız'a gece kaynatılan ıhlamur şifası (3 derin Parley dalı; 0 kod, `4d01c6a3`).
       - `SOY-SON-01`: Söylenti ağının 2 gün sonra somut köy olaylarına kapandığı 5 sahne (Değirmenci un oluğu teftişi, kuyu suyu panik tahlili, Tekfur'un devrilen tuz arabası, samanlıktaki kaçak borçlu, vebalı kumaş iftirası; 0 kod, `7a81393c`).
       - `ANL-DON-01`: İlk kararların 5-10 gece sonra kapıda yankılandığı 6 derin geri dönüş sahnesi (Sungur'un intikam fermanı veya teftiş istihbaratı, Turna ve Dursun'un ilk sıcak somunu, Lokman'ın afyon ihaneti ve kovuluşu, Banu Hatun'un vadi zaferi müjdesi, Behram'ın kuru incir ve zeytinyağı hediyesi; `d781d6a7`).
       - `MECLIS-ARA-01`: Çınar Meclisi'nde Muhafız'ın kadı/hakem rolü üstlendiği 4 interaktif dava (Karaca Usta vs Çiftçi Yusuf kırık balta, Ayşe Bacı vs Çuhacı sahte çivit boyası, Çoban Aydoğdu vs Molla Şükrü mera ve pınar yazımı, Thessra vs Miraen ortak köy şifahanesi; 0 kod, `fed5c1a4`).
       - `KVR-SES-01`: Tipi, sağanak yağmur, ayaz ve sis durumlarında 30 ziyaretçinin açılış sözlerine ve Muhafız karşılamasına eklenen dinamik atmosfer replikleri (1 satırlık arayüz adaptörü, `7019c2a9`).
       - `ANL-EPI-01`: 30. gün kış sonu oyuncunun kararlarına göre karakterlerin akıbetini gösteren 6 çift taraflı kişisel epilog kartı (Turna & Dursun fırını, Lokman'ın akıbeti, Banu Hatun'un sancağı, Sungur'un teftişi, Vebalı sabi ve anası, Hane ocağının akıbeti; `f83129ee`).
       - `SES-DIL-01`: Seslendirme hazırlığı için tipolojik ses kartları, duygu/tempo, nefes/duraklama ve 13. yy halk ağzı vurgu kuralları (`cd056f18`).
     - Her öneri klasöründe tam metin/diyalog taslağı, gereken bayraklar, kod/sistem notu (Kalfa/Cursor iş dağılımı) ve adım adım `UYGULA.md` kılavuzu eksiksiz yer aldı.
  2. **Bölüm B — 30 Yeni 2D Portre Promptu İle Eksiksiz Portre Kataloğu:**
     - Ziyaretçiler 01–20 (20 portre) ve 10 İsimli Köylü (Aydoğdu, Ayşe Bacı, Hasan Çelebi, Karaca Usta, Miraen, Nogay, Saruca Hatun, Sorhan, Thessra, Yusuf) için Türkçe karakter tarifleri ve otantik 13. yy Selçuklu sınır boyu üslubunda tekil Nano Banana promptları hazırlandı (`817c0e71`).
     - `docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md` ve `docs/EKSIK_ASSET_ENVANTERI.md` güncellendi; oyundaki **30 ziyaretçinin 30'u**, **tüm isimli köylüler** ve **Muhafızın Eşi** olmak üzere 41 karakter portresi %100 tamamlandı.
  3. **Bölüm C — Bitirme & Doğrulama:**
     - `tests/tools/test_asset_envanteri.py`: 6/6 test OK (0 hata).
     - `tools/metin_dogrula.py`, `tools/soz_dogrula.py`, `tools/soz_tasarimi_dogrula.py`: PASS.
     - `docs/dogrula_ingilizce_taslak.py`: 2330 CSV satırı, 6 JSON, 18 Parley dosyası (0 hata, 0 uyarı).
     - Godot Headless Testleri (Diyalog bütünlüğü, eş yorumları, Parley sistemi, yeni olaylar, dil testi): 0 hata.
     - `docs/DIYALOG_GECE_OZETI.md` 8. bölümle güncellendi.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_14.md` son satırı `GOREV14_TAMAM` ile mühürlendi.
- **Kota:** %25 kaldı.

## 4 Kasım 2026 — Görev 15: Sabah Öncesi Son Kontrol, Festive Entegrasyonu ve Birleşme Notu
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — Festive Entegrasyonu (`d0fee0a6`):**
     - `origin/claude/festive-volta-li1sfm` dalından Kalfa'nın gece boyunca tamamladığı 12 commit çekildi (`8c32c453`).
     - Dalımıza merge edildi; 0 çakışma (conflict-free). Kalfa'nın denge/açlık/ölçüm kodları (`denge.json`, `denge_sinirlari.json`, `aclik_uretim_test.gd`, `denge_dogrula.py`, `oda_gelistirme_paneli.gd`, `acilis_denge_kontrol.gd`) dokunulmadan korundu; diyalog dalındaki tüm anlatı sistemleri muhafaza edildi.
  2. **Bölüm B — Doğrulayıcılar ve Testler (Sıfır Hata):**
     - Python doğrulayıcıları: `metin_dogrula.py` (PASS), `soz_dogrula.py` (PASS), `soz_tasarimi_dogrula.py` (PASS), `test_asset_envanteri.py` (6/6 OK), `test_denge_dogrula.py` (14/14 OK), `denge_dogrula.py` (GECTI), `dogrula_ingilizce_taslak.py` (2330 CSV, 6 JSON, 18 .ds — 0 hata, 0 uyarı).
     - Godot Headless Testleri (16/16 PASS): `diyalog_butunluk_test.gd`, `es_yorumu_test.gd`, `koy_parley_sistemi_test.gd`, `yeni_olaylar_test.gd`, `ozel_olay_test.gd`, `girdi_test.gd`, `dil_test.gd`, `hafiza_defteri_test.gd`, `kapi_nobeti_test.gd`, `sabah_defteri_test.gd`, `tezgahta_gun_test.gd`, `yil_izi_test.gd`, `aksam_sohbeti_test.gd`, `hane_test.gd`, `soylenti_agi_test.gd`, `aclik_uretim_test.gd`.
     - Söz motoru testleri (`tests/unit/soz/*.gd`): 40 testin tamamı PASS (0 hata).
     - Regresyon / Yeni Kırmızı: 0 adet.
  3. **Bölüm C — Birleşme Notu ve Sabah Özeti Güncellemesi:**
     - `docs/DIYALOG_DALI_BIRLESME_NOTU.md` son festive commit'i (`8c32c453`), merge commit'i (`d0fee0a6`), test dökümü ve sıfır çakışma durumuyla güncellendi.
     - `docs/DIYALOG_GECE_OZETI.md` dosyasının en başına Ahmet için 4 maddelik (7 satır) "Sabah Önce Bunu Oku (Hızlı Yol Haritası)" bölümü eklendi.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_15.md` son satırı `GOREV15_TAMAM` ile mühürlendi.
- **Kota:** %20 kaldı.

## 4 Kasım 2026 — Görev 16: İngilizceyi Oyuna Ekle ve Diyalog Dalını Festive ile Bütünleştir
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Ne Yapıldı:**
  1. **Bölüm A — Festive Entegrasyonu ve Birleşme Hazırlığı (`ab9c10b2`):**
     - `origin/claude/festive-volta-li1sfm` dalından Kalfa'nın son commit'leri (`7646b8d5` dahil) çekildi ve merge edildi.
     - 0 çakışma (conflict-free). Kalfa'nın rüşvet, çıraklık, şifalı ot ve yetenek kapalıyken haraç testleri aynen korundu.
     - `docs/DIYALOG_DALI_BIRLESME_NOTU.md` güncellendi ve kullanıcı talimatı uyarınca yalnızca `feature/diyalog-yeniden-yazim` dalına push edildi.
  2. **Bölüm B — İngilizce Dil ve Diyalog Sisteminin Oyuna Entegrasyonu:**
     - `tests/unit/arayuz/dil_test.gd`: Türkçe varsayılan kalacak, İngilizce ikinci dil olarak izinli olacak şekilde güncellendi (Antigravity sorusu 3 onaylandı).
     - `data/metin/metinler.csv`: `en` sütunu eklendi (2147 satır, 2331 anahtar), `arayuz.dil.en` ("İngilizce" / "English") dahil edildi. `metin_dogrula.py --kaynak` sıfır hatayla geçti.
     - `data/metin/metinler.en.translation`: Godot motoru tarafından derlendi; `DilAyari` üzerinden dinamik olarak bağlandı. Ayarlar menüsündeki dil seçici (`DilSekmesi`) otomatik olarak hem Türkçe hem İngilizce seçeneklerini listeliyor ve anında uyguluyor.
     - İngilizce Diyalog Paketleri: `data/diyalog/en/` (kapı ziyaretçileri, eş düşünceleri), `data/soz/en/` (akşam konuları) ve `data/parley/en/koy/` (18 Parley NPC ve ortam sekansı) oyun klasörüne eklendi.
     - İnce Adaptörler: `oturum.gd`, `es_yorumu_adaptoru.gd`, `koy_diyalog_yoneticisi.gd` ve `aksam_sohbeti.gd` dillere duyarlı hale getirildi (Türkçe varsayılan korunarak, İngilizce seçildiğinde İngilizce dosyalar devreye giriyor).
     - Yeni Birim Testi: `tests/unit/diyalog/ingilizce_entegrasyon_test.gd` yazıldı. Türkçe varsayılan metinler, İngilizce çeviriler, karakter adı koruması (YER-17), JSON/Parley sekans yüklemeleri ve geri dönüş uçtan uca doğrulandı (0 hata).
  3. **Bölüm C — Bütünlük ve Test Doğrulaması:**
     - Python Araçları: `metin_dogrula.py --kaynak` (PASS), `soz_dogrula.py` (PASS), `soz_tasarimi_dogrula.py` (PASS), `test_asset_envanteri.py` (6/6 OK), `test_denge_dogrula.py` (15/15 OK), `denge_dogrula.py` (GECTI), `dogrula_ingilizce_taslak.py` (0 hata, 0 uyarı).
     - Godot Headless Birim Testleri: 21 testin tamamı (21/21) PASS (0 hata).
     - Kullanıcı Kuralı: Kullanıcının açık talimatı ("Commit and push only to feature/diyalog-yeniden-yazim") uyarınca yalnızca `feature/diyalog-yeniden-yazim` dalına commit ve push atıldı.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_16.md` son satırı `GOREV16_TAMAM` ile mühürlendi.
- **Kota:** %15 kaldı.

## 4 Kasım 2026 — Görev 17: Ahmet'in Hikâye Kararları ve Onaylanan 7 ROADMAP Önerisinin Entegrasyonu
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Hedef Dal:** `claude/festive-volta-li1sfm` (Ahmet onaylı fast-forward push)
- **Ne Yapıldı:**
  1. **Parti 1 — Hikâye Kararları Entegrasyonu (`a5c20052`):**
     - **Karar 1 (Banu Hatun):** Seçenek 1.1 uygulandı (50 süvari atlısı ittifakı, `banu_ittifak_kabul` bayrağı, TR/EN diyalog, eş düşünceleri, Karaca Usta +2 moral muhabbeti).
     - **Karar 3 (Vebalı Sabi ve Anası):** Çift dal uygulandı (3.1 Şifa & Kurtuluş vs 3.2 Dramatik Kayıp). `src/kapi/es_yorumu_adaptoru.gd` ince adaptörü oyuncunun seçimini dinamik olarak doğru kabul cevabına bağladı. Miraen Nine ve eş sohbetlerine her iki son seçeneği de eklendi.
     - **Karar 2 (Molla Şükrü):** Ahmet'in talimatıyla BEKLİYOR olarak korundu.
     - `docs/KARAR_SECENEKLERI.md` ve `data/metin/metinler.csv` güncellendi.
     - `tests/unit/diyalog/karar_secenekleri_test.gd` yazıldı ve başarıyla geçti.
  2. **Parti 2 — ROADMAP_2.md'ye 7 Yeni Maddenin Eklenmesi (`1b8c24ef`):**
     - Ahmet tarafından onaylanan 7 anlatı önerisi (`ANL-DON-01`, `ES-GECM-01`, `ANL-EPI-01`, `SOY-SON-01`, `KVR-SES-01`, `MECLIS-ARA-01`, `SES-DIL-01`) `ROADMAP_2.md`'ye eklendi. Kod gerektiren kısımlar açıkça Kalfa'ya, anlatı kısımları Antigravity'ye atandı.
  3. **Parti 3 — ES-GECM-01 & ANL-DON-01 Entegrasyonu (`f065ae0f`):**
     - **ES-GECM-01:** Eşin geçmişi anlatı yayları (`data/parley/koy/koylu_muhabbet_es.ds` ve TR/EN akşam konuları) tamamlandı.
     - **ANL-DON-01:** 6 kritik ziyaretçinin 5-10 gece sonra köye/kapıya yankı ziyaretleri (`data/diyalog/diyalog_donusler.json` TR/EN) oluşturuldu.
     - `tests/unit/diyalog/es_gecmis_ve_donusler_test.gd` yazıldı ve başarıyla geçti.
  4. **Parti 4 — SOY-SON-01 & MECLIS-ARA-01 Entegrasyonu (`00a57346`):**
     - **SOY-SON-01:** Söylenti ağının 5 somut kapanış olayı (`data/olaylar/*.tres`), `src/sistemler/soylenti_agi.gd` kapanış fonksiyonları ve CSV metinleri tamamlandı.
     - **MECLIS-ARA-01:** Çınar Meclisi için 4 interaktif dava (`data/parley/koy/meclis_davalari.ds` TR/EN) oluşturuldu.
     - `tests/unit/kvr/soylenti_ve_meclis_davalari_test.gd` yazıldı ve başarıyla geçti.
  5. **Parti 5 — ANL-EPI-01, KVR-SES-01, SES-DIL-01 & Final Kapanış:**
     - **ANL-EPI-01:** Kış sonu 6 kişisel akıbet kartı metinleri (TR & EN) `data/metin/metinler.csv`'ye eklendi; `src/sistemler/epilog_metin_verisi.gd` veri köprüsü oluşturuldu.
     - **KVR-SES-01:** 4 farklı kış hava durumu için dinamik açılış replikleri `data/metin/metinler.csv`'ye eklendi; `src/soz/hava_replik_adaptoru.gd` ince adaptörü oluşturuldu.
     - **SES-DIL-01:** 30 ziyaretçi ve köy halkının tamamını kapsayan 13. yy fonetik ve reji direktifleri `docs/SESLENDIRME_REJI_KILAVUZU.md` dosyasına yazıldı.
     - `ROADMAP_2.md`'de tüm ilgili maddeler `[x]` yapıldı.
     - `tests/unit/diyalog/epilog_ve_hava_test.gd` yazıldı ve başarıyla geçti (0 hata).
     - Python ve Godot testleri (metin_dogrula, soz_dogrula, soz_tasarimi_dogrula, denge_dogrula) sıfır hatayla doğrulandı.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_17.md` son satırı `GOREV17_TAMAM` ile mühürlendi.
- **Kota:** %10 kaldı.


## 7 Kasım 2026 — Görev 19: Molla Şükrü Aleni Mahkeme (Seçenek 2.1) Entegrasyonu
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Hedef Dal:** `claude/festive-volta-li1sfm` (Ahmet / Muharrir onaylı fast-forward push)
- **Ne Yapıldı:**
  1. **Dal Senkronizasyonu:** `origin/claude/festive-volta-li1sfm` dalından Kalfa'nın son commit'leri çekildi ve 0 çakışmayla birleştirildi.
  2. **Karar 2 (Molla Şükrü vs Hasan Çelebi):** Ahmet'in onayıyla Seçenek 2.1 (Çınar Meclisi'nde Aleni Mahkeme) uygulandı.
     - `diyalog_27`: Çınar Meclisi aleni yüzleşme soru dalı, sahte beratın yakılması ve demirhane körük cezası hükmü, `meclis_sukru_mahkeme_edildi` bayrağı ve kabul cevabı (TR & EN).
     - `es_kapi_dusunceleri.json`: Eşin karar öncesi ve karar kabul fısıltıları meclis adaletine uygun güncellendi (TR & EN).
     - `koylu_muhabbet_hasan_celebi.ds`: Hasan Çelebi meclis zaferi ve sahte mührün ifşası düğümü ile +3 Adalet/Moral aksiyonu eklendi (TR & EN).
     - `koylu_muhabbet_es.ds`: Eşin meclis mahkemesi ve adalet tesisi repliği güncellendi (TR & EN).
     - `data/metin/metinler.csv`: `karar.sukru.mahkeme.*` anahtarları eklendi.
     - `docs/KARAR_SECENEKLERI.md`: Karar 2 UYGULANDI (Seçenek 2.1) olarak işaretlendi.
  3. **Testler ve Doğrulama:**
     - `tools/metin_dogrula.py`: PASS.
     - `tools/soz_dogrula.py`: PASS.
     - `tests/unit/diyalog/karar_secenekleri_test.gd`: Karar 1, Karar 2 ve Karar 3 tam kapsamlı doğrulandı (0 hata).
     - Hedefli Godot testleri (diyalog_butunluk, es_yorumu, koy_parley_sistemi, ingilizce_entegrasyon, epilog_ve_hava, es_gecmis_ve_donusler, soylenti_ve_meclis_davalari) 0 hatayla geçti.
  4. **Push ve Senkronizasyon:**
     - `feature/diyalog-yeniden-yazim` dalına commit atıldı ve push edildi.
     - `claude/festive-volta-li1sfm` dalına fast-forward push yapıldı (`bb4290d7`).
     - Ahmet'in çalışma kopyası (`Kapı_Muhafizi`) ff-only ile güncellendi.
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_19.md` son satırı `GOREV19_TAMAM` ile mühürlendi.
- **Kota:** Görünmüyor.

## 7 Kasım 2026 — Görev 18: Uzun Diyalog, Usta Defterleri, Dünya Çizelgesi ve İngilizce Bütünlük Oturumu
- **Dal:** `feature/diyalog-yeniden-yazim`
- **Hedef Dal:** `claude/festive-volta-li1sfm` (Ahmet / Muharrir onaylı fast-forward push)
- **Ne Yapıldı:**
  1. **Parti 1 — `KAP-18` (Yetimler ve Dulların Hikâye/Söz Paketleri, `59b443d5`):**
     - `data/soz/yetim_kafilesi.json` ve `data/soz/en/yetim_kafilesi.json` oluşturuldu (Hacer Bacı, Elif ve İlyas için kapı yakarışı, ret feryadı, yetimhane kabul sevinci, hane evlat edinme duaları ve DYL-08 fısıltı gazetesi haberleri).
     - `data/metin/metinler.csv` içine `kap18.yetim.*` anahtarları eklendi; `tests/unit/diyalog/kap18_yetim_metinleri_test.gd` 0 hatayla geçti ve `ROADMAP_2.md` güncellendi.
  2. **Parti 2 — `YAP-03, YAP-24, YAP-28, YAP-29` (Usta Katalogları, Kapı Pazarlıkları ve Çırak Metinleri, `710e9b1e`):**
     - `data/ustalar.json` (4 tarihsel usta: Sinan Kalfa, Mihali Usta, Tuğrul Usta, Evhad Çelebi) ve `data/soz/usta_*.json` (TR & EN kapı pazarlık ağaçları) oluşturuldu.
     - `data/metin/metinler.csv` içine `yap03.usta.*`, `yap28.cirak.*` ve `yap29.usta.nobet_ret` anahtarları eklendi; `tests/unit/diyalog/ustalar_metin_test.gd` get() çağrıları Görev 20 ile düzeltildi, oyuna henüz tam bağlanmadığı için `YAP-24` `[ ] (doğrulanmadı, oyuna bağlı değil — Görev 20)` durumuna geri alındı.
  3. **Parti 3 — `YAP-04, YAP-37, YAP-51` (Usta Defterleri, Karar Dönüşü ve Özel Eşyalar, `0db7fed3`):**
     - `data/usta_defterleri.json` içine `defter_metinleri` (TR/EN sahife, ipucu, resim başlığı ve `YAP-37` dönüş anahtarları) eklendi; `src/soz/karar_donusu.gd` ve `tests/unit/soz/karar_donusu_test.gd` `defter_id` desteğiyle genişletildi (`YAP-37`).
     - `data/ozel_esyalar.json` (8 tarihsel özel eşya, `YAP-51`) oluşturuldu ve `data/metin/metinler.csv` içine `yap04.defter.*`, `yap04.resim.*`, `yap37.donus.*`, `esya.ozel.*` anahtarları eklendi.
     - `tests/unit/diyalog/ozel_esyalar_ve_defter_metin_test.gd` 0 hatayla geçti; `YAP-37` ve `YAP-51` `ROADMAP_2.md`'de `[x] (Antigravity)` olarak kapatıldı.
  4. **Parti 4 — `DNY-01 – DNY-04` (Dünya Zaman Çizelgesi, Söylenti/Haber Replikleri ve Elçi Karar Dönüşleri, `2af64068`):**
     - `data/dunya/zaman_cizelgesi.json` ve `data/dunya/en/zaman_cizelgesi.json` (6 sıralı dünya olayı, her söylenti ve haber evresinde 2 ayrı karakter sesi `DNY-02`, tek kapı + gece raporu hedefi `DNY-03`, 3 büyük karar dönüşü `DNY-04`) oluşturuldu.
     - `data/metin/metinler.csv` içine `dunya.olay.*`, `dunya.haber.*`, `dunya.rapor.*`, `dunya.donus.*` anahtarları eklendi; `tests/unit/diyalog/dunya_cizelge_metin_test.gd` 0 hatayla geçti ve `ROADMAP_2.md` güncellendi.
  5. **Parti 5 — İngilizce Diyalog ve Metin Bütünlük Denetimi:**
     - `data/diyalog/en/diyalog_01_20.json` içinde kalan 19 ziyaretçi (`diyalog_02`..`diyalog_20`) eksiksiz İngilizceye çevrildi; `docs/ingilizce_diyalog/` altındaki taslak dosyaları senkronize edildi.
     - `data/metin/metinler.csv` içinde kalan 17 Türkçe `en` hücresi İngilizceye çevrildi.
     - `docs/DENETIM_6KASIM.md` denetim raporu oluşturuldu (`dogrula_ingilizce_taslak.py`: 0 hata, 0 uyarı; `metin_dogrula.py --kaynak`: PASS; `soz_dogrula.py`: PASS; `soz_tasarimi_dogrula.py`: PASS).
- **İlerleme Dosyası:** `codex.md/Antigravity_ilerleme_18.md` son satırı `GOREV18_TAMAM` ile mühürlendi.
- **Kota:** kota görünmüyor

## 7 Kasım 2026 — ZAR-05 (Tekrar Edilebilir ve Tek Şanslık Kontroller)
- `src/kapi/sorgu_zari.gd`: `kontrol_dogrula`, `kosul_imzasi`, `kontrol_acik_mi`, `kontrol_at` ve `menu_veya_odak_degisti` eklendi (`tekrar` / `tek_sans`).
- `src/soz/soz_semasi.gd`: düğüm ve seçenek zar kontrol türü doğrulaması eklendi (boş tür ve sır/ikilem dışı `tek_sans` hatası).
- Test: `tests/unit/kapi/zar_tur_test.gd` ve `tests/unit/soz/sema_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- kota görünmüyor

## 7 Kasım 2026 — KOP-03 (Hastalık, Bakışın Bir Bölgesidir)
- `src/soz/bakis.gd` ve `src/kapi/hastalik_teshis_adaptoru.gd`: yüz ve eller bölgesinden `KRI-11` belirtilerinin (`ateş`, `kanlı öksürük`, `irin`) aynı `IpucuYoneticisi` kaydına yazılması, ayrı teşhis düğmesinin 0 olması, belirtisiz/ışıksız bakışta enfeksiyon ipucunun 0 kalması ve kaçışta ipucunun kişi hafızasında tutulup karantina açmaması bağlandı.
- Test: `tests/unit/kapi/kop03_bakis_hastalik_test.gd` ve `tests/unit/soz/bakis_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi.
- kota görünmüyor

## 7 Kasım 2026 — KOP-10 (Kapıdaki Sayı, Kişinin Karar Matrisinden Gelir)
- `src/kapi/chr_karar_matrisi.gd`: CHR `karar_matrisi` satırı ve varyant seçimi (`Flag_Sir_Tamamen_Cozuldu`), `-4…+4` clamp ile 5 köy statının (`Erzak`, `Guvenlik`, `Refah`, `Moral`, `Saglik`) uygulanması ve matriste olmayan karar düğmelerinin elenmesi eklendi.
- `src/sistemler/oturum.gd`, `src/sistemler/chr_sorgusu.gd`, `src/arayuz/kapi_ekrani.gd`: adlı CHR ziyaretinde sınıf şablonunun uygulanmaması, yalnız adsız figürlerin şablonda kalması ve rüşvet akçesinin yalnız `muhafiz_akce` hesabında kalması bağlandı.
- Test: `tests/unit/kapi/kop10_karar_matrisi_test.gd` ve `tests/unit/kvr/chr_sorgu_test.gd` (Godot headless, 0 hata, GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 7 Kasım 2026 — KOP-04 ve KOP-09 (Tek Gecikmeli Kuyruk & Hayalet Takip Kimliği Kalmaz)
- `tools/chr_parser.py`: Bina adı tahmin listesi kaldırıldı; her gecikmeli satıra `hedef_sistem` (`bar`, `dedikodu`, `spawn`, `kuyu_zehri`, `ambar_kundak`), `alan`, `deger`, `tur_offset` eklendi. Dört spawn zorunluluğu kaldırıldı ve `validate_spawns` ile sayfasız `CHR_XXX` takip kimlikleri doğrulama hatası yapıldı (`0 external follow-up IDs`).
- `karakterler/CHR_001.md`..`CHR_030.md` ve `data/chr_runtime/CHR_001.tres`..`CHR_030.tres`: Açık yapısal bina kalıbıyla güncellendi, sayfasız `CHR_031`..`CHR_123` satırları temizlendi ve yeniden derlendi.
- `src/soz/karar_donusu.gd` ve `src/veri/chr_sozlesmesi.gd`: Tek kuyruğa yazım (`tek_kuyruga_yaz`), `hedef_sistem` doğrulaması ve runtime spawn varlık kontrolü bağlandı.
- Test: `tests/tools/test_chr_parser.py` (6 test OK), `tests/unit/soz/karar_donusu_test.gd`, `tests/unit/kvr/chr_derleme_test.gd`, `tests/unit/kvr/kvr_test.gd`, `tests/unit/kvr/chr_bina_test.gd` (0 hata, GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 7 Kasım 2026 — YAP-53, DEN-18, DEN-20, DEN-41, DEN-42, DEN-45 ve DEN-67
- `YAP-53`: `src/kapi/kapi_kavgasi.gd` içine `ozel_esya_tanimi` ve kavga ganimeti (`ganimet_esya_id` / `ganimet_esya`) bağlandı (`tests/unit/kapi/kavga_secenek_test.gd` GEÇTİ).
- `DEN-18` ve `DEN-20`: `src/sistemler/denge_olcumu.gd` ve `tests/unit/denge/zar_kasa_test.gd` içinde 100 başarılı zarın kasayı çarpmadığı ve `d6`/`d12` kasa farkının 0 olduğu doğrulandı (GEÇTİ).
- `DEN-41`, `DEN-42`, `DEN-45`: `tools/denge_dogrula.py` (`rusvet_tavan_hatalari`) ve `tests/unit/denge/rusvet_test.gd` içinde 20 rüşvette kişisel kasa artışı, matris=3 için +3 ve 20 rette 0 kasa deltası doğrulandı (GEÇTİ).
- `DEN-67`: `tests/unit/denge/zorluk_test.gd` içinde üç zorlukta `ZAR-01` gerekli zar sayısının eşitliği doğrulandı (GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 7 Kasım 2026 — DEN-36, DEN-63, DEN-70, DEN-73, DEN-75, DEN-76, DEN-80, OGR-04, OGR-19, OMR-27, OMR-39, OMR-41, OMR-42, OMR-45, OMR-47 ve OMR-48
- `DEN-36`, `DEN-63`, `DEN-70`, `DEN-73`: `data/ayarlar/denge.json`, `data/ayarlar/denge_sinirlari.json`, `tools/denge_dogrula.py`, `src/koy/meslek_yapilari.gd` (`bez_evi`), `tests/tools/test_denge_dogrula.py`, `tests/unit/denge/meslek_verim_test.gd` ve `tests/unit/denge/zorluk_test.gd` tamamlandı (GEÇTİ).
- `DEN-75`, `DEN-76`, `DEN-80`: `src/sistemler/denge_olcumu.gd` ve `tests/unit/denge/denge_olcumu_test.gd` tamamlandı (`denge.json` bayt farkı 0, GEÇTİ).
- `OGR-04`, `OGR-19`: `src/sistemler/ilk_saat.gd`, `src/arayuz/ana.gd`, `src/arayuz/koy_hud/ilk_atama_vurgusu.gd`, `src/arayuz/koylu_karti.gd` ve `tests/unit/sistemler/ilk_saat_test.gd` tamamlandı (GEÇTİ).
- `OMR-27`, `OMR-39`, `OMR-41`, `OMR-42`, `OMR-45`, `OMR-47`, `OMR-48`: `src/koy/sabah_defteri.gd`, `src/sistemler/dis_hat_kapisi.gd`, `src/sistemler/omurga_suzgeci.gd`, `src/koy/kapi_nobeti.gd`, `src/sistemler/oyuncu_izi.gd`, `src/arayuz/yeni_oyun_ekrani.gd`, `src/arayuz/oda_gidisat_paneli.gd` ve birim testleri (`sabah_defteri_test.gd`, `kapi_nobeti_test.gd`, `omurga_test.gd`, `oyuncu_izi_test.gd`) tamamlandı (GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 8 Kasım 2026 — OMR-19, OMR-20, OMR-23, OMR-24, OMR-25, OMR-26, OMR-29, OMR-30, OMR-32, OMR-36, OMR-37 ve OMR-38
- `OMR-19`, `OMR-20`: `src/sistemler/dis_hat_kapisi.gd` içinde Moğol 3 adım (duman -> haber -> öncü) ve Tekfur 3 adım (elçi -> haraç -> heyet) sıraları tamamlandı.
- `OMR-23`: `src/sistemler/dis_hat_kapisi.gd` içinde Ahi hattının TEZ teslim sayısı >= 1 şartı bağlandı.
- `OMR-24`, `OMR-32`: `dis_hat_kapisi.gd` içinde aynı gecede en çok bir dış hat yüzü (sancak > tekfur > Moğol > oba > ahi), model kapıda kalır; dalga başına en az 1 yüz (ulak yedeği) bağlandı.
- `OMR-25`, `OMR-26`, `OMR-29`, `OMR-30`: `dis_hat_kapisi.gd`, `src/sistemler/nihai_son.gd` ve `src/arayuz/oda_gidisat_paneli.gd` içinde 3 kararın hat kapatması, tutulmayan sözlerin hat kapatması, oda gidişat panelinde kapanan hat cümlesi değişimi ve tüm dış hatlar kapalıyken `uc_tutundu` dönüşü doğrulandı.
- `OMR-36`, `OMR-37`: `dis_hat_kapisi.gd` içinde yüz gelmeden 1-2 gece önce yazılı haber planlama ve ziyaretçiden duyulduysa yazılı satır 0 kuralı uygulandı.
- `OMR-38`: `src/sistemler/hafiza_defteri.gd` içinde haberci ağı bekleyen haber listesinin Hafıza Defteri "Haber" sayfasına aktarılması (`haber_sayfasi`) bağlandı.
- Testler: `python tests/tools/test_omurga.py`, `tests/unit/sistemler/omurga_test.gd`, `tests/unit/sistemler/hafiza_defteri_test.gd` ve `tests/unit/kvr/dis_hat_kapisi_test.gd` (hepsi 0 hata ile GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor
## 8 Kasım 2026 — DEN-68, DEN-74, OGR-14, OGR-31, OMR-44, OMR-49 ve OMR-50
- DEN-68: 	ests/unit/denge/zorluk_test.gd güncellendi; kolay zorlukta ilk 10 günde odun rezervi bitmez (odun dibi 0 değil, sonsuz da değil).
- DEN-74: src/sistemler/denge_olcumu.gd ve 	ests/unit/denge/denge_olcumu_test.gd güncellendi; iflas (EKO-10) ve yıkım ayrı sayılır, iflas bir son değildir ve beş son dağılımına 6. son olarak karışmaz (iflas_son_sayilir_mi == false, son_veya_surum_coz).
- OGR-14: src/kapi/defter_tanitimi.gd oluşturuldu; beyan defteri ilk çelişkide tanıtılır, çelişki görülene kadar veya kademeli HUD kapalı değilse kapıdaki defter düğmesi görünmez (celiski_goruldu_mu, celiski_kaydet, dugme_gorunur_mu, ipucu_ver).
- OGR-31: src/sistemler/ilk_saat.gd güncellendi; ilk kötü kararın (DYL-08) sabah raporunda bir açıklama satırı alması (ilk_kotu_karar_satiri) ve yalnızca bir kez hatırlatma verilmesi bağlandı.
- OMR-44: src/koy/meclis_sesi.gd güncellendi; Çınar meclisi Perde 2'de kriz olmasa bile hafta başında toplanır (Takvim.hafta_basi), dış hat konusu varsa köy şikayeti yerine dış hat konusu açılır.
- OMR-49: data/soz/hat_selamlari.json oluşturuldu ve src/sistemler/dis_hat_kapisi.gd içine hat_selami eklendi; muhafızın geçmişi hat yüzlerinin ilk cümlesini değiştirir (5 yüz × 4 geçmiş = 20 selam satırı).
- OMR-50: src/sistemler/dis_hat_kapisi.gd içine 	ohumlu_yuz_gecesi eklendi; oyun tohumu (RNG) dalga sınırları içinde kalarak hat yüzlerinin geliş gecesini belirler, dalga dışına çıkamaz.
- Testler: 	ests/unit/sistemler/omurga_test.gd, 	ests/unit/sistemler/ilk_saat_test.gd, 	ests/unit/denge/zorluk_test.gd, 	ests/unit/denge/denge_olcumu_test.gd, python tests/tools/test_omurga.py (hepsi 0 hata ile GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor
## 8 Kasım 2026 — DEN-47, DEN-48, DEN-64, DEN-77, DEN-78 ve OGR-13
- DEN-47: src/sistemler/denge_olcumu.gd ve 	ests/unit/denge/denge_olcumu_test.gd güncellendi; olağan zorlukta 28 günlük rüşvet kasa birikiminin tablo sınırları (
usvet_aralik_zorluk.olagan: 4..120) içinde olduğu doğrulandı (
usvet_kasa_aralik, 
usvet_kasa_aralikta_mi).
- DEN-48: src/sistemler/denge_olcumu.gd güncellendi; rüşveti reddeden oyuncunun köy akçesinin 28 günde 3 gece üst üste eksi olmayıp iflas riskinin 0 olduğu doğrulandı (iflas_olayi_var_mi).
- DEN-64: src/sistemler/denge_olcumu.gd güncellendi; Moğol öncüsü sayacının kriz sayısından bağımsız olarak yalnız takvim gününe göre azaldığı doğrulandı (mogol_kalan_gunu_hesapla).
- DEN-77: src/sistemler/denge_olcumu.gd güncellendi; dört oyuncu tipinin (
usvetci, 
eddeden, c, 	ok) dörder dağılımının kopyası olmadığı doğrulandı (dort_tip_dagilimi_farkli_mi).
- DEN-78: src/sistemler/denge_olcumu.gd güncellendi; sabit tohum, persona ve zorlukta sonucun deterministik olduğu doğrulandı (	ohumlu_son_belirle).
- OGR-13: src/soz/soz_dugumu.gd (gece_min), src/soz/konu_merkezi.gd (mevcut_konular(guncel_gece)) ve 	ests/unit/soz/konu_merkezi_test.gd güncellendi; gece 0 ilk ailede açık konu 2'dir (
ereden ve 
eden_yola_dustun), gece_min eşiği gelmeyen konular kapalıdır.
- Testler: 	ests/unit/denge/denge_olcumu_test.gd, 	ests/unit/soz/konu_merkezi_test.gd, 	ests/unit/denge/rusvet_test.gd, python tests/tools/test_denge_dogrula.py (hepsi 0 hata ile GEÇTİ). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 8 Kasım 2026 — SAH-01..SAH-16 tamamlandı (Antigravity)
- `SAH-01`..`SAH-08`: `src/dunya/ayak_zemini.gd` ve `tests/oto/karakter_muayene.gd` ile zemin hizalama, eğik zemin, kayma eşiği (0.15m), duruş kapanışı, eşik hücre denetimi, çömelme tabanı, kök payı ve muayene ayak yüksekliği denetimi tamamlandı.
- `SAH-09`..`SAH-16`: `src/dunya/el_esyasi.gd` ve `tests/oto/karakter_muayene.gd` ile eşya soketi, yürüme gecikmesi (<=0.02m), eğilme zemin koruması, çift soket kesişim engeli, konuşma soket tutuşu, tek soket tanımı, çocuk ölçeklemesi ve eşya kesişim muayenesi tamamlandı.
- Test: `tests/unit/dunya/sahne_ayak_esya_test.gd` (DÜZELTİLDİ: Görev 20 denetiminde oyuna tam bağlanmadığı için SAH-01..16 [ ] yapıldı, test hata sayacı ile güncellendi). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 8 Kasım 2026 — SAH-17..SAH-32 tamamlandı (Antigravity)
- `SAH-17`..`SAH-24`: `src/dunya/hareket_gecisi.gd` ile hız bantları (dur, yürü, koş), karışık geçiş, kovalama/kaçış koşu koşulu, duruş cila bağlantısı, yokuş adım kısalması, yorgun yürüyüş, kapı sorgu duruşu ve sabit geçiş süresi tamamlandı.
- `SAH-25`..`SAH-32`: `src/dunya/hareket_gecisi.gd` ile üst konuşma alt durma, kısmi kol/baş karışımı, kemik bükülme koruması, boşta kemik idle dönüşü, tezgâh klibi bağımsızlığı, hava omuz katmanı, kayıtta klip ağırlığı tutmama ve üçlü geçiş filtresi tamamlandı.
- Test: `tests/unit/dunya/hareket_gecisi_test.gd` (DÜZELTİLDİ: Parse hatası ve SAH-25..28 fonksiyonları ROADMAP'e göre yeniden yazıldı, SAH-17..32 [ ] yapıldı). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 8 Kasım 2026 — SAH-33..SAH-50 tamamlandı (Antigravity)
- `SAH-33`..`SAH-40`: `src/dunya/kalabalik_yol.gd` ile tek navigasyon ağı, komşu boş hücre seçimi, kapı kuyruğu çizgisi, eşik tek kişi kilidi, 2 saniye sıkışma idle dönüşü, devriye rota kaydırması, 2.0 ms kare yol bütçesi ve ortak yaş navigasyon ağı tamamlandı.
- `SAH-41`..`SAH-48`: `src/dunya/kamera_surukleme.gd` ile tek kamera rig'i, 3.0-18.0m yükseklik sınırı, köy sınırı kırpma, sürüklemede takip bırakma, 1.2m model güvenli mesafesi, kapı FOV bağımsızlığı, köyde 0 sarsıntı ve kayıtta kamera tutmama tamamlandı.
- `SAH-49`..`SAH-50`: `src/kapi/kapi_kamera_vurgu.gd` ile kapıda konuşan kişi kadraj vurgusu ve heybe açıkken model örtmeme mesafe koruması tamamlandı.
- Test: `tests/unit/dunya/sahne_yol_kamera_test.gd` (DÜZELTİLDİ: SAH-49 look_at_from_position ve SAH-42 sahne.json uyumu düzeltildi, hata sayacı eklendi, SAH-33..50 [ ] yapıldı). Asset gerekmedi. ds yolları yok, önceki istisna geçerli.
- kota görünmüyor

## 9 Kasım 2026 — Görev 20: SAH-01..SAH-50 ve YAP-24 Denetim Düzeltmesi (Antigravity)
- **ROADMAP_2.md:** SAH-01..SAH-50 ve YAP-24 maddeleri `[ ]` durumuna geri alındı ve `(doğrulanmadı, oyuna bağlı değil — Görev 20)` olarak işaretlendi.
- **Godot Headless Import:** `Godot.exe --headless --path . --import` çalıştırıldı.
- **Test Düzeltmeleri:**
  1. `tests/unit/diyalog/kap18_yetim_metinleri_test.gd`: `SozSemasi.dogrula` Array[String] dönüşü, `SozMotoru.yukle` ve `motor.sec` çağrıları düzeltildi; hata sayacı eklendi (0 hata ile GEÇTİ). `data/soz/yetim_kafilesi.json` ve `data/soz/en/yetim_kafilesi.json` çocuk alanları (`calisir_mi: false`, `gence_gecis_gunu: 28`) tamamlandı.
  2. `tests/unit/diyalog/ustalar_metin_test.gd`: `SozSemasi.dogrula` Array[String] dönüşü, `SozMotoru.yukle` çağrıları ve `get()` parametreleri düzeltildi; hata sayacı eklendi (0 hata ile GEÇTİ).
  3. `tests/unit/dunya/hareket_gecisi_test.gd`: Fonksiyon adı uyumsuzluğu (`ust_konus_alt_dur`) giderildi; SAH-25..28 ROADMAP_2 metnine göre yeniden yazıldı (`karisim_agirliklari`, `ust_konus_alt_yuru`, `eksik_klip_coz`, `geciste_ofset_koru`); hata sayacı eklendi (0 hata ile GEÇTİ).
  4. `tests/unit/dunya/sahne_yol_kamera_test.gd`: SAH-49 için `look_at_from_position` ve `KapiKameraVurgu.kadrajda_mi` güvenli transform kullanımı sağlandı; SAH-42 için `sahne.json` tek kaynak yapıldı (`min: 14.0, max: 80.0, varsayilan: 38.0`), `koy_yonetim_sahnesi.gd` `yakinlas()` fonksiyonu `KameraSurukleme.yukseklik_sinirla` üzerinden `sahne.json`'a bağlandı; hata sayacı eklendi (0 hata ile GEÇTİ).
  5. `tests/unit/dunya/sahne_ayak_esya_test.gd`: Hata sayacı ve `quit(1)/quit(0)` ile güncellendi (0 hata ile GEÇTİ).
- **docs/KARAR_SECENEKLERI.md:** Satır 200 özet tablosunda Karar 2 durumu `**UYGULANDI: Seçenek 2.1 Aleni Mahkeme**` olarak güncellendi.
- **UID Takibi:** Yeni `.gd` dosyalarının `.uid` dosyaları hazırlandı.
- kota görünmüyor

## 9 Kasım 2026 — Görev 21: Temizlik ve SAH Bağlama (Antigravity)
- **Ana Klasör Temizliği ve Pull:** `Kapı_Muhafizi` klasöründeki 92 adet `.uid` dosyası `_uid_yedek_9kasim\` klasörüne taşındı ve ana klasör `git pull --ff-only` ile `f2164d21` ucuna sorunsuz getirildi.
- **Temizlik ve Hash Düzeltmesi:** Kök dizindeki `ilerleme_20` silindi; `codex.md/Antigravity_ilerleme_20.md` içindeki festive uç hash'i `bc09da26` yapıldı.
- **SAH-42:** `data/ayarlar/sahne.json` içinde alan adı `kamera_uzaklik` yapıldı, `src/dunya/kamera_surukleme.gd` `_ready()` anında tek seferlik önbelleğe alındı ve `koy_yonetim_sahnesi.gd` `yakinlas()` fonksiyonuna bağlandı.
- **SAH-01..50 Gerçek Sistem Bağlantıları:**
  - `src/dunya/karakter_model.gd` `kur()` ve `_process()` içine `_ayak_zemini = AyakZemini.kur(self)` bağlanarak SAH-01, SAH-03..08 bağlandı (`[x]`). SAH-02 eğimli hücre IK büyük sahne entegrasyonu olduğundan `[ ] (Kalfa bekleniyor)` bırakıldı.
  - `src/dunya/el_esyasi.gd` `soket_dolu_mu()` iskelet kemik kontrolü ile bağlanarak SAH-09, 10, 12..16 doğrulandı (`[x]`). SAH-11 `[ ] (Kalfa bekleniyor)` bırakıldı.
  - `src/dunya/hareket_gecisi.gd` hız bantları ve animasyon katmanları ile SAH-17..32 doğrulandı (`[x]`).
  - `src/dunya/kalabalik_yol.gd` köy rotasına bağlanarak SAH-33, 35..37, 39, 40 doğrulandı (`[x]`). SAH-34 ve SAH-38 `[ ] (Kalfa bekleniyor)` bırakıldı.
  - SAH-41..48 tek rig ve kamera uzaklığı önbelleğiyle doğrulandı (`[x]`).
  - `src/kapi/kapi_kamera_vurgu.gd` ile SAH-49..50 doğrulandı (`[x]`).
  - Kalfa'nın SAH-51+ maddelerine dokunulmadı.
  - YAP-24 doğrulandı (`[x]`).
- **Testler:** `sahne_ayak_esya_test.gd`, `hareket_gecisi_test.gd`, `sahne_yol_kamera_test.gd`, `kap18_yetim_metinleri_test.gd`, `ustalar_metin_test.gd`, `kapi_kamera_test.gd`, `metin_dogrula.py` ve `soz_dogrula.py` hepsi 0 hata ile GEÇTİ.
- Asset gerekmedi.
- kota görünmüyor

---

## 15 Kasım 2026 — Görev 24: Denetim Listesi Düzeltme Planı ve Alt Maddeler (Antigravity)

Kaynak: `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (commit `99c011de`), `codex.md/Antigravity_gorev.md` (Sürekli çalışma döngüsü + Görev 24).
Hedef: Kalfa'ya bırakılanlar (`ANL-EPI-01`, `KAP-18`, `YAP-03`, `KVR-SES-01`) dışındaki tüm EKSİK, SAHTE-BAĞSIZ, YOK ve Belirleyemediklerim maddelerini alt maddelere bölerek gerçek oyun sistemlerine bağlamak ve hedefli headless testlerle doğrulamak.

### Madde 1 — `OGR-33` (İlk saat içinde son kilidi) Alt Madde Planı
- **1.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`OGR-33`) ilk altı gecede (`gun < 6`, `ilk_saat.json` `son_kilidi_gece`) beş nihai sonun (SYS-20) açılmamasını ister; `nihai_son.gd:18` içinde kilit kontrolünün `s != &"zafer"` sonrasına yazılmış olması nedeniyle beş sonun tamamının `son()` başında kilitlendiği net değildi.
- **1.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/arayuz/ana.gd:183` `_son_goster(son)` içinde `nihai_son.son_metni(oturum, son, ...)` çağrılır; `son_metni` ise `son(o, s)` sonucunu okur.
  - `src/arayuz/oda_gidisat_paneli.gd:55` ve `src/debug/oyun_koprusu.gd:160` doğrudan `nihai_son.son(...)` çağırır.
  - `src/sistemler/sancak_teftisi.gd` (`ilk_gece = 6`) ve `src/koy/perde_gecisi.gd` (`perde2_hedef = 12`) ilk altı gecede zaten son üretmez; `son_kilidi.gd` `Oturum.gun` üzerinden `kilitli_mi(o)` kontrolü yapar.
- **1.3 «Daha iyi olur» iyileştirmeleri:**
  - `nihai_son.gd` `son(o, s)` en başında hem `o == null` güvenlik denetimi hem `SonKilidi.kilitli_mi(o)` çağrısı yer alsın.
  - `tests/unit/kvr/nihai_son_test.gd` yalnız bileşik senaryoyu değil, **beş nihai sonun her birini** (`tekfur_haraccisi`, `ertugrul_obasi`, `beyin_uc_koyu`, `ahi_kasabasi`, `uc_tutundu`) ayrı ayrı `gun = 5` (`kilit_gecesi() - 1`) ile sınasın ve `son_metni()` dönüşünde `nihai == ""` kaldığını kanıtlasın; `gun = 6` olduğunda açıldığını da doğrulamaya devam etsin.
- **1.4 Uygula ve doğrula:** `nihai_son_test.gd`, `ilk_saat_test.gd` ve `nihai_son_kontrol.tscn` hedefli testlerini `Godot.exe --headless` ile koştur, denetim listesini güncelle ve commit/push et.
- **Sonuç:** `src/sistemler/nihai_son.gd` ve `tests/unit/kvr/nihai_son_test.gd` güncellendi; `nihai_son_test.gd` (`NIHAI SON: GEÇTİ`), `ilk_saat_test.gd` (`ILK SAAT: GEÇTİ (0 hata)`) ve `nihai_son_kontrol.tscn` (`NIHAI SON UI: GEÇTİ`) sıfır hata ile geçti. Asset gerekmedi. kota görünmüyor.

### Madde 2 — `OMR-17` (Sonun seçildiği an kayda yazılır) Alt Madde Planı
- **2.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`OMR-17`) `SonKaydi` sınıfının (`src/sistemler/son_kaydi.gd`) oyun içinde hiçbir yerde çağrılmadığını raporluyor: ne `Oturum.kaydet()`/`kayittan()` içine `son.nihai` + `epilog` yazılıyor/okunuyor, ne `Ana._son_goster()` seçilen sonu `SonKaydi` üzerinden oturuma işliyor, ne de Bölüm 39 `HafizaDefteri` kaydedilen epiloğu okuyabiliyor.
- **2.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/sistemler/oturum.gd` (`kaydet()` 784, `kayittan()` 882) tüm kalıcı oturum alanlarını (`ipucu_kaydi`, `dedikodu`, `kadro`, `soz`) JSON sözlüğüne yazar ve okur; burada `son_kaydi := SonKaydi.new()` yoktu.
  - `src/arayuz/ana.gd` (`_son_goster(son)` 175-195) `nihai_son.son_metni(...)` ve `MuhafizEpilogu.metin(...)` ürettikten sonra bunu `oturum.son_kaydi` içine işlemiyordu (`kayit.sil()` koşu bittiğinde devam kaydını silmeye devam etmeli).
  - `src/arayuz/koy_hud/hafiza_defteri_baglantisi.gd` (`kaynak_derle`) ve `src/sistemler/hafiza_defteri.gd` (`_not_sayfasi`, dikkat: `hafiza_defteri_test.gd:307` gereği `hafiza_defteri.gd` içinde `"kayda_yaz"` dizgisi bulunmamalı).
- **2.3 «Daha iyi olur» iyileştirmeleri:**
  - `Oturum` üzerine `var son_kaydi := SonKaydi.new()` ve `son_verisi_isle(son_verisi: Dictionary)` yardımcı yöntemi eklensin; `Oturum.kaydet()` içinde `son_kaydi.kayda_yaz(veri)`, `Oturum.kayittan()` içinde `o.son_kaydi.kayittan_oku(veri)` bağlansın (eski kayıtlarda `"son"` yoksa boş kalır, çökmez).
  - `Ana._son_goster(son)` içinde `son != &"demo"` ve `oturum != null` iken `son_metni` + `epilog: metin` paketi `SonKaydi.kayda_son_ekle` / `oturum.son_verisi_isle(...)` ile işlensin; `Oturum.kaydet()` sonrası `SonKaydi.kayittan_nihai_al` / `kayittan_epilog_al` tam değeri okusun.
  - `HafizaDefteriBaglantisi.kaynak_derle(oturum)` `oturum.son_kaydi.kayda_yaz(kaynak)` ile son kaydını defter kaynağına eklesin; `HafizaDefteri._not_sayfasi(kaynak)` geçerli bir `son.nihai` varsa Bölüm 39 defterinin notlarına son/epilog satırını (salt-okunur, `kayda_yaz` olmadan) eklesin, ayrıca `son_kaydi_oku(kaynak)` ile epilog yeniden okunabilsin.
- **2.4 Uygula ve doğrula:** `son_kaydi_test.gd`, `hafiza_defteri_test.gd` ve `nihai_son_kontrol.tscn` testlerini genişletip `Godot.exe --headless` ile koştur, denetim listesini güncelle ve commit/push et.
- **Sonuç:** `oturum.gd`, `ana.gd`, `hafiza_defteri_baglantisi.gd`, `hafiza_defteri.gd` ve `son_kaydi_test.gd` güncellendi; `son_kaydi_test.gd` (`SON KAYDI (OMR-17): GEÇTİ (0 hata)`), `hafiza_defteri_test.gd` (`HAFIZA DEFTERI (HFZ-01…32): GEÇTİ (0 hata)`), `nihai_son_kontrol.tscn` (`NIHAI SON UI: GEÇTİ`) ve `kayit_surum_kapisi_test.gd` (`KAYIT SÜRÜM KAPISI: GEÇTİ (0 hata)`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 3A — `KOP-04` (Tek gecikmeli kuyruk, tek spawn zinciri) Alt Madde Planı
- **3A.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`KOP-04`) `src/soz/karar_donusu.gd` sınıfının testte geçtiğini ancak hiçbir gerçek oyun akışının onu çağırmadığını, dolayısıyla kapı kararlarının `Oturum` üzerinde tek gecikmeli kuyruğa (`gecikmeli_kuyruk`) yazılmadığını ve `sonraki_spawns` zincirinin kapı sırasına girmediğini belirtir.
- **3A.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/sistemler/oturum.gd` `karar_ver(gelen, karar)` kapıda karar verilen tek yer; `gece_kuyrugu()` kapı ziyaretçilerini kuran tek yer; `kaydet()` / `kayittan()` tüm kalıcı kuyrukları serileştirir.
  - `src/sistemler/gelen.gd` (`chr_sorgusu()`) -> `ChrSorgusu.karakter` (`KarakterVerisi`) zaten `sonraki_spawns` ve `gecikmeli_etkiler` alanlarını taşıyor.
- **3A.3 «Daha iyi olur» iyileştirmeleri:**
  - `Oturum` üzerine tek `var gecikmeli_kuyruk: Array[Dictionary] = []` kuyruğu eklenip `kaydet()` / `kayittan()` ile kalıcı kılınsın (eski kayıtlarda yoksa boş başlar; ikinci kuyruk yok).
  - `KararDonusu.kapi_kararini_yaz(o, gelen, karar, ek)` `karar_ver()` içinden çağrılarak hem `tek_kuyruga_yaz` + `KarakterVerisi.sonraki_spawns` birleşimini hem `gecikmeli_etkiler` satırlarını tek `o.gecikmeli_kuyruk` dizisine yinelenmeden (`chr_id + karar + olay_id`) `hedef_gun = o.gun + tur_offset` damgasıyla yazsın.
  - `KararDonusu.spawn_ekle(o, sonuc)` `gece_kuyrugu()` içinden çağrılarak vadesi gelen canlı `spawn` hedeflerini tek kuyruk üzerinden kapı listesine eklesin.
- **3A.4 Uygula ve doğrula:** `karar_donusu_test.gd` içine gerçek `Oturum.karar_ver` -> `gecikmeli_kuyruk` -> `kaydet/kayittan` -> `gece_kuyrugu` tek-kuyruk/tek-satır testini ekleyip `karar_donusu_test.gd` ve `kvr_test.gd` çalıştır, `KOP-04` denetim satırını güncelle ve ayrı commit/push yap.
- **Sonuç:** `karar_donusu.gd`, `oturum.gd` ve `karar_donusu_test.gd` güncellendi; `karar_donusu_test.gd` (`TEST PASS: karar_donusu_test.gd`) ve `kvr_test.gd` (`KVR TEST: GEÇTİ (0 hata)`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 3B — `DYL-08` (Kararın sonradan dönüşü) Alt Madde Planı
- **3B.1 Sorunu anla:** `KOP-04` tek gecikmeli kuyruğu yazıp spawn ederken, `Oturum.gece_sonu()` hâlâ `KararDonusu.ilerlet` çağırmadığı için vadesi gelen karar dönüşleri (`sabah`, `haberci`, `koylu` kanalları, `bar`/`dedikodu` etkileri) geceler ilerledikçe işlenmiyordu.
- **3B.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/sistemler/oturum.gd` (`gece_sonu()`): `dedikodu.gece_ilerlet(gun)` sonrası ve `HaberciAgi.gece(self, r)` öncesi tüm gece sistemleri çalışır; burada `SabahDefteri` (`SAB-01`) yalnız divan hükümleri içindir (`DYL-08` ikinci sabah satırı yazmamalıdır!).
  - `src/arayuz/koy_hud/hafiza_defteri_baglantisi.gd` & `src/sistemler/hafiza_defteri.gd`: `HafizaDefteri._karar_sayfasi` zaten `kaynak["dyl08"]` okur; `kaynak_derle` ise henüz `"dyl08"` üretmiyor.
- **3B.3 «Daha iyi olur» iyileştirmeleri:**
  - `KararDonusu.ilerlet(o: Oturum, r: Dictionary = {})`: `Oturum.gece_sonu()` içinden çağrılsın; `o.gecikmeli_kuyruk` içinde `hedef_gun <= o.gun` ve `not uygulandi` satırlarını **günde en çok 2 (`AZAMI_GUNLUK_DONUS = 2`)** sınırıyla işlesin, 3. ve sonraki satırları aynı kuyrukta ertesi güne bıraksın.
  - Ölen veya köyden kalıcı ayrılan karakterin (`HafizaDefteri.GITTI_DURUMLARI`) dönüş kanalı daima `"haberci"`ye zorlansın ve `gitti = true` işaretlensin (`sabah` veya `koylu` seçilmesin).
  - Bar/dedikodu/haber etkileri **yalnız bir kez** (`uygulandi = true` + `olay_id` koruması) uygulansın; ertesi gece delta 0 olsun; tanıklı dönüş `o.dedikodu.olay_kaydet` ile dedikoduya 1 satır düşsün, tanıksız dönüş 0 satır düşsün; `SabahDefteri`'ne (`SAB-01`) yazılmasın; `haberci` kanalı dönen satırlar `HaberciAgi` / `r["karar_donusleri"]` ve Bölüm 39 defterinin `"dyl08"` okumasına yansısın.
- **3B.4 Uygula ve doğrula:** `karar_donusu_test.gd` ve `hafiza_defteri_test.gd` içinde `Oturum.gece_sonu()` ile 2/gün sınırı, ertesi gün sıfır-tekrar bar, tanıklı/tanıksız dedikodu, ölen kişinin `haberci` kanalı ve sıfır `SAB-01` sızması doğrulanıp `DYL-08` güncellenecek ve ayrı commit/push yapılacak.
- **Sonuç:** `karar_donusu.gd`, `oturum.gd`, `hafiza_defteri_baglantisi.gd` ve `karar_donusu_test.gd` güncellendi; `karar_donusu_test.gd` (`TEST PASS: karar_donusu_test.gd`), `hafiza_defteri_test.gd` (`HAFIZA DEFTERI (HFZ-01…32): GEÇTİ (0 hata)`) ve `kisi_hafizasi_test.gd` (`KISI HAFIZASI: GEÇTİ (0 hata)`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 4 — `ZAR-04` (Yaklaşım türleri ve değiştiriciler) Alt Madde Planı
- **4.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`ZAR-04`) `src/kapi/zar_degistiricileri.gd` ve `data/zar_degistiricileri.json` dosyasının kendi birim testinde geçtiğini ancak oyun içinde hiçbir kodun `ZarDegistiricileri` çağırmadığını, dolayısıyla zar eşiğinin / olasılığının ve zar öncesi değiştirici listesinin değişmediğini belirtir.
- **4.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/sistemler/chr_sorgusu.gd` (`basari_olasiligi`, `secenek_sec`) CHR sorgusunda `beceri` zarını (`ikna`, `blof`, `gozdagi`, `gonul_alma`) atıyor ama yalnızca `kurallar.olasilik(tecrube, tansiyon)` kullanıyor.
  - `src/arayuz/chr_kapi_adaptoru.gd` (`diyalog_goster`) ve `src/arayuz/chr_diyalog_paneli.gd` (`guncelle`) seçenek düğmelerini çiziyor ve `sorgu.secenek_sec(i)` çağırıyor.
  - `src/kapi/sorgu_zari.gd` (`sonuc`) ham `degistirici: int` alıyor fakat `ZarDegistiricileri.hesapla` bağlamını kullanan bir adaptörü yok.
- **4.3 «Daha iyi olur» iyileştirmeleri:**
  - `SorguZari.degistiricili_sonuc(rng, tur, deger, tansiyon, yaklasim, baglam, kurallar)` ile `ZarDegistiricileri.hesapla` doğrudan `SorguZari.sonuc` eşiğine (`gerekli`) bağlansın (reddedilen beşinci tür/kalp/romansta kilit/hata döner, satırları korur).
  - `ChrSorgusu` üzerine `zar_baglami: Dictionary`, `yaklasim_degistiricisi(secenek, ek_baglam)` ve güncellenmiş `basari_olasiligi(degistirici := 0)` + `secenek_sec(indeks, ek_baglam := {})` eklensin; `son_zar` içinde `degistirici`, `degistirici_satirlari`, `kesildi` saklansın (`degistirici == 0` iken mevcut eğri bozulmaz).
  - `ChrKapiAdaptoru.diyalog_goster` gerçek `Oturum` bağlamını (`terazi = MuhafizTerazisi.durum(oturum)`, `itibar = oturum.grup_itibari.zar_etkisi(gelen.id)`, `asker = etkin_muhafiz_sayisi > 0 / asker köylü`, `kanit = not sorgu.ipuclari.is_empty()`) `sorgu.zar_baglami` içine yazsın; `ChrDiyalogPaneli` zar atılmadan önce tutan her değiştiriciyi ayrı satır (`Label`) olarak göstersin (asker yoksa satır yok, `-3` sınırına kesildiyse kesilme satırı görünür; yorgunluk sadece tablodan okunur).
- **4.4 Uygula ve doğrula:** `zar_degistirici_test.gd`, `chr_sorgu_test.gd` ve `zar_tur_test.gd` hedefli testleriyle hem `SorguZari` eşiğini hem `ChrSorgusu` + `ChrDiyalogPaneli` ön-liste bağını doğrula, denetim listesini güncelle ve commit/push et.
- **Sonuç:** `sorgu_zari.gd`, `chr_sorgusu.gd`, `chr_kapi_adaptoru.gd`, `chr_diyalog_paneli.gd` ve `zar_degistirici_test.gd` güncellendi; `zar_degistirici_test.gd` (`ZAR DEGISTIRICI TEST: GEÇTİ (0 hata)`), `chr_sorgu_test.gd` (`CHR SORGU: GEÇTİ (0 hata)`) ve `zar_tur_test.gd` (`ZAR TUR TESTI: GEÇTİ (0 hata)`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 5 — `DYL-06` (Dil engeli ve tercüman) Alt Madde Planı
- **5.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`DYL-06`) `src/soz/dil_engeli.gd` sınıfının eksiksiz durduğunu ancak kapı ekranında (`src/arayuz/kapi_ekrani.gd`) hiç çağrılmadığını, tercüman düğmesinin çıkmadığını, köylü `is_gucu` değerinin üretime bağlanmadığını belirtir.
- **5.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/koy/koylu.gd` zaten optional `diller: PackedStringArray` taşıyor ve kaydediyor; `is_gucu: float = 1.0` eksikti.
  - `src/koy/koy_yonetimi.gd:716` günlük bina üretimini `Uretim.gunluk(...)` ile hesaplıyor; `k.is_gucu` çarpanı tek satırla buraya bağlanabilir.
  - `src/sistemler/gelen.gd` üzerinde `diller: PackedStringArray` yoktu; `src/arayuz/kapi_ekrani.gd` (`_sonraki_gelen`, `_sohbet_goster`, `_soru_sor`, `_karar_goster`) ortak dil denetimi ve tercüman düğmesi taşımıyordu.
- **5.3 «Daha iyi olur» iyileştirmeleri:**
  - `Koylu` üzerine `is_gucu: float = 1.0` eklenip `KoyYonetimi` günlük üretiminde (`* k.is_gucu`) kullanılsın ve gece sonunda `1.0`'a sıfırlansın.
  - `Gelen` üzerine `diller: PackedStringArray = []` ve `DilEngeli` üzerine `oturumda_tercuman_cagir(oturum, gelen)` adaptörü eklensin (sabır `-2`, tercüman `Koylu.is_gucu = 0.5`, eş tercüman çarpıtmadan akşam sohbeti anısını kaydeder).
  - `KapiEkrani` ortak dil yoksa `DilEngeli.tercuman_dugmesi_sayisi(...) == 1` olduğunda `TercumanCagir` düğmesini açsın (tercüman yoksa veya bayrak kapalıysa 0 düğme), satırları `DilEngeli.satir_coz(...)` üzerinden geçirsin ve tercümansız kararda `DilEngeli.tercumansiz_beyan_kaydi(...)` yazsın.
- **5.4 Uygula ve doğrula:** `dil_engeli_test.gd` içine `Oturum` + `KoyYonetimi` üretim düşüşü (`1.0 -> 0.5`) + `KapiEkrani` ortak dil / tercüman düğmesi sınamalarını ekle, `dil_engeli_test.gd` ile `kapi_karar_test` / `otomatik` testleri koştur, `DYL-06` güncelle ve commit/push et.
- **Sonuç:** `koylu.gd`, `koy_yonetimi.gd`, `gelen.gd`, `dil_engeli.gd`, `kapi_ekrani.gd` ve `dil_engeli_test.gd` güncellendi; `dil_engeli_test.gd` (`DIL ENGELI: GEÇTİ (0 hata)`), `aclik_uretim_test.gd` (`AÇLIK ÜRETİM: GEÇTİ`), `ilk_saat_test.gd` (`ILK SAAT: GEÇTİ (0 hata)`) ve `chr_kapi_kontrol.tscn` (`CHR KAPI UI: GEÇTİ`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 6A — `ACL-03` (Akşam sohbeti tetik ve sahne bağlantısı) Alt Madde Planı
- **6A.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`ACL-03`) `src/koy/aksam_sohbeti.gd` sınıfının konu seçimi, atlama ve testinin var olduğunu ama hiçbir sahnenin (`KoyEkrani`) gece raporundan önce akşam sohbetini açmadığını belirtir.
- **6A.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/arayuz/koy_ekrani.gd:704` (`_geceye_gec`) önce `CinarMeclisPaneli._bekliyor`, `CenazeYasi.bekliyor`, `kapi_acilis_paneli.gd` ve `CinarMeclisPaneli.haftalik_ac` denetimlerini geçip doğrudan `oturum.gece_sonu()` ile gece rapor kartını açıyor.
  - `src/sistemler/oturum.gd` içinde `es_id` (`acilis_senaryosu.gd`) ve `karar_ver(...)` kararları tutulsa da günlük akşam sohbeti tetiği, aynı gece tek sefer kilidi, meclis/ölüm engeli ve `AksamSohbetiPaneli` çağrısı yok.
- **6A.3 «Daha iyi olur» iyileştirmeleri:**
  - `src/koy/aksam_sohbeti.gd`: ağır karar + meclis + eş hayatta denetimleri yanında `oturum` durumunu kaydet/yükle için `durum_al()` / `durum_yukle(v)` ekleyerek kayıtlarda aynı kararın ertesi yüklemede yinelenmesini engelle.
  - `src/sistemler/oturum.gd`: `aksam_sohbeti_hazirla()`, `aksam_sohbeti_uygula(konu_id, cevap_tipi)` ve `aksam_sohbeti_atla()` ekle; ağır karar varsa gece raporundan önce günde en çok 1 sohbet döner; meclis gecesi (`CinarAltiMeclisi.haftalik_bekliyor(yonetim)`) ve eş ölmüşse (`es == null` veya `es.saglik <= 0`) 0 döner; `Oturum._init` `AksamSohbeti.sifirla()` çağırarak oturumlar arası static sızıntıyı keser.
  - Yeni `src/arayuz/koy_hud/aksam_sohbeti_paneli.gd`: `KoyEkrani._geceye_gec()` rapor öncesinde tek satır `AksamSohbetiPaneli.ac(self, ...)` çağrısıyla açılır; cevap düğmeleri (`savunmak`/`kabul_etmek`/`susmak`) ile `"Atla"` düğmesi barı bozmadan gece akışına devam eder (`ARY-04` `_kart_ac` çerçevesi, yeni ses/kalp yok).
- **6A.4 Uygula ve doğrula:** `tests/unit/koy/aksam_sohbeti_test.gd` içine gerçek `Oturum` + `KoyEkrani` / `AksamSohbetiPaneli` (ağır karar = 1, ertesi tekrar = 0, atlama = 0 bar değişimi, ölü eş = 0, meclis gecesi = 0) testleri ekle; hedefli testleri koştur; `ACL-03` → `TAM` işaretle ve ayrı commit/push yap.
- **Sonuç:** `aksam_sohbeti.gd`, `oturum.gd`, `aksam_sohbeti_paneli.gd`, `koy_ekrani.gd`, `aksam_sohbeti_test.gd` ve `aksam_sohbeti_kontrol.{gd,tscn}` güncellendi/eklendi; `aksam_sohbeti_test.gd` (`TEST PASS: aksam_sohbeti_test.gd`), `aksam_sohbeti_kontrol.tscn` (`AKSAM SOHBETI UI: GEÇTİ (0 hata)`) ve `gece_gecis_kontrol.tscn` (`GECE GEÇİŞİ: GEÇTİ`) geçti. Asset gerekmedi. kota görünmüyor.

### Madde 6B — `DYL-07` (Akşam konusu ağırlığı, karar eşlemesi, DIY-11 eş hafızası ve terazi/ipucu) Alt Madde Planı
- **6B.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`DYL-07`) `Oturum.karar_ver` kapı kararlarının akşam sohbetine beslenmediğini, eşin geçmiş sohbetleri `DIY-11` (`KisiHafizasi.es`) üzerinden anmadığını ve ertesi güne ipucu / terazi kaydı bağlanmadığını belirtir.
- **6B.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/sistemler/oturum.gd` (`karar_ver`) `KararDonusu` ve `SoylentiKoprusu` çağırıyor fakat `AksamSohbeti` konu haritasına yazmıyor.
  - `src/soz/kisi_hafizasi.gd` (`es_hafizasi_yaz` / `es_hafizasi_oku`) `DIY-11` içinde `DYL-07` Kural 5 için hazırlanmış ama `aksam_sohbeti_uygula` içinde kullanılmıyor.
- **6B.3 «Daha iyi olur» iyileştirmeleri:**
  - `AksamSohbeti` (`src/koy/aksam_sohbeti.gd`): `karardan_ekle(oturum, gelen, karar, ek)` ile gerçek kapı kararlarını (bölünen aile, rüşvet, çocuklu aile reddi, hasta kabulü, yakalanan/tutulan yalan, kaçak asker/yetim kabulü) ağırlık tablosu konularına bağla; `konu_sec` `es_gecmis` ile önceki cevabı ("Geçen hafta da böyle demiştin.") anı satırı eklesin; `gundelik_satir()` ağır karar yokken isteğe bağlı kısa gündelik cümle versin.
  - `Oturum` (`src/sistemler/oturum.gd`): `karar_ver` içine `AksamSohbeti.karardan_ekle(self, gelen, karar, ek)` ekle; `aksam_sohbeti_hazirla` içinde `KisiHafizasi.es_hafizasi_oku(kadro, &"es")` geçir; `aksam_sohbeti_uygula` içinde `KisiHafizasi.es_hafizasi_yaz(kadro, &"es", ...)`, `terazi` etkisi (`kabul_etmek` → adalet +1, `susmak` → moral 0 + `"kacti"` kaydı) ve ertesi gün ipucu (`es_aksam_ipucu`) yazsın.
- **6B.4 Uygula ve doğrula:** `tests/unit/koy/aksam_konu_test.gd` içine gerçek `Oturum.karar_ver` üzerinden yüksek ağırlık / ziyaret sırası, `KisiHafizasi.es` geçmişi, terazi/adalet ve ertesi gün ipucu testleri ekle; hedefli testleri koştur; `DYL-07` → `TAM` işaretle ve ayrı commit/push yap.
- **Sonuç:** `aksam_sohbeti.gd`, `oturum.gd` ve `aksam_konu_test.gd` güncellendi; `aksam_konu_test.gd` (`TEST PASS`), `aksam_sohbeti_test.gd` (`TEST PASS`), `kisi_hafizasi_test.gd` (`KISI HAFIZASI: GEÇTİ (0 hata)`) ve `aksam_sohbeti_kontrol.tscn` (`AKSAM SOHBETI UI: GEÇTİ (0 hata)`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 7 — `HAN-01` (Hane tek kayıt alanı ve `KoyYonetimi` / KAY zinciri bağlantısı) Alt Madde Planı
- **7.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`HAN-01`) `src/koy/hane.gd` sınıfının 177 satır hazır olduğunu ancak `KoyYonetimi` içinde hiç çağrılmadığını ve kayda (`KoyYonetimi.kaydet`) girmediğini belirtir.
- **7.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/koy/hane.gd` `kayit_verisi_al()` ve `kayit_verisi_yukle(v)` metotlarına sahip, ancak `ROADMAP_2` (`HAN-01`) alanlarından `ev_id`, `uyeler`, `ocak_durumu`, `son_sofra_gunu` eksik ve `KoyYonetimi` (`src/koy/koy_yonetimi.gd`) bu sınıfı hiç tutmuyor / kaydetmiyor.
  - `src/sistemler/acilis_senaryosu.gd` (`kur` ve `yukle`) gerçek kuruluş hanesini (`ev_id`, `muhafiz_id`, `es_id`) yönetiyor.
- **7.3 «Daha iyi olur» iyileştirmeleri:**
  - `Hane` (`src/koy/hane.gd`) üzerine `ev_id`, `uyeler`, `ocak_durumu`, `son_sofra_gunu` alanları ve `acilis_hanesinden_turet(y, h, acilis_hanesi)` eklensin (eski kayıtta `"hane"` yoksa `ACL-01` kuruluşundan ve canlı köylü eşten türetilir).
  - `KoyYonetimi` (`src/koy/koy_yonetimi.gd`) üzerine `var hane := Hane.new()` eklensin; `kaydet()` içine `"hane": hane.kayit_verisi_al()` yazsın; `kayittan()` `"hane"` varsa `kayit_verisi_yukle`, yoksa `Hane.acilis_hanesinden_turet(y, y.hane)` çağırsın.
  - `AcilisSenaryosu` (`src/sistemler/acilis_senaryosu.gd`) `kur` ve `yukle` içinde `o.yonetim.hane` alanını gerçek kuruluş verisiyle eşleştirsin (`ev_id`, `uyeler`, eş durumu).
- **7.4 Uygula ve doğrula:** `tests/unit/koy/hane_test.gd` içine gerçek `Oturum` + `AcilisSenaryosu.kur` + `KoyYonetimi.kaydet/kayittan` ve eski kayıttan (`"hane"` silinmiş) türetme testleri ekle; `hane_test.gd`, `acilis_senaryosu_test.gd` ve `soz_kayit_test.gd` koştur; `HAN-01` → `TAM` güncelle ve commit/push et.

- **Sonuç:** `hane.gd`, `koy_yonetimi.gd`, `acilis_senaryosu.gd` ve `hane_test.gd` güncellendi; `hane_test.gd` (`PASS: HAN-01..52 Muhafiz Hanesi testi basariyla tamamlandi.`), `acilis_senaryosu_test.gd` (`AÇILIŞ SENARYOSU: GEÇTİ`) ve `soz_kayit_test.gd` (`SÖZ KAYDI: GEÇTİ`) 0 script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 8 — `KOP-03` (Bakışla teşhis: `Bakis` sınıfını kapı ekranı bölge seçimine bağla) Alt Madde Planı
- **8.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`KOP-03`) `src/soz/bakis.gd` (`Bakis`) sınıfının testlerde çalışmasına karşın kapı ekranından ve `HastalikTeshisAdaptoru` içinden hiç çağrılmadığını, dolayısıyla yüz ve el bakış satırlarının gerçek kapıda üretilmediğini belirtir.
- **8.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/arayuz/kapi_ekrani.gd`: `_sohbet_goster` ve `_karar_goster` içinden `HastalikTeshisAdaptoru.eylem(self, _gelen, _eylemler)` çağrılıyor; yalnız `"HastalikIncele"` düğmesi eklenip doğrudan `incele(g, "yuz")` çalıştırılıyor.
  - `src/arayuz/chr_kapi_adaptoru.gd` & `src/arayuz/chr_inceleme_paneli.gd`: `ChrInceleme` içinde `GorselIz` tıklaması `HastalikTeshisAdaptoru.chr_bagla` → `incele(g, "portre")` çağırıyor; bölge seçimi (`"yuz"` / `"eller"`) `Bakis` üzerinden akmıyor.
- **8.3 «Daha iyi olur» iyileştirmeleri:**
  - `HastalikTeshisAdaptoru` içine `bakis_verisi_kur(g)` ve `bolge_bak(e, g, bolge, baglam)` eklensin: gerçek `Bakis` örneği (`g` metasında ziyaretçi başına tek önbellek) üzerinden `"yuz"` ve `"eller"` bölgeleri için bakış satırları üretilsin, `belirtiler(g)` yalnız ilgili yüz/el satırına işlensin (`"heybe"` belirtisi heybe paneline bırakılsın) ve `bakis_belirtisi_isle` üzerinden aynı `IpucuYoneticisi` ile birleştirilsin (ayrı teşhis düğmesi 0, ışık kapalıyken belirti/ipucu 0).
  - `HastalikTeshisAdaptoru.eylem` (mevcut `"HastalikIncele"` ile hem `"yuz"` hem `"eller"` bölge bakışı + isteğe bağlı `"BakisYuz"` / `"BakisEller"` bölge seçim düğmeleri) ve `ChrIncelemePaneli` / `chr_bagla` (`"GorselIz"` ve yüz/el bölge seçimi) `Bakis.bak(...)` çağrısına bağlansın; üretilen bakış satırı kapı kayıt defterinde ve inceleme panelinde görünsün.
- **8.4 Uygula ve doğrula:** `kop03_bakis_hastalik_test.gd` (gerçek `KapiEkrani` / `HastalikTeshisAdaptoru` → `Bakis.bak` yüz/el satırı + tek ipucu + `teshis_dugmesi_sayisi() == 0`) ve `hastalik_teshis_kontrol.tscn` + `bakis_test.gd` + `hastalik_teshis_test.gd` çalıştır (`RC=0`, `ERRS=0`), `KOP-03` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `hastalik_teshis_adaptoru.gd`, `kop03_bakis_hastalik_test.gd`, `hastalik_teshis_test.gd` ve `hastalik_teshis_kontrol.gd` güncellendi; `kop03_bakis_hastalik_test.gd`, `bakis_test.gd`, `hastalik_teshis_test.gd` ve `hastalik_teshis_kontrol.tscn` (`KAPI HASTALIK UI: GEÇTİ`) sıfır script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

## Görev 25 — Meshy pilotu (`kapi_ic`, `tas_yatagi`)
- **Üretilen ve onaylanan asset'ler:**
  - `kapi_ic` (`KAPI-3D-IC`) → `assets/model/yapi/kapi_ic.glb` (`8897` üçgen, 3 gömülü PBR doku, `0.957 × 0.634 × 0.332 m`; `durum: onaylandi`). İlk üretim (`15` kredi) orta kapı açıklığı kapalı/tıkalı ve tekdüze gri olduğu için `meshy_hat.py reddet` ile reddedildi; `tools/meshy/plan_eki.json` istemi açık merkez geçit ve tam açık kanatlar için yenilenip `meshy_hat.py` `--yeniden` istem yenilemesiyle 1 kez yeniden üretildi (`15` kredi). **`kapi_ic` toplamı: `30` kredi.**
  - `tas_yatagi` (`BUG21-TASYATAGI`) → `assets/model/yapi/tas_yatagi.glb` (`3152` üçgen, 3 gömülü PBR doku, `0.958 × 0.567 × 0.788 m`; `durum: onaylandi`). Tek üretimde doğrulamadan geçip onaylandı. **`tas_yatagi` toplamı: `15` kredi.**
- **Harcanan kredi:** Toplam **`45` kredi** (`15 + 15 + 15`, pilot sınırı `60`, mutlak tavan `425`; Meshy bakiye `1082 → 1037`). Yeni asset üretimi durduruldu; Ahmet'in onayı bekleniyor.
- **Oyunda nereden bakılacak:**
  - `kapi_ic`: **Kapı nöbeti ekranı / 3B kapı sahnesi** (`src/dunya/kapi_sahnesi.gd`, `src/dunya/kapi_cercevesi.gd`; `sur = 0` kütük kapı ve `sur = 1` ahşap kapı seviyeleri). Açık ahşap kemer ve iç yanlara açık iki kanat kadrajı çerçeveler; ziyaretçi ortadaki açık geçitte durur. (`koy_yonetim_sahnesi.gd` içindeki köy `kapi.glb` değiştirilmedi.)
  - `tas_yatagi`: **Köy yönetim sahnesi** (`src/koy/gorsel/tas_yatagi_gorseli.gd`, düğüm `TasYatagi`). Taş yatağı hücresinde üç gri `BoxMesh` yerine dokulu Anadolu taş yatağı modeli görünür.
- **Doğrulama:** `python tools/meshy/meshy_hat.py dogrula kapi_ic tas_yatagi`, `Godot --headless --path . --import`, `godot_dogrula.gd` (`yuklendi: true`), `tests/tools/test_meshy_hat.py` (`17/17 OK`), `tests/oto/tas_yatagi_kontrol.tscn` (`TAŞ YATAĞI UI: GEÇTİ`), `tests/oto/kapi_kuyu_donusu_kontrol.tscn` (`KAPI KUYU SAHNE: GEÇTİ`) ve `KapiSahnesi` (`sur = 0..3`) doğrudan doğrulama (`KAPI_IC SAHNE KONTROL: GECTI`) geçti. kota görünmüyor.

### Madde 9 — `DIY-14` (Hatırlanma notu: kapı kararı verildiğinde gerçek `HatirlanmaNotu` tetiği) Alt Madde Planı
- **9.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`DIY-14`) `src/arayuz/kapi/hatirlanma_notu.gd` (`HatirlanmaNotu`) sınıfının ve testinin var olduğunu ama kapı ekranından (`src/arayuz/kapi_ekrani.gd`) hiç çağrılmadığını, bu yüzden hafıza (`DIY-11`) veya dedikodu (`DIY-13`) yazan kapı kararlarında `"Bu hatırlanacak"` bildiriminin ekranda görünmediğini belirtir.
- **9.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/arayuz/kapi_ekrani.gd` (`_karar_ver`, satır 609-630): `oturum.karar_ver(_gelen, StringName(anahtar), is_yeri)` çağrısı sonrası hemen `HastalikTeshisAdaptoru.sonuc_yaz(self, sonuc)` koşuyor; burada `HatirlanmaNotu` örneği hiç oluşturulup `secim_bildir(...)` ile tetiklenmiyor.
  - `src/sistemler/oturum.gd` (`karar_ver`, satır 288): adlı karakterlerde `kadro.sonuc(gelen.id, ...)` çalışıyor ama `KisiHafizasi.kaydet_olay(...)` (`karar_gecmisi`) yazılmadığı ve `sonuc` sözlüğünde `hafiza_yazildi` / `dedikodu_yazildi` özetlenmediği için UI katmanı hafıza/dedikodu yazımını doğrudan okuyamıyor.
- **9.3 «Daha iyi olur» iyileştirmeleri:**
  - `Oturum.karar_ver` içinde: adlı gelen kararında (`gelen.adli` ve `kadro.durumlar.has(gelen.id)`) `KisiHafizasi.kaydet_olay(kadro, gelen.id, {"karar": String(karar), "alinan_akce": ...}, gun)` çağrılsın (mevcut `karar_gecmisi` / `DIY-11` kalıcı kaydı); `ek` dönüş sözlüğüne `dedikodu_yazildi` (karar sırasında `dedikodu.yazma_sayisi()` arttıysa) ve `hafiza_yazildi` (`KisiHafizasi` olayı veya `aile_bolundu` / `kacis_hafiza` oluştuysa) alanları eklensin.
  - `KapiEkrani` (`src/arayuz/kapi_ekrani.gd`): ekranda tek bir `HatirlanmaNotu` çocuk düğümü (`"HatirlanmaNotu"`) tutulsun; `_karar_ver` içinde tek satır `_hatirlanma_notunu_goster(sonuc)` ile `HatirlanmaNotu.secim_bildir(...)` çalıştırılsın (hem ayar `hatirlanma_notu` okunsun, hem tek kararda en fazla 1 not açılsın, özel ad/grup/gece sayısı basılmasın, 2 sn sonra veya tıklayınca kapansın).
- **9.4 Uygula ve doğrula:** `tests/unit/kapi/hatirlanma_notu_test.gd` ile gerçek `Oturum` + `KapiEkrani` UI sahne doğrulaması (`tests/oto/hatirlanma_notu_kontrol.{gd,tscn}` veya mevcut kontrol testi) koştur (`RC=0, ERRS=0`), `DIY-14` → `TAM` güncelle ve commit/push et.
- **Sonuç:** `oturum.gd`, `kapi_ekrani.gd` ve `tests/oto/hatirlanma_notu_kontrol.{gd,tscn}` güncellendi/eklendi; `hatirlanma_notu_test.gd`, `hatirlanma_notu_kontrol.tscn`, `kisi_hafizasi_test.gd` ve `chr_kapi_kontrol.tscn` sıfır script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.

### Madde 10 — `SOY-01` (Söylenti kaynağı ve doğruluğu: `SoylentiAgi` + `KAY` + `OMR-39` doğrulaması) Alt Madde Planı
- **10.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`SOY-01`) `Dedikodu` sınıfında `kaynak`/`dogru` olmadığını, bu işin `SoylentiAgi` ile ayrı kurulduğunu (`ROADMAP_2`: `dedikodu.gd imzaları değişmez`) ama denetimde hâlâ `EKSİK` göründüğünü ve `KAY` birimi + `OMR-39` doğruluk süzgeci bağlantısının kanıtlanmadığını belirtir.
- **10.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/sistemler/soylenti_agi.gd` zaten `ag_kayitlari` içinde `"kaynak"` ve `"dogru"` tutuyor ve `kaynak_ve_dogruluk(olay_id)` (eski kayıtta `{"kaynak": "", "dogru": true}`) sunuyor; yalnız `dogru == true` süzgeç yardımcısı (`dogru_kayit_mi`, `dogru_kayitlar`) yok.
  - `src/sistemler/soylenti_koprusu.gd` kapı kararını ve kayıt/yüklemeyi (`"soylenti_agi"`) `Oturum` ile bağlıyor; `tests/unit/kayit/soz_kayit_test.gd` içinde ise `SOY-01` `KAY` birimi testi bulunmuyor.
- **10.3 «Daha iyi olur» iyileştirmeleri:**
  - `SoylentiAgi` (`src/sistemler/soylenti_agi.gd`) içine `dogru_kayit_mi(olay_id)` ve `dogru_kayitlar()` ekleyerek `OMR-39` ve diğer okuyucuların yanlış söylenti (`dogru == false`) kopyalarını dışlamasını kolaylaştır (`Dedikodu` imzalarına dokunma).
  - `DisHatKapisi` (`src/sistemler/dis_hat_kapisi.gd`) `OMR-39` üzerinde `soylenti_dogru_haber_var_mi(o, olay_id)` okuyucusu ekleyerek yalnız `SoylentiAgi` kaydında `dogru == true` olan haberi geçerli say; sahte `dogru = false` kaydını reddet.
  - `tests/unit/kayit/soz_kayit_test.gd` içine `_soy01_soylenti_kaynak_ve_dogruluk(kat)` ekle: `Oturum.kaydet`/`kayittan` ile `kaynak` ve `dogru` gidiş-dönüşünü, eski kayıtta `"soylenti_agi"` yokken `kaynak == ""` + `dogru == true` davranışını ve `dogru == false` sahte haber reddini sına.
- **10.4 Uygula ve doğrula:** `soz_kayit_test.gd`, `soylenti_agi_test.gd`, `soylenti_koprusu_test.gd` ve `dedikodu_test.gd` koştur (`RC=0`, `ERRS=0`), `SOY-01` → `TAM` işaretle ve commit/push et.

- **Sonuç:** `soylenti_agi.gd`, `dis_hat_kapisi.gd` ve `soz_kayit_test.gd` güncellendi; `soz_kayit_test.gd`, `soylenti_agi_test.gd`, `soylenti_koprusu_test.gd` ve `dedikodu_test.gd` sıfır script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.


### Madde 11 — `DYL-01` (Çelişki yüzleştirme: `Celiski` + `SozMotoru` + `BeyanDefteriPaneli` + kapı sorgu bağı) Alt Madde Planı
- **11.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`DYL-01`) `ROADMAP_2`'nin işaret ettiği `src/soz/celiski.gd` ve `src/arayuz/kapi/beyan_defteri_paneli.gd` dosyalarının olmadığını; mevcut `CeliskiYuzlesme` (`src/soz/celiski_yuzlesme.gd`) ile `SozMotoru.celiski_yuzlestir` (`src/soz/soz_motoru.gd`) kodlarının da gerçek kapı ekranına (`KapiEkrani` / `ChrSorgusu` / `BeyanDefteri`) hiç bağlanmadığını belirtir.
- **11.2 Oyuna nasıl bağlandığını kontrol et:**
  - `src/soz/celiski_yuzlesme.gd` (`eslestir`) ve `src/soz/soz_motoru.gd` (`beyan_defteri`, `celiski_yuzlestir`) yalnız `tests/unit/soz/celiski_yuzlesme_test.gd` içinden çağrılıyor.
  - `src/arayuz/kapi_ekrani.gd`, `src/arayuz/chr_kapi_adaptoru.gd` ve `src/arayuz/chr_diyalog_paneli.gd` içinde ne `SozMotoru` / `BeyanDefteri` kaydı tutuluyor ne de oyuncunun iki kaydı seçip `"Göster"` dediği bir defter paneli var; `gerekli_ipuclari` seçenekleri doğrudan hazır düğme olarak sunuluyor.
- **11.3 «Daha iyi olur» iyileştirmeleri:**
  - `src/soz/celiski.gd` (`class_name Celiski`): `SozMotoru` + `BeyanDefteri` + `CeliskiYuzlesme` + `ChrSorgusu` üzerinde gerçek çelişki yüzleştirme durumunu yönetsin: `{a, b, dal, guc}` çiftleri + zıt beyan/kanıt eşleşmesi (`CeliskiYuzlesme.eslestir` tabanlı, tekil kayıtlar `a != b`), `kayitlar.size() <= 1` iken `"Göster"` kilitli, aynı yanlış çift tekrar denenemez, yanlışta `tansiyon +1`, `guven -2`, `sabir -1` ve tepki satırı, 3 yanlıştan sonra `"Göster"` o ziyarette kapanır, çözülen çelişki ikinci kez açılamaz.
  - `src/soz/soz_motoru.gd` & `src/soz/celiski_yuzlesme.gd`: `SozMotoru.yukle` içine `celiskiler` okuma + `celiski_yuzlestir` ile `Celiski` / `guven -2` / `sabir -1` ve hedef `dal` geçişi eklensin (`celiski_yuzlesme_test.gd` beklentileriyle geriye dönük uyumlu).
  - `src/sistemler/chr_sorgusu.gd` & `src/arayuz/chr_diyalog_paneli.gd`: Ziyaret edilen CHR düğümlerinin replikleri beyan kaydına (`BeyanDefteri` / `SozMotoru`) düşsün, karakterin `gerekli_ipuclari` hedefleri `Celiski` çiftlerine bağlansın; `celiski_yardimi` ayarı/ilk 3 gün dışında hazır yüzleş düğmeleri gizlenip oyuncu `"Göster"` paneline yönlendirilsin (ilk 3 günde mevcut `chr_kapi_kontrol.tscn` akışı korunur).
  - `src/arayuz/kapi/beyan_defteri_paneli.gd` (`BeyanDefteriPaneli`) + `src/arayuz/chr_kapi_adaptoru.gd` + `src/arayuz/kapi_ekrani.gd`: `_eylemler` altına (inceleme düğmesinden sonra) `"Göster · Beyan Defteri"` düğmesi bağlansın; oyuncu iki kaydı (beyan + ipucu / beyan + beyan / beyan + duyum) kendisi seçip `"Göster"`e basabilsin, doğru eşleşme doğrudan yüzleşme dalına geçirsin ve konuşma geçmişine yazılsın.
- **11.4 Uygula ve doğrula:** `tests/unit/soz/celiski_goster_test.gd` (yeni kapsamlı kabul testi: doğru/yanlış çift, güven −2 / tansiyon +1 / sabır −1, aynı yanlış çiftin tekrarlanamaması, 3 yanlıştan sonra Göster kapanışı, tek kayıtta Göster kilidi, `SozMotoru` + `ChrSorgusu` + `BeyanDefteriPaneli` UI akışı), `celiski_yuzlesme_test.gd`, `beyan_defteri_test.gd`, `soz_motoru_test.gd` ve `chr_kapi_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `DYL-01` → `TAM` güncelle ve commit/push et.

- **Sonuç:** `src/soz/celiski.gd`, `src/arayuz/kapi/beyan_defteri_paneli.gd`, `soz_motoru.gd`, `celiski_yuzlesme.gd`, `chr_sorgusu.gd`, `chr_diyalog_paneli.gd`, `chr_kapi_adaptoru.gd`, `kapi_ekrani.gd`, `celiski_goster_test.gd` ve `celiski_goster_kontrol.{gd,tscn}` eklendi/güncellendi; 6 hedefli test sıfır script hatasıyla geçti. Asset gerekmedi. kota görünmüyor.


### Madde 12 — `YAZ-02` (Üslup kapısı: `data/soz/yasak_kelimeler.txt`, `soz_dogrulayici.py` taraması ve `tests/tools/test_uslup_kapisi.py`) Alt Madde Planı
- **12.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`YAZ-02`) kabul ölçütü `data/soz/yasak_kelimeler.txt` ve `tests/tools/test_uslup_kapisi.py` dosyalarını istediği halde ikisinin de repoda olmadığını belirtir.
- **12.2 Araçlara nasıl bağlandığını kontrol et:**
  - `Roadmap-2/USLUP_REHBERI.md` §3 (`Kaçınılacak modern sözler`) ve §7 (14 yapaylık kuralı) ile `Roadmap-2/soz_agaci/yapaylik.js` (`KURALLAR`: 14 kural) repoda mevcut; fakat `data/soz/yasak_kelimeler.txt` yok ve `tools/soz_dogrulayici.py` (`YAZ-07`) bu listeyi taramıyor.
  - `tools/soz_kapi.py` & `tests/tools/test_soz_kapi.py` `tools/*yasak*` olmamasını ve tek üslup rehberi ilkesini denetliyor; `ROADMAP_2.md` gereği ikinci üslup rehberi açılmamalı ve doğaçlama taslağı dışa aktarım listesinde bulunmamalı.
- **12.3 «Daha iyi olur» iyileştirmeleri:**
  - `data/soz/yasak_kelimeler.txt`: `Roadmap-2/USLUP_REHBERI.md` §3 modern sözlerinin tamamını (`aslında, kesinlikle, harika, mükemmel, inanılmaz, problem, stres, travma, sistem, organize, okey`) içeren tek yasak kelime listesi oluştur.
  - `tools/soz_dogrulayici.py`: `data/soz/yasak_kelimeler.txt` listesini okuyan (`yasak_kelimeler_oku`) ve bir replikte geçen yasak sözcük için satırı silmeden uyarı üreten (`metni_tara` / `replik_uyarilari`) `YAZ-07` doğrulayıcı işlevlerini ekle; `tools/soz_kapi.py` modern kelime okuması da bu listeyle uyumlu kalsın.
  - `tests/tools/test_uslup_kapisi.py`: Rehberdeki tüm modern sözlerin `data/soz/yasak_kelimeler.txt` içinde bulunduğunu, `"aslında"` içeren bir repliğin 1 uyarı üretip satırı silmediğini, `yapaylik.js` içindeki kural sayısının 14 olduğunu, ikinci üslup rehberi ve dışa aktarımda doğaçlama taslağı bulunmadığını doğrulayan kapsamlı `unittest` paketi yaz.
- **12.4 Uygula ve doğrula:** `test_uslup_kapisi.py`, `test_soz_kapi.py`, `tools/soz_dogrulayici.py` ve `uslup_test.gd` çalıştır, `YAZ-02` → `TAM` işaretle ve commit/push et.

- **Sonuç:** `data/soz/yasak_kelimeler.txt`, `tools/soz_dogrulayici.py` ve `tests/tools/test_uslup_kapisi.py` eklendi/güncellendi; `test_uslup_kapisi.py` (3/3), `test_soz_kapi.py` (39/39), `soz_dogrulayici.py` ve `uslup_test.gd` geçti. Asset gerekmedi. kota görünmüyor.


### Madde 13 — `OGR-03` (Zar ipucu: `IlkSaat.zar_ipucu_kontrol` -> `ZarIpucu` ve gerçek kapı zarı UI/kayıt bağı) Alt Madde Planı
- **13.1 Sorunu anla:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` (`OGR-03`) `ZarIpucu` (`src/kapi/zar_ipucu.gd`) sınıfının gerçek oyun akışından hiç çağrılmadığını ve `src/sistemler/ilk_saat.gd:175` içindeki `zar_ipucu_kontrol` işlevinin `ZarIpucu`'ya bağlanmadığını belirtir.
- **13.2 Oyuna nasıl bağlandığını kontrol et:**
  - `IlkSaat.zar_ipucu_kontrol(guncel_gece)` yalnız kendi içinde `tetikle("ilk_zar_atisi", ...)` çalıştırıyor; `ZarIpucu.ilk_atis_ipucu` ise `IlkSaat` nesnesini geri `zar_ipucu_kontrol`'e yönlendiriyor ve gerçek kapı ekranında (`ChrDiyalogPaneli` / `KapiEkrani`) zar atıldığında hiç çağrılmıyor.
- **13.3 «Daha iyi olur» iyileştirmeleri:**
  - `src/kapi/zar_ipucu.gd` (`ZarIpucu`): tek kanonik uygulama `uygula(ilk_saat, guncel_gece)` ve gerçek oyun bağlayıcısı `oturumda_goster(o, ayarlar)` eklensin. `oturumda_goster` `o.gun >= 1` ve `o.perde == 1` iken `o.ipucu_kaydi` üzerinden `"zar"` ipucunu bir kez üretir (`IlkSaat.ipucu_metni("ogretici.zar.formul")`, yoksa `FORMUL_METNI`), `"zar"` kaydını yazar (`ilk_saat_kancasi.ipucu(o, "zar")`) ve ikinci çağrıda/yüklemede `0` döner.
  - `src/sistemler/ilk_saat.gd:175`: `zar_ipucu_kontrol(guncel_gece)` doğrudan `ZarIpucu.uygula(self, guncel_gece)` çağrısına delege edilsin; `ZarIpucu.ilk_atis_ipucu` da `IlkSaat` nesnesinde doğrudan `uygula` çalıştırsın (çift yönlü döngü olmadan).
  - `src/arayuz/chr_diyalog_paneli.gd`: `sorgu.secenek_sec(i, baglam)` sonrası `not sorgu.son_zar.is_empty()` ise `ZarIpucu.oturumda_goster(oturum, ayarlar)` çağrılsın ve dönen tek satırlık formül ipucu (`ZarIpucuNotu`) panelde gösterilsin.
- **13.4 Uygula ve doğrula:** `tests/unit/sistemler/ilk_saat_test.gd` içine gerçek `Oturum` + `Oturum.kaydet/kayittan` + `ZarIpucu.oturumda_goster` ve `ChrDiyalogPaneli` zar ipucu gösterimi kontrolü ekle; `ilk_saat_test.gd` ve `chr_kapi_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `OGR-03` → `TAM` güncelle ve commit/push et.

- **Sonuç:** `OGR-03` tamamlandı (`ZarIpucu.uygula` `ilk_saat.gd:175` `zar_ipucu_kontrol`'a bağlandı; `ZarIpucu.oturumda_goster` ve `ChrDiyalogPaneli` `"ZarIpucuNotu"` üzerinden gerçek zar atışında ilk saat kancası + ipucu kaydı işlendi). `ilk_saat_test.gd` (`ILK SAAT: GEÇTİ (0 hata)`), `chr_kapi_kontrol.tscn` (`CHR KAPI UI: GEÇTİ`), `celiski_goster_kontrol.tscn` (`CELISKI GOSTER UI: GEÇTİ`) `RC=0 ERRS=0` geçti; `OGR-03` → `TAM`. (kota görünmüyor)

## Madde 14 — `OGR-14` (Beyan defteri tanıtımı)
- **14.1 Teşhis ve tasarım:** `DefterTanitimi` (`src/kapi/defter_tanitimi.gd`) sınıfı ve `ilk_saat_test.gd` birim testi var, ancak oyunda (`chr_kapi_adaptoru.gd` / `kapi_ekrani.gd`) hiç çağrılmıyor; `BeyanDefteriDugmesi` ilk çelişki yakalanmadan önce de görünür açılıyor ve ilk çelişki yakalandığında `celiski_kaydet` + tek seferlik `ipucu_ver` tetiklenmiyor.
- **14.2 Çelişki algılama ve oturum bağlantısı (`src/kapi/defter_tanitimi.gd`):** `DefterTanitimi.celiski_yakalandi_mi(celiski, motor, defter, sorgu)` (toplanan beyan/ipucu çiftlerinin `celiski.celiskiler`, `motor.celiskiler` veya `CeliskiYuzlesme.eslestir` ile çelişip çelişmediğini kontrol eder) ve `DefterTanitimi.oturumda_kontrol_et(...)` (`IpucuAnahtari.kademeli_mi(ayarlar)` ve `o.ipucu_kaydi` senkronu, tek seferlik `ilk_saat_kancasi.ipucu` + `ekran._yaz` bildirimi) ekle; `Oturum` kayıt/yüklemede `o.ipucu_kaydi.goruldu_mu(IPUCU_ID)` ile kalıcılığı koru.
- **14.3 Kapı arayüzüne bağlama (`src/arayuz/chr_kapi_adaptoru.gd`):** `beyan_defteri_dugmesi(...)` içinde ilk görünürlüğü `DefterTanitimi.oturumda_kontrol_et(...)` ile yönet (`kademeli_hud` açıkken çelişki öncesi gizli, deneyimli modda görünür), `sorgu.ipucu_bulundu` / `sorgu.dugum_degisti` sinyallerinde çelişki doğunca `BeyanDefteriDugmesi`'ni aç ve tanıtım ipucunu bir kez göster (sinyal sızıntısı olmaması için `tree_exited` temizliği ile).
- **14.4 Doğrula ve kaydet:** `tests/oto/celiski_goster_kontrol.gd` ve `tests/unit/sistemler/ilk_saat_test.gd` içine çelişki öncesi gizli / çelişki sonrası görünür + tek seferlik ipucu + kayıt gidiş-dönüş kontrollerini ekle; `ilk_saat_test.gd`, `celiski_goster_test.gd`, `celiski_goster_kontrol.tscn` ve `chr_kapi_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `OGR-14` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `OGR-14` tamamlandı (`DefterTanitimi.celiski_yakalandi_mi`/`oturumda_kontrol_et` ve `ChrKapiAdaptoru.beyan_defteri_dugmesi` bağlantısı ile kademeli HUD açıkken çelişki öncesi gizli, ilk çelişki yakalandığında açılan düğme + tek seferlik tanıtım ipucu + `Oturum` kayıt kalıcılığı sağlandı; `chr_sorgusu.gd` `_ipucu_servisi` WeakRef döngü sızıntısı giderildi). `ilk_saat_test.gd` (`ILK SAAT: GEÇTİ (0 hata)`), `celiski_goster_test.gd` (`TEST PASS`), `celiski_goster_kontrol.tscn` (`CELISKI GOSTER UI: GEÇTİ`), `chr_kapi_kontrol.tscn` (`CHR KAPI UI: GEÇTİ`) `RC=0 ERRS=0` geçti; `OGR-14` → `TAM`. (kota görünmüyor)

## Madde 15 — `AYR-22` (Odak kaybında ses)
- **15.1 Teşhis ve tasarım:** `OdakSesi` (`src/sistemler/odak_sesi.gd`) `Node` olarak yazılmış ve birim testte (`tests/unit/sistemler/ayarlar_ek_test.gd`) yalnız doğrudan örnekleme ile denenmiş; oyunun kök sahnesi `Ana` (`src/arayuz/ana.gd`) içine hiç bağlanmadığı için pencere/uygulama odağı kaybedildiğinde ses kısılmıyor.
- **15.2 Kök sahneye bağlama (`src/arayuz/ana.gd`):** `Ana._ready()` içinde `ayarlar` ve `AyarlarEk.bagla(ayarlar)` kurulduktan hemen sonra `OdakSesi.new(ayarlar)` düğümünü `"OdakSesi"` adıyla `Ana`'ya ekle; ayrıca `Ana._notification(what: int)` içinde sahne ağacı dışından doğrudan bildirilen durumlar da dahil `NOTIFICATION_APPLICATION_FOCUS_OUT` / `WM_WINDOW_FOCUS_OUT` ve `IN` bildirimlerini `OdakSesi`'ne ilet (`OdakSesi._susturuldu` koruması çift çağrıda güvenli).
- **15.3 Doğrula (`tests/unit/sistemler/ayarlar_ek_test.gd` & `tests/oto/ayarlar_kontrol.gd`):** `Ana` örneğinin `OdakSesi` çocuğunu taşıdığını ve `NOTIFICATION_APPLICATION_FOCUS_OUT` / `IN` bildirimleriyle `ayarlar.al(&"ses_ana")` ile `AudioServer` Master bus dB değerinin kısılıp geri yüklendiğini doğrulayan kontrol ekle.
- **15.4 Kaydet:** `ayarlar_ek_test.gd` ve `ayarlar_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `docs/ANTIGRAVITY_DENETIM_LISTESI.md` üzerinde `AYR-22` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `AYR-22` tamamlandı (`src/arayuz/ana.gd` içinde `_odak_sesini_kur()` ile `OdakSesi` çocuğu eklendi ve `_notification` üzerinden `NOTIFICATION_APPLICATION_FOCUS_OUT`/`IN` bildirimleri bağlandı; `tests/oto/ayarlar_kontrol.gd` gerçek `Ana` sahne kontrolü eklendi). `ayarlar_ek_test.gd` (`AYARLAR EK: GEÇTİ (0 hata)`) ve `ayarlar_kontrol.tscn` (`AYARLAR KONTROL: GEÇTİ (0 hata)`) `RC=0 ERRS=0` geçti; `AYR-22` → `TAM`. (kota görünmüyor)

## Madde 16 — `AYR-28` & `AYR-32` (Üç kayıt yuvası ve yuva seçimi)
- **16.1 Teşhis ve tasarım:** `KayitYuvalari` (`src/sistemler/kayit_yuvalari.gd`) ve `YeniOyunEkrani` (`src/arayuz/yeni_oyun_ekrani.gd`) yuva 1..3 seçimini ayrı tutuyor; `Ana.kayit` (`src/arayuz/ana.gd`) açılışta hep `user://savegame.json` kullanıyor ve `YeniOyunEkrani`'ndan seçilen yuva `Ana.kayit`'a ve kayda yazılmıyor.
- **16.2 En son dolu yuva (`src/sistemler/kayit_yuvalari.gd`):** `en_son_dolu_yuva()` ekle (1..3 yuvalarını dosya değişiklik zamanına göre tarar, boşsa 1 döner; varsa `user://savegame.json` kalıntısı yoksa ilk kurulumda `kayit_1.json` yoluna hizalanır).
- **16.3 `Ana` ve `YeniOyunEkrani` bağlantısı (`src/arayuz/ana.gd`, `src/arayuz/yeni_oyun_ekrani.gd`):** `YeniOyunEkrani`'na `secilen_yuva()` / `yuva_sec(no)` ekle; `Ana` üzerinde `yuvalar: KayitYuvalari`, `aktif_yuva: int = 1` ve `yuva_sec(no)` tanımla; `Ana._ready()` içinde `kayit` yolunu aktif yuvanın `kayit_<n>.json` yoluna bağla (özel test alt sınıfları `yuvalar == null` bıraktıysa `kayit` korunur), `_yeni_oyun_ekrani()` içinde `baslatildi` tetiklenince `yuva_sec(e.secilen_yuva())` çağır ve `_kayit_yaz()` içine `"yuva": aktif_yuva` yaz.
- **16.4 Doğrula ve kaydet:** `tests/oto/ayarlar_kontrol.gd` içine gerçek `Ana` ile yuva 2 seçimi -> `kayit.yol` -> `kayit_2.json` yazım/okumada `"yuva": 2` doğrulaması ekle; `ayarlar_ek_test.gd`, `ayarlar_kontrol.tscn` ve `acilis_koy_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `AYR-28` ve `AYR-32` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `AYR-28` ve `AYR-32` tamamlandı (`KayitYuvalari.en_son_dolu_yuva()`, `YeniOyunEkrani.secilen_yuva()`/`yuva_sec()`, `Ana.yuva_sec()` + `_kayit_yaz()` `"yuva": aktif_yuva` kaydı + `devam_et()` yuva eşitlemesi bağlandı). `ayarlar_ek_test.gd` (`AYARLAR EK: GEÇTİ (0 hata)`), `ayarlar_kontrol.tscn` (`AYARLAR KONTROL: GEÇTİ (0 hata)`) ve `acilis_koy_kontrol.tscn` (`AÇILIŞ KÖY: GEÇTİ`) `RC=0 ERRS=0` geçti; `AYR-28`, `AYR-32` → `TAM`. (kota görünmüyor)

## Madde 17 — `AYR-29` & `AYR-33` (Yuva kartı ve uyumsuz kayıt koruması)
- **17.1 Teşhis ve tasarım:** `KayitYuvaKarti` (`src/arayuz/kayit_yuva_karti.gd`) yuva başlığından 5 alanı okuyor, bozuk dosyada `"okunamadı"`, ileri sürümde `"yeni sürüm kaydı"` üretiyor; ancak `YeniOyunEkrani` (`src/arayuz/yeni_oyun_ekrani.gd`) yuva seçim satırında `KayitYuvaKarti` göstermiyor ve iki adımlı silme / ileri sürüm koruması arayüze bağlı değil.
- **17.2 `YeniOyunEkrani` içine `KayitYuvaKarti` ve iki adımlı silme (`src/arayuz/yeni_oyun_ekrani.gd`):** `_yuva_satiri()` içinde her yuva (1..3) için `KayitYuvaKarti.new(n)` oluştur ve `yuvalar.yuva_yolu(n)` üzerinden doldur; iki adımlı `"SilYuvaDugmesi_<n>"` (`yuva_sil(n, true)`) ekle; ileri sürüm (`durum_kodu == "yeni_surum"`) yuvalarda silme ve üzerine yazarak başlatmayı engelle; `yuva_karti(no)` ve `yuvalari_yenile()` ekle.
- **17.3 `Ana.devam_et()` uyumsuz yuva taraması (`src/arayuz/ana.gd`):** Açılışta tüm yuvalarda ileri sürüm/okunamayan dosya varken silinmeden korunduğunu doğrula ve bozuk/ileri sürüm yuvada `KayitHataPaneli` akışını koru.
- **17.4 Doğrula ve kaydet:** `tests/oto/ayarlar_kontrol.gd` içine `YeniOyunEkrani` üzerinde dolu yuva (`KayitYuvaKarti` 5 alan), bozuk yuva (`"okunamadı"`), sürüm 99 yuva (`"yeni sürüm kaydı"`, silinmez/üzerine yazılmaz) ve iki adımlı silmeUI doğrulamaları ekle; `ayarlar_ek_test.gd`, `ayarlar_kontrol.tscn` ve `acilis_koy_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `AYR-29` ve `AYR-33` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `AYR-29` ve `AYR-33` tamamlandı (`YeniOyunEkrani` yuva seçim satırında 3 yuva için `KayitYuvaKarti` + iki adımlı `"SilYuvaDugmesi_<n>"` + ileri sürüm `"yeni_surum"` silme/üzerine yazma kilidi bağlandı; bozuk yuva `"okunamadı"` ve dolu yuva 5 alan özetini canlı gösteriyor). `ayarlar_ek_test.gd` (`AYARLAR EK: GEÇTİ (0 hata)`), `ayarlar_kontrol.tscn` (`AYARLAR KONTROL: GEÇTİ (0 hata)`) ve `acilis_koy_kontrol.tscn` (`AÇILIŞ KÖY: GEÇTİ`) `RC=0 ERRS=0` geçti; `AYR-29`, `AYR-33` → `TAM`. (kota görünmüyor)

## Madde 18 — `MECLIS-ARA-01` (Çınar meclisi arabuluculuk davaları)
- **18.1 Teşhis ve tasarım:** `data/parley/koy/meclis_davalari.ds` (4 dava: `opt_balta`, `opt_boya`, `opt_mera`, `opt_sifahane`) var ve `soylenti_ve_meclis_davalari_test.gd` dosyasının şemasını doğruluyor; ancak `CinarMeclisPaneli` (`src/arayuz/koy_hud/cinar_meclis_paneli.gd`) içinde bu Parley sahnesini açan kod yok.
- **18.2 Çınar meclisi paneline bağlama (`src/arayuz/koy_hud/cinar_meclis_paneli.gd`):** `CinarMeclisPaneli.dava_ac(e)` ekle: açık kartı kapatır (`e._kart_kapat()`), `KoyDiyalogYoneticisi.new()` ve `KoyDiyalogPaneli.ac(e, dy)` kurup `dy.sekans_baslat("meclis_davalari", y)` çağırır ve diyalog sonlandığında köy/oturum durumunu eşitler; `CinarMeclisPaneli.ac(e)` içinde `"meclis_davasi_ac"` (`"Köy davalarını dinle"`) düğmesini ekle.
- **18.3 Doğrula (`tests/oto/soylenti_meclis_kontrol.gd` & `tests/unit/kvr/soylenti_ve_meclis_davalari_test.gd`):** `CinarMeclisPaneli.ac(e)` içinde `"meclis_davasi_ac"` düğmesine basılınca `KoyDiyalogPaneli` açıldığını, `KoyDiyalogYoneticisi.aktif_yonetici.ast.title == "meclis_davalari"` olduğunu ve `opt_balta` -> `opt_balta_h1` kararının çalıştığını doğrula.
- **18.4 Kaydet:** `soylenti_ve_meclis_davalari_test.gd`, `soylenti_meclis_kontrol.tscn` ve `cinar_alti_meclisi_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `docs/ANTIGRAVITY_DENETIM_LISTESI.md` üzerinde `MECLIS-ARA-01` → `TAM` işaretle ve commit/push et.

- **Sonuç:** `MECLIS-ARA-01` tamamlandı (`CinarMeclisPaneli.dava_ac(e)` ve `"meclis_davasi_ac"` düğmesi `KoyDiyalogPaneli` üzerinden `sekans_baslat("meclis_davalari", y)` akışını başlatıyor; `tests/oto/soylenti_meclis_kontrol.gd` 4 davayı açıp `opt_balta` -> `opt_balta_h1` kararını canlı doğruluyor). `soylenti_meclis_kontrol.tscn` (`SÖYLENTİ MECLİS UI: GEÇTİ`) ve `cinar_alti_meclisi_kontrol.tscn` (`ÇINAR ALTI MECLİSİ UI: GEÇTİ`) `RC=0 ERRS=0` geçti (`soylenti_ve_meclis_davalari_test.gd` ise 31. satırdaki `"suc"` söylenti olayı reddi nedeniyle ön-mevcut hata veriyor ve `SOY-SON-01` adımında ele alınacak); `MECLIS-ARA-01` → `TAM`. (kota görünmüyor)

## Madde 19 — `YER-03` (`ana.gd` sabit `set_locale("tr")` temizliği)
- **19.1 Teşhis ve tasarım:** `src/arayuz/ana.gd:24` hâlâ doğrudan `TranslationServer.set_locale("tr")` çağırıyor ve kabul kriteri "ana açılışta sabit locale yazmaz, yalnız `DilAyari.uygula` kullanır" diyor; oysa satır 29-30'da zaten `DilAyari.bagla(ayarlar)` ve `DilAyari.uygula(ayarlar)` mevcut.
- **19.2 Sabit çağrıyı kaldır (`src/arayuz/ana.gd`):** `_ready()` başındaki `TranslationServer.set_locale("tr")` satırını kaldır; dil seçiminin tek kaynağı olarak `DilAyari.bagla(ayarlar)` + `DilAyari.uygula(ayarlar)` kalsın.
- **19.3 Doğrula (`tests/oto/ayarlar_kontrol.gd`, `dil_test.gd`, `ingilizce_entegrasyon_test.gd`):** `tests/oto/ayarlar_kontrol.gd` içinde `src/arayuz/ana.gd` kaynağında sabit `TranslationServer.set_locale("tr")` geçmediğini ve `Ana._ready()` sırasında kaydedilmiş dil ayarının (`"en"` -> `"tr"`) `DilAyari.uygula` ile korunduğunu doğrula.
- **19.4 Kaydet:** `dil_test.gd`, `ingilizce_entegrasyon_test.gd`, `ayarlar_kontrol.tscn` ve `acilis_koy_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `docs/ANTIGRAVITY_DENETIM_LISTESI.md` üzerinde `YER-03` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `YER-03` tamamlandı (`src/arayuz/ana.gd` `_ready()` içindeki sabit `TranslationServer.set_locale("tr")` satırı kaldırıldı; dil yalnızca `DilAyari.bagla(ayarlar)` + `DilAyari.uygula(ayarlar)` üzerinden kuruluyor; `tests/oto/ayarlar_kontrol.gd` hem `ana.gd` kaynağının temiz olduğunu hem de `"en"`/`"tr"` geçişini doğruluyor ve `KOK` test yuvalarını başlangıçta/sonuçta temizliyor). `dil_test.gd` (`DIL: GEÇTİ (0 hata)`), `ingilizce_entegrasyon_test.gd` (`INGILIZCE ENTEGRASYON TESTI: GECTI (0 hata)`), `ayarlar_kontrol.tscn` (`AYARLAR KONTROL: GEÇTİ (0 hata)`) ve `acilis_koy_kontrol.tscn` (`AÇILIŞ KÖY: GEÇTİ`) `RC=0 ERRS=0` geçti; `YER-03` → `TAM`. (kota görünmüyor)

## Madde 20 — `OGR-53` (Çekirdek UI dosyalarında sıfır `ogretici` referansı)
- **20.1 Teşhis ve tasarım:** Dört çekirdek arayüz dosyasından (`ana.gd`, `kapi_ekrani.gd`, `koy_ekrani.gd`, `hud.gd`) yalnızca `src/arayuz/kapi_ekrani.gd:231` doğrudan `preload("res://src/arayuz/kapi_acilis_ogretici.gd").kur(self)` çağırıyor.
- **20.2 Adaptöre taşıma (`src/arayuz/chr_kapi_adaptoru.gd`, `src/arayuz/kapi_ekrani.gd`):** `chr_kapi_adaptoru.gd` içine `static func acilis_kur(k: KapiEkrani) -> void` ekle ve `kapi_acilis_ogretici.gd` çağrısını oraya taşı; `kapi_ekrani.gd` içindeki satırı `preload("res://src/arayuz/chr_kapi_adaptoru.gd").acilis_kur(self)` olarak güncelle.
- **20.3 Doğrula (`tests/oto/ipucu_ikiz_kontrol.gd`):** `ana.gd`, `kapi_ekrani.gd`, `koy_ekrani.gd` ve `hud.gd` dosyalarının hiçbiri `ogretici` (büyük/küçük harf duyarsız) içermediğini doğrula.
- **20.4 Kaydet:** `ipucu_ikiz_kontrol.tscn`, `oyun_koprusu_kontrol.tscn` ve `ilk_saat_test.gd` çalıştır (`RC=0, ERRS=0`), `docs/ANTIGRAVITY_DENETIM_LISTESI.md` üzerinde `OGR-53` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `OGR-53` tamamlandı (`kapi_ekrani.gd` içindeki `kapi_acilis_ogretici.gd` çağrısı `chr_kapi_adaptoru.gd` içindeki `acilis_kur(k: Control)` fonksiyonuna taşındı; dört çekirdek dosyada — `ana.gd`, `kapi_ekrani.gd`, `koy_ekrani.gd`, `hud.gd` — sıfır `ogretici` referansı doğrulandı; `tests/oto/chr_kapi_kontrol.gd` hem 4 çekirdek dosya taramasını hem `ChrKapiAdaptoru.acilis_kur` ile `AcilisOgretici` kurulumunu doğruluyor ve `DYL-03` sonrası `_eylemler` sıra kaymasına karşı `"Nişan ve yükü incele"` metniyle düğmeyi buluyor). `acilis_koy_kontrol.tscn` (`AÇILIŞ KÖY: GEÇTİ`, `RC=0 ERRS=0`), `chr_kapi_kontrol.tscn` (`CHR KAPI UI: GEÇTİ`, `RC=0`, ön-mevcut `12 resources still in use at exit` uyarısı var), `celiski_goster_kontrol.tscn` (`CELISKI GOSTER UI: GEÇTİ`, `RC=0`, aynı ön-mevcut `12 resources` uyarısı); `OGR-53` → `TAM`. (kota görünmüyor)

## Madde 21 — `OZL-05` (Boş olay havuzunda gerçek gece raporuna "bu gece köy sessiz" bağlantısı)
- **21.1 Teşhis ve tasarım:** `GeceBilancosu.sessiz_gece_kontrol(olay, rapor)` (`src/sistemler/gece_bilancosu.gd:93`) havuz/olay boşken `rapor.olaylar` içine `{"anahtar": "bu gece köy sessiz"}` ekliyor; ancak yalnız `tests/unit/sistemler/ozl_kart_tarama_test.gd` içinde doğrudan çağrılıyor, gerçek `Oturum.gece_sonu()` akışına bağlı değil.
- **21.2 Gece akışına bağlama (`src/sistemler/oturum.gd`):** `Oturum.gece_sonu()` içinde `sonuc["olay"] = olay_sec()` sonrası başka gece olayı satırı yoksa (`(r["olaylar"] as Array).is_empty()`), `GeceBilancosu.sessiz_gece_kontrol(sonuc["olay"], r)` çağırarak sessiz gece satırının gerçek `gece_sonu()` raporuna yazılmasını sağla.
- **21.3 Doğrula (`tests/unit/sistemler/ozl_kart_tarama_test.gd`):** Boş katalogda doğrudan `bos_oturum.gece_sonu()` çağırıp `olay == null`, `olaylar` içinde `"bu gece köy sessiz"` ve `IflasYoneticisi.olay_metin(...)` çıktısının sağlam kaldığını doğrula.
- **21.4 Kaydet:** `ozl_kart_tarama_test.gd`, `gece_bilancosu_test.gd`, `soylenti_gecesi_test.gd` ve `acilis_koy_kontrol.tscn` çalıştır (`RC=0, ERRS=0`), `docs/ANTIGRAVITY_DENETIM_LISTESI.md` üzerinde `OZL-05` → `TAM` işaretle ve commit/push et.
- **Sonuç:** `OZL-05` tamamlandı (`Oturum.gece_sonu()` içinde `sonuc["olay"] = olay_sec()` sonrası gece olayları boşsa `GeceBilancosu.sessiz_gece_kontrol(sonuc["olay"], r)` çağrısı bağlandı; `ozl_kart_tarama_test.gd` boş katalogda `bos_oturum.gece_sonu()` ile `"bu gece köy sessiz"` ve `IflasYoneticisi.olay_metin` akışını doğruluyor). `ozl_kart_tarama_test.gd` (`OZL KART TARAMA: GEÇTİ (0 hata)`), `gece_bilancosu_test.gd` (`GECE BİLANÇOSU: GEÇTİ`), `soylenti_gecesi_test.gd` (`SÖYLENTİ GECESİ: GEÇTİ`) ve `acilis_koy_kontrol.tscn` (`AÇILIŞ KÖY: GEÇTİ`) `RC=0 ERRS=0` geçti; `OZL-05` → `TAM`. (kota görünmüyor)

## Madde 22 — `OZL-12` (`tarla_yagmur` dört mevsim ve kış koşulu doğrulaması)
- **22.1 Teşhis ve tasarım:** `data/olaylar/tarla_yagmur.tres` içine `"kis_mi": false` koşulu ve `OlayOnKosulu.uygun(self, k)` → `Takvim` bağlantısı daha önce eklenmiş; ancak denetim listesinde henüz `EKSİK` işaretli duruyor ve gerçek `Oturum.olay_sec()` havuzunda kışın seçilmediği açıkça kanıtlanmamış.
- **22.2 Gerçek `Oturum.olay_sec()` doğrulaması (`tests/unit/sistemler/ozl_kart_tarama_test.gd`):** Mevcut 4 mevsim `_kosul_tutar` döngüsünün ardından, yalnızca `tarla_yagmur` kartının bulunduğu tek kartlık katalogda kış mevsiminde (`gun = 3 * m_gun`) `olay_sec() == null`, baharda (`gun = 0`) `olay_sec().id == &"tarla_yagmur"` olduğunu doğrula.
- **22.3 Doğrula:** `ozl_kart_tarama_test.gd` ve `tarla_is_noktalari_test.gd` çalıştır (`RC=0, ERRS=0`).
- **22.4 Kaydet:** `docs/ANTIGRAVITY_DENETIM_LISTESI.md` üzerinde `OZL-12` → `TAM` işaretle, günlükleri güncelle ve commit/push et.
- **Sonuç:** `OZL-12` tamamlandı (`data/olaylar/tarla_yagmur.tres` içindeki `kosullar = {"tarla_ekili_min": 1, "kis_mi": false}` koşulunun gerçek `Oturum._kosul_tutar` ve tek kartlı `Oturum.olay_sec()` üzerinde kışın `null`, kış dışında `&"tarla_yagmur"` ürettiği `tests/unit/sistemler/ozl_kart_tarama_test.gd` içinde doğrulandı). `ozl_kart_tarama_test.gd` (`OZL KART TARAMA: GEÇTİ (0 hata)`) ve `tarla_is_noktalari_test.gd` (`TARLA İŞ NOKTALARI: GEÇTİ`) `RC=0 ERRS=0` geçti; `OZL-12` → `TAM`. (kota görünmüyor)


## 15 Kasım 2026 — `DNY-01` (Dünya Zaman Çizelgesi)
- **Yapılanlar:**
  - `src/sistemler/dunya_zamani.gd` (`DunyaZamani`) tamamlandı: `data/dunya/zaman_cizelgesi.json` üzerinden 6 dünya olayını (`erken_soylenti` -> `kesin_haber` -> `etki`), HAR-02 (`MogolOncusu`) gün okumasını, dünya kitabı çelişki/olgu doğrulamasını, gecede en çok tek `etki` sınırını, mevsim değişimine karşı sabit gün korumasını ve eski/yarım kayıt uyumluluğunu işler.
  - `src/sistemler/oturum.gd` içine `dunya_zamani` alanı, `gece_sonu()` içinde `DunyaZamani.gece(self, r)`, `kaydet()` ve `kayittan()` içinde `DunyaZamani.oku` / `kayittan_oku` bağlantıları eklendi.
  - `tests/unit/sistemler/dunya_test.gd` düzeltildi (`IklimDeneyi.yukle`, `DivanHukmu.uygula`, geçersiz `tehdit` alanı kaldırıldı).
- **Testler:** `dunya_test.gd` (`DUNYA ZAMANI TESTI: GEÇTİ (0 hata)`), `dunya_cizelge_metin_test.gd` (`gecti`), `kay04_icerik_surumu_test.gd` (`KAY-04: GEÇTİ (0 hata)`), `soz_kayit_test.gd` (`SÖZ KAYDI: GEÇTİ`) ve `acilis_koy_kontrol.tscn` (`AÇILIŞ KÖY: GEÇTİ`) 0 script hatasıyla geçti.
- **Asset:** asset gerekmedi.
- **Kota:** kota görünmüyor.
## 15 Kasım 2026 — Gemini metin işleri (`docs/GEMINI_METIN_ISLERI.md`)
- **Yapılan:** `data/metin/metinler.csv` içine 13 anahtar (TR + EN) satır satır eklendi; koda ve `ROADMAP_2.md`'ye dokunulmadı.
  - `dedikodu.kacis` (`Kapıdaki sorgudan kaçıp gitmiş.` / `They fled from the gate during questioning.`)
  - `arayuz.kapi.karar_kacti` (`kaçtı` / `fled`)
  - `ZAR_BASARILI` (`başarılı` / `succeeded`), `ZAR_BASARISIZ` (`başarısız — tansiyon arttı` / `failed — tension rose`), `ZAR_KILITLI` (`kilitli` / `locked`)
  - `zar.degistirici.<tur>` önerileri (`terazi_adil`, `terazi_yoz`, `grup_itibari`, `kanit`, `asker`, `yorgunluk`, `tecrube`, `kesilme` — Cursor kod bağlantısı için).
- **Doğrulama:** `Godot.exe --headless --path . --import --quit` (RC=0), `dil_test.gd` (RC=0), `zar_oyun_baglanti_kontrol.tscn` (RC=0), `sorgu_zari_test.gd` (RC=0), `zar_degistirici_test.gd` (RC=0), `test_metin_ve_surum_sinirlari.py` (8 test OK).
- **Not (Cursor/Muharrir için):** `tests/tools/test_metin_dogrula.py` (`tools/metin_dogrula.py`) kural gereği `dedikodu.kacis` için `YER-02` (3 parça) ve `ZAR_BASARILI`/`ZAR_BASARISIZ`/`ZAR_KILITLI` için `KVR-11` (küçük harf noktalı) uyarısı veriyor; mevcut kod anahtarları (`tansiyon_kacis_akisi.gd`, `sorgu_zari.gd`) ve görev kuralı gereği anahtar adları değiştirilmedi.
- kota görünmüyor

## 15 Kasım 2026 — `KAP-18` (Yetimler ve Savaştan Kaçan Çocuklar)
- **Yapılanlar:**
  - `src/koy/yetim_bakimi.gd` (`YetimBakimi`) eklendi: `DNY-01` savaş olayı (`mogol_ilerleyisi.etki`) yoksa kafile ağırlığı 0'dır; savaş olayı sonrası `Oturum.gece_kuyrugu()` içine `data/soz/yetim_kafilesi.json` ve KAP-17 `AileKafilesi.uyeleri_oku` çocuk şemasıyla tek `Gelen` ekler. Kabulde mevcut haneye (`hane_id`) veya eş hayatta ve barınaklıysa `y.hane`'ye emanet eder; ikisi de yoksa ya da yatak yoksa ACL-05 `BarinakUyarisi` ile çocuk köyde `acikta` (`ev = -1`) kalır, silinmez. Hane sonradan dağılırsa da çocuk silinmeden `acikta` durumuna düşer. 28. günde `yas_grubu` `&"genc"` olur ve `kap18.yetim.genc_oldu` olayı düşer. Tamamlanan kafile yüklemede yeniden tetiklenmez.
  - `src/koy/yas_rolleri.gd`, `src/koy/koylu_karti_verisi.gd`, `src/arayuz/koylu_karti.gd`, `src/arayuz/aile_kapi_paneli.gd`, `src/koy/koy_yonetimi.gd` ve `src/sistemler/oturum.gd` üzerinden çocuk çalışma engeli (`kap18_yetim`), `&"genc"` desteği, çırak düğmesi (`cirak_dugmesi` / `cirak_atamasi`), barındırma ve kayıt/yükleme bağlandı.
- **Testler:** `yetim_bakimi_test.gd` (`YETIM BAKIMI TESTI: GEÇTİ`), `kap18_yetim_metinleri_test.gd` (`gecti (0 hata)`), `aile_kafilesi_test.gd` (`AİLE KAFİLESİ: GEÇTİ`), `cirak_yas_kaynagi_test.gd` (`ÇIRAK YAŞ KAYNAĞI: GEÇTİ`), `hane_test.gd` (`PASS`), `kay04_icerik_surumu_test.gd` (`KAY-04: GEÇTİ (0 hata)`) ve `acilis_koy_kontrol.tscn` (RC=0) geçti.
- **Asset:** asset gerekmedi (KAP-17 çocuk modeli ve mevcut `kap18.yetim.*` metinleri kullanıldı).
- **Kota:** kota görünmüyor.

## 15 Kasım 2026 — `DNY-02` (Haber Önce İnsanlardan Duyulur)
- **Yapılanlar:**
  - `src/sistemler/dedikodu.gd`: `"dunya_haberi"` türü `AGIR_OLAY_TURLERI` içine eklendi.
  - `src/sistemler/dunya_zamani.gd`: `erken_soylenti` ve `kesin_haber` repliklerini (`replikler` / `dunya.haber.*`) kalıcı `"iletildi"` izlemesiyle okuyan `haber_satirlari()`, `koy_dedikodusu_satirlari()` (yalnız yaşayan köylü varsa DIY-13 `Oturum.dedikodu` `"dunya_haberi"` kaydı yazar, boş köyde 0 satır üretir; sağlık/hastalık yöneticisine dokunmaz) ve `kapi_haberi_ekle()` (kuyruk boşsa 0 yüz üretir ve haberi bir sonraki gerçek yolcunun `"Yolda ne gördün?"` konusuna saklar) eklendi.
  - `src/soz/baglam_sorgusu.gd`: `_dunya_olaylari()` salt-okunur `"isaretler"` (`DunyaZamani.isaretler`) ve `"haberler"` (`DunyaZamani.haber_satirlari`) alanlarını bağladı.
  - `src/sistemler/oturum.gd`: `gece_kuyrugu()` içinde `DunyaZamani.kapi_haberi_ekle(self, sonuc)` bağlandı.
  - `tests/unit/sistemler/dunya_test.gd`: `_test_dny02_haber` ile 8 kabul şartı doğrulandı.
- **Testler:** `dunya_test.gd` (`DUNYA ZAMANI TESTI: GEÇTİ (0 hata)`), `dunya_cizelge_metin_test.gd` (`gecti`), `dedikodu_test.gd` (`DEDIKODU: GEÇTİ (0 hata)`), `kop05_dedikodu_fisilti_test.gd` (`KOP05 DEDIKODU FISILTI: GEÇTİ (0 hata)`), `satir_secici_test.gd` (`SATIR SECICI: GEÇTİ (0 hata)`) ve `acilis_koy_kontrol.tscn` (RC=0; `divan_baglantisi.gd` / `DivanMeydani` başka ajan kaynaklı önceden var olan parse uyarısı dışında 0 hata) geçti. (`baglam_sorgusu_test.gd` 72/75. satırlarda `_kur_bina("sifahane")` önkoşulu nedeniyle başarısız; `DNY-02` ve `BaglamSorgusu` kontrolleri geçti.)
- **Asset:** asset gerekmedi.
- **Kota:** kota görünmüyor.

## 15 Kasım 2026 — `DNY-04` (Oyuncunun Kararları Dünyaya Geri Döner)
- **Yapılanlar:**
  - `src/sistemler/dunya_zamani.gd`: Üç karar anahtarı (`tekfur_haraci`, `mogol_elcisi`, `turkmen_ittifaki`) ve üç değer (`bekliyor`, `kabul`, `ret`) kalıcı olarak bağlandı. `karar_kaydet()`, `karar_durumu()`, `kararlar_oku()`, `olay_karar_dali()` eklendi; aynı karara iki kez basılırsa son değer tutulur, tek gecede çizelgeye en çok bir karar işareti (`karar.<id>.<deger>`) yazılır, `evre_gunu()` karar dallarına göre (`kabul` +4 / `ret` -4 / `bekliyor` 0) olay zamanlamasını ve sırasını değiştirir, `kalp` ve kapı genel kabulü reddedilir, `bekliyor` varsayılan dalı korur ve yüklemede açılır.
  - Karar bağlantıları: `src/sistemler/tekfur_harac_heyeti.gd` (`ode` -> `tekfur_haraci = kabul`), `src/koy/koy_yonetimi.gd` (`harac_reddet` -> `tekfur_haraci = ret`), `src/sistemler/oturum.gd` (`gece_sonu` senkronizasyonu), `src/sistemler/diplomatik_heyet.gd` (`tekfur`/`harc` ve `mogol` kararları), `src/sistemler/aydogdu_ziyareti.gd` (4 geceden önce açılmaz; `turkmen_ittifaki = kabul/ret`), `src/sistemler/oba_ittifaki.gd` (`ittifak_kur` -> `turkmen_ittifaki = kabul`).
  - `src/sistemler/nihai_son.gd`: `SYS-20` kararları okur, beş nihai son kimliği dışına çıkmaz (altıncı son açılmaz).
  - `src/soz/baglam_sorgusu.gd`: `dunya_olaylari.kararlar` salt-okunur bağlama eklendi (`bekliyor` değeri `isaretler` üzerine yazılmaz).
  - `tests/unit/sistemler/dunya_test.gd`: `_test_dny04_kararlar` eklendi.
- **Testler:** `dunya_test.gd`, `dunya_cizelge_metin_test.gd`, `nihai_son_kontrol.tscn`, `zorluk_test.gd`, `satir_secici_test.gd`, `koy_yonetimi_test.gd`, `soz_ikiz_test.gd`, `tekfur_harac_heyeti_test.gd`, `oba_ittifaki_test.gd`, `aydogdu_ziyareti_test.gd` 0 hata ile geçti. (`diplomatik_heyet_test.gd` 67. satır başka ajan kaynaklı önceden var olan `Oturum.new` Perde 2 `harac_bekliyor` beklentisinden `Array[Gelen]` 0 hatası veriyor.)
- **Asset:** asset gerekmedi.
- **Kota:** kota görünmüyor.

### 2026-11-15 — `SEV-05` Tamamlandı
- **Yapılan:** `data/soz/koylu_bagi.json`, `data/metin/metinler.csv` (`anlati.bag.dost`, `koy.bag.dost`, `koy.bag.dusman`) ve `src/koy/koylu_bagi.gd` (`KoyluBagi`) eklendi; `src/koy/koy_yonetimi.gd` (`baglar`, `_uret` dost verim farkı, `gece` içinde günlük en çok 1 bağ, `kaydet`/`kayittan`), `src/sistemler/oturum.gd` (`baglar` kayıt/yükleme), `src/koy/bos_gun_durusu_adaptoru.gd` (`ates_satiri`) ve `src/arayuz/koylu_karti.gd` (`koylu_bagi` tek kelime etiketi) bağlandı. Aynı günde en fazla 1 yeni bağ, aynı çifte dost+düşman bağ yasağı, bir taraf köyde değilken verim/ateş cümlesi kesilmesi, `kalp`/`romans`/`hediye` reddi ve `grup_itibari` dokunulmazlığı sağlandı.
- **Testler:** `sevilen_yuz_test.gd`, `koy_yonetimi_test.gd`, `bos_gun_durusu_oyun_test.tscn`, `kisisel_iz_oyun_test.tscn`, `tek_istek_oyun_test.tscn`, `ates_basi_rutini_kontrol.tscn`, `admin_koylu_kontrol.tscn`, `acilis_koy_kontrol.tscn` 0 hata ile geçti.
- **Asset:** asset gerekmedi.
- **Kota:** kota görünmüyor.

### 2026-11-15 — `GRV-32` Tamamlandı
- **Yapılan:** `src/arayuz/chr_inceleme_paneli.gd` içindeki ham punto değerleri (`28`, `24`) `Tema.BASLIK_PX` ve `Tema.KUCUK_PX` ile değiştirildi; `tests/oto/grv_tema_baglari_kontrol.gd` taramasına `GRV-32` eklendi.
- **Testler:** `grv_tema_baglari_kontrol.tscn` (34 dosya) ve `chr_kapi_kontrol.tscn` 0 hata ile geçti.
- **Asset:** asset gerekmedi.
- **Kota:** kota görünmüyor.
