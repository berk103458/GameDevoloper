# İngilizce Diyalog ve Metin Denetimi Raporu (6–7 Kasım 2026)

- **Denetleyen Ajan:** Antigravity
- **Kapsam:** `data/diyalog/en/`, `data/soz/en/`, `data/dunya/en/`, `docs/ingilizce_diyalog/`, `data/metin/metinler.csv`
- **Doğrulayıcı Sonucu:** `Hata Sayısı (Errors): 0`, `Uyarı Sayısı (Warnings): 0`, `PASS data/metin/metinler.csv`

---

## 1. Tespit Edilen Sorunlar ve Kök Nedenler

1. **`data/diyalog/en/diyalog_01_20.json` içinde Türkçe kalmış iç soru/cevap ağaçları (`diyalog_02` – `diyalog_20`):**
   - `diyalog_01` ve `diyalog_21`–`diyalog_30` tam İngilizce olduğu halde, `diyalog_02` ile `diyalog_20` arasındaki 19 kapı diyaloğunun iç `sorular` dizileri Türkçe kalmıştı.
   - Ayrıca `diyalog_02`–`diyalog_20` kayıtlarında `sahne`, `acilis`, `not` ve `yanitlar` alanlarında Türkçe kaynakla uyuşmayan şablon/yer tutucu İngilizce cümleler (`"Take this purse... Let it stay between the two of us"`, `"Do not cast me back into the frozen dark..."` vb.) bulunuyordu.
2. **`data/metin/metinler.csv` içinde `en` sütunu Türkçe kalmış satırlar:**
   - `koy.iflas.tip`, `koy.iflas.olay`, `koy.iflas.mal_yok`
   - `koy.kart.ozet`, `koy.kart.uzmanlik_yok`
   - `koy.levent.olay`
   - `koy.sancak.temiz`, `koy.sancak.bulunamadi`, `koy.sancak.idam`, `koy.sancak.azil`, `koy.sancak.son_azil_baslik`, `koy.sancak.son_azil_metin`, `koy.sancak.son_idam_baslik`, `koy.sancak.son_idam_metin`, `koy.sancak.tip`
   - `koy.coban.otlatiyor`, `koy.coban.agila`
   satırlarında Türkçe metin doğrudan İngilizce sütununa kopyalanmıştı.
3. **Üslup / Terim Uyumu (`docs/dogrula_ingilizce_taslak.py`):**
   - Dönem üslubuna aykırı `"Lady Miraen"` kullanımı 9 noktada uyarı veriyordu; tamamı `"Miraen Hatun"` olarak düzeltildi.

---

## 2. Yapılan Düzeltmeler

- **`data/diyalog/en/diyalog_01_20.json` ve `docs/ingilizce_diyalog/` senkronizasyonu:**
  - `diyalog_02` (Kayserili çuhacı), `diyalog_03` (Sivaslı kırık kargılı nefer), `diyalog_04` (yaylacı çoban), `diyalog_05` (demirci kalfası), `diyalog_06` (boş kınlı Erzincanlı asker), `diyalog_07` (kırık sabanlı rençber), `diyalog_08` (dikici kalfası), `diyalog_09` (boş sadaklı kemankeş), `diyalog_10` (testisinde bağ şırası taşıyan genç), `diyalog_11` (taş köprü gazisi), `diyalog_12` (kalaycı), `diyalog_13` (topal oğlaklı çoban), `diyalog_14` (tuz ve güherçile çerçisi), `diyalog_15` (kule borazancısı), `diyalog_16` (bağ bekçisi), `diyalog_17` (kantarcı), `diyalog_18` (kireç yanıklı kale ırgatı), `diyalog_19` (hamur tekneli fırıncı) ve `diyalog_20` (topuğu çivili nalbant) diyaloglarının tüm `sahne`, `acilis`, `not`, `yanitlar` ve çok katmanlı `sorular` ağaçları Türkçe asıllarına birebir sadık, 13. yüzyıl Anadolu sınır atmosferine uygun doğal İngilizceye çevrildi.
  - Tüm bayraklar (`gizli_akce_suphesi`, `firari_asker`, `suru_hastaligi_riski`, `kacak_kalfa`, `pusat_kaybi`, `yikilmis_koy`, `kacak_sarac`, `bos_sadak_kemankes`, `fedakar_genc`, `yarali_gazi`, `supheli_bakirci`, `topal_oglak`, `tuz_kervani_kacak`, `borazanci_korkaklik_ithami`, `saraplik_bag_suphesi`, `hileli_dirhem`, `rusvetci_dizdar_tanigi`, `zehirli_un_suphesi`, `harami_ati_nali`) olduğu gibi korundu.
  - Parçalı taslak dosyaları (`docs/ingilizce_diyalog/diyalog_01_10.json`, `diyalog_11_20.json`, `diyalog_21_30.json`, `diyalog_01_20.json`) tam senkronize edildi.
- **`data/metin/metinler.csv` çevirileri:**
  - Türkçe kalmış 17 sistem/arayüz anahtarı format belirteçleri (`%s`, `%d`, `%%`) korunarak İngilizceye çevrildi.
- **Yeni Eklenen Görev 18 Paketlerinin İngilizce Karşılıkları:**
  - `KAP-18`: `data/soz/en/yetim_kafilesi.json` + `kap18.yetim.*`
  - `YAP-03..29`: `data/soz/en/usta_sinan_kalfa.json`, `usta_mihali_degirmenci.json`, `usta_tugrul_pusatci.json`, `usta_evhad_hekim.json` + `yap03.usta.*`, `yap28.cirak.*`, `yap29.usta.*`
  - `YAP-04..51`: `yap04.defter.*`, `yap04.resim.*`, `yap37.donus.*`, `esya.ozel.*`
  - `DNY-01..04`: `data/dunya/en/zaman_cizelgesi.json` + `dunya.olay.*`, `dunya.haber.*`, `dunya.rapor.*`, `dunya.donus.*`

---

## 3. Doğrulama Özeti

- `python tools/metin_dogrula.py --kaynak` → **PASS**
- `python docs/dogrula_ingilizce_taslak.py` → **0 Hata, 0 Uyarı**
- `python tools/soz_dogrula.py` → **PASS** (`KAY-53`, `KAY-38`)
- `python tools/soz_tasarimi_dogrula.py` → **SÖZ TASARIMI: GEÇTİ**
