# BUG-21 — taş yatağı ve kurtarıcı kaynak

11 Ekim 2026 · Uygulayan: Codex (Berk) · Claude incelemesine hazır çalışma ağacı; ROADMAP işareti değiştirilmedi, commit/push yapılmadı.

Yeni oyun köy kenarında sınırlı taş yatağıyla başlar. Toplam/verim/kurtarıcı miktarı/sınırı `data/koy/tas_yatagi.json` içindedir. Kazı ataması mevcut `KoyYonetimi.ata` üzerinden ayrı kaynak kimliğine gider; yatağın kendisi bina veya ikinci ocak türü değildir. Mevcut EKO-05 kataloğu, maliyeti ve üretimi korunur.

Kazı günde bir kez işçi başına 4 taş üretir. Ambara sığmayan taş yatakta kalır. Sağlıklı yetişkin kazıcılar mevcut yaş, karantina, dış görev, uyuklama, grev ve iş reddi kapılarından geçer. Tükenen yatak işçileri ve hücreyi serbest bırakır. Mevcut rota ağı kazıcıları yatağın yanına götürür.

Sabah adaptörü tek satırdır. Yatakta veya ambarda taş varsa, inşa halinde bile ocak varsa, mevcut maliyet/akçe/yol/alan/yön kurallarıyla ocak kurulabiliyorsa veya oyun bittiyse kurtarıcı yoktur. Üç başarılı yerleştirme sınırı oyun kaydında korunur. Boş hücre yoksa sayaç ve RNG harcanmadan ertesi sabaha ertelenir; aynı sabah çağrısı yinelenmez.

Optional `tas_yatagi` alanı toplam, kalan, hücre, kurtarıcı sayacı, gece/sabah kilidi ve ayrı tohumlu RNG durumunu saklar. Alan yok/null/bozuksa yatak eklenmez. Restore dolu hücreyi ezmez; ambarın eski stoğunu değiştirmez. Hücre rezervi bina olmayan ayrı kimlikle yeniden kurulur; ikinci bir ızgara veya üretim sistemi açılmaz. Ayrı RNG mevcut gece olaylarının RNG akışını değiştirmez.

Taş kartının bilgi/kazı/bırak kontrolleri aynı kart içindedir. Kazı ve kurtarıcı raporları CSV anahtarlı Dictionary olaydır; mevcut `IflasYoneticisi.olay_metin` bunları gece/sabah raporuna çevirir. CSV'ye yalnız altı yeni anahtar eklendi; önceki tüm satırlar aynı kaldı. Gerçek asset üretilmedi/indirilmedi; gri BoxMesh öbeğinin tek değişim noktası `tas_yatagi_gorseli.gd`, envanter kimliği `BUG21-TASYATAGI`.

## Kabul iddiası → test

Tüm birimler `tests/unit/koy/tas_yatagi_test.gd` içinde; gerçek ekran testi `tests/oto/tas_yatagi_kontrol.gd/.tscn` ve tam sanity listesindedir.

