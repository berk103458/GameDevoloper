# ReadmeGrok

Bunu Grok yazdı. Abinin ajanı isterse kullanır.

# Berk'in ajanı için

Oyun artık 3D. Bu dosya Ahmet'in ürettiklerini anlatıyor. İstersen kullan, zorunda değilsin. 3D modeller ve ses zaten sahnede duruyor. 2D çizimler ve Flutter prototip görselleri eski ekranlar içindi.

## Kapı diyalogları

Gemini 3.1 Pro ile üretildi. Adsız gelenler. Karar sohbetten sonra. Düğmeler her gelende aynı anda açılmaz. Oyun bunları `data/diyalog/diyalog_01_20.json` dosyasından okuyor. Adsız gelenler sırayla bu 20 metni kullanır.

- `diyalog_01` (ciftci). Kapıya yorgun adımlarla biri yanaştı. Sırtında boyundan büyük bir darı çuvalı var. Eliyle göğsüne bastırdığı ayrı bir kesede tohum taşıyor. Düğme: Önce Ret. Bir cevap sonra Kabul ve Rüşvet. Kışla yok.
- `diyalog_02` (esnaf). Üstü başı toz içinde. Koltuk altında çuha topu. Düğme: Önce Rüşvet. Bir cevap sonra Kabul ve Ret. Kışla yok.
- `diyalog_03` (asker). Aksayarak geldi. Kırık kargıya yaslanıyor. Düğme: Önce Kışla. Bir cevap sonra Kabul ve Ret. Rüşvet yok.
- `diyalog_04` (ciftci). İki koyun, belinde süt kabı. Düğme: Önce Kabul. Bir cevap sonra Rüşvet ve Ret. Kışla yok.
- `diyalog_05` (esnaf). Elleri is. Çekiç ve körük parçası, örs yok. Düğme: Önce Ret. Bir cevap sonra Kabul ve Kışla. Rüşvet yok.
- `diyalog_06` (asker). Miğfer yamulmuş, kın boş. Düğme: Önce Kışla. Bir cevap sonra Kabul. İki cevap sonra Ret. Rüşvet yok.
- `diyalog_07` (ciftci). Kırık saban, küçük arpa çuvalı. Düğme: Önce Rüşvet. Bir cevap sonra Ret. İki cevap sonra Kabul. Kışla yok.
- `diyalog_08` (esnaf). İp çilesi, deri biz. Mal yok. Düğme: Önce Kabul. Bir cevap sonra Rüşvet. Ret ve Kışla yok.
- `diyalog_09` (asker). Sağlam yay, sadak neredeyse boş. Düğme: Önce Ret. Bir cevap sonra Kabul. Kışla ve Rüşvet yok.
- `diyalog_10` (ciftci). Toprak testi, yarım ekmek. Düğme: Önce Ret. Bir cevap sonra Rüşvet. İki cevap sonra Kabul. Kışla yok.
- `diyalog_11` (asker). Omzunda çatlak bir kalkan asılı duruyor, kargısı elinde yok. Sağ kolu dirsekten bileğe kadar kirli bir bezle göğsüne sarılmış. Çizmeleri dizine kadar balçığa batmış, zırhının etekleri yırtık. Düğme: Kabul, Ret, Kışla
- `diyalog_12` (esnaf). Eşeğinin heybesinde dövme bakır taslar ve iki uzun kepçe birbirine çarpıp tıngırdıyor. Önlüğü ocak isine bulanmış, sol kaşının üstünde kurumuş derin bir sıyrık var. Düğme: Rüşvet, Kabul, Ret
- `diyalog_13` (ciftci). Kucağında zayıf, topal bir teke yavrusu sıkıca sarılı duruyor. Keçe yeleği boydan boya yırtılmış, çarıkları taşa sürtünmekten parçalanmış. Çıplak dizleri diken çizikleri ve pıhtılaşmış kanla kaplı. Düğme: Ret, Kabul
- `diyalog_14` (esnaf). Kendir kuşağında irice, kalın deriden bir tuz kesesi sarkıyor. Sırtındaki çuval heybe aşınmaktan delinmiş. Elleri tuzdan ve soğuktan çatlamış, sol şakağında kurumuş sert bir sıyrık var. Düğme: Kabul, Rüşvet, Ret
- `diyalog_15` (asker). Boynundaki deri kayışta eğri bir bakır borazan asılı duruyor. Deri yeleği omuz başından parçalanmış, belindeki kılıcın ahşap kını çatlak. Şakağından yanağına doğru taze bir kılıç sıyrığı pıhtılaşmış. Düğme: Kışla, Ret, Kabul
- `diyalog_16` (ciftci). Kucağında kökleri bezle sarılı kuru bir fidan gövdesi ve sapı aşınmış bir bağ bıçağı tutuyor. Peştamalı balçığa ve toprağa bulanmış. Avuç içleri su toplamış, patlayan yerlerden sarı su sızıyor. Düğme: Ret, Kabul, Rüşvet
- `diyalog_17` (esnaf). Kuşağında pirinç dirhem ağırlıkları birbirine vuruyor, koynundan küçük bir el terazisi sarkıyor. Çamurlu kaftanının etekleri yırtılmış. Sol ayağındaki mest parçalanmış, topuğundan sızan kan çamura karışıyor. Düğme: Rüşvet, Ret, Kabul
- `diyalog_18` (ciftci). Sırtında demir başlıklı ağır bir kürek taşıyor. Yırtık abasının altından çıkan parmak uçları kireçten çatlamış ve kabuk bağlamış. Sağ omzunda sopa ya da taş çarpmasından kalma taze morluk var. Düğme: Kabul, Kışla, Ret
- `diyalog_19` (esnaf). Boynuna urganla asılmış gürgen bir oklava ve sırtında tahta hamur teknesi taşıyor. Unlu mintanının kolları yırtılmış. Sol dirseğinde taş zemine çarpmaktan kaynaklanan derin bir sürtünme sıyrığı var. Düğme: Ret, Rüşvet, Kabul
- `diyalog_20` (esnaf). Eski bir deri palaskaya takılı demir çifte nal ve uzun bir kerpeten sarkıyor. Toz içindeki mintanı terden sırılsıklam olmuş. Sol topuğu yırtık bir bezle sarılı, beze kan ve çamur bulaşmış. Düğme: Kışla, Kabul, Ret

