# Eklenti bağları — köy sahnesi

20 Kasım 2026, Cursor. Dal `claude/festive-volta-li1sfm`. Yedi eklenti ince adaptörle `KoyYonetimSahnesi` üzerine bağlandı. Eski yol, yenisi doğrulanmadan silinmedi. Ekonomi ve gece üretim hesabı değişmedi.

## Ne nereye bağlandı

| Eklenti | Bağ | Eski yol |
| --- | --- | --- |
| Instanced Renderer 1.3 | `src/koy/gorsel/ornek_yigini.gd`. Durağan ve iskeletsiz ağlar `InstancedMesh3D` (`is_static`, parça 32 m, görüş 120 m). Çit parçası `KoyYonetimSahnesi._sur_kur` içinde, topluluk dekoru `ToplulukDekoru` içinde. Sürü küresi ve kutusu hareketli (`is_static` kapalı) `CobanSurusu` içinde. Statik düğüm bir kare sonra eklentinin yığın yöneticisine geçer ve sahneden çıkar; hareketli düğüm sahnede kalır. Çim (12.000 tutam) ve orman kartı eski `MultiMesh` olarak durur: 12.000 ayrı düğüm daha pahalı olur, çim gölgelendiricisi `MODEL_MATRIX` kullanır. | MeshInstance3D duruyor; dönüşüm yalnız iskeletsiz kopyada. İskeletli GLB'ye dokunulmaz. Tavuk ölçeği `celep_hayvan_gorseli.gd` içinde 0,40 m. |
| Sky3D 2.1 | `KoyAtmosferi`. Köyün `WorldEnvironment` ve güneşi Sky3D. Saat oyun saati değil, mevcut faz: şafak 5,4 (geceden gündüze geçiş), gündüz 9,5, akşam 18,85, gece 22,6. Takvim yılı 1352, ay mevsimden. Sis: alacakaranlık, açık gündüz, akşam, karanlık gece. `game_time_enabled` kapalı; zamanı faz sürer. Samanyolu Sky3D kubbesinde her zaman yüklü. Kredi: ESO/S. Brunier, CC BY 4.0. | Sky3D çocukları yoksa eski panorama ortamı (`_eski_kur`). Kapı ve menü ortamına dokunulmadı. |
| Terrain3D 1.1 | `src/koy/gorsel/koy_zemini.gd`. 128 yükseklik, aralık 240/127 m, köken (−120, 0, −120). Köy ızgarası düz (y = 0). Dışarıda eski `yukseklik_burada` tepesi. Katmanlar, repodaki Poly Haven CC0 2K: çimen `sparse_grass`, patika `rocky_trail`, çamur `muddy_tracks`. `brown_mud_leaves_01` 1K olduğu için katmana girmedi (Terrain3D karışık boyutu reddeder). Çarpışma kapalı (`collision_mode` 0): seçim, yapı ve navigasyon y = 0 düzleminde kalır. | Eski zemin düzlemi `zemin_eski` adıyla sahnede durur, bölge oluşunca gizlenir. |
| ProtonScatter 4.2 | `src/koy/gorsel/koy_serpintisi.gd`. Dört saçıcı, `render_mode` 0 (instancing), görüş 120 m, marj 8 m. Ot 140 (mevcut tutam ağı), taş 28, çalı 18, ağaç 12. Yol kenarı ot ve taş; 34–68 m halka çalı ve ağaç. Kapı yolu, dolu hücre, yol hücresi ve meydan yasak. | Yeni düğüm `koy_serpintisi`. Çim ve orman yığınına dokunulmaz. |
| LimboAI 1.8.1 | `src/koy/gorsel/halk_agaci.gd` + `halk_gorev.gd`. Seçici: alarm, hayvan otla/dolaş, gece eve, akşam bekle, gündüz iş, yedek bekle. `BTPlayer.set_scene_root_hint` ile köy sahnesi. Yalnız `limbo` meta ve alarmda görsel bekleme. Üretim ve rota hesabı aynı. | `KoyHalkHareketi.yenile` / `faz` ve `CobanSurusu` otlatması duruyor. |
| GdPlanningAI 1.0 | `src/koy/gorsel/ihtiyac_plani.gd`. En çok 3 ajan: ilk esnaf, sonra aç veya asker. Açlık, su, pazar. `ON_DEMAND`. Sonuç köylü metasındaki `ihtiyac` (ekmek/su/pazar). `k.ac` ve üretim değişmez. Anahtar `data/ayarlar/eklenti_bag.json` → `ihtiyac_plani`. Genel sınıf adı eklenmedi (`Action` / `Goal` eklentinindir). | Kapalıyken düğüm eklenmez. |
| Dialogue Manager 4.2 | `src/diyalog/dm_kopru.gd`. Kapı: `data/diyalog/kapi_sorgu.dialogue` (iş / su debuff). Tüccar kapısı ve esnaf muhabbeti: `data/diyalog/tuccar.dialogue` (harç, rüşvet, geri çevir). Metin tr + `*.en.dialogue`. Karar `dm_is`, `dm_sonraki` ve `is_gucu` (0,7 tavan, gece sıfırlanır). Uydurma evrak yok. | `SozMotoru`, Parley ve `metinler.csv` duruyor. Esnaf olmayan köylü Parley'de kalır. |

