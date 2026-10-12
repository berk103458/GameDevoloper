# Metin anahtarı standardı (KVR-11 / SYS-09 / BUG-07)

Tek metin tablosu: `data/metin/metinler.csv` (UTF-8, ilk satır `keys,tr`). Godot bunu
`metinler.tr.translation` olarak içe aktarır; kodda `tr("anahtar")` ile okunur.

## 1. Anahtar biçimi

- **Noktalı küçük harf** (mevcut tüm satırlar): `alan.alt_alan.ad` — yalnızca `a-z`, `0-9`, `_`
  ve nokta; ilk parça harfle başlar, boş parça yok. Örnek: `arayuz.hud.gun`, `koy.bayrak.vergi_isyani`,
  `arayuz.son.kirildi.0`.
- **Yeni anahtar en az üç parçadır (YER-02):** `alan.alt.ad`. YER-02 öncesinden kalan iki parçalı anahtarlar
  (`bar.halk`, `esya.akce` …) `tools/metin_eski_iki_parcali.txt` listesinde korunur; listeye yeni ad eklenmez.
  Yeni iki parçalı anahtar `metin_dogrula.py` ile 1 hata verir. Bu belge tek standarttır; ikinci standart açılmaz.
- Üst alanlar: `arayuz` (menü/HUD/düğme), `anlati` (günlük ve anlatı satırları), `koy` (köy yönetimi),
  `sohbet` (kapı diyalogları), `olay` (olay kartları), `sablon` (sınıf şablonları), `karakter`
  (karakter adları), `heybe`, `esya`, `bar`, `bitki`. Yeni üst alan açarken buraya ekleyin.
- **CHR sayfaları** (CSV'ye taşındığında): replik `CHR_XXX_DUGUM_YY_REPLIK`, seçenek
  `CHR_XXX_DUGUM_YY_SEC_Z_METIN`, heybe `CLUE_CHRXXX_ESYA_ADI_BASLIK` / `_TANIM`
  (XXX üç hane, YY iki hane, Z sayı).

## 2. CSV'ye satır ekleme kuralı

- Her anahtar **tek satır**, mükerrer anahtar yok; mevcut satırı silmeyin/yeniden adlandırmayın.
- Yeni satırı ilgili alanın yanına ekleyin; satır sayısı sütun sayısına eşit olmalı (`keys,tr` → 2 alan).
- Metinde virgül, tırnak ya da satır sonu varsa alanı çift tırnağa alın; içteki tırnak `""` yazılır.
- Türkçe metin boş bırakılmaz.
- `%s`/`%d` yer tutucularının sayısı, koddaki `tr("k") % [...]` argüman sayısıyla aynı olmalı.

## 3. Doğrulama (commit öncesi)

```
python -B tools/metin_dogrula.py --kaynak    # CSV biçimi + kod/katalog anahtarları + yer tutucu sayısı
python -B tools/sanity_check.py --godot <godot>   # "metin-csv" adımı dahil tam paket
```

`--kaynak` şunları yakalar: bozuk tırnak, eksik/fazla sütun, mükerrer ya da biçimsiz anahtar, boş Türkçe
metin, `src/**/*.gd` içinde `tr("...")` ile kullanılıp CSV'de olmayan anahtar, `data/**/*.tres` katalog
alanlarında (`*_anahtari`, `*_anahtarlari`, `ad_havuzu`) olup CSV'de olmayan anahtar ve argüman/yer tutucu
uyuşmazlığı.

## 4. Çalışma anında güvenlik (BUG-07 / SYS-12)

`src/sistemler/guvenli_metin.gd` (`GuvenliMetin.kur()`, `Ana._ready`):

- Eksik ya da boş anahtar oyunu **kilitlemez**. Katalog bunu hata değil uyarı (`Katalog.uyarilar`) sayar.
- Sıra: içe aktarılmış tablo → ham CSV'nin hoşgörülü okuması (geliştirme kopyasında; kapanmamış tırnak bir
  sonraki anahtar satırında kesilir, bozuk satır atlanır) → ekranda `[KEY_NOT_FOUND] anahtar`.
- Her durum bir kez `push_warning` ile günlüğe yazılır; eksikler `GuvenliMetin.eksikler` listesindedir.
- Düz metinler, sayılar ve dosya adları çeviriden etkilenmez.
- Test: `tests/unit/metin/guvenli_metin_test.gd`, `tests/tools/test_metin_dogrula.py`.
