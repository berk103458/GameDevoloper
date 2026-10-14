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