## Şu an oyunda kullanılanlar

### 3D modeller

- `assets/model/karakter/asker_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/aydogdu_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/ayse_baci_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/ciftci_kadin_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/ciftci_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/esnaf_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/hasan_celebi_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/karaca_usta_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/miraen_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/nogay_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/saruca_hatun_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/sorhan_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/thessra_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/karakter/yusuf_yuru.glb`. Yürüme animasyonlu 3D karakter. Kapı ve köy sahnesi bunu kullanıyor.
- `assets/model/nesne/agac.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/nesne/araba.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/nesne/cuval_yigini.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/nesne/kaya.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/nesne/kazik_cit.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/nesne/kuyu.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/nesne/mesale.glb`. Köyde duran 3D eşya. Sahne bunu kullanıyor.
- `assets/model/yapi/cadir.glb`. 3D yapı (kapı, ev, pazar, kervansaray). Sahne bunu kullanıyor.
- `assets/model/yapi/ev.glb`. 3D yapı (kapı, ev, pazar, kervansaray). Sahne bunu kullanıyor.
- `assets/model/yapi/kapi.glb`. 3D yapı (kapı, ev, pazar, kervansaray). Sahne bunu kullanıyor.
- `assets/model/yapi/kervansaray.glb`. 3D yapı (kapı, ev, pazar, kervansaray). Sahne bunu kullanıyor.
- `assets/model/yapi/pazar_tezgahi.glb`. 3D yapı (kapı, ev, pazar, kervansaray). Sahne bunu kullanıyor.

### Ses

- `assets/ses/muzik_gece_dongu.wav`. Gece müziği, ney. Oyunda çalıyor.
- `assets/ses/ortam_mesale_dongu.wav`. Meşale ortam sesi. Oyunda çalıyor.
- `assets/ses/sfx_adim.wav`. Yürüme adımı. Oyunda çalıyor.
- `assets/ses/sfx_bar_catlak.wav`. Bar çatlağı. Oyunda çalıyor.
- `assets/ses/sfx_bar_kirildi.wav`. Bar kırılması. Oyunda çalıyor.
- `assets/ses/sfx_gece_bitti.wav`. Gece bitişi. Oyunda çalıyor.
- `assets/ses/sfx_insaat.wav`. İnşaat. Oyunda çalıyor.
- `assets/ses/sfx_kapi_acilir.wav`. Kapı açılışı. Oyunda çalıyor.
- `assets/ses/sfx_kapi_kapanir.wav`. Kapı kapanışı. Oyunda çalıyor.
- `assets/ses/sfx_kese.wav`. Rüşvet kesesi. Oyunda çalıyor.
- `assets/ses/sfx_olay.wav`. Gece olayı. Oyunda çalıyor.
- `assets/ses/sfx_onay.wav`. Karar onayı. Oyunda çalıyor.
- `assets/ses/sfx_saldiri.wav`. Saldırı. Oyunda çalıyor.
- `assets/ses/sfx_secim.wav`. Seçim. Oyunda çalıyor.

