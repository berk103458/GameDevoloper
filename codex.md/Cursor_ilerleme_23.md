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

### SOY-29, SOY-30

- SOY-29 çağrı zinciri: köy HUD "Defter" düğmesi → `HafizaDefteriBaglantisi.ac` → `kaynak_derle` → `kaynak["soylenti_agi"] = SoylentiKoprusu.defter_satirlari(oturum)` → `HafizaDefteri._soylenti_sayfasi`.
  - Satırda olay (oyuncu dilinde kalıp), kaynak (köydeki ad), kademe (birkaç / yarı köy / herkes) var. Kaynak köyde değilse satır yok.
  - Önceden `kaynak_derle` bu alanı hiç doldurmuyordu; ekran da olay ve kademe alanlarını çizmiyordu. `hafiza_defteri_ekrani.gd`'ye iki alanlık döngü eklendi.
- SOY-30 çağrı zinciri: `hud.gd` yenilemesi → yeni `src/arayuz/koy_hud/kamuoyu_seridi.gd` `KamuoyuSeridi.guncelle` → `SoylentiKoprusu.kamuoyu_satiri`.
  - Konu yokken satır yok. Tıklanınca `HafizaDefteriBaglantisi.ac` çalışır ve defter Söylenti sayfasında açılır.
- Test: `tests/oto/soylenti_meclis_kontrol.tscn` → GEÇTİ. Satır kamuoyundan önce 0, sonra 1. Defter Söylenti sayfasında açılıyor; sayfa ağ kaydıyla eşit ve olayı + kaynağı gösteriyor.
- Bozma kanıtı:
  - `hud.gd` satırı silinince `KALDI (3 hata)`.
  - `kaynak_derle` satırı silinince `KALDI (2 hata)`.
  - Ekrandaki olay/kademe çizimi kapatılınca `KALDI (1 hata)`.
- Yeşil kalanlar: `hafiza_defteri_test`, `defter_aday_test`, `koy_hud_kontrol`, `yapi_karti_test`, `bosta_kalma_test`, `denge_hud_test`. `Ses` derleme zinciri temiz.

### SOY-45

