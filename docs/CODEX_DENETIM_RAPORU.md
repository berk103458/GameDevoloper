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


## Takip — Onuncu gece ve alternatif tohum

Tohum 11 ile 8. gece sonu kaydı yeni bir süreçte açıldı. 9. ve 10. gece raporları 651 adımda sıfır hata ile kapandı. Gıda üretimi +10 ve +9, tüketimi 14 ve 18. 10. gece sonu kayıt fazı `kapi`. Tohum 76 ve hikâye odaklı seçimle ana menüden başlayan alternatif 507 adımlık koşu da 3. geceye sıfır hata ile ulaştı.

Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/08-gec-dongu/gece-9-10.ozet.json` ve aynı dizinde `erken-alternatif-76.ozet.json`.


Tohum 76'nın 3. gece sonu kaydını izleyen koşu Zeynep'in inceleme panelinde durdu. Köprü durumunda evre `sohbet` göründü, seçenekler arasında `Sorguya dön` vardı ve hikâye politikası `soru_sor` isteğini tekrarladı. Köprü açık inceleme nedeniyle isteği reddetti. Bu bulgu otomatik oyuncunun modal seçim akışına ait. 4. ve 5. gece bu tohumda doğrulanmadı. Kanıt `alternatif-76-gece-4-5.jsonl`.

## Takip — Açılış menüsü ve öğretici (23 Kasım 2026)

Godot 4.7.2 Forward+ ve RTX 3050 Laptop ile gerçek ana menü, 1920 × 1080 iç çözünürlükte ölçüldü. Hareketli gökyüzü başlangıçta 2048'lik gök ışığı küp haritasını kalite modunda güncelliyordu. 256'lık gerçek zamanlı küp haritasıyla medyan 275,2 ms'den 30,3 ms'ye (3,6 → 33,0 FPS), yüzde 95 kare süresi 333,8 ms'den 34,0 ms'ye indi. Ana menünün ilk düğme odağı ile Yeni Oyun geçişi çalıştı. 3D arka planı 960 × 540'a indiren deneme medyanı iyileştirmedi, bu değişiklik pakete alınmadı. Kanıtlar: D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/10-ana-menu/onceki-temel.log, gok256-temel.log ve son.log. Görüntüler aynı dizinde onceki.png ve gok256.png.

Temiz festive kopyasında `koy_yonetim_sahnesi.gd` henüz commit edilmemiş `KameraSurukleme.odak_sinirla()` metodunu çağırdığı için derleme hatası verdi. Önce/sonra denemeleri aynı yerel kamera bağımlılığıyla D: üzerindeki test kopyasında yapıldı. Kamera dosyaları düzenlenmedi. Alpha eksik kamera metodunu ve daha sonra ulak panelindeki sözdizimi hatasını festive'e ekledi. Güncel kodla import ve açılış temiz geçti. Menü yamasıyla ayrı son koşuda 92 karede medyan 13,89 ms (yaklaşık 72 FPS), yüzde 95 kare süresi 14,12 ms ve Yeni Oyun geçişi başarılıydı. Kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/10-ana-menu/festive.log`.

### Öğretici ve mevcut diyalog ağacı

`docs/DIYALOG_DALI_BIRLESME_NOTU.md` 30 ziyaretçi için üç kademeli sorguları, koşullu takipleri ve yalan/doğru dallarını belgeliyor. Türkçe oyun verisi `data/diyalog/diyalog_01_20.json` içinde. `src/sistemler/oturum.gd` ziyaretçiye ve dile göre bu ağacı yükler. Köylü ve eş sohbetleri ayrı Parley kaynaklarından geliyor.

İlk iki gün için mevcut `KoyRehberiPaneli` işçi, yatak, gıda ve kapı kararını takip ediyor. `data/ogretici/ilk_saat.json` ile `IlkSaat` zamanlanmış ipuçlarını sağlıyor. İlk ailede yalnız soru ve karar öğretiliyor. Yönetim öğreticisinin kabul akışı, ilk köy ekranında bir işçi ata ve üretimini gör, stok ve yatak değişimini oku, geceye geç, ilk aileyi sorgula ve kararın ertesi günkü iş gücü ile kaynak etkisini köyde gör adımlarından oluşur. İnceleme ve daha derin sorgu, ilk uygun ziyaretçide mevcut ağacın gerçek düğmeleriyle tanıtılır. Tamamlanma oyuncunun yaptığı işlemden okunur. Öğreticiyi atlayıp temel akışa dönme ve gün ortası kaydından kalınan adımı açma da kabul akışına dahildir.

