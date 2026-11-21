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
