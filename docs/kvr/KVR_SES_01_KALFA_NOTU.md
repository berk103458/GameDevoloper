# KVR-SES-01: Kalfa Entegrasyon ve Bağlantı Kılavuzu

**Hazırlayan:** Antigravity (Paralel Ajan C)  
**Tarih:** 4 Kasım 2026  
**Durum:** Metinler ve Veri Yapısı TAMAMLANDI, Kalfa Kod Entegrasyonu Bekleniyor  

---

## 1. Hazırlanan Veri ve Kaynaklar

### A. Metin Tablosu (`data/metin/metinler.csv`)
Tüm replikler Türkçe ve İngilizce (`en`) olarak eksiksiz eklenmiştir:
1. **Köylü Ortam Replikleri (`kvr.hava.*`):**
   - 12 Karakter: `karaca_usta`, `ayse_baci`, `es`, `saruca_hatun`, `hasan_celebi`, `yusuf`, `miraen`, `thessra`, `sorhan`, `aydogdu`, `nogay`, `genel`.
   - 5 Hava Durumu: `yagmur`, `kar`, `ayaz`, `sicak`, `sis`.
   - Her duruma 2 varyasyon: `kvr.hava.<karakter>.<hava>.1` ve `kvr.hava.<karakter>.<hava>.2`.
   - Toplam 120 adet zengin, 13. yüzyıl Anadolu atmosferine uygun köylü repliği.

2. **Kapı Nöbeti Hava Replikleri (`kapi.hava.*`):**
   - Tipi/Kar Fırtınası: `kapi.hava.firtina_1`, `kapi.hava.firtina_2`, `kapi.hava.firtina_3`, `kapi.hava.firtina_muhafiz`
   - Yağmur/Çamur: `kapi.hava.yagmur_1`, `kapi.hava.yagmur_2`, `kapi.hava.yagmur_muhafiz`
   - Gece Ayazı/Don: `kapi.hava.ayaz_1`, `kapi.hava.ayaz_2`, `kapi.hava.ayaz_muhafiz`
   - Yoğun Sis/Pus: `kapi.hava.sis_1`, `kapi.hava.sis_2`, `kapi.hava.sis_muhafiz`
   - Kavurucu Sıcak/Kuraklık: `kapi.hava.sicak_1`, `kapi.hava.sicak_2`, `kapi.hava.sicak_muhafiz`

### B. Yapılandırılmış JSON Kaynakları
- `data/koy/hava_replikleri.json` (Türkçe)
- `data/koy/en/hava_replikleri.json` (İngilizce)
Karakter ve hava durumuna göre `data[karakter][hava] = ["replik1", "replik2"]` dizisi sunar.

---

## 2. Hazır İnce Adaptör API (`HavaReplikAdaptoru`)
`src/soz/hava_replik_adaptoru.gd` altında hafif ve sıfır yan etkili adaptör hazırdır:

```gdscript
# 1. Köylünün hava repliğini alma:
var replik = HavaReplikAdaptoru.koylu_replik_al("karaca_usta", "kar_firtinasi", 1)

# 2. Kapıya gelen ziyaretçinin hava açılış ön ekini alma:
var on_ek = HavaReplikAdaptoru.kapi_on_ek_al("ayaz", 1)

# 3. Muhafızın sert hava karşılama varyasyonunu alma:
var karsilama = HavaReplikAdaptoru.muhafiz_karsilama_al("firtina")

# 4. Hava durumu adını standartlaştırma:
var norm = HavaReplikAdaptoru.normalize_hava("kar_firtinasi") # "kar" döner
```

---

## 3. Kalfa İçin Bağlantı Noktaları (Önerilen Entegrasyon)

1. **Kapı Ekranı Ziyaretçi Açılışı (`src/arayuz/kapi_ekrani.gd`):**
   Kapı açıldığında ziyaretçi konuşma balonuna veya diyaloğuna hava ön eki eklemek için:
   ```gdscript
   var hava = IklimDeneyi.hava(Oturum.yonetim) if Oturum and Oturum.yonetim else "normal"
   var on_ek = HavaReplikAdaptoru.kapi_on_ek_al(hava, randi() % 2 + 1)
   if not on_ek.is_empty():
       replik_metni = on_ek + " " + replik_metni
   ```

2. **Köy İçi Muhabbet / Ortam Balonları (`src/diyalog/` veya `src/koy/`):**
   Köylü tıklandığında veya köyde dolaşırken ortam repliği tetiklemek için:
   ```gdscript
   var hava = IklimDeneyi.hava(yonetim)
   var replik = HavaReplikAdaptoru.koylu_replik_al(koylu.adli_id, hava, randi() % 2 + 1)
   ```

3. **Gece/Gündüz Döngüsü & Takvim:**
   Mevcut `MevsimYoneticisi` ve `IklimDeneyi` verileri doğrudan adaptörle uyumludur (`kar_firtinasi`, `kuraklik`, `yagmur`, `sis` otomatik normalize edilir).