Antigravity `9a798752` ile ilk iki günün hikâyesi ve rehberini güncelledi. Ahmet öğretici entegrasyonunu Alpha'ya, kabul testini Kalfa'ya verdi. Dört senaryo `docs/tester/OGRETICI_KABUL_TESTI.md` dosyasında hazır. Alpha'ya öğretici, kamera commit'i ve üretim sırası Ajan Masası #11 üzerinden iletildi. Asset gerekmedi.

## 23 Kasım 2026 — Beş arka plan bağı ve ProtonScatter yeniden ölçümü (Antigravity)

### Beş arka plan bağlantısı (`assets/ui/arkaplan/`)
- `GeceKapisiCerceve.arka_plan_varsa(ad)` eklendi; dosya mevcutsa tam ekran `TextureRect` (`arka_<ad>`, `MOUSE_FILTER_IGNORE`) kurar, dosya yoksa `null` dönerek önceki görünümü aynen korur.
- `kayit.png` → `YeniOyunEkrani` ve `KayitHataPaneli` (`BilgiEkrani` üzerinden, hafif karartma perdesiyle).
- `kapi_gece.png` → `KapiEkrani` (3B kapı sahnesinin arkasına katman), *Muhafızın geçmişi* ekranı ve kapı duraklatma ekranı.
- `koy_gunduz.png` → `KoyEkrani` gündüz açılışı ve gündüz duraklatma ekranı.
- `koy_gece.png` → `KoyEkrani` geceye geçiş / köy olayı ekranı ve gece duraklatma ekranı.
- `gun_sonu.png` → `KoyEkrani` gece sonu raporu ve `AksamSohbetiPaneli` arka katmanı.

### ProtonScatter yeniden ölçümü
Güncel `KoySerpintisi` ayarlarıyla (`GORUNUR = 120.0`, `[["ot", 140], ["tas", 28], ["cali", 18], ["agac", 12]]`, 4 `ProtonScatter` alt düğümü / 4 `ScatterOutput`) gerçek `KoyEkrani` (`SubViewport` `1920×1080`, `1280×720` pencerede, Vulkan 1.4.341 Forward+, NVIDIA GeForce RTX 3050 Laptop GPU, VSync kapalı, 120 FPS üst sınırı, 12 köylü, 3 hazır yapı `kulube`/`tarla`/`ambar`, `sur_seviye = 1`) üzerinde ölçüldü. Her koşuda 24 ısınma karesi ardından 84 kare örneklendi:

| Durum | Ortanca FPS | Ortanca kare | En uzun kare | Köy viewport GPU ort. | Görünür çizim çağrısı (VP / Toplam) | Görünür ilkel (VP / Toplam) |
|---|---:|---:|---:|---:|---:|---:|
| Normal %100 (`MSAA 4X + SMAA`), Scatter Açık (1) | 35,60 | 28,09 ms | 36,39 ms | 13,75 ms | 88 / 672 | 494.022 / 2.969.030 |
| Normal %100 (`MSAA 4X + SMAA`), Scatter Gizli | 34,66 | 28,85 ms | 34,19 ms | 14,27 ms | 77 / 634 | 448.208 / 2.889.195 |
| Normal %100 (`MSAA 4X + SMAA`), Scatter Açık (2) | 33,95 | 29,46 ms | 42,64 ms | 14,71 ms | 89 / 670 | 494.790 / 2.958.619 |
| Düşük %75 (`MSAA kapalı + SMAA`), Scatter Açık | 69,93 | 14,30 ms | 18,22 ms | 6,99 ms | 87 / 286 | 494.718 / 499.978 |
| Düşük %75 (`MSAA kapalı + SMAA`), Scatter Gizli | 71,50 | 13,99 ms | 17,61 ms | 6,84 ms | 75 / 274 | 448.136 / 453.396 |

