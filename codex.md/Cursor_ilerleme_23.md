# Cursor — Görev 23 ilerleme (ROADMAP sürekli çalışma)

Taban: festive. Her maddeden önce `git fetch` + rebase yapıldı. Kalfa'nın SAH maddelerine dokunulmadı.
Test: Godot 4.7.2 headless, `--import` + hedefli testler; tam sanity yok.

## (a) Yalnız `assert` kullanan testler — `891f3776`

- 32 test dönüştürüldü: 17 birim testi yalnız `quit(0)` ile bitiyordu, 4 testte `quit(hata)` yanında `assert` vardı, 11 `oto` testinde `quit(0)`/`quit()` yolu vardı.
  - Her `assert(x)` artık `_dene(x, "dosya:satır")` oldu (dört testte mevcut `dene`).
  - Çıkış `quit(1 if _hata > 0 else 0)`. GEÇTİ satırı yalnız hata 0 iken basılıyor.
- Neden: headless debug yapısında başarısız `assert` testi dondurur (çıkış 124, zaman aşımı), export yapısında ise hiç çalışmaz.
- Kanıt: `guvenli_ses_test` ve `koy_ortam_kontrol` beklentisi bilerek bozuldu; ikisi de anında `KALDI (1 hata)` verdi, çıkış 1.
- Bulgu: dört test değişiklikten önce de bozuktu, `assert` testi dondurduğu için görünmüyordu.
  - `canli_hayvan_takasi_test`, `savunma_guvenligi_test`, `casus_gece_takibi_test`: kök neden YAP yapı kilidi. Ahır, ağıl, kışla ve şifahane, bilgi ya da 1. kademe yapı olmadan kurulamıyor. Kurulum oyundaki gibi yapılıyor, üçü de geçiyor.
  - `soylenti_ve_meclis_davalari_test`: `SoylentiAgi` kaydı açılmıyor. Test artık çıkış 1 ile `KALDI (3 hata)` veriyor; SOY-SON-01 zaten açık.

## (b) "Identifier not found: Ses" — `64fb12fb`

- 368 `-s` testi `--check-only` ile tarandı. Yalnız 4 test bu hatayı veriyordu: `denge_hud_test`, `bosta_kalma_test`, `yapi_karti_test`, `hud_islem_test`.
- Zincir: `yapi_karti`/`kaynak_gostergesi` → `hud.gd` → `karantina_paneli.gd` (`ekle(e: KoyEkrani…)`) → `koy_ekrani.gd:217` `Ses.cal`. `-s` betiği autoload'lar kaydedilmeden derlendiği için `Ses` bilinmiyor.
- Kök düzeltme: HUD sayacı `KoyEkrani` bağımlılığı olmayan yeni `src/arayuz/koy_hud/karantina_hud_sayaci.gd`'ye taşındı; `hud.gd`'de yalnız bir satır değişti. `KarantinaPaneli.hud_guncelle` ince yönlendirme olarak duruyor.
- Kanıt: `hud.gd` satırı geri alınınca hata geri geldi (`koy_ekrani.gd:217`); düzeltmeyle 4 test temiz derleniyor ve geçiyor (`YAPI KARTI: GEÇTİ`, `DENGE HUD TEST: GEÇTİ (0 hata)`, `BOŞTA KALMA MODEL: GEÇTİ`, `HUD İŞLEM KAPISI: GEÇTİ (0 hata)`, `KOY HUD TEST: GEÇTİ (0 hata)`).

## Ek test onarımı — `965813db`

- `tests/oto/karantina_kontrol.gd` ve `tests/oto/hekim_ilac_kontrol.gd` değişiklikten önce de çöküyordu (YAP kilidi, şifahane kurulamıyor).
- Kurulum bilgi + barınak olmayan 1. kademe yapı (`tas_ocagi`) ile yapılıyor. Kulübe kullanılınca ev etkisi sağlık hesabını değiştiriyordu.
- Sonuç: `KARANTINA UI: GEÇTİ`, `HEKIM ILAC UI: GEÇTİ`.

## (c) Bağsız maddeler

### Bulgu: dedikodunun oyunda kaynağı yoktu

- `oturum.dedikodu` her gece ilerliyordu ama oyunda ona olay yazan yer yoktu. Yazan iki dosya (`siddet_korkusu.gd`, `kapi_kavgasi.gd`) oyundan çağrılmıyor.
- `KapiNobeti.yaz` oyunda hiç çağrılmıyor, yani kapı nöbetçisi tanık olamaz. Savunma konuşlanması yalnız ağalık + maaşlı muhafızda açılıyor.
- Karar: tanık, DIY-13 kural 2'deki "kapıda sırada duran" kişidir. Kapıdaki ağır olay o gece bekler; sonra gelen biri kabul edilip köylü olunca haberi içeri taşır ve kaynak o olur. Gece biter de taşıyan çıkmazsa haber düşer.

### SOY-01, SOY-03, SOY-04 — commit (aşağıda)

- Çağrı zinciri:
  - Kapı ekranı → `Oturum.karar_ver` → `SoylentiKoprusu.karar(self, gelen, karar, ek)` (yeni `src/sistemler/soylenti_koprusu.gd`).
  - Rüşvet ya da kusursuz yolcunun reddi bekleyen haber olur. Sonraki kabulde `SoylentiAgi.soylenti_ekle` çağrılır; bu da `oturum.dedikodu.olay_kaydet` ile aynı DIY-13 kaydını açar, tanık ve kaynak taşıyan köylüdür.
  - `Oturum.gece_sonu` → `SoylentiKoprusu.gece`: bekleyenler düşer, ağ gerçek komşu/iş arkadaşı haritasıyla yayılır.
  - `Oturum.kaydet/kayittan` → `SoylentiKoprusu.kaydet/yukle`. Eski kayıt ağsız açılır.
- `SoylentiAgi.gece_ilerlet`'teki uydurma `koylu_N` dinleyicileri artık yalnız iki harita da boşken (eski birim testi yolu) ekleniyor.
- Test: `tests/unit/sistemler/soylenti_koprusu_test.gd` → `SÖYLENTİ KÖPRÜSÜ: GEÇTİ`.
- Bozma kanıtı: `oturum.gd`'den kapı kancası silinince `KALDI (5 hata)`, yükleme satırı silinince `KALDI (1 hata)`.
- Not: `tas_yatagi_test`, `tehdit_takvimi_test`, `baglam_sorgusu_test` bu değişiklikten önce de kırmızı (stash ile doğrulandı); bu maddeyle ilgisiz.
