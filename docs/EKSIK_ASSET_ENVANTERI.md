## 6 Kasım 2026 — YAP05-ODA (Kalfa)

3D çözümleme odası:13. yüzyıl Anadolu köyünde sade tek odalı ahşap/kâgir çalışma yapısı; yaklaşık4×4 m taban,3 m yükseklik. Öncelik orta. Yer tutucu src/koy/gorsel/cozumleme_oda_yer_tutucu.gd içindeki düz renk BoxMesh ve Türkçe isim etiketi; katalog kimliği cozumleme_odasi. Gerçek başsız sahnede kutu ve dokusuz malzeme doğrulandı. Yeni model/görsel üretilmedi veya indirilmedi. Ekleyen Kalfa.

## 6 Kasım 2026 — YAP04-DEFTER (Kalfa)

2D kişisel eşya ikonu: marangoz ustasının defteri / yapı resmi. Öncelik orta. Yer tutucu: src/arayuz/koy_hud/kisisel_karaborsa_paneli.gd mevcut ColorRect ve ad etiketi; oda sergisinde mevcut kutu. Dosya adı: usta_defteri_marangoz.png. Boyut64×64. Saydamlık için kaynak düz #00FF00 yeşil. Tekli İngilizce prompt: "A single small worn leather bound carpenter notebook from thirteenth century Anatolia, closed plain cover with a simple cord, centered inventory icon, hand painted medieval game style, no writing, no letters, no symbols, isolated on a solid bright #00FF00 green background, 64 by 64 pixels." Üretim/indirme yapılmadı; png/ses/model eklenmedi. Ekleyen: Kalfa.

# Kapı Muhafızı — Eksik asset envanteri

## 3 Kasım — SAB-03 kapalı tezgâh örtüsü (Cursor)

SAB-03. 2D örtü. Yer tutucu: düz renk bez, ANI-08 düğümünün üstünde; kodda sahne eklenmedi, bayrak `sabah_defteri.kapali`. Dosya adı `sabah_tezgah_ortu.png`. Boyut 256×128. Saydam kaynak düz #00FF00. Prompt: "A small plain unpatterned cloth cover draped over a medieval Anatolian workshop stall, flat color, no text, transparent background." Öncelik düşük. Ekleyen: Cursor.

## 3 Kasım — TEZ-03…08 tezgâh yer tutucuları (Cursor)

Üretilmedi. Düz renk küp, örtünün üstünde. TEZ03-HAM, TEZ04-IZ (bir kenar koyu), TEZ05-BICIM, TEZ06-AGIZ (bir uç açık), TEZ07-TITREME (eğri tek çizgi), TEZ08-PARCA (küçük kutu). 3B, yaklaşık 0,4 m. Ekleyen: Cursor.

## 3 Kasım 2026 — hazır 2D adaylar (Cursor)

Oyun betiğine, defter sinyaline ve genel `Theme` dosyasına dokunulmadı. Görseller `assets/gorsel_adaylari/` altında. Varsayılan defter `yirtik`; bağ `assets/gorsel_adaylari/defter/secili.json` ve `secili_sayfa.tres`. Önizleme `docs/GORSEL_ADAYLARI.md`. Atıf `docs/credits/HAZIR_ASSET_ATIFLARI.md`.

**Kapatılan veya kısmi bağlanan:** defter sayfası, kapak, sayfa çevirme kareleri, deri ayraç, mühür, mürekkep süsleri; kâğıt ve yıpranmış tahta dokusu; kaynak, eşya, yapı, mevsim, savunma ve mühür ikonları. Satır **kapatıldı** ise konu tutuyor. **Kısmi** ise elde silüet var, boyalı sahne değil. Lisans yalnız CC0, kamu malı veya CC-BY.

**Açık kalan:** adlı ve sınıfsız portreler, kişi izleri, ekmek, tuz, yüzük, ilkbahar, açlık, yorgunluk, zar, sekiz anlatı yükleme/son sahnesi, boyalı kart ve portre çerçevesi (yerinde duruyor; üstüne yazılmadı). Çini, Parşömen ve Ocak düz renk şablonları kopyalanmadı. 3B alınmadı. Lisansı belirsiz veya düz giriş kutusu gibi duran parşömen alınmadı.

## 3 Kasım — GRV-26 kabuk yer tutucuları (Cursor)

Yeni doku indirilmedi ve üretilmedi. `GRV02-AYARLAR` ve `GRV04-DURAKLAT` zemini `Kabuk.zemin()` düz rengidir. Ayarlar ekranı Bölüm 35'te başka işte olduğu için bu turda yerleşimi değişmedi. Duraklat zemini `bilgi_ekrani.gd` içinde `kabuk_zemin` düğümüdür.

## 3 Kasım — gece UI adayları (Cursor)

Beş açık lisanslı 2D arayüz paketi `assets/ui_adaylari/` altına alındı ve ayrı ekranlara tema olarak bağlandı. Eksik üretim kuyruğu değildir; kaynak, lisans ve ekran eşlemesi [UI adayları](UI_ADAYLARI.md) belgesindedir. Yeni görüntü üretilmedi. Seçim Ahmet'tedir; seçilene kadar `tema.gd` ve `src/arayuz/tema/` değişmez.

## 28 Ekim — HAE-02 LOWPO karakter ve UAL hareket bağlantıları (Kalfa)

İHT-0357 (kısmi), İHT-0431 (kısmi), İHT-0444, İHT-0445 (kısmi), İHT-0452 (kısmi), İHT-0453, İHT-0524 — **bağlandı (Kalfa)**. src/dunya/hazir_karakterler.gd LOWPO çocuğu 1,15 m ve adsız demirci rolünü 1,80 m kurar. Adlı ustaların kimliği/modeli korunur. UAL A01 idle/yürüme/konuşma, A02 hasat; yalnız UAL'de olmayan çekiç için A03 Hammering. Ahmet yerel referans kullanımını açıkça onayladı: data/animasyon/ual_referans.json yalnız sayısal rig/rest ve kaynak hash, ham model ve yeni indirme yok. Skin bind adları eşlendi, kaynak global rest/poz farkı hedef rest üzerine 30 FPS uyarlandı. Rota yönünde kök hareketi yok. Meslek değişiminde aktör dönüşümü, kayıt/RNG ve rota durumu korunur. Prosedürel düzeltici LOWPO'da ikinci kez uygulanmaz. Hedefli karakter, CHR kapı/sıra sonucu/köy hareket/zanaat/ses testleri geçti. 44 Meshy karakterin tamamı yeniden retarget edildi sayılmaz. Orak aleti ve özgül usta varyantları açık. 452bb671 kod yayını; son talimat: görünür Godot açılmaz.

## 28 Ekim — HAE-05 Dokulu GPU meşale, ocak ve baca (Kalfa)

İHT-0150 (uyarlama), İHT-0157 (uyarlama) — **bağlandı (Kalfa)**. src/koy/gorsel/hazir_ates_efektleri.gd: meşalede Kenney alevi, meydan/çalışan ocakta Kronbits ateşi, bacada Kenney dumanı. Her emitörde en çok 32 parçacık, gölge yok; atölye aktifliği/LOD ve düşük grafik profili korunur. Baca MegaKit tuğla modülünden 3,20 m tepeyle kuruldu. hazir_vfx_kontrol, atolye_parcaciklari_kontrol, hazir_koy_yapilari_kontrol ve koy_hareket_kontrol geçti; gerçek Vulkan gece renderı TEMP/kalfa_entegrasyon_20261028/gece_vfx.png. Yağmur/kar, özel kıvılcım ve ışık maskesi bu teslimle tamamlandı sayılmaz; UI/harita/portre değişmedi.

## 28 Ekim — HAE-04 Hazır Ses bağlantıları ve kısa dere döngüsü (Kalfa)

İHT-0468, İHT-0469, İHT-0471, İHT-0479, İHT-0470 (kısmi), İHT-0481 (kısmi), İHT-0485 (kısmi) — **bağlandı (Kalfa)**. src/ses/hazir_ses_kaynaklari.gd mevcut Ses anahtarlarını hazır kayıtlara yönlendirir. Kapı/kese/sikke mevcut tetiklerde, adım gerçek yer değişiminde, örs mevcut dov çalışma duruşunda. Dere assets/ses/quendel/dere_dongu.ogg 8 sn/57.218 bayt; yumuşak çapraz birleşim, OGG loop=true; özgün WAV korunur. Atıf ve türev kaynak hash kayıtları eklendi. Import, hazir_ses_kontrol, koy_ortam_kontrol, zanaat_tezgahi_kontrol ve ses birim testi geçti; kullanıcı bus/susturma ve müzik anahtarları korundu.

## 28 Ekim — HAE-03 Eşya ve hayvan sahne bağlantıları (Kalfa)

İHT-0342, İHT-0350 (kısmi), İHT-0384, İHT-0388 (kısmi), İHT-0413, İHT-0414, İHT-0380, İHT-0403, İHT-0383 (kısmi) — **bağlandı (Kalfa)**. src/koy/gorsel/hazir_esya_hayvan.gd: örs/çekiç tezgâhta, balta oduncuda, kazma/odun mevcut ElEsyasi soketinde; masa/yatak MuhafizOdasi içinde. Sürüde statik koyun, satın alınmış inek, kapı yanında mevcut idle klipli köpek. Kaynak oranları ve y=0 taban denetlendi; gerçek render TEMP/kalfa_entegrasyon_20261028/ilk_gruplar.png. Vertexcat hayvanların yürüme/otlama klibi yok, köpek Kangal değil; öküz, koç/beygir kutuları ve tüm üretim/sayı/rota verisi korunur. Demir çubuğu yalnız dekor, İHT-0439 ham blok kapanmadı. Import, yeni hazır eşya-hayvan testi ve çoban/celep/zanaat/oduncu/hava/oda hedefli testleri geçti. Eski kutu beklentileri gerçek model bağlantısı kontrolüyle güncellendi.

## HAE-02 — önceki rig engeli çözüldü (28 Ekim, Kalfa)

Tarihsel engel kaydı; Ahmet yerel referans kullanımını onayladı, üstteki HAE-02 teslimi geçerlidir. Önceki durum: İHT-0357/0431/0444/0524 bağlanmamıştı. LOWPO iskeleti var; seçilmiş UAL kitaplıkları kaynak kemik hiyerarşisi/rest dönüşümü içermiyor (metadata boş). Önceki karşılaştırma betiği `assets/animasyon/_karsilastirma/karsilastirma.gd` kaynak iskeleti repoda olmayan TEMP GLB’den okuyor. Gerekli 3D veri: UAL A01/A02 referans Skeleton3D + bone rest/bind pose ve doğru kemik haritası, 1 birim=1 m; yeni görsel üretimi değil özgün kliplerin referansı. Mevcut çalışan karakter/hareketler korunur; çocuk eksikliği mevcut isimli yer tutucuda kalır.

## 28 Ekim — HAE-01 MegaKit köy yapıları (Kalfa)

İHT-0372, İHT-0397 — **bağlandı (Kalfa)**. Hazır kapalı yapı kabuğu src/koy/gorsel/hazir_koy_yapilari.gd ve yağmur saçağı karakter_hava_tepkisi.gd üzerinden bağlandı. Konut 3×3×3 m, diğer kabuk mevcut ızgarada; özgül endüstri içi, tarla, ağıl, iskele ve eski çalışan modeller korunur. Import kurtarma kipinde temiz; hazir_koy_yapilari_kontrol ve koy_hareket_kontrol geçti. İlk importta Cursor karşılaştırma önizlemesinin look_at hatası vardı; kaynak değiştirilmeden editor araçları kapatılarak import ve normal runtime testiyle ayrıştırıldı.

## 24 Ekim 2026 — A03 animasyon teslimi (Kalfa)

A03 ücretsiz CC0 katmanından **6 kitaplık / 9 klip eklendi**; 8 ihtiyaç **kısmi/uyarlama**, tam kapanış 0. Retarget deneyinde Idle_A 19/21 iz eşleşti; poz ve bütün karakterlerde görsel kabul açık. Mevcut hareketler değiştirilmedi. [Dosya/ID ve kabul kaydı](asset_envanteri/UCRETSIZ_ASSET_EKLEME_2026-10-24.md).

- İHT-0444, İHT-0456 — **eklendi, uyarlama (Kalfa)**; A03; `assets/animasyon/kaykit/general.res`; aktif oyun kabulü bekliyor.
- İHT-0450, İHT-0524 — **eklendi, uyarlama (Kalfa)**; A03; `assets/animasyon/kaykit/movement_basic.res`; aktif oyun kabulü bekliyor.
- İHT-0399 — **eklendi, kısmi (Kalfa)**; A03; `assets/animasyon/kaykit/movement_advanced.res`; aktif oyun kabulü bekliyor.
- İHT-0453 — **eklendi, uyarlama (Kalfa)**; A03; `assets/animasyon/kaykit/tools.res`; aktif oyun kabulü bekliyor.
- İHT-0455 — **eklendi, uyarlama (Kalfa)**; A03; `assets/animasyon/kaykit/combat_melee.res`; yedek, ana kaynak A01; aktif oyun kabulü bekliyor.
- İHT-0451 — **eklendi, kısmi (Kalfa)**; A03; `assets/animasyon/kaykit/simulation.res`; yedek, ana kaynak A01; aktif oyun kabulü bekliyor.
- İHT-0444, İHT-0456 — **eklendi — uyarlama (Cursor)**; A01 ana kaynak; `assets/animasyon/quaternius/general.res`; chr_001 görüntüsünde KayKit’ten iyi, oyuna bağlanmadı.
- İHT-0450, İHT-0524 — **eklendi — uyarlama (Cursor)**; A01; `assets/animasyon/quaternius/movement.res`; oyuna bağlanmadı.
- İHT-0399 — **eklendi — kısmi (Cursor)**; A01; `assets/animasyon/quaternius/movement.res` çömelme; kuytu bekleme açık.
- İHT-0451 — **eklendi — kısmi (Cursor)**; A01; `assets/animasyon/quaternius/simulation.res`; otur, kalk ve oturma var, oyuna bağlanmadı.
- İHT-0455 — **eklendi — uyarlama (Cursor)**; A01 `combat.res` ve A02 `ual2_kilic.res`; kılıç, oyuna bağlanmadı.
- İHT-0452 — **eklendi — uyarlama (Cursor)**; A02; `assets/animasyon/quaternius/ual2_tarim.res`; orak yok, hasat/tohum/sulama.
- İHT-0372 — **eklendi — kısmi (Cursor)**; E02; `assets/cevre/megakit/` duvar, çatı, kapı, pencere, döşeme; sahneye bağlanmadı.
- İHT-0397 — **eklendi — kısmi (Cursor)**; E02; `assets/cevre/megakit/Overhang_Plaster_Short.gltf`; eve takılmadı.
- İHT-0431 — **eklendi — uyarlama (Cursor)**; KAR02; `assets/karakter/lowpo/demirci.gltf`; 1,80 m, T-pozu, oyuna bağlanmadı.
- İHT-0357 — **eklendi — uyarlama (Cursor)**; KAR02; `assets/karakter/lowpo/cocuk.gltf`; 1,27 m, hedef 1,15 m, oyuna bağlanmadı.
- İHT-0342 — **eklendi — uyarlama (Cursor)**; ESY01; `assets/esya/kaykit_alet/hammer.gltf`; 0,82 m, hedef 0,35 m, bağlanmadı.
- İHT-0384 — **eklendi — uyarlama (Cursor)**; ESY01; `assets/esya/kaykit_alet/anvil.gltf`; 1,62 × 0,80 × 0,75 m, kütük yok, bağlanmadı.
- İHT-0388 — **eklendi — kısmi (Cursor)**; ESY01; balta, örs ve çekiç var; kova, orak ve fırın küreği yok.
- İHT-0395 — **eklendi — kısmi (Cursor)**; ESY01; örs var, fırın ağzı yok.
- İHT-0400 — **eklendi — kısmi (Cursor)**; ESY01; çekiç var, fırın küreği yok, tutma noktası ayrı değil.
- İHT-0430 — **eklendi — kısmi (Cursor)**; ESY01 ve ESY04; el aletleri, kılıç, kalkan ve mızrak var, ölçü büyük, bağlanmadı.
- İHT-0387 — **eklendi — uyarlama (Cursor)**; ESY04 ve ESY01; kılıç, kalkan, mızrak ve meşale var, soket yok, ölçü büyük.
- İHT-0406 — **eklendi — uyarlama (Cursor)**; ESY04; `bow_A_withString.gltf`; uzun eksen X, 1,96 m, hedef 1,10 m, döndürülmedi.
- İHT-0407 — **eklendi — uyarlama (Cursor)**; ESY04; `spear_A.gltf`; 3,14 m, hedef 2,00 m.
- İHT-0413 — **eklendi — uyarlama (Cursor)**; ESY02; `bed_single_A.gltf`; 1,60 × 1,00 × 3,00 m, mavi örtü, bağlanmadı.
- İHT-0414 — **eklendi — uyarlama (Cursor)**; ESY02; `table_medium.gltf`; 2,00 × 1,00 × 2,00 m, bağlanmadı.
- İHT-0350 — **eklendi — kısmi (Cursor)**; ESY03; `Wood_Log_A.gltf`; tek odun, hedef iki küçük odun.
- İHT-0439 — **eklendi — uyarlama (Cursor)**; ESY03; `Iron_Bar.gltf`; 0,40 × 0,25 × 0,80 m çubuk, hedef 0,30 m küp.
- İHT-0380 — **eklendi — uyarlama (Cursor)**; HYV03; `assets/hayvan/vertexcat/koyun.gltf`; 0,89 m, hedef 0,80 m, bağlanmadı.
- İHT-0403 — **eklendi — uyarlama (Cursor)**; HYV03; `assets/hayvan/vertexcat/inek.gltf`; 1,59 × 2,20 m, hedef 1,45 × 2,20 m, bağlanmadı.
- İHT-0383 — **eklendi — uyarlama (Cursor)**; HYV02; `assets/hayvan/styloo/kopek.glb`; 0,71 m, hedef 0,80 m, bağlanmadı.
- İHT-0468 — **eklendi — uyarlama (Cursor)**; S01 ve S05; kapı açma, gıcırtı ve kilit, ağır kapı kanıtı yok, bağlanmadı.
- İHT-0469 — **eklendi — uyarlama (Cursor)**; S01 `wood_slam_01.ogg` 0,38 sn ve S05 kapı kapanışı; hedef 0,8–1,2 sn.
- İHT-0471 — **eklendi — uyarlama (Cursor)**; FOL11 toprak, ot ve çakıl; kodla sentez, çarık kaydı değil.
- İHT-0472 — **eklendi — kısmi (Cursor)**; UIS03 `tahta_tik_01.ogg`; tahta ama 1,29 sn, hedef yaklaşık 0,06 sn.
- İHT-0473 — **eklendi — kısmi (Cursor)**; UIS03 `tahta_tik_02.ogg`; alçak kısa onay değil, 1,29 sn.
- İHT-0475 — **eklendi — uyarlama (Cursor)**; S04 kılıç kını 0,54 sn ve FOL14 kılıç çekme 2,34 sn.
- İHT-0478 — **eklendi — kısmi (Cursor)**; S04 zincir zırh ve FOL14 bıçak sürtmesi; zincir sürtünmesinin tamamı değil.
- İHT-0479 — **eklendi — uyarlama (Cursor)**; S04 iki sikke ve S05 sikke tutuşu.
- İHT-0470 — **eklendi — kısmi (Cursor)**; S05 `handleCoins.ogg`; deri kese yok.
- İHT-0481 — **eklendi — kısmi (Cursor)**; ORT14 `dere_01.wav` 41 sn; çekiç ve koyun yok.
- İHT-0485 — **eklendi — kısmi (Cursor)**; S01 çekiç, S05 keser, FOL14 örs; tek inşaat döngüsü değil.
- İHT-0492 — **eklendi — uyarlama (Cursor)**; FOL14 `bow_release_01.ogg`.
- İHT-0499 — **eklendi — uyarlama (Cursor)**; S01 `wood_cracking_01.ogg`.
- İHT-0500 — **eklendi — uyarlama (Cursor)**; S01 `wood_breaking_01.ogg`.
- İHT-0515 — **eklendi — uyarlama (Cursor)**; FOL14 `war_horn_01.ogg`.
- İHT-0516 — **eklendi — kısmi (Cursor)**; MIR04 nefes, iç çekiş ve homurtu; İngilizce konuşma yok.
- İHT-0157 — **eklendi — uyarlama (Cursor)**; VFX14 `assets/vfx/kenney/smoke_01.png`; 512², hedef 256², sahneye bağlanmadı.
- İHT-0150 — **eklendi — uyarlama (Cursor)**; VFX14 alev ve VFX04 `ates_01.png`; köy meşalesi ikonu değil.
- İHT-0154 — **eklendi — uyarlama (Cursor)**; VFX14 `trace_01.png`; tek dikey çizgi, yağmur perdesi değil.
- İHT-0151 — **eklendi — uyarlama (Cursor)**; VFX14 `isik_01.png`; yumuşak ışık lekesi.