Normal (%100) iki ProtonScatter Açık penceresi de **33,95–35,60 FPS** vererek 30 FPS sınırının üzerinde ve 36,39–42,64 ms ile 100 ms kare bütçesinin altında kaldı. ProtonScatter bu kadrajda köy viewport'una ~11–12 çizim çağrısı ve ~46k ilkel eklemekte, düşük profilde ise fark yalnız ~0,15 ms GPU medyanıdır (`69,93` vs `71,50` FPS). Bu nedenle `src/koy/gorsel/koy_serpintisi.gd` yoğunluğu düşürülmedi.

## Takip — Kapı inceleme ekranından sorguya dönüş (23 Kasım 2026)

Oyun köprüsü CHR inceleme paneli veya eşya ayrıntı kartı açıkken bunu `inceleme_acik` alanında bildirir. Hikâye politikası görünür inceleme düğmelerini birer kez kullanır, ayrıntı kartını kapatır ve sorguya döner. Diğer politikalar görünür geri dönüş düğmesini kullanır. Normal sohbet ve karar komutları korunur.

Tohum 76, üçüncü gece sonu gerçek kaydından başlatıldı. Zeynep'in incelemesi sekiz geçerli `devam` isteğiyle geçildi. Dördüncü ve beşinci geceler 483 adım ve sıfır hatayla tamamlandı. Politika denetiminde altı doğrulama geçti. Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/11-diyalog/tohum-76-uyumlu-panel.ozet.json` ve aynı dizindeki JSONL.

İlk koşuda yalnız D: test kopyasında ulak panelinin önceki çalışan sürümü kullanıldı. Alpha'nın ulak sözdizimi düzeltmesi `55130cfd` sonrasında güncel kaynakla import temiz geçti. İkinci koşuda aynı kayıt Halil'in incelemesini geçti ve beşinci gece 372 adım ve sıfır hatayla kapandı. Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/11-diyalog/import-guncel.log` ve aynı dizindeki `tohum-76-festive.ozet.json`. Asset gerekmedi.

## Takip — Kapı sorgusunda grup itibarı ve zar (23 Kasım 2026)

CHR kapı adaptörü grup itibarını ziyaretçinin çözülmüş grup anahtarıyla okur. Paneldeki değiştirici satırı ve atış aynı sayısal zar bağlamını kullanır. Sohbet tepkileri ziyaretin anlatı bağlamını kullanmaya devam eder. Sorgu API'sine açıkça ek zar bağlamı verildiğinde tavan kontrolü ve atış aynı bağlamı okur.

Godot importu, gerçek kapı düğmesine tıklayan zar bağlantı sahnesi ve değiştirici birim testi geçti. Asker grubu itibarı +8 iken panel −1 gösterdi ve atış aynı değeri kullandı. d6 tavanında ek itibar kilidi açtı ve gerekli değer 6 oldu. 30 CHR kaynak sayfası doğrulandı. Ek `chr_sorgu_test.gd` komut satırı koşusu `Ses` autoload bağlamı ve `GorselIz` düğüm yolu yüzünden tamamlanamadı. Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/12-zar-baglam/`. Asset gerekmedi.

## Kapı diyalog motoru ve üç gecelik kabul

Kapı sahnesi ilk aile, adsız figürler, sınıf şablonları, tüccar ve diğer özel ziyaretlerin girişini, sorgusunu ve kararlarını ziyaret başına Söz motorundan geçiriyor. Adlı CHR dalları kendi koşul ve ipucu verilerini kullanır. Seçim, devam ve kaçış sonucu aynı ziyaret motoruna bağlanır. Karar gerçek Oturum işlemini çağırır. Kabul edilen kişi köyün iş gücü havuzuna, ret ve rüşvet etkileri mevcut oyun akışına yazılır. Uygun ret ve tüccar rüşvetinde iş gücü tavanları `data/soz/kurallar.json` içinden okunur. Kuyruk kapanış ve sonraki ziyaret akışını sürdürür.

