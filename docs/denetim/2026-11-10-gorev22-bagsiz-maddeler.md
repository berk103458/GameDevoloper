# Görev 22 genel düzeltme — oyuna bağlı olmayan `[x]` maddeler (Cursor, 10 Kasım 2026)

Festive `4a2ce9e7` üzerinde yapıldı. Yöntem:

1. Godot 4.7.2 headless ile `src/` ve `tests/` altındaki 1099 betik yüklendi. Derlenmeyen tek betik `tests/unit/soz/toplu_yazim_test.gd` (YAZ-06) idi; düzeltildi.
2. Oyunun giriş noktalarından (`project.godot` ana sahne + autoload'lar) başlayarak `src/` içindeki dosyalar arasında referans grafiği kuruldu (`class_name` ya da dosya adı geçişi). Ulaşılamayan dosya, oyun açıldığında hiçbir akışta çalışmaz.
3. ROADMAP_2'de `[x]` olan ve "Dosya" alanındaki betiği ulaşılamayan maddeler listelendi. Madde kodu oyunda ulaşılabilir bir dosyada da geçiyorsa madde bağlı sayıldı ve dokunulmadı.

Sınırlar: Parley `.ds` / `.dlg` verisinden yüklenen diyalog eylemleri bu grafikte görünmez. Ölçüm araçları (`denge_olcumu.gd`, `is_olcumu.gd`) bilerek yalnız araç ve testten çalışır; o maddeler açılmadı.

## Geri açılan maddeler (`[ ]`, "doğrulanmadı — Görev 22")

Sınıf var, ama oyunda hiçbir sahne ya da betik onu çağırmıyor; yalnız testi çağırıyor.

| Sınıf (dosya) | Maddeler |
|---|---|
| `SoylentiAgi` (`src/sistemler/soylenti_agi.gd`) | SOY-01…30, 32…46, 50 (46 madde), SOY-SON-01 |
| `KapiKavgasi` (`src/kapi/kapi_kavgasi.gd`) | CAT-01, CAT-02 |
| `SiddetKorkusu` (`src/kapi/siddet_korkusu.gd`) | CAT-04 |
| `Yemin` (`src/soz/yemin.gd`) | DYL-03 |
| `SevilenYuz` (`src/koy/sevilen_yuz.gd`) | SEV-01…05 |
| `DefterTanitimi` (`src/kapi/defter_tanitimi.gd`) | OGR-14 |
| `YeniDugmeIsareti` (`src/arayuz/koy_hud/yeni_dugme_isareti.gd`) | OGR-24 |
| `GecisGecesi` (`src/sistemler/gecis_gecesi.gd`) | OMR-08 |
| `PerdeOzeti` (`src/arayuz/perde_ozeti.gd`) | OMR-10 |
| `KayitYuvaKarti` (`src/arayuz/kayit_yuva_karti.gd`) | AYR-29, AYR-33 |
| `YilIzi` (`src/koy/yil_izi.gd`) | YIL-01, 02, 05, 09, 10 |
| `KonusmaGecmisi` (`src/arayuz/kapi/konusma_gecmisi.gd`) | AYR-11 |
| `ProfilOnerisi` (`src/sistemler/profil_onerisi.gd`) | AYR-41 |
| `AksamSohbeti` (`src/koy/aksam_sohbeti.gd`) | HAN-13, HAN-34 |
| `HavaReplikAdaptoru` (`src/soz/hava_replik_adaptoru.gd`) | KVR-SES-01 |

Ayrıca DYL-14 geri açıldı: `docs/dunya_kitabi/ornek_defteri/` ve kabul testi `tests/tools/test_ornek_defteri.py` yok. `docs/ORNEK_DEFTERI.md` kaynak alanı olmayan 11 örnek tutuyor; madde 12 tür × 3 kaynaklı kayıt istiyor ve deftere modelin yazmasını yasaklıyor. KLT-14 ve KLT-47 bu yüzden alınmadı.

SOY-31, SOY-47 ve SOY-49 (Claude, kapsam kuralları) ile SOY-48 ("ikinci dedikodu kaydı yoktur", oyunda doğru) `[x]` bırakıldı. ISG-39, `SoylentiAgi` oyuna bağlanmadan yapılamaz; ROADMAP'e not düşüldü.

SAH-01…50 ayrıca `docs/SAH_KANIT_TABLOSU.md`'dedir.

## Şüpheli, elle bakılmalı (dokunulmadı)

"Dosya" alanındaki betik repoda yok ve madde kodu hiçbir `src/` dosyasında geçmiyor. İş başka bir dosyada ya da yalnız veriyle yapılmış olabilir; tek tek okunmadan açılmadı.

- HAN-10, HAN-14, HAN-19, HAN-20, HAN-23, HAN-25, HAN-26, HAN-27, HAN-30, HAN-32, HAN-33, HAN-35, HAN-37, HAN-39
- YAZ-07, YAZ-08, YAZ-10, DYL-09, DYL-11, DYL-13, OMR-40, OZL-09

Sınıfı ulaşılamayan ama madde kodu oyunda bağlı başka bir dosyada da geçen maddeler. Kısmen bağlı olabilirler:

- DIY-03 (`KonuMerkezi`), DIY-14 (`HatirlanmaNotu`), DYL-02 (`Bakis`), DYL-06 (`DilEngeli`), DYL-08 ve KOP-04 (`KararDonusu`), OGR-03 (`ZarIpucu`), AYR-22 (`OdakSesi`), ACL-03 ve DYL-07 (`AksamSohbeti`)

## Oyundan ulaşılamayan `src/` betikleri (debug hariç)

`AyakZemini`, `HareketGecisi`, `KalabalikYol`, `SoylentiAgi`, `KapiKavgasi`, `SiddetKorkusu`, `SorguZari`, `ZarIpucu`, `TansiyonKacisAdaptoru`, `DefterTanitimi`, `AksamSohbeti`, `SevilenYuz`, `YilIzi`, `GecisGecesi`, `PerdeOzeti`, `KayitYuvaKarti`, `KonusmaGecmisi`, `HatirlanmaNotu`, `YeniDugmeIsareti`, `TemaOnizleme`, `OdakSesi`, `ProfilOnerisi`, `SonUyarisi`, `SurumEkranListesi`, `EpilogMetinVerisi`, `IcerikAyarlari`, `Bakis`, `BeyinDenetcisi`, `CeliskiYuzlesme`, `DilEngeli`, `HavaReplikAdaptoru`, `KararDonusu`, `KonuMerkezi`, `MuhafizYalani`, `SozVerme`, `Yemin`, `src/veri/chr_sorgu_kurallari.gd`, `src/arayuz/soz/okunmus_isaret.gd`, `src/arayuz/ui_adaylari/onizleme.gd`, Parley eylem/olgu betikleri (`src/diyalog/actions/*`, `src/diyalog/facts/*`; `.ds` verisinden yükleniyor olabilir), ölçüm araçları (`DengeOlcumu`, `is_olcumu.gd`, `bosta_terk_olcumu.gd`).

## Diğer genel düzeltmeler

- `data/metin/metinler.tr.translation` ve `.en.translation` CSV'nin gerisindeydi; 433 anahtar yoktu. Oyunda `GuvenliMetin` ham CSV'ye düşüp uyarı basıyordu; `GuvenliMetin.kur()` çağırmayan testlerde HUD satırları ham anahtarla `%` biçimlemesi yapıp "String formatting error" veriyordu (örnek: `koy.bosta.hud`, `koy.karantina.hud`). Çeviriler yeniden üretildi.
- `karakter_model.gd` içindeki sahte `AyakZemini` bağı kaldırıldı (bkz. SAH tablosu).
- Risk, düzeltilmedi: `tests/unit/kvr/*`, `tests/unit/diyalog/*` ve başka yerlerde 29 test yalnız `assert` ile denetleyip sonda `quit(0)` çağırıyor. Bu testler hata sayacı ve `quit(1)` kullanmıyor.
