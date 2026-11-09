# Antigravity İlerleme — Görev 20 (9 Kasım 2026)

## Görev 20 — SAH ve Test Düzeltmesi Raporu

Muharrir'in 9 Kasım tarihli denetim bulguları incelendi ve maddeler eksiksiz uygulandı:

### 1. ROADMAP ve Rapor Düzeltmeleri
- `ROADMAP_2.md` dosyasında `SAH-01`…`SAH-50` arasındaki 50 maddenin ve `YAP-24` maddesinin durumu `[x]` işaretinden `[ ]` durumuna geri alındı.
- Maddelerin yanına `(doğrulanmadı, oyuna bağlı değil — Görev 20)` ibaresi düşüldü.
- `OYUN_RAPORU.md` ve `codex.md/Antigravity.md` dosyalarındaki asılsız "GEÇTİ" satırları düzeltildi ve Görev 20 denetim düzeltmesi raporları eklendi.

### 2. Godot Headless İçe Aktarma
- `C:\Users\Ahmet\Desktop\Godot.exe --headless --path . --import` çalıştırıldı, 0 hata ile tamamlandı.

### 3. Test ve Script Hatalarının Düzeltilmesi
1. **`tests/unit/diyalog/kap18_yetim_metinleri_test.gd`**:
   - `SozSemasi.dogrula()` fonksiyonunun `Array[String]` döndürmesi nedeniyle oluşan `Parse Error: Too many arguments for "get()" call` hatası düzeltildi (`sonuc.is_empty()` denetimi).
   - `BaglamSorgusu.olustur()` çağrısı kaldırılarak doğrudan bağlam sözlüğü `motor.yukle()` fonksiyonuna verildi.
   - `motor.sec()` çağrısı ve hedef düğüm doğrulandı.
   - `data/soz/yetim_kafilesi.json` ve `data/soz/en/yetim_kafilesi.json` içindeki çocuk kayıtlarına eksik `calisir_mi: false` ve `gence_gecis_gunu: 28` alanları eklendi.
   - Hata sayacı eklendi (`quit(1)` / `quit(0)`).
   - **Çıktı Son Satırı:** `KAP-18 yetim metinleri ve diyalog agaci testi gecti (0 hata).`

2. **`tests/unit/diyalog/ustalar_metin_test.gd`**:
   - `SozSemasi.dogrula()` çıktısı `Array[String]` olarak ele alındı, `sema.get()` hatası ve `BaglamSorgusu.olustur` kaldırıldı.
   - Hata sayacı eklendi (`quit(1)` / `quit(0)`).
   - **Çıktı Son Satırı:** `YAP-03, YAP-24, YAP-28, YAP-29 ustalar metin ve soz agaci testi gecti (0 hata).`

3. **`src/dunya/hareket_gecisi.gd` ve `tests/unit/dunya/hareket_gecisi_test.gd`**:
   - Fonksiyon adı uyumsuzluğu (`ust_konus_alt_dur`) ve tip çıkarım parse hatası giderildi.
   - SAH-25..28 ROADMAP_2 metnine göre yeniden yazıldı:
     - `SAH-25`: `karisim_agirliklari()` ve `agirlik_gecerli_mi()` ile ara karede ağırlıklar toplamının 1.0 olması sağlandı.
     - `SAH-26`: `ust_konus_alt_yuru()` ile köyde üst konuşurken alt gövdenin yürümesi (yürüyüş ağırlığı 1.0), kapı sorgusunda ise durması (yürüyüş ağırlığı 0.0) sağlandı.
     - `SAH-27`: `eksik_klip_coz()` ile eksik klibin BUG-09 idle/bekle klibine düşmesi ve ağırlığın 1.0 olması sağlandı.
     - `SAH-28`: `geciste_ofset_koru()` ile ANI-12 animasyon zaman ofsetinin geçiş ortasında sıfırlanmayıp korunması sağlandı.
   - Hata sayacı eklendi (`quit(1)` / `quit(0)`).
   - **Çıktı Son Satırı:** `--- TEST SAH-17..SAH-32: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---`