## Ölçüm

Headless Godot 4.7.2, hedef `tests/unit/koy/eklenti_bag_test.gd`. `RenderingServer` çizim ve üçgen sayacı bu kukla görüntüleyicide 0/0 döndü. Aşağısı sahnedeki düğümlerden sayıldı (`OrnekYigini.olc`). Görünmez eski zemin de sayıya girer.

Boş test köyü (sur yok, sürü yok), bağlardan sonra:

| Kalem | Değer |
| --- | --- |
| Tahmini çizim çağrısı | 32 |
| Sayılan üçgen | 296.988 |
| Sahnede kalan InstancedMesh3D | 0 (statik 4 dekor bir kare sonra yığına geçti) |
| Düz MeshInstance3D | 26 |
| MultiMeshInstance3D | 6 (eski çim + orman + 4 serpinti) |
| Durağan dönüşüm | 4 |

Bağlardan önceki aynı köyün tahmini: 4 dekor hâlâ ayrı MeshInstance3D olurdu (düz 30) ve serpinti olmazdı (MultiMesh 2). Çağrı yine 32'dir: 4 tekil dekor çizimi, 4 serpinti yığınıyla yer değiştirdi. Serpinti 198 noktayı (140+28+18+12) 4 çağrıda tutar; her nokta ayrı MeshInstance3D olsaydı çağrı yaklaşık 198 artardı. Çim ve orman zaten tek yığındı, yerinde bırakıldı. Yeni FPS eşiği uydurulmadı (`docs/gorevler/PERFORMANS_BUTCESI.md` aynı).

Sur seviyesi 0 olduğu için çit dönüşümü bu testte çalışmaz. Sürü hareketli InstancedMesh3D kullanır; test köyünde sürü yoktur.

## Test

`eklenti_bag_test.gd` çıkış 0. Sky3D faz saati, Terrain3D bölgesi, eski zeminin gizlenmesi, yükseklik 0, çarpışma 0, dört serpinti ve çıktısı, çim yığını, Limbo meta, planlayıcıda `ihtiyac=ekmek`, kapı debuff + sonraki kişi, tüccar harcı. Tam sanity koşulmadı. Kapanıştaki PagedAllocator / RID / Parley uyarıları bu turdan öncedir.

## Bilinen sınır

- Headless pencereden ekran görüntüsü alınamadı (`texture_2d_get` t null).
- Statik InstancedMesh3D sahnede durmaz; görüntü eklentinin iç yığınındadır. Hareketli sürü düğümü durur.
- Planlayıcı ağırlaşırsa `data/ayarlar/eklenti_bag.json` içinde `ihtiyac_plani` false yapılır. Bu turda açık kaldı; test köyünde esnaf `ekmek` seçti.
- GdPlanningAI `gdpai_agent.gd` tek satır: zamanlayıcı genel ad yerine `/root/GdPAIAutoload`. Genel ad, autoload yazılmadan derlenen betikte yoktu ve JSON sözlüklerini boşaltıyordu.

