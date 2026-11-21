# Kapı Muhafızı — Codex denetim raporu

22 Kasım 2026, Kalfa. Dal `claude/festive-volta-li1sfm`.

## Bölüm 0 — Bağlantı testi

Festive yayını `4155bd5a`.

- Festive, `6d05960d` → `d0e3f89f` fast-forward ile güncellendi. Bu commitin arşivi `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/proje/` altında açıldı. Godot AI klasörü ve yerel etkinleştirme ayarları yalnız bu kopyaya aktarıldı. Pencereli deneme ayrı bir `user://` kayıt dizini kullandı.
- Godot `4.7.2.stable.official.ed1daf0bf` ile sıfır önbellekten tek headless import tamamlandı. Çıkış kodu `0`. `ERROR`, `SCRIPT ERROR` ve `Failed to load script` satırları yok. Parley karakter, olgu ve eylem depoları geçici bellekte açıldı. Bir betik yeniden yükleme uyarısı ile HDR başlıklarındaki `GAMMA` ve `PRIMARIES` alanları için iki uyarı kaydedildi. Log `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/00-import.log`.
- Godot AI `4.4.2` ilk sorguda bağlı editör bulamadı. İzole proje editörde açılınca sunucu editörü tanıdı ve kimlik doğrulandı. İlk `project_run` dosya taraması sürerken `EDITOR_IMPORTING` döndü. Tarama bitince oyun başlatıldı ve oyun yardımcısı `live` durumuna geçti.
- `editor_screenshot(source="game")` ilk olarak 900×506 yükleme karesini döndürdü. MCP o kareyi `stale_frame=true` ile işaretledi. Editör odağa alınınca 800×450 yeni karede `stale_frame=false` görüldü. İlk kare `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/00-ilk-kare.png`.
- `logs_read` oyun ve editör kaynaklarıyla çalıştı. Oyun logunun ilk okumasında on uyarı vardı. `soylenti_degirmen_kapanis`, `soylenti_kuyu_kapanis`, `soylenti_mogol_casus_kapanis`, `soylenti_tekfur_araba_kapanis` ve `soylenti_vebali_kumas_kapanis` olaylarının her birinde `sonuc1` ve `sonuc2` metin anahtarları boş veya eksik. Editör `tests/oto/oyun_koprusu_kontrol.gd:71` satırındaki `beklenen_soru` türünü çıkaramadı ve test betiğini yükleyemedi. Oyun ana sahnesi buna rağmen açıldı. Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/00-mcp-oyun.json` ve `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/00-mcp-editor.json`.

`C:/Users/ds/Documents/GitHub/GameDevoloper` ve `ds` çalışma kopyası bu makinede bulunamadı. GitHub CLI oturumu yok, anonim issue #11 sorgusu HTTP 404 döndürdü.

## Bölüm 1 — Köy eklentileri

Festive yayını `5eaa84f7`.

`fdcfa645` üzerindeki çalışma sonuçları [Eklenti bağları](EKLENTI_BAGLANTI.md) belgesinde. Altı Terrain3D dokusu mipmap aldı. Headless eklenti testindeki GPU karesi okuması artık yalnız pencereli çalışmada, çıktı yolu verilirse yapılıyor. Bölüm 1 importu `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-import.log`.

| Kanıt | Dosya |
|---|---|
| Şafak | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-safak.png` |
| Gündüz | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-gunduz.png` |
| Akşam | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-aksam.png` |
| Gece | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-gece.png` |
| Eklenti testi | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-eklenti-testi.log` |
| Görsel sahne ve fazlar | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-gorsel.log` |
| Mipmap ve performans | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-performans.log` |

## Bölüm 3 — Çerçeve ve arka plan

Altı çerçeve eski çerçeve ya da süssüz durumla açıldı. On arka plan için ortak yükleyici etiketli kutuya, yükleme ekranı ise `loading_bg.png` dosyasına döndü. İzole kopyaya geçici renkli PNG'ler konup tek import yapıldığında altı çerçeve dokuya bağlandı ve on arka plan ortak yükleyiciden `TextureRect` olarak açıldı. Çerçeve sınamaları diyalog şeridi, seçenek satırı, portre, genel panel, mühür ve dört rumi köşenin bağlantılarını kapsadı.

Oyun içinde üç yükleme adayı, ayarlar ve heybe gerçekten çağrılıyor. `kapi_gece.png`, `koy_gunduz.png`, `koy_gece.png`, `gun_sonu.png` ve `kayit.png` için oyun ekranında çağrı bulunmadı. Bu beş yol dosya konunca kendiliğinden ilgili ekranda görünmez. Kapı ve köydeki 3B görünümün üzerine hangi bölgede yer alacağı da oyun içi bağ aşamasında netleştirilmeli.

Başarılı koşular `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/03-dosyasiz.log`, `03-png-ile.log` ve aynı dizindeki `03-import.log`. İlk dosyasız deneme betiği `SceneTree` açılışında heybe sınıfını Ses autoload'undan önce çözmeye çalıştı. Denetim betiği heybe betiğini çalışma anında yükleyince dosyasız ve PNG'li koşular sıfır hatayla tamamlandı. Geçici 16 PNG ve bunların `.import` yan dosyaları izole kopyadan kaldırıldı.
