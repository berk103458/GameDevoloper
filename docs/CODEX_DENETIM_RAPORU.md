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
| Son eklenti testi derleme kontrolü | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-eklenti-parse.log` |
| Görsel sahne ve fazlar | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-gorsel.log` |
| Mipmap ve performans | `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/01-koy-performans.log` |

## Bölüm 2 — 3–5. gün döngüsü ve kayıt

Festive yayını `cf0efca3`.

Tohum 11 ile gerçek kapı ve köy düğmelerinden ilerlenip 3, 4 ve 5. gece raporları tamamlandı. İlk koşu 5. gün kapı kararlarında süre sınırına ulaştı. Beşinci gün, 4. gece sonu dosyasını ana menüden yükleyen ayrı bir süreçte tamamlandı. 3. günde 13 sorgu, bir kabul, iki ret ve bir köy eylemi kaydedildi. 4. günde harç, rüşvet, kabul ve dört köy eylemi, 5. günde kışlaya alma, iki kabul ve iki köy eylemi kaydedildi. İş gücü debuff'ı ve sıradaki köylüye bağ ayrıca Bölüm 1 eklenti testinde doğrulandı.

| Gece | Oyun raporundan örnek |
|---|---|
| 3 | Thessra köye kaldı, ambar 30 → 34, tahsildar olayı açıldı. |
| 4 | +17 gıda üretimi, 7 gıda tüketimi ve 1 gıda bozulması. İmzasız pusula açıldı. |
| 5 | +21 gıda üretimi, 10 gıda tüketimi, 1 gıda bozulması ve akçe 13 → 12. |

Köyde F5 mevcut etkin yuvanın yazım yoluna bağlandı. Rapor ve olay kartı açıkken F5 bu geçişi kaydetmiyor. 2. yuvada yedek yazıldı ve 1. yuvanın SHA-256 özeti korundu. Köy kaydı yeni Godot sürecinde `koy` fazıyla açıldı ve karşılaştırılan oturum sözlüğü eşleşti. 5. gece sonu kaydı yeni süreçte `kapi` fazıyla açıldı. Önceki yapıda oluşturulmuş kayıttaki eski tek istek alanı dönüşümü ilk açılışta görüldü. Yeni biçimde yazılıp süreç kapatıldıktan sonra tekrar açılan 5. gece sonu kaydında fark listesi boştu.