## İstersen kullan

### 2D piksel çizimler

Gemini hattıyla, eski 2D görünüm için üretildi. Oyun 3D olduğu için sahnede karşılıkları yok. Dosya adları duruyor, istersen arayüz ikonu olarak alabilirsin.

- `assets/art/char/char_aydogdu_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_aydogdu_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_craftsman_01_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_craftsman_01_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_farmer_01_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_farmer_01_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_farmer_02_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_farmer_02_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_karaca_usta_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_karaca_usta_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_miraen_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_miraen_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_saruca_hatun_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_saruca_hatun_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_soldier_01_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_soldier_01_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_sorhan_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_sorhan_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/char_thessra_idle_village.png`. 2D köyde duran karakter. Oyun 3D olunca şart değil.
- `assets/art/char/char_thessra_neutral_card.png`. 2D kapı kartı portresi. Oyun 3D olunca şart değil.
- `assets/art/char/crowd_tekfur_spear_01_far.png`. 2D uzak kalabalık figürü. Oyun 3D olunca şart değil.
- `assets/art/env/env_gate_scene_bg.png`. 2D sahne arka planı. Menü ve köy artık 3D, şart değil.
- `assets/art/env/env_menu_bg.png`. 2D sahne arka planı. Menü ve köy artık 3D, şart değil.
- `assets/art/env/env_village_bg.png`. 2D sahne arka planı. Menü ve köy artık 3D, şart değil.
- `assets/art/fx/fx_torch_village_01.png`. 2D meşale efekti. 3D sahnede şart değil.
- `assets/art/fx/fx_torchlight_patch_village_01.png`. 2D meşale efekti. 3D sahnede şart değil.
- `assets/art/ui/icon_bribe_pouch_empty_48.png`. Rüşvet kesesi ikonu.
- `assets/art/ui/icon_bribe_pouch_full_48.png`. Rüşvet kesesi ikonu.
- `assets/art/ui/icon_decision_accept_48.png`. Karar düğmesi ikonu (kabul, ret, rüşvet, kışla).
- `assets/art/ui/icon_decision_barracks_48.png`. Karar düğmesi ikonu (kabul, ret, rüşvet, kışla).
- `assets/art/ui/icon_decision_bribe_48.png`. Karar düğmesi ikonu (kabul, ret, rüşvet, kışla).
- `assets/art/ui/icon_decision_reject_48.png`. Karar düğmesi ikonu (kabul, ret, rüşvet, kışla).
- `assets/art/ui/ui_bar_segment_cracked_01.png`. Üst şeritteki bar parçası.
- `assets/art/ui/ui_bar_segment_cracked_02.png`. Üst şeritteki bar parçası.
- `assets/art/ui/ui_bar_segment_empty.png`. Üst şeritteki bar parçası.
- `assets/art/ui/ui_bar_segment_full.png`. Üst şeritteki bar parçası.
- `assets/art/ui/ui_cursor_arrow_32.png`. Fare imleci.

### Flutter prototip görselleri

`assets/aday/` altına kondu. 3D Godot sahnesi bunları yüklemiyor. İstersen referans ya da arayüz taslağı olarak kullan.

