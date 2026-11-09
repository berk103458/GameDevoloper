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

### SOY-02, SOY-06, SOY-12, SOY-13, SOY-16, SOY-40

- Çağrı zinciri: `Oturum.gece_sonu` → `SoylentiKoprusu.gece(self, r)` → `SoylentiKoprusu.baglar` (gerçek köylülerden komşu/iş arkadaşı haritası) → `SoylentiAgi.gece_ilerlet(gun, nüfus, komşu, iş)`.
  - Kamuoyu olunca `Oturum._herkese_moral(fark * KOPRU_MORAL)` çalışır ve gece raporuna "Köy bunu konuşuyor" satırı düşer.
- Karar: evi olmayan köylüler ortak kampta birbirinin komşusudur. Açılış köyünde kimsenin evi ya da işi yok; aksi halde ağ hiç yayılmazdı.
- Test: `tests/unit/sistemler/soylenti_gecesi_test.gd` → `SÖYLENTİ GECESİ: GEÇTİ`. 15 kişilik köyde gece başına en çok 4 yeni duyan var ve hepsi köyde. 2. gece %40 eşiğinde kamuoyu oluyor, bar bir kez −1 ve moral bir kez düşüyor. Konu 5 gece sonra sönüyor, 8. gece kayıt düşüyor. 4 kişilik köyde ağ susuyor.
- Bozma kanıtı:
  - Gece kancası silinince `KALDI (10 hata)`.
  - Moral satırı silinince `KALDI (1 hata)`.
  - Kamp komşuluğu geri alınınca `KALDI (9 hata)`.
- Açık kalan: Çınar meclisinin kamuoyu konusunu oyunda gerçekten alması SOY-33'tür. `meclis_sikayeti_sec` henüz `CinarAltiMeclisi`'ne bağlı değil. SOY-13'teki tüccar barı ayrımı yok; kapıdaki rüşvet ve haksız ret halka dokunuyor.

### SOY-42

- Çağrı zinciri: `Oturum.kayittan` → `SoylentiKoprusu.yukle(o, veri.get("soylenti_agi"))`. Eski kayıtta alan yoksa ağ boş başlar ve DIY-13 satırı kaynaksız sayılır. Bozuk alan reddedilir, oyun çökmez.
- Test: `soylenti_koprusu_test` → GEÇTİ. Tür denetimi silinince `KALDI (1 hata)` ve SCRIPT ERROR.

### SOY-33

- Çağrı zinciri: köy HUD yenilemesi → `CinarMeclisPaneli.hud` → `SoylentiKoprusu.meclis_sikayeti(e.oturum)`. Canlı kamuoyu konusu varsa düğme görünür.
  - Düğmeye basınca `CinarMeclisPaneli.ac` → aynı fonksiyon → `MeclisSesi.sikayet_metni(karar adı, taşıyanın adı)` → `meclis_soylenti_sikayeti` satırı.
  - Kaynak köyde yaşamıyorsa satır basılmaz. Karar adları `data/soylenti.json` `meclis_karar_adlari`'nda.
- Test: `tests/oto/soylenti_meclis_kontrol.tscn` → `SÖYLENTİ MECLİS UI: GEÇTİ`. 1. gece kamuoyu yok ve düğme görünmüyor. 2. gece düğme açılıyor, satır "ret kararı" ile taşıyanın adını taşıyor.
- Bozma kanıtı: panel satırı silinince `KALDI (1 hata)`, düğme görünürlük satırı silinince `KALDI (1 hata)`.
- Mevcut `cinar_alti_meclisi_kontrol`, `meclis_sesi_test`, `cinar_meclisi_genisletme_test` yeşil.
