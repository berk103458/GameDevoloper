# Kapı Muhafızı — Kapsamlı Cilalama Planı

> **Durum:** Araştırma ve Planlama Tamamlandı (Tur 1–6) · **Kapsam:** Kod/sahne/asset değişikliği içermez; uygulama ajanları (Cursor, Codex, Antigravity) için tek doğrulanmış iş sırasıdır.  
> **Hedef Dal:** `claude/festive-volta-li1sfm` (`Godot 4.7.2.stable`, GDScript, 3B) · **Bağlayıcı Kaynaklar:** `AGENTS.md`, `ROADMAP_4.md` (Kararlar `A1–F2`), `ROADMAP_2.md`, `docs/ROADMAP_4_ON_RAPOR.md`, `docs/meshy/TOPLULUK_INCELEME.md`, `docs/MESHY_URETIM_SISTEMI.md`, `docs/arayuz/ARAYUZ_ARASTIRMA_RAPORU.md`, `docs/EKSIK_ASSET_ENVANTERI.md`.

---

## 1. Özet

Ahmet'in oynanabilir durum denetiminde tespit ettiği dört temel sorun, var olan içeriğin **kalitesiz olmasından değil oyuna yarım veya normalizasyonsuz bağlanmasından** kaynaklanmaktadır:

1. **Yapı modelleri inşada ve tamamlandığında görünmüyor:** `src/dunya/koy_yonetim_sahnesi.gd:302` içindeki `HazirKoyYapilari.kur()` (`src/koy/gorsel/hazir_koy_yapilari.gd:6-46`) `KAPALI` listesindeki 8 yapının (`kulube`, `tas_ev`, `ambar`, `sifahane`, `firin`, `demirhane`, `atolye`, `kisla`) üstüne tam kapalı **Quaternius MegaKit** kutu bina örüp Meshy `.glb` modelini bunun içine (`Vector3.ZERO`) gizlemektedir. Ayrıca `"kisla"` != `"muhafiz_kislasi"` isim uyuşmazlığı vardır; inşaat aşamasında `_iskele()` yalnızca 4 çubuk + korkuluk diker.
2. **Ölçek, taban, pivot ve yön normalizasyonu yok:** `Dunya3B.nesne()` (`src/dunya/dunya3b.gd:188-255`) yalnızca `yukseklik / kutu.size.y` oranıyla ölçekler; `X/Z` taşmasını denetlemez. `Armature` kök düğümü `0.01` ölçekli iskeletli GLB'lerde `_kutu()` (`dunya3b.gd:264-278`) gerçek vertex AABB yerine santimetre-metre çarpımlı ham kutuyu ölçer (`k04_tavuk.glb` raw `0.0156 m` → `26.92x` ölçek; `k05_at.glb` raw `0.000033 m`; `k13_koyun.glb` raw `0.000167 m`). `ahir.glb` ham Z derinliği `0.061 m` iken `y=2.8` ölçeklendiğinde `4.10 × 2.80 × 0.26 m` kâğıt gibi ince kalır; `muhafiz_kislasi.glb` ise `4 × 4 m` parseline `7.96 × 2.80 × 6.40 m` olarak taşar.
3. **Animasyonlu modellerin klipleri oynatılmıyor:** `k04_tavuk` (`Walking`, `Running`, `RunFast`), `k05_at`, `k13_koyun`, `k09_okcu_pers`, `k12_ortacag_tuccari` ve `ekstra/` satıcı kadını `AnimationPlayer` kliplerini oynatan ortak bir döngüden yoksundur. `HazirEsyaHayvan.hayvan("kopek")` (`src/koy/gorsel/hazir_esya_hayvan.gd:32-42`) klipli `assets/hayvan/styloo/kopek.glb` yerine statik `assets/model/hayvan/kopek.glb`'yi seçer; `kopek_kur()` (`hazir_esya_hayvan.gd:129`) `"idle"` ararken klip adı `"iddle"` yazıldığı için idle hiç çalışmaz.
4. **Arayüz ve ses yarıda kalmış:** `assets/ui/atmosfer/gece_kapisi/` altında 44 temizlenmiş PNG hazır dururken `MenuEkrani`, `KapiEkrani`, `KoyEkrani` ve yardımcı ekranlar hâlâ düz `StyleBoxFlat` / `ColorRect` / `CerceveKutu` kullanmaktadır. Ayrıca `ROADMAP_2.md`'deki `ARY-01` için Usta/Berk'in `parsomen` seçimiyle Ahmet'in düz/parşömen şablon reddi arasında açık karar çelişkisi vardır. Ses tarafında `assets/ses/` içindeki 72 ses dosyası `-37.5 dB` ile `-15.5 dB` RMS arasında **22 dB** seviye farkı taşır; `koy_ortam_sesi.gd:9` `ROADMAP_4` **D2** kararındaki `Master -> Muzik, Efekt, Ortam` yerine `"Efekt"` altında `"Ambiance"` bus'ı açar.

Bu plan, **F0–F6** fazlarında **22 atomik cilalama maddesi (`CIL-01`..`CIL-22`)**, her biri için kod/dosya hedefleri, önerilen ajan sahipleri (Berk/Usta `[EMIR]` sınırlarına saygılı), hedefli `quit(1)` headless testleri ve Nano Banana 2D / CC0–CC-BY ses eylem listeleri sunar.

---

## 2. Mevcut Durum (Tur 1–2 Tarama Sonuçları)

### 2.1. Oyunun Bugünkü Akışı, Ekranlar ve HUD Envanteri

`project.godot:27-32` pencere tabanı `1920×1080` (`window_width_override=1600`, `viewport_height=900`, `stretch/mode="canvas_items"`, `stretch/aspect="expand"`). Akışı `src/arayuz/ana.gd` yönetir:

| Aşama / Ekran | Sınıf / Dosya | İçerdiği Paneller ve Göstergeler | Veri Kaynağı (`src/`) | Bugünkü Görsel / UX Durumu |
|---|---|---|---|---|
| **Yükleme Örtüsü** | `VarlikYuklemePaneli` (`src/arayuz/varlik_yukleme_paneli.gd:1-57`) | Tam ekran `ColorRect`, ortalanmış ilerleme `Label` (`%d/%d`) | `VarlikOnbellek` (`varlik_akis_denetimi.gd`) | Düz `Kabuk.zemin()` rengi; `gece_kapisi/loading_bg.png`, `loading_track.png`, `loading_fill.png` bağlı değil. |
| **Ana Menü** | `MenuEkrani` (`src/arayuz/menu_ekrani.gd:1-192`) | `MenuSahnesi` 3B gece sahnesi (`SubViewport`, `satir 38`) + sol koyu gölge + başlık + `MenuSusu` vektör çizimi + 4 ikonlu `MenuSatiri` (`Yeni Oyun`, `Devam Et`, `Ayarlar`, `Çıkış`) | `KayitYuvalari`, `OyuncuSurumu` | Sağda canlı 3B `MenuSahnesi` güzel bir zemin verse de düğmeler/çerçeveler `gece_kapisi` dokusu yerine vektör/düz yazı; C1 playtest ilk-açılış onay penceresi (`TEL-02`) henüz yok. |
| **Yeni Oyun** | `YeniOyunEkrani` (`src/arayuz/yeni_oyun_ekrani.gd:1-193`) | Arka plan geçmişi seçimi (`MuhafizGecmisleri`), başlangıç senaryosu (`AcilisSenaryosu` / `Senaryolar`), zorluk/mutatör, isim/tohum girişi | `ZorlukSecimi`, `MuhafizGecmisleri` | Uzun tek sütun `VBoxContainer`; B2 başlangıç senaryoları ilk günden açık olmalı (`ROADMAP_4` B2). |
| **Kapı Sorgu Sahnesi** | `KapiSahnesi` (`src/dunya/kapi_sahnesi.gd`) + `KapiEkrani` (`src/arayuz/kapi_ekrani.gd`) | Sol/üst `Hud` kaynak/gün çubuğu, gelen kişi bilgileri (`ChrIncelemePaneli`), `ChrDiyalogPaneli` (`chr_diyalog_paneli.gd:1-160`: `TansiyonGostergesi`, `ZarSonucu`, `ZarIpucuNotu`, `replik_kaydir`, `Secenek%d`), `KonusmaGecmisi`, `BeyanDefteriPaneli`, `HeybePaneli`, alt karar düğmeleri (`Al`, `Reddet`, `Rüşvet/Bedel`), `KapiAcilisOgretici` | `Oturum`, `ChrSorgu`, `MuhafizTonu`, `Celiski`, `Heybe` | Sağ/sol sabit paneller 3B kapıyı (`KapiCercevesi` + `KapiManzarasi` + `KarakterModel`) daraltıyor; `portrait_frame.png`, `dialogue_panel.png`, `interrogation_bg.png` bağlı değil. |
| **Köy Yönetimi Sahnesi** | `KoyYonetimSahnesi` (`src/dunya/koy_yonetim_sahnesi.gd`) + `KoyEkrani` (`src/arayuz/koy_ekrani.gd`) | Üst `Hud` şeridi (`hud.gd:1-205` + `hud_katmani.gd:1-58`: `KaynakGostergesi` odun/tas/kereste/gida/demir/alet/akce/bugday/un/saman/su, `KeseGostergesi`, `YasamBarlariPaneli`, `MevsimTakvim`, `BostaGostergesi`, `KamuoyuSeridi`, 1x/2x hız & geceye geç), sol/sağ açılır menüler (inşa, pazar, görev, teftiş), seçili yapı `YapiKarti` (`yapi_karti.gd:1-74`), köylü atama (`KoyAtamaAlani`), geçici işler (`KoyGeciciIslerPaneli`), olay/karar katmanları (`TekfurHeyetiPaneli`, `ObaIttifakPaneli`, `CinarMeclisPaneli`, `SoylentiHukmu`, `KarantinaPaneli`, `CozumlemePaneli` vb.) | `Oturum`, `KoyYonetimi`, `BinaKatalogu`, `YapiKilidi`, `YapiInsaati`, `HudKatmani` | En yoğun ekran; üst `Hud` 11+ göstergeyle sıkışık; `YapiKarti` 3B yapının inşaat yüzdesini görselle senkronize etmiyor (`_iskele` 4 direk); `hud_strip.png` / `villager_card.png` bağlı değil. |
| **Gece / Rapor / Olay** | `GeceRaporuKisa` (`gece_raporu_kisa.gd:1-31`), `BilgiEkrani` (`bilgi_ekrani.gd:1-106`) | Gece özeti, cenaze/olay sonuçları, 1./2. perde geçişleri, 5 zafer / 5 kayıp sonu | `DengeOlcumu`, `SonucEpilogOlusturucu` | Kısa metin kartı, illüstrasyon/atmosfer çerçevesi yok; `TEL-07` koşu özeti + tohum kopyala `ROADMAP_4`'te bekliyor. |
| **Yardımcı Ekranlar** | `HaritaEkrani` (`harita_ekrani.gd`), `MuhafizOdasiEkrani`, `HafizaDefteriEkrani`, `DivanEkrani`, `AyarlarEkrani` (`ayarlar_ekrani.gd`) | Harita düğümleri (`map_bg.png` yok), muhafız yetenekleri, karakter hafızası, divan yargılaması, Ayarlar 4–5 sekme (`ses_sekmesi.gd` yalnız 2 kaydırıcı: Müzik & Efekt) | `HaberciAgi`, `MuhafizOdaGelisimi`, `HafizaDefteri`, `DivanHukmu`, `Ayarlar` | Tek tip düz koyu `StyleBoxFlat` kutular; `GRV-05/15/56` Berk/Codex-Berk üzerinde WIP. |

---

### 2.2. Meshy Manifest Durumu (`assets/meshy_manifest.json`)

Python denetimiyle doğrulanan güncel sayılar (`assets/meshy_manifest.json`, `surum: 1`):
- Toplam kayıt: **1144** (`mevcut`: **946**, `onaylandi`: **186**, `planli`: **12**).
- `oyun_baglantisi == "baglandi"` olan kayıt: **54** = **51** `topluluk` + **3** `yapi` (`pazar_tezgahi`, `su_bendi`, `yanik_ev`).
- `design/art/meshy/meshy-secim.json`: **69** topluluk kodu (`A012`..`O92`), hepsi `assets/meshy_manifest.json` içinde `tur == "topluluk"` ve `plan_kimlikleri[0] == kod` olarak kayıtlı; **51**'i `baglandi` (**12**'si `Dunya3B.TOPLULUK_YER` gerçek anahtarı + **39**'u `td_*` `ToplulukDekoru`), **18**'i `oyun_baglantisi: None`.
- `tur == "yapi"` satırı: **31** kayıt; tüm 31 `.glb` `assets/model/yapi/` altında diskte mevcut, ancak yalnız 3'ü `baglandi` görünüyor (`demirhane` dâhil **28 yapı `oyun_baglantisi: None`**!).
- **Zorunlu Kural:** `assets/meshy_manifest.json` ve `assets/meshy_manifest.csv` dosyalarına **yalnız `tools/meshy/manifest.py` içindeki `yaz(nesne)` (`satir 716`) aracılığıyla yazılır**; elle JSON düzenlemesi yasaktır.

---

### 2.3. Topluluk 3B Modelleri Tam Denetim Tablosu (69 Seçili + Ekstralar)

Aşağıdaki tablo tüm 69 `meshy-secim.json` kodunu Godot 4.7.2 headless `MeshInstance3D` + `Transform3D` AABB ölçümüyle (`audit_meshy_glbs.gd`) listeler. `Dunya3B._kutu()` (`src/dunya/dunya3b.gd:264-278`) iskeletli (`sk=1`) modellerde `Armature` ölçeğini (`0.01`) dışarıdan küçülttüğü için ham kutu `0.016 m`–`0.00003 m` okunup dev ölçek çarpanı üretmektedir.