- `assets/aday/portraits/bust-miraen.jpeg`. Miraen'in göğüs portresi. Flutter prototipinin kapı kartı için.
- `assets/aday/portraits/bust-sorhan.jpeg`. Sorhan'ın göğüs portresi. Flutter prototipinin kapı kartı için.
- `assets/aday/portraits/bust-thessra.jpeg`. Thessra'nın göğüs portresi. Flutter prototipinin kapı kartı için.
- `assets/aday/portraits/idle-miraen.jpeg`. Miraen'in duruş görseli. Flutter prototipinin köy sahnesi için.
- `assets/aday/portraits/idle-sorhan.jpeg`. Sorhan'ın duruş görseli. Flutter prototipinin köy sahnesi için.
- `assets/aday/portraits/idle-thessra.jpeg`. Thessra'nın duruş görseli. Flutter prototipinin köy sahnesi için.
- `assets/aday/backgrounds/bg-city.jpeg`. Şehir arka planı. Flutter prototipinin köy ekranı için.
- `assets/aday/backgrounds/bg-gate.jpeg`. Kapı arka planı. Flutter prototipinin kapı ekranı için.
- `assets/aday/ui/banner-day-done.jpeg`. Gün bitti şeridi. Flutter prototipinin gece sonu için.
- `assets/aday/ui/btn-boot-continue.jpeg`. Açılışta devam düğmesi. Flutter prototipinin ilk ekranı için.
- `assets/aday/ui/btn-boot-cta.jpeg`. Açılıştaki ana düğme. Flutter prototipinin ilk ekranı için.
- `assets/aday/ui/btn-crisis-bribe.jpeg`. Kriz ekranında rüşvet düğmesi. Flutter prototipi için.
- `assets/aday/ui/btn-enter.jpeg`. İçeri al düğmesi. Flutter prototipinin kapı kararı için.
- `assets/aday/ui/btn-finish-day.jpeg`. Günü bitir düğmesi. Flutter prototipi için.
- `assets/aday/ui/btn-restart.jpeg`. Yeniden başlat düğmesi. Flutter prototipi için.
- `assets/aday/ui/btn-suppress.jpeg`. Bastır düğmesi. Flutter prototipinin kriz ekranı için.
- `assets/aday/ui/card-building.jpeg`. Bina kartı çerçevesi. Flutter prototipinin köy yönetimi için.
- `assets/aday/ui/card-crisis.jpeg`. Kriz kartı çerçevesi. Flutter prototipi için.
- `assets/aday/ui/chip-history.jpeg`. Geçmiş etiketi. Flutter prototipi için.
- `assets/aday/ui/chip-hotspot.jpeg`. Sıcak nokta etiketi. Flutter prototipinin haritası için.
- `assets/aday/ui/frame-card.jpeg`. Kart çerçevesi. Flutter prototipi için.
- `assets/aday/ui/hud-bar-crisis.jpeg`. Kriz barı. Flutter prototipinin üst şeridi için.
- `assets/aday/ui/hud-bar-faction.jpeg`. Grup barı. Flutter prototipinin üst şeridi için.
- `assets/aday/ui/hud-bar-gold.jpeg`. Altın barı. Flutter prototipinin üst şeridi için.
- `assets/aday/ui/hud-crisis-chip.jpeg`. Kriz sayacı. Flutter prototipi için.
- `assets/aday/ui/hud-day-frame.jpeg`. Gün çerçevesi. Flutter prototipinin üst şeridi için.
- `assets/aday/ui/hud-gold.jpeg`. Altın göstergesi. Flutter prototipi için.
- `assets/aday/ui/hud-guard.jpeg`. Muhafız göstergesi. Flutter prototipi için.
- `assets/aday/ui/icon-back.jpeg`. Geri ikonu. Flutter prototipi için.
- `assets/aday/ui/icon-caravanserai.jpeg`. Kervansaray ikonu. Flutter prototipinin bina seçimi için.
- `assets/aday/ui/icon-close.jpeg`. Kapat ikonu. Flutter prototipi için.
- `assets/aday/ui/icon-market.jpeg`. Pazar ikonu. Flutter prototipinin bina seçimi için.
- `assets/aday/ui/nav-badge.jpeg`. Alt menü rozeti. Flutter prototipi için.
- `assets/aday/ui/nav-bar.jpeg`. Alt menü şeridi. Flutter prototipi için.
- `assets/aday/ui/nav-city.jpeg`. Köy sekmesi. Flutter prototipi için.
- `assets/aday/ui/nav-gate.jpeg`. Kapı sekmesi. Flutter prototipi için.
- `assets/aday/ui/panel-management.jpeg`. Yönetim paneli. Flutter prototipinin köy ekranı için.
- `assets/aday/ui/plate-game-over.jpeg`. Oyun bitti plakası. Flutter prototipi için.
- `assets/aday/ui/plate-interior.jpeg`. İç mekân plakası. Flutter prototipi için.
- `assets/aday/ui/plate-sticker.jpeg`. Etiket plakası. Flutter prototipi için.
- `assets/aday/ui/reply-accept.jpeg`. Kabul cevabı görseli. Flutter prototipinin karar düğmesi için.
- `assets/aday/ui/reply-barracks.jpeg`. Kışla cevabı görseli. Flutter prototipinin karar düğmesi için.
- `assets/aday/ui/reply-bribe.jpeg`. Rüşvet cevabı görseli. Flutter prototipinin karar düğmesi için.
- `assets/aday/ui/reply-reject.jpeg`. Ret cevabı görseli. Flutter prototipinin karar düğmesi için.
- `assets/aday/ui/ribbon-leak.jpeg`. Sızıntı kurdelesi. Flutter prototipinin kriz uyarısı için.
- `assets/aday/ui/stamp-accept.jpeg`. Kabul mührü. Flutter prototipinin karar sonucu için.
- `assets/aday/ui/stamp-barracks.jpeg`. Kışla mührü. Flutter prototipinin karar sonucu için.
- `assets/aday/ui/stamp-bribe.jpeg`. Rüşvet mührü. Flutter prototipinin karar sonucu için.
- `assets/aday/ui/stamp-reject.jpeg`. Ret mührü. Flutter prototipinin karar sonucu için.
- `assets/aday/ui/ui-clue-strip.jpeg`. İpucu şeridi. Flutter prototipinin sohbeti için.
- `assets/aday/ui/ui-parchment.jpeg`. Parşömen zemin. Flutter prototipinin diyalog paneli için.
- `assets/aday/ui/ui-visitor-count.jpeg`. Gelen sayacı. Flutter prototipi için.
- `assets/aday/visitors/gate-bg.svg`. Kapı arka planı, yedek vektör. Flutter prototipi PNG'yi birincil kullanıyordu.
- `assets/aday/visitors/portrait-crown.svg`. Taçlı ziyaretçi portresi, yedek vektör. Flutter prototipi için.
- `assets/aday/visitors/portrait-founder.svg`. Kurucu portresi, yedek vektör. Flutter prototipi için.
- `assets/aday/visitors/portrait-merchant.svg`. Tüccar portresi, yedek vektör. Flutter prototipi için.