12 Ekim 2026 (Kalfa). **Aktif görsel ihtiyaçları 2D ve 3D olarak ayrılmıştır.** Mekanikler asset beklemez: isim etiketli kutu / ColorRect / BoxMesh yer tutucuyla tamamlanır. Assetler üretim tamamlandıktan sonra ayrı entegrasyon paketinde eklenir; hazır prompt, teslim veya oyun kabulü değildir.

## Yeni ihtiyaç ekleme kuralı

- Önce mevcut ihtiyacı kullan; aynı model/portre için tekrar kuyruk açma. ROADMAP kodu, yer tutucu `res://` yolu, öncelik ve ekleyen ajan kaydı korunur.
- **2D:** aşağıdaki 2D bölümüne dosya adı, nihai piksel ölçüsü, saydamlık ve tek resimlik İngilizce Nano Banana promptunu aynı commit'te ekle. Ortak gece_kapisi stilini kullan; saydam kaynakta düz **#00FF00** zemin, `no text`. Gerçek alfa sonradan temizlenir; modelden saydamlık beklenmez. Prompt metni aşağıdaki bağlantılı katalogda tutulur; yeni kayıtla katalog da güncellenir.
- **3D:** 3D bölümüne kısa tanım ve metreyle ölçü yaz. Ölçü sırası genişlik × yükseklik × derinlik; 1 Godot birimi = 1 metre. Animasyon mevcut rig ölçeğini korur. Buradaki ölçüler üretim hedefi / başlangıç zarfıdır; ölçülmüş mevcut model boyutu değildir. Yapı, hayvan ve prop sahnede sonradan doğrulanır.
- Yeni mekanik kapanırken envanter ve prompt birlikte güncellenir; ihtiyaç yoksa `asset gerekmedi` yazılır. Asset eksikliği ROADMAP maddesini bekletmez.
- Önceki kaynak taraması, arama sözcükleri, öncelikler, yollar ve ajan imzaları [kaynak kaydında](asset_envanteri/2026-10-12-kaynak-taramasi.md) korunur. Bu belge aktif kuyruktur; kaynak kaydına yeni ihtiyaç eklenmez. En alttaki H tablosu ARY-05 kimlik izleme kaydıdır, ikinci üretim kuyruğu değildir.

## 2D assetler — prompt hazır, Ahmet üretecek

**281 envanter parçası + 57 mevcut UI yuvası.** Aynı ihtiyacın değişik boyutları ayrı dosyadır; kaynak kimliği birden çok parçaya bağlanabilir. YAP06'nın henüz tanımlanmamış sekiz eşya türü ortak ikonla özgül olarak tamamlanmış sayılmaz. Karışık doku/model ihtiyaçlarının dokusu burada, geometrisi 3D bölümündedir.

Üretim için [311 satırlık sıradaki liste](arayuz/GEMINI_SIRADAKI_URETIM_LISTESI.md): 5 yeniden üretim + 25 teslim edilmemiş UI + 281 envanter resmi. Alfa hazırlığı biten 27 PNG üretim beklerken saklanır; tekrar üretilmez ve henüz oyun entegrasyonu kabulü sayılmaz. [Kabul kanıtı](arayuz/GECE_KAPISI_ALFA_KABUL.md).

ACL-04 uygulama notu (14 Ekim, Kalfa): `ACL04-ARASAHNE` için aşağıdaki mevcut 1920×1080 opak `assets/art/env/acilis_ulak.png` promptu kullanılır. Yer tutucu `res://src/arayuz/koy_hud/kapi_acilis_paneli.gd`: koyu ColorRect + «Ulak / ilk aile» isim etiketi. Öncelik yüksek; görsel gelene kadar açılış mekaniği çalışır. Yeni 3D gerekmiyor; ilk aile mevcut yetişkin modelini kullanır, genel çocuk/aile modelleri KAP-17 kuyruğunda kalır.

### Envanterin tekli 2D parçaları

Her satırdaki prompt bağlantısı tam İngilizce metin, kaynak konu ve notları açar. Satırların çoğu hâlâ **prompt hazır, Ahmet üretecek**. 3 Kasım 2026’da bulunan açık lisanslı parçalar satırda **kapatıldı** veya **kısmi** diye işaretlidir; ayrıntı dosyanın başındaki kapanış kaydındadır. ROADMAP / yer tutucu / öncelik / ekleyen bilgisi kaynak kimliğiyle tarihsel taramadan izlenir.