| Kod | Dosya Yolu (`assets/meshy/...`) | Ne Olduğu | Oyunda Karşılığı | Şu An Nasıl Bağlı | Olması Gereken Bağ | Ölçek Sorunu (Hedef Gerçek Boy) | Taban / Pivot / Yön Sorunu | Animasyon Klipleri & Durumu | Gereken İş (`CIL-*`) |
|---|---|---|---|---|---|---|---|---|---|
| `A012` | `dogrudan/a012_mizrak.glb` (0.93 MB) | Mızrak | Muhafız/devriye ve `ElEsyasi("mizrak")` / `mizrak` anahtarı | `TOPLULUK_YER["mizrak"]` (`dunya3b.gd:18`) | Nöbetçi/devriye eli ve kışla silahlığı | Ham `(1.98, 0.10, 0.04) m` yatay! Y'den `2.0` ölçeklenirse `38 m` olur | Yatay uzanmış; merkez pivot (`y0=-0.048`); el ekseni +Y dik değil | Yok (`sk=0`) | `CIL-01`, `CIL-11` |
| `A016` | `dogrudan/a016_mizrak_sehpasi.glb` (1.10 MB) | Mızrak sehpası | Kışla / Kapı önü silahlığı (`OlayYapilari`) | `TOPLULUK_YER["mizrak_sehpasi"]` (`dunya3b.gd:12`) | `muhafiz_kislasi` ve `kapi` nöbet noktası | Ham `(1.09, 1.38, 2.01) m`; hedef `1.35 m` | `y0=-0.679` merkez pivot; taban oturtması zorunlu | Yok | `CIL-01`, `CIL-07` |
| `A040` | `dogrudan/a040_kutuk_ustunde_ors.glb` (1.51 MB) | Kütük üstünde örs | Demirhane / tamir sundurması avlusu | **Bağsız** (`oyun_baglantisi: None`) | `demirhane` / `tamir_sundurmasi` önü aktif eşya (`civi_ocagi` yakını) | Ham `(2.00, 0.53, 0.70) m`; Y=`0.85 m` hedeflenirse en=`3.2 m` şişer → en-boy `1.10 m` sınırı gerek | `y0=-0.270`; kütük-örs yatay uzun | Yok | `CIL-01`, `CIL-07` |
| `A042` | `dogrudan/a042_el_korugu.glb` (1.12 MB) | El körüğü | Demirhane / ocak eşyası | `ToplulukDekoru` (`td_a042`) — dış çember | `demirhane` ve `demir_ocagi` avlusu | Ham `(1.17, 1.99, 0.33) m`; gerçek körük `~0.45 m` boy | `y0=-1.000`; merkez pivot | Yok | `CIL-01`, `CIL-07` |
| `A060` | `dogrudan/a060_tas_halkali_ocak.glb` (0.25 MB) | Taş halkalı ocak | Köy meydanı / gece nöbet ateşi | `TOPLULUK_YER["nobet_ocagi"]` (`dunya3b.gd:11`) | Köy meydanı / `ortak_sofra` / kapı nöbeti ateş yeri + ışık + duman | Ham `(1.99, 0.72, 1.96) m`; hedef çap `1.30 m`, boy `0.48 m` | `y0=-0.362`; yassı, çap sınırı şart | Yok | `CIL-01`, `CIL-07` |
| `A073` | `dogrudan/a073_sazdan_catili_pazar_tezgahi_cuvalli.glb` (1.37 MB) | Sazdan çatılı pazar tezgâhı (çuvallı) | Köy pazarı / tüccar alanı (`han` yakınında) | **Bağsız** (`None`) | Gezgin tüccar / `pazar_tezgahi` K1–K2 tezgâhı | Ham `(1.97, 1.49, 1.63) m`; hedef boy `2.45 m` | `y0=-0.743`; tezgâh önü açısı doğrulanmalı | Yok | `CIL-01`, `CIL-06`, `CIL-07` |
| `A077` | `dogrudan/a077_ortulu_pazar_tezgahi.glb` (1.36 MB) | Örtülü pazar tezgâhı | Pazar tezgâhı varyantı / kervan tezgâhı | **Bağsız** (`None`) | Gezgin tüccar / kumaşçı / `han` pazarı | Ham `(1.10, 1.23, 2.00) m`; hedef boy `2.35 m` | `y0=-0.608`; Z uzun eksen (`+90°` dönüş kontrolü) | Yok | `CIL-01`, `CIL-06`, `CIL-07` |
| `A081` | `dogrudan/a081_agzi_acik_un_cuvali.glb` (0.44 MB) | Ağzı açık un çuvalı | Değirmen / fırın / ambar önü dekoru | `ToplulukDekoru` (`td_a081`) — dış çember | `firin`, `degirmen`, `ambar` giriş eşyası | Ham `(1.77, 1.81, 1.47) m`; gerçek çuval `0.65 m` | `y0=-0.906` | Yok | `CIL-01`, `CIL-07` |
| `A113` | `dogrudan/a113_sazdan_catili_ahsap_gozetleme_kulesi.glb` (2.29 MB) | Sazdan çatılı ahşap gözetleme kulesi | `nobetci_kulesi` K1 (ahşap palisat kulesi) | `ToplulukDekoru` (`td_a113`) — dış çember | `nobetci_kulesi` Seviye 1 veya `OlayYapilari` yan kule | Ham `(0.88, 1.91, 0.87) m`; gerçek kule `4.8–5.5 m` | `y0=-0.955`; taban merdiven yönü kapıya dönmeli | Yok | `CIL-01`, `CIL-06` |
| `A116` | `dogrudan/a116_iki_katli_duz_damli_kerpic_ev.glb` (1.62 MB) | İki katlı düz damlı kerpiç ev | `tas_ev` / konak / zengin hane (ya da Anadolu köy evi) | `ToplulukDekoru` (`td_a116`) — dış çember | Köy dışı mesken sınırı veya `tas_ev` alternatifi | Ham `(1.90, 1.09, 1.59) m`; hedef boy `4.6 m`, taban `≤3.8 m` | `y0=-0.549`; X-Z genişliği parseli aşmamalı | Yok | `CIL-01`, `CIL-07` |
| `A117` | `dogrudan/a117_duz_damli_kerpic_ev.glb` (1.76 MB) | Düz damlı kerpiç ev | `kulube` / arka plan köy evi | `ToplulukDekoru` (`td_a117`) — dış çember | `kulube` varyantı veya arka hane dekoru | Ham `(1.66, 1.20, 1.90) m`; hedef boy `2.8 m`, taban `≤3.6 m` | `y0=-0.599` | Yok | `CIL-01`, `CIL-07` |
| `A146` | `animasyon_bekliyor/a146_tavuk_gercekci.glb` (1.29 MB) | Tavuk (gerçekçi) | Kümes / köy avlusu tavukları | `ToplulukDekoru` (`td_a146`, `boy=0.42`) — dışta sabit heykel | Köy içi avlu / kümes tavuğu (tekil veya `K04` tercihli) | Ham `(0.98, 1.91, 1.67) m` (1.9 m!) — normalizer yoksa dev durur | `y0=-0.951` | Yok (`sk=0`) | `CIL-01`, `CIL-10` |
| `A157` | `animasyon_bekliyor/a157_esek.glb` (0.53 MB) | Eşek | Kervan / köy yük hayvanı | `ToplulukDekoru` (`td_a157`, `boy=1.25`) — dış çember | Han / değirmen / yol kenarı yük hayvanı | Ham `(0.50, 1.75, 1.99) m`; omuz/kulak `1.20 m` | `y0=-0.873` | Yok (`sk=0`) | `CIL-01`, `CIL-10` |
| `A163` | `animasyon_bekliyor/a163_keci.glb` (0.60 MB) | Keçi | Ağıl / mera sürüsü | **Bağsız** (`None`; `model/hayvan/keci.glb` var) | `agil` yanında veya mera otlak hayvanı | Ham `(0.63, 1.66, 2.00) m`; hedef boy `0.85 m` | `y0=-0.838` | Yok (`sk=0`) | `CIL-01`, `CIL-10` |
| `A172` | `animasyon_bekliyor/a172_okuz.glb` (0.60 MB) | Öküz | Çeki öküzü / ahır (`ahir`) | `ToplulukDekoru` (`td_a172`, `boy=1.45`) — dış çember | `ahir` avlusu / karasaban önü (`nesne/okuz.glb` ile tekilleştirilecek) | Ham `(0.72, 1.04, 1.99) m`; Y=`1.45 m` olunca `Z=2.79 m` hafif uzun, `boy=1.35 m` uygun | `y0=-0.517` | Yok (`sk=0`) | `CIL-01`, `CIL-10` |
| `A177` | `dogrudan/a177_kubbeli_toprak_firin.glb` (0.43 MB) | Kubbeli toprak fırın | `firin` avlusu / ortak ekmek fırını | `ToplulukDekoru` (`td_a177`) — dış çember | `firin` dış avlusu veya `firin` K1 modeli | Ham `(1.98, 1.77, 2.00) m`; hedef boy `1.65 m` | `y0=-0.887`; ağız yönü patikaya dönmeli | Yok | `CIL-01`, `CIL-07` |
| `A181` | `dogrudan/a181_tandir.glb` (0.65 MB) | Tandır | `firin_agzi` (`OlayYapilari`) / mutfak avlusu | `TOPLULUK_YER["firin_agzi"]` (`dunya3b.gd:15`) + `td` | `firin` / `ortak_sofra` yanı tandır ocağı | Ham `(1.32, 2.00, 1.28) m`; hedef boy `0.95 m` | `y0=-1.000` | Yok | `CIL-01`, `CIL-07` |
| `A186` | `dogrudan/a186_saman_kovan.glb` (0.53 MB) | Saman kovan (arı kovanı / saman sepet) | Bostan / tarla damı arıcılık/depolama | `ToplulukDekoru` (`td_a186`) — dış çember | `bostan` / `tarla_dami` kenarı | Ham `(1.97, 1.09, 1.32) m`; hedef boy `0.70 m` | `y0=-0.556` | Yok | `CIL-01`, `CIL-07` |
| `A190` | `dogrudan/a190_tahil_cuvali.glb` (0.51 MB) | Tahıl çuvalı | Ambar / değirmen / harman çuval yığını | `TOPLULUK_YER["cuval_yigini"]` (`dunya3b.gd:13`) | `ambar`, `degirmen`, `harman_yeri` aktif stok | Ham `(1.98, 1.99, 1.68) m`; hedef boy `0.75 m` | `y0=-0.996` | Yok | `CIL-01`, `CIL-07` |
| `A202` | `dogrudan/a202_tinaz_saman_yigini.glb` (2.41 MB) | Tınaz (saman yığını) | `harman_yeri` / `saman` stoğu | `ToplulukDekoru` (`td_a202`) — dış çember | `harman_yeri` merkezi / `ahir` yanı | Ham `(1.88, 1.96, 1.89) m`; hedef boy `1.55 m` | `y0=-0.982` | Yok | `CIL-01`, `CIL-07` |
| `A205` | `dogrudan/a205_degirmen_tasi.glb` (0.62 MB) | Değirmen taşı | `degirmen` / taş ocağı yanı | `ToplulukDekoru` (`td_a205`) — dış çember | `degirmen` / `tas_ocagi` avlusu | Ham `(2.00, 2.00, 0.81) m`; hedef boy `1.10 m` | `y0=-0.999` | Yok | `CIL-01`, `CIL-07` |
| `A209` | `dogrudan/a209_el_degirmeni.glb` (1.04 MB) | El değirmeni | Ev / fırın avlusu | `ToplulukDekoru` (`td_a209`) — dış çember | `firin` / `kulube` avlusu | Ham `(1.64, 1.91, 1.61) m`; gerçek el değirmeni `0.55 m` | `y0=-0.960` | Yok | `CIL-01`, `CIL-07` |
| `A211` | `dogrudan/a211_orak.glb` (0.76 MB) | Orak | Çiftçi el eşyası (`ElEsyasi("orak")`) | `TOPLULUK_YER["orak"]` (`dunya3b.gd:17`) | Köylü çiftçi eli (`el_esyasi.gd:69`) + tarla çiti | Ham `(1.68, 1.90, 0.22) m`; `ElEsyasi` `0.38 m` istiyor | `y0=-0.952`; sap ekseni avuç hizası kontrolü şart | Yok | `CIL-01`, `CIL-11` |
| `A220` | `dogrudan/a220_karasaban.glb` (0.64 MB) | Karasaban | Tarla kenarı tarım aleti | `ToplulukDekoru` (`td_a220`) — dış çember | `tarla` / `ahir` kenarı | Ham `(2.00, 1.61, 0.39) m`; hedef boy `0.95 m` | `y0=-0.807` | Yok | `CIL-01`, `CIL-07` |
| `A227` | `dogrudan/a227_bakir_kazan.glb` (1.06 MB) | Bakır kazan | Ortak sofra / şifahane avlusu | `ToplulukDekoru` (`td_a227`) — dış çember | `ortak_sofra`, `sifahane` önü | Ham `(1.71, 1.54, 1.83) m`; gerçek kazan `0.55 m` | `y0=-0.767` | Yok | `CIL-01`, `CIL-07` |
| `A228` | `dogrudan/a228_sacayak_ustunde_kazan.glb` (0.48 MB) | Sacayak üstünde kazan | Ocak / `ortak_sofra` pişirme | `ToplulukDekoru` (`td_a228`) — dış çember | `ortak_sofra` / `koy_meydani` ateş üstü | Ham `(0.86, 1.00, 0.90) m`; hedef boy `0.78 m` | `y0=-0.500` | Yok | `CIL-01`, `CIL-07` |
| `A236` | `dogrudan/a236_kilim_dokuma_tezgahi.glb` (1.28 MB) | Kilim dokuma tezgâhı | `bez_evi` / dokuma alanı | `TOPLULUK_YER["dokuma_tezgahi"]` (`dunya3b.gd:14`) | `bez_evi` içi/avlusu ve `atolye` | Ham `(1.45, 1.91, 0.89) m`; hedef boy `1.65 m` | `y0=-0.957` | Yok | `CIL-01`, `CIL-03`, `CIL-07` |
| `A241` | `dogrudan/a241_comlek_takimi.glb` (0.86 MB) | Çömlek takımı | Han / çeşme / atölye yanı dekor | `ToplulukDekoru` (`td_a241`) — dış çember | `han`, `koy_cesmesi`, `atolye` avlusu | Ham `(1.90, 1.27, 1.90) m`; gerçek `0.50 m` | `y0=-0.635` | Yok | `CIL-01`, `CIL-07` |
| `B019` | `animasyon_bekliyor/b019_kangal_anadolu_coban_kopegi.glb` (1.18 MB) | Kangal (Anadolu çoban köpeği) | Köy/çoban bekçi köpeği (döneme %100 uygun) | **Bağsız** (`None`) | Statik kulübe nöbetçisi veya `styloo/kopek.glb` alternatifi | Ham `(0.48, 1.40, 1.90) m`; gerçek Kangal omuz `0.85 m` | `y0=-0.704` | Yok (`sk=0`) | `CIL-01`, `CIL-09`, `CIL-10` |
| `B092` | `animasyon_bekliyor/b092_kapusonlu_koylu.glb` (0.99 MB) | Kapüşonlu köylü | Gece/kış ziyaretçisi veya arka plan nöbeti | **Bağsız** (`None`) | Statik silüet (`KapiManzarasi` yolcu?) — animasyonsuz! | Ham `(1.28, 1.90, 0.47) m`; hedef boy `1.70 m` | `y0=-0.950` | Yok (`sk=0`) | `CIL-01`, `CIL-11` |
| `B117` | `animasyon_bekliyor/b117_coban_ve_koyun_heykel.glb` (1.79 MB) | Çoban ve koyun (heykel) | Köy girişi / ağıl heykeli veya referans sahne | `ToplulukDekoru` (`td_b117`) — dış çember | `agil` yakını statik dekor veya çıkarılacak (statik ikili insan heykeli) | Ham `(1.06, 1.91, 0.85) m`; hedef `1.72 m` | `y0=-0.954` | Yok (`sk=0`) | `CIL-01`, `CIL-07` |
| `K02` | `animasyon_bekliyor/k02_kipcak_kuman_savascisi.glb` (1.39 MB) | Kıpçak / Kuman savaşçısı | Akıncı/paralel göçebe konuk veya `SVS-*` (Berk) | **Bağsız** (`None`) | Rig/animasyon gelirse kapı/savaş; şimdilik **Berk `SVS-*` sorulacak** | Ham `(1.21, 1.90, 1.10) m`; hedef `1.76 m` | `y0=-0.951` | Yok (`sk=0`) | `CIL-01`, `CIL-11` |
| `K04` | `animasyonlu/k04_tavuk.glb` (1.58 MB) | Tavuk (animasyonlu) | Kümes / köy avlusu yürüyen tavukları | `ToplulukDekoru` (`td_k04`) — yanlış ölçek + animasyon yok! | Köy avlusu sürü/tavuk döngüsü | **KRİTİK:** Ham `(0.008, 0.016, 0.013) m` → `26.92x` ölçeklenmiş; hedef `0.40 m` | `y0=-0.000`; `Armature` `0.01` kök ölçeği `_kutu()`yu şaşırtır | **`sk=1`: `RunFast`, `Running`, `Walking`** (oynatılmıyor!) | `CIL-01`, `CIL-08`, `CIL-10` |
| `K05` | `animasyonlu/k05_at.glb` (1.74 MB) | At (animasyonlu) | Kervan / ahır / kapı atlı habercisi | **Bağsız** (`None`; `model/hayvan/at.glb` statik) | `ahir` + kervan + atlı sahne (`Armature\|Unreal Take\|baselayer`) | **KRİTİK:** Ham `(0.000009, 0.000033, 0.000027) m` (`0.03 mm`!) `_kutu` çalışmaz! Hedef omuz/baş `1.65 m` | `y0=0`; `Unreal Take` klip ekseni ve kök dönüşü denetlenmeli | **`sk=1`: `Armature\|Unreal Take\|baselayer`** | `CIL-01`, `CIL-08`, `CIL-10` |
| `K07` | `animasyon_bekliyor/k07_ayi.glb` (1.63 MB) | Ayı | Orman sınırı (`avci` / vahşi tehdit dekoru) | `ToplulukDekoru` (`td_k07`) — dış çember | Orman sınırı / `avci` olayı yakını (köy içinde durmamalı) | Ham `(0.96, 1.31, 1.88) m`; hedef omuz `1.20 m` | `y0=-0.668` | Yok (`sk=0`) | `CIL-01`, `CIL-07` |
| `K09` | `animasyonlu/k09_okcu_pers.glb` (2.41 MB) | Okçu (animasyonlu) | Nöbetçi / okçu eğitimi (`nobetci_kulesi` / `muhafiz_kislasi`) | **Bağsız** (`None`) | Kışla/kule nöbetçisi veya **Berk `SVS-*`** savaş okçusu | **KRİTİK:** Ham `(0.008, 0.017, 0.004) m` (`Armature` `0.01`); hedef `1.72 m` | `y0=0`; vertex AABB normalizasyonu şart | **`sk=1`: `Agree_Gesture`, `Chair_Sit_Idle_M`, `Checkout_Gesture`, `Indoor_Swing`, `Running`, `Walking`** | `CIL-01`, `CIL-08`, `CIL-11` |
| `K12` | `animasyonlu/k12_ortacag_tuccari.glb` (1.70 MB) | Ortaçağ tüccarı (animasyonlu) | Han / kervan / gezgin tüccar | **Bağsız** (`None`) | `han` / pazar tezgâhı yanı yürüyen tüccar veya kapı konuğu | **KRİTİK:** Ham `(0.011, 0.017, 0.004) m` (`Armature` `0.01`); hedef `1.70 m` | `y0=0`; vertex AABB normalizasyonu şart | **`sk=1`: `Running`, `Walking`** | `CIL-01`, `CIL-08`, `CIL-11` |
| `K13` | `animasyonlu/k13_koyun.glb` (0.65 MB) | Koyun (animasyonlu) | `agil` ve `CobanSurusu` otlayan sürüsü | **Bağsız** (`None`; `vertexcat/koyun.gltf` statik kullanılıyor) | `CobanSurusu` (`coban_surusu.gd:8-65`) canlı koyunları | **KRİTİK:** Ham `(0.000055, 0.000167, 0.000121) m` (`0.17 mm`!); hedef `0.85 m` | `y0=0`; `Unreal Take` kök transformu normalleştirilmeli | **`sk=1`: `Armature\|Unreal Take\|baselayer`** | `CIL-01`, `CIL-08`, `CIL-10` |
| `K14` | `animasyon_bekliyor/k14_gezgin_tuccar.glb` (1.21 MB) | Gezgin tüccar | Pazar / kervan statik figürü veya ileride rig | **Bağsız** (`None`) | Han/pazar önü figür (yalnız animasyon gelene dek) ya da rig adayı | Ham `(1.07, 1.99, 0.63) m`; hedef `1.72 m` | `y0=-1.001` | Yok (`sk=0`) | `CIL-01`, `CIL-11` |
| `K15` | `animasyon_bekliyor/k15_gezgin_tuccar_sepetli.glb` (1.07 MB) | Gezgin tüccar (sepetli) | Pazar / sepetli gezgin | **Bağsız** (`None`) | Pazar tezgâhı satıcısı (statik bekletme / rig adayı) | Ham `(1.16, 2.00, 1.14) m`; hedef `1.72 m` | `y0=-1.001` | Yok (`sk=0`) | `CIL-01`, `CIL-11` |
| `O00` | `dogrudan/o00_odun_yigini_kutuk.glb` (2.11 MB) | Odun yığını + kütük | `hizarhane` / `odunluk` avlusu odun stoku | `ToplulukDekoru` (`td_o00`) — dış çember | `odunluk` ve `hizarhane` çevresi | Ham `(1.90, 0.60, 1.65) m`; hedef boy `0.75 m` | `y0=-0.307` | Yok | `CIL-01`, `CIL-07` |
| `O01` | `dogrudan/o01_hasir_sepet.glb` (0.94 MB) | Hasır sepet | Çiftçi/tüccar büyük el sepeti (`el_sepet_buyuk`) | `TOPLULUK_YER["el_sepet_buyuk"]` (`dunya3b.gd:20`) | `ElEsyasi("sepet_buyuk")` + ambar/pazar önü | Ham `(1.91, 0.92, 1.76) m`; elde `0.48 m`, yerde `0.55 m` | `y0=-0.463` | Yok | `CIL-01`, `CIL-07`, `CIL-11` |
| `O05` | `dogrudan/o05_demir_mangal_nobet_ocagi.glb` (0.45 MB) | Demir mangal (nöbet ocağı) | Kışla / sur / kapı içi ateş mangalı | `ToplulukDekoru` (`td_o05`) — dış çember | `muhafiz_kislasi`, `nobetci_kulesi` dibi, kapı içi | Ham `(0.40, 1.00, 0.39) m`; hedef boy `0.85 m` | `y0=-0.500` | Yok | `CIL-01`, `CIL-07` |
| `O07` | `dogrudan/o07_toprak_comlek.glb` (0.42 MB) | Toprak çömlek | Han / fırın / ev kapısı dekoru | `ToplulukDekoru` (`td_o07`) — dış çember | `han`, `kulube`, `sifahane` önü | Ham `(1.87, 1.90, 1.87) m`; gerçek çömlek `0.45 m` | `y0=-0.951` | Yok | `CIL-01`, `CIL-07` |
| `O14` | `dogrudan/o14_yumurta_sepeti.glb` (1.60 MB) | Yumurta sepeti | Han / pazar / kümes önü | `ToplulukDekoru` (`td_o14`) — dış çember | Pazar tezgâhı / `firin` yanı | Ham `(1.86, 1.91, 1.87) m`; gerçek sepet `0.35 m` | `y0=-0.956` | Yok | `CIL-01`, `CIL-07` |
| `O17` | `dogrudan/o17_sivri_kazik_cit.glb` (1.49 MB) | Sivri kazık çit | Savunma çiti / kışla-ağıl çevresi | `ToplulukDekoru` (`td_o17`) — dış çember | Köy dışı savunma hattı / kışla avlusu | Ham `(1.90, 0.93, 0.29) m`; hedef boy `1.45 m` | `y0=-0.465`; modül uç birleşimi kontrolü | Yok | `CIL-01`, `CIL-06`, `CIL-07` |
| `O18` | `dogrudan/o18_tas_yigini.glb` (0.58 MB) | Taş yığını | `tas_ocagi` / `tas_yatagi` yanı | `ToplulukDekoru` (`td_o18`) — dış çember | `tas_ocagi` ve inşaat şantiyesi | Ham `(1.91, 1.30, 1.79) m`; hedef boy `0.90 m` | `y0=-0.649` | Yok | `CIL-01`, `CIL-05`, `CIL-07` |
| `O19` | `dogrudan/o19_asma_toprak_kandil.glb` (0.62 MB) | Asma toprak kandil | Han / kapı / kışla girişi asma ışık | `ToplulukDekoru` (`td_o19`) — yerde duruyor! | Kapı direği veya han saçağına **asma** (`y=2.2 m`) | Ham `(1.90, 0.83, 1.20) m`; gerçek kandil `0.30 m` | `y0=-0.416`; yerde durması yanlış — saçak kancası şart | Yok | `CIL-01`, `CIL-07`, `CIL-12` |
| `O20` | `dogrudan/o20_tas_oturak.glb` (0.89 MB) | Taş oturak | `koy_meydani` / `han` / `ortak_sofra` bankı | `ToplulukDekoru` (`td_o20`) — dış çember | Meydan çınarı veya han avlusu | Ham `(1.90, 0.68, 1.24) m`; oturak boy `0.50 m` | `y0=-0.343` | Yok | `CIL-01`, `CIL-07` |
| `O21` | `dogrudan/o21_tas_kuyu_cikrikli.glb` (1.41 MB) | Taş kuyu (çıkrıklı) | `su_kuyusu` (`OlayYapilari`) | `TOPLULUK_YER["kuyu"]` (`dunya3b.gd:9`) | Köy su kuyusu + `KuyuKirecleme` | Ham `(1.84, 1.91, 1.65) m`; hedef boy `1.95 m` | `y0=-0.956` | Yok | `CIL-01`, `CIL-07` |
| `O23` | `dogrudan/o23_rafli_odun_istifi.glb` (0.28 MB) | Raflı odun istifi | `odunluk` / `hizarhane` yanı | `ToplulukDekoru` (`td_o23`) — dış çember | `odunluk`, `firin` yanı yakacak istifi | Ham `(1.92, 1.05, 0.69) m`; hedef boy `1.35 m` | `y0=-0.527` | Yok | `CIL-01`, `CIL-07` |
| `O25` | `dogrudan/o25_ahsap_palisat_kapisi.glb` (2.40 MB) | Ahşap palisat kapısı | `sur` seviye 1–2 köy kapısı (`KapiCercevesi` / `koy_yonetim_sahnesi`) | **Bağsız** (`None`) | Köy kuzey/güney sur kapısı (palisat evresi) | Ham `(1.90, 1.68, 0.38) m`; hedef boy `3.60 m` | `y0=-0.839`; yol eksenine dik konmalı | Yok | `CIL-01`, `CIL-06` |
| `O26` | `dogrudan/o26_toprak_damli_kerpic_ev.glb` (0.59 MB) | Toprak damlı kerpiç ev | `kulube` / arka hane | `ToplulukDekoru` (`td_o26`, `boy=2.60`) — dış çember | Köy yerleşim evi / `kulube` | Ham `(1.85, 1.24, 1.89) m`; `2.60 m` → `en=3.88 m`, parseli doldurur (`≤3.5 m` taban önerilir) | `y0=-0.616` | Yok | `CIL-01`, `CIL-07` |
| `O30` | `dogrudan/o30_ahsap_yalak.glb` (0.92 MB) | Ahşap yalak | `ahir` / `su_kuyusu` / `agil` su yalağı | `ToplulukDekoru` (`td_o30`) — dış çember | `ahir`, `agil`, `koy_cesmesi` önü | Ham `(2.00, 0.38, 0.73) m`; hedef boy `0.48 m` (en `2.5 m` aşarsa `1.6 m` taban sınırı) | `y0=-0.190` | Yok | `CIL-01`, `CIL-07` |
| `O32` | `dogrudan/o32_toprak_kandil.glb` (0.50 MB) | Toprak kandil | Han masası / gece nöbet eşyası | `ToplulukDekoru` (`td_o32`) — dış çember | `muhafiz_odasi` / `han` tezgâh üstü | Ham `(1.91, 0.73, 1.32) m`; gerçek kandil `0.22 m`! | `y0=-0.367` | Yok | `CIL-01`, `CIL-07` |
| `O37` | `dogrudan/o37_ahsap_palisat_kazik_sur.glb` (0.63 MB) | Ahşap palisat (kazık sur) | `kazik_cit` / köy sur hattı | `TOPLULUK_YER["kazik_cit"]` (`dunya3b.gd:10`) | Köy savunma çemberi (`sur` S1) | Ham `(1.92, 1.76, 0.14) m`; hedef boy `2.40 m` | `y0=-0.878` | Yok | `CIL-01`, `CIL-06` |
| `O48` | `dogrudan/o48_toprak_testi.glb` (0.71 MB) | Toprak testi | Çeşme / fırın / sofra | `ToplulukDekoru` (`td_o48`) — dış çember | `koy_cesmesi`, `ortak_sofra` önü | Ham `(1.53, 1.91, 1.53) m`; gerçek testi `0.45 m` | `y0=-0.956` | Yok | `CIL-01`, `CIL-07` |
| `O49` | `dogrudan/o49_kervan_konak_yeri_ortu_yuk.glb` (2.24 MB) | Kervan konak yeri (örtü+yük) | `han` / `kervansaray` konaklama avlusu | `ToplulukDekoru` (`td_o49`) — dış çember | `han` / kervan alanı içi aktif eşya | Ham `(1.89, 0.75, 1.86) m`; hedef boy `1.45 m` (çap `≤3.5 m`) | `y0=-0.376` | Yok | `CIL-01`, `CIL-07` |
| `O51` | `dogrudan/o51_sapli_sepet.glb` (0.80 MB) | Saplı sepet | Köylü el eşyası (`el_sepet`) + tarla | `TOPLULUK_YER["el_sepet"]` (`dunya3b.gd:19`) | `ElEsyasi("sepet")` (`el_esyasi.gd:58`) | Ham `(1.89, 2.00, 1.93) m`; elde `0.36 m` | `y0=-1.000`; sap ekseni avuca dönmeli | Yok | `CIL-01`, `CIL-11` |
| `O58` | `dogrudan/o58_saman_arabasi.glb` (0.90 MB) | Saman arabası | Harman / kervan / `OlayYapilari("araba")` | `TOPLULUK_YER["araba"]` (`dunya3b.gd:16`) | `harman_yeri`, `tarla` yolu kenarı | Ham `(0.79, 0.72, 2.00) m`; gerçek araba boy `1.25 m`, uzunluk `~3.4 m` | `y0=-0.371`; teker ekseni Z uzun | Yok | `CIL-01`, `CIL-07` |
| `O64` | `dogrudan/o64_orme_cubuk_cit_ceper.glb` (1.06 MB) | Örme çubuk çit (çeper) | `agil` / `tarla` / `bostan` çiti | `ToplulukDekoru` (`td_o64`) — dış çember | `tarla`, `bostan`, `agil` sınırları | Ham `(2.00, 1.75, 0.23) m`; gerçek çeper `1.15 m` | `y0=-0.878` | Yok | `CIL-01`, `CIL-06`, `CIL-07` |
| `O65` | `dogrudan/o65_renkli_carsi_tezgahi.glb` (1.38 MB) | Renkli çarşı tezgâhı | `han` / kumaşçı / çarşı tezgâhı | **Bağsız** (`None`) | Pazar veya kervan etkinlik tezgâhı (`A073`/`A077` ile birlikte) | Ham `(2.01, 1.87, 1.94) m`; hedef boy `2.30 m` | `y0=-0.932` | Yok | `CIL-01`, `CIL-06`, `CIL-07` |
| `O72` | `dogrudan/o72_tas_ahsap_kule.glb` (1.60 MB) | Taş-ahşap kule | `nobetci_kulesi` Seviye 2 (taş tabanlı kule) | `ToplulukDekoru` (`td_o72`) — dış çember | `nobetci_kulesi` yükseltme kademesi (veya sur köşesi) | Ham `(1.01, 1.99, 1.07) m`; hedef boy `5.80 m` | `y0=-1.002` | Yok | `CIL-01`, `CIL-06` |
| `O76` | `dogrudan/o76_su_degirmeni.glb` (2.28 MB) | Su değirmeni | `degirmen` (dere kenarı alternatif/seviye 2) | `ToplulukDekoru` (`td_o76`, `boy=3.20`) — dış çember | `degirmen` dere kenarı görseli veya ek su değirmeni (`CIL-06` seçimi) | Ham `(1.89, 1.15, 1.90) m`; `3.2 m` ölçekte `5.26 × 5.30 m` | `y0=-0.582` | Yok | `CIL-01`, `CIL-06` |
| `O79` | `dogrudan/o79_debbaghane_deri_gerdirme.glb` (1.16 MB) | Debbağhane (deri gerdirme) | `atolye` / `deri` işleme avlusu | `ToplulukDekoru` (`td_o79`) — dış çember | `atolye` avlusu çalışma alanı | Ham `(1.89, 0.75, 1.90) m`; hedef boy `1.45 m` | `y0=-0.374` | Yok | `CIL-01`, `CIL-07` |
| `O81` | `dogrudan/o81_yurume_yollu_ahsap_palisat.glb` (1.71 MB) | Yürüme yollu ahşap palisat | `sur` S2 (seğirdim yollu palisat) | **Bağsız** (`None`) | Köy kuzey/batı sur duvarı modülü | Ham `(1.90, 0.72, 0.75) m`; hedef boy `2.90 m` | `y0=-0.362` | Yok | `CIL-01`, `CIL-06` |
| `O84` | `dogrudan/o84_kapakli_bakir_tencere.glb` (0.55 MB) | Kapaklı bakır tencere | Ocak / han / ev eşyası | `ToplulukDekoru` (`td_o84`) — dış çember | `ortak_sofra`, `han` masa/ocak yanı | Ham `(1.90, 1.73, 1.90) m`; gerçek tencere `0.35 m`! | `y0=-0.862` | Yok | `CIL-01`, `CIL-07` |
| `O90` | `dogrudan/o90_tas_sur_duvari.glb` (1.34 MB) | Taş sur duvarı | `sur` S3 (taş sur modülü; `sur_3_tas.glb` alternatifi) | **Bağsız** (`None`) | Taş sur seviyesinde duvar segmenti | Ham `(2.00, 1.05, 0.50) m`; hedef boy `3.20 m` | `y0=-0.530` | Yok | `CIL-01`, `CIL-06` |
| `O92` | `dogrudan/o92_tas_cerceveli_demir_parmaklikli_kapi.glb` (1.00 MB) | Taş çerçeveli demir parmaklıklı kapı | `sur` S3 kapısı / `KapiCercevesi` S3 | **Bağsız** (`None`) | Taş sur seviyesi (`seviye >= 3`) kapı geçidi | Ham `(2.01, 1.24, 1.17) m`; hedef boy `4.20 m` | `y0=-0.619` | Yok | `CIL-01`, `CIL-06`, `CIL-12` |

