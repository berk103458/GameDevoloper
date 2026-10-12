# UI asset üretim rehberi — atmosferik oyun ekranları (Kalfa)

**12 Ekim güncel kural:** Saydam kaynaklarda düz #00FF00 yeşil zemin; aktif kalan üretimler GEMINI_SIRADAKI_URETIM_LISTESI.md içindedir. Ham kaynaklar _inceleme altında, 27 temiz çıktı manifestte. Önceki inceleme gözlemleri tarihsel kayıttır.

> **12 Ekim araştırma güncellemesi:** Gece kapısı için yeniden üretimde [tekli yeni promptları](GEMINI_TEKLI_URETIM_PROMPTLARI.md) kullan. [Araştırma](NANO_BANANA_OYUN_ASSET_ARASTIRMASI.md) resim üretimi ile gerçek alfa/kesin ölçü/9-slice hazırlamasını ayırır. Bu belgedeki önceki promptlar tarihsel kayıt; modelden tek adımda teknik teslim istemek güvenilir bulunmadı.

12 Ekim 2026 · Muharrir'in yeni görsel yön görevi · Ahmet için Nano Banana Pro promptları.

## Karar ve kapsam

Çini / Parşömen / Ocak önizlemeleri Ahmet tarafından reddedildi: yeni hedef, mekân hissi veren resimli oyun ekranlarıdır. Bu belge ARY-01 sahipliğini veya şablon seçimini değiştirmez; Claude'un `[/]` maddesine, `SABLONLAR.md` dosyasına ve oyun temasına dokunulmadı. İki yeni yön öneridir; birinin seçildiği varsayılmaz. 2D menü asset üretimine yeni kullanıcı izni geçerlidir; görselleri Ahmet Nano Banana Pro ile üretecek. Bu teslimde görsel, 3D model, ses veya oyun kodu üretilmedi.

## Altı oyundan kısa tasarım dersleri

Aşağıdaki uygulama önerileri kaynak ekranların tasarım yorumudur; geliştiricilerin Kapı Muhafızı için verdiği talimat değildir. Kaynaklar 12 Ekim 2026'da kontrol edildi. Referans resimler yalnız inceleme içindir; oyuna kopyalanmayacak.