| Kaynak ID | Nihai dosya | Boyut (px) | Saydamlık / kaynak zemin | Hazır prompt |
|---|---|---|---|---|
| `UI-KARAR-KABUL` | `assets/art/ui/icon_decision_accept_48.png` | 48×48 | RGBA; düz #00FF00 | [Prompt 001](arayuz/UI_ASSET_PROMPTLARI_2.md#001--assetsartuiicon_decision_accept_48png) |
| `UI-KARAR-RET` | `assets/art/ui/icon_decision_reject_48.png` | 48×48 | RGBA; düz #00FF00 | [Prompt 002](arayuz/UI_ASSET_PROMPTLARI_2.md#002--assetsartuiicon_decision_reject_48png) |
| `UI-KARAR-RUSVET` | `assets/art/ui/icon_decision_bribe_48.png` | 48×48 | RGBA; düz #00FF00 | [Prompt 003](arayuz/UI_ASSET_PROMPTLARI_2.md#003--assetsartuiicon_decision_bribe_48png) |
| `UI-KARAR-KISLA` | `assets/art/ui/icon_decision_barracks_48.png` | 48×48 | RGBA; düz #00FF00 | [Prompt 004](arayuz/UI_ASSET_PROMPTLARI_2.md#004--assetsartuiicon_decision_barracks_48png) |
| `UI-KESE-DOLU` | `assets/art/ui/icon_bribe_pouch_full_48.png` | 48×48 | RGBA; düz #00FF00 | [Prompt 005](arayuz/UI_ASSET_PROMPTLARI_2.md#005--assetsartuiicon_bribe_pouch_full_48png) |
| `IKN-KESE-BOS` | `assets/art/ui/icon_bribe_pouch_empty_48.png` | 48×48 | RGBA; düz #00FF00 | [Prompt 006](arayuz/UI_ASSET_PROMPTLARI_2.md#006--assetsartuiicon_bribe_pouch_empty_48png) |
| `UI-IMLEC` | `assets/art/ui/ui_cursor_arrow_32.png` | 32×32 | RGBA; düz #00FF00 | [Prompt 007](arayuz/UI_ASSET_PROMPTLARI_2.md#007--assetsartuiui_cursor_arrow_32png) |
| `UI-IMLEC` | `assets/art/ui/ui_cursor_hand_32.png` | 32×32 | RGBA; düz #00FF00 | [Prompt 008](arayuz/UI_ASSET_PROMPTLARI_2.md#008--assetsartuiui_cursor_hand_32png) |
| `ENV-MENU` | `assets/art/env/env_menu_bg.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 009](arayuz/UI_ASSET_PROMPTLARI_2.md#009--assetsartenvenv_menu_bgpng) |
| `ENV-KAPI` | `assets/art/env/env_gate_scene_bg.png` | 1140×1000 | Opak RGB; tam sahne/doku | [Prompt 010](arayuz/UI_ASSET_PROMPTLARI_2.md#010--assetsartenvenv_gate_scene_bgpng) |
| `ENV-KOY-2D` | `assets/art/env/env_village_bg.png` | 1920×1000 | Opak RGB; tam sahne/doku | [Prompt 011](arayuz/UI_ASSET_PROMPTLARI_2.md#011--assetsartenvenv_village_bgpng) |
| `PORTRE-ADLI-6` | `assets/art/char/char_miraen_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 012](arayuz/UI_ASSET_PROMPTLARI_2.md#012--assetsartcharchar_miraen_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_miraen_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 013](arayuz/UI_ASSET_PROMPTLARI_2.md#013--assetsartcharchar_miraen_idle_villagepng) |
| `PORTRE-ADLI-6` | `assets/art/char/char_sorhan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 014](arayuz/UI_ASSET_PROMPTLARI_2.md#014--assetsartcharchar_sorhan_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_sorhan_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 015](arayuz/UI_ASSET_PROMPTLARI_2.md#015--assetsartcharchar_sorhan_idle_villagepng) |
| `PORTRE-ADLI-6` | `assets/art/char/char_thessra_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 016](arayuz/UI_ASSET_PROMPTLARI_2.md#016--assetsartcharchar_thessra_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_thessra_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 017](arayuz/UI_ASSET_PROMPTLARI_2.md#017--assetsartcharchar_thessra_idle_villagepng) |
| `PORTRE-ADLI-6` | `assets/art/char/char_karaca_usta_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 018](arayuz/UI_ASSET_PROMPTLARI_2.md#018--assetsartcharchar_karaca_usta_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_karaca_usta_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 019](arayuz/UI_ASSET_PROMPTLARI_2.md#019--assetsartcharchar_karaca_usta_idle_villagepng) |
| `PORTRE-ADLI-6` | `assets/art/char/char_aydogdu_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 020](arayuz/UI_ASSET_PROMPTLARI_2.md#020--assetsartcharchar_aydogdu_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_aydogdu_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 021](arayuz/UI_ASSET_PROMPTLARI_2.md#021--assetsartcharchar_aydogdu_idle_villagepng) |
| `PORTRE-ADLI-6` | `assets/art/char/char_saruca_hatun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 022](arayuz/UI_ASSET_PROMPTLARI_2.md#022--assetsartcharchar_saruca_hatun_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_saruca_hatun_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 023](arayuz/UI_ASSET_PROMPTLARI_2.md#023--assetsartcharchar_saruca_hatun_idle_villagepng) |
| `PORTRE-SINIF-4` | `assets/art/char/char_soldier_01_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 024](arayuz/UI_ASSET_PROMPTLARI_2.md#024--assetsartcharchar_soldier_01_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_soldier_01_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 025](arayuz/UI_ASSET_PROMPTLARI_2.md#025--assetsartcharchar_soldier_01_idle_villagepng) |
| `PORTRE-SINIF-4` | `assets/art/char/char_farmer_01_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 026](arayuz/UI_ASSET_PROMPTLARI_2.md#026--assetsartcharchar_farmer_01_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_farmer_01_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 027](arayuz/UI_ASSET_PROMPTLARI_2.md#027--assetsartcharchar_farmer_01_idle_villagepng) |
| `PORTRE-SINIF-4` | `assets/art/char/char_farmer_02_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 028](arayuz/UI_ASSET_PROMPTLARI_2.md#028--assetsartcharchar_farmer_02_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_farmer_02_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 029](arayuz/UI_ASSET_PROMPTLARI_2.md#029--assetsartcharchar_farmer_02_idle_villagepng) |
| `PORTRE-SINIF-4` | `assets/art/char/char_craftsman_01_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 030](arayuz/UI_ASSET_PROMPTLARI_2.md#030--assetsartcharchar_craftsman_01_neutral_cardpng) |
| `KOY-FIGUR-2D` | `assets/art/char/char_craftsman_01_idle_village.png` | 56×120 | RGBA; düz #00FF00 | [Prompt 031](arayuz/UI_ASSET_PROMPTLARI_2.md#031--assetsartcharchar_craftsman_01_idle_villagepng) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_001_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 032](arayuz/UI_ASSET_PROMPTLARI_2.md#032--assetsartcharchar_chr_001_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_001_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 033](arayuz/UI_ASSET_PROMPTLARI_2.md#033--assetsarticonsicon_clue_chr_001_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_001_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 034](arayuz/UI_ASSET_PROMPTLARI_2.md#034--assetsarticonsicon_clue_chr_001_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_002_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 035](arayuz/UI_ASSET_PROMPTLARI_2.md#035--assetsartcharchar_chr_002_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_002_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 036](arayuz/UI_ASSET_PROMPTLARI_2.md#036--assetsarticonsicon_clue_chr_002_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_002_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 037](arayuz/UI_ASSET_PROMPTLARI_2.md#037--assetsarticonsicon_clue_chr_002_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_003_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 038](arayuz/UI_ASSET_PROMPTLARI_2.md#038--assetsartcharchar_chr_003_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_003_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 039](arayuz/UI_ASSET_PROMPTLARI_2.md#039--assetsarticonsicon_clue_chr_003_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_003_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 040](arayuz/UI_ASSET_PROMPTLARI_2.md#040--assetsarticonsicon_clue_chr_003_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_004_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 041](arayuz/UI_ASSET_PROMPTLARI_2.md#041--assetsartcharchar_chr_004_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_004_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 042](arayuz/UI_ASSET_PROMPTLARI_2.md#042--assetsarticonsicon_clue_chr_004_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_004_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 043](arayuz/UI_ASSET_PROMPTLARI_2.md#043--assetsarticonsicon_clue_chr_004_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_005_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 044](arayuz/UI_ASSET_PROMPTLARI_2.md#044--assetsartcharchar_chr_005_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_005_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 045](arayuz/UI_ASSET_PROMPTLARI_2.md#045--assetsarticonsicon_clue_chr_005_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_005_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 046](arayuz/UI_ASSET_PROMPTLARI_2.md#046--assetsarticonsicon_clue_chr_005_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_006_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 047](arayuz/UI_ASSET_PROMPTLARI_2.md#047--assetsartcharchar_chr_006_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_006_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 048](arayuz/UI_ASSET_PROMPTLARI_2.md#048--assetsarticonsicon_clue_chr_006_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_006_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 049](arayuz/UI_ASSET_PROMPTLARI_2.md#049--assetsarticonsicon_clue_chr_006_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_007_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 050](arayuz/UI_ASSET_PROMPTLARI_2.md#050--assetsartcharchar_chr_007_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_007_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 051](arayuz/UI_ASSET_PROMPTLARI_2.md#051--assetsarticonsicon_clue_chr_007_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_007_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 052](arayuz/UI_ASSET_PROMPTLARI_2.md#052--assetsarticonsicon_clue_chr_007_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_008_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 053](arayuz/UI_ASSET_PROMPTLARI_2.md#053--assetsartcharchar_chr_008_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_008_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 054](arayuz/UI_ASSET_PROMPTLARI_2.md#054--assetsarticonsicon_clue_chr_008_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_008_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 055](arayuz/UI_ASSET_PROMPTLARI_2.md#055--assetsarticonsicon_clue_chr_008_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_009_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 056](arayuz/UI_ASSET_PROMPTLARI_2.md#056--assetsartcharchar_chr_009_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_009_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 057](arayuz/UI_ASSET_PROMPTLARI_2.md#057--assetsarticonsicon_clue_chr_009_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_009_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 058](arayuz/UI_ASSET_PROMPTLARI_2.md#058--assetsarticonsicon_clue_chr_009_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_010_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 059](arayuz/UI_ASSET_PROMPTLARI_2.md#059--assetsartcharchar_chr_010_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_010_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 060](arayuz/UI_ASSET_PROMPTLARI_2.md#060--assetsarticonsicon_clue_chr_010_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_010_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 061](arayuz/UI_ASSET_PROMPTLARI_2.md#061--assetsarticonsicon_clue_chr_010_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_011_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 062](arayuz/UI_ASSET_PROMPTLARI_2.md#062--assetsartcharchar_chr_011_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_011_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 063](arayuz/UI_ASSET_PROMPTLARI_2.md#063--assetsarticonsicon_clue_chr_011_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_011_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 064](arayuz/UI_ASSET_PROMPTLARI_2.md#064--assetsarticonsicon_clue_chr_011_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_012_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 065](arayuz/UI_ASSET_PROMPTLARI_2.md#065--assetsartcharchar_chr_012_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_012_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 066](arayuz/UI_ASSET_PROMPTLARI_2.md#066--assetsarticonsicon_clue_chr_012_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_012_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 067](arayuz/UI_ASSET_PROMPTLARI_2.md#067--assetsarticonsicon_clue_chr_012_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_013_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 068](arayuz/UI_ASSET_PROMPTLARI_2.md#068--assetsartcharchar_chr_013_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_013_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 069](arayuz/UI_ASSET_PROMPTLARI_2.md#069--assetsarticonsicon_clue_chr_013_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_013_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 070](arayuz/UI_ASSET_PROMPTLARI_2.md#070--assetsarticonsicon_clue_chr_013_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_014_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 071](arayuz/UI_ASSET_PROMPTLARI_2.md#071--assetsartcharchar_chr_014_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_014_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 072](arayuz/UI_ASSET_PROMPTLARI_2.md#072--assetsarticonsicon_clue_chr_014_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_014_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 073](arayuz/UI_ASSET_PROMPTLARI_2.md#073--assetsarticonsicon_clue_chr_014_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_015_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 074](arayuz/UI_ASSET_PROMPTLARI_2.md#074--assetsartcharchar_chr_015_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_015_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 075](arayuz/UI_ASSET_PROMPTLARI_2.md#075--assetsarticonsicon_clue_chr_015_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_015_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 076](arayuz/UI_ASSET_PROMPTLARI_2.md#076--assetsarticonsicon_clue_chr_015_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_016_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 077](arayuz/UI_ASSET_PROMPTLARI_2.md#077--assetsartcharchar_chr_016_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_016_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 078](arayuz/UI_ASSET_PROMPTLARI_2.md#078--assetsarticonsicon_clue_chr_016_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_016_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 079](arayuz/UI_ASSET_PROMPTLARI_2.md#079--assetsarticonsicon_clue_chr_016_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_017_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 080](arayuz/UI_ASSET_PROMPTLARI_2.md#080--assetsartcharchar_chr_017_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_017_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 081](arayuz/UI_ASSET_PROMPTLARI_2.md#081--assetsarticonsicon_clue_chr_017_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_017_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 082](arayuz/UI_ASSET_PROMPTLARI_2.md#082--assetsarticonsicon_clue_chr_017_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_018_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 083](arayuz/UI_ASSET_PROMPTLARI_2.md#083--assetsartcharchar_chr_018_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_018_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 084](arayuz/UI_ASSET_PROMPTLARI_2.md#084--assetsarticonsicon_clue_chr_018_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_018_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 085](arayuz/UI_ASSET_PROMPTLARI_2.md#085--assetsarticonsicon_clue_chr_018_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_019_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 086](arayuz/UI_ASSET_PROMPTLARI_2.md#086--assetsartcharchar_chr_019_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_019_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 087](arayuz/UI_ASSET_PROMPTLARI_2.md#087--assetsarticonsicon_clue_chr_019_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_019_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 088](arayuz/UI_ASSET_PROMPTLARI_2.md#088--assetsarticonsicon_clue_chr_019_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_020_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 089](arayuz/UI_ASSET_PROMPTLARI_2.md#089--assetsartcharchar_chr_020_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_020_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 090](arayuz/UI_ASSET_PROMPTLARI_2.md#090--assetsarticonsicon_clue_chr_020_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_020_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 091](arayuz/UI_ASSET_PROMPTLARI_2.md#091--assetsarticonsicon_clue_chr_020_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_021_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 092](arayuz/UI_ASSET_PROMPTLARI_2.md#092--assetsartcharchar_chr_021_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_021_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 093](arayuz/UI_ASSET_PROMPTLARI_2.md#093--assetsarticonsicon_clue_chr_021_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_021_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 094](arayuz/UI_ASSET_PROMPTLARI_2.md#094--assetsarticonsicon_clue_chr_021_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_022_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 095](arayuz/UI_ASSET_PROMPTLARI_2.md#095--assetsartcharchar_chr_022_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_022_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 096](arayuz/UI_ASSET_PROMPTLARI_2.md#096--assetsarticonsicon_clue_chr_022_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_022_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 097](arayuz/UI_ASSET_PROMPTLARI_2.md#097--assetsarticonsicon_clue_chr_022_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_023_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 098](arayuz/UI_ASSET_PROMPTLARI_2.md#098--assetsartcharchar_chr_023_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_023_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 099](arayuz/UI_ASSET_PROMPTLARI_2.md#099--assetsarticonsicon_clue_chr_023_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_023_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 100](arayuz/UI_ASSET_PROMPTLARI_2.md#100--assetsarticonsicon_clue_chr_023_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_024_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 101](arayuz/UI_ASSET_PROMPTLARI_2.md#101--assetsartcharchar_chr_024_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_024_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 102](arayuz/UI_ASSET_PROMPTLARI_2.md#102--assetsarticonsicon_clue_chr_024_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_024_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 103](arayuz/UI_ASSET_PROMPTLARI_2.md#103--assetsarticonsicon_clue_chr_024_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_025_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 104](arayuz/UI_ASSET_PROMPTLARI_2.md#104--assetsartcharchar_chr_025_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_025_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 105](arayuz/UI_ASSET_PROMPTLARI_2.md#105--assetsarticonsicon_clue_chr_025_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_025_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 106](arayuz/UI_ASSET_PROMPTLARI_2.md#106--assetsarticonsicon_clue_chr_025_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_026_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 107](arayuz/UI_ASSET_PROMPTLARI_2.md#107--assetsartcharchar_chr_026_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_026_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 108](arayuz/UI_ASSET_PROMPTLARI_2.md#108--assetsarticonsicon_clue_chr_026_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_026_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 109](arayuz/UI_ASSET_PROMPTLARI_2.md#109--assetsarticonsicon_clue_chr_026_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_027_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 110](arayuz/UI_ASSET_PROMPTLARI_2.md#110--assetsartcharchar_chr_027_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_027_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 111](arayuz/UI_ASSET_PROMPTLARI_2.md#111--assetsarticonsicon_clue_chr_027_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_027_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 112](arayuz/UI_ASSET_PROMPTLARI_2.md#112--assetsarticonsicon_clue_chr_027_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_028_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 113](arayuz/UI_ASSET_PROMPTLARI_2.md#113--assetsartcharchar_chr_028_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_028_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 114](arayuz/UI_ASSET_PROMPTLARI_2.md#114--assetsarticonsicon_clue_chr_028_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_028_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 115](arayuz/UI_ASSET_PROMPTLARI_2.md#115--assetsarticonsicon_clue_chr_028_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_029_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 116](arayuz/UI_ASSET_PROMPTLARI_2.md#116--assetsartcharchar_chr_029_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_029_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 117](arayuz/UI_ASSET_PROMPTLARI_2.md#117--assetsarticonsicon_clue_chr_029_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_029_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 118](arayuz/UI_ASSET_PROMPTLARI_2.md#118--assetsarticonsicon_clue_chr_029_obje2png) |
| `PORTRE-CHR-30` | `assets/art/char/char_chr_030_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt 119](arayuz/UI_ASSET_PROMPTLARI_2.md#119--assetsartcharchar_chr_030_neutral_cardpng) |
| `NISAN-30` | `assets/art/icons/icon_clue_chr_030_obje1.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 120](arayuz/UI_ASSET_PROMPTLARI_2.md#120--assetsarticonsicon_clue_chr_030_obje1png) |
| `YUK-30` | `assets/art/icons/icon_clue_chr_030_obje2.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 121](arayuz/UI_ASSET_PROMPTLARI_2.md#121--assetsarticonsicon_clue_chr_030_obje2png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_akce_64.png` — kapatıldı 3 Kasım 2026 (Cursor): sikke, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 122](arayuz/UI_ASSET_PROMPTLARI_2.md#122--assetsarticonsicon_esya_akce_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_arpa_64.png` — kapatıldı 3 Kasım 2026 (Cursor): buğday, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 123](arayuz/UI_ASSET_PROMPTLARI_2.md#123--assetsarticonsicon_esya_arpa_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_tohum_64.png` — kapatıldı 3 Kasım 2026 (Cursor): tahıl demeti, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 124](arayuz/UI_ASSET_PROMPTLARI_2.md#124--assetsarticonsicon_esya_tohum_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_ekmek_64.png` | 64×64 | RGBA; düz #00FF00 | [Prompt 125](arayuz/UI_ASSET_PROMPTLARI_2.md#125--assetsarticonsicon_esya_ekmek_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_tuz_64.png` | 64×64 | RGBA; düz #00FF00 | [Prompt 126](arayuz/UI_ASSET_PROMPTLARI_2.md#126--assetsarticonsicon_esya_tuz_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_kumas_64.png` — kapatıldı 3 Kasım 2026 (Cursor): kumaş topu, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 127](arayuz/UI_ASSET_PROMPTLARI_2.md#127--assetsarticonsicon_esya_kumas_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_bakir_64.png` — kısmi 3 Kasım 2026 (Cursor): metal çubuk, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 128](arayuz/UI_ASSET_PROMPTLARI_2.md#128--assetsarticonsicon_esya_bakir_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_ok_64.png` — kapatıldı 3 Kasım 2026 (Cursor): ok, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 129](arayuz/UI_ASSET_PROMPTLARI_2.md#129--assetsarticonsicon_esya_ok_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_hancer_64.png` — kapatıldı 3 Kasım 2026 (Cursor): hançer, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 130](arayuz/UI_ASSET_PROMPTLARI_2.md#130--assetsarticonsicon_esya_hancer_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_ilac_64.png` — kısmi 3 Kasım 2026 (Cursor): ot demeti, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 131](arayuz/UI_ASSET_PROMPTLARI_2.md#131--assetsarticonsicon_esya_ilac_64png) |
| `HEYBE-11` | `assets/art/icons/icon_esya_yuzuk_64.png` | 64×64 | RGBA; düz #00FF00 | [Prompt 132](arayuz/UI_ASSET_PROMPTLARI_2.md#132--assetsarticonsicon_esya_yuzuk_64png) |
| `IKN-KURK` | `assets/ui/koy/gece_kapisi/kurk.png` — kısmi 3 Kasım 2026 (Cursor): kürk çizme, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 133](arayuz/UI_ASSET_PROMPTLARI_2.md#133--assetsuikoygece_kapisikurkpng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/firin.png` — kısmi 3 Kasım 2026 (Cursor): fırın ikonu, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 134](arayuz/UI_ASSET_PROMPTLARI_2.md#134--assetsuikoygece_kapisifirinpng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/degirmen.png` — kapatıldı 3 Kasım 2026 (Cursor): yel değirmeni, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 135](arayuz/UI_ASSET_PROMPTLARI_2.md#135--assetsuikoygece_kapisidegirmenpng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/sifahane.png` — kısmi 3 Kasım 2026 (Cursor): ot demeti, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 136](arayuz/UI_ASSET_PROMPTLARI_2.md#136--assetsuikoygece_kapisisifahanepng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/ahir.png` — kısmi 3 Kasım 2026 (Cursor): ahır kapısı, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 137](arayuz/UI_ASSET_PROMPTLARI_2.md#137--assetsuikoygece_kapisiahirpng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/agil.png` — kapatıldı 3 Kasım 2026 (Cursor): koyun, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 138](arayuz/UI_ASSET_PROMPTLARI_2.md#138--assetsuikoygece_kapisiagilpng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/demirhane.png` — kapatıldı 3 Kasım 2026 (Cursor): örs, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 139](arayuz/UI_ASSET_PROMPTLARI_2.md#139--assetsuikoygece_kapisidemirhanepng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/kislasi.png` — kapatıldı 3 Kasım 2026 (Cursor): hisar, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 140](arayuz/UI_ASSET_PROMPTLARI_2.md#140--assetsuikoygece_kapisikislasipng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/maden.png` — kapatıldı 3 Kasım 2026 (Cursor): maden arabası, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 141](arayuz/UI_ASSET_PROMPTLARI_2.md#141--assetsuikoygece_kapisimadenpng) |
| `IKN-YAPI` | `assets/ui/koy/gece_kapisi/ocak.png` — kısmi 3 Kasım 2026 (Cursor): ateş ikonu, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 142](arayuz/UI_ASSET_PROMPTLARI_2.md#142--assetsuikoygece_kapisiocakpng) |
| `IKN-UYARI` | `assets/arayuz/ikonlar/uyari_isci_yok.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 143](arayuz/UI_ASSET_PROMPTLARI_2.md#143--assetsarayuzikonlaruyari_isci_yokpng) |
| `IKN-UYARI` | `assets/arayuz/ikonlar/uyari_hammadde_yok.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 144](arayuz/UI_ASSET_PROMPTLARI_2.md#144--assetsarayuzikonlaruyari_hammadde_yokpng) |
| `IKN-UYARI` | `assets/arayuz/ikonlar/uyari_ambar_dolu.png` — kapatıldı 3 Kasım 2026 (Cursor): ambar, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 145](arayuz/UI_ASSET_PROMPTLARI_2.md#145--assetsarayuzikonlaruyari_ambar_dolupng) |
| `IKN-BAR` | `assets/art/ui/ui_bar_segment_full.png` | 22×30 | RGBA; düz #00FF00 | [Prompt 146](arayuz/UI_ASSET_PROMPTLARI_2.md#146--assetsartuiui_bar_segment_fullpng) |
| `IKN-BAR` | `assets/art/ui/ui_bar_segment_empty.png` | 22×30 | RGBA; düz #00FF00 | [Prompt 147](arayuz/UI_ASSET_PROMPTLARI_2.md#147--assetsartuiui_bar_segment_emptypng) |
| `IKN-BAR` | `assets/art/ui/ui_bar_segment_cracked_01.png` | 22×30 | RGBA; düz #00FF00 | [Prompt 148](arayuz/UI_ASSET_PROMPTLARI_2.md#148--assetsartuiui_bar_segment_cracked_01png) |
| `IKN-BAR` | `assets/art/ui/ui_bar_segment_cracked_02.png` | 22×30 | RGBA; düz #00FF00 | [Prompt 149](arayuz/UI_ASSET_PROMPTLARI_2.md#149--assetsartuiui_bar_segment_cracked_02png) |
| `IKN-MESALE-2D` | `assets/art/fx/fx_torch_village_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 150](arayuz/UI_ASSET_PROMPTLARI_2.md#150--assetsartfxfx_torch_village_01png) |
| `IKN-MESALE-2D` | `assets/art/fx/fx_torchlight_patch_village_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 151](arayuz/UI_ASSET_PROMPTLARI_2.md#151--assetsartfxfx_torchlight_patch_village_01png) |
| `KAR-TEKFUR-ASKER` | `assets/art/char/crowd_tekfur_spear_01_far.png` | 420×80 | RGBA; düz #00FF00 | [Prompt 152](arayuz/UI_ASSET_PROMPTLARI_2.md#152--assetsartcharcrowd_tekfur_spear_01_farpng) |
| `VFX-KAR`, `MEV04-KAR` | `assets/art/fx/fx_snow_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 153](arayuz/UI_ASSET_PROMPTLARI_2.md#153--assetsartfxfx_snow_01png) |
| `VFX-YAGMUR` | `assets/art/fx/fx_rain_streak_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 154](arayuz/UI_ASSET_PROMPTLARI_2.md#154--assetsartfxfx_rain_streak_01png) |
| `VFX-KIVILCIM`, `ANI15-KIVILCIM` | `assets/art/fx/fx_spark_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 155](arayuz/UI_ASSET_PROMPTLARI_2.md#155--assetsartfxfx_spark_01png) |
| `VFX-SIS` | `assets/art/fx/fx_fog_noise.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 156](arayuz/UI_ASSET_PROMPTLARI_2.md#156--assetsartfxfx_fog_noisepng) |
| `ANI15-DUMAN` | `assets/art/fx/fx_smoke_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 157](arayuz/UI_ASSET_PROMPTLARI_2.md#157--assetsartfxfx_smoke_01png) |
| `ANI15-SU` | `assets/art/fx/fx_water_drop_01.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 158](arayuz/UI_ASSET_PROMPTLARI_2.md#158--assetsartfxfx_water_drop_01png) |
| `LOGO` | `assets/art/ui/logo_kapi_muhafizi.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 159](arayuz/UI_ASSET_PROMPTLARI_2.md#159--assetsartuilogo_kapi_muhafizipng) |
| `LOGO`, `SRM18-IKON` | `assets/ui/atmosfer/gece_kapisi/app_icon.png` | 1024×1024 | RGBA; düz #00FF00 | [Prompt 160](arayuz/UI_ASSET_PROMPTLARI_2.md#160--assetsuiatmosfergece_kapisiapp_iconpng) |
| `PALET` | `assets/palette/palette_swatch.png` | 1024×192 | Opak RGB; tam sahne/doku | [Prompt 161](arayuz/UI_ASSET_PROMPTLARI_2.md#161--assetspalettepalette_swatchpng) |
| `TUC-UI` | `assets/art/icons/icon_trade_contract.png` — kapatıldı 3 Kasım 2026 (Cursor): tomar, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 162](arayuz/UI_ASSET_PROMPTLARI_2.md#162--assetsarticonsicon_trade_contractpng) |
| `TUC-UI` | `assets/art/icons/icon_trade_price.png` — kapatıldı 3 Kasım 2026 (Cursor): sikke, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 163](arayuz/UI_ASSET_PROMPTLARI_2.md#163--assetsarticonsicon_trade_pricepng) |
| `TUC-UI` | `assets/art/icons/icon_trade_caravan.png` — kapatıldı 3 Kasım 2026 (Cursor): deve, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 164](arayuz/UI_ASSET_PROMPTLARI_2.md#164--assetsarticonsicon_trade_caravanpng) |
| `MEV-HUD` | `assets/ui/koy/gece_kapisi/mevsim_ilkbahar.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 165](arayuz/UI_ASSET_PROMPTLARI_2.md#165--assetsuikoygece_kapisimevsim_ilkbaharpng) |
| `MEV-HUD` | `assets/ui/koy/gece_kapisi/mevsim_yaz.png` — kapatıldı 3 Kasım 2026 (Cursor): güneş, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 166](arayuz/UI_ASSET_PROMPTLARI_2.md#166--assetsuikoygece_kapisimevsim_yazpng) |
| `MEV-HUD` | `assets/ui/koy/gece_kapisi/mevsim_sonbahar.png` — kapatıldı 3 Kasım 2026 (Cursor): meşe yaprağı, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 167](arayuz/UI_ASSET_PROMPTLARI_2.md#167--assetsuikoygece_kapisimevsim_sonbaharpng) |
| `MEV-HUD` | `assets/ui/koy/gece_kapisi/mevsim_kis.png` — kapatıldı 3 Kasım 2026 (Cursor): kar tanesi, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 168](arayuz/UI_ASSET_PROMPTLARI_2.md#168--assetsuikoygece_kapisimevsim_kispng) |
| `CAS-DIVAN` | `assets/art/ui/divan_kart.png` | 768×1024 | RGBA; düz #00FF00 | [Prompt 169](arayuz/UI_ASSET_PROMPTLARI_2.md#169--assetsartuidivan_kartpng) |
| `ODA-UI` | `assets/art/icons/icon_oda_terazi.png` — kapatıldı 3 Kasım 2026 (Cursor): terazi, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 170](arayuz/UI_ASSET_PROMPTLARI_2.md#170--assetsarticonsicon_oda_terazipng) |
| `ODA-UI` | `assets/art/icons/icon_oda_yetenek.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 171](arayuz/UI_ASSET_PROMPTLARI_2.md#171--assetsarticonsicon_oda_yetenekpng) |
| `ODA-UI` | `assets/art/icons/icon_oda_yozlasma.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 172](arayuz/UI_ASSET_PROMPTLARI_2.md#172--assetsarticonsicon_oda_yozlasmapng) |
| `ODA-UI` | `assets/art/env/oda_epilog.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 173](arayuz/UI_ASSET_PROMPTLARI_2.md#173--assetsartenvoda_epilogpng) |
| `HAR-HARITA`, `HAR01-HARITA`, `ARY03-HARITA` | `assets/art/env/harita_uc.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 174](arayuz/UI_ASSET_PROMPTLARI_2.md#174--assetsartenvharita_ucpng) |
| `HAR01-HARITA` | `assets/art/icons/icon_map_hisar.png` — kapatıldı 3 Kasım 2026 (Cursor): hisar, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 175](arayuz/UI_ASSET_PROMPTLARI_2.md#175--assetsarticonsicon_map_hisarpng) |
| `HAR01-HARITA` | `assets/art/icons/icon_map_yol.png` — kapatıldı 3 Kasım 2026 (Cursor): yol, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 176](arayuz/UI_ASSET_PROMPTLARI_2.md#176--assetsarticonsicon_map_yolpng) |
| `HAR01-HARITA` | `assets/art/icons/icon_map_tekfur.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 177](arayuz/UI_ASSET_PROMPTLARI_2.md#177--assetsarticonsicon_map_tekfurpng) |
| `HAR01-HARITA` | `assets/art/icons/icon_map_goc.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 178](arayuz/UI_ASSET_PROMPTLARI_2.md#178--assetsarticonsicon_map_gocpng) |
| `HAR-SAVAS` | `assets/art/icons/icon_savunma_okcu_64.png` — kapatıldı 3 Kasım 2026 (Cursor): okçu, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 179](arayuz/UI_ASSET_PROMPTLARI_2.md#179--assetsarticonsicon_savunma_okcu_64png) |
| `HAR-SAVAS` | `assets/art/icons/icon_savunma_mizrakli_64.png` — kapatıldı 3 Kasım 2026 (Cursor): mızrak, CC-BY | 64×64 | RGBA; düz #00FF00 | [Prompt 180](arayuz/UI_ASSET_PROMPTLARI_2.md#180--assetsarticonsicon_savunma_mizrakli_64png) |
| `KRI-HASTA` | `assets/art/fx/portrait_symptom_ates.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 181](arayuz/UI_ASSET_PROMPTLARI_2.md#181--assetsartfxportrait_symptom_atespng) |
| `KRI-HASTA` | `assets/art/fx/portrait_symptom_irin.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 182](arayuz/UI_ASSET_PROMPTLARI_2.md#182--assetsartfxportrait_symptom_irinpng) |
| `KRI-HASTA` | `assets/art/fx/portrait_symptom_oksuruk.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 183](arayuz/UI_ASSET_PROMPTLARI_2.md#183--assetsartfxportrait_symptom_oksurukpng) |
| `SYS-SON` | `assets/art/env/son_tekfur_haraccisi.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 184](arayuz/UI_ASSET_PROMPTLARI_2.md#184--assetsartenvson_tekfur_haraccisipng) |
| `SYS-SON` | `assets/art/env/son_ertugrul_obasi.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 185](arayuz/UI_ASSET_PROMPTLARI_2.md#185--assetsartenvson_ertugrul_obasipng) |
| `SYS-SON` | `assets/art/env/son_beyin_uc_koyu.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 186](arayuz/UI_ASSET_PROMPTLARI_2.md#186--assetsartenvson_beyin_uc_koyupng) |
| `SYS-SON` | `assets/art/env/son_ahi_kasabasi.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 187](arayuz/UI_ASSET_PROMPTLARI_2.md#187--assetsartenvson_ahi_kasabasipng) |
| `SYS-SON` | `assets/art/env/son_uc_tutundu.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 188](arayuz/UI_ASSET_PROMPTLARI_2.md#188--assetsartenvson_uc_tutundupng) |
| `SYS-SON` | `assets/art/env/son_epilog.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 189](arayuz/UI_ASSET_PROMPTLARI_2.md#189--assetsartenvson_epilogpng) |
| `SYS-PROLOG` | `assets/art/env/prolog_01.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 190](arayuz/UI_ASSET_PROMPTLARI_2.md#190--assetsartenvprolog_01png) |
| `SYS-PROLOG` | `assets/art/env/prolog_02.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 191](arayuz/UI_ASSET_PROMPTLARI_2.md#191--assetsartenvprolog_02png) |
| `SYS-PROLOG` | `assets/art/env/prolog_03.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 192](arayuz/UI_ASSET_PROMPTLARI_2.md#192--assetsartenvprolog_03png) |
| `SYS-PROLOG` | `assets/art/env/prolog_04.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 193](arayuz/UI_ASSET_PROMPTLARI_2.md#193--assetsartenvprolog_04png) |
| `MEV-ZEMIN` | `assets/art/textures/gece_kapisi/snow_ground_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 194](arayuz/UI_ASSET_PROMPTLARI_2.md#194--assetsarttexturesgece_kapisisnow_ground_albedopng) |
| `MEV-ZEMIN` | `assets/art/textures/gece_kapisi/snow_roof_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 195](arayuz/UI_ASSET_PROMPTLARI_2.md#195--assetsarttexturesgece_kapisisnow_roof_albedopng) |
| `MEV-AFET` | `assets/art/textures/gece_kapisi/flood_water_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 196](arayuz/UI_ASSET_PROMPTLARI_2.md#196--assetsarttexturesgece_kapisiflood_water_albedopng) |
| `MEV-AFET` | `assets/art/textures/gece_kapisi/burnt_ground_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 197](arayuz/UI_ASSET_PROMPTLARI_2.md#197--assetsarttexturesgece_kapisiburnt_ground_albedopng) |
| `KAPI-DEMIR` | `assets/art/textures/gece_kapisi/iron_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 198](arayuz/UI_ASSET_PROMPTLARI_2.md#198--assetsarttexturesgece_kapisiiron_albedopng) |
| `ARY01-*` | `assets/art/textures/gece_kapisi/timber_albedo.png` — kapatıldı 3 Kasım 2026 (Cursor): yıpranmış tahta, CC0 | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 199](arayuz/UI_ASSET_PROMPTLARI_2.md#199--assetsarttexturesgece_kapisitimber_albedopng) |
| `ARY01-*` | `assets/art/textures/gece_kapisi/paper_albedo.png` — kapatıldı 3 Kasım 2026 (Cursor): lif kâğıt, CC0 | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 200](arayuz/UI_ASSET_PROMPTLARI_2.md#200--assetsarttexturesgece_kapisipaper_albedopng) |
| `SAB03-ORTU` | `assets/art/textures/gece_kapisi/cloth_cover_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 201](arayuz/UI_ASSET_PROMPTLARI_2.md#201--assetsarttexturesgece_kapisicloth_cover_albedopng) |
| `TEZ01-ORTU` | `assets/art/textures/gece_kapisi/tez_agil_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 202](arayuz/UI_ASSET_PROMPTLARI_2.md#202--assetsarttexturesgece_kapisitez_agil_albedopng) |
| `TEZ01-ORTU` | `assets/art/textures/gece_kapisi/tez_degirmen_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 203](arayuz/UI_ASSET_PROMPTLARI_2.md#203--assetsarttexturesgece_kapisitez_degirmen_albedopng) |
| `TEZ01-ORTU` | `assets/art/textures/gece_kapisi/tez_demir_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 204](arayuz/UI_ASSET_PROMPTLARI_2.md#204--assetsarttexturesgece_kapisitez_demir_albedopng) |
| `TEZ01-ORTU` | `assets/art/textures/gece_kapisi/tez_bez_albedo.png` | 1024×1024 | Opak RGB; tam sahne/doku | [Prompt 205](arayuz/UI_ASSET_PROMPTLARI_2.md#205--assetsarttexturesgece_kapisitez_bez_albedopng) |
| `DYL02-AYRINTI-*` | `assets/art/inspect/carik.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 206](arayuz/UI_ASSET_PROMPTLARI_2.md#206--assetsartinspectcarikpng) |
| `DYL02-AYRINTI-*` | `assets/art/inspect/el.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 207](arayuz/UI_ASSET_PROMPTLARI_2.md#207--assetsartinspectelpng) |
| `DYL02-AYRINTI-*` | `assets/art/inspect/yara.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 208](arayuz/UI_ASSET_PROMPTLARI_2.md#208--assetsartinspectyarapng) |
| `DYL02-AYRINTI-*` | `assets/art/inspect/yanik.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 209](arayuz/UI_ASSET_PROMPTLARI_2.md#209--assetsartinspectyanikpng) |
| `TEZ07-TITREME` | `assets/art/textures/gece_kapisi/shaky_line.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 210](arayuz/UI_ASSET_PROMPTLARI_2.md#210--assetsarttexturesgece_kapisishaky_linepng) |
| `MEV-SENLIK` | `assets/art/decor/harvest_bunting.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 211](arayuz/UI_ASSET_PROMPTLARI_2.md#211--assetsartdecorharvest_buntingpng) |
| `MEV-SENLIK` | `assets/art/decor/harvest_grain_wreath.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 212](arayuz/UI_ASSET_PROMPTLARI_2.md#212--assetsartdecorharvest_grain_wreathpng) |
| `MEV-SENLIK` | `assets/art/decor/harvest_cloth_banner.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 213](arayuz/UI_ASSET_PROMPTLARI_2.md#213--assetsartdecorharvest_cloth_bannerpng) |
| `TUC04-AFYON` | `assets/art/icons/icon_stok_afyon.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 214](arayuz/UI_ASSET_PROMPTLARI_2.md#214--assetsarticonsicon_stok_afyonpng) |
| `TUC04-SARGI` | `assets/art/icons/icon_stok_sargi.png` — kapatıldı 3 Kasım 2026 (Cursor): sargı, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 215](arayuz/UI_ASSET_PROMPTLARI_2.md#215--assetsarticonsicon_stok_sargipng) |
| `TUC04-KECE` | `assets/art/icons/icon_stok_kece.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 216](arayuz/UI_ASSET_PROMPTLARI_2.md#216--assetsarticonsicon_stok_kecepng) |
| `TUC04-KUMAS` | `assets/art/icons/icon_stok_kumas_stok.png` — kapatıldı 3 Kasım 2026 (Cursor): kumaş topu, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 217](arayuz/UI_ASSET_PROMPTLARI_2.md#217--assetsarticonsicon_stok_kumas_stokpng) |
| `TUC11-MUHUR` | `assets/art/icons/icon_stok_yasak_muhur.png` — kapatıldı 3 Kasım 2026 (Cursor): mühür ikonu, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 218](arayuz/UI_ASSET_PROMPTLARI_2.md#218--assetsarticonsicon_stok_yasak_muhurpng) |
| `TUC11-IKSIR` | `assets/art/icons/icon_stok_kacak_iksir.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 219](arayuz/UI_ASSET_PROMPTLARI_2.md#219--assetsarticonsicon_stok_kacak_iksirpng) |
| `TUC08-ZIRH` | `assets/art/icons/icon_stok_zirh.png` — kısmi 3 Kasım 2026 (Cursor): göğüs zırhı, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 220](arayuz/UI_ASSET_PROMPTLARI_2.md#220--assetsarticonsicon_stok_zirhpng) |
| `TUC08-YAY` | `assets/art/icons/icon_stok_yay.png` — kapatıldı 3 Kasım 2026 (Cursor): yay, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 221](arayuz/UI_ASSET_PROMPTLARI_2.md#221--assetsarticonsicon_stok_yaypng) |
| `TUC08-KALKAN` | `assets/art/icons/icon_stok_kalkan.png` — kapatıldı 3 Kasım 2026 (Cursor): kalkan, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 222](arayuz/UI_ASSET_PROMPTLARI_2.md#222--assetsarticonsicon_stok_kalkanpng) |
| `TUC03-CIVI` | `assets/art/icons/icon_stok_civi.png` — kapatıldı 3 Kasım 2026 (Cursor): çivi, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 223](arayuz/UI_ASSET_PROMPTLARI_2.md#223--assetsarticonsicon_stok_civipng) |
| `TUC03-TIRPAN` | `assets/art/icons/icon_stok_tirpan.png` — kapatıldı 3 Kasım 2026 (Cursor): tırpan, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 224](arayuz/UI_ASSET_PROMPTLARI_2.md#224--assetsarticonsicon_stok_tirpanpng) |
| `TUC03-BALTA` | `assets/art/icons/icon_stok_balta.png` — kapatıldı 3 Kasım 2026 (Cursor): balta, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 225](arayuz/UI_ASSET_PROMPTLARI_2.md#225--assetsarticonsicon_stok_baltapng) |
| `MEV07-SU` | `assets/art/icons/icon_stok_su.png` — kapatıldı 3 Kasım 2026 (Cursor): su matarası, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 226](arayuz/UI_ASSET_PROMPTLARI_2.md#226--assetsarticonsicon_stok_supng) |
| `MEV14-SAMAN` | `assets/art/icons/icon_stok_saman.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 227](arayuz/UI_ASSET_PROMPTLARI_2.md#227--assetsarticonsicon_stok_samanpng) |
| `KRI03-ILAC` | `assets/art/icons/icon_stok_ilac_stok.png` — kısmi 3 Kasım 2026 (Cursor): ot demeti, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 228](arayuz/UI_ASSET_PROMPTLARI_2.md#228--assetsarticonsicon_stok_ilac_stokpng) |
| `HAR03-HEYET` | `assets/art/icons/icon_stok_heyet.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 229](arayuz/UI_ASSET_PROMPTLARI_2.md#229--assetsarticonsicon_stok_heyetpng) |
| `HAR06-IKON` | `assets/art/icons/icon_stok_gozcu_kulesi.png` — kapatıldı 3 Kasım 2026 (Cursor): gözcü kulesi, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 230](arayuz/UI_ASSET_PROMPTLARI_2.md#230--assetsarticonsicon_stok_gozcu_kulesipng) |
| `HAR09-GUVERCIN` | `assets/art/cards/guvercin.png` | 512×640 | RGBA; düz #00FF00 | [Prompt 231](arayuz/UI_ASSET_PROMPTLARI_2.md#231--assetsartcardsguvercinpng) |
| `HAR09-ULAK` | `assets/art/cards/ulak.png` | 512×640 | RGBA; düz #00FF00 | [Prompt 232](arayuz/UI_ASSET_PROMPTLARI_2.md#232--assetsartcardsulakpng) |
| `ACL04-ARASAHNE` | `assets/art/env/acilis_ulak.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 233](arayuz/UI_ASSET_PROMPTLARI_2.md#233--assetsartenvacilis_ulakpng) |
| `ZAR01-ZAR` | `assets/art/ui/zar_d6.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 234](arayuz/UI_ASSET_PROMPTLARI_2.md#234--assetsartuizar_d6png) |
| `ZAR01-ZAR` | `assets/art/ui/zar_d12.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 235](arayuz/UI_ASSET_PROMPTLARI_2.md#235--assetsartuizar_d12png) |
| `YAP04-DEFTER` | `assets/art/icons/icon_usta_defteri.png` — kapatıldı 3 Kasım 2026 (Cursor): açık kitap ikonu, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 236](arayuz/UI_ASSET_PROMPTLARI_2.md#236--assetsarticonsicon_usta_defteripng) |
| `YAP06-ESYA` | `assets/art/icons/icon_ozel_esya.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 237](arayuz/UI_ASSET_PROMPTLARI_2.md#237--assetsarticonsicon_ozel_esyapng) |
| `YSM01-IKON` | `assets/art/icons/icon_yasam_aclik.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 238](arayuz/UI_ASSET_PROMPTLARI_2.md#238--assetsarticonsicon_yasam_aclikpng) |
| `YSM01-IKON` | `assets/art/icons/icon_yasam_yorgunluk.png` | 256×256 | RGBA; düz #00FF00 | [Prompt 239](arayuz/UI_ASSET_PROMPTLARI_2.md#239--assetsarticonsicon_yasam_yorgunlukpng) |
| `YSM01-IKON` | `assets/art/icons/icon_yasam_moral.png` — kısmi 3 Kasım 2026 (Cursor): ateş ikonu, CC-BY | 256×256 | RGBA; düz #00FF00 | [Prompt 240](arayuz/UI_ASSET_PROMPTLARI_2.md#240--assetsarticonsicon_yasam_moralpng) |
| `ARY03-*` | `assets/art/env/secim_bg.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 241](arayuz/UI_ASSET_PROMPTLARI_2.md#241--assetsartenvsecim_bgpng) |
| `ARY03-*` | `assets/art/env/koy_hud_bg.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 242](arayuz/UI_ASSET_PROMPTLARI_2.md#242--assetsartenvkoy_hud_bgpng) |
| `ARY04-YUKLEME-01` | `assets/art/env/yukleme_01.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 243](arayuz/UI_ASSET_PROMPTLARI_2.md#243--assetsartenvyukleme_01png) |
| `ARY04-YUKLEME-02` | `assets/art/env/yukleme_02.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 244](arayuz/UI_ASSET_PROMPTLARI_2.md#244--assetsartenvyukleme_02png) |
| `ARY04-YUKLEME-03` | `assets/art/env/yukleme_03.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 245](arayuz/UI_ASSET_PROMPTLARI_2.md#245--assetsartenvyukleme_03png) |
| `ARY04-YUKLEME-04` | `assets/art/env/yukleme_04.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 246](arayuz/UI_ASSET_PROMPTLARI_2.md#246--assetsartenvyukleme_04png) |
| `ARY04-YUKLEME-05` | `assets/art/env/yukleme_05.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 247](arayuz/UI_ASSET_PROMPTLARI_2.md#247--assetsartenvyukleme_05png) |
| `ARY04-YUKLEME-06` | `assets/art/env/yukleme_06.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 248](arayuz/UI_ASSET_PROMPTLARI_2.md#248--assetsartenvyukleme_06png) |
| `ARY04-YUKLEME-07` | `assets/art/env/yukleme_07.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 249](arayuz/UI_ASSET_PROMPTLARI_2.md#249--assetsartenvyukleme_07png) |
| `ARY04-YUKLEME-08` | `assets/art/env/yukleme_08.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 250](arayuz/UI_ASSET_PROMPTLARI_2.md#250--assetsartenvyukleme_08png) |
| `DYL07-OCAK` | `assets/art/env/ocak_arasahne.png` | 1920×1080 | Opak RGB; tam sahne/doku | [Prompt 251](arayuz/UI_ASSET_PROMPTLARI_2.md#251--assetsartenvocak_arasahnepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_001_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 252](arayuz/UI_ASSET_PROMPTLARI_2.md#252--assetsartinspectchr_001_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_002_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 253](arayuz/UI_ASSET_PROMPTLARI_2.md#253--assetsartinspectchr_002_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_003_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 254](arayuz/UI_ASSET_PROMPTLARI_2.md#254--assetsartinspectchr_003_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_004_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 255](arayuz/UI_ASSET_PROMPTLARI_2.md#255--assetsartinspectchr_004_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_005_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 256](arayuz/UI_ASSET_PROMPTLARI_2.md#256--assetsartinspectchr_005_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_006_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 257](arayuz/UI_ASSET_PROMPTLARI_2.md#257--assetsartinspectchr_006_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_007_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 258](arayuz/UI_ASSET_PROMPTLARI_2.md#258--assetsartinspectchr_007_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_008_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 259](arayuz/UI_ASSET_PROMPTLARI_2.md#259--assetsartinspectchr_008_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_009_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 260](arayuz/UI_ASSET_PROMPTLARI_2.md#260--assetsartinspectchr_009_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_010_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 261](arayuz/UI_ASSET_PROMPTLARI_2.md#261--assetsartinspectchr_010_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_011_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 262](arayuz/UI_ASSET_PROMPTLARI_2.md#262--assetsartinspectchr_011_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_012_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 263](arayuz/UI_ASSET_PROMPTLARI_2.md#263--assetsartinspectchr_012_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_013_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 264](arayuz/UI_ASSET_PROMPTLARI_2.md#264--assetsartinspectchr_013_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_014_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 265](arayuz/UI_ASSET_PROMPTLARI_2.md#265--assetsartinspectchr_014_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_015_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 266](arayuz/UI_ASSET_PROMPTLARI_2.md#266--assetsartinspectchr_015_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_016_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 267](arayuz/UI_ASSET_PROMPTLARI_2.md#267--assetsartinspectchr_016_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_017_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 268](arayuz/UI_ASSET_PROMPTLARI_2.md#268--assetsartinspectchr_017_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_018_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 269](arayuz/UI_ASSET_PROMPTLARI_2.md#269--assetsartinspectchr_018_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_019_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 270](arayuz/UI_ASSET_PROMPTLARI_2.md#270--assetsartinspectchr_019_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_020_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 271](arayuz/UI_ASSET_PROMPTLARI_2.md#271--assetsartinspectchr_020_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_021_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 272](arayuz/UI_ASSET_PROMPTLARI_2.md#272--assetsartinspectchr_021_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_022_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 273](arayuz/UI_ASSET_PROMPTLARI_2.md#273--assetsartinspectchr_022_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_023_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 274](arayuz/UI_ASSET_PROMPTLARI_2.md#274--assetsartinspectchr_023_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_024_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 275](arayuz/UI_ASSET_PROMPTLARI_2.md#275--assetsartinspectchr_024_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_025_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 276](arayuz/UI_ASSET_PROMPTLARI_2.md#276--assetsartinspectchr_025_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_026_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 277](arayuz/UI_ASSET_PROMPTLARI_2.md#277--assetsartinspectchr_026_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_027_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 278](arayuz/UI_ASSET_PROMPTLARI_2.md#278--assetsartinspectchr_027_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_028_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 279](arayuz/UI_ASSET_PROMPTLARI_2.md#279--assetsartinspectchr_028_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_029_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 280](arayuz/UI_ASSET_PROMPTLARI_2.md#280--assetsartinspectchr_029_tracepng) |
| `PORTRE-CHR-30` | `assets/art/inspect/chr_030_trace.png` | 512×512 | RGBA; düz #00FF00 | [Prompt 281](arayuz/UI_ASSET_PROMPTLARI_2.md#281--assetsartinspectchr_030_tracepng) |

### Mevcut arayüz yuvaları

Her yuva [tekli UI kataloğunda](arayuz/GEMINI_TEKLI_URETIM_PROMPTLARI.md) kendi hazır promptuna veya aynı temelden türetme talimatına sahiptir. Yeni şekil üreterek buton ailesi bozulmaz.

| No | Nihai dosya | Boyut | Saydamlık | Hazırlık / durum |
|---|---|---|---|---|
| 01 | `assets/ui/atmosfer/gece_kapisi/main_menu_bg.png` | 1920×1080 | Opak RGB | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 02 | `assets/ui/atmosfer/gece_kapisi/interrogation_bg.png` | 1920×1080 | Opak RGB | prompt hazır, Ahmet üretecek; Tek resim |
| 03 | `assets/ui/atmosfer/gece_kapisi/map_bg.png` | 1920×1080 | Opak RGB | prompt hazır, Ahmet üretecek; Tek resim |
| 04 | `assets/ui/atmosfer/gece_kapisi/loading_bg.png` | 1920×1080 | Opak RGB | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 05 | `assets/ui/atmosfer/gece_kapisi/dialogue_panel.png` | 1536×768 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 06 | `assets/ui/atmosfer/gece_kapisi/button_normal.png` | 768×192 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 07 | `assets/ui/atmosfer/gece_kapisi/button_hover.png` | 768×192 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Aynı temelden türet |
| 08 | `assets/ui/atmosfer/gece_kapisi/button_pressed.png` | 768×192 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Aynı temelden türet |
| 09 | `assets/ui/atmosfer/gece_kapisi/button_disabled.png` | 768×192 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Aynı temelden türet |
| 10 | `assets/ui/atmosfer/gece_kapisi/villager_card.png` | 768×1024 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 11 | `assets/ui/atmosfer/gece_kapisi/portrait_frame.png` | 512×640 | RGBA; dışı ve merkezi saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 12 | `assets/ui/atmosfer/gece_kapisi/settings_panel.png` | 1536×1536 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 13 | `assets/ui/atmosfer/gece_kapisi/tooltip_panel.png` | 768×384 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 14 | `assets/ui/atmosfer/gece_kapisi/hud_strip.png` | 2048×192 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 15 | `assets/ui/atmosfer/gece_kapisi/focus_ring.png` | 768×192 | RGBA; dışı ve merkezi saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Aynı temelden türet |
| 16 | `assets/ui/atmosfer/gece_kapisi/tab_normal.png` | 384×160 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 17 | `assets/ui/atmosfer/gece_kapisi/tab_selected.png` | 384×160 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Aynı temelden türet |
| 18 | `assets/ui/atmosfer/gece_kapisi/checkbox_off.png` | 96×96 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 19 | `assets/ui/atmosfer/gece_kapisi/checkbox_on.png` | 96×96 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Aynı temelden türet |
| 20 | `assets/ui/atmosfer/gece_kapisi/slider_track.png` | 768×64 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 21 | `assets/ui/atmosfer/gece_kapisi/slider_thumb.png` | 96×128 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 22 | `assets/ui/atmosfer/gece_kapisi/scrollbar_track.png` | 48×768 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 23 | `assets/ui/atmosfer/gece_kapisi/scrollbar_thumb.png` | 48×192 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 24 | `assets/ui/atmosfer/gece_kapisi/loading_track.png` | 1024×96 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 25 | `assets/ui/atmosfer/gece_kapisi/loading_fill.png` | 1024×96 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 26 | `assets/ui/atmosfer/gece_kapisi/ornament_corner.png` | 256×256 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 27 | `assets/ui/atmosfer/gece_kapisi/ornament_divider.png` | 1024×96 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 28 | `assets/ui/atmosfer/gece_kapisi/ornament_emblem.png` | 512×512 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 29 | `assets/ui/atmosfer/gece_kapisi/ornament_seal.png` — kapatıldı 3 Kasım 2026 (Cursor): 1464 mühür, kamu malı | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 30 | `assets/ui/atmosfer/gece_kapisi/cursor_arrow.png` | 128×128 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 31 | `assets/ui/atmosfer/gece_kapisi/cursor_point.png` | 128×128 | RGBA; dışı saydam | Alfa/ölçü hazır; entegrasyon üretim sonu; Tek resim |
| 32 | `assets/ui/atmosfer/gece_kapisi/cursor_grab.png` | 128×128 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 33 | `assets/ui/atmosfer/gece_kapisi/cursor_busy.png` | 128×128 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 34 | `assets/ui/atmosfer/gece_kapisi/icon_akce.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 35 | `assets/ui/atmosfer/gece_kapisi/icon_erzak.png` — kapatıldı 3 Kasım 2026 (Cursor): tahıl demeti, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 36 | `assets/ui/atmosfer/gece_kapisi/icon_odun.png` — kapatıldı 3 Kasım 2026 (Cursor): odun yığını, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 37 | `assets/ui/atmosfer/gece_kapisi/icon_tas.png` — kapatıldı 3 Kasım 2026 (Cursor): taş yığını, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 38 | `assets/ui/atmosfer/gece_kapisi/icon_demir.png` — kısmi 3 Kasım 2026 (Cursor): metal çubuk, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 39 | `assets/ui/atmosfer/gece_kapisi/icon_bez.png` — kapatıldı 3 Kasım 2026 (Cursor): kumaş topu, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 40 | `assets/ui/atmosfer/gece_kapisi/icon_alet.png` — kapatıldı 3 Kasım 2026 (Cursor): çekiç ve çivi, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 41 | `assets/ui/atmosfer/gece_kapisi/icon_nufus.png` — kapatıldı 3 Kasım 2026 (Cursor): kişi silüeti, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 42 | `assets/ui/atmosfer/gece_kapisi/icon_yatak.png` — kapatıldı 3 Kasım 2026 (Cursor): yatak, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 43 | `assets/ui/atmosfer/gece_kapisi/icon_saglik.png` — kısmi 3 Kasım 2026 (Cursor): ot demeti, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 44 | `assets/ui/atmosfer/gece_kapisi/icon_moral.png` — kısmi 3 Kasım 2026 (Cursor): ateş ikonu, CC-BY | 256×256 | RGBA; dışı saydam | açık lisanslı asset bağlandı; Tek resim |
| 45 | `assets/ui/atmosfer/gece_kapisi/icon_guvenlik.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 46 | `assets/ui/atmosfer/gece_kapisi/icon_adalet.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 47 | `assets/ui/atmosfer/gece_kapisi/icon_gun.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 48 | `assets/ui/atmosfer/gece_kapisi/icon_kabul.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 49 | `assets/ui/atmosfer/gece_kapisi/icon_ret.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 50 | `assets/ui/atmosfer/gece_kapisi/icon_uyari.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 51 | `assets/ui/atmosfer/gece_kapisi/icon_kilit.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 52 | `assets/ui/atmosfer/gece_kapisi/icon_geri.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 53 | `assets/ui/atmosfer/gece_kapisi/icon_kapat.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 54 | `assets/ui/atmosfer/gece_kapisi/icon_ayarlar.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 55 | `assets/ui/atmosfer/gece_kapisi/icon_kaydet.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 56 | `assets/ui/atmosfer/gece_kapisi/icon_harita.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |
| 57 | `assets/ui/atmosfer/gece_kapisi/icon_diyalog.png` | 256×256 | RGBA; dışı saydam | prompt hazır, Ahmet üretecek; Tek resim |

## 3D assetler — açık üretim ihtiyaçları

### SAH-74 / ARY-05 eksik hareket klipleri (Kalfa)

Headless karakter muayenesindeki eksik klipler. Yer tutucu mevcut bekleme klibi veya duruş pozu. Düşük öncelik. Hareketler modelin mevcut iskelet ve ölçeğine uyarlanır. Arama terimleri: karakter hareketi, medieval character animation, idle fallback.

| Kimlik | Sahne | Model | İstenen klip | Durum |
|---|---|---|---|---|
| SAH-KLIP-asker-gergin | `tests/oto/karakter_muayene.tscn` | `asker` | `gergin` | bekliyor |
| SAH-KLIP-asker-konus | `tests/oto/karakter_muayene.tscn` | `asker` | `konus` | bekliyor |
| SAH-KLIP-asker-ofke | `tests/oto/karakter_muayene.tscn` | `asker` | `ofke` | bekliyor |
| SAH-KLIP-asker-panik | `tests/oto/karakter_muayene.tscn` | `asker` | `panik` | bekliyor |
| SAH-KLIP-asker-sevinc | `tests/oto/karakter_muayene.tscn` | `asker` | `sevinc` | bekliyor |
| SAH-KLIP-aydogdu-gergin | `tests/oto/karakter_muayene.tscn` | `aydogdu` | `gergin` | bekliyor |
| SAH-KLIP-aydogdu-konus | `tests/oto/karakter_muayene.tscn` | `aydogdu` | `konus` | bekliyor |
| SAH-KLIP-aydogdu-ofke | `tests/oto/karakter_muayene.tscn` | `aydogdu` | `ofke` | bekliyor |
| SAH-KLIP-aydogdu-panik | `tests/oto/karakter_muayene.tscn` | `aydogdu` | `panik` | bekliyor |
| SAH-KLIP-aydogdu-sevinc | `tests/oto/karakter_muayene.tscn` | `aydogdu` | `sevinc` | bekliyor |
| SAH-KLIP-ayse_baci-gergin | `tests/oto/karakter_muayene.tscn` | `ayse_baci` | `gergin` | bekliyor |
| SAH-KLIP-ayse_baci-konus | `tests/oto/karakter_muayene.tscn` | `ayse_baci` | `konus` | bekliyor |
| SAH-KLIP-ayse_baci-ofke | `tests/oto/karakter_muayene.tscn` | `ayse_baci` | `ofke` | bekliyor |
| SAH-KLIP-ayse_baci-panik | `tests/oto/karakter_muayene.tscn` | `ayse_baci` | `panik` | bekliyor |
| SAH-KLIP-ayse_baci-sevinc | `tests/oto/karakter_muayene.tscn` | `ayse_baci` | `sevinc` | bekliyor |
| SAH-KLIP-chr_001-gergin | `tests/oto/karakter_muayene.tscn` | `chr_001` | `gergin` | bekliyor |
| SAH-KLIP-chr_001-panik | `tests/oto/karakter_muayene.tscn` | `chr_001` | `panik` | bekliyor |
| SAH-KLIP-chr_002-gergin | `tests/oto/karakter_muayene.tscn` | `chr_002` | `gergin` | bekliyor |
| SAH-KLIP-chr_002-ofke | `tests/oto/karakter_muayene.tscn` | `chr_002` | `ofke` | bekliyor |
| SAH-KLIP-chr_003-gergin | `tests/oto/karakter_muayene.tscn` | `chr_003` | `gergin` | bekliyor |
| SAH-KLIP-chr_003-ofke | `tests/oto/karakter_muayene.tscn` | `chr_003` | `ofke` | bekliyor |
| SAH-KLIP-chr_004-gergin | `tests/oto/karakter_muayene.tscn` | `chr_004` | `gergin` | bekliyor |
| SAH-KLIP-chr_004-panik | `tests/oto/karakter_muayene.tscn` | `chr_004` | `panik` | bekliyor |
| SAH-KLIP-chr_005-gergin | `tests/oto/karakter_muayene.tscn` | `chr_005` | `gergin` | bekliyor |
| SAH-KLIP-chr_005-panik | `tests/oto/karakter_muayene.tscn` | `chr_005` | `panik` | bekliyor |
| SAH-KLIP-chr_006-gergin | `tests/oto/karakter_muayene.tscn` | `chr_006` | `gergin` | bekliyor |
| SAH-KLIP-chr_006-ofke | `tests/oto/karakter_muayene.tscn` | `chr_006` | `ofke` | bekliyor |
| SAH-KLIP-chr_006-panik | `tests/oto/karakter_muayene.tscn` | `chr_006` | `panik` | bekliyor |
| SAH-KLIP-chr_006-sevinc | `tests/oto/karakter_muayene.tscn` | `chr_006` | `sevinc` | bekliyor |
| SAH-KLIP-chr_007-gergin | `tests/oto/karakter_muayene.tscn` | `chr_007` | `gergin` | bekliyor |
| SAH-KLIP-chr_007-panik | `tests/oto/karakter_muayene.tscn` | `chr_007` | `panik` | bekliyor |
| SAH-KLIP-chr_008-gergin | `tests/oto/karakter_muayene.tscn` | `chr_008` | `gergin` | bekliyor |
| SAH-KLIP-chr_008-ofke | `tests/oto/karakter_muayene.tscn` | `chr_008` | `ofke` | bekliyor |
| SAH-KLIP-chr_009-gergin | `tests/oto/karakter_muayene.tscn` | `chr_009` | `gergin` | bekliyor |
| SAH-KLIP-chr_009-panik | `tests/oto/karakter_muayene.tscn` | `chr_009` | `panik` | bekliyor |
| SAH-KLIP-chr_010-gergin | `tests/oto/karakter_muayene.tscn` | `chr_010` | `gergin` | bekliyor |
| SAH-KLIP-chr_010-panik | `tests/oto/karakter_muayene.tscn` | `chr_010` | `panik` | bekliyor |
| SAH-KLIP-chr_011-gergin | `tests/oto/karakter_muayene.tscn` | `chr_011` | `gergin` | bekliyor |
| SAH-KLIP-chr_011-ofke | `tests/oto/karakter_muayene.tscn` | `chr_011` | `ofke` | bekliyor |
| SAH-KLIP-chr_012-gergin | `tests/oto/karakter_muayene.tscn` | `chr_012` | `gergin` | bekliyor |
| SAH-KLIP-chr_012-ofke | `tests/oto/karakter_muayene.tscn` | `chr_012` | `ofke` | bekliyor |
| SAH-KLIP-chr_013-gergin | `tests/oto/karakter_muayene.tscn` | `chr_013` | `gergin` | bekliyor |
| SAH-KLIP-chr_013-ofke | `tests/oto/karakter_muayene.tscn` | `chr_013` | `ofke` | bekliyor |
| SAH-KLIP-chr_014-gergin | `tests/oto/karakter_muayene.tscn` | `chr_014` | `gergin` | bekliyor |
| SAH-KLIP-chr_014-ofke | `tests/oto/karakter_muayene.tscn` | `chr_014` | `ofke` | bekliyor |
| SAH-KLIP-chr_015-gergin | `tests/oto/karakter_muayene.tscn` | `chr_015` | `gergin` | bekliyor |
| SAH-KLIP-chr_015-ofke | `tests/oto/karakter_muayene.tscn` | `chr_015` | `ofke` | bekliyor |
| SAH-KLIP-chr_016-gergin | `tests/oto/karakter_muayene.tscn` | `chr_016` | `gergin` | bekliyor |
| SAH-KLIP-chr_016-ofke | `tests/oto/karakter_muayene.tscn` | `chr_016` | `ofke` | bekliyor |
| SAH-KLIP-chr_017-gergin | `tests/oto/karakter_muayene.tscn` | `chr_017` | `gergin` | bekliyor |
| SAH-KLIP-chr_017-ofke | `tests/oto/karakter_muayene.tscn` | `chr_017` | `ofke` | bekliyor |
| SAH-KLIP-chr_018-gergin | `tests/oto/karakter_muayene.tscn` | `chr_018` | `gergin` | bekliyor |
| SAH-KLIP-chr_018-ofke | `tests/oto/karakter_muayene.tscn` | `chr_018` | `ofke` | bekliyor |
| SAH-KLIP-chr_019-gergin | `tests/oto/karakter_muayene.tscn` | `chr_019` | `gergin` | bekliyor |
| SAH-KLIP-chr_019-ofke | `tests/oto/karakter_muayene.tscn` | `chr_019` | `ofke` | bekliyor |
| SAH-KLIP-chr_020-gergin | `tests/oto/karakter_muayene.tscn` | `chr_020` | `gergin` | bekliyor |
| SAH-KLIP-chr_020-ofke | `tests/oto/karakter_muayene.tscn` | `chr_020` | `ofke` | bekliyor |
| SAH-KLIP-chr_021-gergin | `tests/oto/karakter_muayene.tscn` | `chr_021` | `gergin` | bekliyor |
| SAH-KLIP-chr_021-ofke | `tests/oto/karakter_muayene.tscn` | `chr_021` | `ofke` | bekliyor |
| SAH-KLIP-chr_022-gergin | `tests/oto/karakter_muayene.tscn` | `chr_022` | `gergin` | bekliyor |
| SAH-KLIP-chr_022-ofke | `tests/oto/karakter_muayene.tscn` | `chr_022` | `ofke` | bekliyor |
| SAH-KLIP-chr_023-gergin | `tests/oto/karakter_muayene.tscn` | `chr_023` | `gergin` | bekliyor |
| SAH-KLIP-chr_023-ofke | `tests/oto/karakter_muayene.tscn` | `chr_023` | `ofke` | bekliyor |
| SAH-KLIP-chr_024-gergin | `tests/oto/karakter_muayene.tscn` | `chr_024` | `gergin` | bekliyor |
| SAH-KLIP-chr_024-ofke | `tests/oto/karakter_muayene.tscn` | `chr_024` | `ofke` | bekliyor |
| SAH-KLIP-chr_025-gergin | `tests/oto/karakter_muayene.tscn` | `chr_025` | `gergin` | bekliyor |
| SAH-KLIP-chr_025-ofke | `tests/oto/karakter_muayene.tscn` | `chr_025` | `ofke` | bekliyor |
| SAH-KLIP-chr_026-gergin | `tests/oto/karakter_muayene.tscn` | `chr_026` | `gergin` | bekliyor |
| SAH-KLIP-chr_026-ofke | `tests/oto/karakter_muayene.tscn` | `chr_026` | `ofke` | bekliyor |
| SAH-KLIP-chr_027-gergin | `tests/oto/karakter_muayene.tscn` | `chr_027` | `gergin` | bekliyor |
| SAH-KLIP-chr_027-ofke | `tests/oto/karakter_muayene.tscn` | `chr_027` | `ofke` | bekliyor |
| SAH-KLIP-chr_028-gergin | `tests/oto/karakter_muayene.tscn` | `chr_028` | `gergin` | bekliyor |
| SAH-KLIP-chr_028-ofke | `tests/oto/karakter_muayene.tscn` | `chr_028` | `ofke` | bekliyor |
| SAH-KLIP-chr_029-gergin | `tests/oto/karakter_muayene.tscn` | `chr_029` | `gergin` | bekliyor |
| SAH-KLIP-chr_029-ofke | `tests/oto/karakter_muayene.tscn` | `chr_029` | `ofke` | bekliyor |
| SAH-KLIP-chr_030-gergin | `tests/oto/karakter_muayene.tscn` | `chr_030` | `gergin` | bekliyor |
| SAH-KLIP-chr_030-ofke | `tests/oto/karakter_muayene.tscn` | `chr_030` | `ofke` | bekliyor |
| SAH-KLIP-ciftci-gergin | `tests/oto/karakter_muayene.tscn` | `ciftci` | `gergin` | bekliyor |
| SAH-KLIP-ciftci-konus | `tests/oto/karakter_muayene.tscn` | `ciftci` | `konus` | bekliyor |
| SAH-KLIP-ciftci-ofke | `tests/oto/karakter_muayene.tscn` | `ciftci` | `ofke` | bekliyor |
| SAH-KLIP-ciftci-panik | `tests/oto/karakter_muayene.tscn` | `ciftci` | `panik` | bekliyor |
| SAH-KLIP-ciftci-sevinc | `tests/oto/karakter_muayene.tscn` | `ciftci` | `sevinc` | bekliyor |
| SAH-KLIP-ciftci_kadin-gergin | `tests/oto/karakter_muayene.tscn` | `ciftci_kadin` | `gergin` | bekliyor |
| SAH-KLIP-ciftci_kadin-konus | `tests/oto/karakter_muayene.tscn` | `ciftci_kadin` | `konus` | bekliyor |
| SAH-KLIP-ciftci_kadin-ofke | `tests/oto/karakter_muayene.tscn` | `ciftci_kadin` | `ofke` | bekliyor |
| SAH-KLIP-ciftci_kadin-panik | `tests/oto/karakter_muayene.tscn` | `ciftci_kadin` | `panik` | bekliyor |
| SAH-KLIP-ciftci_kadin-sevinc | `tests/oto/karakter_muayene.tscn` | `ciftci_kadin` | `sevinc` | bekliyor |
| SAH-KLIP-esnaf-gergin | `tests/oto/karakter_muayene.tscn` | `esnaf` | `gergin` | bekliyor |
| SAH-KLIP-esnaf-konus | `tests/oto/karakter_muayene.tscn` | `esnaf` | `konus` | bekliyor |
| SAH-KLIP-esnaf-ofke | `tests/oto/karakter_muayene.tscn` | `esnaf` | `ofke` | bekliyor |
| SAH-KLIP-esnaf-panik | `tests/oto/karakter_muayene.tscn` | `esnaf` | `panik` | bekliyor |
| SAH-KLIP-esnaf-sevinc | `tests/oto/karakter_muayene.tscn` | `esnaf` | `sevinc` | bekliyor |
| SAH-KLIP-hasan_celebi-gergin | `tests/oto/karakter_muayene.tscn` | `hasan_celebi` | `gergin` | bekliyor |
| SAH-KLIP-hasan_celebi-konus | `tests/oto/karakter_muayene.tscn` | `hasan_celebi` | `konus` | bekliyor |
| SAH-KLIP-hasan_celebi-ofke | `tests/oto/karakter_muayene.tscn` | `hasan_celebi` | `ofke` | bekliyor |
| SAH-KLIP-hasan_celebi-panik | `tests/oto/karakter_muayene.tscn` | `hasan_celebi` | `panik` | bekliyor |
| SAH-KLIP-hasan_celebi-sevinc | `tests/oto/karakter_muayene.tscn` | `hasan_celebi` | `sevinc` | bekliyor |
| SAH-KLIP-karaca_usta-gergin | `tests/oto/karakter_muayene.tscn` | `karaca_usta` | `gergin` | bekliyor |
| SAH-KLIP-karaca_usta-konus | `tests/oto/karakter_muayene.tscn` | `karaca_usta` | `konus` | bekliyor |
| SAH-KLIP-karaca_usta-ofke | `tests/oto/karakter_muayene.tscn` | `karaca_usta` | `ofke` | bekliyor |
| SAH-KLIP-karaca_usta-panik | `tests/oto/karakter_muayene.tscn` | `karaca_usta` | `panik` | bekliyor |
| SAH-KLIP-karaca_usta-sevinc | `tests/oto/karakter_muayene.tscn` | `karaca_usta` | `sevinc` | bekliyor |
| SAH-KLIP-lowpo_cocuk-gergin | `tests/oto/karakter_muayene.tscn` | `lowpo_cocuk` | `gergin` | bekliyor |
| SAH-KLIP-lowpo_cocuk-ofke | `tests/oto/karakter_muayene.tscn` | `lowpo_cocuk` | `ofke` | bekliyor |
| SAH-KLIP-lowpo_cocuk-panik | `tests/oto/karakter_muayene.tscn` | `lowpo_cocuk` | `panik` | bekliyor |
| SAH-KLIP-lowpo_cocuk-sevinc | `tests/oto/karakter_muayene.tscn` | `lowpo_cocuk` | `sevinc` | bekliyor |
| SAH-KLIP-lowpo_demirci-gergin | `tests/oto/karakter_muayene.tscn` | `lowpo_demirci` | `gergin` | bekliyor |
| SAH-KLIP-lowpo_demirci-ofke | `tests/oto/karakter_muayene.tscn` | `lowpo_demirci` | `ofke` | bekliyor |
| SAH-KLIP-lowpo_demirci-panik | `tests/oto/karakter_muayene.tscn` | `lowpo_demirci` | `panik` | bekliyor |
| SAH-KLIP-lowpo_demirci-sevinc | `tests/oto/karakter_muayene.tscn` | `lowpo_demirci` | `sevinc` | bekliyor |
| SAH-KLIP-miraen-gergin | `tests/oto/karakter_muayene.tscn` | `miraen` | `gergin` | bekliyor |
| SAH-KLIP-miraen-konus | `tests/oto/karakter_muayene.tscn` | `miraen` | `konus` | bekliyor |
| SAH-KLIP-miraen-ofke | `tests/oto/karakter_muayene.tscn` | `miraen` | `ofke` | bekliyor |
| SAH-KLIP-miraen-panik | `tests/oto/karakter_muayene.tscn` | `miraen` | `panik` | bekliyor |
| SAH-KLIP-miraen-sevinc | `tests/oto/karakter_muayene.tscn` | `miraen` | `sevinc` | bekliyor |
| SAH-KLIP-nogay-gergin | `tests/oto/karakter_muayene.tscn` | `nogay` | `gergin` | bekliyor |
| SAH-KLIP-nogay-konus | `tests/oto/karakter_muayene.tscn` | `nogay` | `konus` | bekliyor |
| SAH-KLIP-nogay-ofke | `tests/oto/karakter_muayene.tscn` | `nogay` | `ofke` | bekliyor |
| SAH-KLIP-nogay-panik | `tests/oto/karakter_muayene.tscn` | `nogay` | `panik` | bekliyor |
| SAH-KLIP-nogay-sevinc | `tests/oto/karakter_muayene.tscn` | `nogay` | `sevinc` | bekliyor |
| SAH-KLIP-saruca_hatun-gergin | `tests/oto/karakter_muayene.tscn` | `saruca_hatun` | `gergin` | bekliyor |
| SAH-KLIP-saruca_hatun-konus | `tests/oto/karakter_muayene.tscn` | `saruca_hatun` | `konus` | bekliyor |
| SAH-KLIP-saruca_hatun-ofke | `tests/oto/karakter_muayene.tscn` | `saruca_hatun` | `ofke` | bekliyor |
| SAH-KLIP-saruca_hatun-panik | `tests/oto/karakter_muayene.tscn` | `saruca_hatun` | `panik` | bekliyor |
| SAH-KLIP-saruca_hatun-sevinc | `tests/oto/karakter_muayene.tscn` | `saruca_hatun` | `sevinc` | bekliyor |
| SAH-KLIP-sorhan-gergin | `tests/oto/karakter_muayene.tscn` | `sorhan` | `gergin` | bekliyor |
| SAH-KLIP-sorhan-konus | `tests/oto/karakter_muayene.tscn` | `sorhan` | `konus` | bekliyor |
| SAH-KLIP-sorhan-ofke | `tests/oto/karakter_muayene.tscn` | `sorhan` | `ofke` | bekliyor |
| SAH-KLIP-sorhan-panik | `tests/oto/karakter_muayene.tscn` | `sorhan` | `panik` | bekliyor |
| SAH-KLIP-sorhan-sevinc | `tests/oto/karakter_muayene.tscn` | `sorhan` | `sevinc` | bekliyor |
| SAH-KLIP-thessra-gergin | `tests/oto/karakter_muayene.tscn` | `thessra` | `gergin` | bekliyor |
| SAH-KLIP-thessra-konus | `tests/oto/karakter_muayene.tscn` | `thessra` | `konus` | bekliyor |
| SAH-KLIP-thessra-ofke | `tests/oto/karakter_muayene.tscn` | `thessra` | `ofke` | bekliyor |
| SAH-KLIP-thessra-panik | `tests/oto/karakter_muayene.tscn` | `thessra` | `panik` | bekliyor |
| SAH-KLIP-thessra-sevinc | `tests/oto/karakter_muayene.tscn` | `thessra` | `sevinc` | bekliyor |
| SAH-KLIP-yusuf-gergin | `tests/oto/karakter_muayene.tscn` | `yusuf` | `gergin` | bekliyor |
| SAH-KLIP-yusuf-konus | `tests/oto/karakter_muayene.tscn` | `yusuf` | `konus` | bekliyor |
| SAH-KLIP-yusuf-ofke | `tests/oto/karakter_muayene.tscn` | `yusuf` | `ofke` | bekliyor |
| SAH-KLIP-yusuf-panik | `tests/oto/karakter_muayene.tscn` | `yusuf` | `panik` | bekliyor |
| SAH-KLIP-yusuf-sevinc | `tests/oto/karakter_muayene.tscn` | `yusuf` | `sevinc` | bekliyor |


### SAH-16 el eşyası temas bulguları (Kalfa)

46 modelin gerçek headless muayenesinde 8 model-eşya eşleşmesi bulundu. Kayıtlar ARY-05 izleme tablosundaki yedi türe bağlıdır. Torba, sepet, çekiç, asa ve değnek için ölçü referansı mevcut EL satırlarıdır. Kazma 0,60 × 0,80 × 0,15 m kaynak sınırını, kile yaklaşık 0,22 × 0,13 × 0,22 m mevcut ahşap ölçeği kullanır. Kapı dönemi ve mevcut avuç soketi esas alınır. Doğrulama için kasıtlı kesiştirilen heybe üretim listesine eklenmedi.

**114 satır/grup**, tek tek model dosyası sayısı değildir. Bir grup birden çok model/klip içerebilir. Kimlik / kısa tanım / ölçü aşağıdadır; eski yer tutucu, format, öncelik ve ajan kaydı kaynak taramasında korunur. 2D doku promptu bağlı geometriyi kapatmaz.

| ID / grup | Kısa tanım | Hedef ölçü (metre) |
|---|---|---|
| `KAPI-3D-IC` | [ÜRETİLDİ: `assets/model/yapi/kapi_ic.glb`] Bekçi kadrajı (`KapiCercevesi`). | 4,0 × 4,0 × 0,35 m; kanat başına 2,0 m |
| `EL-TORBA` | [ÜRETİLDİ: `assets/model/nesne/el_torba.glb`] chr_002; keten torba, linen sack (`ElEsyasi`). | 0,35 × 0,50 × 0,20 m |
| `EL-SEPET` | [ÜRETİLDİ: `assets/model/nesne/el_sepet.glb`] chr_003; hasır sepet, wicker basket (`ElEsyasi`). | 0,45 × 0,40 × 0,35 m |
| `EL-CEKIC` | [ÜRETİLDİ: `assets/model/nesne/el_cekic.glb`] chr_003; küçük çekiç, hand hammer (`ElEsyasi`). | 0,12 × 0,35 × 0,06 m |
| `EL-KAMCI` | [ÜRETİLDİ: `assets/model/nesne/el_kamci.glb`] chr_004; at kamçısı, horse whip (`ElEsyasi`). | 0,10 × 0,80 × 0,10 m |
| `EL-KURK` | [ÜRETİLDİ: `assets/model/nesne/el_kurk_bohca.glb`] chr_004; kürk bohça, fur bundle (`ElEsyasi`). | 0,45 × 0,30 × 0,30 m |
| `EL-HEYBE` | [ÜRETİLDİ: `assets/model/nesne/el_heybe.glb`] chr_005, 009, 010; çift göz heybe, saddlebags (`ElEsyasi`). | 0,65 × 0,40 × 0,25 m |
| `EL-SEPET-BUYUK` | [ÜRETİLDİ: `assets/model/nesne/el_sepet_buyuk.glb`] chr_006, 012; büyük sepet (`ElEsyasi`). | 0,65 × 0,60 × 0,45 m |
| `EL-SANDIK` | [ÜRETİLDİ: `assets/model/nesne/el_sandik.glb`] chr_007; küçük sandık, small chest (`ElEsyasi`). | 0,60 × 0,35 × 0,35 m |
| `EL-ASA` | [ÜRETİLDİ: `assets/model/nesne/el_asa.glb`] chr_008; ahşap asa, staff (`ElEsyasi`). | 0,06 × 1,60 × 0,06 m |
| `EL-DEGNEK` | [ÜRETİLDİ: `assets/model/nesne/el_degnek.glb`] chr_013; eğri değnek, cane (`ElEsyasi`). | 0,08 × 1,00 × 0,08 m |
| `EL-ODUN` | [ÜRETİLDİ: `assets/model/nesne/el_odun.glb`] chr_001; iki odun, firewood (`ElEsyasi`). | 0,25 × 0,60 × 0,20 m |
| `chr_001, 004, 005, 006, 007, 009, 010` | eksik klipler: panik, gergin. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `chr_002, 003, 008, 011–030` | eksik klipler: ofke, gergin. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `asker, ciftci, ciftci_kadin, esnaf, aydogdu, ayse_baci, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf` | eksik klipler: altı duygu klibinin hepsi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `KAR-CAVUS` | [ÜRETİLDİ: `assets/model/karakter/cavus_yuru.glb`] `miraen_cavus` | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAR-TAHSILDAR` | [ÜRETİLDİ: `assets/model/karakter/tahsildar_yuru.glb`] `vergi_tahsildari` (`Dunya3B.PORTRE_MODEL`) | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAR-ELCI` | [ÜRETİLDİ: `assets/model/karakter/tekfur_elcisi_yuru.glb`] `tekfur_elcisi` | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAR-DERVIS` | [ÜRETİLDİ: `assets/model/karakter/dervis_yuru.glb`] `dervis` + `diyalog_21` | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAR-HABERCI` | [ÜRETİLDİ: `assets/model/karakter/haberci_yuru.glb`] `haberci`, `diyalog_29` | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAR-BEY` | [ÜRETİLDİ: `assets/model/karakter/bey_yuru.glb`] `bey_daveti` | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAR-COCUK` | [ÜRETİLDİ: `assets/model/karakter/cocuk_yuru.glb`] Kapı refakatçileri (`aile_kapi_gorunumu.gd`), `diyalog_25`, köy çocukları (`HazirKarakterler`) | 0,40 × 1,15 × 0,30 m |
| `KAR-TEKFUR-ASKER` | [ÜRETİLDİ: `assets/model/karakter/tekfur_askeri_yuru.glb`] Uzak siluet + tekfur askeri | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `YAPI-tarla, bostan` | [ÜRETİLDİ: `assets/model/nesne/tarla.glb`, `bostan.glb`, `dizili_taslar.glb`] düzlem + kutu sap (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-hizarhane` | [ÜRETİLDİ: `assets/model/yapi/hizarhane.glb`] sundurma kutusu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-odunluk` | [ÜRETİLDİ: `assets/model/yapi/odunluk.glb`] aynı sundurma (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-tas_ocagi` | [ÜRETİLDİ: `assets/model/yapi/tas_ocagi.glb`] Poly Haven kaya (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-avci` | [ÜRETİLDİ: `assets/model/yapi/avci_cadiri.glb`] çadır + sırık (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-atolye, demirhane` | [ÜRETİLDİ: `assets/model/yapi/atolye.glb`, `demirhane.glb`] sundurma + sandık (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-ambar` | [ÜRETİLDİ: `assets/model/yapi/ambar.glb`] `kervansaray.glb` (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-firin` | [ÜRETİLDİ: `assets/model/yapi/firin.glb`] ahşap kutu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-degirmen` | [ÜRETİLDİ: `assets/model/yapi/degirmen.glb`] kutu (`DegirmenHareketi`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-sifahane` | [ÜRETİLDİ: `assets/model/yapi/sifahane.glb`] kutu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-ahir` | [ÜRETİLDİ: `assets/model/yapi/ahir.glb`] kutu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-agil` | [ÜRETİLDİ: `assets/model/yapi/agil.glb`] CHR hedefi (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-kirec_kuyusu` | [ÜRETİLDİ: `assets/model/yapi/kirec_kuyusu.glb`] kutu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-tas_ev` | [ÜRETİLDİ: `assets/model/yapi/tas_ev.glb`] kutu, ikon kulübe (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-demir_madeni` | [ÜRETİLDİ: `assets/model/yapi/demir_madeni.glb`] kutu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-demir_ocagi` | [ÜRETİLDİ: `assets/model/yapi/demir_ocagi.glb`] kutu (`koy_yonetim_sahnesi.gd`) | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-muhafiz_kislasi` | [ÜRETİLDİ: `assets/model/yapi/muhafiz_kislasi.glb`] kutu (`koy_yonetim_sahnesi.gd`) | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `YAPI-gozetleme_kulesi` | [ÜRETİLDİ: `assets/model/yapi/gozetleme_kulesi.glb`] menü ve devriye kulesi (`GozcuKulesiGorseli`, `MuhafizDevriyesi`) | 3,0 × 6,0 × 3,0 m; sur modülü 4,0 × 3,0 × 0,6 m |
| `YAPI-pazar_tezgahi` | GLB var, sahne kurmuyor | 6,0 × 3,0 × 5,0 m; hedef yapı zarfı, yerleşimde doğrulanır |
| `YAPI-sur 2–3` | [ÜRETİLDİ: `assets/model/yapi/sur_2_palisat.glb`, `sur_3_tas.glb`] kazık çit ölçeklenir, `SurHasarGorseli`, `koy_yonetim_sahnesi.gd` | 3,0 × 6,0 × 3,0 m; sur modülü 4,0 × 3,0 × 0,6 m |
| `HYV-AT` | [ÜRETİLDİ: `assets/model/hayvan/at.glb` (Antigravity)] Sorhan, Nogay, kervan, TUC, HAR-07 | 0,80 × 1,60 × 2,30 m; deve yüksekliği 2,10 m |
| `HYV-KOYUN` | Ağıl, ANI-05, TUC-02 | 0,45 × 0,80 × 1,10 m; sürü üyeleri ayrı nesne |
| `HYV-KECI` | [ÜRETİLDİ: `assets/model/hayvan/keci.glb` (Antigravity)] Yusuf olayı | 0,45 × 0,80 × 1,10 m; sürü üyeleri ayrı nesne |
| `HYV-DEVE` | [ÜRETİLDİ: `assets/model/hayvan/deve.glb` (Antigravity)] Kervan | 0,80 × 1,60 × 2,30 m; deve yüksekliği 2,10 m |
| `HYV-KOPEK` | [ÜRETİLDİ: `assets/model/hayvan/kopek.glb` (Antigravity)] Gece köy | 0,45 × 0,80 × 1,10 m; sürü üyeleri ayrı nesne |
| `PROP-ORS` | [ÜRETİLDİ: `assets/model/nesne/ors.glb`] Demirhane izi (`ZanaatTezgahi`) | 0,50 × 0,75 × 0,35 m; kütük dahil |
| `PROP-TEZGAH` | [ÜRETİLDİ: `assets/model/nesne/dokuma_tezgahi.glb`] Ayşe / bez (`HazirEsyaHayvan`) | 1,50 × 1,60 × 0,60 m |
| `PROP-AGAC-2` | [ÜRETİLDİ: `assets/model/nesne/agac_02.glb`, `kaya_02.glb`] İkinci ağaç ve kaya modeli (`OduncuRutini`, `KapiManzarasi`) | Ağaç 2,0 × 5,0 × 2,0 m; kaya 1,2 × 0,8 × 1,0 m |
| `ANI-SILAH` | [ÜRETİLDİ: `assets/model/nesne/kilic.glb`, `kalkan.glb`, `mizrak.glb`, `mesale_el.glb`] Kılıç, kalkan, mızrak, meşale soketi (`MuhafizDonanimi`, `ElEsyasi`); glTF, el kemiği. | Kılıç 0,08 × 0,85 × 0,04 m; kalkan çapı 0,60 m; mızrak boyu 2,0 m; alet boyu 0,35–1,20 m |
| `ANI-ALET` | [ÜRETİLDİ: `kova.glb`, `orak.glb`, `balta.glb`, `el_cekic.glb`, `firin_kuregi.glb` (Antigravity)] Kova, orak, balta, örs çekici, fırın küreği; glTF. | Kova 0,30 × 0,35 × 0,30 m; orak 0,40 m; balta 0,60 m; çekiç 0,35 m; kürek 1,20 m |
| `ANI-HAYVAN-SURU` | Öküz yürüyüş, koyun otlama; glTF klip. | Mevcut öküz ve koyun riginde yürüyüş/otlama klibi; model ölçeği korunur |
| `TUC-TACIR` | [ÜRETİLDİ: `assets/model/karakter/celep_yuru.glb`, `nalbur_yuru.glb`, `kumasci_yuru.glb`, `aktar_yuru.glb`, `silah_tuccari_yuru.glb`] Celep, nalbur, kumaşçı, aktar, silah tüccarı (`TuccarKapiGecisi`, `Dunya3B.PORTRE_MODEL`). | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `TUC-HAYVAN` | [ÜRETİLDİ: `inek.glb`, `koc.glb`, `beygir.glb` (Antigravity)] İnek, koç, beygir; glTF. | İnek 0,85 × 1,45 × 2,20 m; koç 0,55 × 0,85 × 1,10 m; beygir 0,80 × 1,60 × 2,30 m |
| `MEV-ZEMIN` | [ÜRETİLDİ: `assets/model/nesne/kurek.glb` (Antigravity)] Kar örtüsü, çatı karı, kürek — prompt hazır, Ahmet üretecek; 3D geometri açık; shader + PNG; `kurek.glb`. | Kürek 0,25 × 1,20 × 0,08 m; kar geometri katmanı mevcut çatı/zemin zarfında |
| `MEV-AFET` | Su bendi, yangın, kurt sürüsü — prompt hazır, Ahmet üretecek; 3D geometri açık; glTF + PNG. | Bent modülü 3,0 × 0,8 × 0,6 m; kurt 0,45 × 0,8 × 1,1 m |
| `CAS-GECE` | Fener, yangın kovası; glTF. | Açık kandil 0,18 × 0,08 × 0,12 m; kova 0,30 × 0,35 × 0,30 m |
| `ODA-ODA` | [ÜRETİLDİ: `assets/model/yapi/muhafiz_odasi.glb`, `yatak.glb`, `masa.glb`, `kasa.glb`, `kutuphane.glb`] Muhafız odası, yatak, masa, kasa, kütüphane (`MuhafizOdasi`). | Oda 4,0 × 2,8 × 4,0 m; yatak 0,9 × 0,5 × 2,0 m; masa 1,2 × 0,75 × 0,7 m |
| `KRI-MEZAR` | Toplu mezar, yazısız taş; glTF. | 2,0 × 0,4 × 1,0 m; işaretsiz taş 0,3 × 0,6 × 0,2 m |
| `ANI07-ISINMA` | İki el ateşe uzatılan ısınma döngüsü; glTF / iskelet animasyon klibi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `ANI08-TEZGAH` | [ÜRETİLDİ: `assets/model/nesne/ors.glb`, `firin_agzi.glb`] Örs ve fırın ağzı (`ZanaatTezgahi`); glTF. | Örs/kütük 0,50 × 0,75 × 0,35 m; fırın ağzı 0,80 × 0,70 × 0,40 m |
| `ANI08-HAREKET` | Çekiç vurma ve fırın küreği döngüsü; glTF / iskelet animasyon klibi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `ANI09-SACAK` | [ÜRETİLDİ: `assets/model/nesne/sacak.glb`] Yağmurdan korunma saçağı (`KarakterHavaTepkisi`); glTF. | 2,00 × 0,25 × 1,20 m; taşıyıcı ev kenarına uygun |
| `ANI09-BUZULME` | Soğukta büzülmüş yürüyüş; glTF / iskelet animasyon klibi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `ANI10-SINSI` | Sinsi yürüyüş ve temkinli kuytu bekleyiş; glTF / iskelet animasyon klibi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `ANI11-ALET` | [ÜRETİLDİ: `el_cekic.glb`, `firin_kuregi.glb` (Antigravity)] Gerçek çekiç ve fırın küreği; sokete hazır tutma noktası; glTF. | Çekiç 0,12 × 0,35 × 0,06 m; kürek 0,20 × 1,20 × 0,06 m |
| `ANI12-IDLE` | Üç doğal bekleme döngüsü (nefes / ağırlık aktarma / çevreye bakış); glTF / iskelet animasyon klibi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `TUC02-OKUZ` | Öküz barınak modeli; glTF. | 0,85 × 1,45 × 2,20 m; ayak tabanı y=0 |
| `TUC02-INEK` | [ÜRETİLDİ: `assets/model/hayvan/inek.glb` (Antigravity)] İnek barınak modeli; glTF. | 0,85 × 1,45 × 2,20 m; ayak tabanı y=0 |
| `TUC02-BEYGIR` | [ÜRETİLDİ: `assets/model/hayvan/beygir.glb` (Antigravity)] Beygir barınak modeli; glTF. | 0,80 × 1,60 × 2,30 m |
| `TUC02-KOC` | [ÜRETİLDİ: `assets/model/hayvan/koc.glb` (Antigravity)] Koç barınak ve sürü modeli; glTF. | 0,55 × 0,85 × 1,10 m |
| `HAR06-KULE` | [ÜRETİLDİ: `assets/model/yapi/gozetleme_kulesi.glb`] Gözcü kulesi yapı modeli (`GozcuKulesiGorseli`); glTF. | 3,0 × 6,0 × 3,0 m; sur modülü 4,0 × 3,0 × 0,6 m |
| `HAR10-YAY` | [ÜRETİLDİ: `assets/model/nesne/yay.glb`] Sur okçusu el yayı (`KonuslanmaDonanimi`); glTF. | 0,08 × 1,10 × 0,35 m |
| `HAR10-MIZRAK` | [ÜRETİLDİ: `assets/model/nesne/mizrak.glb`] Kapı mızraklısı görev mızrağı (`KonuslanmaDonanimi`); glTF. | 0,06 × 2,00 × 0,06 m |
| `MEV05-KUREK` | [ÜRETİLDİ: `assets/model/nesne/kurek.glb` (Antigravity)] Kar küreme küreği ve temizlik klibi; glTF / iskelet klibi. | 0,25 × 1,20 × 0,08 m |
| `MEV10-KURT` | Kurt modeli, yürüyüş ve kaçış klibi; glTF / iskelet klibi. | 0,45 × 0,80 × 1,10 m; sürü üyeleri ayrı nesne |
| `CAS05-DIVAN` | [ÜRETİLDİ: `assets/model/nesne/divan_masasi.glb`, `divan_oturak.glb`] Meydan divan masası ve oturma sıraları (`DivanMeydani`); glTF. | Masa 2,00 × 0,80 × 1,00 m; oturak 0,50 × 0,45 × 0,50 m |
| `CAS07-ZINDAN` | [ÜRETİLDİ: `assets/model/nesne/zindan_kapisi.glb`] Kapı zindan hücresi kapısı (`DivanZindanGorseli`); glTF. | Parmaklık modülü 1,50 × 2,00 × 0,10 m |
| `ODA01-ICMEKAN` | [ÜRETİLDİ: `assets/model/yapi/muhafiz_odasi.glb`] Oda zemin ve duvarları (`MuhafizOdasi`); glTF. | 4,0 × 2,8 × 4,0 m; mevcut oda tabanı y=0 |
| `ODA01-YATAK` | [ÜRETİLDİ: `assets/model/nesne/yatak.glb`] Muhafız yatağı (`MuhafizOdasi`); glTF. | 0,90 × 0,50 × 2,00 m |
| `ODA01-MASA` | [ÜRETİLDİ: `assets/model/nesne/masa.glb`] Muhafız masası (`MuhafizOdasi`); glTF. | 1,20 × 0,75 × 0,70 m |
| `ODA01-MESALE` | [ÜRETİLDİ: `assets/model/nesne/mesale_el.glb`] Oda meşalesi; glTF. | 0,12 × 0,60 × 0,12 m |
| `ODA01-KASA` | [ÜRETİLDİ: `assets/model/nesne/kasa.glb`] Gizli zemin kasası (`MuhafizOdasi`); glTF. | 0,60 × 0,40 × 0,40 m |
| `ODA09-KABUS` | Rüya gölgesi figürü; glTF. | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `ODA08-YATAK` | [ÜRETİLDİ: `assets/model/nesne/rahat_yatak.glb`] Rahat muhafız yatağı (`OdaGelistirmePaneli`); glTF. | 1,10 × 0,55 × 2,00 m |
| `ODA08-ASKILIK` | [ÜRETİLDİ: `assets/model/nesne/askilik.glb`] Donanım askılığı (`MuhafizOdasi`, `OdaGelistirmePaneli`); glTF. | 0,60 × 1,60 × 0,40 m |
| `ODA08-KUTUPHANE` | [ÜRETİLDİ: `assets/model/nesne/kutuphane.glb`] Muhafız kütüphanesi (`MuhafizOdasi`, `OdaGelistirmePaneli`); glTF. | 1,00 × 1,80 × 0,35 m |
| `ODA03-ESYA` | Rüşvet ve kişisel eşya sergi modelleri (mühür, iksir, CHR hediyeleri); glTF / set. | Mühür 0,05 × 0,06 × 0,05 m; iksir 0,06 × 0,15 × 0,06 m; hediye zarfı 0,30 m |
| `KRI05-MEZAR` | Toplu mezar ve cenaze töreni mezar işareti; glTF. | 2,0 × 0,4 × 1,0 m; işaretsiz taş 0,3 × 0,6 × 0,2 m |
| `BUG21-TASYATAGI` | [ÜRETİLDİ: `assets/model/yapi/tas_yatagi.glb`] Kazılabilir taş yatağı (`tas_yatagi_gorseli.gd`); glTF / 3B model. | 3,0 × 0,6 × 2,0 m; açık taş yatağı |
| `BUG25-MESALE` | Kapı meşalesi gerçek modeli (gerekirse); glTF / 3B model. | 0,12 × 0,60 × 0,12 m; mevcut sokete uygun |
| `BUG25-KUYU` | Köy kuyusu gerçek modeli (gerekirse); glTF / 3B model. | 1,20 × 1,20 × 1,20 m; taban y=0, mevcut kuyu yüksekliği korunur |
| `ACL01-MUHAFIZ` | [ÜRETİLDİ: `assets/model/karakter/muhafiz_yuru.glb`] Muhafız gövdesi (`HazirKarakterler`, `acilis_hane_gorunumu.gd`); glTF / 3B model. | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `ACL01-ES` | [ÜRETİLDİ: `assets/model/karakter/muhafiz_esi_yuru.glb`] Muhafızın eşi gövdesi (`HazirKarakterler`, `ilk_aile_es_kadraji.gd`, `acilis_hane_gorunumu.gd`); glTF / 3B model. | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `KAP17-COCUK` | Çocuk köylü modeli; glTF / 3B model. | 0,40 × 1,15 × 0,30 m |
| `KAP17-YASLI` | [ÜRETİLDİ: `assets/model/karakter/yasli_yuru.glb`] Yaşlı köylü modeli (`aile_kapi_gorunumu.gd`, `HazirKarakterler`, `aile_yas_gorunumu.gd`); glTF / 3B model. | 0,55 × 1,65 × 0,40 m |
| `CAT02-KAVGA` | Kapıda kavga canlandırması; glTF / iskelet animasyon klibi. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |
| `ISG02-ALETLER` | [ÜRETİLDİ: `kurek.glb`, `el_sepet.glb`, `su_kabi.glb`, `kirmen.glb`, `bakim_bezi.glb` (Antigravity)] Geçici işlere özel el aletleri; glTF. | Kürek 0,20 × 1,20 × 0,08 m; sepet 0,35 × 0,35 × 0,35 m; su kabı 0,25 × 0,40 × 0,25 m; kirmen 0,05 × 0,30 × 0,05 m; bakım bezi 0,25 × 0,25 m. |
| `YAP03-USTALAR` | [ÜRETİLDİ: `assets/model/karakter/usta_yuru.glb`] Kapıdan gelen usta modelleri (`Dunya3B.PORTRE_MODEL`, `HazirKarakterler`); glTF / 3B model. | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `YAP05-ODA` | [ÜRETİLDİ: `assets/model/yapi/cozumleme_odasi.glb`] Çözümleme odası modeli (`cozumleme_oda_yer_tutucu.gd`); glTF / 3B model. | 4,0 × 2,8 × 4,0 m |
| `DYL02-AYRINTI-*` | Karakter ayrıntıları: yamalı çarık, nasırlı el, sarılı yara, yanık giysi — prompt hazır, Ahmet üretecek; 3D geometri açık; glTF / doku. | Çarık 0,12 × 0,08 × 0,28 m; el/yara/giysi mevcut karakter rigine bağlı, ölçek değişmez |
| `DYL03-YEMIN` | Yemin nesneleri (dünya kitabına göre); glTF. | 0,30 × 0,30 × 0,30 m; elde taşınan nesne zarfı |
| `DYL09-DENETCI` | [ÜRETİLDİ: `assets/model/karakter/denetci_yuru.glb`] Beyin denetçisi modeli; glTF / 3B model. | 0,55 × 1,75 × 0,40 m; yetişkin insan, ayak tabanı y=0 |
| `SEV03-IZ` | Kişisel iz; glTF. | 0,30 × 0,30 × 0,30 m; elde taşınan nesne zarfı |
| `SAB03-ORTU` | Kapalı iş yeri örtüsü — prompt hazır, Ahmet üretecek; 3D geometri açık; glTF / doku. | 1,50 × 1,00 × 0,80 m; örtü aynı taşıyıcının zarfına oturur |
| `TEZ01-ORTU` | Dört tezgâh örtüsü (ağıl kirli beyaz, değirmen taş gri, demir is, bez ham) — prompt hazır, Ahmet üretecek; 3D geometri açık; glTF / doku. | 1,50 × 1,00 × 0,80 m; örtü aynı taşıyıcının zarfına oturur |
| `TEZ03-HAM` | Ham blok; glTF. | 0,30 × 0,30 × 0,30 m |
| `TEZ04-IZ` | İz bloğu; glTF. | 0,30 × 0,30 × 0,30 m; elde taşınan nesne zarfı |
| `TEZ05-BICIM` | Biçim bloğu; glTF. | 0,30 × 0,30 × 0,30 m; elde taşınan nesne zarfı |
| `TEZ06-AGIZ` | Ağız bloğu; glTF. | 0,30 × 0,30 × 0,30 m; elde taşınan nesne zarfı |
| `TEZ08-PARCA` | Teslim parçası; glTF. | 0,30 × 0,30 × 0,30 m; elde taşınan nesne zarfı |
| `B4-ILERI-KLIPLER` | kos, otur, orak, cekic, nobet, saldir, dus, yagmur_yuru, kar_yuru — bir ileri 3D klip grubu. | Mevcut insan rigine uyum; yetişkin boyu 1,65–1,80 m (ölçek değişmez) |


### Diyalog ve Anlatı 2D Parçaları (Görev 13 — Antigravity)

Görev 6, 8 ve 13 kapsamında derinleştirilen 10 ziyaretçi (21-30), muhafızın eşi, 8 köy olayı kartı, defter/söylenti görselleri ve 5 oyun sonu için hazırlanan 27 tekil 2D parçadır. Tam İngilizce Nano Banana promptları ve Türkçe karakter tarifleri [Diyalog Asset Promptları](arayuz/DIYALOG_ASSET_PROMPTLARI.md) belgesindedir.

| Kaynak ID | Nihai dosya | Boyut (px) | Saydamlık / kaynak zemin | Hazır prompt |
|---|---|---|---|---|
| `PORTRE-DYS-021` | `assets/art/char/char_dervis_baba_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-021](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-021) |
| `PORTRE-DYS-022` | `assets/art/char/char_tuccar_tebrizli_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-022](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-022) |
| `PORTRE-DYS-023` | `assets/art/char/char_cavus_sungur_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-023](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-023) |
| `PORTRE-DYS-024` | `assets/art/char/char_vebali_ana_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-024](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-024) |
| `PORTRE-DYS-025` | `assets/art/char/char_firinci_dursun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-025](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-025) |
| `PORTRE-DYS-026` | `assets/art/char/char_cerrah_lokman_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-026](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-026) |
| `PORTRE-DYS-027` | `assets/art/char/char_katip_sukru_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-027](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-027) |
| `PORTRE-DYS-028` | `assets/art/char/char_banu_hatun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-028](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-028) |
| `PORTRE-DYS-029` | `assets/art/char/char_kafile_habercisi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-029](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-029) |
| `PORTRE-DYS-030` | `assets/art/char/char_yetim_turna_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-030](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-030) |
| `PORTRE-DYS-ES` | `assets/art/char/char_muhafiz_esi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-ES](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-es) |
| `KART-OLAY-01` | `assets/art/events/event_kavga_harman.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-01](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-01) |
| `KART-OLAY-02` | `assets/art/events/event_ambarda_hirsizlik.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-02](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-02) |
| `KART-OLAY-03` | `assets/art/events/event_salgin_fisiltisi.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-03](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-03) |
| `KART-OLAY-04` | `assets/art/events/event_koy_dugunu.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-04](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-04) |
| `KART-OLAY-05` | `assets/art/events/event_firari_cenazesi.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-05](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-05) |
| `KART-OLAY-06` | `assets/art/events/event_samanlik_yangini.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-06](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-06) |
| `KART-OLAY-07` | `assets/art/events/event_gece_donu.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-07](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-07) |
| `KART-OLAY-08` | `assets/art/events/event_harami_elcisi.png` | 800×450 | Opak RGB | [Prompt KART-OLAY-08](arayuz/DIYALOG_ASSET_PROMPTLARI.md#kart-olay-08) |
| `UI-DEFTER-DERI` | `assets/art/ui/ui_defter_kapak_deri.png` | 512×512 | RGBA; düz #00FF00 | [Prompt UI-DEFTER-DERI](arayuz/DIYALOG_ASSET_PROMPTLARI.md#ui-defter-deri) |
| `UI-DEFTER-PARSOMEN` | `assets/art/ui/ui_defter_sayfa_parsomen.png` | 512×512 | RGBA; düz #00FF00 | [Prompt UI-DEFTER-PARSOMEN](arayuz/DIYALOG_ASSET_PROMPTLARI.md#ui-defter-parsomen) |
| `UI-SOYLENTI-AGI` | `assets/art/ui/icon_soylenti_agi.png` | 512×512 | RGBA; düz #00FF00 | [Prompt UI-SOYLENTI-AGI](arayuz/DIYALOG_ASSET_PROMPTLARI.md#ui-soylenti-agi) |
| `SON-DYS-TEKFUR` | `assets/art/env/son_tekfur_haraccisi_cinar.png` | 1920×1080 | Opak RGB | [Prompt SON-DYS-TEKFUR](arayuz/DIYALOG_ASSET_PROMPTLARI.md#son-dys-tekfur) |
| `SON-DYS-ERTUGRUL` | `assets/art/env/son_ertugrul_obasi_sancak.png` | 1920×1080 | Opak RGB | [Prompt SON-DYS-ERTUGRUL](arayuz/DIYALOG_ASSET_PROMPTLARI.md#son-dys-ertugrul) |
| `SON-DYS-AHI` | `assets/art/env/son_ahi_kasabasi_refah.png` | 1920×1080 | Opak RGB | [Prompt SON-DYS-AHI](arayuz/DIYALOG_ASSET_PROMPTLARI.md#son-dys-ahi) |
| `SON-DYS-KURTULUS` | `assets/art/env/son_veba_karantina_kurtulus.png` | 1920×1080 | Opak RGB | [Prompt SON-DYS-KURTULUS](arayuz/DIYALOG_ASSET_PROMPTLARI.md#son-dys-kurtulus) |
| `SON-DYS-DIRENIS` | `assets/art/env/son_harami_kusatmasi_direnis.png` | 1920×1080 | Opak RGB | [Prompt SON-DYS-DIRENIS](arayuz/DIYALOG_ASSET_PROMPTLARI.md#son-dys-direnis) |


### Ziyaretçi ve Köylü Portreleri (Görev 14 — Antigravity)

Görev 14 kapsamında tamamlanan 20 ziyaretçi portresi (01–20) ve 10 isimli köylü portresi için hazırlanan 30 tekil 2D parçadır. Tam İngilizce Nano Banana promptları ve Türkçe karakter tarifleri [Diyalog Asset Promptları](arayuz/DIYALOG_ASSET_PROMPTLARI.md) belgesindedir.

| Kaynak ID | Nihai dosya | Boyut (px) | Saydamlık / kaynak zemin | Hazır prompt |
|---|---|---|---|---|
| `PORTRE-DYS-001` | `assets/art/char/char_rencber_hamza_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-001](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-001) |
| `PORTRE-DYS-002` | `assets/art/char/char_kayserili_cuhaci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-002](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-002) |
| `PORTRE-DYS-003` | `assets/art/char/char_bozgun_neferi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-003](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-003) |
| `PORTRE-DYS-004` | `assets/art/char/char_coban_yusuf_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-004](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-004) |
| `PORTRE-DYS-005` | `assets/art/char/char_demirci_hasan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-005](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-005) |
| `PORTRE-DYS-006` | `assets/art/char/char_silahsiz_piyade_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-006](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-006) |
| `PORTRE-DYS-007` | `assets/art/char/char_seyyar_kalayci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-007](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-007) |
| `PORTRE-DYS-008` | `assets/art/char/char_tasci_kalfasi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-008](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-008) |
| `PORTRE-DYS-009` | `assets/art/char/char_firinci_ali_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-009](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-009) |
| `PORTRE-DYS-010` | `assets/art/char/char_sarac_kalfasi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-010](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-010) |
| `PORTRE-DYS-011` | `assets/art/char/char_yarali_nobetci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-011](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-011) |
| `PORTRE-DYS-012` | `assets/art/char/char_surgun_katip_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-012](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-012) |
| `PORTRE-DYS-013` | `assets/art/char/char_dervis_burhan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-013](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-013) |
| `PORTRE-DYS-014` | `assets/art/char/char_kacak_madenci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-014](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-014) |
| `PORTRE-DYS-015` | `assets/art/char/char_turkmen_anasi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-015](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-015) |
| `PORTRE-DYS-016` | `assets/art/char/char_tovbekar_harami_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-016](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-016) |
| `PORTRE-DYS-017` | `assets/art/char/char_degirmenci_mihali_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-017](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-017) |
| `PORTRE-DYS-018` | `assets/art/char/char_avci_kara_bekir_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-018](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-018) |
| `PORTRE-DYS-019` | `assets/art/char/char_asik_kul_dertli_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-019](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-019) |
| `PORTRE-DYS-020` | `assets/art/char/char_seyyar_nalbant_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-DYS-020](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-dys-020) |
| `PORTRE-KOY-AYDOGDU` | `assets/art/char/char_aydogdu_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-AYDOGDU](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-aydogdu) |
| `PORTRE-KOY-AYSE-BACI` | `assets/art/char/char_ayse_baci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-AYSE-BACI](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-ayse-baci) |
| `PORTRE-KOY-HASAN-CELEBI` | `assets/art/char/char_hasan_celebi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-HASAN-CELEBI](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-hasan-celebi) |
| `PORTRE-KOY-KARACA-USTA` | `assets/art/char/char_karaca_usta_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-KARACA-USTA](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-karaca-usta) |
| `PORTRE-KOY-MIRAEN` | `assets/art/char/char_miraen_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-MIRAEN](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-miraen) |
| `PORTRE-KOY-NOGAY` | `assets/art/char/char_nogay_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-NOGAY](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-nogay) |
| `PORTRE-KOY-SARUCA-HATUN` | `assets/art/char/char_saruca_hatun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-SARUCA-HATUN](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-saruca-hatun) |
| `PORTRE-KOY-SORHAN` | `assets/art/char/char_sorhan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-SORHAN](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-sorhan) |
| `PORTRE-KOY-THESSRA` | `assets/art/char/char_thessra_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-THESSRA](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-thessra) |
| `PORTRE-KOY-YUSUF` | `assets/art/char/char_yusuf_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | [Prompt PORTRE-KOY-YUSUF](arayuz/DIYALOG_ASSET_PROMPTLARI.md#portre-koy-yusuf) |

## Ses ve diğer görsel dışı ihtiyaçlar

Ses/müzik, font ve GPL/ASE palet dosyaları 2D resim değildir; Nano Banana ile üretilmez, 3D kuyruğuna da sokulmaz. Ses ihtiyaçları kaynak taramasının A3 ve C3 bölümlerinde korunur. Mevcut fontlar ve teslim edilmiş modeller yeniden eksik sayılmaz. Lisans/kaynak kayıtları silinmemiştir.

## H. ROADMAP 2 (ARY-05)

Kimlik izleme tablosu: önceki ARY-05/SRM-18 kaynak satırları korunur. Aktif üretim türü, dosya, ölçü ve prompt yukarıdaki 2D / 3D bölümünde bulunur. Yeni ihtiyaç aynı tip bölümüne eklenir; ROADMAP Asset satırına eklenen kimliğin bu izleme tablosu da korunur.

ROADMAP 2 maddelerinin `Asset:` satırlarında "envantere" denen her kimlik burada **bir kez** durur; kimliği yol haritasında olmayan satır ve ikinci satır hatadır. Liste ses dosyası istemez; bu bölümde wav satırı yoktur. Bu madde dosya üretmez. Satırlar madde kapandıkça güncellenir; kodlanmamış maddenin yer tutucusu "planlı" yazar. `BUG21-TASYATAGI`, `ACL01-MUHAFIZ`, `ACL01-ES` G bölümünden buraya taşındı. Denetim: `tests/tools/test_asset_envanteri.py`.

| ID | ROADMAP | Ne | Tür / format | Yer tutucu yolu | Anahtar kelimeler (TR + EN) | Öncelik | Ekleyen |
|---|---|---|---|---|---|---|---|
| SAH-EL-TORBA | SAH-16 | CHR-002 keten torba, gövde temasını azalt | 3B temas düzeltmesi | res://src/dunya/el_esyasi.gd (_torba, mevcut torba) | keten torba, avuç tutuşu; linen sack, palm grip | düşük | Kalfa |
| SAH-EL-CEKIC | SAH-16 | CHR-003 ve CHR-029 el çekici, gövde temasını azalt | 3B temas düzeltmesi | res://assets/esya/kaykit_alet/hammer.gltf | küçük el çekici, sap; small hand hammer, handle | düşük | Kalfa |
| SAH-EL-ASA | SAH-16 | CHR-008 ahşap asa, gövde temasını azalt | 3B temas düzeltmesi | res://src/dunya/el_esyasi.gd (_asa, mevcut dik asa) | düz ahşap asa, tutuş; straight wooden staff, grip | düşük | Kalfa |
| SAH-EL-DEGNEK | SAH-16 | CHR-014 eğri değnek, gövde temasını azalt | 3B temas düzeltmesi | res://src/dunya/el_esyasi.gd (_asa, mevcut eğri değnek) | eğri ahşap değnek, tutuş; curved wooden cane, grip | düşük | Kalfa |
| SAH-EL-SEPET | SAH-16 | CHR-015 hasır sepet, gövde temasını azalt | 3B temas düzeltmesi | res://src/dunya/el_esyasi.gd (_sepet, mevcut sepet) | kulplu hasır sepet; handled wicker basket | düşük | Kalfa |
| SAH-EL-KAZMA | SAH-16 | CHR-019 kazma, gövde temasını azalt | 3B temas düzeltmesi | res://assets/esya/kaykit_alet/pickaxe.gltf | tahta saplı kazma, tutuş; wooden-handled pickaxe, grip | düşük | Kalfa |
| SAH-EL-KILE | SAH-16 | CHR-030 ahşap kile, gövde temasını azalt | 3B temas düzeltmesi | res://src/dunya/el_esyasi.gd (_kile, mevcut ölçek) | ahşap kile, tahıl ölçeği; wooden grain measure, scoop | düşük | Kalfa |
| BUG21-TASYATAGI | BUG-21 | Kazılabilir başlangıç ve kurtarıcı taş yatağı modeli | glTF / 3B model | Meshy ile üretildi: `assets/model/yapi/tas_yatagi.glb` (`res://src/koy/gorsel/tas_yatagi_gorseli.gd`) | taş yatağı kaya öbeği taş toplama; stone deposit rock pile gathering | yüksek | Codex |
| BUG25-MESALE | BUG-25 | Kapı meşalesi gerçek modeli (gerekirse) | glTF / 3B model | res://assets/model/nesne/mesale.glb (duran modelin düzeltilmiş hali) | kapı meşalesi duvar; medieval gate wall torch | orta | Claude |
| BUG25-KUYU | BUG-25 | Köy kuyusu gerçek modeli (gerekirse) | glTF / 3B model | res://assets/model/nesne/kuyu.glb (duran modelin düzeltilmiş hali) | taş köy kuyusu; medieval stone village well | orta | Claude |
| ACL01-MUHAFIZ | ACL-01 | 13. yy Anadolu muhafız gövdesi | glTF / 3B model | Meshy ile üretildi: `assets/model/karakter/muhafiz_yuru.glb` (`HazirKarakterler`, `acilis_hane_gorunumu.gd`) | Anadolu muhafız Selçuklu köylü; Anatolian medieval Seljuk guard villager | orta | Kalfa |
| ACL01-ES | ACL-01 | Muhafızın eşi gövdesi | glTF / 3B model | Meshy ile üretildi: `assets/model/karakter/muhafiz_esi_yuru.glb` (`HazirKarakterler`, `ilk_aile_es_kadraji.gd`, `acilis_hane_gorunumu.gd`) | Anadolu köylü kadın Selçuklu eş; Anatolian medieval female villager spouse | orta | Kalfa |
| ACL04-ARASAHNE | ACL-04 | Sancak Beyi ulağı ara sahne arka planı — prompt hazır, Ahmet üretecek | PNG 1920×1080 | res://src/arayuz/koy_hud/kapi_acilis_paneli.gd (ColorRect + kısa isim etiketi; ARY-04 entegrasyonu üretim sonu) | ulak berat ara sahne akşam; medieval courier cutscene dusk | yüksek | Claude |
| KAP17-COCUK | KAP-17 | Çocuk köylü modeli | glTF / 3B model | Meshy ile üretildi: `assets/model/karakter/cocuk_yuru.glb` (`aile_kapi_gorunumu.gd`, `HazirKarakterler`, `aile_yas_gorunumu.gd`) | Anadolu köylü çocuk; medieval anatolian peasant child | yüksek | Claude |
| KAP17-YASLI | KAP-17 | Yaşlı köylü modeli | glTF / 3B model | Meshy ile üretildi: `assets/model/karakter/yasli_yuru.glb` (`aile_kapi_gorunumu.gd`, `HazirKarakterler`, `aile_yas_gorunumu.gd`) | Anadolu yaşlı köylü; medieval anatolian elder peasant | yüksek | Claude |
| ZAR01-ZAR | ZAR-01 | Görünür zar (d6, d12) — prompt hazır, Ahmet üretecek | PNG / SVG + 3B isteğe bağlı | 3B model Meshy ile üretildi: `assets/model/nesne/zar.glb` (`Dunya3B.nesne("zar")`) | kemik zar d6 d12; medieval bone dice d6 d12 | yüksek | Claude |
| CAT02-KAVGA | CAT-02 | Kapıda kavga canlandırması | glTF / iskelet animasyon klibi | yer tutucu sarsıntı + metin oyuna bağlandı (`src/kapi/kapi_kavgasi_paneli.gd`); gerçek animasyon hâlâ eksik | kapı itişme kavga; medieval gate scuffle brawl animation | orta | Claude |
| ISG02-ALETLER | ISG-02 | Geçici işler: kürek, dal sepeti, su kabı, kirmen ve bakım bezi | glTF | Mekanik (Kalfa): mevcut köylü figürü ve kartta iş adı; özel alet görseli henüz bağlanmadı. Entegrasyon noktası `src/dunya/karakter_ekipman_yoneticisi.gd` (ANI-11); mevcut kutu soketi korunur. | ortaçağ el aleti kürek kirmen su kabı; medieval shovel spindle basket water jug tools | orta | Claude (ilk kayıt), Kalfa (mekanik durumu) |
| YAP03-USTALAR | YAP-03 | Kapıdan gelen usta modelleri | glTF / 3B model | Meshy ile üretildi: `assets/model/karakter/usta_yuru.glb` (`Dunya3B.PORTRE_MODEL`, `HazirKarakterler`) | Selçuklu usta zanaatkâr; seljuk master craftsman | orta | Claude |
| YAP04-DEFTER | YAP-04 | Usta defteri ikonu — prompt hazır, Ahmet üretecek | SVG / PNG | planlı — madde kodlanınca: düz ColorRect + etiket | usta defteri kitap; medieval master's notebook icon | orta | Claude |
| YAP05-ODA | YAP-05 | Çözümleme odası modeli | glTF / 3B model | Meshy ile üretildi: `assets/model/yapi/cozumleme_odasi.glb` (`cozumleme_oda_yer_tutucu.gd`) | araştırma odası masa; medieval study workshop room | orta | Claude |
| YAP06-ESYA | YAP-06 | Özel eşya ikonları — prompt hazır, Ahmet üretecek; ortak ikon, türler YAP-06 tanımını bekler | SVG / PNG | planlı — madde kodlanınca: düz ColorRect + etiket | özel eşya ikon; medieval special item icons | orta | Claude |
| YSM01-IKON | YSM-01 | Açlık, yorgunluk, moral bar ikonları — prompt hazır, Ahmet üretecek | SVG / PNG | planlı — madde kodlanınca: düz ColorRect | açlık yorgunluk moral ikon; hunger fatigue morale icons | yüksek | Claude |
| ARY01-* | ARY-01 | Görsel dil şablonları: doku, çerçeve, yazı tipi — prompt hazır, Ahmet üretecek; çerçeve: mevcut UI paketi; font mevcut lisanslı kaynak | PNG / SVG / font | planlı — madde kodlanınca: StyleBoxFlat | Selçuklu çini çerçeve parşömen; seljuk tile frame parchment UI | yüksek | Claude |
| ARY03-* | ARY-03 | Ekran arka planları (sorgu, seçim, köy HUD) — prompt hazır, Ahmet üretecek; sorgu: mevcut UI yeniden üretim listesi | PNG 1920×1080 | planlı — madde kodlanınca: düz renk | uç kapısı gece arka plan; frontier gate night background | orta | Claude |
| ARY03-HARITA | GRV-05 / ARY-03 | Harita ekranı arka planı — prompt hazır, Ahmet üretecek | PNG / SVG | res://src/arayuz/harita_ekrani.gd (düz renk) | ortaçağ Anadolu harita parşömen; medieval anatolia parchment map | orta | Claude |
| ARY04-YUKLEME-01 | ARY-04 | Yükleme görseli 1 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-02 | ARY-04 | Yükleme görseli 2 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-03 | ARY-04 | Yükleme görseli 3 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-04 | ARY-04 | Yükleme görseli 4 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-05 | ARY-04 | Yükleme görseli 5 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-06 | ARY-04 | Yükleme görseli 6 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-07 | ARY-04 | Yükleme görseli 7 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| ARY04-YUKLEME-08 | ARY-04 | Yükleme görseli 8 — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + satır | uç köyü yükleme ekranı; frontier village loading screen | orta | Claude |
| DYL02-AYRINTI-* | DYL-02 | Karakter ayrıntıları: yamalı çarık, nasırlı el, sarılı yara, yanık giysi — prompt hazır, Ahmet üretecek; 3D geometri açık | glTF / doku | planlı — madde kodlanınca: modelin bölgesinde düz renkli küçük kutu + gözlem metni | yamalı çarık nasırlı el yara; patched sandals calloused hands wound | yüksek | Claude |
| DYL03-YEMIN | DYL-03 | Yemin nesneleri (dünya kitabına göre) | glTF | yer tutucu kutu+etiket oyuna bağlandı (`src/soz/yemin_adaptoru.gd`); gerçek nesne hâlâ eksik | yemin ekmek tuz kitap; oath bread salt holy book | orta | Claude |
| DYL07-OCAK | DYL-07 | Ocak başı ara sahne arka planı — prompt hazır, Ahmet üretecek | PNG 1920×1080 | planlı — madde kodlanınca: düz renk + metin, ARY-04 çerçevesi | ocak başı akşam ev içi; hearth evening cottage interior | orta | Claude |
| DYL09-DENETCI | DYL-09 | Beyin denetçisi modeli | glTF / 3B model | Meshy ile üretildi: ssets/model/karakter/denetci_yuru.glb (Dunya3B.PORTRE_MODEL) | Selçuklu bey denetçi memur; seljuk inspector official | orta | Claude |
| SEV03-IZ | SEV-03 | Kişisel iz | glTF | planlı — madde kodlanınca: düz renk küçük kutu | kişisel eşya hatıra; personal keepsake trinket | düşük | Claude |
| SAB03-ORTU | SAB-03 | Kapalı iş yeri örtüsü — prompt hazır, Ahmet üretecek; 3D geometri açık | glTF / doku | planlı — madde kodlanınca: düz renk bez, ANI-08 düğümü üstünde | kapalı tezgâh örtü bez; covered workshop cloth | düşük | Claude |
| TEZ01-ORTU | TEZ-01 | Dört tezgâh örtüsü (ağıl kirli beyaz, değirmen taş gri, demir is, bez ham) — prompt hazır, Ahmet üretecek; 3D geometri açık | glTF / doku | planlı — madde kodlanınca: düz renk | tezgâh örtüsü ağıl değirmen demirhane; workshop cover sheepfold mill forge | düşük | Claude |
| TEZ03-HAM | TEZ-03 | Ham blok | glTF | planlı — madde kodlanınca: düz renk küp, örtünün üstünde | ham malzeme blok; raw material block | düşük | Claude |
| TEZ04-IZ | TEZ-04 | İz bloğu | glTF | planlı — madde kodlanınca: aynı küp, bir kenarı koyu | işlenmiş iz blok; worked material block | düşük | Claude |
| TEZ05-BICIM | TEZ-05 | Biçim bloğu | glTF | planlı — madde kodlanınca: küp, etikette işin adı | biçimlenmiş parça; shaped workpiece | düşük | Claude |
| TEZ06-AGIZ | TEZ-06 | Ağız bloğu | glTF | planlı — madde kodlanınca: küp, bir ucu açık renk | bıçak ağzı kenar; blade edge workpiece | düşük | Claude |
| TEZ07-TITREME | TEZ-07 | Çırak titreme çizgisi — prompt hazır, Ahmet üretecek | doku / çizgi | planlı — madde kodlanınca: blok üstünde eğri tek çizgi | titrek çizgi kusur; shaky line flaw mark | düşük | Claude |
| TEZ08-PARCA | TEZ-08 | Teslim parçası | glTF | planlı — madde kodlanınca: düz renk, yüzde küçük kutu | bitmiş zanaat parçası; finished craft piece | düşük | Claude |
| SRM18-IKON | SRM-18 | Pencere ve dosya ikonu — prompt hazır, Ahmet üretecek | ICO / PNG | planlı — madde kodlanınca: Godot varsayılan ikonu | kapı muhafızı oyun ikonu; game app icon gate | düşük | Claude |

KAP-17 notu (2 Kasım 2026, Kalfa): KAP17-COCUK/YASLI ihtiyaçları yukarıdaki mevcut 3D satırlarında güncellendi; yeni asset üretilmedi/indirilmedi. Kapıdaki refakatçiler isimli BoxMesh, köyde çocuk mevcut LOWPO, yaşlı mevcut yetişkin yer tutucusudur. Boy hedefleri mevcut 1,15 m / 1,65 m. Yaşlı modeli tamamlandı sayılmaz; yeni 2D ihtiyacı yok.