**Ekstralar ve Eksikler (TOPLULUK_INCELEME.md & Disk Özeti):**
- **Diskte bulunan ekstra animasyonlu model:** `assets/meshy/ekstra/Meshy_AI_시장_한가운데_서_있는_듯한_활기찬_중세_상인_여성의_전신_3D_모델_20251018_animated_mixamo_All_animation.glb` (`1.99 MB` + `5.02 MB` PNG texture; ham boyut `(0.015, 0.016, 0.006) m`, `sk=1`, klipler: `Hand_on_Hip_Gesture`, `Idle_15`, `Running`, `Walking`). Doğu Asya giyim üslubu 14. yy Anadolu ucu ile çatışıyor → `CIL-03` ile karar/arşiv (ya reddedilir ya da yalnız uyarlanabilirse uzak diyar tüccarı olarak değerlendirilir).
- **Reddedilen 6 ekstra GLB (`TOPLULUK_INCELEME.md §E`):** Atina Süvarisi, Brahma Tavuğu, Cüce Yel Değirmeni (fantastik), Frostfur Warlord, Iron Warlord, Fatih Sultan Mehmed (15. yy — dönem dışı). Diskteki `ekstra/` klasörüne alınmamış ve alınmayacak.
- **Kaynak GLB'si hiç olmayan 14 kod (`TOPLULUK_INCELEME.md §C`):** `O31`, `O67`, `B065`, `O03`, `B021`, `A242`, `O82`, `O83`, `O93`, `A095`, `A002`, `K10`, `B104`, `A140` — bunlar için `CIL-03` kapsamında yeniden kredi harcamadan varsa hazır CC0/CC-BY eşdeğerine bakılır, yoksa envanterden temizlenir.

---

### 2.4. `assets/model/yapi/` (31 Yapı Modeli) ve Köy İnşa Sistemi Kök Neden Denetimi

**Neden `demirhane` ve diğer yapılar görünmüyor? (`koy_yonetim_sahnesi.gd:288-387` akış izi):**
1. **İnşaat halindeyken (`koy_yonetim_sahnesi.gd:293-295`):** `if not b.hazir(): _iskele(n, en, derin); return n` çağrılır. `_iskele()` yalnızca kahverengi 4 `BoxMesh` dikmesi + yatay sırıklar kurar; ne temel taşları, ne kısmi duvar, ne inşaat ilerlemesi ne de seçili yapının silüeti görünür.
2. **İnşaat bittiğinde (`koy_yonetim_sahnesi.gd:302`):** `if HazirKoyYapilari.kur(n, b.tur, en, derin):` devreye girer. `HazirKoyYapilari.KAPALI` (`hazir_koy_yapilari.gd:6`) şu 8 türü kapsar: `["kulube", "tas_ev", "ambar", "sifahane", "firin", "demirhane", "atolye", "kisla"]`.
   - `HazirKoyYapilari.kur()` (`satir 8-46`) her defasında tam boy kapalı **Quaternius MegaKit** bina örer (`w = minf(en * 0.82, 6.0)`, `d = minf(derin * 0.82, 6.0)`, `Roof_RoundTiles_4x6` çatısı, alçı/tuğla duvarlar).
   - Ardından (`satir 42-45`) `Dunya3B.nesne("demirhane", 2.8, "yapi")` oluşturup **aynen o kapalı MegaKit binanın tam merkezine (`Vector3.ZERO`)** çocuk olarak ekler! Sonuç: `demirhane.glb` (`3.34 × 2.80 × 3.36 m`) tamamen MegaKit duvarları ve çatısının içinde hapsolur ve **oyuncu kameradan göremez**.
3. **Ölü kod ve ad uyuşmazlığı:**
   - `koy_yonetim_sahnesi.gd:344-368` altında `"atolye", "demirhane"` ve `"ambar"` dalları yazılmıştır ama üstteki `HazirKoyYapilari.kur()` (`satir 302`) `true` dönüp `return` ettiği için **hiç çalışmaz**.
   - `HazirKoyYapilari.KAPALI` içindeki `"kisla"` kimliği `data/koy/binalar.json` ve `yapi_kademeleri.json` içindeki **`"muhafiz_kislasi"`** kimliğiyle eşleşmez!
   - `muhafiz_kislasi` `OlayYapilari.yapi_adi` üzerinden `Dunya3B.nesne("muhafiz_kislasi", 2.8)` alırken ham boyu `(0.944, 0.332, 0.759)` olduğundan `8.43x` ölçeklenir ve **`7.96 × 2.80 × 6.40 m`** boyuta fırlayarak `2×2` (`4×4 m`) parselinin **her iki kenarından ~2'şer metre dışarı taşar**.
   - `ahir.glb` ham boyu `(0.953, 0.651, 0.061)` olduğundan `y=2.8` ölçeğiyle **`4.10 × 2.80 × 0.26 m`** incelikte düz bir levha/kabartma gibi görünür (gerçek 3B ahır derinliği yok).

| Yapı ID (`binalar` / `yapi`) | Dosya Yolu (`assets/model/yapi/...`) | Ham Boyut `(X, Y, Z) m` | Godot Mevcut Çağrı Ölçeği `(X, Y, Z) m` | Parsel (`m`) | Bağ / Gölgeleme Durumu | Olması Gereken Bağ & Düzeltme | Gereken İş |
|---|---|---|---|---|---|---|---|
| `demirhane` | `demirhane.glb` | `(0.953, 0.798, 0.958)` | MegaKit içinde görünmez (`3.34, 2.80, 3.36`) | `4×4` | `KAPALI` içinde gölgeleniyor; manifest `bag=None` | MegaKit kaldır; `demirhane.glb` (`2.80 m`) + `A040` örs + `A042` körük avlu dekoru | `CIL-02`, `CIL-04`, `CIL-07` |
| `firin` | `firin.glb` | `(0.957, 0.657, 0.808)` | MegaKit içinde görünmez (`4.08, 2.80, 3.45`) | `4×4` | `KAPALI` içinde gölgeleniyor; manifest `bag=None` | MegaKit kaldır; `firin.glb` + `A177`/`A181` tandır + `A081` un çuvalı | `CIL-02`, `CIL-04`, `CIL-07` |
| `ambar` | `ambar.glb` | `(0.957, 0.569, 0.857)` | MegaKit içinde görünmez (`4.71, 2.80, 4.22`) | `6×4` | `KAPALI` içinde gölgeleniyor; `Z=4.22` sınırda | MegaKit kaldır; `ambar.glb` + `A190` tahıl çuvalları + `Z<=3.6 m` kırpımı | `CIL-01`, `CIL-04`, `CIL-07` |
| `sifahane` | `sifahane.glb` | `(0.954, 0.703, 0.927)` | MegaKit içinde görünmez (`3.80, 2.80, 3.69`) | `4×4` | `KAPALI` içinde gölgeleniyor | MegaKit kaldır; `sifahane.glb` + `A227` bakır kazan + yeşil/sıcak ışık | `CIL-02`, `CIL-04`, `CIL-07` |
| `tas_ev` | `tas_ev.glb` | `(0.958, 0.757, 0.962)` | MegaKit içinde görünmez (`3.54, 2.80, 3.56`) | `4×4` | `KAPALI` içinde gölgeleniyor | MegaKit kaldır; `tas_ev.glb` (K1–K2) veya `A116` varyant | `CIL-02`, `CIL-04` |
| `atolye` | `atolye.glb` | `(0.956, 0.585, 0.249)` | MegaKit içinde görünmez (`4.58, 2.80, 1.19`) | `4×4` | `KAPALI` içinde gölgeleniyor + Z ince (`0.25`) | MegaKit kaldır; `atolye.glb` + `A236` tezgâh / `O79` deri gerdirme | `CIL-01`, `CIL-04`, `CIL-07` |
| `kulube` | `ev.glb` (manifestte) | `(1.891, 1.119, 1.816)` | `ev.glb` hiç çağrılmıyor (`MegaKit` var!) | `4×4` | `HazirKoyYapilari.kur()` `kulube`'ye GLB eklemez | `ev.glb` (`3.5×2.8×3.4 m`) kulübeye bağla + `A117`/`O26` varyant olarak aç | `CIL-03`, `CIL-04` |
| `muhafiz_kislasi` | `muhafiz_kislasi.glb` | `(0.944, 0.332, 0.759)` | **`(7.96, 2.80, 6.40)`** — PARSEL DIŞINA TAŞIYOR | `4×4` | `OlayYapilari` ile bağlanıyor ama dev taşıyor | `X/Z <= 3.60 m` parsel kilidiyle ölçekle (boy `~1.8–2.1 m` veya parsel `3×3` değerlendirmesi) + `A016`, `O05` | `CIL-01`, `CIL-04` |
| `degirmen` | `degirmen.glb` | `(0.892, 0.600, 0.961)` | **`(4.76, 3.20, 5.12)`** + üstüne prosedürel Torus çark! | `6×6` | `DegirmenHareketi` GLB üstüne 2. baraka ve su çarkı çiziyor | Tek modele indir: `degirmen.glb` + yalnızca dönen ahşap kanat veya dere kenarında `O76` | `CIL-06`, `CIL-07` |
| `agil` | `agil.glb` | `(0.961, 0.300, 0.933)` | **`(5.77, 1.80, 5.60)`** + prosedürel çit | `6×6` | `CobanSurusu.agil_kur()` GLB çevresine fazladan çit koyuyor | `agil.glb` merkezinde tek parsel (`5.4 m` çap), fazlalık prosedürel çiti sadeleştir + `O64` çeper | `CIL-06`, `CIL-10` |
| `ahir` | `ahir.glb` | `(0.953, 0.651, 0.061)` | **`(4.10, 2.80, 0.26)`** — YASSI LEVHA! | `4×4` | `Z=0.26 m` kâğıt gibi ince (kabartma mesh) | Çift yüzlü/derin ahır modeli için 3D eksik veya `O30`/`A172`/`K05` açık sundurma ahırı kullan | `CIL-01`, `CIL-03` |
| `cozumleme_odasi` | `cozumleme_odasi.glb` | `(0.934, 0.899, 0.885)` | `(2.91, 2.80, 2.76)` | `4×4` | `CozumlemeOdaYerTutucu` önce küp kurup sonra gizliyor | Küp fallback yalnız GLB yoksa kurulsun | `CIL-03` |
| `cadir` | `cadir.glb` | `(1.898, 1.097, 1.898)` | Parselde uyumlu (~`2.2–2.6 m` hedef) | `4×4` | `koy_yonetim_sahnesi.gd:315` çağırıyor; manifest `bag=None` | `varlik_olculeri.json` + manifest `baglandi` güncellemesi | `CIL-01`, `CIL-02` |
| `hizarhane` | `hizarhane.glb` | `(0.782, 0.691, 0.952)` | `koy_yonetim_sahnesi.gd:336` | `4×4` | Çağrılıyor ama çevresi/ölçeği normsuz; manifest `None` | `X/Z <= 3.6 m`, `O00`/`O23` odun istifi yanına bağla | `CIL-01`, `CIL-07` |
| `odunluk` | `odunluk.glb` | `(0.950, 0.552, 0.943)` | `koy_yonetim_sahnesi.gd:336` | `4×4` | Çağrılıyor; manifest `None` | `X/Z <= 3.6 m` + `O00`/`O23` | `CIL-01`, `CIL-07` |
| `tas_ocagi` | `tas_ocagi.glb` | `(0.952, 0.951, 0.953)` | `koy_yonetim_sahnesi.gd:339` | `4×4` | Çağrılıyor; manifest `None` | `X/Z <= 3.6 m` + `O18` taş yığını | `CIL-01`, `CIL-07` |
| `tas_yatagi` | `tas_yatagi.glb` | `(0.958, 0.567, 0.788)` | `TasYatagiGorseli` (`boy=0.65`) | `2×2` | `tas_yatagi_gorseli.gd:13` kuruyor; manifest `None` | `X/Z <= 1.8 m` normalizasyonu + manifest `baglandi` | `CIL-01`, `CIL-02` |
| `avci_cadiri` | `avci_cadiri.glb` | `(0.881, 0.572, 0.708)` | **`avci` için KULLANILMIYOR!** | `4×4` | `OlayYapilari` `"avci"` → `avci` arar; dosya adı `avci_cadiri.glb`! | `OlayYapilari.YAPI_MAP["avci"] = "avci_cadiri"` (veya `binalar.json`) eşle | `CIL-03` |
| `kirec_kuyusu` | `kirec_kuyusu.glb` | `(0.959, 0.641, 0.950)` | `OlayYapilari` çağırıyor | `4×4` | Çağrılıyor; parsel sınır kontrolü yok; manifest `None` | `X/Z <= 3.6 m` + boy `1.9 m` | `CIL-01`, `CIL-02` |
| `demir_madeni` | `demir_madeni.glb` | `(0.960, 0.392, 0.840)` | **`(6.86, 2.80, 6.00)`** — PARSELE TAŞAR | `4×4` | `OlayYapilari` çağırıyor; dev taşıyor | `X/Z <= 3.6 m` parsel sınırı zorunlu | `CIL-01`, `CIL-04` |
| `demir_ocagi` | `demir_ocagi.glb` | `(0.945, 0.588, 0.940)` | `OlayYapilari` çağırıyor | `4×4` | Çağrılıyor; `boy=2.8 -> X=4.50 m` hafif taşar | `X/Z <= 3.6 m` + `A042` körük ekle | `CIL-01`, `CIL-07` |
| `gozetleme_kulesi` | `gozetleme_kulesi.glb` | `(0.485, 0.951, 0.580)` | `(3.06, 6.00, 3.66)` | `4×4` | `GozcuKulesiGorseli` (`gozcu_kulesi_gorseli.gd:17`) kuruyor; manifest `None` | `A113` (S1) → `O72` (S2) → `gozetleme_kulesi.glb` (S3) kademe seçimi netleştir | `CIL-02`, `CIL-06` |
| `kapi` | `kapi.glb` | `(1.895, 0.945, 0.271)` | Dış/köy kapısı | — | `koy_yonetim_sahnesi.gd` vs `KapiCercevesi` kullanım kontrolü; manifest `None` | Köy yönetim sahnesinde güney kapı geçişi + sur bağlantısı doğrulanır | `CIL-02`, `CIL-06` |
| `kapi_ic` | `kapi_ic.glb` | `(0.957, 0.634, 0.332)` | `KapiCercevesi` (`yuk=4.9` veya `seviye<=1`) | — | `kapi_cercevesi.gd:81-88` seviyesine göre çağrılıyor; manifest `None` | Seviye 0–3 sur geçişiyle tutarlı hale getir + manifest `baglandi` | `CIL-02`, `CIL-12` |
| `sur_2_palisat` | `sur_2_palisat.glb` | `(0.594, 0.354, 0.955)` | Köy sur S2 | — | Sahnede sur diziliminde yalnız `O37` / `sur_2_palisat` ikiliği var | Tek sur modül standart boy `4.0 × 2.8 × 0.8 m` (`O81`/`sur_2_palisat`) | `CIL-02`, `CIL-06` |
| `sur_3_tas` | `sur_3_tas.glb` | `(0.956, 0.387, 0.956)` | Köy sur S3 | — | Kullanımı sınırlı; manifest `None` | `O90`/`sur_3_tas` + `O92`/`kapi_ic` taş sur eşlemesi | `CIL-02`, `CIL-06` |
| `muhafiz_odasi` | `muhafiz_odasi.glb` | `(0.950, 0.505, 0.889)` | İç mekân sahnesi / kapı arkası | — | `MuhafizOdasiEkrani` yalnız 2D UI; 3B model sahneye bağlı değil | Köy/kapı içi muhafız odası köşesi ya da `oyun_disi/2D` manifest kaydı | `CIL-02`, `CIL-03` |
| `kervansaray` | `kervansaray.glb` | `(1.897, 0.633, 0.988)` | `han` / kervansaray olayı | — | `OlayYapilari["han"] = "pazar_tezgahi"` diyor; `kervansaray.glb` pasif | Han yapısı K2–K3 ya da kervan durağı için seçime al | `CIL-02`, `CIL-06` |
| `pazar_tezgahi` | `pazar_tezgahi.glb` | `(1.893, 1.173, 1.557)` | `han` (`OlayYapilari["han"]`) + gezgin satıcı | — | Manifest `bag=baglandi`; `OlayYapilari` ile çağrılıyor | `A073`/`A077`/`O65` ile tutarlı parsel ölçüsü | `CIL-01`, `CIL-06` |
| `su_bendi` | `su_bendi.glb` | `(0.963, 0.475, 0.500)` | Dere su bendi (`OlayYapilari`) | — | Manifest `bag=baglandi` | Dere üstü yön ve `y=0` su seviyesi oturtması | `CIL-01`, `CIL-12` |
| `yanik_ev` | `yanik_ev.glb` | `(0.962, 0.645, 0.940)` | Yanan/hasarlı bina durumu (`kundak` / baskın) | — | Manifest `bag=baglandi` | İnşaat/hasar sisteminde yanan yapı göstergesi (`CIL-05`) | `CIL-05` |