| Oyun ve bakılacak ekran | Kısa ders | Kapı Muhafızı'na uygulama |
|---|---|---|
| [Papers, Please — resmî kabin ekranı](https://papersplea.se/img/Shot02-Booth.png), [resmî ekran galerisi](https://papersplea.se/) | Yüz, dışarıdaki sıra ve çalışma masası farklı alanlarda okunur; araçlar yapılan işin parçasıdır. | Sorguda yüzü, beyan defterini ve kararları sabit bölgelerde tut; süs bunların önüne geçmesin. Piksel estetiğini ve modern sınır bürokrasisini taşımıyoruz. |
| [Pentiment — resmî oyun ve erişilebilirlik ekranları](https://pentiment.obsidian.net/), [diyalog/manuskript galerisi](https://www.playstation.com/en-us/games/pentiment/) | İllüstrasyon, yazı ve konuşma aynı anlatı dünyasına aittir; tarihî yazı görünümü okunabilir yazı seçeneğiyle desteklenir. | Minyatürü tüm sahneye yay; tezhibi kenarda tut. Metni görsele yazdırma, mevcut okunabilir Türkçe fontla oyunda bas. Avrupa 16. yy üslubunu Anadolu'ya aynen aktarma. |
| [Darkest Dungeon — resmî medya](https://www.darkestdungeon.com/darkest-dungeon/media/), [oyun ve sanat tanımı](https://store.steampowered.com/app/262060/Darkest_Dungeon/) | Kalın çizgi, güçlü siluet ve karanlık kütleler küçük portre/ikonlarda da kimlik taşır. | Büyük karanlık alan içinde az sıcak vurgu; siluetle ayrılan ikonlar. Gotik kafatası ve her panelde kırmızı bordür kullanma. |
| [Inscryption — resmî oyun](https://www.inscryption.com/), [oyun ekranları](https://store.steampowered.com/app/1092790/Inscryption/) | Masa, oda ve ışık, arayüze dokunulabilir bir nesne hissi verir. | Ahşap, demir ve kandili tek mekânda birleştir; kararı bir eşikte verilmiş hissettir. Kart savaşı düzeni veya korku sembollerini kopyalama. |
| [Disco Elysium — resmî medya](https://discoelysium.com/media), [diyalog arayüzü geliştirme notu](https://discoelysium.com/devblog/2016/12/20/feld-playback-experiment) | Resim atmosferi kurarken uzun diyalog için ayrı bir okuma sütunu gerekir; arayüzün malzemesi dünya kimliğine bağlanabilir. | Sorgu resmiyle okunaklı metin yüzeyini ayır. Portre güçlü, cevap alanı sakin olsun; iç ses/psikoloji sistemi ekleme. Geliştirme notu 2016 prototipidir, nihai ekranın birebir teknik tarifi değildir. |
| [Pathologic 2 — resmî yayıncı oyun sayfası ve ekranları](https://store.steampowered.com/app/505230/Pathologic_2/) | Kasvetli çevre, diyalog ve harita birlikte baskı hissi kurar; atmosfer bilgiye engel olmamalıdır. | Yıpranma, sis ve boşlukla gerilim yarat; harita noktalarını/cevapları net tut. İncelenen sürüm Pathologic 2'dir; kıyamet, beden korkusu ve onun kasabasını taşımıyoruz. |

## İki yön

### A — Gece kapısı: kandil, ahşap, demir

**His:** nöbet, sorumluluk, yaklaşan bir insanın belirsizliği; az ışık altında sıcak ama huzursuz bir eşik. Önerilen ilk deneme budur; kapı mesleğiyle doğrudan bağ kurar. Kapının sağında kandil, ortada ziyaretçi için boşluk, solunda koyu menü alanı; ıslak taş ve ahşapta kontrollü ışık. Panel ahşap/demir kenarlıdır fakat ortası metin okumaya uygun sakin koyu yüzeydir. Her düğmede kocaman perçin veya alev çizilmez.

| Rol | Renk | Kullanım |
|---|---|---|
| Gece | `#10171C` | Büyük arka plan ve metin yüzeyi |
| İsli ahşap | `#30251F` | Panel ve kapı malzemesi |
| Soğuk demir | `#58616A` | Çerçeve, pasif işaret |
| Kandil | `#C88A43` | Odak ve seçili kenar |
| Açık kemik | `#E6DDC6` | Oyun tarafından basılan metin |
| Pas kırmızısı | `#A95648` | Tehlike/ret; simge ve yazıyla birlikte |
| Soluk adaçayı | `#829581` | Kabul/iyileşme; simge ve yazıyla birlikte |

### B — Minyatür / tezhip: sahne anlatan resimli levha

**His:** tarihî bir anlatının içine girme, insan hikâyeleri ve ihtiyatlı ihtişam. Tekdüze kâğıt dokusunun üstüne kutular yerleştirilmez: tam ekran kapı, yol, köy ve tepeler yassı perspektifli minyatür sahnesi olarak resmedilir. Tezhip küçük köşe/kenar vurgusudur; sorgu metninin çevresini boğmaz. Anadolu Selçuklu dönemi bir görsel yorumdur, arkeolojik birebirlik iddiası değildir; son dönem Osmanlı kubbe/manzara klişeleri kullanılmaz.

| Rol | Renk | Kullanım |
|---|---|---|
| Gece laciverdi | `#17233D` | Gölgeler ve koyu panel alternatifi |
| Eskitilmiş fildişi | `#E7D8B5` | Sakin metin yüzeyi |
| Mürekkep | `#29231E` | Oyun tarafından basılan metin |
| Mat altın | `#B89249` | Seyrek tezhip, odak |
| Kökboya | `#8E3F3B` | Tehlike/ret; simge ve yazıyla birlikte |
| Turkuaz | `#3C7774` | Seçim/kabul; simge ve yazıyla birlikte |
| Toprak | `#79634E` | Yol, malzeme ve ikincil çizgi |

## Üretim ve teslim ölçüsü

- Mevcut oyun tasarım alanı 1920×1080; arka plan teslimi 3840×2160 (16:9), oyunda aşağı örneklenir. Diğer ölçüler tablolardaki nihai kaynak pikselidir. Prompt modelin çıktısının bu ölçüye/alfaya kesin uyacağını garanti etmez: dışa aktarırken gerçek ölçü ve alfa kontrol edilir; gerekirse yeniden üretilir veya editörde kırpılır. Şeffaflık dama deseninin resme çizilmesi değildir.
- Her dosya ayrı PNG; saydam parçalar RGBA, arka planlar opak. Verilen `assets/ui/atmosfer/<yon>/` yolları **önerilen gelecek teslim yollarıdır**, bu commit'te oluşturulmuş asset yolu değildir. İki yön aynı boyutları ve yerleşim boşluklarını kullanır. İkisini aynı ekranda karıştırma.
- Her promptta aynı ortak stil cümlesi ve `no text` vardır. Oyun adları prompta yazılmadı. Logo, karakter adı, sayı, harita etiketi, açıklama, tuş ve uydurma hat/yazı üretilmez; tüm metinler mevcut yerelleştirme/font katmanından gelir.
- **9-slice sırası S/Ü/Sa/A = sol/üst/sağ/alt.** Değerler kaynak pikselidir. Sabit köşelerde küçük süs, esneyen şeritlerde yalnız düşük ayrıntılı doku, merkezde sakin dolgu; köşeyi geçen motif/diagonal çizgi yok. Portre çerçevesi, ikon, imleç ve resimli arka plan esnetilmez (`0/0/0/0`, uygulanmaz).
- Panel dışı alfa 0, okuma merkezinin doluluğu yüksek; 9-slice paneli içi boş fotoğraf çerçevesi gibi üretme. Portre çerçevesinde ise **orta pencere de alfa 0**. Alfa kenarlarında beyaz/siyah hale olmamalı.
- Düğmelerde 4 dosya aynı dış sınır, aynı köşe ve aynı 16 px saydam dış payı korur. Önce normal üret; kalan üç promptu normal resmi referans vererek düzenleme olarak çalıştır. Hover ince açık kenar, basılı iç gölge, pasif düşük doygunluk + silik çapraz çentik: durum yalnız renkle anlatılmaz. Klavye/gamepad odağı ayrı saydam `focus_ring.png` katmanıdır.
- Arka planlar yalnız ortam katmanıdır: sorgu ziyaretçisi, oyun dünyasının yaşayan 3D sahnesi, sıra ve harita düğümleri resme gömülmez. Sorgu resmi diyalog arka yüzü/boş çevre olarak kullanılabilir; mevcut 3D oyun yolunu değiştiren bir entegrasyon kararı değildir. Harita resmi örnek dekoratif arazi taşır; gerçek bölge/rota konumları mevcut harita verisiyle uyumlu olmalı, uydurma sabit yer adı veya ulaşılabilir nokta içermez.
- 1920×1080 hedefte gövde 26 px, küçük metin 22 px altına düşmez; uzun Türkçe seçenekler sarılır. Dekor 9-slice payında kalır, ayrıca metin iç payı vardır: diyalog 128/112/128/112, buton 112/40/112/40, kart 96/96/96/96, ayarlar 112/112/112/112 kaynak px. Bunlar Godot tema içerik payı önerisidir; 9-slice kesim çizgisi değildir.
- Resmi yüzde 100/50 ve gerçek 1600×900 pencerede kontrol et: sakin okuma alanı, metin kontrastı, net küçük ikon silueti, bozulmayan 9-slice ve aynı dört düğme boyutu. Gerekirse UI yüzeyi daha opak yapılır; atmosfer uğruna okunabilirlik düşürülmez.
- Önce yalnız bir yönde `main_menu_bg`, `interrogation_bg`, `dialogue_panel`, dört buton ve `portrait_frame` ile küçük bir deneme üret. Aynı ekran kompozisyonu beğenilirse kalan parçaları yap. Bu sıra Ahmet'in görsel üretim işini küçültür; burada yeni ROADMAP sahipliği alınmadı.

## Tam parça kataloğu ve kopyalanabilir promptlar

Her yönün tablosu aynı parça kümesini içerir. Tablodaki ID'nin hemen alt başlığında **tek başına yapıştırılabilir** tam İngilizce prompt bulunur; bir stil ön eki ayrıca eklemek gerekmez. Yalnız dört butonun düzenleme promptlarında normal resmi referans olarak yükle. Portre çerçevesi hazır portreyi çevreler; bu görev yeni köylü portresi/3D gövde istemez.

**Ortak stil cümlesi:**

> Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship.

### A — Gece kapısı — dosya listesi

Teslim kökü: `assets/ui/atmosfer/gece_kapisi/` (öneri).

| ID | Dosya | Parça | Boyut (px) | Saydamlık | 9-slice S/Ü/Sa/A (px) |
|---|---|---|---|---|---|
| gece_kapisi-01 | `main_menu_bg.png` | Ana menü arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| gece_kapisi-02 | `interrogation_bg.png` | Sorgu çevre arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| gece_kapisi-03 | `map_bg.png` | Harita arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| gece_kapisi-04 | `loading_bg.png` | Yükleme ekranı arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| gece_kapisi-05 | `dialogue_panel.png` | 9-slice diyalog paneli | 1536×768 | RGBA; dışı saydam | 96/80/96/80 |
| gece_kapisi-06 | `button_normal.png` | Buton — normal | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| gece_kapisi-07 | `button_hover.png` | Buton — üstünde | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| gece_kapisi-08 | `button_pressed.png` | Buton — basılı | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| gece_kapisi-09 | `button_disabled.png` | Buton — pasif | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| gece_kapisi-10 | `villager_card.png` | Köylü kartı zemini | 768×1024 | RGBA; dışı saydam | 64/64/64/64 |
| gece_kapisi-11 | `portrait_frame.png` | Portre çerçevesi | 512×640 | RGBA; dışı ve merkezi saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-12 | `settings_panel.png` | Ayarlar paneli | 1536×1536 | RGBA; dışı saydam | 80/80/80/80 |
| gece_kapisi-13 | `tooltip_panel.png` | İpucu / küçük bilgi paneli | 768×384 | RGBA; dışı saydam | 48/48/48/48 |
| gece_kapisi-14 | `hud_strip.png` | HUD kaynak şeridi | 2048×192 | RGBA; dışı saydam | 64/40/64/40 |
| gece_kapisi-15 | `focus_ring.png` | Klavye / gamepad odak halkası | 768×192 | RGBA; dışı ve merkezi saydam | 64/48/64/48 |
| gece_kapisi-16 | `tab_normal.png` | Sekme — normal | 384×160 | RGBA; dışı saydam | 40/32/40/32 |
| gece_kapisi-17 | `tab_selected.png` | Sekme — seçili | 384×160 | RGBA; dışı saydam | 40/32/40/32 |
| gece_kapisi-18 | `checkbox_off.png` | Onay kutusu — boş | 96×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-19 | `checkbox_on.png` | Onay kutusu — işaretli | 96×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-20 | `slider_track.png` | Ayar sürgüsü kanalı | 768×64 | RGBA; dışı saydam | 24/16/24/16 |
| gece_kapisi-21 | `slider_thumb.png` | Ayar sürgüsü tutamacı | 96×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-22 | `scrollbar_track.png` | Kaydırma kanalı | 48×768 | RGBA; dışı saydam | 12/24/12/24 |
| gece_kapisi-23 | `scrollbar_thumb.png` | Kaydırma tutamacı | 48×192 | RGBA; dışı saydam | 12/24/12/24 |
| gece_kapisi-24 | `loading_track.png` | Yükleme çubuğu kanalı | 1024×96 | RGBA; dışı saydam | 32/24/32/24 |
| gece_kapisi-25 | `loading_fill.png` | Yükleme çubuğu dolgusu | 1024×96 | RGBA; dışı saydam | 32/24/32/24 |
| gece_kapisi-26 | `ornament_corner.png` | Köşe süsü — sol üst | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-27 | `ornament_divider.png` | Metin bölücü süs | 1024×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-28 | `ornament_emblem.png` | Başlık yanı özgün amblem | 512×512 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-29 | `ornament_seal.png` | Yazısız mühür / belge süsü | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-30 | `cursor_arrow.png` | İmleç — normal | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-31 | `cursor_point.png` | İmleç — etkileşim | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-32 | `cursor_grab.png` | İmleç — sürükleme | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-33 | `cursor_busy.png` | İmleç — bekleme | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-34 | `icon_akce.png` | İkon — Akçe | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-35 | `icon_erzak.png` | İkon — Erzak | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-36 | `icon_odun.png` | İkon — Odun | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-37 | `icon_tas.png` | İkon — Taş | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-38 | `icon_demir.png` | İkon — Demir | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-39 | `icon_bez.png` | İkon — Bez | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-40 | `icon_alet.png` | İkon — Alet | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-41 | `icon_nufus.png` | İkon — Nüfus | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-42 | `icon_yatak.png` | İkon — Yatak | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-43 | `icon_saglik.png` | İkon — Sağlık | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-44 | `icon_moral.png` | İkon — Moral | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-45 | `icon_guvenlik.png` | İkon — Güvenlik | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-46 | `icon_adalet.png` | İkon — Adalet | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-47 | `icon_gun.png` | İkon — Gün / zaman | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-48 | `icon_kabul.png` | İkon — Kabul | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-49 | `icon_ret.png` | İkon — Ret | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-50 | `icon_uyari.png` | İkon — Uyarı | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-51 | `icon_kilit.png` | İkon — Kilit | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-52 | `icon_geri.png` | İkon — Geri | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-53 | `icon_kapat.png` | İkon — Kapat | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-54 | `icon_ayarlar.png` | İkon — Ayarlar | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-55 | `icon_kaydet.png` | İkon — Kaydet | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-56 | `icon_harita.png` | İkon — Harita | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| gece_kapisi-57 | `icon_diyalog.png` | İkon — Diyalog | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |

### A — Gece kapısı — hazır İngilizce promptlar

#### gece_kapisi-01 · `main_menu_bg.png` — Ana menü arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. A full-screen atmospheric gate at night in a 13th-century Anatolian frontier village, a wooden gate with iron fittings, a small oil lamp on the right, distant foothills and sparse mist. Keep the left 35 percent dark and low-detail for a vertical menu, and the upper left 25 percent quiet for a runtime title. No people, no interface controls. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-02 · `interrogation_bg.png` — Sorgu çevre arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. An empty guard-side view of an Anatolian gate threshold, worn timber ledge and stone jambs at the sides, one small oil lamp near the upper right. Keep the central 45 percent unoccupied for a live visitor, the rightmost 30 percent low-detail for a dialogue column, and the bottom 25 percent quiet for decisions. No baked-in visitor, documents, controls or queue. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-03 · `map_bg.png` — Harita arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. An unlabeled illustrated Anatolian frontier terrain map with subdued hills, a river and sparse tracks. Top-down readable composition, central 75 percent low-contrast for runtime map nodes, no fixed settlement markers or decorative compass letters; edge decoration only. Decorative terrain, not a claim of precise historical geography. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-04 · `loading_bg.png` — Yükleme ekranı arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. A quiet frontier road leading toward a distant gate at dusk, a solitary oil lamp beside the road, layered foothills, gentle haze. Keep the bottom 20 percent uniformly calm for a runtime progress bar and loading message. No people or interface controls. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-05 · `dialogue_panel.png` — 9-slice diyalog paneli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One front-facing dialogue panel with a nearly opaque low-detail reading surface and a restrained border; no portrait hole. Keep all ornamental detail within the fixed corners, horizontal and vertical edge bands straight and stretch-safe. Leave the center completely blank and calm. Create one image; final preparation target is 1536 by 768 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 96, top 80, right 96, bottom 80 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-06 · `button_normal.png` — Buton — normal

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One blank front-facing horizontal button in its normal state, restrained tactile border and flat low-detail center. Leave clear unclipped space around the object; final 16-pixel alpha padding is prepared after download. Stretch-safe straight edge bands and fixed small corner details. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-07 · `button_hover.png` — Buton — üstünde

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. Edit the supplied button_normal image into the hovered state: add a narrow light edge and a subtle inner highlight. Preserve exactly its canvas, silhouette, corners, texture scale, blank center and 16-pixel outer padding. No resizing, movement or extra ornament. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-08 · `button_pressed.png` — Buton — basılı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. Edit the supplied button_normal image into the pressed state: a recessed inner rim, compressed lighting and a small inward shadow. Preserve exactly its canvas, silhouette, corners, texture scale, blank center and 16-pixel outer padding. No resizing or movement. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-09 · `button_disabled.png` — Buton — pasif

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. Edit the supplied button_normal image into the disabled state: muted saturation, suppressed highlight and one faint diagonal notch confined to the border. Preserve exactly its canvas, silhouette, corners, blank center and 16-pixel outer padding. No resizing or movement. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-10 · `villager_card.png` — Köylü kartı zemini

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One tall front-facing villager information card panel, an uninterrupted blank reading surface for a runtime portrait and statistics, restrained corner details and stretch-safe edge bands. No baked-in portrait, chart, slot, symbol or number. Create one image; final preparation target is 768 by 1024 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 64, right 64, bottom 64 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-11 · `portrait_frame.png` — Portre çerçevesi

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One front-facing rectangular portrait border, 48 pixels wide, with a fully transparent central opening at x=48 y=48 width=416 height=544 and restrained corner detail. No portrait, background or symbol inside the opening. Fixed-size frame, not a stretchable panel. Create one image; final preparation target is 512 by 640 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. The central opening must also be genuinely transparent. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-12 · `settings_panel.png` — Ayarlar paneli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One square settings panel with an opaque calm blank central surface, restrained fixed corner details and straight stretch-safe edge bands. No baked-in toggles, sliders, tabs or title; those are separate runtime components. Create one image; final preparation target is 1536 by 1536 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 80, top 80, right 80, bottom 80 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-13 · `tooltip_panel.png` — İpucu / küçük bilgi paneli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One small front-facing blank tooltip panel with restrained edge detail, a nearly opaque low-detail center and straight stretch-safe bands. No arrow tail and no embedded symbol. Create one image; final preparation target is 768 by 384 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 48, top 48, right 48, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-14 · `hud_strip.png` — HUD kaynak şeridi

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One long horizontal blank HUD backing strip, subdued nearly opaque center, very quiet top and bottom edge bands, small fixed end caps. No compartments, icons or numeric counters. Create one image; final preparation target is 2048 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 40, right 64, bottom 40 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-15 · `focus_ring.png` — Klavye / gamepad odak halkası

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One thin rectangular focus outline matching the supplied normal button silhouette, bright restrained edge and four small corner notches. Center fully transparent. Preserve a 16-pixel transparent outer padding and stretch-safe edges; no button fill. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. The central opening must also be genuinely transparent. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-16 · `tab_normal.png` — Sekme — normal

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One blank normal-state horizontal tab with flat quiet center, subtle corner details and straight stretch-safe edges. No label or symbol. Create one image; final preparation target is 384 by 160 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 40, top 32, right 40, bottom 32 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-17 · `tab_selected.png` — Sekme — seçili

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One selected-state horizontal tab matching the normal tab geometry exactly, a clear narrow bottom accent line and brighter top edge, quiet blank center. No label or symbol. Create one image; final preparation target is 384 by 160 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 40, top 32, right 40, bottom 32 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-18 · `checkbox_off.png` — Onay kutusu — boş

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered empty square checkbox with a crisp tactile rim, 12-pixel external padding, and an opaque dark inset. Readable at 24 pixels, no lettering. Create one image; final preparation target is 96 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-19 · `checkbox_on.png` — Onay kutusu — işaretli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered checked square checkbox matching the empty checkbox outline exactly, a clear ivory check mark inside its opaque inset. Readable at 24 pixels; no lettering or additional symbol. Create one image; final preparation target is 96 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-20 · `slider_track.png` — Ayar sürgüsü kanalı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One straight horizontal slider track with fixed end caps, a quiet recessed inner channel and stretch-safe center. No thumb, tick marks or numbers. Create one image; final preparation target is 768 by 64 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 24, top 16, right 24, bottom 16 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-21 · `slider_thumb.png` — Ayar sürgüsü tutamacı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered upright slider thumb with a tactile rim and a single vertical inset grip, clean silhouette and 12-pixel outer padding. No track or text. Create one image; final preparation target is 96 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-22 · `scrollbar_track.png` — Kaydırma kanalı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One narrow vertical scrollbar track, quiet recessed center, fixed top and bottom end caps and stretch-safe central edges. No thumb, arrows or symbols. Create one image; final preparation target is 48 by 768 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 12, top 24, right 12, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-23 · `scrollbar_thumb.png` — Kaydırma tutamacı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One vertical scrollbar thumb with tactile rim and a subtle center grip; fixed end caps and stretch-safe straight central edges. No track or symbols. Create one image; final preparation target is 48 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 12, top 24, right 12, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-24 · `loading_track.png` — Yükleme çubuğu kanalı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One horizontal blank progress bar track, recessed nearly opaque inner surface and restrained fixed end caps. No fill, percentage or text. Create one image; final preparation target is 1024 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 32, top 24, right 32, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-25 · `loading_fill.png` — Yükleme çubuğu dolgusu

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One horizontal progress fill strip matching the supplied progress track inner area, quiet bright material and constant visual weight across its straight center. No channel rim, number or spark effects. Create one image; final preparation target is 1024 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 32, top 24, right 32, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-26 · `ornament_corner.png` — Köşe süsü — sol üst

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One restrained upper-left L-shaped Anatolian geometric and vegetal corner ornament, detail contained in 64-pixel-wide top and left bands. Other corners will be runtime mirrors; no central scene or calligraphy. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-27 · `ornament_divider.png` — Metin bölücü süs

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One thin horizontal divider with a small abstract geometric center knot and balanced quiet extensions, 12-pixel outer padding. No letters, heraldry or repeated dense filigree; fixed-size overlay. Create one image; final preparation target is 1024 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-28 · `ornament_emblem.png` — Başlık yanı özgün amblem

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One original small emblem combining a simple gate arch and oil-lamp silhouette, restrained symmetrical ornament and a clean empty surrounding alpha area. No historical coat of arms, modern flag, crescent-star insignia or lettering. Create one image; final preparation target is 512 by 512 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-29 · `ornament_seal.png` — Yazısız mühür / belge süsü

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One restrained blank seal-shaped ornament with an abstract geometric imprint, no actual seal inscription, monogram, heraldry or letters. Clean silhouette and small controlled shadow, not a button. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-30 · `cursor_arrow.png` — İmleç — normal

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One crisp northwest-pointing arrow cursor, tip at pixel 8,8, light interior and dark outline, immediately readable at 32 pixels. No large decoration, motion trail or drop-shadow blur. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-31 · `cursor_point.png` — İmleç — etkileşim

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One crisp pointing-hand cursor with the fingertip at pixel 40,8, light interior and dark outline, readable at 32 pixels. No sleeve ornament or motion trail. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-32 · `cursor_grab.png` — İmleç — sürükleme

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One crisp closed-hand grab cursor centered on pixel 64,64, light interior and dark outline, readable at 32 pixels. No held object or motion trail. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-33 · `cursor_busy.png` — İmleç — bekleme

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One crisp small hourglass cursor centered on pixel 64,64, light interior and dark outline, readable at 32 pixels. One static image only; no animation frames or lettering. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-34 · `icon_akce.png` — İkon — Akçe

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a single worn round silver coin with a blank face. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-35 · `icon_erzak.png` — İkon — Erzak

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a small grain sack with a few visible wheat grains. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-36 · `icon_odun.png` — İkon — Odun

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting two short stacked firewood logs. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-37 · `icon_tas.png` — İkon — Taş

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting three rough angular quarry stones. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-38 · `icon_demir.png` — İkon — Demir

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting one simple iron ingot. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-39 · `icon_bez.png` — İkon — Bez

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a folded coarse woven cloth. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-40 · `icon_alet.png` — İkon — Alet

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting one small hand hammer and simple chisel. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-41 · `icon_nufus.png` — İkon — Nüfus

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting two distinct human head-and-shoulder silhouettes. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-42 · `icon_yatak.png` — İkon — Yatak

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting one simple wooden bed with a blanket. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-43 · `icon_saglik.png` — İkon — Sağlık

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a mortar and pestle with one herb leaf. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-44 · `icon_moral.png` — İkon — Moral

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a small upright oil-lamp flame with protective hands. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-45 · `icon_guvenlik.png` — İkon — Güvenlik

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a plain round shield with no heraldry. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-46 · `icon_adalet.png` — İkon — Adalet

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a simple balanced two-pan scale. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-47 · `icon_gun.png` — İkon — Gün / zaman

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a plain sun disk with short rays. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-48 · `icon_kabul.png` — İkon — Kabul

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a bold clean check mark inside a simple border. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-49 · `icon_ret.png` — İkon — Ret

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a bold clean diagonal cross inside a simple border. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-50 · `icon_uyari.png` — İkon — Uyarı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a triangular warning outline with one solid central vertical stroke. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-51 · `icon_kilit.png` — İkon — Kilit

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a simple closed iron padlock. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-52 · `icon_geri.png` — İkon — Geri

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting one broad left-pointing arrow. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-53 · `icon_kapat.png` — İkon — Kapat

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting one clear X-shaped close mark without a surrounding frame. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-54 · `icon_ayarlar.png` — İkon — Ayarlar

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting three simple horizontal adjustment lines with clearly offset sliders. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-55 · `icon_kaydet.png` — İkon — Kaydet

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a tied folded document packet with a blank seal, not a floppy disk. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-56 · `icon_harita.png` — İkon — Harita

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting a folded blank map with one simple route stroke and no labels. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### gece_kapisi-57 · `icon_diyalog.png` — İkon — Diyalog

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use painterly ink-and-gouache shading, lamp-lit smoky timber and worn iron; charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6. For panels use dark nearly opaque reading surfaces; for small icons keep ivory highlights against dark edges. Atmospheric and grounded. One centered game UI icon depicting two overlapping blank speech silhouettes. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

### B — Minyatür / tezhip — dosya listesi

Teslim kökü: `assets/ui/atmosfer/minyatur_tezhip/` (öneri).

| ID | Dosya | Parça | Boyut (px) | Saydamlık | 9-slice S/Ü/Sa/A (px) |
|---|---|---|---|---|---|
| minyatur_tezhip-01 | `main_menu_bg.png` | Ana menü arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-02 | `interrogation_bg.png` | Sorgu çevre arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-03 | `map_bg.png` | Harita arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-04 | `loading_bg.png` | Yükleme ekranı arka planı | 3840×2160 | Opak RGB | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-05 | `dialogue_panel.png` | 9-slice diyalog paneli | 1536×768 | RGBA; dışı saydam | 96/80/96/80 |
| minyatur_tezhip-06 | `button_normal.png` | Buton — normal | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| minyatur_tezhip-07 | `button_hover.png` | Buton — üstünde | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| minyatur_tezhip-08 | `button_pressed.png` | Buton — basılı | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| minyatur_tezhip-09 | `button_disabled.png` | Buton — pasif | 768×192 | RGBA; dışı saydam | 64/48/64/48 |
| minyatur_tezhip-10 | `villager_card.png` | Köylü kartı zemini | 768×1024 | RGBA; dışı saydam | 64/64/64/64 |
| minyatur_tezhip-11 | `portrait_frame.png` | Portre çerçevesi | 512×640 | RGBA; dışı ve merkezi saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-12 | `settings_panel.png` | Ayarlar paneli | 1536×1536 | RGBA; dışı saydam | 80/80/80/80 |
| minyatur_tezhip-13 | `tooltip_panel.png` | İpucu / küçük bilgi paneli | 768×384 | RGBA; dışı saydam | 48/48/48/48 |
| minyatur_tezhip-14 | `hud_strip.png` | HUD kaynak şeridi | 2048×192 | RGBA; dışı saydam | 64/40/64/40 |
| minyatur_tezhip-15 | `focus_ring.png` | Klavye / gamepad odak halkası | 768×192 | RGBA; dışı ve merkezi saydam | 64/48/64/48 |
| minyatur_tezhip-16 | `tab_normal.png` | Sekme — normal | 384×160 | RGBA; dışı saydam | 40/32/40/32 |
| minyatur_tezhip-17 | `tab_selected.png` | Sekme — seçili | 384×160 | RGBA; dışı saydam | 40/32/40/32 |
| minyatur_tezhip-18 | `checkbox_off.png` | Onay kutusu — boş | 96×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-19 | `checkbox_on.png` | Onay kutusu — işaretli | 96×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-20 | `slider_track.png` | Ayar sürgüsü kanalı | 768×64 | RGBA; dışı saydam | 24/16/24/16 |
| minyatur_tezhip-21 | `slider_thumb.png` | Ayar sürgüsü tutamacı | 96×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-22 | `scrollbar_track.png` | Kaydırma kanalı | 48×768 | RGBA; dışı saydam | 12/24/12/24 |
| minyatur_tezhip-23 | `scrollbar_thumb.png` | Kaydırma tutamacı | 48×192 | RGBA; dışı saydam | 12/24/12/24 |
| minyatur_tezhip-24 | `loading_track.png` | Yükleme çubuğu kanalı | 1024×96 | RGBA; dışı saydam | 32/24/32/24 |
| minyatur_tezhip-25 | `loading_fill.png` | Yükleme çubuğu dolgusu | 1024×96 | RGBA; dışı saydam | 32/24/32/24 |
| minyatur_tezhip-26 | `ornament_corner.png` | Köşe süsü — sol üst | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-27 | `ornament_divider.png` | Metin bölücü süs | 1024×96 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-28 | `ornament_emblem.png` | Başlık yanı özgün amblem | 512×512 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-29 | `ornament_seal.png` | Yazısız mühür / belge süsü | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-30 | `cursor_arrow.png` | İmleç — normal | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-31 | `cursor_point.png` | İmleç — etkileşim | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-32 | `cursor_grab.png` | İmleç — sürükleme | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-33 | `cursor_busy.png` | İmleç — bekleme | 128×128 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-34 | `icon_akce.png` | İkon — Akçe | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-35 | `icon_erzak.png` | İkon — Erzak | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-36 | `icon_odun.png` | İkon — Odun | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-37 | `icon_tas.png` | İkon — Taş | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-38 | `icon_demir.png` | İkon — Demir | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-39 | `icon_bez.png` | İkon — Bez | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-40 | `icon_alet.png` | İkon — Alet | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-41 | `icon_nufus.png` | İkon — Nüfus | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-42 | `icon_yatak.png` | İkon — Yatak | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-43 | `icon_saglik.png` | İkon — Sağlık | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-44 | `icon_moral.png` | İkon — Moral | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-45 | `icon_guvenlik.png` | İkon — Güvenlik | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-46 | `icon_adalet.png` | İkon — Adalet | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-47 | `icon_gun.png` | İkon — Gün / zaman | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-48 | `icon_kabul.png` | İkon — Kabul | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-49 | `icon_ret.png` | İkon — Ret | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-50 | `icon_uyari.png` | İkon — Uyarı | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-51 | `icon_kilit.png` | İkon — Kilit | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-52 | `icon_geri.png` | İkon — Geri | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-53 | `icon_kapat.png` | İkon — Kapat | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-54 | `icon_ayarlar.png` | İkon — Ayarlar | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-55 | `icon_kaydet.png` | İkon — Kaydet | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-56 | `icon_harita.png` | İkon — Harita | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |
| minyatur_tezhip-57 | `icon_diyalog.png` | İkon — Diyalog | 256×256 | RGBA; dışı saydam | 0/0/0/0 — uygulanmaz |

### B — Minyatür / tezhip — hazır İngilizce promptlar

#### minyatur_tezhip-01 · `main_menu_bg.png` — Ana menü arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. A full-screen atmospheric gate at night in a 13th-century Anatolian frontier village, a wooden gate with iron fittings, a small oil lamp on the right, distant foothills and sparse mist. Keep the left 35 percent dark and low-detail for a vertical menu, and the upper left 25 percent quiet for a runtime title. No people, no interface controls. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-02 · `interrogation_bg.png` — Sorgu çevre arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. An empty guard-side view of an Anatolian gate threshold, worn timber ledge and stone jambs at the sides, one small oil lamp near the upper right. Keep the central 45 percent unoccupied for a live visitor, the rightmost 30 percent low-detail for a dialogue column, and the bottom 25 percent quiet for decisions. No baked-in visitor, documents, controls or queue. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-03 · `map_bg.png` — Harita arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. An unlabeled illustrated Anatolian frontier terrain map with subdued hills, a river and sparse tracks. Top-down readable composition, central 75 percent low-contrast for runtime map nodes, no fixed settlement markers or decorative compass letters; edge decoration only. Decorative terrain, not a claim of precise historical geography. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-04 · `loading_bg.png` — Yükleme ekranı arka planı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. A quiet frontier road leading toward a distant gate at dusk, a solitary oil lamp beside the road, layered foothills, gentle haze. Keep the bottom 20 percent uniformly calm for a runtime progress bar and loading message. No people or interface controls. Create one image; final preparation target is 3840 by 2160 pixels, opaque full-bleed RGB image with no alpha and no letterboxing. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-05 · `dialogue_panel.png` — 9-slice diyalog paneli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One front-facing dialogue panel with a nearly opaque low-detail reading surface and a restrained border; no portrait hole. Keep all ornamental detail within the fixed corners, horizontal and vertical edge bands straight and stretch-safe. Leave the center completely blank and calm. Create one image; final preparation target is 1536 by 768 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 96, top 80, right 96, bottom 80 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-06 · `button_normal.png` — Buton — normal

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One blank front-facing horizontal button in its normal state, restrained tactile border and flat low-detail center. Leave clear unclipped space around the object; final 16-pixel alpha padding is prepared after download. Stretch-safe straight edge bands and fixed small corner details. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-07 · `button_hover.png` — Buton — üstünde

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. Edit the supplied button_normal image into the hovered state: add a narrow light edge and a subtle inner highlight. Preserve exactly its canvas, silhouette, corners, texture scale, blank center and 16-pixel outer padding. No resizing, movement or extra ornament. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-08 · `button_pressed.png` — Buton — basılı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. Edit the supplied button_normal image into the pressed state: a recessed inner rim, compressed lighting and a small inward shadow. Preserve exactly its canvas, silhouette, corners, texture scale, blank center and 16-pixel outer padding. No resizing or movement. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-09 · `button_disabled.png` — Buton — pasif

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. Edit the supplied button_normal image into the disabled state: muted saturation, suppressed highlight and one faint diagonal notch confined to the border. Preserve exactly its canvas, silhouette, corners, blank center and 16-pixel outer padding. No resizing or movement. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-10 · `villager_card.png` — Köylü kartı zemini

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One tall front-facing villager information card panel, an uninterrupted blank reading surface for a runtime portrait and statistics, restrained corner details and stretch-safe edge bands. No baked-in portrait, chart, slot, symbol or number. Create one image; final preparation target is 768 by 1024 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 64, right 64, bottom 64 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-11 · `portrait_frame.png` — Portre çerçevesi

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One front-facing rectangular portrait border, 48 pixels wide, with a fully transparent central opening at x=48 y=48 width=416 height=544 and restrained corner detail. No portrait, background or symbol inside the opening. Fixed-size frame, not a stretchable panel. Create one image; final preparation target is 512 by 640 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. The central opening must also be genuinely transparent. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-12 · `settings_panel.png` — Ayarlar paneli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One square settings panel with an opaque calm blank central surface, restrained fixed corner details and straight stretch-safe edge bands. No baked-in toggles, sliders, tabs or title; those are separate runtime components. Create one image; final preparation target is 1536 by 1536 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 80, top 80, right 80, bottom 80 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-13 · `tooltip_panel.png` — İpucu / küçük bilgi paneli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One small front-facing blank tooltip panel with restrained edge detail, a nearly opaque low-detail center and straight stretch-safe bands. No arrow tail and no embedded symbol. Create one image; final preparation target is 768 by 384 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 48, top 48, right 48, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-14 · `hud_strip.png` — HUD kaynak şeridi

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One long horizontal blank HUD backing strip, subdued nearly opaque center, very quiet top and bottom edge bands, small fixed end caps. No compartments, icons or numeric counters. Create one image; final preparation target is 2048 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 64, top 40, right 64, bottom 40 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-15 · `focus_ring.png` — Klavye / gamepad odak halkası

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One thin rectangular focus outline matching the supplied normal button silhouette, bright restrained edge and four small corner notches. Center fully transparent. Preserve a 16-pixel transparent outer padding and stretch-safe edges; no button fill. Create one image; final preparation target is 768 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. The central opening must also be genuinely transparent. Design for 9-slice with fixed left 64, top 48, right 64, bottom 48 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-16 · `tab_normal.png` — Sekme — normal

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One blank normal-state horizontal tab with flat quiet center, subtle corner details and straight stretch-safe edges. No label or symbol. Create one image; final preparation target is 384 by 160 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 40, top 32, right 40, bottom 32 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-17 · `tab_selected.png` — Sekme — seçili

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One selected-state horizontal tab matching the normal tab geometry exactly, a clear narrow bottom accent line and brighter top edge, quiet blank center. No label or symbol. Create one image; final preparation target is 384 by 160 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 40, top 32, right 40, bottom 32 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-18 · `checkbox_off.png` — Onay kutusu — boş

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered empty square checkbox with a crisp tactile rim, 12-pixel external padding, and an opaque dark inset. Readable at 24 pixels, no lettering. Create one image; final preparation target is 96 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-19 · `checkbox_on.png` — Onay kutusu — işaretli

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered checked square checkbox matching the empty checkbox outline exactly, a clear ivory check mark inside its opaque inset. Readable at 24 pixels; no lettering or additional symbol. Create one image; final preparation target is 96 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-20 · `slider_track.png` — Ayar sürgüsü kanalı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One straight horizontal slider track with fixed end caps, a quiet recessed inner channel and stretch-safe center. No thumb, tick marks or numbers. Create one image; final preparation target is 768 by 64 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 24, top 16, right 24, bottom 16 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-21 · `slider_thumb.png` — Ayar sürgüsü tutamacı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered upright slider thumb with a tactile rim and a single vertical inset grip, clean silhouette and 12-pixel outer padding. No track or text. Create one image; final preparation target is 96 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-22 · `scrollbar_track.png` — Kaydırma kanalı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One narrow vertical scrollbar track, quiet recessed center, fixed top and bottom end caps and stretch-safe central edges. No thumb, arrows or symbols. Create one image; final preparation target is 48 by 768 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 12, top 24, right 12, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-23 · `scrollbar_thumb.png` — Kaydırma tutamacı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One vertical scrollbar thumb with tactile rim and a subtle center grip; fixed end caps and stretch-safe straight central edges. No track or symbols. Create one image; final preparation target is 48 by 192 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 12, top 24, right 12, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-24 · `loading_track.png` — Yükleme çubuğu kanalı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One horizontal blank progress bar track, recessed nearly opaque inner surface and restrained fixed end caps. No fill, percentage or text. Create one image; final preparation target is 1024 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 32, top 24, right 32, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-25 · `loading_fill.png` — Yükleme çubuğu dolgusu

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One horizontal progress fill strip matching the supplied progress track inner area, quiet bright material and constant visual weight across its straight center. No channel rim, number or spark effects. Create one image; final preparation target is 1024 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Design for 9-slice with fixed left 32, top 24, right 32, bottom 24 pixel bands; keep corners intact and stretchable bands free of crossing motifs. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-26 · `ornament_corner.png` — Köşe süsü — sol üst

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One restrained upper-left L-shaped Anatolian geometric and vegetal corner ornament, detail contained in 64-pixel-wide top and left bands. Other corners will be runtime mirrors; no central scene or calligraphy. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-27 · `ornament_divider.png` — Metin bölücü süs

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One thin horizontal divider with a small abstract geometric center knot and balanced quiet extensions, 12-pixel outer padding. No letters, heraldry or repeated dense filigree; fixed-size overlay. Create one image; final preparation target is 1024 by 96 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-28 · `ornament_emblem.png` — Başlık yanı özgün amblem

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One original small emblem combining a simple gate arch and oil-lamp silhouette, restrained symmetrical ornament and a clean empty surrounding alpha area. No historical coat of arms, modern flag, crescent-star insignia or lettering. Create one image; final preparation target is 512 by 512 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-29 · `ornament_seal.png` — Yazısız mühür / belge süsü

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One restrained blank seal-shaped ornament with an abstract geometric imprint, no actual seal inscription, monogram, heraldry or letters. Clean silhouette and small controlled shadow, not a button. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-30 · `cursor_arrow.png` — İmleç — normal

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One crisp northwest-pointing arrow cursor, tip at pixel 8,8, light interior and dark outline, immediately readable at 32 pixels. No large decoration, motion trail or drop-shadow blur. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-31 · `cursor_point.png` — İmleç — etkileşim

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One crisp pointing-hand cursor with the fingertip at pixel 40,8, light interior and dark outline, readable at 32 pixels. No sleeve ornament or motion trail. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-32 · `cursor_grab.png` — İmleç — sürükleme

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One crisp closed-hand grab cursor centered on pixel 64,64, light interior and dark outline, readable at 32 pixels. No held object or motion trail. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-33 · `cursor_busy.png` — İmleç — bekleme

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One crisp small hourglass cursor centered on pixel 64,64, light interior and dark outline, readable at 32 pixels. One static image only; no animation frames or lettering. Create one image; final preparation target is 128 by 128 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-34 · `icon_akce.png` — İkon — Akçe

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a single worn round silver coin with a blank face. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-35 · `icon_erzak.png` — İkon — Erzak

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a small grain sack with a few visible wheat grains. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-36 · `icon_odun.png` — İkon — Odun

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting two short stacked firewood logs. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-37 · `icon_tas.png` — İkon — Taş

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting three rough angular quarry stones. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-38 · `icon_demir.png` — İkon — Demir

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting one simple iron ingot. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-39 · `icon_bez.png` — İkon — Bez

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a folded coarse woven cloth. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-40 · `icon_alet.png` — İkon — Alet

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting one small hand hammer and simple chisel. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-41 · `icon_nufus.png` — İkon — Nüfus

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting two distinct human head-and-shoulder silhouettes. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-42 · `icon_yatak.png` — İkon — Yatak

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting one simple wooden bed with a blanket. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-43 · `icon_saglik.png` — İkon — Sağlık

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a mortar and pestle with one herb leaf. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-44 · `icon_moral.png` — İkon — Moral

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a small upright oil-lamp flame with protective hands. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-45 · `icon_guvenlik.png` — İkon — Güvenlik

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a plain round shield with no heraldry. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-46 · `icon_adalet.png` — İkon — Adalet

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a simple balanced two-pan scale. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-47 · `icon_gun.png` — İkon — Gün / zaman

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a plain sun disk with short rays. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-48 · `icon_kabul.png` — İkon — Kabul

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a bold clean check mark inside a simple border. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-49 · `icon_ret.png` — İkon — Ret

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a bold clean diagonal cross inside a simple border. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-50 · `icon_uyari.png` — İkon — Uyarı

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a triangular warning outline with one solid central vertical stroke. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-51 · `icon_kilit.png` — İkon — Kilit

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a simple closed iron padlock. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-52 · `icon_geri.png` — İkon — Geri

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting one broad left-pointing arrow. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-53 · `icon_kapat.png` — İkon — Kapat

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting one clear X-shaped close mark without a surrounding frame. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-54 · `icon_ayarlar.png` — İkon — Ayarlar

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting three simple horizontal adjustment lines with clearly offset sliders. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-55 · `icon_kaydet.png` — İkon — Kaydet

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a tied folded document packet with a blank seal, not a floppy disk. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-56 · `icon_harita.png` — İkon — Harita

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting a folded blank map with one simple route stroke and no labels. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

#### minyatur_tezhip-57 · `icon_diyalog.png` — İkon — Diyalog

```text
Original hand-painted 2D game UI art for a 13th-century Anatolian frontier gatekeeper, tactile materials, restrained ornament, readable silhouettes, quiet negative space, consistent craftsmanship. Use an original Anatolian manuscript-inspired miniature illustration, flattened perspective, fine controlled ink contours, matte pigment and sparse geometric illumination; navy #17233D, ivory #E7D8B5, ink #29231E, gold #B89249, madder #8E3F3B and turquoise #3C7774. For panels use calm ivory reading surfaces with dark borders; small icons keep dark contours. Narrative and restrained, not a generic parchment website. One centered game UI icon depicting two overlapping blank speech silhouettes. Use a strong readable silhouette and a consistent 24-pixel outer clear margin. Readable at 32 pixels. No extra objects, background scene, tiny engraved marks or labels. Create one image; final preparation target is 256 by 256 pixels, RGB source on uniform solid #00FF00 green outside the object for later masking; no green reflections or checkerboard. Fixed-size artwork; no 9-slice stretching. no text, no letters, no numerals, no pseudo-calligraphy, no logo, no watermark, no contact sheet, no website layout, no 3D model or render.
```

## Üretim sonrası kabul ve entegrasyon notu

1. Dört arka planın menü/metin boşlukları gerçekten sakin mi? Sorgu yüzü ve harita düğümleri sonradan yerleşebiliyor mu? Görsele gömülü yazı, kontrol veya portre varsa tekrar üret.
2. Dört buton birebir aynı boyut/siluette mi? Normal/hover/basılı/pasif durum, odak ve uzun Türkçe etiket birbirinden okunuyor mu? Model aynı geometrinin devamını vermezse normal resmi editörde esas al; uyumsuz dört görseli oyuna alma.
3. Her 9-slice paneli yarım, normal ve iki kat genişlikte dene; motifler yalnız sabit köşelerde kalsın. Kaynak paylarını çözünürlük ölçeğiyle birlikte uygula; sıfırdan dekoratif kenar tahmin etme.
4. Alfa gerçekten mevcut mu; portre penceresi delik mi; kenarlarda hale var mı? Portre yerleşimi önerisi `portrait_frame.png` açıklığının içine yapılır. İmleç hotspotları: ok (8,8), işaret (40,8), sürükleme/bekleme (64,64) kaynak pikseli; 32×32 kullanılırsa aynı oranla küçült.
5. Kaynak PNG ve üretim promptunu sakla. Gerçek dosyalar geldiğinde Ahmet tarafından üretildiği, üretim tarihi/araç ve varsa referans kaynağı `docs/EKSIK_ASSET_ENVANTERI.md` ilgili kayıtlarına eklenir; bu belgedeki önerilen dosyalar henüz mevcut asset olarak işaretlenmez. Eski asset üretme yasağının 2D menü istisnası bu görevin açık kullanıcı talimatıdır; 3D yasağı devam eder.
6. Entegrasyon ayrı iştir: mevcut tema/Sanat yükleme yolu ve yerelleştirme korunur; seçilen yön kaynaklarından ince adaptörle bağlanır. ARY-01/ARY-02 sahipliği ve insan seçimi bu belgeyle tamamlanmış sayılmaz. Bu görevde ROADMAP işaretleri, oyun ekranları ve asset envanterinin mevcut sahiplikleri değiştirilmedi.

## Teslim doğrulaması

Belge bütün gerekli kategorileri, iki paleti ve her dosya için tam promptu içerir. PNG ölçüleri, saydamlık ve kesim payları belge içinde kontrol edilmiştir; gerçek görseller henüz üretilmediğinden görsel QA yapılmış iddiası yoktur. Yalnız Markdown/günlük/rapor değişti; oyun kodu, sahne veya asset değişmediğinden oyun sanity yeniden çalıştırılmadı. Gerekli ds çalışma kopyası/ayna yolları bu bilgisayarda yok; eşitlenemedi. Başka ajanın `[/]` işi korunmuştur.