## 22 Kasım 2026 — Windows çalışma denetimi (Kalfa)

MCP, `editor_plugins/enabled` içinde Dialogue Manager, Sky3D, Terrain3D, GdPlanningAI ve ProtonScatter'ı doğruladı. LimboAI ve Instanced Renderer, `.gdextension` ile yükleniyor. Pencereli oyunda `BTPlayer` ve `InstancedMesh3D` sınıfları mevcut. Açık başka bir oyun nedeniyle Eklentiler sekmesinin güvenilir penceresi yakalanamadı.

- **Sky3D.** Şafak 5,4, gündüz 9,5, akşam 18,85 ve gece 22,6. Dört çekimde açık gündüz, turuncu alacakaranlık ve gece meydan ateşi ayrıldı. Güneş gölgesi gündüz açık, diğer örneklerde kapalı.
- **Terrain3D.** Köy bölgesi ve zemin dokuları mevcut. Test köyündeki 12 karakter gövdesinin kök yüksekliği araziyle 0,001 m çözünürlükte eşleşti. Altı albedo/normal doku için mipmap açıldı. Forward+ doğrulamasında altı doku da mipmap döndürdü.
- **ProtonScatter.** Dört çıktı 140 ot, 28 taş, 18 çalı ve 12 ağaç örneği verdi. Altı yığın ve dört durağan dönüşüm headless testiyle görüldü.
- **LimboAI ve GdPlanningAI.** Köylüde BT düğümü ve esnafta `ekmek` planı görüldü. Pencereli köyde `pazar` planı tamamlandı. Hayvan ve tüccar rotalarının duvar etrafındaki davranışı uzun süreli izlenmedi.
- **Dialogue Manager.** `eklenti_bag_test.gd` kapı sorgusu, ret sonrası iş gücü düşüşü ve sıradaki köylü bağı ile tüccar diyaloğunu ve harcı doğruladı. Balon konumu Alpha'nın alanı.

### Kısa performans ölçümü

RTX 3050 Laptop GPU, Forward+, 640×360, 45 FPS üst sınırı. Aynı kamera ve köyde ProtonScatter açık → gizli → açık, her durumda 48 kare. Instanced Renderer üç durumda da etkin.

| ProtonScatter | Ortanca FPS | En uzun kare | Görünen çizim çağrısı |
|---|---:|---:|---:|
| Açık | 25,8 | 67,0 ms | 83 |
| Gizli | 27,1 | 60,7 ms | 71 |
| Açık | 26,6 | 41,6 ms | 83 |

Üç örnek de [performans bütçesindeki](gorevler/PERFORMANS_BUTCESI.md) 30 FPS ortanca sınırının altında, 100 ms kare süresi sınırının içinde. Ölçüm düşük işlem önceliğinde ve başka bir oyun açıkken alındı. Temiz performans koşusuyla yeniden doğrulama ve Instanced Renderer için tek başına ölçüm gerekli. [Log ve ekran görüntüsü yolları](CODEX_DENETIM_RAPORU.md).


## 22 Kasım 2026 — Surlu köyde ayrı eklenti ölçümü (Kalfa)

`bd8a9a69` commitli izole kopya. RTX 3050 Laptop GPU, Godot 4.7.2 Forward+, 640×360, VSync kapalı, 120 FPS üst sınırı. Başlangıçta GPU %0 ve 44 MiB idi, ana oyun ve editör kapalıydı. Aynı kamera, 12 köylü, 3 yapı ve seviye 1 sur kullanıldı. Instanced Renderer kapalı varyantında yalnız test kopyasındaki durağan dönüşüm atlandı ve özgün ağlar korundu. Açık varyantta 102 ağ dönüştü. Her yapılandırma için 24 ısınma karesinden sonra iki ayrı 84 karelik pencere alındı.

| Instanced Renderer | ProtonScatter | Ortanca FPS aralığı | Görünür çizim çağrısı | Köy viewport GPU ortancası | En uzun kare |
|---|---|---:|---:|---:|---:|
| Açık | Açık | 24,61–24,68 | 88 | 12,65–13,58 ms | 50,57 ms |
| Açık | Gizli | 24,54–24,56 | 76 | 14,04–14,58 ms | 53,01 ms |
| Kapalı | Açık | 24,78–26,41 | 86 | 12,02–13,33 ms | 46,11 ms |
| Kapalı | Gizli | 24,95–31,57 | 74 | 11,64–13,55 ms | 46,44 ms |