*Not — `assets/model/yapi/` karşılığı hiç olmayan `BinaKatalogu` türleri:* `bez_evi` (üretim — `dokuma_tezgahi` A236 + MegaKit veya 3D envanter ihtiyacı), `bostan` / `tarla` (prosedürel ekim parseli — kasıtlı), ve `chr_hedef` nokta yapıları (`bag_evi`, `bati_kapisi`, `civi_ocagi`, `dere`, `harman_yeri`, `hendek`, `koy`, `koy_cesmesi`, `koy_meydani`, `ortak_sofra`, `su_arki`, `su_kuyusu`, `sur`, `tamir_sundurmasi`, `tarla_dami`, `zindan`) — bunların bir kısmı yukarıdaki `topluluk` eşyalarıyla (`O21`, `O58`, `A060`, `A202`, `A040`) süslenmelidir.

---

### 2.5. Hayvanlar, İskeletli Modeller ve El Eşyaları Çakışmaları

| Varlık / Klasör | Ölçülen Boyut `(X,Y,Z) m` | Klipler | Bugünkü Sorun ve Çakışma | Çözüm (`CIL-*`) |
|---|---|---|---|---|
| `assets/hayvan/styloo/kopek.glb` | `(0.291, 0.710, 1.023)` | `["attack1", "iddle", "jump", "run", "walk", "walksent"]` | `HazirEsyaHayvan.hayvan("kopek")` (`hazir_esya_hayvan.gd:32-42`) önce `Dunya3B.model_var_mi("kopek", "hayvan")` → statik `assets/model/hayvan/kopek.glb` yükler! Üstelik `kopek_kur()` (`satir 129`) `"idle" in ad.to_lower()` aradığı için **`"iddle"` klibini yakalayamaz**, idle animasyonsuz kalır. | `CIL-09`: Animasyonlu `styloo/kopek.glb` öncelikli, `"iddle"` / `"idle"` normalize eşleme |
| `assets/model/hayvan/kopek.glb` vs `b019_kangal...glb` | `(0.625, 0.485, 0.956)` vs `(0.482, 1.403, 1.900)` | `anims=[]` (ikisi de statik) | Aynı tür için 3 köpek dosyası var (`styloo`, `model/hayvan/kopek`, `b019`) | `CIL-09`: Hareketli devriye/çoban köpeği = `styloo/kopek`; nöbetçi kulübe bekçisi = `b019_kangal` (riglenene dek ops.) |
| `assets/model/hayvan/{at,beygir,deve,inek,keci,koc,kurt}.glb` | Ham boy `0.70–0.90 m` | `anims=[]` (statik) | `CanliHayvanSurusu` ve `CelepHayvanGorseli` bunları kullanıyor ama ölçekleri insanın yarısı kadar veya yanlış oranlı (`deve.glb` `0.70 m` boy!) | `CIL-01`, `CIL-10`: `varlik_olculeri.json` gerçek omuz boyları (`at=1.55 m`, `deve=1.95 m`, `inek=1.40 m`, `keci=0.80 m`, `koc=0.85 m`, `kurt=0.78 m`) |
| `assets/hayvan/vertexcat/{inek,koyun}.gltf` | `inek: 1.59 m`, `koyun: 0.89 m` | `anims=[]` | `CobanSurusu` `koyun.gltf` kullanır; `k13_koyun.glb` (`animasyonlu`) oyuna hiç bağlı değil | `CIL-08`, `CIL-10`: `k13_koyun.glb` vertex AABB düzeltmesi sonrası `CobanSurusu`na bağlanır (`koyun.gltf` fallback) |
| `assets/model/nesne/okuz.glb` vs `a172_okuz.glb` | `(0.512, 1.070, 1.838)` vs `(0.715, 1.035, 1.993)` | `anims=[]` | Çift öküz modeli | `CIL-10`: Ayrıntı kalitesine göre `a172_okuz.glb` ahır/saban önünde birleştirilir |
| `assets/esya/kaykit_*` (19 `.gltf`) vs `ElEsyasi` (`el_esyasi.gd:55-92`) | Çeşitli | — | `ElEsyasi` bazı eşyalarda Meshy (`a012_mizrak`, `a211_orak`, `o51_sapli_sepet`, `o01_hasir_sepet`), bazı eşyalarda `HazirEsyaHayvan` KayKit (`cekic`, `kazma`, `odun`), yoksa prosedürel kutu kullanıyor; el tutuş rotasyonu ve `position.y` sabitleri elle tahmin edilmiş | `CIL-11`: `varlik_olculeri.json` içinde `el_esya` pivot/rotasyon ofsetleri tanımlanır |

---

### 2.6. Tekil Ölçek / Taban / Yön Normalizasyon Katmanı ve İnşaat Kademesi Mimarisi

#### A. Tekil Normalizasyon Katmanı (`data/varlik_olculeri.json` + `Dunya3B.nesne()`)
- **Nereye yazılmalı?**
  - Üretim hedef boyu (`boy_m`, `olcu`) `assets/meshy_manifest.json` içinde kalır (yalnız `tools/meshy/manifest.py -> yaz(nesne)` ile güncellenir).
  - Oyun içi kesin montaj kuralları **`data/varlik_olculeri.json`** dosyasında tutulur; böylece tekil model yolu, oyun parsel kısıtı ve pivot yönü manifest üretim kurallarından bağımsız okunabilir:
    ```json
    {
      "demirhane": { "hedef_boy_m": 2.80, "azami_ayak_m": [3.50, 3.50], "taban_y": 0.0, "yon_derece": 0.0, "eksen": "vertex_aabb" },
      "k04_tavuk": { "hedef_boy_m": 0.40, "azami_ayak_m": [0.45, 0.45], "taban_y": 0.0, "yon_derece": 0.0, "eksen": "vertex_aabb", "varsayilan_klip": "Walking" }
    }
    ```
- **Armature `scale=0.01` Kutu Hatasının Çözümü:** `Dunya3B._kutu()` (`dunya3b.gd:264-278`) bir `MeshInstance3D`'nin sadece lokal `Transform3D` zincirini çarpar; `Skeleton3D` kemik bind/pose matrislerini ve animasyonlu ilk kareyi hesaba katmazsa `0.000033 m` döner. Çözüm:
  1. `Skeleton3D` mevcutsa `Mesh.surface_get_arrays(ARRAY_VERTEX)` ham köşe noktalarını okuyup gerçek `Armature` ölçeğini (ya da tek bir `bake_frame` bind-pose kutusunu) hesaplayan `_gercek_kutu(kok)` yardımcısı,
  2. Ölçeği `olcek = min(hedef_boy / size.y, azami_x / size.x, azami_z / size.z)` biçiminde **üç eksen sınırıyla** hesaplamak (böylece `muhafiz_kislasi` `4×4 m` parselinden taşmaz, `a146` `0.40 m` üstüne çıkmaz),
  3. Merkez X/Z (`-kutu_orta.x, -kutu.position.y + taban_y, -kutu_orta.z`) hizalaması ve `rotation_degrees.y = yon_derece` uygulamak.

#### B. Profesyonel Kurgu Oyunlarına Göre İnşaat Kademesi Mimarisi
*Manor Lords*, *Banished* ve *Farthest Frontier* gibi ciddi tarihî köy kurucularda her yapı için 4 ayrı ağır Meshy modeli üretmek yerine **tek bitmiş hero model + hafif paylaşımlı şantiye katmanları** kullanılır:
1. **Aşama 0 — Yer İşareti / Kazık (`%0–%19`, ilk yerleştirme):** Zemin üzerinde parsel çerçevesi (`toprak sıkıştırma` splat + 4 köşe kazığı + ip).
2. **Aşama 1 — Temel ve İskele (`%20–%64`, `yapilan / insa_gun`):** Temel taş sırası (`BoxMesh` / `O18_tas_yigini` örneği) + ahşap dikme iskele (`_iskele`) + yapının asıl `.glb` modelinin yalnızca alt %40 dilimini gösteren clipping/yükselme veya Y ekseninde kademeli kaplama örtüsü (`shader` veya `ClipPlane` / yarı şeffaf ahşap kalıp).
3. **Aşama 2 — Çatı ve Tamamlama (`%65–%99`):** Asıl `.glb` model görünür hâle gelir; etrafında iskele sırıkları + `O00` kereste/taş yığını + inşaat tozu parçacığı kalır.
4. **Aşama 3 — Tamamlandı (`%100`, `b.hazir()`):** İskele sökülür, `HazirKoyYapilari` MegaKit **kaldırılır**, gerçek `.glb` + çevre `ToplulukDekoru` aktif eşyaları (`örs`, `kümes`, `odun istifi`, `çuval`) yerini alır.
5. **Hasarlı / Yanık Durum (`yanik` / `kundak`):** Olayla yanan bina geçici olarak `yanik_ev.glb` (küçük/konut yapılarında) veya asıl modelin karartılmış/dumanlı malzeme geçersiz kılmasıyla gösterilir.

---

## 3. Araştırma Özeti (Tur 3–4)

### 3.1. Tur 3 — Profesyonel Oyun Arayüzü ve Görsel Dil Araştırması

#### A. İncelenen 12 Referans Oyun ve Çıkarımlar
| Oyun | Kategori / İlgi Alanı | Referans Kaynağı | *Kapı Muhafızı* İçin Somut Tasarım Dersi |
|---|---|---|---|
| **Papers, Please** | Kapı sorgu & belge kontrolü | `gameuidatabase.com/gameData.php?id=1414` | Sahneyi boğmayan sabit çalışma masası bölgesi: karakter/pencere üst-sol (%55 alan), mühür/belge/seçenek sağ-alt bölgede; karar anı ses+mühür tatmini net. |
| **Manor Lords** | 14. yy Ortaçağ köy kurucu | `gameuidatabase.com/gameData.php?id=1957` | Üst HUD **ince tek şerit** (kaynaklar gruplu, yalnız sayı + küçük ikon + açılır net değişim); yapı seçilince alt-sağda tek bağlamsal kart; gereksiz süs sıfır. |
| **Frostpunk 1 & 2** | Ahlaki baskı & kriz yönetimi | `interfaceingame.com/games/frostpunk` | Kriz/umut/hoşnutsuzluk barları alt-orta/üst-köşede sabit; karar kartları merkezden sahneyi karartarak tek odak verir; tipografi yüksek kontrastlı ivory/amber. |
| **Farthest Frontier** | Ortaçağ köy yönetimi & inşaat | `store.steampowered.com/app/1044720` | İnşaat kartında yüzdelik ilerleme, atanan işçi +/- düğmesi ve eksik kaynak kırmızı rozetle gösterilir; kaynaklar 3 gruba (Ham / Üretim / Yaşam) bölünür. |
| **Banished** | Kompakt koloni HUD'u | `interfaceingame.com/games/banished` | Yükleyici/çalışan sayısı her yapı kartında `mevcut/azami` slot olarak anında ayarlanır; küçük pencereler sürüklenip kapatılabilir. |
| **Against the Storm** | İlerleme & olay penceresi | `gameuidatabase.com/gameData.php?id=1641` | Tehdit/sabırsızlık sayacı ile olay penceresi birbirinden kopmaz; seçenek üstüne gelince (hover) net sonuç önizlemesi görünür. |
| **Kingdom Come: Deliverance 1 & 2** | Tarihsel RPG / Codex / Diyalog | `interfaceingame.com/games/kingdom-come-deliverance` | Diyalog seçenekleri altta koyu dumanlı bant üstünde 1–4 numaralı; beceri/ikna zorluk etiketi seçenek yanında ikonlu; codex/defter koyu ahşap/kemik çerçeveli. |
| **Mount & Blade II: Bannerlord** | Anadolu/Türk-Balkan tarihî UI | `interfaceingame.com/games/mount-and-blade-ii-bannerlord` | Metal perçin, koyu meşe ve sıcak pirinç ince kenarlık; harita üstü tarih/mevsim kadranı kompakt dairesel/şerit formda. |
| **Crusader Kings III** | Karakter portresi & olay penceresi | `interfaceingame.com/games/crusader-kings-iii` | Portre sol/üstte tam boy çerçevede (`portrait_frame`), karakter ilişkisi/stres tek küçük simgede; ipucu (`tooltip`) üzerine gelince 0.3 s sonra kilitlenir. |
| **Pentiment** | Tarihsel anlatı & defter dili | `gameuidatabase.com/gameData.php?id=1498` | Konuşma geçmişi defter hissini bozmadan okunur; tipografi *Alegreya* + *Cinzel* benzeri serif hiyerarşisine dayanır (`assets/font/` içinde zaten mevcut!). |
| **This War of Mine** | Kıtlık & gece/gündüz döngüsü | `gameuidatabase.com/gameData.php?id=271` | Gece raporu tek sayfada "Ne oldu / Kim yaralandı / Ne eksildi" özetler; karakter kartı sade yorgunluk/açlık etiketleri taşır. |
| **Medieval Dynasty** | Köy yerleşimi & üretim ataması | `gameuidatabase.com/gameData.php?id=1766` | Köy yapılarında üretim tarifi seçimi ve yıllık/mevsimlik tüketim dengesi tek bakışta okunur (`kışın durur` uyarısı belirgin). |

#### B. Karşıt Kural — `ARY-01` Görsel Dil Çelişkisi (Ahmet vs Berk)
- `docs/arayuz/SABLONLAR.md:3-15` ve `CLAUDE.md:54`: Berk/Usta `ARY-01` şablonu olarak `parsomen` (*Parşömen*) seçtiğini kaydetti (`docs: ARY-01 Berk'in şablon seçimi Parşömen`).
- Buna karşılık Ahmet hem Çini, Parşömen ve Ocak şablonlarını reddetmiş hem de *web sitesi gibi düz kutular yerine* **`assets/ui/atmosfer/gece_kapisi/`** içindeki yağ lambası, koyu meşe, dövme demir ve atmosferik sahne resimlerine dayalı gerçek oyun arayüzünü yönlendirmiştir (`docs/arayuz/GECE_KAPISI_GORSEL_DENETIMI.md`).
- **Bu plan kendi başına karar vermez; `CIL-14` ön kapısı "Ahmet–Berk kararı gerekiyor" olarak işaretlenmiştir** (Seçenekler Bölüm 5'te).

#### C. Ekran Yerleşim Taslakları (ASCII) ve Ölçekleme / Erişilebilirlik Kuralları

**1) Ana Menü (`1920×1080`) — Atmosferik Sağ Odak / Sol Menü Düzeni**
```text
+------------------------------------------------------------------------------+
| [gece_kapisi/main_menu_bg.png — Sağda meşale/kandil, solda boş gece duvarı]  |
|                                                                              |
|    KAPI MUHAFIZI                   (Cinzel 44pt, #E6DDC6, ince gölge)        |
|    ==============                   (ornament_divider.png)                   |
|                                                                              |
|    [  Devam Et  ]  (Son: Gece 7)   (button_normal/hover/pressed.png + focus) |
|    [  Yeni Oyun ]                                                            |
|    [  Ayarlar   ]                                                            |
|    [  Çıkış     ]                                                            |
|                                                                              |
|                                                [ C1 Playtest Onay Penceresi ]|
| v0.x · festive · tr/en                         (Yalnız playtest ilk açılış)  |
+------------------------------------------------------------------------------+
```

**2) Kapı Sorgu Sahnesi (`1920×1080`) — Sahne Merkezi Korunmuş**
```text
+------------------------------------------------------------------------------+
| [hud_strip] Gün 4 · Güz | Akçe 42 | Erzak 18 | Odun 12 | Moral 74 | [Ayar][?]|
+------------------------------------------------------------------------------+
| +-Kişi / Beyan-------+                                +---Diyalog & Karar--+ |
| | [portrait_frame]   |   < 3B Kapı Çerçevesi >        | [dialogue_panel]   | |
| | Ayşe Bacı / Çiftçi |     Kişi (z=-2.5) +            | Tansiyon: [==--]   | |
| | Belge / Heybe Özeti|     Arka Plan (KapiManzara)    | "Köyden duman..."  | |
| | [Konuşma Geçmişi]  |                                | 1. Sert sor (Zar)  | |
| | [Beyan Defteri]    |   (%46 orta alan açık kalır)   | 2. Şefkatli sor    | |
| +--------------------+                                | 3. Heybeye bak     | |
|                                                       | [AL] [RED] [RÜŞVET]| |
+------------------------------------------------------------------------------+
```

**3) Köy Yönetimi (`1920×1080`) — İnce Üst Şerit + Alt Sağ Bağlamsal Yapı Kartı**
```text
+------------------------------------------------------------------------------+
| [Temel: Odun Taş Kereste Demir Alet | Yaşam: Erzak Akçe Kese | Gün/Hız 1x 2x]|
+------------------------------------------------------------------------------+
| [Sol Alt İkon Çubuğu]                                                        |
|  * İnşa Et                                                                   |
|  * Halk (Boşta: 2)                                  < 3B Köy Izgarası >      |
|  * Harita / Divan                                   Seçili yapı vurgusu +    |
|  * Muhafız Odası                                    Yürüyen köylü & hayvan   |
|  * Hafıza Defteri                                                            |
|                                                     +-Seçili Yapı / İnşaat-+ |
|                                                     | Demirhane [%66 İnşa] | |
| [Sol Bildirim: Kış yaklaşıyor / Tekfur uyarısı]     | İşçi: [-] 1/2 [+]    | |
|                                                     | [Tarif] [Onar] [Yık] | |
|                                                     +----------------------+ |
+------------------------------------------------------------------------------+
```