## karakterler klasörü

Bunu Muharrir yazdı. Oyun henüz bu dosyaları okumuyor. `data/diyalog/diyalog_01_20.json` duruyor. Onu silme, onun yerine bunu bağlama. Berk'in ajanı isterse bakar.

`karakterler/` içinde her kişi ayrı bir sayfa. `CHR_001.md` diye gider. `OKU.md` tek satırlık dizin. Şablon motor kartı. Kimlik, maske, nişan, görsel iz, diyalog ağacı, köy statı. Statlar Refah, Erzak, Güvenlik, Moral, Sağlık. Değişim 1 ile 10 arası. İçeri alınan kişi köyde bir iş görür. Ret debuff döner. Rüşvet ve kışla da iz bırakır. Evrak yok.

Şu an diskte CHR_001 ile CHR_030 var. Otuz kişi tamam. Çiftçiler CHR_011 ile CHR_020. Askerler CHR_021 ile CHR_025: Cemil levent, Bayram davulcu, Necip keşif eri, Fehmi cebe yamağı, Nevzat sucu. Esnaflar CHR_026 ile CHR_030: Salih saraç, Rasim çömlekçi, Hulusi bezci, Basri çivi ustası, Latif değirmen kalfası. Commit, Ahmet söylemeden atılmaz. Bu commit Ahmet'in şarjı bitmeden önce istediği kayıttır.

CHR_001 ile CHR_010 Gemini'nin ilk turu. İçlerinde Kızıl Karga çetesi, kundak ve kapıyı içeriden açma var. Ahmet bunları silme dedi, kötü de olsa duruyor. CHR_003 Haydar kalaycı kılığında cerrah. CHR_008 Dudu Hatun ebe. CHR_011 ile CHR_015 çiftçi. İdris harman, Zeynep bağ, Osman tohum, Bekir çoban, Emine bostan. Osman kendi ambarını yakmış, Emine dere bendini kırmış. Onlar da duruyor.

CHR_016 ile CHR_020 da çiftçi, duruyor, silinmeyecek. Halil budamacı, eşek borcunu ödeyemeyip aşı çubuğuyla kaçtı. Fadime sağmal çoban, kızını heybede saklıyor. Rahime bostancı, ana tohumunu su kabağına sakladı. İsmail kuyu ve ark temizleyicisi, su nöbetini savıp kuraklık yalanına sığındı. Satılmış ırgat, karısının bakır kalburunu kumara rehin bırakıp utancından kaçtı.

CHR_021 ile CHR_030 kişisel sır. Borç, çocuk, ana, yalan, utanç. Köyü yakmak, bendi kırmak, zehir, suikast, çete ve kapı açmak yok. Kabul edilen kişi köyde gerçek bir iş görür.

Dikkat, başka ajanlar için: bir dosyanın kimliği o dosyanın kendisidir. Eski sayfalardaki köşeli parantez spawn satırları ayrı kanca isimleridir ve aynı numarayı başka bir kişiye vermiş olabilir. Örnek: CHR_004 içindeki [CHR_016] Demirci Rüstem'dir, dosya CHR_016 ise Halil'dir. Aynı şey CHR_011 ve sonrası için de geçer. Oyun bu sayfaları yüklemez. Eski sayfaları bu çakışma yüzünden düzeltme. Godot hâlâ data/diyalog/diyalog_01_20.json okur.