ProtonScatter görünürlüğü bu kadrajda 12 çizim çağrısı ekledi. Instanced Renderer iki çağrı ekledi ve örneklenen sahnede FPS kazancı göstermedi. Tek 31,57 FPS örneği sonraki pencerede tekrarlanmadı. En uzun kareler 100 ms sınırındaydı. Viewport GPU süresi tüm kareyi kapsamadığından darboğazın tamamı bu sayılardan çıkarılamaz. Üretim ayarları bu ölçümle değiştirilmedi.

Köylünün işe yürüyüşü, akşam ev durağına varışı ve duraklaması geçti. Dört koyun gündüz otlağa çıktı, geçit kapandığında kestirme yapmadı ve akşam ağıla döndü. Sürü sahnesi testine mevcut ağıl yapım bilgisi eklendi. Kayıt kıyası ekranın açılışından sonra başlıyor. Tüccar harçtan sonra eşiği x=1,05 m'de geçti, açıklığın yarı genişliği 1,75 m. Köy yönünde z=2,49 m'ye ilerleyip sahneden ayrıldı. Tüccar ölçümü kapı rotasını kapsar.

Yerel kanıt dizini `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/04-performans/`. `instanced-*.log`, dört varyant PNG'si, `koylu.log`, `suru-rota.log` ve `tuccar.log`.


## 22 Kasım 2026 — Düşük grafik profili, köy kenar yumuşatma (Kalfa)

Aynı surlu köy 1280×720 görünür pencerede ölçüldü. Köyün SubViewport boyutu 1920×1080. Testte VSync kapalı, üst sınır 120 FPS. Görsel inceleme için [yerel kanıt dizini](CODEX_DENETIM_RAPORU.md) raporda.

| Deneme | Ortanca FPS | Köy GPU ortancası |
|---|---:|---:|
| Normal, %100, MSAA + SMAA | 33,21–35,62 | 14,09–15,11 ms |
| Normal, %75, MSAA + SMAA | 48,71 | 10,35 ms |
| Düşük, %75, MSAA + SMAA | 52,17–54,41 | 9,25–9,64 ms |
| Düşük, %75, yalnız SMAA | 67,35–70,35 | 7,19–7,59 ms |

SMAA kullanan SubViewport'larda düşük profil MSAA'yı devre dışı bırakıyor. Normal profile dönüldüğünde önceki MSAA değeri geri yükleniyor. SMAA kullanmayan kapı görünümünün MSAA değeri korunuyor. Değişiklik sonrasında köy saati 1x iken normal → düşük → normal geçişi sırasıyla 34,13 → 71,40 → 33,20 FPS verdi. Önceden duran sahnede yapılan yan yana ölçüm, AA değişikliğinin tek başına etkisini gösterir. Bu değerler aynı donanım ve örnek köyle sınırlı.

Godot headless import ile `grafik_profili_test.gd` geçti. Canlı sahne testi düşük profilde `MSAA_DISABLED + SMAA`, normale dönüşte `MSAA_4X + SMAA` doğruladı. Kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/05-profil/`.


## 22 Kasım 2026 — Terrain3D çalışma uyarısı (Kalfa)

Köyde Terrain3D Assets kaynağı çalışma anında oluşturuluyor. Dosyaya bağlı editör dokularını boşaltma özelliği bu örnekte kapatıldı. Aynı eklenti testi arazi bölgesini, mevcut çarpışma davranışını ve eklenti bağlarını doğruladı. `free_editor_textures requires Assets...` uyarısı çıkmadı. Import ve hedefli test 0. Yerel kanıt `D:/Kapı_Muhafizi_Codex_Denetim_d0e3f89f/07-eklenti-kapanis/`. MCP beş editör eklentisini yeniden doğruladı. Windows güncelleme istemi Eklentiler sekmesine erişimi kapattı.