**Çözünürlük & Erişilebilirlik Standartları (`XAG 101/102`, `project.godot:27-32`):**
- **Ölçekleme:** `1920×1080` temelinde `canvas_items` + `expand`. `1280×720`'de (`%66.7`) gövde fontu `>= 18 pt` (= ekranda `12 pt` okunurluk), düğme yüksekliği `>= 44 px` (dokunma/fare rahatlığı), sol/sağ paneller `<= %28` genişlikte kalmalı (`%44+` 3B sahne alanı açık). `2560×1440`'ta paneller yüzde yerine maksimum piksel genişliğine (`max_width = 520 px`) sabitlenip kenarlarda boşluk açılmaz.
- **Güvenli alan:** Ekran kenarlarından en az `24 px` (`1920×1080`'de) dış marj; önemli uyarılar merkezden uzaklaşmamalı.
- **Kontrast & Renk-Körlüğü (`XAG 101`):** Fildişi yazı `#E6DDC6` koyu ahşap/karakalem zemin (`#10171C` / `#1D1714`) üstünde `> 10:1` kontrast sağlar. Kritik durum yalnız kırmızıyla değil **ikon + metin etiketi (`KRİTİK`, `UYARI`, `ARTIŞ`)** ile gösterilir.
- **Klavye / Focus (`XAG 102`):** Her düğme/kart `focus_mode = FOCUS_ALL`, görünür `focus_ring.png` (veya altın `2 px` çerçeve), `ESC` geri kapatma, `Tab`/ok tuşlarıyla kesintisiz gezinme ve `Ayarlar → Okuma / Hareket Azalt` senkronizasyonu zorunludur.

---

### 3.2. Tur 4 — Ses ve Müzik Envanteri, Bus Mimarisi ve Seviye Analizi

#### A. Mevcut Ses Dosyaları Ölçümü (`assets/ses/`)
Disk taramasında `assets/ses/` altında **73** `.import`-dışı dosya bulundu: **72 ses dosyası** (54 `.wav`, 18 `.ogg`) + **1 lisans metni** (`assets/ses/kenney_rpg/LICENSE.txt`). (`ROADMAP_4_ON_RAPOR.md:745`'teki "73 ses" bu lisans dosyasını da saymıştır.)

| Grup / Klasör | Dosya Sayısı | Örnekleme / Biçim | Ölçülen Peak Aralığı (dBFS) | Ölçülen RMS Aralığı (dBFS) | Tespit Edilen Sorunlar |
|---|---|---|---|---|---|
| Kök `assets/ses/muzik_*.wav` | 5 (`chr_gergin`, `chr_panik`, `chr_sakin`, `dugun_dongu`, `gece_dongu`) | `1ch`, `16k–44.1kHz`, `16b PCM` (`8–75 s`) | `-16.9` .. `-7.7 dBFS` | `-27.7` .. `-22.6 dBFS` | Sakin/gergin örnek `16 kHz` (boğuk üst frekans) ve kısa (`8 s` döngü tekrarı); seviye biraz düşük (`-24 dBFS` RMS). |
| Kök `assets/ses/ortam_*.wav` | 4 (`koy_dongu`, `koy_gece`, `koy_gunduz`, `mesale_dongu`) | `1ch`, `16k–44.1kHz`, `16b PCM` (`12–30 s`) | `-20.0` .. `-12.0 dBFS` | `-33.9` .. `-29.1 dBFS` | `ortam_koy_gunduz` / `gece` `-33.9 dBFS` (aşırı kısık ve `16 kHz`); `"Ambiance"` bus'ı `Efekt` altında kaldığı için bağımsız kısılıp açılamıyor. |
| Kök `assets/ses/sfx_*.wav` | 26 (`adim..yagmur`) | `1ch`, `22k–44.1kHz`, `16b PCM` (`0.06–3.0 s`) | `-20.3` .. `-3.0 dBFS` | **`-37.5`** (`sfx_bar_catlak`) .. **`-16.3 dBFS`** (`sfx_saldiri`) | **21.2 dB RMS farkı!** `sfx_bar_catlak` (`-37.5 dB`) neredeyse duyulmazken `sfx_saldiri`/`gece_bitti` (`-16.5 dB`) patlıyor. |
| `assets/ses/cici/*.wav` | 3 (`ic_cekim`, `mirilti`, `nefes`) | `2ch`, `48kHz`, **`32b Float (fmt_tag=3)`** | `-18.0` .. `-8.4 dBFS` | `-35.5` (`nefes`) .. `-22.3 dBFS` (`ic_cekim`) | 32-bit float `fmt_tag=3` tüm hedeflerde/standart WAV okuyucularda güvenli çalışması için `16b/24b PCM`'e veya kazanç tablosuna normalize edilmeli; `nefes` `-35.5 dB` çok kısık. |
| `assets/ses/rpg_sound/*.wav` | 4 (`chainmail1`, `coin`, `coin2`, `sword-unsheathe`) | `2ch`, `44.1k–48kHz`, `24b PCM` | `-0.1 dBFS` (clip sınırında!) | `-22.5` .. **`-15.5 dBFS`** (`coin`) | Peak `-0.1 dBFS` → yüksek geçici tepe (headroom yok, diğer SFX'lerden `+10–20 dB` sert duyulur). |
| `assets/ses/quendel/` (`dere_01.wav`, `dere_dongu.ogg`) | 2 (`41 s` `96kHz 24b` + `55.9 KB` `.ogg`) | `2ch` WAV + Vorbis OGG | WAV peak `-6.4 dBFS` | WAV RMS `-24.2 dBFS` | `dere_01.wav` `96 kHz` (~23 MB ham WAV); oyunda `dere_dongu.ogg` varken ham `96 kHz` WAV paketi şişirebilir (`PKT` sızıntı riski). |
| `.ogg` Klasörleri (`cyrex`, `heyhey`, `heyhey_savas`, `kenney_rpg`, `rubberduck`) | 28 `.ogg` (`6.8–33.0 KB`) | OGG Vorbis | — | (Import sonrası Godot LUFS/peak ölçümü `SES-01.b`'de alınacak) | `HazirSesKaynaklari.YOLLAR` (`hazir_ses_kaynaklari.gd:4-11`) yalnız 7 dosyayı eşler; örneğin `rubberduck/` (8 dosya), `cyrex/tahta_tik_*`, `heyhey_savas/` (6 dosya) büyük ölçüde kullanılmıyor veya yalnız `SVS-*`'yi bekliyor. |

#### B. Bus Mimarisi (`ROADMAP_4` Karar D2 ile Uyum)
- **Bugünkü çakışma:** `src/sistemler/ses.gd:28-37` yalnızca `Master -> Muzik, Efekt` oluşturur; `_ortam` çaları `"Efekt"`e bağlıdır. Ardından `src/sistemler/koy_ortam_sesi.gd:8-20` sahne yüklenince dinamik olarak `"Efekt"` altına `"Ambiance"` bus'ı yaratıp `_ortam`'ı `&"Ambiance"` yapar. `src/arayuz/ayarlar/ses_sekmesi.gd` yalnızca **Müzik** ve **Efekt** kaydırıcısı sunar.
- **Olması gereken (`CIL-19` / `SES-02`):**
  - Kalıcı `res://data/ses/default_bus_layout.tres` (ve `project.godot` ayarı) + `Ses._ready()` fallback: **`Master` → `Muzik`, `Efekt`, `Ortam`** (3 eşdüzey alt bus).
  - `Muzik` bus'ına **AudioEffectLimiter** (tavan `-1.0 dB`) + hafif stereo; `Efekt` bus'ına eşzamanlı UI/3D ses kotası (`<= 6` eşzamanlı SFX, `>= 60 ms` aynı SFX cooldown); `Ortam` bus'ına gece/gündüz crossfade (`1.5 s`).
  - **Sorgu / Diyalog Ducking:** Kapı sorgu repliği, önemli olay kartı veya muhafız seçimi açıldığında `Muzik` ve `Ortam` `0.35 s` içinde **`-6 dB`** indirilir, kapanınca `0.8 s` içinde `0 dB`'e döner.
  - **Hedef Loudness:** Müzik `-20 LUFS` (`-1 dBTP`), Ortam `-24 LUFS`, UI & Etki SFX `-16 LUFS` / Peak `<= -3 dBFS` (`data/ses/ses_denge_tablosu.json` üzerinden `bus_volume_db` telafisi; dosyayı yeniden sentezlemeden).

#### C. Eksik Ses İhtiyaçları ve Açık Lisanslı (CC0 / CC-BY) Kaynak Adayları (`Karar D1`)
Aşağıdaki kategorilerde oyunda boşluk vardır (`ROADMAP_4` `SES-03` ile ortak; `SVS-*` savaş sesleri Berk/Usta'nın `SVS-47` alanındadır):
1. **Tarihsel Anadolu / Ortaçağ Dönem Müziği (Menü, Gündüz Köy, Kriz/Kış):** Mevcut `16 kHz` kısa döngülerin yerine uzun (60–120 s) ud/ney/bendir/yaylı atmosfer parçaları — *OpenGameArt CC0 / CC-BY 4.0* (ör. Matthew Pablo / yd / Trevor Lentz CC0 ortaçağ folk etiketleri, URL ve atıf doğrulamasıyla).
2. **İnşaat ve Zanaat SFX (Çekiç, Testere, Körük, Fırın Çıtırtısı, Tarla Çapa):** Mevcut `rubberduck/hammer_01.ogg` ve `kenney_rpg/chop.ogg` genişletilecek; eksik körük/ocağa uygun **Sonniss GDC Game Audio Bundles** (Royalty-Free / kurumsal-ticari serbest lisans kontrolüyle) veya *OpenGameArt CC0* zanaat paketleri.
3. **Kapı, Mühür ve Arayüz Dokunsallığı (Parşömen çevirme, tahta sürgü, mühür basma):** `Kenney UI Audio` & `Kenney RPG Audio` (CC0, mevcut `assets/ses/kenney_rpg/` ile aynı kaynak) — `sfx_secim`/`sfx_onay` çeşitlendirmesi (3–5 varyasyonla kulak yorgunluğunu önleme).
4. **Mevsim & Hayvan Ortamı (Kış rüzgârı, yaz ağustos böceği, tavuk/koyun/köpek sesleri):** *OpenGameArt CC0* doğa/hayvan paketleri (`SES-03` & `SES-05` kapsamında lisans+URL kaydı `docs/credits/HAZIR_ASSET_ATIFLARI.md` içine eklenecek).

---

## 4. Uygulama Planı (Fazlar F0–F6, `CIL-01`..`CIL-22`)

> **Ortak İlkeler:**
> 1. `ROADMAP_2.md` açık/WIP maddeleri (`ARY-*`, `GRV-*`, `DYL-14`, `SEV-05`, `AYR-*`, `HAN-*`, `SOY-*`, `YIL-09`, `OGR-*`, `YAZ-01`) ve `ROADMAP_3.md` (`SVS-*`) **Berk/Usta** sorumluluğundadır. Berk tarafını ilgilendiren `CIL-*` maddelerinde kod yazmadan önce Ajan Masası (GitHub issue `#11`) üzerinden `[EMIR]` / onay alınır.
> 2. **Manifest kuralı:** `assets/meshy_manifest.json` ve `.csv` yalnızca `tools/meshy/manifest.py -> yaz(nesne)` çağrısıyla güncellenir.
> 3. **Test kuralı:** Tam `sanity_check.py` her adımda koşulmaz; **her `CIL-*` maddesinin kendi hedefli headless testi** (`SCRIPT ERROR`, eksik kaynak veya UID hatası gördüğünde `quit(1)` dönen) çalıştırılır.

### Faz F0 — Temel Normalizasyon, Manifest ve İsim/Yol Onarımı

- ✅ **`CIL-01` — Tekil 3B Ölçek, Taban, Yön ve `Skeleton3D` Vertex-AABB Normalizasyon Katmanı**
  - **Faz:** F0 · **Boyut:** `L` · **Önerilen Sahip:** Ahmet tarafı (`Cursor` / `Codex`)
  - **Sorun:** `Dunya3B.nesne()` (`src/dunya/dunya3b.gd:188-255`) yalnız Y yüksekliğine böler; `Armature` `0.01` ölçekli modellerde `_kutu()` (`dunya3b.gd:264-278`) `0.000033 m` ölçer (`k04_tavuk` 27× büyür, `k05_at`/`k13_koyun` görünmez/bozuk olur); `muhafiz_kislasi` `7.96 m` taşar, `ahir` `0.26 m` ince kalır.
  - **Yapılacak iş:** `data/varlik_olculeri.json` şeması oluştur (`hedef_boy_m`, `azami_ayak_m: [x, z]`, `taban_y`, `yon_derece`, `olcu_kural`: `"vertex_aabb"` | `"mesh_aabb"`). `Dunya3B._kutu()`'yu kemikli GLB'lerde yüzey köşelerini (`Mesh.ARRAY_VERTEX`) ve `Skeleton3D` kök transformunu hesaba katacak şekilde düzelt; `nesne()` içinde `olcek = min(hedef_y / size.y, max_x / size.x, max_z / size.z)` uygula, tabanı `y = taban_y`'ye ve X/Z merkezine oturt, `yon_derece` dönüşünü uygula.
  - **Dokunulacak dosyalar:** Yeni `data/varlik_olculeri.json`, `src/dunya/dunya3b.gd`, `src/koy/gorsel/hazir_sahne_modeli.gd`.
  - **Bağımlılıklar:** Yok.
  - **Kabul ölçütü:** `k04_tavuk` boyu `0.38–0.44 m`, `k05_at` `1.55–1.75 m`, `k13_koyun` `0.80–0.92 m`, her `yapi` GLB tabanı `y=0.0 ± 0.02 m` ve `X/Z <= parsel * 0.90` içinde kalır.
  - **Hedefli headless test:** Yeni `tests/unit/dunya/varlik_normalizasyon_test.gd` (tüm 69 topluluk + 31 yapı GLB'sini `Dunya3B.nesne()` ile örnekler, min/max boyut + `y0` sapması + script hatasında `quit(1)`).

- ✅ **`CIL-02` — `assets/meshy_manifest.json` Bağlantı & Ölçü Kayıtlarının `manifest.py -> yaz()` ile Senkronizasyonu**
  - **Faz:** F0 · **Boyut:** `S` · **Önerilen Sahip:** Ahmet tarafı (`Antigravity` / `Cursor`)
  - **Sorun:** 31 `yapi` satırının 28'i `oyun_baglantisi: None`, 18 `topluluk` satırı `None`, `cadir`/`ev`/`kapi`/`kervansaray`/`yanik_ev`/`pazar_tezgahi` `boy_m` alanı `None`.
  - **Yapılacak iş:** `tools/meshy/manifest.py` içindeki `kur()`/`yaz(nesne)` (`satir 716`) akışına `data/varlik_olculeri.json` ve gerçek kod bağlarını okuyup `oyun_baglantisi`, `boy_m` ve `olcu` alanlarını güncelleyen bir doğrulama komutu ekle ve `yaz(nesne)` ile `assets/meshy_manifest.json` + `.csv` yeniden üret.
  - **Dokunulacak dosyalar:** `tools/meshy/manifest.py`, `assets/meshy_manifest.json`, `assets/meshy_manifest.csv` (`yaz()` çıktısı).
  - **Bağımlılıklar:** `CIL-01`, `CIL-04`–`CIL-10` bağlantı kararları.
  - **Kabul ölçütü:** Oyunda kullanılan tüm `yapi` ve seçili `topluluk` satırlarının `oyun_baglantisi` ve `boy_m` değeri sıfır elle düzenlemeyle `manifest.py` üzerinden dolu gelir.
  - **Hedefli headless/Python test:** `tests/py/test_meshy_manifest_uyumu.py` (eksik dosya/bozuk durum/eksik `boy_m` kontrolü → exit 1).

- ✅ **`CIL-03` — Yapı ID Çakışmaları, Ölü Yer Tutucular ve Eksik/Ekstra Model Kararlarının Temizliği**
  - **Faz:** F0 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** `HazirKoyYapilari.KAPALI` `"kisla"` yazarken katalog `"muhafiz_kislasi"` kullanır; `OlayYapilari.YAPI_MAP` `"avci"` → `"avci"` arar (`avci_cadiri.glb` kullanılmaz); `CozumlemeOdaYerTutucu` önce küp ekleyip gizler; `bez_evi` ve `ahir` (`Z=0.061 m`) görseli yetersiz; `ekstra/` altındaki Koreli kadın modeli döneme uyumsuz.
  - **Yapılacak iş:** `OlayYapilari.YAPI_MAP` (`src/koy/gorsel/olay_yapilari.gd`) içine `"avci": "avci_cadiri"`, `"kulube": "ev"` ekle; `CozumlemeOdaYerTutucu` fallback küpünü yalnız GLB yüklenmezse kur; `ekstra/` koreli modeli arşivle/reddet kararı (Bölüm 5) + 14 kaynak GLB'siz kod için envanter temizliği; `ahir` ve `bez_evi` için 3D eksik kaydı / geçici sahne çözümü.
  - **Dokunulacak dosyalar:** `src/koy/gorsel/olay_yapilari.gd`, `src/koy/gorsel/cozumleme_oda_yer_tutucu.gd`, `docs/EKSIK_ASSET_ENVANTERI.md`.
  - **Bağımlılıklar:** Bölüm 5 kararları.
  - **Kabul ölçütü:** Her `BinaKatalogu` inşa edilebilir yapısının geçerli bir `.glb` veya bilinçli yer tutucu eşlemesi vardır; sıfır kırık yol uyarısı.
  - **Hedefli headless test:** `tests/unit/koy/yapi_gorsel_esleme_test.gd` (tüm `BinaKatalogu` türleri için düğüm kurup script/resource hatasında `quit(1)`).

---

### Faz F1 — Yapı Modelleri ve İnşaat Kademesi Bağlantısı

- ✅ **`CIL-04` — `HazirKoyYapilari.KAPALI` Gölgeleme Hatasının Kaldırılması (Demirci vb. Binaların Görünmesi)**
  - **Faz:** F1 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** `HazirKoyYapilari.kur()` (`src/koy/gorsel/hazir_koy_yapilari.gd:6-46`) ve `koy_yonetim_sahnesi.gd:302-307` kapalı MegaKit evinin içine `demirhane.glb`, `firin.glb`, `ambar.glb`, `sifahane.glb`, `tas_ev.glb`, `atolye.glb` modellerini hapsederek görünmez kılar; `satir 344` ve `368` ölü koddur.
  - **Yapılacak iş:** `HazirKoyYapilari.kur()` yalnız GLB modeli olmayan yapılar (fallback) için çağrılsın; `demirhane`, `firin`, `ambar`, `sifahane`, `tas_ev`, `atolye`, `kulube` (`ev.glb`), `muhafiz_kislasi`, `cadir`, `avci` (`avci_cadiri`), `kirec_kuyusu`, `demir_madeni`, `demir_ocagi`, `hizarhane`, `odunluk`, `tas_ocagi` doğrudan `Dunya3B.nesne()` ile normalleştirilmiş parsel zarfında sahneye basılsın.
  - **Dokunulacak dosyalar:** `src/koy/gorsel/hazir_koy_yapilari.gd`, `src/dunya/koy_yonetim_sahnesi.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-03`.
  - **Kabul ölçütü:** `demirhane` dahil tüm inşa edilebilir binaların kökünde `megakit_yapi` gölge kutusu bulunmaz; kamera açısından GLB mesh yüzeyi doğrudan görünür ve parsel sınırını aşmaz.
  - **Hedefli headless test:** `tests/unit/dunya/bina_gorunurluk_test.gd` (`demirhane`, `firin`, `ambar`, `sifahane`, `muhafiz_kislasi` kurup `megakit_yapi` yokluğu + AABB `<= parsel` kontrolü; ihlalde `quit(1)`).

- ✅ **`CIL-05` — Çok Aşamalı İnşaat İlerleme Kademeleri (%0 → %33 → %66 → %100) ve Hasarlı/Yanık Görseli**
  - **Faz:** F1 · **Boyut:** `L` · **Önerilen Sahip:** Ahmet tarafı (`Cursor` / `Antigravity`)
  - **Sorun:** `koy_yonetim_sahnesi.gd:293-295` inşaat halindeki tüm yapıları ilerlemeye bakmaksızın 4 ahşap direk (`_iskele`) gösterir; `yanik_ev.glb` hasar sistemine tam bağlanmamıştır.
  - **Yapılacak iş:** `YapiInsaati` (`yapilan / insa_gun`) oranına göre paylaşımlı hafif şantiye görselleştiricisi (`src/koy/gorsel/insaat_kademesi_gorseli.gd`) kur:
    - `%0–%33`: kazık + zemin temel taş çerçevesi + kereste istifi (`O18`/`O00` küçültülmüş).
    - `%34–%66`: etrafta ahşap iskele + asıl `.glb` modelin alt %55'i görünür (veya aşama 1 iskele içinde yükselen duvar).
    - `%67–%99`: tam `.glb` + ince son çatı iskelesi ve çalışırken hafif toz parçacığı.
    - `hasarlı / yanmış` bayrağı varsa konutlarda `yanik_ev.glb`, diğerlerinde duman + koyu hasar materyali.
  - **Dokunulacak dosyalar:** Yeni `src/koy/gorsel/insaat_kademesi_gorseli.gd`, `src/dunya/koy_yonetim_sahnesi.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-04`.
  - **Kabul ölçütü:** Aynı binanın `yapilan = 0, 1, 2` günlerindeki düğüm çocukları aşama ilerlemesine göre farklı geometri üretir ve bitişte iskele temizlenir.
  - **Hedefli headless test:** `tests/unit/dunya/insaat_kademesi_test.gd` (`0%`, `50%`, `100%`, `yanik` durumlarında düğüm doğrulama → `quit(1)`).

- **`CIL-06` ✅ — Çakışan Çift Yapıların Birleştirilmesi (`Değirmen`, `Ağıl`, `Gözetleme Kulesi`, `Han/Pazar`, `Sur`)**
  - **Faz:** F1 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** `DegirmenHareketi` (`degirmen_hareketi.gd`) `degirmen.glb` üstüne prosedürel baraka+çark bindiriyor (`O76_su_degirmeni.glb` dışta bekliyor); `CobanSurusu.agil_kur()` (`coban_surusu.gd:181`) `agil.glb` üstüne ayrı çit kuruyor; `nobetci_kulesi` için 3 aday (`gozetleme_kulesi.glb`, `A113`, `O72`), `han` için 4 aday (`pazar_tezgahi`, `A073`, `A077`, `O65`, `kervansaray`), `sur` için 6 modül (`O37`, `O81`, `O25`, `O90`, `O92`, `sur_2_palisat`, `sur_3_tas`) dağınık duruyor.
  - **Yapılacak iş:** Çift model bindirmelerini kaldır; her yapıya seviye/rol haritası kur:
    - `degirmen`: Köy parseli = `degirmen.glb` (yalnız dönen ahşap çark animasyonu, ikinci prosedürel kulübesiz); dere kıyısı su değirmeni = `O76` (karar opsiyonlu).
    - `agil`: Merkezde `agil.glb` + çeperde yalnız eksik taraflara `O64`.
    - `nobetci_kulesi`: S1 `A113` → S2 `O72` → S3 `gozetleme_kulesi.glb`.
    - `sur` / `kapı`: S1 `O37` + `O25` → S2 `O81` / `sur_2_palisat` → S3 `O90` / `sur_3_tas` + `O92`.
    - `han` / `pazar`: Ana yapı `pazar_tezgahi.glb` (K2+ `kervansaray.glb`) + yan tezgâhlar `A073`, `A077`, `O65`.
  - **Dokunulacak dosyalar:** `src/koy/gorsel/degirmen_hareketi.gd`, `src/koy/gorsel/coban_surusu.gd`, `src/koy/gorsel/gozcu_kulesi_gorseli.gd`, `src/dunya/koy_yonetim_sahnesi.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-04`, Bölüm 5 kararları.
  - **Kabul ölçütü:** `degirmen` üstünde ikinci prosedürel kulübe yok; `sur` seviye 1→2→3 yükseltmesinde ilgili sur/kule modelleri otomatik değişir.
  - **Hedefli headless test:** `tests/unit/dunya/yapi_yukseltme_gorseli_test.gd`.

- **`CIL-07` ✅ — `ToplulukDekoru` Dış-Izgara Yığınının Köy İçi Bağlama Dağıtılması**
  - **Faz:** F1 · **Boyut:** `L` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** `ToplulukDekoru` (`src/koy/gorsel/topluluk_dekoru.gd`, `koy_yonetim_sahnesi.gd:197`) 39 topluluk modelini yürüme ızgarasının dış çemberine vitrin gibi diziyor (`A040`, `A073` vb. ise hiç kullanılmıyor).
  - **Yapılacak iş:** Dış-ızgara vitrin listesini kaldır; her küçük/orta topluluk eşyasını ait olduğu binanın veya köy noktasının **avlu kenarına (`bina + local_offset`, yürüme hücresini tıkamadan)**:
    - `demirhane` / `demir_ocagi`: `A040` (örs), `A042` (körük).
    - `firin` / `ortak_sofra`: `A177` (kubbeli fırın), `A181` (tandır), `A081` (un çuvalı), `A209` (el değirmeni), `A227` / `A228` (kazan/sacayak), `O84` (tencere), `O14` (yumurta), `O07` / `O48` (çömlek/testi).
    - `degirmen` / `harman_yeri` / `ambar`: `A202` (tınaz), `A205` (değirmen taşı), `A190` (tahıl çuvalı), `O58` (saman arabası), `A220` (karasaban).
    - `odunluk` / `hizarhane` / `tas_ocagi` / `bostan`: `O00`, `O23`, `O18`, `A186`.
    - `atolye` / `bez_evi`: `A236` (kilim tezgâhı), `O79` (debbağhane), `A241` (çömlek).
    - `muhafiz_kislasi` / `koy_meydani` / `han`: `A016`, `O05`, `A060`, `O20`, `O49`, `O19` (saçak asılı!), `O32` (masa üstü), `O30` (`ahir` önü).
    - Orman/arka çevre: `K07` (ayı orman kenarına), `A116`/`A117`/`O26` arka köy yerleşim silüetine; `B117` (heykel) meydan/ağıl seçimine göre sadeleştirilir.
  - **Dokunulacak dosyalar:** `src/koy/gorsel/topluluk_dekoru.gd` (veya yeni `src/koy/gorsel/bina_avlu_esyalari.gd`), `src/dunya/koy_yonetim_sahnesi.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-04`.
  - **Kabul ölçütü:** Köy dışı yürüme sınırındaki yapay 39'lu halka yok olur; binalar kuruldukça ilgili avlu eşyaları doğru yerçekimi ve parsel yönünde belirir.
  - **Hedefli headless test:** `tests/unit/koy/avlu_esya_yerlesim_test.gd` (tüm eşya düğümlerinin `KoyZeminNavigasyonu` yürüme koridorlarını tıkamadığını doğrular; çakışmada `quit(1)`).

---

### Faz F2 — Animasyonlu Modeller, Hayvanlar ve Karakter Bağlantısı

- **`CIL-08` — İskeletli Animasyon Motoru (`k04_tavuk`, `k05_at`, `k13_koyun`, `k09_okcu_pers`, `k12_ortacag_tuccari`)**
  - **Faz:** F2 · **Boyut:** `L` · **Önerilen Sahip:** Ahmet tarafı (`Cursor` / `Antigravity`)
  - **Sorun:** Animasyonlu 5 Meshy GLB'sinin hiçbiri sahnede `AnimationPlayer.play()` çalıştırmıyor; `k05_at` ve `k13_koyun` `"Armature|Unreal Take|baselayer"` tek klibi kullanıyor ve kök ölçeği bozuk.
  - **Yapılacak iş:** Ortak `src/dunya/animasyonlu_varlik.gd` yardımcı sınıfını yaz:
    1. Klipleri `LOOP_LINEAR` döngüsüne al (`Walking`/`Running`/`RunFast`/`Idle_15`/`Armature|Unreal Take|baselayer`),
    2. Hız durumuna göre klip seçimi (`duruyor -> idle/ilk kare`, `yuruyor -> Walking`, `kosuyor -> Running`),
    3. Farklı hayvanlar aynı anda senkron zıplamasın diye rastgele `seek(randf_range(0, length))` faz kaydırması ve `AnimationPlayer` root motion kırpması (yerinde koşuyu kod hareketinden ayır).
  - **Dokunulacak dosyalar:** Yeni `src/dunya/animasyonlu_varlik.gd`, `src/dunya/dunya3b.gd`.
  - **Bağımlılıklar:** `CIL-01`.
  - **Kabul ölçütü:** 5 animasyonlu GLB'nin her biri örneklendiğinde `AnimationPlayer.is_playing() == true` ve `AABB` boyu gerçek dünya ölçüsündedir.
  - **Hedefli headless test:** `tests/unit/dunya/animasyonlu_varlik_test.gd`.

- **`CIL-09` — Köpek Modellerinin ve `"iddle"` Klip Hatasının Düzeltilmesi (`HazirEsyaHayvan.kopek_kur`)**
  - **Faz:** F2 · **Boyut:** `S` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** `HazirEsyaHayvan.hayvan("kopek")` (`src/koy/gorsel/hazir_esya_hayvan.gd:32-42`) statik `model/hayvan/kopek.glb`'yi animasyonlu `styloo/kopek.glb`'nin önüne koyar; `kopek_kur()` (`satir 129`) `"idle"` arar ama klipteki ad `"iddle"`dır. Ayrıca `b019_kangal` çoban köpeği boşta durmaktadır.
  - **Yapılacak iş:** Hareketli devriye/çoban köpeği için `assets/hayvan/styloo/kopek.glb` zorunlu önceliklendir; klip eşlemesini `["idle", "iddle"]`, `["walk", "walksent"]`, `["run"]`, `["attack1"]` olarak düzelt; `b019_kangal_anadolu_coban_kopegi.glb`'yi `agil`/`kapi` önü sabit bekçi seçeneği olarak normalleştir (veya `B019` için rig sırasına al).
  - **Dokunulacak dosyalar:** `src/koy/gorsel/hazir_esya_hayvan.gd`, `src/koy/gorsel/canli_hayvan_surusu.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-08`.
  - **Kabul ölçütü:** `kopek_kur()` sonrası `AnimationPlayer` mevcut animasyonu oynatır, idle seçimi `iddle` ile eşleşir (`0` klip kaçırma).
  - **Hedefli headless test:** `tests/unit/koy/kopek_animasyon_test.gd`.

- **`CIL-10` — Hayvan Sürülerinin Canlı Animasyon ve Ölçekle Köye Bağlanması**
  - **Faz:** F2 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** `k04_tavuk` devasa ve donuk; `k13_koyun` ve `a163_keci` bağsız; `a157_esek` ve `a172_okuz` dış çemberde sabit duruyor; `model/hayvan/` canlı hayvanları düşük boylu.
  - **Yapılacak iş:**
    - Tavuk: `k04_tavuk.glb` (`0.40 m`, `Walking`/`Running` animasyonlu) kulübeler ve `harman_yeri` etrafında küçük sürü olarak gezsin; `a146_tavuk_gercekci.glb` yalnız gagalı/duran varyant ya da reddedilmiş yedek olarak tekilleştirilsin.
    - Koyun & Keçi: `CobanSurusu` (`coban_surusu.gd`) içinde animasyonlu `k13_koyun.glb` (`0.85 m`) birincil, `a163_keci.glb` (`0.82 m`) sürüye çeşitlilik olarak bağlansın (`vertexcat/koyun.gltf` fallback).
    - Öküz, Eşek, At: `ahir` ve `han` avlusu önüne `a172_okuz.glb` (`1.35 m`), `a157_esek.glb` (`1.20 m`), ve `k05_at.glb` (`1.65 m`, animasyonlu; kervan/haberci sahnelerinde öncelikli).
  - **Dokunulacak dosyalar:** `src/koy/gorsel/canli_hayvan_surusu.gd`, `src/koy/gorsel/coban_surusu.gd`, `src/koy/gorsel/celep_hayvan_gorseli.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-08`, `CIL-09`.
  - **Kabul ölçütü:** Köy açılışında en az tavuk, koyun ve köpek sürüleri yürüme hızına göre animasyon değiştirir; tavuk boyu insan bacağının diz altındadır (`~0.40 m`).
  - **Hedefli headless test:** `tests/unit/koy/hayvan_surusu_cilalama_test.gd`.

- **`CIL-11` — Bağsız İnsan Figürleri (`k09`, `k12`, `k02`, `b092`, `k14`, `k15`) ve `ElEsyasi` Kalibrasyonu**
  - **Faz:** F2 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`) + Savaş okçu için **Berk/Usta `[EMIR]`**
  - **Sorun:** `k09_okcu_pers` (`6` klipli!) ve `k12_ortacag_tuccari` (`2` klipli!) animasyonlu olmalarına rağmen oyunda hiç yer almıyor; `k02`, `b092`, `k14`, `k15` rig bekliyor; `ElEsyasi` (`el_esyasi.gd:55-85`) elle girilmiş offset yüzünden `a012_mizrak` ve `a211_orak` avuçtan kayabiliyor.
  - **Yapılacak iş:**
    - `ROADMAP_4` **B1** (30 karakter sınırı) bozulmadan `k12_ortacag_tuccari` → `KoyHalkHareketi` içinde gezgin tüccar/han figürü veya kervan aktörü olarak bağlanır (`Walking`/`Running`); `k09_okcu_pers` → `nobetci_kulesi` / `muhafiz_kislasi` nöbetçi figürü olarak bağlanır (**Savaş `SVS-*` için kullanılacaksa Berk/Usta ile Ajan Masası `#11`'den koordine edilir**).
    - `k02`, `b092`, `k14`, `k15` animasyon rigleme sırası `docs/EKSIK_ASSET_ENVANTERI.md`'de işaretlenir (oyuna heykel olarak konmaz).
    - `ElEsyasi` (`a012`, `a211`, `o51`, `o01`, `kaykit_*`) avuç tutuş açısı ve `position.y` offsetleri `data/varlik_olculeri.json` içine taşınır.
  - **Dokunulacak dosyalar:** `src/dunya/el_esyasi.gd`, `src/koy/gorsel/koy_halk_hareketi.gd`, `data/varlik_olculeri.json`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-08`.
  - **Kabul ölçütü:** `k09` ve `k12` sahnede `1.70–1.75 m` boyda animasyonlu görünür; `ElEsyasi.olustur()` tüm 20 anahtar için mesh sınırını el merkezine `<= 0.15 m` hizalar.
  - **Hedefli headless test:** `tests/unit/dunya/el_esyasi_ve_aktor_test.gd`.

---

### Faz F3 — Atmosfer, Aydınlatma, Yön ve Kamera Cilası

- **`CIL-12` — 3B Aydınlatma, Mevsim/Gece Atmosferi ve Kapı-Köy Görsel Uyumlaştırması**
  - **Faz:** F3 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** Meshy modellerinin ham PBR dokuları gölgesiz ya da soğuk gece sahnesinde parlıyor/kararıyor; asma kandiller (`O19`) yerde duruyor; binaların ön kapıları yola bakmıyor.
  - **Yapılacak iş:**
    - Tüm köy yapılarının ön giriş yüzü (`yon_derece`) en yakın `izgara.yollar` hücresine otomatik döndürülür.
    - `O19_asma_toprak_kandil`, `O05_demir_mangal`, `A060_tas_halkali_ocak` gece saatinde sıcak `OmniLight3D` (`#FF9A40`, hafif titreme, gölge maliyeti düşük) yayar.
    - `KapiCercevesi` ve `KoyArazisi` `WorldEnvironment` tonemap (`ACES`) ve sis/kırağı eğrileri gece/kış okunurluğu bozulmayacak şekilde kalibre edilir.
  - **Dokunulacak dosyalar:** `src/dunya/koy_yonetim_sahnesi.gd`, `src/dunya/kapi_cercevesi.gd`, `src/koy/gorsel/koy_arazisi.gd`.
  - **Bağımlılıklar:** `CIL-04`, `CIL-07`.
  - **Kabul ölçütü:** Gündüz ve gece/kış ortamında binalar silüete gömülmez; kapılar yola bakar; gece meşale/mangal noktaları sahneye sıcak odak verir.
  - **Hedefli headless test:** `tests/unit/dunya/yon_ve_isik_test.gd`.

- **`CIL-13` — Kamera Sürükleme, Odaklanma ve `HareketAzalt` Cilası**
  - **Faz:** F3 · **Boyut:** `S` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`)
  - **Sorun:** Köy haritası büyüdüğünde veya yapı seçildiğinde kamera yumuşak odaklanmıyor; `HareketAzalt` ayarı (`src/sistemler/hareket_azalt.gd`) kamera geçişlerinde her noktada sayılmıyor.
  - **Yapılacak iş:** `kamera_surukleme.gd`, `kapi_kamera_gecisi.gd` ve `kapi_kamera_vurgu.gd` içinde yakınlaştırma (`min/max zoom`), `KoyArazisi` sınır clamp'i, bina/olay seçildiğinde isteğe bağlı yumuşak odaklanma (`HareketAzalt` aktifse anlık kesme) ve `cursor_grab.png` imleç dönüşü eklensin.
  - **Dokunulacak dosyalar:** `src/dunya/kamera_surukleme.gd`, `src/dunya/kapi_kamera_gecisi.gd`, `src/kapi/kapi_kamera_vurgu.gd`.
  - **Bağımlılıklar:** `CIL-12`.
  - **Kabul ölçütü:** Kamera hiçbir zoom değerinde ızgara/orman sınırının dışına kaçmaz; `HareketAzalt=true` iken tween süresi `0` olur.
  - **Hedefli headless test:** `tests/unit/dunya/kamera_sinir_test.gd`.

---

### Faz F4 — Atmosferik Oyun Arayüzü ve Tema Cilası *(Berk `ARY-*`/`GRV-*` Koordinasyonu Zorunlu)*

> **Kritik Çakışma Uyarısı:** `ROADMAP_2.md`'de `ARY-01..04, 70` ve `GRV-05/15/30/56` **Berk/Usta** üzerindedir; ayrıca `src/arayuz/ana.gd`, `hud.gd`, `tema.gd`, `koy_ekrani.gd` (`AGENTS.md §2`) korumalı çekirdek dosyalardır. `CIL-14`..`CIL-18` uygulanmadan önce issue `#11` üzerinde `[EMIR]` ve Ahmet–Berk şablon kararı netleştirilmelidir.

- **`CIL-14` — [KARAR KAPISI] `ARY-01` Görsel Dil Birleştirme ve `gece_kapisi` Varlıklarının `Tema`/`Kabuk`'a Bağlanması**
  - **Faz:** F4 · **Boyut:** `L` · **Önerilen Sahip:** **Berk/Usta `[EMIR]` + Ahmet Kararı** (Uygulama: `Claude/Codex-Berk` veya ortak onaylı `Cursor`)
  - **Sorun:** `assets/ui/atmosfer/gece_kapisi/` altında 44 PNG hazır (buton 4 durum, panel, portre çerçevesi, HUD şeridi, kaydırıcı, onay kutusu, 11 ikon, 4 arka plan); ancak UI hâlâ düz `StyleBoxFlat` kullanıyor ve Berk'in `parsomen` seçimiyle Ahmet'in *Gece Kapısı* tercihi çelişiyor.
  - **Yapılacak iş:** Ahmet–Berk kararı (Bölüm 5, Soru 1) verildikten sonra `Tema` (`tema.gd`) + `Kabuk` (`kabuk.gd`) `StyleBoxTexture` (9-slice değerleri `assets/ui/atmosfer/gece_kapisi/asset_manifest.json`'dan alınır) tek kaynaktan sağlayacak şekilde yükseltilir; `focus_ring.png` klavye/gamepad odağına, `Cinzel` başlık / `Alegreya` gövde fontuna bağlanır. Ölü `TemaOnizleme` / `ui_adaylari/onizleme.gd` (`ROADMAP_4` A1) kaldırılır.
  - **Dokunulacak dosyalar:** `src/arayuz/tema.gd`, `src/arayuz/kabuk.gd`, `src/arayuz/cerceve_kutu.gd`, `docs/arayuz/SABLONLAR.md`.
  - **Bağımlılıklar:** Bölüm 5 Soru 1 kararı + issue `#11` Berk koordinasyonu.
  - **Kabul ölçütü:** `Theme` tüm `Button`, `PanelContainer`, `HSlider`, `CheckBox`, `VScrollBar`, `TabBar` kontrollerinde 9-slice dokulu görünür; 44 PNG + 13 yeni ikon eksik `load()` vermez.
  - **Hedefli headless test:** `tests/unit/arayuz/tema_9slice_yukleme_test.gd`.

- **`CIL-15` — `MenuEkrani`, `VarlikYuklemePaneli` ve `YeniOyunEkrani` Atmosferik Yenilemesi**
  - **Faz:** F4 · **Boyut:** `M` · **Önerilen Sahip:** `Berk/Usta [EMIR]` + Ahmet tarafı `Cursor` (`TEL-02` / `ICR` uyumlu)
  - **Sorun:** Ana menü, yükleme örtüsü (`ColorRect`) ve yeni oyun senaryo/geçmiş seçimi düz koyu kutulardan oluşuyor; başlangıç senaryoları (`B2`) ilk günden belirgin değil; `C1` playtest ilk-açılış onayı eklenmeli.
  - **Yapılacak iş:**
    - `MenuEkrani`: `main_menu_bg.png` + sol negatif boşlukta `Cinzel` başlık + `button_*.png` + sürüm/tohum alt bilgisi + `playtest_mi()` ise ilk açılışta tek soruluk `TelemetriOnayPaneli` (`ROADMAP_4` `TEL-02`).
    - `VarlikYuklemePaneli`: `loading_bg.png` + `loading_track.png` / `loading_fill.png` ilerleme çubuğu + döneme uygun kısa ipucu satırı.
    - `YeniOyunEkrani`: 2 sütun kart düzeni (sol: 4 muhafız geçmişi kartı + 3 başlangıç senaryosu — **B2 kararı gereği hepsi ilk günden seçilebilir**; sağ: zorluk/mutatör özeti ve `Oyuna Başla`).
  - **Dokunulacak dosyalar:** `src/arayuz/menu_ekrani.gd`, `src/arayuz/varlik_yukleme_paneli.gd`, `src/arayuz/yeni_oyun_ekrani.gd`.
  - **Bağımlılıklar:** `CIL-14`.
  - **Kabul ölçütü:** `1280×720`, `1920×1080`, `2560×1440` çözünürlüklerinde hiçbir düğme taşmaz; 3 başlangıç senaryosu kilit işareti olmadan seçilebilir.
  - **Hedefli headless test:** `tests/unit/arayuz/menu_ve_yeni_oyun_olcek_test.gd`.

- **`CIL-16` — `KapiEkrani` (Sorgu HUD'u) Hiyerarşi ve Çerçeve Cilası**
  - **Faz:** F4 · **Boyut:** `M` · **Önerilen Sahip:** `Berk/Usta [EMIR]` + `Cursor`
  - **Sorun:** Sorgu ekranı sağ/sol sabit panelleri 3B kapıyı boğuyor; tansiyon ve zar sonuçları düz etiketlerle (`ChrDiyalogPaneli:43-69`) diziliyor; portre/belge penceresi tarihî atmosferden yoksun.
  - **Yapılacak iş:** `KapiEkrani` düzenini merkez `%46+` 3B kapıyı açık bırakacak yan raylara oturt; `portrait_frame.png` + `dialogue_panel.png` + `ornament_divider.png` ekle; `TansiyonGostergesi` ve `ZarSonucu` rozetlerini okunur ikon+renk-kör metne geçir; uzun konuşma geçmişi kaydırılır (`GRV-15` uyumlu).
  - **Dokunulacak dosyalar:** `src/arayuz/kapi_ekrani.gd`, `src/arayuz/chr_diyalog_paneli.gd`, `src/arayuz/kapi/tansiyon_gostergesi.gd`, `src/arayuz/kapi/zar_sonucu.gd`.
  - **Bağımlılıklar:** `CIL-14`.
  - **Kabul ölçütü:** `1280×720`'de merkez 3B karakter yüzü herhangi bir HUD panelinin altında kalmaz; tüm seçenekler kaydırma/sarma ile kesilmeden görünür.
  - **Hedefli headless test:** `tests/unit/arayuz/kapi_sorgu_yerlesim_test.gd`.

- **`CIL-17` — `KoyEkrani`, `Hud` Üst Şeridi ve Bağlamsal `YapiKarti` Cilası**
  - **Faz:** F4 · **Boyut:** `L` · **Önerilen Sahip:** `Berk/Usta [EMIR]` + `Cursor`
  - **Sorun:** Üst `Hud` (`hud.gd:125`) 11 kaynağı tek sırada sıkıştırıyor; seçili yapıda inşaat yüzdesi ve 3B durum kartta öne çıkmıyor; `icon_guvenlik..icon_diyalog` (13 ikon) eksik.
  - **Yapılacak iş:**
    - Üst `hud_strip.png` üzerinde kaynakları 3 okunabilir gruba ayır (`Temel Malzeme` | `Erzak & Kese` | `Köy & Zaman`) + `KeseGostergesi` vurgusu.
    - Alt-sağ `YapiKarti` (`yapi_karti.gd`) içine `loading_track/fill` tabanlı inşaat ilerleme çubuğu, `[-]` / `[+]` işçi slotu ve kısa tarım/kış durumu etiketi (`Manor Lords` / `Farthest Frontier` modeli) ekle.
    - Eksik 13 ikon slotu (`icon_guvenlik`..`icon_diyalog`, Bölüm 6) gelene kadar fallback SVG/metinle bağla, gelince `gece_kapisi/` PNG'lerine geç.
  - **Dokunulacak dosyalar:** `src/arayuz/hud.gd`, `src/arayuz/koy_ekrani.gd`, `src/arayuz/koy_hud/yapi_karti.gd`, `src/arayuz/koy_hud/kaynak_gostergesi.gd`.
  - **Bağımlılıklar:** `CIL-05`, `CIL-14`, Bölüm 6 2D ikonlar.
  - **Kabul ölçütü:** `1280×720` genişliğinde üst şerit taşmadan/kırpılmadan 2 satıra düşmeden sığar; seçilen inşaat yapısı `YapiKarti`nda gerçek `%` ilerlemeyi gösterir.
  - **Hedefli headless test:** `tests/unit/arayuz/koy_hud_olcek_test.gd`.

- **`CIL-18` — Yardımcı Ekranlar, Çözünürlük Matrisi, İmleçler ve Erişilebilirlik Denetimi**
  - **Faz:** F4 · **Boyut:** `M` · **Önerilen Sahip:** `Berk/Usta [EMIR]` (`GRV-05`, `GRV-15`) + `Cursor` (`TEL-04/07`)
  - **Sorun:** `HaritaEkrani`, `AyarlarEkrani`, `BilgiEkrani`, `MuhafizOdasiEkrani`, `DivanEkrani`, `HafizaDefteriEkrani` arka plan ve panel dokusu kullanmıyor; özel imleçler (`cursor_arrow/point/grab/busy.png`) aktif değil; `tr`/`en` metin uzunluğu taşma kontrolü (`ING-08.a`) eksik.
  - **Yapılacak iş:** `map_bg.png` → `HaritaEkrani`, `settings_panel.png` → `AyarlarEkrani` (D2 3. Ortam kaydırıcısı + `C2` "Test raporunu klasörde göster" düğmesi), `tooltip_panel.png` → tüm ipuçları (`0.3 s` gecikmeli kilitleme), `Input.set_custom_mouse_cursor()` ile 4 imleç bağlantısı, tüm `Control` düğümlerinde focus/klavye sırası + `en` taşma denetimi.
  - **Dokunulacak dosyalar:** `src/arayuz/harita_ekrani.gd`, `src/arayuz/ayarlar_ekrani.gd`, `src/arayuz/bilgi_ekrani.gd`, `src/arayuz/muhafiz_odasi_ekrani.gd`, `src/arayuz/hafiza_defteri_ekrani.gd`, `src/kapi/divan_ekrani.gd`.
  - **Bağımlılıklar:** `CIL-14`, `CIL-19`.
  - **Kabul ölçütü:** 3 hedef çözünürlükte (`1280×720`, `1920×1080`, `2560×1440`) hem `tr` hem `en` modunda `get_minimum_size() <= viewport` ve sıfır clipping uyarısı.
  - **Hedefli headless test:** `tests/unit/arayuz/cozunurluk_ve_focus_test.gd`.

---

### Faz F5 — Ses Dengesi, 3-Bus Mimari ve Hazır CC0/CC-BY (`ROADMAP_4` D1/D2 ile Birebir Hizalı)

- **`CIL-19` — `Master -> Muzik, Efekt, Ortam` 3-Bus Düzeni ve Ayarlar Kaydırıcısı (`ROADMAP_4` `SES-02`)**
  - **Faz:** F5 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`) + (`ses.gd` korumalı dosya olduğu için minimal adaptör)
  - **Sorun:** `koy_ortam_sesi.gd` `"Efekt"` altında `"Ambiance"` bus'ı üretiyor; `Ayarlar` ve `SesSekmesi` yalnız Müzik + Efekt sunuyor (Karar `D2` ihlali).
  - **Yapılacak iş:** `data/ses/default_bus_layout.tres` ekle ve `project.godot` içine bağla (`Master` → `Muzik`, `Efekt`, `Ortam`); `ses.gd` içine `_ortam` bus yönlendirmesi `&"Ortam"` olarak ekle (`koy_ortam_sesi.gd`'den `"Ambiance"` kaldır); `Ayarlar` (`ses_ortam: 0.75`) ve `ses_sekmesi.gd` içine 3. kaydırıcı ("Ortam Sesleri") ekle.
  - **Dokunulacak dosyalar:** `project.godot`, yeni `data/ses/default_bus_layout.tres`, `src/sistemler/ses.gd`, `src/sistemler/koy_ortam_sesi.gd`, `src/sistemler/ayarlar.gd`, `src/arayuz/ayarlar/ses_sekmesi.gd`.
  - **Bağımlılıklar:** Yok (Paralel başlatılabilir).
  - **Kabul ölçütü:** `AudioServer.get_bus_index("Ortam") != -1` ve üst bus'ı `"Master"`; `Ortam` susturulunca `Efekt` çalmaya devam eder, `Ortam` kesilir.
  - **Hedefli headless test:** `tests/unit/ses/bus_mimari_test.gd` (mevcut `ses_test.gd` genişletmesi; hata/eksikte `quit(1)`).

- **`CIL-20` — Mevcut 72 Ses Dosyasının Kazanç (`dB`) Normalizasyonu ve `dere_01.wav` Temizliği (`ROADMAP_4` `SES-01`)**
  - **Faz:** F5 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor` / `Antigravity`)
  - **Sorun:** Ölçülen RMS `-37.5 dBFS` (`sfx_bar_catlak.wav`) ile `-15.5 dBFS` (`rpg_sound/coin.wav`) arasında `22 dB` fark var; `rpg_sound/*.wav` peak `-0.1 dBFS` ile klip sınırında; `cici/*.wav` `32b Float`; `quendel/dere_01.wav` `96 kHz` (~23 MB) paketi şişiriyor (`dere_dongu.ogg` varken).
  - **Yapılacak iş:** `data/ses/ses_denge_tablosu.json` oluştur: her 72 ses dosyası için ölçülen RMS/Peak, hedef bus (`Muzik`/`Efekt`/`Ortam`) ve `telafi_db` (`sfx_bar_catlak` `+12 dB`, `sfx_gece_bitti`/`saldiri`/`coin` `-6..-8 dB`, `ortam_koy_gunduz/gece` `+8 dB`, `cici/nefes` `+10 dB`) tanımla; `Ses.cal`/`muzik_cal`/`ortam_cal` oynatırken `telafi_db`'yi baz hacme eklesin. `quendel/dere_01.wav` kullanılmıyorsa `PKT` paket dışlamasına (`export_presets`) al veya temizle.
  - **Dokunulacak dosyalar:** Yeni `data/ses/ses_denge_tablosu.json`, `src/sistemler/ses.gd`, `src/ses/hazir_ses_kaynaklari.gd`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`.
  - **Bağımlılıklar:** `CIL-19`.
  - **Kabul ölçütü:** 72 sesin tamamı `ses_denge_tablosu.json` ve `HAZIR_ASSET_ATIFLARI.md` içinde eşlenmiştir; telafi sonrası etkin oynatma RMS aralığı hedef bandın `±3 dB` içinde kalır.
  - **Hedefli headless test:** `tests/unit/ses/ses_denge_tablosu_test.gd`.

- **`CIL-21` — Eksik CC0/CC-BY Ses Paketleri, Sorgu Ducking'i ve Adaptif Müzik / Ses Kotası (`ROADMAP_4` `SES-03..09`)**
  - **Faz:** F5 · **Boyut:** `L` · **Önerilen Sahip:** Ahmet tarafı (`Cursor`, **insan/kaynak CC0-CC-BY indirmesiyle**) + Savaş `K16` kancası **Berk/Usta** uyumlu
  - **Sorun:** Menü ve gündüz köy temaları eksik (`16 kHz` 8 s döngüler tekrara düşüyor); sorgu sırasında müzik/ortam kısılmıyor; UI tıklama/adım/örs sesleri aynı karede üst üste patlayabiliyor; `K16` savaş sesleri boş.
  - **Yapılacak iş:**
    - `MuzikYonetmeni` crossfade (`Menü`, `Gündüz Köy`, `Kapı Sorgu`, `Gece Raporu`, `Kriz/Kış`; `SVS-47` için yalnız boş kanca `K16` — Berk dokunmadan).
    - Sorgu/olay kartı açılınca `Ortam` & `Muzik` `-6 dB` ducking.
    - Aynı kategori eşzamanlı ses limiti (`max_polyphony = 4`, cooldown `60 ms`) ve yazılı ses işareti (`SES-08`: `SesIsaretSeridi`).
    - İnşaat/UI/mevsim için doğrulanmış **CC0 / CC-BY** dosyaları (`Kenney UI`, `OpenGameArt CC0`, `Sonniss GDC`) kaynak URL + yazar + lisans ile `docs/credits/HAZIR_ASSET_ATIFLARI.md` & `docs/EKSIK_ASSET_ENVANTERI.md`'ye işlenir.
  - **Dokunulacak dosyalar:** `src/sistemler/tansiyon_muzigi.gd`, `src/ses/hazir_ses_kaynaklari.gd`, `src/sistemler/odak_sesi.gd`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`, `docs/EKSIK_ASSET_ENVANTERI.md`.
  - **Bağımlılıklar:** `CIL-19`, `CIL-20`.
  - **Kabul ölçütü:** 30 ardışık `adim` çağrısı aktif çalar kotasını aşmaz; sorgu açıldığında `Ortam` bus'ı `-6 dB` altına iner; eklenen her yeni sesin geçerli CC0/CC-BY atıfı yazılıdır.
  - **Hedefli headless test:** `tests/unit/ses/ducking_ve_kota_test.gd`.

---

### Faz F6 — Son Cilalama Doğrulaması

- **`CIL-22` — Cilalama Kapanış Kapısı (Hedefli Test Süiti ve Görsel/İşitsel Çekirdek Taraması)**
  - **Faz:** F6 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Cursor` / `Antigravity`) + `testx` oynanış duman turu (Berk)
  - **Sorun:** Her faz ayrı geçse bile entegrasyonda yeni `SCRIPT ERROR`, eksik UID veya `1280×720` çakışması doğabilir.
  - **Yapılacak iş:** Yalnız `CIL-01`..`CIL-21` testlerini çalıştıran birleşik hedefli koşucu + `KapiSahnesi` ve `KoyYonetimSahnesi` üzerinde tüm 31 yapı + 69 topluluk + `gece_kapisi` 57 slot yükleme/boyut kontrolü (tam `sanity_check.py` veya geniş `ROADMAP_2` tam paketi değil).
  - **Dokunulacak dosyalar:** `tests/oto/cilalama_kapisi_test.gd`, `docs/OYUN_TESTI_KONTROL_LISTESI.md` (sonuç işaretlemesi).
  - **Bağımlılıklar:** `CIL-01`..`CIL-21`.
  - **Kabul ölçütü:** Konsolda sıfır `SCRIPT ERROR`, sıfır `Failed to load script`, sıfır eksik `.uid`, tüm alt testler `exit 0` (aksi hâlde `quit(1)`).
  - **Hedefli headless test:** `Godot.exe --headless --path . -s tests/oto/cilalama_kapisi_test.gd`.

---

### Ek Tespitler (`CIL-23`..`CIL-25` — Ahmet'in Oynanış Gözlemleri)

- **`CIL-23` — Köylülerin Sakin Boşta Duruş (`idle`) Animasyonu**
  - **Faz:** F2 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Antigravity`)
  - **Sorun:** Köylüler ve insan karakterler boşta dururken fazla sallanıp hareket ediyor.
  - **Yapılacak iş:** `assets/model/hareket/` (383 dosya), `assets/animasyon/`, `assets/meshy/animasyonlu/` içindeki klipleri tara; yoksa Mixamo veya kodla kök/gövde salınımı bastırılmış, hafif nefes alma ve yavaş (`>= 3 s` periyot, `<= ±25°`) baş bakışlı sakin bir `sakin_bekle` klibi/retarget katmanı üret ve 30 karakter ile varyantlarında varsayılan boşta klip yap; hangi karakterin hangi iskeleti kullandığını tabloya yaz.
  - **Dokunulacak dosyalar:** `src/dunya/karakter_model.gd`, `src/koy/gorsel/karakter_bekleme_cesitliligi.gd`, `src/dunya/hazir_karakter_animasyonu.gd`.
  - **Bağımlılıklar:** `CIL-08`.
  - **Kabul ölçütü:** Boşta duran köylülerin kök kemiği `1 sn` içinde `<= 2 cm` yer değiştirir; baş dönüşü `±25°` ve `>= 3 s` periyotludur; 30 karakter ve varyantlarında klip bulunur.
  - **Hedefli headless test:** `tests/oto/sakin_bosta_kontrol.gd` (`quit(1)` on failure).

- **`CIL-24` — Karakterlerde Kol, Omuz ve Vücut Tutarsızlıkları Denetimi ve Düzeltmesi**
  - **Faz:** F2 · **Boyut:** `L` · **Önerilen Sahip:** Ahmet tarafı (`Antigravity`)
  - **Sorun:** Bazı insan karakterlerde kollar gövdeye giriyor, kol/omuz oranları veya uzunlukları tutarsız, A-poz/T-poz kalıntıları ya da ters dönen kemik/normaller var.
  - **Yapılacak iş:** `assets/model/karakter/`, `assets/karakter/`, `assets/meshy/` ve 30 karakter + varyantlarının kemik pozisyonlarından omuz genişliği/boy, kol uzunluğu/boy ve boşta kol–gövde kesişimini kodla ölç; çözüm sırası (a) kemik pose/rest ofseti ile kolu gövdeden uzaklaştırma, (b) kemik oran düzeltme, (c) düzelmeyeni uygun modelle değiştirme; tam tabloyu ve önce/sonra ekran görüntüsü yollarını `docs/KARAKTER_GOVDE_DENETIMI.md` raporuna yaz.
  - **Dokunulacak dosyalar:** `docs/KARAKTER_GOVDE_DENETIMI.md`, `src/dunya/durus_duzeltici.gd`, `src/dunya/karakter_model.gd`.
  - **Bağımlılıklar:** `CIL-23`.
  - **Kabul ölçütü:** Köyde kullanılan hiçbir karakterde boşta pozda kol–gövde kesişmesi kalmaz; kol uzunluğu/boy oranı `±%10` içindedir.
  - **Hedefli headless test:** `tests/oto/karakter_govde_kontrol.gd` (`quit(1)` on failure).

- **`CIL-25` ✅ — Kapı Bekçiliği Sahnesi Asset Çakışmaları ve Kamera Açısı Cilası**
  - **Faz:** F1 · **Boyut:** `M` · **Önerilen Sahip:** Ahmet tarafı (`Antigravity`)
  - **Sorun:** Kapı sahnesinde `kapi.glb`, sur parçaları (`O37`, sur 1/2/3), `O58` araba, `A016` mızrak sehpası ve çevre dekorları birbirinin üstüne biniyor; kamera açısı ve paneller gelen kişiyi/kapıyı kötü gösteriyor.
  - **Yapılacak iş:** Kapı sahnesindeki tüm görünür nesnelerin AABB'lerini çıkarıp 1 cm üstü iç içe geçmeleri yeniden konumlandır/ayır; kamera açısını (`kapi_kamera_gecisi.gd`, `kapi_kamera_vurgu.gd`, `kapi_sahnesi.gd`) *Papers, Please* / *Kingdom Come* benzeri göz hizasına yakın hafif yukarı bakışa kalibre et; gündüz ve gece önce/sonra ekran görüntüleri al.
  - **Dokunulacak dosyalar:** `src/dunya/kapi_cercevesi.gd`, `src/dunya/kapi_sahnesi.gd`, `src/dunya/kapi_kamera_gecisi.gd`, `src/kapi/kapi_kamera_vurgu.gd`, `src/arayuz/kapi_ekrani.gd`.
  - **Bağımlılıklar:** `CIL-01`, `CIL-04`.
  - **Kabul ölçütü:** Görünür nesneler arasında `> 1 cm` istenmeyen iç içe geçme yok; gelen kişinin başı ve gövdesi `1920×1080`'de orta üçte birde ve panel altında değil.
  - **Hedefli headless test:** `tests/oto/kapi_sahne_cakisma_kontrol.gd` (`quit(1)` on failure).

---

## 5. Karar Soruları (Ahmet & Berk) — Ahmet Tarafından Onaylanan Kararlar (17 Kas 2026)

1. **[Ahmet Kararı Onaylandı · Berk `ARY-01` için issue #11 `[EMIR]` süreciyle uygulanacak] `ARY-01` Arayüz Görsel Dili (Hibrit):**
   - **Karar:** **Gece Kapısı** ana tema olacak (`assets/ui/atmosfer/gece_kapisi/*.png`); **Parşömen** ise yalnızca defter, beyan ve belge panellerinde yaşayacak (hibrit).

2. **[Ahmet Kararı Onaylandı] Dış Mekan Tekilleştirmeleri:**
   - **Tavuk:** `a146_tavuk_gercekci.glb` kalır, `k04_tavuk.glb` sahneden çıkar.
   - **Değirmen:** Meshy `O76_su_degirmeni.glb` kalır, eski `degirmen.glb` sahneden çıkar.
   - **Ahır:** Bozuk `ahir.glb` (`Z = 0,061 m`) kullanılmaz; yerine düzgün ahır yer tutucusu/yapısı konur.
   - **Koreli satıcı (`assets/meshy/ekstra/`):** Repodan çıkarılır.

3. **[Ahmet Kararı Onaylandı] Askerî Modeller (`k09`, `k02`) ve İnsan Figürleri:**
   - `k09_okcu_pers` ve `k02_kipcak_kuman_savascisi` köyde `muhafiz_kislasi` çevresinde sakin nöbet animasyonuyla durur. `ROADMAP_3` (`SVS-*`) savaş kullanımı Berk'e bırakılır.

4. **[Ahmet Kararı Onaylandı] `muhafiz_kislasi` Ölçeği & Kimlikler:**
   - `muhafiz_kislasi` `3×3` (`6×6 m`) parsele genişler; `kisla` ↔ `muhafiz_kislasi` ve `avci` ↔ `avci_cadiri` kimlik eşleşmesi düzeltilir.

5. **[Ahmet Kararı Onaylandı] `quendel/dere_01.wav`:**
   - `96 kHz` → `48 kHz`'e indirilir (ses sistemine bağlamaya ve `CIL-19..21`'e dokunulmaz; o faz başka ajan tarafından yürütülüyor).

---

## 6. Nano Banana 2D Parça Listesi ve Hazır İngilizce Promptlar

### 6.1. Mevcut ve Eksik Parça Durumu (`assets/ui/atmosfer/gece_kapisi/`)
- **Hazır olan (44 PNG, `asset_manifest.json` kayıtlı):** `01–04` arka planlar (`main_menu_bg`, `interrogation_bg`, `map_bg`, `loading_bg`), `05–33` temel kontrol & süs & imleçler (`dialogue_panel`, `button_normal/hover/pressed/disabled`, `villager_card`, `portrait_frame`, `settings_panel`, `tooltip_panel`, `hud_strip`, `focus_ring`, `tab_normal/selected`, `checkbox_off/on`, `slider_track/thumb`, `scrollbar_track/thumb`, `loading_track/fill`, `ornament_corner/divider/emblem/seal`, `cursor_arrow/point/grab/busy`), ve `34–44` ilk 11 kaynak/durum ikonu (`icon_akce`..`icon_yatak`). **Bunlar tekrar üretilmez.**
- **Katalogda sırasını bekleyen (13 PNG, promptları `docs/arayuz/GEMINI_TEKLI_URETIM_PROMPTLARI.md` içinde zaten hazır):**
  - `45` `icon_guvenlik.png` · `46` `icon_adalet.png` · `47` `icon_gun.png` · `48` `icon_kabul.png` · `49` `icon_ret.png` · `50` `icon_uyari.png` · `51` `icon_kilit.png` · `52` `icon_geri.png` · `53` `icon_kapat.png` · `54` `icon_ayarlar.png` · `55` `icon_kaydet.png` · `56` `icon_harita.png` · `57` `icon_diyalog.png` (`256×256`, `#00FF00` saydam anahtarlı).

### 6.2. Cilalama Planında Eklenen Yeni 2D Parçalar + Tekli Nano Banana Promptları

Ahmet tarafından Nano Banana Pro ile üretilecek 4 yeni cilalama parçası (`gece_kapisi` stili, düz `#00FF00` saydam anahtar, sıfır metin):

#### A · `building_context_card.png` — Köy Alt-Sağ Bağlamsal Yapı & İnşaat Kartı
- **Nihai dosya:** `assets/ui/atmosfer/gece_kapisi/building_context_card.png` · **Ölçü:** `768×512` RGBA (dışı saydam) · **9-slice S/Ü/Sa/A:** `96/96/96/96` · **Kaynak tuvali:** `3:2`

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI art for a 14th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, dark charcoal #10171C inner panel, seasoned walnut wood #30251F frame, hand-forged iron #58616A corner brackets, subtle warm amber #C88A43 rim highlight.
Design a single compact rectangular medieval wooden-and-iron HUD building inspection panel seen flat head-on, slightly beveled oak rim with small iron rivets at the four corners and a quiet dark interior center suitable for readable ivory game text.
Keep the frame strictly centered inside the canvas with a clean silhouette edge against a solid flat pure chroma green background #00FF00 outside the frame. Keep the inner center panel opaque dark wood/charcoal, NOT green.
no text, no letters, no numbers, no icons, no portraits, no buttons, no checkerboard, no labels, no shadows cast onto green, no 3D render.
```

#### B · `day_night_banner_bg.png` — Gece Raporu & Olay Penceresi Atmosfer Başlığı
- **Nihai dosya:** `assets/ui/atmosfer/gece_kapisi/day_night_banner_bg.png` · **Ölçü:** `1536×384` Opak RGB · **9-slice:** `0/0/0/0` · **Kaynak tuvali:** `16:9` (alt-üst kırpılacak geniş banner)

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI header illustration for a 14th-century Anatolian frontier village, painterly ink-and-gouache style, matte surfaces, grounded historical tone.
Smoky charcoal #10171C night sky transitioning gently to warm lantern amber #C88A43 horizon glow, faint silhouette of wooden palisade watchtower and Anatolian ridge mist along the bottom edge, keeping the center wide dark and uncluttered for readable title text overlay.
Fill the entire 16:9 canvas edge-to-edge with continuous atmospheric scene, no UI frame, no borders.
no text, no letters, no numbers, no figures in close-up, no fantasy magic, no glowing runes, no checkerboard, no website mockup.
```

#### C · `ending_chronicle_bg.png` — Oyun Sonu / Epilog Atmosferik Arka Planı (`BilgiEkrani` & `TEL-07`)
- **Nihai dosya:** `assets/ui/atmosfer/gece_kapisi/ending_chronicle_bg.png` · **Ölçü:** `1920×1080` Opak RGB · **9-slice:** `0/0/0/0` · **Kaynak tuvali:** `16:9`

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D game UI background for a serious 14th-century Ottoman Anatolian frontier chronicle screen, painterly ink-and-gouache shading, charcoal #10171C, dark oak #30251F, worn iron #58616A, restrained amber #C88A43 candlelight, ivory #E6DDC6 mist tones.
An atmospheric interior of a quiet stone-and-timber frontier guardroom at dawn: an open wooden table corner with a brass wax seal, an unlit quill and faint morning light filtering through a narrow iron-barred window on the right, while the center-left two thirds remain softly shadowed and calm so end-of-run text and statistics sit legibly over the background.
Fill the full 16:9 canvas cleanly with no borders.
no text, no letters, no pseudo-calligraphy, no modern items, no portraits, no buttons, no checkerboard, no 3D render.
```

#### D · `app_icon_master.png` — Uygulama İkonu Ana Görseli (`ROADMAP_4` Karar E2 / `PKT-01` ile Ortak)
- **Nihai dosya:** `assets/ui/app_icon_master.png` (`1024×1024` Opak RGB → insan eliyle `.ico` çevrimi) · **Kaynak tuvali:** `1:1`

```text
Create ONE actual image now, not a list, plan or filename response.
Original hand-painted 2D emblem art for a 14th-century Anatolian frontier village gatekeeper desktop application icon, bold readable silhouette even at 32x32 pixels, dark iron #10171C and #58616A, heavy oak #30251F, warm amber lantern #C88A43, ivory highlight #E6DDC6.
Front-facing heavy timber-and-iron medieval frontier gate archway slightly ajar with a warm amber oil-lamp glow pouring through the narrow central gap against deep night blue-charcoal shadow, framed inside a clean beveled octagonal forged-iron medallion centered cleanly in the 1:1 square.
no text, no letters, no numbers, no crest ribbons, no watermark, no checkerboard, no fantasy dragons or swords.
```

---

## 7. `docs/EKSIK_ASSET_ENVANTERI.md`'ye Eklenecek Satırlar (2D ve 3D Ayrı)

*(Bu belge yalnız plan belgesi olduğu için `docs/EKSIK_ASSET_ENVANTERI.md` henüz değiştirilmedi; `CIL-03` / `CIL-17` / `CIL-21` aşamasında aşağıdaki satırlar ilgili bölümlere eklenecektir.)*

### 7.1. Eklenecek 2D Arayüz Satırları (`2D Assetler` bölümü)
| Kimlik | Tür | Hedef Yol & Boyut | Saydamlık | Kaynak / Yöntem | Bağlı `CIL` | Öncelik |
|---|---|---|---|---|---|---|
| `UI-ICON-45..57` | 13 eksik ikon (`guvenlik`..`diyalog`) | `assets/ui/atmosfer/gece_kapisi/icon_*.png` (`256×256`) | RGBA (`#00FF00` anahtar) | Nano Banana Pro (promptlar `GEMINI_TEKLI_URETIM_PROMPTLARI.md`'de hazır) | `CIL-17` | Yüksek |
| `UI-KOY-KART` | Alt-sağ bağlamsal yapı kartı | `assets/ui/atmosfer/gece_kapisi/building_context_card.png` (`768×512`, 9-slice `96`) | RGBA (`#00FF00` anahtar) | Nano Banana Pro (Bölüm 6.2-A) | `CIL-17` | Yüksek |
| `UI-RAPOR-UST` | Gece raporu/olay başlık bandı | `assets/ui/atmosfer/gece_kapisi/day_night_banner_bg.png` (`1536×384`) | Opak RGB | Nano Banana Pro (Bölüm 6.2-B) | `CIL-18` | Orta |
| `UI-SON-ARKA` | Oyun sonu / epilog arka planı | `assets/ui/atmosfer/gece_kapisi/ending_chronicle_bg.png` (`1920×1080`) | Opak RGB | Nano Banana Pro (Bölüm 6.2-C) | `CIL-18` | Orta |
| `UI-APP-ICON` | Masaüstü uygulama ikonu | `assets/ui/app_icon_master.png` (`1024×1024` → `.ico`) | Opak RGB | Nano Banana Pro + insan `.ico` dönüşümü (Karar E2) | `CIL-15` | Orta |

### 7.2. Eklenecek 3D ve Ses Satırları (`3D Assetler` ve `Ses` bölümleri)
| Kimlik | Tür | Açıklama / Hedef Ölçü (m) | Arama Anahtarları (TR+EN) / Kaynak Kuralı | Yer Tutucu / Mevcut Durum | Bağlı `CIL` | Öncelik |
|---|---|---|---|---|---|---|
| `3D-AHIR-DERIN` | 3D Yapı | 14. yy ahşap-taş köy ahırı (dolu derinlik, `3.6 × 2.8 × 3.4 m`; mevcut `ahir.glb` `0.061 m` ince levha) | `ahır`, `wooden medieval stable barn`, CC0/CC-BY veya Meshy planı | Mevcut ince `ahir.glb` + sundurma yalak | `CIL-03` | Yüksek |
| `3D-BEZEVI` | 3D Yapı | Anadolu köy dokuma atölyesi / bez evi (`3.6 × 2.8 × 3.4 m`) | `dokuma evi`, `medieval weaver workshop`, CC0/CC-BY veya Meshy | `A236` dokuma tezgâhı + MegaKit kulübe | `CIL-03` | Orta |
| `3D-RIG-BEKLEYEN` | 3D Rig / Klip | `B019` (Kangal) ve kararı onaylanırsa `K02`, `B092`, `K14`, `K15` yürüme/bekleme klipleri | Meshy iskelet+hareket (Ahmet kredi onayıyla) veya mevcut `styloo`/`HazirKarakter` | `styloo/kopek.glb` (Kangal yerine) | `CIL-09`, `CIL-11` | Düşük |
| `SES-ORTAM-MEVSIM` | Ses (Ortam) | Kış fırtına/rüzgâr, yaz cırcır/kuş, ateş çıtırtısı, kalabalık köy gündüzü (48kHz OGG) | `OpenGameArt CC0`, `Sonniss GDC` (ticari serbest doğrulamalı) | Mevcut `ortam_koy_gunduz.wav` (`16 kHz`) | `CIL-21` | Yüksek |
| `SES-UI-ANA` | Ses (UI/Zanaat) | Parşömen çevirme, tahta sürgü, mum/balmumu mühür, örs/testere/körük varyasyonları | `Kenney UI Audio` / `Kenney RPG Audio` (CC0), `OpenGameArt CC0` | Mevcut `sfx_secim.wav` / `rubberduck/` | `CIL-21` | Yüksek |

---

## 8. Riskler ve Yapılmayacaklar

### Yapılmayacaklar (Kırmızı Çizgiler — `AGENTS.md` ve `ROADMAP_4.md` `A1–F2`)
- **Berk/Usta alanına izinsiz dokunulmayacak:** `ROADMAP_3.md` (`SVS-*`), `ROADMAP_2.md` açık maddeleri (`ARY-01..04, 70`, `GRV-*`, `DYL-14`, `SEV-05`, `AYR-*`, `HAN-*`, `SOY-*`, `YIL-09`, `OGR-*`, `YAZ-01`) için Ajan Masası (`issue #11`) `[EMIR]` süreci olmadan kod değiştirilmez.
- **Asset üretimi yasak:** Hiçbir ajan yapay zekâyla veya scriptle görsel, doku, ses, müzik, 3B model sentezlemez. Yalnız doğrulanmış **CC0 / CC-BY** veya Ahmet'in ürettiği Nano Banana / Meshy varlıkları eklenir.
- **100 MB üstü model yasağı:** Ham (inceltilmemiş) Meshy modelleri sahneye konmaz; tüm modeller inceltilmiş (`decimated`, `<=60k` tris) hâliyle kullanılır.
- **`ROADMAP_4` Karar sınırları çiğnenmeyecek:** Karakter kadrosu 30 (`B1`) üstüne çıkarılmaz; Steamworks/cloud/başarım açılmaz (`E1`); 3. dil eklenmez (`F2`, yalnız `tr`+`en`); `.ico` ajan eliyle üretilmez (`E2`); test başarısızlığında sessiz geçilmez (`A2`, zorunlu `quit(1)`).
- **Tam `sanity_check.py` yerine hedefli test:** Her `CIL-*` yalnızca kendi hedefli headless testini koşar (`SCRIPT ERROR` = `quit(1)`).
- **Stok & dal koruması:** Yereldeki `muharrir-yedek-2026-11-16-0020-pull-oncesi` stash'ine, izlenmeyen `assets/meshy/gelen/` klasörüne, `reset --hard` / `force push` işlemlerine dokunulmaz.

### Başlıca Uygulama Riskleri ve Önlemleri
| Risk | Etkisi | Önlem |
|---|---|---|
| **İskeletli GLB'lerde (`Armature` `0.01`) animasyonun ölçeği sıfırlaması** | `k04`, `k05`, `k13` oynatılırken ilk karede tekrar mikro boya küçülebilir | Ölçek normalizasyonunu `Skeleton3D` çocuğuna değil kapsayıcı `Node3D` köküne veya pozisyon/ölçek izi içermeyen kök sarmalayıcıya uygula (`CIL-01`, `CIL-08`). |
| **Korumalı çekirdek dosya çakışmaları (`ana.gd`, `hud.gd`, `ses.gd`, `koy_yonetim_sahnesi.gd`, `koy_ekrani.gd`)** | Berk/Codex-Berk dallarıyla merge çatışması | Yeni davranışları `insaat_kademesi_gorseli.gd`, `animasyonlu_varlik.gd`, `bina_avlu_esyalari.gd` gibi yeni dosyalara yaz; korumalı dosyalarda yalnızca tek satır adaptör çağrısı kullan. |
| **`1280×720`'de yoğun HUD taşması** | Küçük pencerelerde düğmeler/kaynaklar üst üste biner | `CIL-15`–`CIL-18` her UI değişikliğinde `1280×720` viewport boyutuyla kontrol sahnesi çalıştırılır. |
| **Ses dosyası yeniden kodlama riski (`cici/*.wav` `fmt_tag=3`)** | Bazı platformlarda 32-bit float WAV sesi gürültülü/sessiz çalabilir | `CIL-20` kapsamında mevcut dosyalara ses sentezlemeden yalnız kazanç tablosu + Godot import/dönüşüm doğrulaması uygulanır. |

---

## Tur Günlüğü

- **Tur 1 (Envanter ve Oyun Akışı):** `AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, `OYNA.md`, `OYUN_RAPORU.md`, `ROADMAP_2.md`, `ROADMAP_4.md`, `docs/ROADMAP_4_ON_RAPOR.md`, `docs/OYUN_TESTI_KONTROL_LISTESI.md`, `design/omurga.md`, `design/art/meshy/meshy-secim.json` ve `assets/meshy_manifest.json` okundu. Ana Menü → Yeni Oyun → Kapı Sorgu → Köy Yönetimi → Gece/Rapor/Son akışı çıkarıldı; manifestteki `1144` satır (`54` `baglandi`: `51` topluluk + `3` yapı) ve `69` topluluk kodu doğrulandı.
- **Tur 2 (3B Asset ve İnşa Kök Neden Denetimi):** Godot 4.7.2 headless (`audit_models.gd`, `full_audit.gd`, `audit_meshy_glbs.gd`) ile `184` GLB/GLTF modelinin gerçek ham boyutları, pivot ofsetleri ve `AnimationPlayer` klipleri ölçüldü. `demirhane` ve `KAPALI` yapıların `HazirKoyYapilari.kur()` tarafından MegaKit kutu bina içine hapsedildiği, `"kisla"` != `"muhafiz_kislasi"` / `"avci"` != `"avci_cadiri"` uyumsuzlukları, `Armature` `0.01` AABB hatası (`k04` `26.92x`, `k05` `0.03 mm`, `k13` `0.17 mm`), `ahir` (`Z=0.061 m`), `muhafiz_kislasi` (`7.96 m` taşma) ve `styloo/kopek.glb` `"iddle"` klip yazım hatası saptandı. `tools/meshy/manifest.py -> yaz(nesne)` yazım kuralı doğrulandı.
- **Tur 3 (Profesyonel Oyun Arayüzü Araştırması):** *Papers, Please*, *Manor Lords*, *Frostpunk 1–2*, *Farthest Frontier*, *Banished*, *Against the Storm*, *Kingdom Come: Deliverance*, *Bannerlord*, *Crusader Kings III*, *Pentiment*, *This War of Mine* ve *Medieval Dynasty* arayüz kalıpları ile `XAG 101/102` erişilebilirlik kuralları tarandı. `assets/ui/atmosfer/gece_kapisi/` içindeki `44` hazır PNG ve `13` eksik ikon doğrulandı; `ARY-01` Parşömen vs *Gece Kapısı* çelişkisi işaretlendi; ana ekran taslakları çizildi.
- **Tur 4 (Ses Envanteri ve Bus Mimarisi):** `assets/ses/` içindeki `73` `.import`-dışı dosya (`72` ses: 54 `.wav`, 18 `.ogg` + `1` `kenney_rpg/LICENSE.txt`) Python ile tarandı. RMS aralığının `-37.5 dBFS` (`sfx_bar_catlak`) ile `-15.5 dBFS` (`rpg_sound/coin`) arasında `22 dB` saptığı, `cici/*.wav`'ın `32-bit float (fmt_tag=3)`, `dere_01.wav`'ın `96 kHz` olduğu ve `koy_ortam_sesi.gd`'nin `ROADMAP_4` D2 (`Ortam` bus) yerine `Ambiance` ürettiği tespit edildi.
- **Tur 5 (Uygulama Planı ve Prompt Yazımı):** Fazlar `F0–F6` (`CIL-01`..`CIL-22`), sahiplik/koordinasyon sınırları, Nano Banana `#00FF00` yeni 2D parça promptları, `EKSIK_ASSET_ENVANTERI.md` eklenti satırları ve risk matrisi `docs/CILALAMA_PLANI.md` olarak yazıldı.
- **Tur 6 (Kendi Kendine Denetim):** Plan üzerindeki tüm yol ve veriler Python betiğiyle doğrulandı: `69/69` `meshy-secim.json` kodu, `31/31` `yapi` satırı, `22/22` `CIL-*` iş birimi (her biri sahip/bağımlılık/kabul/hedefli `quit(1)` testli) ve tüm mevcut repo dosya yolları (`0` kırık yol; yalnızca planlanan `10` yeni dosya haricinde tamamı diskte doğrulandı) onaylandı. Plan uygulama ajanları için hazırdır.
