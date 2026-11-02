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
