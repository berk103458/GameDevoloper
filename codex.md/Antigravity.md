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
