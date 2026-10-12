# Gece kapısı — alfa hazırlaması ve son kabul (Kalfa)

12 Ekim 2026. **27 kullanılabilir PNG çıktı, 5 yeniden üretim, 25 henüz teslim edilmemiş UI parçası.** Ayrıca 281 yeni envanter promptu hazır. 27, kaynak fotoğraf sayısı değildir: ana şekilden türetilen durumlar dahildir. Yalnız mevcut kaynak işleme yapıldı; modelden resim üretilmedi veya ağırlık indirilmedi.

## Kaynaklar ve işlem

İlk 29 RGB JPEG `_inceleme/` içinde durur; son 29 kaynak `_inceleme/paket_20261012/` içine SHA-256 eşitliği kontrol edilerek taşındı. Aynı içerikli `loading_bg.jpg` ve `loading_bg2.jpg` ayrı adlarla korundu. Eski üç aday PNG `_inceleme/onceki_yayin/` içinde korunur. İşaretli checkbox çizgisinin işlenmiş ara kopyası `_inceleme/checkbox_tick_donor.png` içindedir. Ham klasör .gdignore ile import dışındadır.

Son pakette 1 ana menü, 3 hatalı harita, 4 yükleme arka planı, 5 diyalog paneli, 6 ana buton ve 10 köylü kartıdır. Yeni 2 (sorgu) ve 11 (portre) gelmedi; portre eski kaynaktan pencere maskesiyle kurtarıldı. Rastgele isimli -2 kaydırma kanalı, -5 sürgü tutacağı, -6 kaydırma tutacağı ve -7 işaretli checkbox olarak ayrıldı. -1 belirsiz yatay kanal ve -3/-4 geniş panel varyantları tekrar import edilmez; kabul edilen temel parçalar bunların yerini karşılar.

Magenta kaynaklar chroma key ile; gri/dama kaynaklar Pillow + OpenCV GrabCut ile ve elle denetlenen ROI/poligon maskeleriyle temizlendi. Gri demiri korumak için bütün gri pikseller toptan silinmedi. Nesne kırpıldı, hedef PNG boyutuna getirildi ve **en az 16px saydam dış pay** bırakıldı. Dikdörtgen panellerin merkezi opak, portre penceresi ve odak çerçevesi merkezi saydamdır. Beyaz yükleme dolgusu kaynağın iç dokusundan çıkarılıp amber renge dönüştürüldü; dış metal/palet alınmadı.

Dört butonun alfa/şekli ana butonla birebir aynıdır; üstünde 1.17, basılı 0.78, devre dışı 0.60 parlaklık ve düşük doygunluk. Checkbox işareti eski kaynaktan alınarak kapalı durumun aynı çerçevesine yerleştirildi. Sekme seçili durumu temel sekmeden, odak çizgisi buton konturundan türetildi.

## Kabul edilen çıktılar

| Dosya | Ölçü | Alfa | 9-slice sol/üst/sağ/alt | Kaynak |
|---|---|---|---|---|
| `main_menu_bg.png` | 1920×1080 | opak RGB | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/1.jpg` |
| `loading_bg.png` | 1920×1080 | opak RGB | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/4.jpg` |
| `dialogue_panel.png` | 1536×768 | gerçek RGBA, 16px pay | 112/112/112/112 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/5.jpg` |
| `button_normal.png` | 768×192 | gerçek RGBA, 16px pay | 64/64/64/64 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/6.jpg` |
| `villager_card.png` | 768×1024 | gerçek RGBA, 16px pay | 144/144/144/144 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/10.jpg` |
| `portrait_frame.png` | 512×640 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/portrait_frame.jpg` |
| `settings_panel.png` | 1536×1536 | gerçek RGBA, 16px pay | 192/192/192/192 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/settings_panel.jpg` |
| `tooltip_panel.png` | 768×384 | gerçek RGBA, 16px pay | 72/72/72/72 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/tooltip_panel.jpg` |
| `hud_strip.png` | 2048×192 | gerçek RGBA, 16px pay | 80/64/80/64 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/hud_strip.jpg` |
| `scrollbar_track.png` | 48×768 | gerçek RGBA, 16px pay | 20/24/20/24 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/Refer to this file by its name verbatim-2.jpg` |
| `slider_thumb.png` | 96×128 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/Refer to this file by its name verbatim-5.jpg` |
| `scrollbar_thumb.png` | 48×192 | gerçek RGBA, 16px pay | 20/32/20/32 | `assets/ui/atmosfer/gece_kapisi/_inceleme/paket_20261012/Refer to this file by its name verbatim-6.jpg` |
| `checkbox_off.png` | 96×96 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/checkbox_off.jpg` |
| `tab_normal.png` | 384×160 | gerçek RGBA, 16px pay | 64/48/64/48 | `assets/ui/atmosfer/gece_kapisi/_inceleme/tab_normal.jpg` |
| `ornament_corner.png` | 256×256 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/ornament_corner.jpg` |
| `cursor_arrow.png` | 128×128 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/cursor_arrow.jpg` |
| `slider_track.png` | 768×64 | gerçek RGBA, 16px pay | 32/24/32/24 | `assets/ui/atmosfer/gece_kapisi/_inceleme/slider_track.jpg` |
| `cursor_point.png` | 128×128 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/cursor_point.jpg` |
| `ornament_divider.png` | 1024×96 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/_inceleme/ornament_divider.jpg` |
| `button_hover.png` | 768×192 | gerçek RGBA, 16px pay | 64/64/64/64 | `assets/ui/atmosfer/gece_kapisi/button_normal.png` |
| `button_pressed.png` | 768×192 | gerçek RGBA, 16px pay | 64/64/64/64 | `assets/ui/atmosfer/gece_kapisi/button_normal.png` |
| `button_disabled.png` | 768×192 | gerçek RGBA, 16px pay | 64/64/64/64 | `assets/ui/atmosfer/gece_kapisi/button_normal.png` |
| `tab_selected.png` | 384×160 | gerçek RGBA, 16px pay | 64/48/64/48 | `assets/ui/atmosfer/gece_kapisi/tab_normal.png` |
| `focus_ring.png` | 768×192 | gerçek RGBA, 16px pay | 64/64/64/64 | `assets/ui/atmosfer/gece_kapisi/button_normal.png` |
| `checkbox_on.png` | 96×96 | gerçek RGBA, 16px pay | 0/0/0/0 | `assets/ui/atmosfer/gece_kapisi/checkbox_off.png` |
| `loading_track.png` | 1024×96 | gerçek RGBA, 16px pay | 32/32/32/32 | `assets/ui/atmosfer/gece_kapisi/slider_track.png` |
| `loading_fill.png` | 1024×96 | gerçek RGBA, 16px pay | 32/32/32/32 | `assets/ui/atmosfer/gece_kapisi/_inceleme/loading_fill.jpg` |