- Çağrı zinciri: meclis satırı (`CinarMeclisPaneli` → `SoylentiKoprusu.meclis_sikayeti`) ve defter satırı (`kaynak_derle` → `SoylentiKoprusu.defter_satirlari`) kaynağı köy kaydında arar. Ölü ya da köyde olmayan kaynak satır basmaz. Ağdaki uydurma `koylu_N` dinleyicileri gerçek haritada yok (SOY-01 commit'i).
- Test: `soylenti_gecesi_test`. Yaşayan kaynak 1 satır, ölen kaynak 0, köyden silinen kaynak 0.
- Bozma kanıtı: defterdeki sağlık denetimi silinince `KALDI (1 hata)`.

### SOY-38

- Ağın bütün ayar sayıları `SoylentiAgi._ayar` ile `data/soylenti.json`'dan okunuyor. Kademe oranları ve doğrulama güvenilirlik değişimi veriye taşındı; eksik alan `push_error` verir, sessiz varsayılan yok.
- Oyunda okunur: ağ artık `Oturum` üzerinden kuruluyor (SOY-01 zinciri).
- Test: yeni `tests/unit/sistemler/soylenti_ayar_tarama_test.gd` → GEÇTİ. `soylenti_agi.gd` ve `soylenti_koprusu.gd` içinde `.get("…", sayı)` ya da oran yok; okunan her ayar json'da var.
- Bozma kanıtı: kademe oranı koda `0.8` yazılınca `KALDI (1 hata)`.

### SOY-08

- Çağrı zinciri: köyde figüre tıklama → `KoyluKarti.ac` → `KoyluKartiVerisi.soz_guvenilirligi(oturum, k)` → `SoylentiKoprusu.guvenilirlik_kelimesi` → `SoylentiAgi.guvenilirlik_kelimesi`. Kartta `soz_guvenilirligi` satırı görünür.
- Okuma ağ kurmaz: ağ yoksa geçici nesneden varsayılan kelime gelir.
- Test: `soylenti_meclis_kontrol.tscn`. Kartta "Sözü: konuşkan" görünüyor; güvenilirlik 3 olunca "Sözü: ağzı sıkı", sayı yok. Kart okuması oturuma ağ yazmıyor.
- Bozma kanıtı: kart satırı silinince `KALDI (2 hata)`. `koylu_karti_kontrol` yeşil.
- Not: güvenilirliğin oyunda değişmesi (SOY-07/09/11) hâlâ açık. Bugün herkes "konuşkan" görünür.

### SOY-22

- Çağrı zinciri: `Oturum.gece_sonu` → `SancakTeftisi.gece` → `SoylentiKoprusu.teftis(o, d)`.
  - Kamuoyu olmuş tanıklı rüşvet varsa makbuza `soylenti_sorusu` yazılır ve soru listesi boşalır; her olay bir kez sorulur.
  - Sabah kartı `SancakTeftisi.olay_metin` metne `koy.sancak.soylenti_sorusu` cümlesini ekler (metinler.csv'ye tek anahtar).
  - Teftiş yeniden kurulmadı; `oku()` yeni alanı güvenli okur.
- Test: yeni `tests/unit/sistemler/soylenti_teftis_test.gd` → GEÇTİ.
  - 6. gece teftişinde kamuoyu yok, soru 0. 11. gece teftişinde soru 1 ve sabah metninde görünüyor.
  - Soru kayıttan dönüyor; ikinci kez sorulmuyor.
- Bozma kanıtı: teftiş kancası silinince `KALDI (4 hata)`, metin eki silinince `KALDI (1 hata)`.
- Yeşil kalanlar: `sancak_teftis_kontrol`, `sancak_teftisi_test`, `koy_hud_kontrol`.
- Önceden kırmızı (stash ile doğrulandı, ilgisiz): `tests/oto/muhafiz_epilogu_kontrol` (satır 33 assert) ve `tests/unit/kvr/sancak_kayit_slotu_test` ("Yüklenen kişisel kasa gerçek gece teftişinde bulunur").

### SOY-05, SOY-44

- Çağrı zinciri: `Oturum.gece_sonu` → `SoylentiKoprusu.gece` → `SoylentiAgi.gece_ilerlet` → her yeni duyan için `bozulma_bicimi(olay, bozan, gece)`.
  - Zar tutarsa `_bozuk_kopya` açılır: `dogru=false`, kaynak bozandır, `asil` ve `bicim` (ad kayması / yer kayması / abartı) taşır. Asıl kayıt silinmez.
  - Kopya yalnız doğru asıldan doğar (kopyadan kopya yok). DIY-13'e ikinci kayıt açmaz, bar etkisini ikinci kez uygulamaz, teftişe soru olmaz.
  - Defter kopyayı `bozulma_kaliplari` metniyle yazar.
- Karar: zar, olay + bozan + gece karmasından gelir, oyun RNG'sini tüketmez. Aynı koşu aynı sonucu verir.
  - Oran ve çözünürlük `data/soylenti.json`'da (`bozulma_orani` 0.0875, `bozulma_zar_cozunurlugu`, `bozulma_faili`).
- Test: yeni `tests/unit/sistemler/soylenti_bozulma_test.gd` → GEÇTİ.
  - 31 kişilik köyde 4 gerçek gece; her yeni duyanda kopya zarla birebir tutarlı. Asıl doğru kalıyor, dedikoduda kopya yok, defterde biçim kalıbı görünüyor.
  - 1000 örnekte oran tablo ±%5; üç biçim, üç kalıp.
- Bozma kanıtı: kopya ekleme kapatılınca `KALDI (2 hata)`, defter biçim metni kapatılınca `KALDI (1 hata)`.

### SOY-41

- Çağrı zinciri: SOY-01/02/05 zinciri (kapı kararı → gece sonu → ağ). Ağ oyun RNG'sini tüketmez; bozulma zarı olay + bozan + gece karmasıdır.
- Test: yeni `tests/unit/sistemler/soylenti_ikiz_test.gd`. Aynı tohumla iki gerçek koşu, 31 kişi, 6 gece; gece gece ağ kaydı birebir eşit.
- Bozma kanıtı: zara `randi()` karıştırılınca `KALDI (1 hata)`.

### SOY-15

- Çağrı zinciri: `Oturum.gece_sonu` → `SoylentiKoprusu.gece` → `SoylentiAgi.gece_ilerlet`. Yanlış kayıt (SOY-05 kopyası) kamuoyu olunca `histeri_tetik_sayisi` artar.
  - Köprü artışı `BatilInancHisterisi.soylenti_tetigi(y, adet)` okuyucusuna verir. Açık vaka varsa seviye +1 (en çok 3) ve sabah raporuna satır düşer.
  - Vaka yoksa yeni hedef seçilmez; histeri motorunun kriz/hedef kuralı aynı kalır.
  - Seviye histeri durumunda saklandığı için kayıttan döner.
- Test: yeni `tests/unit/sistemler/soylenti_histeri_test.gd` → GEÇTİ.
  - Kirli kuyu vakası 1/3 iken yanlış kamuoyu 2/3 yapıyor ve rapor satırı çıkıyor.
  - Doğru kamuoyu 1/3'te kalıyor. Vakasız köyde hedef seçilmiyor.
- Bozma kanıtı: köprü çağrısı 0 adetle verilince `KALDI (3 hata)`, ağdaki sayaç kapatılınca `KALDI (3 hata)`.
- Önceden kırmızı, ilgisiz (değişiklik saklanarak aynı sonuç alındı):
  - `tests/unit/kvr/batil_inanc_histerisi_test.gd` → "Gerçek Dudu/Şifahane kapasitesi".
  - `tests/oto/batil_inanc_histerisi_kontrol.gd:51` → Nil `id`.
- Açık kalan: vaka yokken yanlış kamuoyu kendi başına histeri başlatmaz; bunun için motorda yeni bir sebep gerekir.

### SOY-09

- Çağrı zinciri: köy ekranında köylüye tıklama → `KoyluKarti.ac` → `NeDuydun.ekle` (yeni `src/koy/ne_duydun.gd`).
  - Köylü ağda bir söylenti duyduysa kartta "Ne duydun?" düğmesi çıkar. Basınca köylü en son duyduğu sürümü kendi ağzından söyler (`Ad: «…»`).
  - Bozan köylü kendi bozuk kopyasını söyler; metin `SoylentiKoprusu.olay_metni` ile defterle aynı kalıptan gelir.
  - Sistem doğru ya da yanlış demez. Hükme bağlanan konu sorulmaz.
  - Duymayan köylüde dal yok; kart okuması ağı kurmaz.
- Test:
  - Yeni `tests/unit/sistemler/ne_duydun_test.gd` → GEÇTİ: taşıyan asıl haberi, bozan bozuk sürümü söylüyor; duymayan 0, hükümlü konu 0.
  - `tests/oto/soylenti_meclis_kontrol.gd` gerçek kartta düğme, cevap ve duymayan dalı için genişletildi → GEÇTİ.
- Bozma kanıtı:
  - Karttaki tek satır silinince UI `KALDI (2 hata)`.
  - Son kaydı seçme kuralı ilk kayda çevrilince birim testi `KALDI (1 hata)`.
- YAZ-08 sohbet dalı yerine kart düğmesi kullanıldı: köylü seçim kartı oyunda zaten açılan gerçek yüzey.

### SOY-20

- Çağrı zinciri: `KoyluKarti.ac` → `NeDuydun.ekle` → "Ne duydun?" cevabından sonra "Bunu konuşma" → `NeDuydun.susturma_cevabi` → `SoylentiAgi.sustur`.
  - Güvenilirlik varsayılanın (2) altında değilse kayıt susturulur, yayılım durur.
  - Altındaysa kayıt `hizlandi` olur ve `gece_ilerlet` o kaydı `susturma_ters_carpan` (2) katı hızla yayar.
  - Oyuncu iki durumda da yalnız "… başını salladı." görür.
- Test: yeni `tests/unit/sistemler/susturma_test.gd` → GEÇTİ.
  - 41 kişilik gerçek köy, gerçek gece: susturmasız yayılım > 0, güvenilir kaynakta 0, güvenilmezde susturmasızdan fazla. Söz aynı.
  - `soylenti_meclis_kontrol` kartta seçeneği bastı → GEÇTİ.
- Bozma kanıtı: ters tepme kapatılınca `KALDI (1 hata)`, karttaki `sustur` çağrısı kapatılınca `KALDI (2 hata)`.

### SOY-14

- Çağrı zinciri: `Oturum.karar_ver` → `SoylentiKoprusu.karar`. Kapıdaki kişinin sınıfı altı DIY-12 grubundan biriyse (tüccar, asker, köylü…) bekleyen olay grubu taşır; taşıyan köylüyle ağ kaydına geçer.
  - `Oturum.gece_sonu` → `SoylentiKoprusu.gece` → `grup_yaz`: kamuoyu olan konu `Oturum.grup_itibari.karar_uygula` ile kararın deltasını (ret/rüşvet −1) bir kez yazar.
  - `grup_yazildi` kayıtta durur. Bozuk kopya grup taşımaz.
- Test: yeni `tests/unit/sistemler/soylenti_grup_test.gd` → GEÇTİ.
  - Tüccar reti kamuoyu olunca tüccar itibarı bir kez −1. Kayıttan sonra iki gece daha geçince yazım hâlâ 1.
  - Çiftçi (grup değil) konusu yazmaz.
- Bozma kanıtı: tek yazım bayrağı, `grup_yaz` çağrısı ya da grubun kayda taşınması ayrı ayrı kapatılınca her biri `KALDI (2 hata)`.
- Açık kalan: Gelen verisinde Türkmen/Rum/Ahi kimliği yok. Bu üç grup ancak veri gelirse yazılır; sınıftan etnik grup uydurulmadı.

### SOY-17

- Çağrı zinciri: `Oturum.karar_ver` → `AileKafilesi.karar` → (reis) `karar_ver` → `SoylentiKoprusu.karar`. Kafileyi ailece kabul `aile_birlikte_alma` olumlu olayı bekletir; sonra kabul edilen köylü onu taşır.
  - `gece_sonu` → `SoylentiKoprusu.gece` → `gece_ilerlet`: kamuoyu olunca `iyi_olay_bar_etkisi` +1 bir kez uygulanır; köprü bunu halk moraline çevirir ve sabaha olumlu satır düşer.
  - Olumlu konu meclise şikâyet olmaz. Bozuk kopyası histeriyi beslemez.
- Veri: `data/soylenti.json` `iyi_olaylar` + üç olumlu kalıp.
- Test: yeni `tests/unit/sistemler/soylenti_iyi_olay_test.gd` → GEÇTİ. Gerçek kafile kabulü, 4 gece; kamuoyu, bar toplamı +1 bir kez, rapor satırı, meclis 0, histeri 0.
- Bozma kanıtı: köprüdeki aile koşulu kapatılınca `KALDI (4 hata)`, meclis filtresi kaldırılınca `KALDI (1 hata)`.
- Açık kalan: listedeki "haksızlığa karşı durma" (divan) ve "yaralı tedavi" (CAT-03) için oyunda henüz yazar yok; yalnız ailece kabul bağlı.

### SOY-21, SOY-07, SOY-11

- Çağrı zinciri: köy HUD'unda "Çınar altı meclisi" → `CinarMeclisPaneli.ac` → `SoylentiHukmu.ekle` (yeni `src/arayuz/koy_hud/soylenti_hukmu.gd`) → "Şikâyeti dinle, hükme bağla" → `SoylentiKoprusu.hukme_bagla`.
  - Asıl kayıt ve bütün bozuk kopyaları `divan_hukmu_ver` ile kapanır; kamuoyu, HUD satırı ve şikâyet söner.
  - Doğru asılın kaynağı `dogru_soylenti_dogrulandi` ile +1 (SOY-07/11). Yanlış her kopyanın bozanı `yanlis_soylenti_dogrulandi` ile −1.
  - Defter satırı "doğrulandı" olur. Ertesi sabah `SoylentiKoprusu.gece` tek "Çınar altında hüküm" satırı basar; satır kayıtta `hukum_satiri` olarak taşınır.
- Karar: kapı söylentisinin konusu muhafızın kendi kapı kararı. Köylü divanı (CAS-07, köylüyü yargılar) yerine SOY-33 şikâyetinin geldiği çınar meclisi hüküm yüzeyi oldu. SOY-50 akışı da "meclis şikâyeti → hüküm → kamuoyu 0" diyor.
- Test:
  - Yeni `tests/unit/sistemler/soylenti_hukum_test.gd` → GEÇTİ. 31 kişi, 4 gerçek gece: hüküm, kamuoyu 0, kopyalar kapalı, kaynak +1, bozan −1, ikinci hüküm 0, defter doğrulandı; kayıttan sonra sabah satırı 1, ertesi sabah 0.
  - `soylenti_meclis_kontrol` gerçek meclis kartında düğmeye bastı → GEÇTİ.
- Bozma kanıtı:
  - Kopya kapatma kapatılınca `KALDI (2 hata)`.
  - Bozan −1 kapatılınca `KALDI (1 hata)`.
  - Sabah satırı kapatılınca `KALDI (1 hata)`.
  - Panel adaptörü kaldırılınca UI `KALDI (3 hata)`.
- Açık kalan: SOY-10 (kapıda "köyde başka duydum") ayrı yoldur, bağlanmadı.

### SOY-50

- Çağrı zinciri: `tests/unit/kvr/soylenti_agi_test.gd`'deki eski ağ birim testi (Antigravity) korundu. Yanına aynı yedi adımın gerçek oyun koşusu (`_oyun_kosusu`) eklendi:
  1. `Oturum.karar_ver(rüşvet)`: tanıklı kayıt, kaynak köylü.
  2. 4 × `gece_sonu`: yayılım.
  3. Kamuoyu.
  4. Bar bir kez −1.
  5. `SoylentiKoprusu.meclis_sikayeti` rüşveti anar.
  6. `hukme_bagla`: kamuoyu 0.
  7. Bozuk kopyanın bozanı −1.
- Test: GEÇTİ.
- Bozma kanıtı: hükümde bozan −1 kapatılınca ve kayıt kapatma kapatılınca test `quit(1)` ile düştü.
- Not: SOY-10/18/19/23/24/25/39 açık. Bu yedi adımın zincirine girmiyorlar.

### SOY-18, SOY-19

- Çağrı zinciri: `CinarMeclisPaneli.ac` → `SoylentiHukmu.ekle` → "Muhafız olarak: Bu söz doğru/yalan" → `SoylentiKoprusu.nitele`.
  - Nitelik kayda `muhafiz_dugumu` olarak yazılır. Kayıtla uyan nitelik muhafızın (`muhafiz`) güvenilirliğini +1, uymayan −1 yapar.
  - Doğru bir konuyu yalanlamak, şikâyeti getiren köylünün tanıklığında `muhafizin_yalani` DIY-13 kaydı açar. Bu tür `dedikodu.gd` ağır olay listesine ve kalıplara eklendi. Tanık köyde değilse kayıt açılmaz.
  - Meclis şikâyet şablonu "karar" olmayan türlerde (yalan) kalıp metnini kullanır.
- DYL-07 akşam sohbeti oyunda yok. Madde "ya da çınarda (MCL)" dediği için meclis yolu bağlandı. DYL-04 muhafız yalanı yerine meclis önündeki inkâr yalandır.
- Test:
  - Yeni `tests/unit/sistemler/soylenti_muhafiz_test.gd` → GEÇTİ: yalan dedi, düğüm kayıtta, muhafız −1, yalan kaydı 1, ikinci nitelik 0, kayıttan döner; doğru nitelik +1 ve kayıt 0; tanık sürgündeyse 0.
  - `soylenti_meclis_kontrol` gerçek kartta seçeneğe bastı → GEÇTİ.
- Bozma kanıtı: güvenilirlik değişimi ya da DIY-13 listesindeki tür kaldırılınca `KALDI (2 hata)`, panel döngüsü boşaltılınca UI `KALDI (2 hata)`.
- Diğer testler: `dedikodu_test` ve `dedikodu_kayit_test` GEÇTİ.

### SOY-32

- Çağrı zinciri: `Ana` (`--debug-arac`) → `AdminHud._ready` → `SoylentiPaneli.kur(dikey, baglam)` (yeni `src/debug/soylenti_paneli.gd`).
  - Panel saniyede bir oturumun ağını okur. Her kayıt için tür, gece, kaynak → duyanlar (duyma sırasıyla), KAMUOYU işareti ve kopyada asıl/biçim yazar.
  - Debug kapalıyken panel kurulmaz. Okuma ağı kurmaz.
- Test: yeni `tests/unit/sistemler/soylenti_paneli_test.gd` → GEÇTİ (debug kapalı 0, boş oturum ağ kurmaz, gerçek gecede kaynak→duyanlar ve gece). `admin_zaman_kontrol` GEÇTİ.
- Bozma kanıtı: debug koşulu kaldırılınca `KALDI (1 hata)`, satır üretimi kapatılınca `KALDI (1 hata)`.
- Not: kim kime aktardı kenarı ağda tutulmuyor. Panel kaynaktan başlayan duyma sırasını gösteriyor.

### SOY-39

- Çağrı zinciri: `DengeOlcumu.olustur(oturum, gece_raporu)` DEN raporuna `soylenti` satırı ekler: `SoylentiKoprusu.olcum` → canlı, kamuoyu, yanlış, yanlış oranı. Salt okuma; ağ kurmaz.
- Test: yeni `tests/unit/denge/soylenti_yogunlugu_test.gd` → GEÇTİ. 30 gerçek gece (üç gecede bir ret/rüşvet, her gece bir kabul); her gecenin DEN raporunda ağla uyuşan satır var.
- Bozma kanıtı: DEN satırı silinince `KALDI (2 hata)`.
- **Ölçüm sonucu (denge riski):**
  - En çok canlı 10 (öneri ≤ 3).
  - En çok kamuoyu 8 (öneri ≤ 1).
  - Ortalama yanlış oranı 0.58.
  - Sebep: SOY-05 her yeni duyanda %8.75 zarla ayrı kopya kaydı açıyor; kopyalar da yayılıp kamuoyu oluyor.
  - Hedefler öneri olduğu için rapor otomatik düzeltilmedi. Denge kararı (kopya sayımı ya da oranı) Claude/Muharrir'e bırakıldı.
- `tools/python_test_runner.py` yerine DEN birim testi kullanıldı; madde "rapor DEN raporunun satırıdır" diyor.

### SOY — açık bırakılanlar ve nedenleri

- **SOY-10:** DYL-01 "Göster" yolu (`CeliskiYuzlesme`) oyunda hiçbir ekrandan çağrılmıyor.
- **SOY-23, SOY-24, SOY-43:** `SozMotoru`/`SatirSecici` oyunda başlatılmıyor (`SozKaydi.motor` yalnız kaydedilip yükleniyor). Bağlam anahtarlarını okuyacak canlı söz akışı yok.
- **SOY-25, SOY-36, SOY-37:** dış dünya söylentisi ("kervan gelmeyecek", "yol güvensiz") türü ağa giren hiçbir oyun olayı yok.
- **SOY-26:** DIY-14 `HatirlanmaNotu` oyunda hiçbir sahneye eklenmiyor.
- **SOY-27:** YAZ-09 kota tablosu ve "duydum ki" satırları yok.
- **SOY-28:** DIY-13 pusula satırlarını (`FisiltiGazetesi.dedikodu_pusulasi_oku`) oyunda okuyan ekran yok.
- **SOY-34:** iş kazası/ücret söylentisi türü yok.
- **SOY-35:** kapı söylentisinin hedefi köylü değil, muhafız; köylüler arası yanlış söylenti üreten yol yok.
- **SOY-46:** YAZ-08 köylü sohbet konu tablosu yok.
- **SOY-SON-01:** değirmen/kuyu/Tekfur/hekim/ışık söylentileri ağa hiçbir oyun olayından girmiyor. Kapanış olaylarının metin anahtarları da tabloda eksik (import uyarısı: `olay.soylenti_degirmen_kapanis.sonuc1`).
  - `soylenti_ve_meclis_davalari_test` bu yüzden hâlâ `KALDI (3 hata)`.

### CAT-01/02/04 — açık bırakıldı

- `KapiKavgasi.ret_degerlendir` kavga tipi (`genc_erkek`, `ac_aile_reisi`, `asker_kacagi`) ve neden (`yer_yoklugu`, `sert_ret`) istiyor.
- Bu değerler yalnız `data/kapi_kavgasi.json` ile `kapi_kavgasi.gd` içinde var. Hiçbir gelen veya karakter verisi kavga tipi taşımıyor; "sert ret" üreten bir kapı yolu da yok.
- Bağlamak için gelenlere tip uydurmak gerekir, bu yüzden açık kaldı. Tip verisi tasarımı Claude/Muharrir'de.

### SEV-01 … SEV-05 — açık bırakıldı

- SEV-01 ve SEV-02 boş güne dayanıyor. Boş günü üreten KAP-16 testx'in `[/]` maddesi, ona dokunulmadı.
- SEV-03, SEV-04 ve SEV-05 her biri yeni sistem istiyor (`kisisel_iz.gd`, `tek_istek.gd`, `koylu_bagi.gd`). `SevilenYuz` 60 satırlık bir iskelet; çağrılacak gerçek bir motoru yok. Görev 23 kapsamında yarım kalma riski yüzünden alınmadı.

### YIL-01, YIL-02, YIL-05, YIL-10 — kapandı

- Çağrı zinciri: `Oturum.gece_sonu` → `KoyYonetimi.gece` → (gün artmadan önce) `YilIziGecesi.gece(self, olaylar)`. Bu adım şunları yapar:
  - `YilIzi.sec` ile yılın yüzünü seçer; tarla iş yeri `KoyBinasi.tur == "tarla"` üzerinden okunur.
  - `YilIzi.satir` çağrılır. Bağlam duran kayıtlardan gelir: MEV-08 `HasatSenligi.son_yil`, MEV-06 `IlkbaharTaskini.hasar`, ev ve iş yeri.
  - Yeni satır gece raporuna "Ad: metin" olarak girer.
  - 28. gecede `YilIzi.kapanis` "Yıl kapandı; … %d mevsim sözü" satırını yazar.
- Kayıt: `KoyYonetimi.kaydet` içine `yil_izi` anahtarı, `kayittan` içine `YilIzi.oku` eklendi. Eski kayıtta alan yoksa iz boş açılır.
- Test: yeni `tests/unit/koy/yil_izi_oyun_test.gd` → GEÇTİ. 28 gerçek gece; şenlik gecesinde güz sofrası, kışın tarla işçisinde satır yok, kapanışta 3 sayımı, kayıt yüklemesi. `yil_izi_test`, `yasam_test`, `hasat_senligi_test` ve kayıt testleri de GEÇTİ.
- Bozma kanıtı (hepsi kırmızıya döndü):

  | Bozulan bağ | Sonuç |
  |---|---|
  | Gece bağı silinince | `KALDI (6)` |
  | Şenlik bağlamı kapatılınca | `KALDI (1)` |
  | Tarla okuması kapatılınca | `KALDI (1)` |
  | Kayıt anahtarı silinince | `KALDI (1)` |

- Not: Yılın başında köyde adlı kimse yoksa, yıl ortasında gelen ilk adlı kişi seçilir.
- **YIL-09 açık kaldı:** satır kartta duran adı (`Koylu.ad`) söylüyor. Ancak SEV-06'nın maske/gerçek ad ayrımı (`persona_maskesi`, `Flag_Kimlik_Cozuldu`) oyunda karta bağlı değil, bu yüzden çoban/Fadime kabulü sınanamaz.

### OGR-24 — kapandı

- Çağrı zinciri: `KoyEkrani._alt_panel_kur` → `YeniDugmeBaglantisi.kur(sag, oturum.ipucu_kaydi, {pazar, divan_ac})`. Her düğmeye `YeniDugmeIsareti` takılır. İlk görüşte bir kez yanıp sönen çerçeve ve düğmenin altında tek satır çıkar; basınca `dugmeye_girildi` işareti, satır da kendisi kalkar.
- Görüldü bilgisi `Oturum.ipucu_kaydi`ndadır ve kayda girer.
- Not: pazar ve divan düğmeleri oyunda baştan etkin. "İlk kez etkin olunca" burada ilk köy ekranı demek.
- Test: yeni `tests/oto/yeni_dugme_kontrol.tscn` → GEÇTİ. Gerçek `Ana` ve köy ekranı; ikinci açılışta işaret 0. `ilk_saat_test` de koşuldu.
- Bozma kanıtı (hepsi kırmızıya döndü):

  | Bozulan bağ | Sonuç |
  |---|---|
  | Köy ekranı bağı silinince | kırmızı |
  | Basınca kaldırma kapatılınca | `KALDI (1)` |
  | Kayıt bağı kesilince | `KALDI (3)` |

### OGR-14 — açık bırakıldı

- Beyan defteri düğmesi "kendi sözüyle çelişki" anını bekliyor. Bu çelişkiyi yalnız `SozMotoru` ve DYL-01 `CeliskiYuzlesme` üretiyor, ikisi de oyunda çalışmıyor (bkz. SOY-10/23). `DefterTanitimi.celiski_kaydet` bu yüzden bağlanamadı.

### OMR-08 — kapandı

- Çağrı zinciri: `Oturum.gece_kuyrugu` içinde, açılış kapı kapalı denetiminden sonra tek satır: `GecisGecesi.gecis_gecesi_mi(yonetim)` doğruysa kuyruk boş döner.
  - Nüfus 18'e varınca `_asamalar` ağalığı açar, `PerdeGecisi.isaretle` de `perde2_baslangic = gün+1` yazar. Geçiş gecesi bu başlangıç günüdür.
  - KAP-16 testx'te olduğu için boş gün zarına dokunulmadı; kuyruk doğrudan boş döner. Boş kuyruk yolu açılıştaki `kapi_kapali` ile aynıdır.
- Test: yeni `tests/unit/sistemler/gecis_gecesi_oyun_test.gd` → GEÇTİ. Gerçek kabul ve gece; geçiş gecesinde kuyruk 0, ertesi gece dolu. `perde_gecisi_test` ve `acilis_senaryosu_test` de GEÇTİ.
- Bozma kanıtı: satır kapatılınca `KALDI (1)`.

### OMR-10 — kapandı

- Çağrı zinciri: Ağalık gecesi `Oturum.gece_sonu` `perde_degisti` döndürür → `Ana` `_perde_gecisi` → `BilgiEkrani` metni. Kadraj metninin altına `PerdeOzeti.oturumdan(oturum)` altı satırı eklenir.
- Satırların kaynağı:
  - Gün: `KoyYonetimi.gun`.
  - Gelen, kabul ve ret: `kabul_sayisi` ve `ret_sayisi`.
  - Ölü: yeni `toplam_olen` sayacı. `KoyYonetimi.gece` içinde `_saglik_ve_moral`dan sonra `PerdeOzeti.olum_say` çağrılır; sayaç `kaydet`/`kayittan` ile korunur. Önceden kümülatif bir ölü kaydı yoktu.
  - En çok anılan karar: söylenti ağında en çok duyanı olan doğru kaydın kalıp metni. Bozuk kopya ve yalan sayılmaz. Defterde "anılma" sayımı olmadığı için ağ kullanıldı.
- Test: yeni `tests/oto/perde_ozeti_kontrol.tscn` → GEÇTİ. Gerçek `Ana`, 19 kabul ve bir ret, bir ölüm, ağalık gecesi, perde kadrajı ve kayıttan dönüş. `perde_gecisi_test` de GEÇTİ.
- Bozma kanıtı (hepsi kırmızıya döndü):

  | Bozulan bağ | Sonuç |
  |---|---|
  | Ana bağı silinince | `KALDI (6)` |
  | Ölüm sayacı kapatılınca | `KALDI (1)` |
  | Anılan karar kapatılınca | `KALDI (1)` |

### AYR-11, AYR-29, AYR-33, AYR-41, HAN-13, HAN-34 — açık bırakıldı

- **AYR-11:** Kapı ekranındaki konuşma akışı (`KapiEkrani._kayit`, RichTextLabel, `scroll_following`) fare tekeriyle zaten yukarı kayıyor.
  - `KonusmaGecmisi` ikinci bir akış (Label yığını) kurar ve tekerin her iki yönünde ilk satıra atlar. Bağlamak mevcut davranışı bozar.
  - Eksik olan yalnız gamepad sağ çubuğu. Bunun `_kayit`'a ince bir adaptörle eklenmesi ayrı karar.
- **AYR-29, AYR-33:** `Ana` tek `GuvenliKayit` dosyasına yazıyor. Yeni oyun ekranındaki yuva seçimi (`KayitYuvalari`) kayıt yoluna bağlanmıyor; AYR-28 oyunda yarım.
  - Yuva kartı gerçek kaydı değil, hep boş yuvaları gösterir. Önce yuva yolunun `Ana.kayit`a bağlanması gerekir; bu, korumalı `ana.gd` kayıt akışını değiştirir.
- **AYR-41:** Gece başı FPS ölçümü yalnız TEK-10 `PerformansGunlugu`nda var, o da yalnız debug yapıda ya da `--perf-log` ile açılıyor.
  - Normal oyuncu için üç gece ortalaması üretilmiyor. Yayın yapısında yeni bir ölçüm hattı açmak ayrı tasarım kararı.
- **HAN-13, HAN-34:** İkisi de ACL-03 akşam sohbetinin dalları. `AksamSohbeti` oyunda hiçbir yerden açılmıyor, akşam sohbeti sahnesi yok. Dalı bağlanacak ana sahne olmadığı için açık kaldı.