Kapı ekranından eski Dialogue Manager karşılama ve karar çağrıları kaldırıldı. Düz Gemini replikleri yerine CSV anahtarları kullanılıyor. İlk aile, tüccar girişleri ve usta soruları CSV'de. Özel olayların hesaplanan satırları mevcut veri/adaptör kaynaklarını kullanır. Köyde kullanılan Dialogue Manager köprüsü ve yazım araçlarının kaynak JSON dosyaları yerinde duruyor. İlk aile kararı gerçek karar kimliğiyle yazılır. Önceki kayıtlardaki bool değer metne çevrilirken hata oluşturmaz.

Yeni oyun, tohum 76, hikâye politikası, 312 adım, 3 gece. Dört gözlenen ziyaretin dördünde motor satırı ve kararı var. Kabul 2, ret 1, rüşvet 1. Oyun hatası 0, yer tutucu metin 0. Tohum 11 doğrulamasında ret iş gücünü 1,0'dan 0,7'ye indirdi. Bu ilk üç gece koşularında CHR kaynağına sahip ziyaretçi gelmedi. Statik veri kontrolü 30 CHR ve 30 figür kaynağında 1.685 görünür anahtarı doğruladı. Sessiz yönlendirme düğümleri metin sayımına katılmadı.

Kanıtlar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/13-kapi-soz/uc-gece-son.motor-denetimi.json`, `uc-gece-son.jsonl`, `uc-gece-son.godot.log`, `uc-gece-uyum-kopyasi.motor-denetimi.json` ve `metin-denetimi.json`. Asset gerekmedi.

### Sonraya

Bağımsız CHR testi, `Ses` autoload bağlamı ve `GorselIz` yolu kapatıldı. Zar bağlantısı hedefli sahneyle denetlendi.

## Canlı CHR kapı doğrulaması

`res://tests/oto/chr_soz_canli_kontrol.tscn` yalnız test oturumuna Meryem ve Haydar'ı sırayla verir. Üretim kuyruğu değiştirilmedi. Test normal kapıya girer, görünür düğmelerden ilk soruyu ve takip sorusunu seçer, nişanı inceleyip mevcut yüzleşme dalı üzerinden karar ekranına ulaşır. İki ziyaretin Söz motoru kayıtlarında giriş repliği, `00 → 1.1 → 1.2` takibi, karar ve sonuç bulundu.

- Meryem (`chr_002`) kabul edildi. Nüfus 0 → 1, gıda 30 → 32. Meryem köyün boşta iş gücüne katıldı.
- Haydar (`chr_003`) geri çevrildi. Köy nüfusu 1, gıda 32. Ret sayacı 0 → 1. İkinci kararın ardından gerçek köy ekranı açıldı.

Godot 4.7.2 importu ve sahne çıkış kodu 0. Oyun hatası, eksik metin anahtarı ve yer tutucu metin 0. Log `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/14-chr-canli/canli.log`. Diyalog entegrasyonu kabul edildi. Asset gerekmedi.

## Ses autoload ve görsel inceleme

Kayıtlı `Ses` autoload korunuyor. Zorunlu CHR konuşma ve karar sesleri başlayamazsa kaynak yolu başına bir kez uyarı yazar. Karar sesinin dosya denetimi oynatıcıyla aynı yönlendirmeyi kullanır. Görsel iz düğmesi çerçeve hiyerarşisinden bağımsız bir erişime sahip. Çerçeveli portre tıklanabilir boyutunu korur. Bağımsız CHR testi arayüz betiklerini autoload hazır olduktan sonra yükler.

Import, bağımsız CHR sorgusu ve iki ziyaretli canlı kapı denetimi geçti. Test, replik efektini ve karar sesini kayıtlı `Ses` üzerinden başlattı. Loglar `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/15-soz-kadro/`. Asset gerekmedi.

## Bütün CHR kadrosu