## Şimdi yeniden üret

- `interrogation_bg.png`: Mevcut çevre kadrajı düz boşluk ve uygun olmayan lamba içeriyor; yeni 2 numara teslim edilmedi. Düzeltilmiş tekli prompt GEMINI_SIRADAKI_URETIM_LISTESI.md ilk beş satırındadır.
- `map_bg.png`: Yeni 3 numarada perspektifli kağıt, fazladan anahtar ve camlı lamba var; düz harita değil. Düzeltilmiş tekli prompt GEMINI_SIRADAKI_URETIM_LISTESI.md ilk beş satırındadır.
- `ornament_emblem.png`: Amblem yerine sihirli lamba / dekoratif kabartma; oyun simgesi briefine uymuyor. Düzeltilmiş tekli prompt GEMINI_SIRADAKI_URETIM_LISTESI.md ilk beş satırındadır.
- `ornament_seal.png`: Mum mühür yerine metal madalyon ve gömülü dama; özgün nesne yanlış. Düzeltilmiş tekli prompt GEMINI_SIRADAKI_URETIM_LISTESI.md ilk beş satırındadır.
- `cursor_grab.png`: Koyu dama parmak kenarlarına yapışmış; deri/gri konturu kayıpsız ayrılamıyor. Düzeltilmiş tekli prompt GEMINI_SIRADAKI_URETIM_LISTESI.md ilk beş satırındadır.

## Doğrulama ve yeniden hazırlama

Godot 4.7.2 ed1daf0bf ile boş TEMP projesinde 27 texture yükleme/boyut/alfa kontrolü, bütün 9-slice sınırları ve üç temel panelin iki farklı ölçüde gerçek renderı geçti: `GECE_KAPISI_IMPORT_9SLICE_PASS 27`. Ekran kanıtı `docs/denetim/2026-10-12-ui-alfa/godot_9slice.png`. Köşeler sabit kaldı; kontrol paneli gerçek oyun yerleşimi değildir. Paneli sabit köşe paylarının toplamından küçük çizme. İnce kaydırma kanalı 48px hedefte 16px dış pay nedeniyle 16px içerik alanına sahiptir. Boyutları ve kesin sınırları manifestten oku.

Kullanılan yerel bağımlılıklar: Pillow, NumPy, SciPy, OpenCV (cv2). rembg kurulu değildi, indirilmedi. Chroma yeşil/magenta demir koruması, 16px pay/köşe rengi ve küçük hedef ret kontrolleri üç Python testinde geçti; ARY-05/SRM-18 altı envanter kontrolü geçti. Tek tam UTF-8 sanity tamamlandı: 368 PASS / 0 başarısız kontrol / 20 gece; loglar work/sanity_ui_alfa_20261012.

```powershell
$env:PYTHONUTF8="1"
python -B tools/art/gece_kapisi_hazirla.py docs/arayuz/gece_kapisi_hazirlama_isleri.json assets/ui/atmosfer/gece_kapisi
```

Bu komut mevcut nihai adları yeniden hazırlar; manifest teslim kaydıdır, yeni kaynak geldiğinde config ve manifest güncellenmelidir. ROI maskeleri yalnız bu kaynaklar için elle denetlendi, başka bir resme körlemesine uygulanmaz. Yeni saydam kaynak için `method: green` kullanılır; 16px final payı modelden beklenmez. İmleçlerin 16px dış payına göre hotspot entegrasyonda ayarlanmalıdır. PNG eski SVG veya font tüketicisine uzantı değiştirilerek bağlanmaz. Bu teslim Godot importuna hazır asset paketidir; aktif temanın oyuna bağlanması ARY sahibinin ayrı entegrasyonudur.