| İddia | Birim / gerçek akış |
|---|---|
| Yeni gerçek oturumda kenarda 20 taş; ikinci ocak yok | `_yeni_oyun` |
| İşçi başı 4/gün; iki işçi 8; toplamı aşmaz | `_uretim` |
| Bilgi kalan taşla birebir; 0'da kazı kapalı | `_yeni_oyun`, `_uretim`, gerçek taş kartı ve düğmesi |
| Taş 0 + ocak yok + kurulamıyor → sabah 10 taş; tek bilgi | `_kurtarici`, gerçek `_geceye_gec` ve rapor Label sayısı |
| İşçisiz bekletmede düşmez | `_bekletme_ve_ocak` (dört gerçek gece) |
| Kurulabilen veya inşa halindeki ocakta, pozitif taşta düşmez | `_bekletme_ve_ocak` |
| Sayaç 3'te durur; yeniden çağrı/restore bilgiyi çoğaltmaz | `_sayac_ve_erteleme`, `_kurtarici`, `_kayit` |
| Boş hücre yoksa çökmeden ertelenir; sonra boşalana düşer | `_sayac_ve_erteleme` |
| Eski kayıt yatak eklemez ve stokunu korur; UI'da yok | `_kayit`, eski Oturum kaydıyla gerçek köy ekranı |
| Aynı tohum aynı başlangıç/kurtarıcı hücresi; oyun RNG'si korunur | `_tohum`; `_kayit` RNG restore |
| Hızar + 2 çadır + tarla sonrası 10 gün içinde ocak | `_acilis`: mevcut başlangıç stokları, gerçek gece ve tüccardan eksik 3 odun alış API'si |
| Çocuk/yaralı ataması yok; kapasite doluyken yatak kaybolmaz | `_atama_ve_kapasite` |
| Kazı/bırak düğmeleri, gri BoxMesh, rota hedefi; panel çoğalmaz | Gerçek UI testi |

Açılış testinde kaynak enjektörü yoktur. BUG-22'nin beş farklı açılış sırası ve stok dengesi bu görevde değiştirilmedi; bu test yalnız BUG-21'in belirtilen açılış kabulünü mevcut ticaretle doğrular.

## Değişen dosyalar

- Yeni mantık: `src/koy/tas_yatagi.gd`, `src/koy/kaynak_kurtarici.gd`.
- Yeni UI/yer tutucu: `src/arayuz/koy_hud/tas_yatagi_paneli.gd`, `src/koy/gorsel/tas_yatagi_gorseli.gd`.
- İnce adaptörler: `src/koy/koy_yonetimi.gd`, `src/koy/is_memnuniyeti.gd`, `src/arayuz/koy_ekrani.gd`, `src/dunya/koy_yonetim_sahnesi.gd`, `src/koy/gorsel/koy_halk_hareketi.gd`.
- Veri: `data/koy/tas_yatagi.json`, `data/metin/metinler.csv`.
- Testler: `tests/unit/koy/tas_yatagi_test.gd`, `tests/oto/tas_yatagi_kontrol.gd`, `tests/oto/tas_yatagi_kontrol.tscn`, `tools/sanity_check.py`.
- Godot UID: dört yeni kaynak betiğinin ve iki yeni test betiğinin altı `.gd.uid` dosyası.
- Notlar: `docs/EKSIK_ASSET_ENVANTERI.md`, `codex.md/Codex.md`, `OYUN_RAPORU.md`, bu rapor.

## Doğrulama

55 birim kontrolü ve gerçek UI testi geçti. Son headless editor import exit 0, SCRIPT ERROR/parse/load hatası yok. `python -B tools/metin_dogrula.py` PASS. Tam sanity sonucu koşu bitince buraya yazılacak.

`APPDATA=C:/Users/ds/Documents/Codex/codex-wt/work/ad/roaming` ve `LOCALAPPDATA=C:/Users/ds/Documents/Codex/codex-wt/work/ad/local` mutlak yollarıyla tüm Godot/sanity çağrılarına aktarıldı. Kanıt: `work/bug21/import-final.log`, `work/bug21/sanity-console.log`, `work/bug21/tas_yatagi_test.log`, `work/bug21/tas_yatagi_kontrol.log`.

Windows headless ortamının mevcut kök sertifika deposu uyarısını sanity'nin mevcut gürültü filtresi ayırır; oyun betiği/import hataları filtrelenmez.

Ayna `C:/Users/ds/Documents/GitHub/GameDevoloper` okunabildi; ilgili mevcut dosyalar görev öncesi içerikle aynı. Bu oturumun yazma izni yalnız çalışma ağacını kapsadığı için ayna eşitlemesi yapılamadı; eşitlendi iddiası yoktur. Git metadata'sına yazılmadı. Ajan Masası yorumları `gh` bu ortamda bulunmadığı için okunamadı.