Eş hafızası hem eski hem yeni kayıttan yükleniyor. Etkin kayıt yalnızca mevcut oyun ekranında yazılıyor. Yeni ziyaret kaydındaki boş tek istek durumu eski eksik alandan ayrıldı. Beş söylenti olayının mevcut seçeneklerine Türkçe ve İngilizce sonuç satırları eklendi. Oyuncu köprüsü, akşam sohbeti gibi karar kartının açılışını kilit diye raporlamıyor. Köprü testindeki `beklenen_soru` türü açık verildi. `tek_istek_oyun_test.tscn` 45 kontrolde hata vermedi.

Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/` içindeki `02-oyun-dongusu.jsonl`, `02-besinci-gun.jsonl`, `02-kalici-yaz.log`, `02-kalici-orta.log`, `02-besinci-gece-son_yaz.log`, `02-besinci-gece-son.log`, `02-tek-istek.log` ve `02-import.log`. Bölüm 2 koşuları headless. İlk durumda yanlış yuvaya kopyalanan test kaydının içindeki yuva kimliği fixture'da düzeltildi.

## Bölüm 3 — Çerçeve ve arka plan

Festive yayını `6cea9ca3`.

Altı çerçeve eski çerçeve ya da süssüz durumla açıldı. On arka plan için ortak yükleyici etiketli kutuya, yükleme ekranı ise `loading_bg.png` dosyasına döndü. İzole kopyaya geçici renkli PNG'ler konup tek import yapıldığında altı çerçeve dokuya bağlandı ve on arka plan ortak yükleyiciden `TextureRect` olarak açıldı. Çerçeve sınamaları diyalog şeridi, seçenek satırı, portre, genel panel, mühür ve dört rumi köşenin bağlantılarını kapsadı.

Oyun içinde üç yükleme adayı, ayarlar ve heybe gerçekten çağrılıyor. `kapi_gece.png`, `koy_gunduz.png`, `koy_gece.png`, `gun_sonu.png` ve `kayit.png` için oyun ekranında çağrı bulunmadı. Bu beş yol dosya konunca kendiliğinden ilgili ekranda görünmez. Kapı ve köydeki 3B görünümün üzerine hangi bölgede yer alacağı da oyun içi bağ aşamasında netleştirilmeli.

Başarılı koşular `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/03-dosyasiz.log`, `03-png-ile.log` ve aynı dizindeki `03-import.log`. İlk dosyasız deneme betiği `SceneTree` açılışında heybe sınıfını Ses autoload'undan önce çözmeye çalıştı. Denetim betiği heybe betiğini çalışma anında yükleyince dosyasız ve PNG'li koşular sıfır hatayla tamamlandı. Geçici 16 PNG ve bunların `.import` yan dosyaları izole kopyadan kaldırıldı.

## Bölüm 4 — Açık bulgular ve oynama kontrolü

### Açık bulgular

- **Eklentiler ve performans.** Eklentiler sekmesinin güvenilir ekran görüntüsü açık. Takip turunda Instanced Renderer ve ProtonScatter ayrı ölçüldü. Köylü, sürü ve tüccarın kapı rotası geçti. İlk surlu köy çekiminde 30 FPS tekrarlanamadı. Görünür pencereyle takipte normal profil 33–34 FPS, SMAA kullanan yeni düşük profil 71 FPS verdi. Yerel kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/05-profil/`. [Takip ölçümü ve koşulları](EKLENTI_BAGLANTI.md). Terrain3D çalışma anındaki `free_editor_textures` uyarısı takip turunda giderildi. Eklentiler sekmesinin ekran görüntüsü Windows güncelleme istemi nedeniyle açık.
- **Arka planlar.** Kapı gecesi, köy gündüz/gece, gün sonu ve kayıt ekranı için beş PNG yolunun ekran bağlantısı yok. Kapı ve köy için 3B sahnenin hangi alanının görselle kaplanacağı yerleşim kararı gerektiriyor.
- **Godot uyarıları.** Parley'nin üç kayıt deposu ile HDR başlık uyarıları açık. Theatre kapanışındaki null dosya sistemi taraması, geçerlilik kontrolü eklenince yeniden oluşmadı. Kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/09-theatre/editor-kapanis.log`. Beş söylenti olayının eksik sonuç anahtarları ve oyun köprüsü testindeki tür çıkarımı hatası Bölüm 2'de giderildi.
- **Yerel ayna.** Bu makinedeki erişilebilir kopya Ahmet'in çalışma dizini. `C:/Users/ds/Documents/GitHub/GameDevoloper` erişilebilir olmadığı için yerel eşitleme yapılamadı. Bölüm commit'leri festive'e gönderildi.

### Eksik asset ve animasyonlar

| Tür | Açık ihtiyaç |
|---|---|
| 2D çerçeve | Diyalog şeridi, seçenek satırı, portre, genel panel, mühür, rumi köşe. |
| 2D arka plan | Yükleme kapı/köy/ocak, kapı gece, köy gündüz/gece, ayarlar, heybe, gün sonu, kayıt. Nihai ad ve ölçüler envanterde. |
| 3D karakter rig ve klip | Kıpçak savaşçısı `k02`, kapüşonlu köylü `b092`, gezgin tüccar `k14`, sepetli tüccar `k15`, Kangal `b019`. İskelet, yürüyüş ve sakin bekleme. **Alpha'da da var.** |
| 3D hayvan klibi | Öküz yürüyüşü ve koyun otlaması. Envanterde `ANI-HAYVAN-SURU`. |

