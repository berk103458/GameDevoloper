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
