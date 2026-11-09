# Antigravity İlerleme — Görev 21 (9 Kasım 2026)

## Görev 21 — Temizlik ve SAH Bağlama Raporu

Muharrir'in (Ahmet onaylı) 9 Kasım 2026 tarihli Görev 21 yönergeleri eksiksiz uygulandı:

### 1. Ana Klasör (`Kapı_Muhafizi`) .uid Temizliği ve Fast-Forward Pull
- `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi` klasöründeki 92 adet takip edilmeyen `.uid` dosyası yol yapısı korunarak `C:\Users\Ahmet\Desktop\Cursor_All_DAta\_uid_yedek_9kasim\` klasörüne taşındı.
- Ana klasörde `git pull --ff-only` başarıyla çalıştırıldı ve dal `f2164d21` ucuna sorunsuz getirildi.
- Kalfa'nın çalışma ağacındaki kirli dosyalara dokunulmadı; stash, reset veya force kullanılmadı.

### 2. Gereksiz Dosya Temizliği
- Repo kökündeki `ilerleme_20` dosyası silindi (`git rm ilerleme_20`).

### 3. Görev 20 Festive Uç Hash Düzeltmesi
- `codex.md/Antigravity_ilerleme_20.md` dosyasındaki festive uç hash'i `bc09da26` olarak düzeltildi.

### 4. SAH-42: `kamera_uzaklik` ve Tek Seferlik Yükleme
- `data/ayarlar/sahne.json` dosyasında `kamera_yukseklik` alan adı gerçek işlevine uygun olarak `kamera_uzaklik` olarak güncellendi.
- `src/dunya/kamera_surukleme.gd` içinde `_ready()` anında `sahne_ayarlari_yukle()` ile `sahne.json` tek bir kez okunarak `_uzaklik_sinirlar` statik önbelleğine alındı.
- Her tekerlek adımında (`yakinlas`) dosya sistemi okuması yapılması engellendi; `KameraSurukleme.uzaklik_sinirla()` statik önbellek üzerinden sınırları uyguladı.
- `src/dunya/koy_yonetim_sahnesi.gd` içindeki `yakinlas()` fonksiyonu `KameraSurukleme.uzaklik_sinirla()` ile bağlandı.
- `tests/unit/dunya/sahne_yol_kamera_test.gd` güncellendi ve doğrulandı.

### 5. SAH-01..50 Gerçek Oyun Sistemlerine Bağlama ve ROADMAP Güncellemesi
- **Karakter Modeli & Ayak Zemini (`SAH-01..SAH-08`):**
  - `src/dunya/karakter_model.gd` `kur()` içine `_ayak_zemini = AyakZemini.kur(self)` tek bağ adaptörü bağlandı; `_process()` içinde `position.y = _ayak_zemini.zemin_hizala(position.y, 0.0)` ile yürüyüşte ve duruşta topuğun zemin altına inmemesi gerçek oyun modeline bağlandı.
  - SAH-01, SAH-03, SAH-04, SAH-05, SAH-06, SAH-07, SAH-08 gerçek sisteme bağlanıp doğrulandı (`[x] (Antigravity)`).
  - SAH-02 eğimli hücrelerde 2 ayak bağımsız yüzey izleme (SkeletonIK3D / iskelet kemik IK entegrasyonu) büyük sahne çalışması olduğundan `[ ] (Kalfa bekleniyor — eğimli hücre IK entegrasyonu)` olarak işaretlendi.
- **El Eşyası (`SAH-09..SAH-16`):**
  - `src/dunya/el_esyasi.gd` `soket_dolu_mu()` fonksiyonu sahte kontrol yerine gerçek `_iskelet` ve `_el` kemik geçerliliğini denetleyecek şekilde güncellendi.
  - SAH-09, SAH-10, SAH-12, SAH-13, SAH-14, SAH-15, SAH-16 doğrulandı (`[x] (Antigravity)`).
  - SAH-11 (asılı eşya dynamic raycast zemin çarpışma entegrasyonu) `[ ] (Kalfa bekleniyor — asılı eşya zemin çarpışma entegrasyonu)` olarak işaretlendi.
- **Yürüme, Koşma, Durma (`SAH-17..SAH-24`):**
  - `data/ayarlar/sahne.json` ve `src/dunya/hareket_gecisi.gd` üzerinden hız bantları, duruştan yürüyüşe yumuşak geçiş, kovalama/kaçış koşu koşulu, duruş cilası ve sabit geçiş süresi doğrulandı (`[x] (Antigravity)`).
- **Animasyon Karıştırma (`SAH-25..SAH-32`):**
  - `src/dunya/hareket_gecisi.gd` ile ağırlıklar toplamı 1.0, köyde üst konuşup alt yürüme, eksik klibin idle düşüşü, bekleme ofseti koruması, tezgâh klibi bağımsızlığı, hava omuz katmanı ve üçlü geçiş filtresi doğrulandı (`[x] (Antigravity)`).
- **Kalabalıkta Yol (`SAH-33..SAH-40`):**
  - `KalabalikYol.tek_ag_var_mi()` ve `ag_kimligi()` köy navigasyon mimarisine (`KoyRotasi`) bağlandı.
  - SAH-33, SAH-35, SAH-36, SAH-37, SAH-39, SAH-40 doğrulandı (`[x] (Antigravity)`).
  - SAH-34 ve SAH-38 canlı köy simülasyonundaki 30 köylü dinamik hücre rezervasyonu ve devriye yol sapması Kalfa'nın yapay zekasına ait olduğundan `[ ] (Kalfa bekleniyor)` olarak işaretlendi.
- **Kamera (`SAH-41..SAH-48`):**
  - `KameraSurukleme`, `sahne.json`, `KoyYonetimSahnesi` ve `KoyluTakibi` ile tek rig, uzaklık sınırları, köy dışına taşmama, orta tuşta takibi bırakma, modele girmeme, kapı FOV bağımsızlığı, köyde 0 sarsıntı ve kayıtta kamera tutmama doğrulandı (`[x] (Antigravity)`).
- **Kapıda Konuşan Yüz (`SAH-49..SAH-50`):**
  - `KapiKameraVurgu.kadrajda_mi()` ve `heybe_ile_mesafe_koru()` kapı kamerası geçişine bağlandı ve doğrulandı (`[x] (Antigravity)`).
- **YAP-24:**
  - `tests/unit/diyalog/ustalar_metin_test.gd` ile doğrulanıp `[x] (Antigravity)` yapıldı.

### 6. Testler ve Çıktı Son Satırları
`C:\Users\Ahmet\Desktop\Godot.exe --headless --path . --import` başarıyla çalıştırıldı (çıkış 0).

1. **`tests/unit/dunya/sahne_ayak_esya_test.gd`**:
   - Çıkış Kodu: 0
   - Son Satır: `--- TEST SAH-01..SAH-16: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---`

2. **`tests/unit/dunya/hareket_gecisi_test.gd`**:
   - Çıkış Kodu: 0
   - Son Satır: `--- TEST SAH-17..SAH-32: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---`

3. **`tests/unit/dunya/sahne_yol_kamera_test.gd`**:
   - Çıkış Kodu: 0
   - Son Satır: `--- TEST SAH-33..SAH-50: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---`

4. **`tests/unit/diyalog/kap18_yetim_metinleri_test.gd`**:
   - Çıkış Kodu: 0
   - Son Satır: `KAP-18 yetim metinleri ve diyalog agaci testi gecti (0 hata).`

5. **`tests/unit/diyalog/ustalar_metin_test.gd`**:
   - Çıkış Kodu: 0
   - Son Satır: `YAP-03, YAP-24, YAP-28, YAP-29 ustalar metin ve soz agaci testi gecti (0 hata).`

6. **`tests/unit/kvr/kapi_kamera_test.gd`**:
   - Çıkış Kodu: 0
   - Son Satır: `KAPI KAMERA: GEÇTİ`

7. **Doğrulayıcı Scriptler:**
   - `python -B tools/metin_dogrula.py --kaynak`: `PASS`
   - `python -B tools/soz_dogrula.py`: `KAY-53 sure_ms=79.6 chr=30 adli=30 \n KAY-38`

GOREV21_TAMAM