`docs/SOZ_KAPI_KADROSU.md` 30 CHR kaydını ve varış koşullarını listeler. 90 karar koşusunda gerçek gece kuyruğu kullanıldı. Yedi tehdit profili mevcut takvim nedeniyle 14. günden sonra denendi. Kabul, ret ve rüşvetin iş gücü, ret sayacı, gıda, kese ve kapı çıkışı doğrulandı. Sorgu replikleri ve takip seçimi Söz izinde. Sonuçsuz dal veya teklifsiz rüşvet yok. Asset gerekmedi. Log `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/15-soz-kadro/kadro-son.log`.

## Köy tüccarı ve CHR metin anahtarları

Köy tüccar sohbeti Söz'ün veri düğümlerinden yürür. Eski oyun içi Dialogue Manager çağrısı kaldırıldı. Eklentinin çağrıları yalnız önceki bağımsız uyumluluk testinde bulunur. Parley'nin yazılmış köy sohbetleri kendi kaynaklarını kullanır. Tüccar sohbeti kapıda yapılmış ödeme veya rüşveti ikinci kez kasaya yazmaz. Mevcut rüşvet iş gücü etkisi korunur.

900 CHR tablo anahtarı CSV anahtar standardına taşındı. Kaynak düğüm ve kayıt kimlikleri değişmedi. Zar ve kaçış etiketleri CSV biçimine uyar. Köye alınmış CHR'nin ismi sorulmadan görünen etiket eklendi. Metin kaynak doğrulaması, kadro, zar bağlantısı ve eklenti bağları testleri geçti. Asset gerekmedi.

## CHR kaçış sinyali ve kapanış

Kaçış sinyali taşıdığı CHR sorgusunu artık kuvvetli bir başvuruyla tutmaz. Ertelenen işlem sinyali gönderen sorgunun hâlâ kapıdaki ziyaretçiye ait olduğunu denetler. Canlı kapı testi geçici sorgunun serbest kaldığını, Meryem ve Haydar kararlarının uygulandığını doğruladı. Kayıt: `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/15-soz-kadro/chr-kacis-dogrulama.log`. Asset gerekmedi.

## Birim testi giriş noktaları

İlk paket keşfi, betik yoluyla kalıtım kullanan Şiddet Korkusu ekran testini tek başına `godot -s` ile açtı. Godot autoload bağlamını kuramadı ve betiği SceneTree olarak çalıştıramadı. Keşif artık eşleşen test sahnesini açıyor. Gerekirse betiğin kalıtımını izliyor ve düğümü autoload'lar kurulduktan sonra SceneTree sarmalayıcısına ekliyor. Şiddet Korkusu ekran sahnesi ve SceneTree tabanlı oyun testi ayrı giriş noktalarında geçti.

## Beş gece ve çeviri kaynakları

Tohum 76, yeni oyun, hikâye politikası. Kaçış düzeltmesiyle beş gece 2.872 adımda tamamlandı. On kapı karşılaşmasının tamamı Söz izine karar ve sonuç yazdı. Yedi kabul, bir ret, bir rüşvet ve bir harç. Nevzat ve Zeynep doğal gece kuyruğundan geldi. Otomatik oyuncu hatası, Godot hatası, Godot uyarısı ve yer tutucu metin sayısı 0. Performans günlüğü ilk gecede bir kare süresi eşiği ihlali kaydetti. Denetim dosyası D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/15-soz-kadro/bes-gece-kapanis.denetim.json. Aynı klasörde Godot günlüğü ve ham JSONL var. Koşu sonradan festive'e gelen kare animasyonu paketinden öncedir.

Projenin depo içinde beklediği Türkçe ve İngilizce çeviri kaynakları güncel CSV ile eşitlendi. Soğuk ve sıcak importun ürettiği çeviri dosyaları birebir aynı. Asset gerekmedi.

- 226673af — Ses ve GorselIz, bağımsız CHR doğrulaması.
- 2233a400 — Otuz CHR ve 90 karar dalı.
- 6fbdd216 — Köy tüccarı ve CSV anahtarları.
- de1d292d — Kaçış sinyali referans döngüsü ve canlı regresyon testi.
- 9b3ee4d8 — Birim testi sahnesi ve SceneTree kalıtımı. Üç Şiddet Korkusu testi geçti. Kanıt D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/15-soz-kadro/siddet-korkusu-ozet.json.
