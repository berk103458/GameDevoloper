# Arayüz denetimi

20 Kasım 2026. Cursor. Ekranlar koddan ve depodaki gece kapısı PNG'lerinden okundu. Godot 4.7.2 headless birim testi `GECE KAPISI ÇERÇEVE: GEÇTİ (0 hata)` verdi. `/opt/cursor/artifacts/ui_*.png` dosyaları, aynı PNG'lerin 9-dilim yerleşim karşılaştırmasıdır: sol taraf eski düz kutu, sağ taraf gece kapısı çerçevesi. Bunlar oyun penceresinin fotoğrafı değildir. Headless sürücü sahne karesi basmaz.

Ahmet'in cümlesi: ana menü kalsın. Arka plan, yükleme, oyun içi boyut, çerçeve zayıf. Çini, Parşömen ve Ocak şablonları seçilmedi. Beş hazır aday (Lamoot, itsmars, Kenney RPG, Crisp Quest, Kenney macera) ana menünün üstüne biniyordu. Bu turda o bağ kapatıldı.

## Zayıf bulunanlar

| Ekran | Kod | Eksik |
|---|---|---|
| Yükleme | `src/arayuz/varlik_yukleme_paneli.gd` | Düz gece rengi, tek satır, ipucu yok, çubuk yok |
| Köy HUD paneli | `Kabuk.panel()` ve `Tema.koy_paneli()` | 1 px düz kenar |
| Kapı sorgu paneli | `src/arayuz/chr_diyalog_paneli.gd` | Düz kutu. 3B kişi duruyor, çerçeve yok |
| Diyalog balonu | Dialogue Manager örnek balonu | Siyah düz `StyleBoxFlat`. Eklenti dosyası değiştirilmedi |
| Ayarlar, duraklatma, kayıt | `ayarlar_ekrani.gd`, kayıt kartları | Tema düğmesi düz |
| Gün sonu | `gece_raporu_kisa.gd` | Aynı düz panel |
| Envanter / heybe | `heybe_paneli.gd` | Aday ızgara teması, dönem çerçevesi yok |
| Ana menü | `menu_ekrani.gd`, `yeni_oyun_ekrani.gd` | Ahmet bunu güzel buldu. Satır çizimi ve Alpha'nın sessiz dönüş düzeltmesi durur |

## Bu turda bağlanan

Ortak tema `src/arayuz/gece_kapisi_tema.tres`. Çalışırken `Tema.olustur` bunu kopyalar, Alegreya puntoyu `Ayarlar.boyut` ile çarpar (`metin_olcegi`). Pencere `canvas_items` ile 1920×1080 tabanından 1440p ve 4K'ya uzar. Menü düğmesi `MenuDugmesi` kutusuz kalır.

Çerçeve dosyaları zaten depodaydı: `assets/ui/atmosfer/gece_kapisi/`. 9-dilim payı `docs/arayuz/GECE_KAPISI_ALFA_KABUL.md` içindedir. Düğmede kabul payı 64+64 px, kısa düğmeyi eziyor. Düğme payı 28 px yapıldı. Panel payı 112 px durur.

Dialogue Manager balonu `src/arayuz/diyalog/balon.tscn`. `project.godot` anahtarı `dialogue_manager/runtime/balloon_path`. Eklenti klasörüne yazılmadı.

Arka plan dosyası düşünce kod değişmeden duran yerler: yükleme (`yukleme*.png`), ayarlar (`ayarlar.png`), heybe (`envanter.png`). Kapı ekranının arkası 3B sahnedir; `kapi_gece.png` 3B örtünün altında kalacağı için bağlanmadı. Köy, gün sonu ve kayıt yuvaları korumalı ya da Alpha menü dosyalarındadır; çerçeve temadan gelir, arka plan dosyası henüz o sahnelere eklenmez.

## Hazır paket kararı

`docs/arayuz/ARAYUZ_ARASTIRMA_RAPORU.md` (15 Kasım 2026): 13. yy / uç beyliği için CC0 veya CC-BY bir UI kiti bulunmadı. Kenney CC0'dır ve çizgi film kabuğuna kayar. Bu turda yeniden indirilmedi. Çini, Parşömen ve Ocak düz renk şablonları da bağlanmadı. Kullanılan çerçeve, depodaki gece kapısı 9-dilim setidir. Yeni bir zip depoya girmedi.