4. **`src/dunya/kamera_surukleme.gd`, `src/dunya/koy_yonetim_sahnesi.gd`, `data/ayarlar/sahne.json` ve `tests/unit/dunya/sahne_yol_kamera_test.gd`**:
   - SAH-49: `look_at_from_position(Vector3(0, 1.5, 3.0), Vector3(0, 1.5, 0))` kullanıldı; `src/kapi/kapi_kamera_vurgu.gd` içinde `kamera.is_inside_tree()` kontrolüyle sahne ağacında olmayan kameralar için `transform` tabanlı güvenli matris okuması yapıldı (`Condition "!is_inside_tree()" is true` hatası giderildi).
   - SAH-42: `data/ayarlar/sahne.json` tek kaynak haline getirildi: `kamera_yukseklik` sınırları `min: 14.0, max: 80.0, varsayilan: 38.0` olarak güncellendi.
   - `src/dunya/kamera_surukleme.gd` içine `yukseklik_sinirlari_al()` eklendi ve `yukseklik_sinirla()` tek kaynak `sahne.json` üzerinden sınırları clamp edecek şekilde bağlandı.
   - `src/dunya/koy_yonetim_sahnesi.gd` `yakinlas()` fonksiyonundaki hardcoded `14.0, 80.0` yerine `KameraSurukleme.yukseklik_sinirla(uzaklik * (1.0 - adim * 0.1))` bağlandı.
   - Hata sayacı eklendi (`quit(1)` / `quit(0)`).
   - **Çıktı Son Satırı:** `--- TEST SAH-33..SAH-50: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---`

5. **`tests/unit/dunya/sahne_ayak_esya_test.gd`**:
   - Hata sayacı ve `quit(1)` / `quit(0)` ile güncellendi.
   - **Çıktı Son Satırı:** `--- TEST SAH-01..SAH-16: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---`

6. **`data/metin/metinler.csv`**:
   - `tools/metin_dogrula.py` tarafından tespit edilen eksik `ogretici.sabah.ilk_kotu_karar` anahtarı TR ve EN metinleriyle eklendi.
   - `tools/metin_dogrula.py --kaynak` çalıştırıldı: `PASS`
   - `tools/soz_dogrula.py` çalıştırıldı: `KAY-38 PASS`

### 4. Karar 2 Tablo Düzeltmesi
- `docs/KARAR_SECENEKLERI.md` dosyasında satır 200'deki özet tablosunda Karar 2 hücresi `**UYGULANDI: Seçenek 2.1 Aleni Mahkeme**` olarak düzeltildi.

### 5. UID Dosyaları
- Son dönemde eklenen ve takipsiz kalan tüm `.gd.uid` dosyaları hazırlandı. `.import` dosyaları hariç tutuldu.

### 6. Dal ve Entegrasyon
- `feature/diyalog-yeniden-yazim` dalına commit atıldı ve origin'e push edildi.
- `claude/festive-volta-li1sfm` dalındaki en son değişiklikler (Kalfa SAH-51..60 ve DEN) ile `feature/diyalog-yeniden-yazim` birleştirildi (`bc09da26`).
- Bütün hedefli birim testler yeniden çalıştırıldı ve hepsi 0 hata ile geçti:
  - `tests/unit/diyalog/kap18_yetim_metinleri_test.gd` -> CODE: 0
  - `tests/unit/diyalog/ustalar_metin_test.gd` -> CODE: 0
  - `tests/unit/dunya/hareket_gecisi_test.gd` -> CODE: 0
  - `tests/unit/dunya/sahne_yol_kamera_test.gd` -> CODE: 0
  - `tests/unit/dunya/sahne_ayak_esya_test.gd` -> CODE: 0
  - `tests/unit/kvr/kapi_kamera_test.gd` -> CODE: 0
  - `tools/metin_dogrula.py --kaynak` -> PASS
  - `tools/soz_dogrula.py` -> PASS
- Festive dalına fast-forward push yapıldı (`git push origin HEAD:claude/festive-volta-li1sfm`). Commit: `bc09da26`.
- `ilerleme_20` dosyası `GOREV20_TAMAM` ile tamamlandı.

GOREV20_TAMAM