[Eksik Asset Envanteri](EKSIK_ASSET_ENVANTERI.md) ve [Alpha günlüğü](../codex.md/Antigravity.md).

### Ahmet'in oynarken kontrol edeceği 10 madde

1. Godot 4.7.2 ile oyunu aç. Yükleme sonunda ana menüye geçişi ve editörün kırmızı hata satırlarını kontrol et.
2. Proje Ayarları → Eklentiler'de beş editör eklentisini, köyde LimboAI ve Instanced Renderer'ın çalışma çıktısını kontrol et.
3. Köyde şafak, gündüz, akşam ve geceyi aynı kamera açısından izle. Gündüz gölgesine ve gece meydan ateşine bak.
4. Bir köylüyü, bir hayvanı ve bir tüccarı duvar ve kapı çevresinde izle. Ayağın zemine oturmasına ve rota takılmasına bak.
5. Başka oyun kapalıyken köyde aynı kamera ve grafik profiliyle 30 FPS ortanca ve 100 ms en uzun kare sınırını ölç.
6. 3. günde bir kişiyi sorgula, birini kabul et, birini geri çevir. Köydeki yeni kişiyi, iş etkisini ve sonraki ziyaretçiyi kontrol et.
7. 2. yuvada köyde F5'e bas, oyunu kapat ve Devam Et ile aç. Kaynaklar, iş atamaları ve yuvanın aynı kaldığını kontrol et.
8. 4. ve 5. gece raporunda üretim, tüketim, zarar ve olay seçimini kontrol et. 5. gece sonu kaydını oyunu kapatıp yeni süreçte aç.
9. Kapı sorgusunu ve tüccar diyaloğunu birer kez aç. Ret ve harç sonuçlarının ilgili karaktere ve köy durumuna işlendiğini kontrol et.
10. Nihai PNG'ler geldiğinde diyalog, düğme, portre, mühür, rumi köşe, yükleme, ayarlar ve heybeyi aç. Beş eksik ekran bağı eklendiğinde aynı koşuyu bu ekranlarda da yap.


## Takip — Kalıcı F5 regresyon testi

Başlatmak için `python -B tests/oto/hizli_kayit_yuva_kontrol.py <Godot.exe>`. Test yalıtılmış kayıt dizini kullanıyor. İlk Godot süreci F5'i açık raporda ve normal oyunda sınayıp etkin yuvayı, önceki kaydın yedeğini ve 1. yuvanın değişmediğini doğrular. İkinci süreç Devam Et ile 2. yuvayı açar ve oturum sözlüğünü kayıttan okunan değerlerle karşılaştırır. İki aşama da geçti. Kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/06-kayit-regresyonu/`. Bu test F5 ve yeniden açılışa odaklanır, 3–5. gün oynama kanıtı Bölüm 2'de durur.


## Takip — Altıncı ile sekizinci günler

5. gece sonu kaydından başlayınca 6. gece raporu açıldı. 7. günde Sancak Beyi'nin ulağı yalnız `ulak_dinle` düğmesini sundu. Oyun köprüsünün sabit karar listesi geçerli düğme anahtarını reddetti. Köprü artık açık, görünür ve etkin oyun düğmesini esas alıyor. Geçersiz değer ve gösterilmeyen düğme reddediliyor.

6. gece sonundan yeni süreçte devam edilince `ulak_dinle` uygulandı. 7. ve 8. gece raporları kapandı. Yeniden başlatılan 604 adımlık koşu sıfır hata ve `gece_siniri` ile tamamlandı. 6, 7, 8. gecelerde gıda üretimi sırasıyla +16, +11, +9. 8. gece sonu dosyası `8 / kapi` durumuyla diske yazıldı. Kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/08-gec-dongu/`.
