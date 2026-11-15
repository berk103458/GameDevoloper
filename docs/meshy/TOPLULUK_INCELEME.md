# Meshy topluluk modelleri envanter incelemesi

16 Kasım 2026. Kaynak klasör `C:/Users/Ahmet/Desktop/Cursor_All_DAta/Kapı_Muhafizi/assets/meshy/gelen`. Seçim kaynağı `design/art/meshy/meshy-secim.json`.

**86 dosya, 85 GLB ve 1 destek dosyası.** 86 kodun **65** tanesi kesin eşleşti, **7** tanesinin yalnız adayı var, **14** tanesine dosya bulunamadı. **9** GLB'nin listede karşılığı yok. Kesin eşleşen iki kodun ayrıca birer alternatif adayı var. 60 GLB 50.000 üçgeni aşıyor.

GLB geometri, materyal, gömülü görsel ve animasyon kayıtları Python ile okundu. Dosya adı, varsa düğüm/materyal/doku adları ve yerel iki açılı önizleme birlikte incelendi. Çoğu modelde düğüm ve materyal adları genel olduğu için modelin silüeti, dokusu, kullanım amacı ve listedeki ad/grup/bölüm esas alındı. Üçgen sayısı destek kanıtıdır. Kesin eşleşme, envanter kimliği kanaatini gösterir. Dönem uyumu ayrıca değerlendirilmiştir.

Vertex sayısı dosyadaki benzersiz POSITION accessor kayıtlarının toplamıdır. UV dikişlerindeki kopyalar dahil olabilir. Doku sütununda görsel dosyası, texture kaydı, çözünürlük ve materyal sayısı ayrı verilir. Animasyon adları GLB içinden alınmıştır. Bazı yürüyüş dosyalarında klip adı geneldir ve hareket kalitesi önizlemede doğrulanmadı. ZIP veya başka model biçimi yoktu.

İnceltme hedefleri en yakın oyun kamerasına yönelik başlangıç bütçeleridir. Tekrarlanan nesnelerde alt ucu kullan. 50.000 üçgen sınırı altındaki dosyalara hedef atanmadı. İskeletli modellerde UV ve skin ağırlıkları korunmalı. Bazı çok yoğun kaynaklarda hedef, yeniden topoloji ve doku bake gerektirebilir. Uygun olmayan modeller için teknik bütçe yalnız referanstır.

## A. Dosya bazında envanter

| Dosya | Boyut (bayt) | Ne olduğu ve çağ gerekçesi | Önerilen kod | Güven | Üçgen | Vertex | Doku ve materyal | İskelet / animasyon | Çağ uyumu | İnceltme hedefi |
|---|---|---|---|---|---|---|---|---|---|---|
| `.gdignore` | 0 | Boş Godot yok sayma işareti | — | — | — | — | — | — | — | — |
| `Meshy_AI_a_clay_pot_1115205051_texture.glb` | 33.913.244 | Ağzı geniş, bezemesiz pişmiş toprak çömlek | O07 | kesin | 761.834 | 390.672 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG (`material`) | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_A_realistic_old_woode_1115205403_texture.glb` | 4.051.740 | Ahşap iki tekerlekli saman arabası; statik tarla ve harman dekoru | O58 | aday | 24.866 | 19.266 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | — |
| `Meshy_AI_A_robust_corner_modul_1115204612_texture.glb` | 221.352.692 | Düzensiz taşlardan örülmüş kuru duvar köşe modülü | B071 | kesin | 4.518.708 | 4.784.597 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | 12–25 bin |
| `Meshy_AI_A_traveling_medieval__1115114934_texture.glb` | 6.325.248 | Pelerinli, yaşlı seyyar tüccar; kolunda sepet | K15 | kesin | 171.460 | 103.924 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Pelerin, sepet ve sade giysi yolcu görünümüne uyuyor. | 18–30 bin |
| `Meshy_AI_A_traveling_medieval__1115211230_texture.glb` | 8.002.216 | Asalı, sarıklı gezgin tüccar; kumaş katmanları ve bohça | K14 | kesin | 217.307 | 133.581 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Sade kumaş katmanları ve yol eşyaları köy tüccarına uyuyor. | 18–30 bin |
| `Meshy_AI_a_white_goat_1115211422_texture.glb` | 1.517.804 | Kıvrık boynuzlu beyaz evcil keçi | A163 | kesin | 19.452 | 12.533 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Evcil keçinin doğal görünümü köy sürüsüne uyuyor. | — |
| `Meshy_AI_Amber_Feathered_Hen_1115125831_texture.glb` | 54.237.448 | Altın-kızıl tüylü evcil tavuk; kümes dekoru olarak daha ağır statik seçenek | A146 | aday | 655.213 | 359.657 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Uygun. Doğal evcil tavuk silüeti köy kümesine uyuyor. | 12–25 bin |
| `Meshy_AI_Anatolian_Shepherd_Do_1115211348_texture.glb` | 22.611.712 | Siyah maskeli, açık renkli iri Anadolu çoban köpeği | B019 | kesin | 388.371 | 215.398 | 4 görsel / 4 texture / 1 mat.; 3 × 2048×2048 JPEG, 1 × 2048×2048 PNG (`Material_0`) | Yok / yok | Uygun. Koyu ağız maskesi ve iri gövde yerel çoban köpeği tipine yakın. | 12–25 bin |
| `Meshy_AI_Ancient_medieval_wood_1115210124_texture.glb` | 84.770.744 | Üzerinde dokuma bulunan dikey ahşap tezgâh; dokumacı atölyesi | A236 | aday | 583.794 | 798.792 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 1 × 4096×4096 JPEG, 1 × 4096×4096 PNG (`Material_0`) | Yok / yok | Uygun. Görünür düzenek ve malzemeler geleneksel köy zanaatına uyuyor. | 8–15 bin |
| `Meshy_AI_Ancient_terracotta_oi_1115205137_texture.glb` | 15.095.432 | Gagalı, yuvarlak hazneli toprak yağ kandili | O32 | kesin | 364.307 | 207.545 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Antique_Wooden_Plow_1115205317_texture.glb` | 3.730.260 | Ahşap saplı ve toprak süren metal uçlu karasaban | A220 | kesin | 86.388 | 51.487 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | 8–15 bin |
| `Meshy_AI_Athens_An_Ancient_Man_Riding_On_The_20250502_animated_Walking.glb` | 3.755.440 | Antik Atina tipi atlı insan ve at, tek animasyonlu model; Antik Yunan donanımı oyunun döneminden eski | — | yok | 20.171 | 15.094 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 27 eklem / `Armature&#124;Unreal Take&#124;baselayer` | Uygun değil | — |
| `Meshy_AI_Bear_animated_1115211308_texture.glb` | 52.738.868 | İri, boz renkli ayı; dosya adında animated geçse de skin veya klip yok | K07 | kesin | 1.546.078 | 830.903 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Doğal boz ayı görünümü Anadolu yaban hayatı için makul. | 12–25 bin |
| `Meshy_AI_Bellows_on_Wall_1115210112_texture.glb` | 2.521.936 | Duvara asılı, deri yüzlü el körüğü | A042 | kesin | 36.986 | 25.140 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür düzenek ve malzemeler geleneksel köy zanaatına uyuyor. | — |
| `Meshy_AI_black_smith_kiln_sto_1115205934_texture.glb` | 6.839.764 | Taş ocak ile dağınık demirci öğeleri; örsün biçimi küçük önizlemede belirsiz, tekil örs yerine bütün atölye parçası | A040 | aday | 172.837 | 110.376 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Şüpheli | 20–40 bin |
| `Meshy_AI_brahma_huhn_1115211507_texture.glb` | 52.289.736 | Tüylü paçalı Brahma tipi tavuk; Güney Asya kökenli, daha geç biçimlenmiş belirgin ırk görünümü | — | yok | 1.304.372 | 790.357 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun değil | 12–25 bin (teknik referans) |
| `Meshy_AI_Campfire_Cauldron_1115204557_texture.glb` | 9.116.028 | Üç ayaklı askıda asılı kazan ve altında ateş | A228 | kesin | 6.296 | 4.887 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG (`material`) | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | — |
| `Meshy_AI_Campfire_Circle_1115204546_texture.glb` | 1.175.136 | Taş halkayla çevrili açık odun ocağı | A060 | kesin | 3.000 | 3.736 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | — |
| `Meshy_AI_Chicken_20260203_animated_mixamo_All_animation.glb` | 14.624.112 | Kızıl evcil tavuk; üç hareket klipli | K04 | kesin | 235.964 | 141.637 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 21 eklem / `Running`, `Walking`, `RunFast` | Uygun. Kızıl tüyler ve sade evcil tavuk silüeti kırsal kümes için uygun. | 12–25 bin |
| `Meshy_AI_Clay_Jug_1115205101_texture.glb` | 21.595.104 | Tek kulplu, dar ağızlı toprak testi | O48 | kesin | 446.726 | 247.015 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Clay_Oven_Glow_1115210142_texture.glb` | 1.557.236 | Yüksek toprak tandır, altta taş kaide ve görünen köz | A181 | kesin | 20.387 | 14.090 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür düzenek ve malzemeler geleneksel köy zanaatına uyuyor. | — |
| `Meshy_AI_Clay_Oven_Structure_1115210151_texture.glb` | 2.464.780 | Geniş ağızlı, kubbeli toprak fırın | A177 | kesin | 9.960 | 8.967 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür düzenek ve malzemeler geleneksel köy zanaatına uyuyor. | — |
| `Meshy_AI_Colorful_Bazaar_Displ_1115204828_texture.glb` | 8.347.504 | Renkli kumaş örtülü, döşenmiş çarşı tezgâhı | O65 | kesin | 184.169 | 143.884 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap taşıyıcı ile kumaş örtü veya yükler köy pazarı ve yol konaklamasına uyuyor. | 12–25 bin |
| `Meshy_AI_Copper_Pot_with_Lid_1115205120_texture.glb` | 15.552.140 | Tutamaklı kapak ve bakır tonlu yuvarlak tencere | O84 | kesin | 374.832 | 209.154 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Create_a_3D_model_of_an_ancient_Persian_20250219_animated_mixamo_All_animation.glb` | 15.584.060 | Antik Pers olarak adlandırılmış insan; başlık ve katlı giysi dönem doğrulaması ister, yay ayrı görünmüyor | K09 | kesin | 257.376 | 164.765 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 24 eklem / `Agree_Gesture`, `Chair_Sit_Idle_M`, `Checkout_Gesture`, `Indoor_Swing`, `Running`, `Walking` | Şüpheli | 18–30 bin |
| `Meshy_AI_Donkey_Profile_1115211412_texture.glb` | 1.072.368 | Uzun kulaklı boz eşek; B104 ile üçgen sayısı aynı olsa da bir savaşçı değil | A157 | kesin | 9.999 | 7.004 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG (`Material_0.001`) | Yok / yok | Uygun. Sade eşek modeli dönem yük hayvanı olarak uyumlu. | — |
| `Meshy_AI_Dwarven_Windmill_1115210559_texture.glb` | 59.688.492 | Abartılı taş gövdeli, çapraz kanatlı cüce temalı fantastik yel değirmeni | — | yok | 1.610.756 | 927.740 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun değil | 20–40 bin (teknik referans) |
| `Meshy_AI_Eggs_in_a_wicker_bask_1115205228_texture.glb` | 17.733.220 | Yumurta içeren, yüksek saplı hasır sepet | O14 | kesin | 28.037 | 36.002 | 1 görsel / 1 texture / 1 mat.; 1 × 4096×4096 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | — |
| `Meshy_AI_Firewood_Stack_1115205728_texture.glb` | 24.550.900 | Yerde toplu kesilmiş odunlar ve iri kütük | O00 | kesin | 30.415 | 44.068 | 3 görsel / 3 texture / 1 mat.; 2 × 2048×2048 PNG, 1 × 4096×4096 PNG (`BakedMaterial`) | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | — |
| `Meshy_AI_Forest_Watermill_by_t_1115210249_texture.glb` | 94.050.224 | Su çarklı değirmen binası, ağaç ve zeminle birlikte; çatısı ve birleşik diorama köy diline uyarlanmalı | O76 | aday | 1.927.250 | 1.078.554 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Şüpheli | 20–40 bin |
| `Meshy_AI_Frostfur_Warlord_1115211203_texture.glb` | 69.779.820 | Kürk ve abartılı donanımlı fantastik savaş beyi, yanında hayvan | — | yok | 1.286.160 | 724.576 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Uygun değil | 18–30 bin (teknik referans) |
| `Meshy_AI_Golden_Hen_Against_Bl_1115211518_texture.glb` | 39.393.976 | Altın renkli, doğal gövdeli statik tavuk; A146 için hafifletilecek en iyi statik aday | A146 | aday | 230.464 | 132.981 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Uygun. Doğal evcil tavuk silüeti köy kümesine uyuyor. | 12–25 bin |
| `Meshy_AI_Hanging_Terracotta_Oi_1115205146_texture.glb` | 18.493.520 | Halkalı kulplu, sığ toprak yağ kandili; asma düzeneği ayrıca görülmüyor | O19 | kesin | 316.518 | 181.571 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Haystack1_1115205307_texture.glb` | 12.968.076 | Konik tınaz, saman yığını | A202 | kesin | 33.259 | 55.307 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | — |
| `Meshy_AI_Hooded_Medieval_Peasa_1114225137_texture.glb` | 70.693.648 | Kapüşon, kuşak ve sade tunikli köylü | B092 | kesin | 10.214 | 19.217 | 3 görsel / 3 texture / 1 mat.; 1 × 4096×4096 JPEG, 1 × 4096×4096 PNG, 1 × 8192×8192 JPEG (`Material_0`) | Yok / yok | Uygun. Kaba kumaş ve yalın iş giysisi kırsal karaktere uyuyor. | — |
| `Meshy_AI_Horse_20260120_animated_Walking.glb` | 3.998.552 | Kahverengi at; iskeletli yürüyüş dışa aktarımı | K05 | kesin | 47.468 | 27.220 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 27 eklem / `Armature&#124;Unreal Take&#124;baselayer` | Uygun. Sade, modern donanımsız at görünümü döneme uyuyor. | — |
| `Meshy_AI_indian_ox_1115211438_texture.glb` | 1.523.080 | Uzun boynuzlu, hörgüçlü Hint tipi öküz; zebu silüeti yerel Anadolu öküzünden ayrılıyor | A172 | kesin | 19.401 | 12.791 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Şüpheli | — |
| `Meshy_AI_Iron_Cauldron_1114212203_texture.glb` | 27.183.964 | Koyu, ayaklı demir kazan; mutfak kazanı olarak kullanılabilir, seçimdeki bakır yüzey görünmüyor | A227 | aday | 617.352 | 353.291 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Şüpheli | 8–15 bin |
| `Meshy_AI_Iron_portcullis_gate__1115204258_texture.glb` | 3.792.240 | Taş kemerli sur modülünde demir parmaklıklı kapı | O92 | kesin | 75.028 | 51.884 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 12–25 bin |
| `Meshy_AI_Ironwood_Brazier_1115204537_texture.glb` | 8.967.372 | Taş kaideli, ayaklı demir mangal | O05 | kesin | 4.254 | 3.868 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | — |
| `Meshy_AI_Lone_Sheep_20250805_animated_Walking.glb` | 4.606.012 | Yünlü koyun; iskeletli yürüyüş dışa aktarımı | K13 | kesin | 9.802 | 8.368 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 27 eklem / `Armature&#124;Unreal Take&#124;baselayer` | Uygun. Görünür silüet ve yünlü gövde köy koyununa uyuyor. | — |
| `Meshy_AI_Market_Stall_with_Rug_1114232647_texture.glb` | 7.726.468 | Kilim fonlu, örtülü ahşap tezgâh; boş veya tekstil tezgâhı işlevinde düşük maliyetli alternatif | A077 | aday | 188.438 | 129.170 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap taşıyıcı ile kumaş örtü veya yükler köy pazarı ve yol konaklamasına uyuyor. | 12–25 bin |
| `Meshy_AI_Medieval_Beehive_Cons_1115205353_texture.glb` | 1.888.860 | Çan biçimli örgü saman kovan | A186 | kesin | 9.991 | 10.551 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | — |
| `Meshy_AI_medieval_market_stall_1114234047_texture.glb` | 22.384.220 | Alçak saz örtülü, çuvallar dizilmiş tezgâh | A073 | kesin | 635.056 | 408.081 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap taşıyıcı ile kumaş örtü veya yükler köy pazarı ve yol konaklamasına uyuyor. | 12–25 bin |
| `Meshy_AI_medieval_market_stall_1115204742_texture.glb` | 20.267.272 | Beşik biçimli eğimli örtüsü ve altta malları olan tezgâh | A077 | kesin | 566.952 | 364.476 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap taşıyıcı ile kumaş örtü veya yükler köy pazarı ve yol konaklamasına uyuyor. | 12–25 bin |
| `Meshy_AI_Medieval_merchant_20251210_animated_mixamo_All_animation.glb` | 4.509.192 | Sade koyu yeşil tunikli ortaçağ tüccarı; koşu ve yürüyüş klipli | K12 | kesin | 29.944 | 27.450 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 23 eklem / `Running`, `Walking` | Uygun. Katmanlı sade tunik kırsal bir gezgin tüccar için makul. | — |
| `Meshy_AI_medieval_millstone_h_1115205344_texture.glb` | 5.741.892 | Ortası delik, iri ve aşınmış değirmen taşı | A205 | kesin | 158.967 | 86.841 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | 8–15 bin |
| `Meshy_AI_Moonlit_Stone_Mill_1115205335_texture.glb` | 36.380.304 | Sehpalı taş el değirmeni; üst taş ve döndürme kolu | A209 | kesin | 874.267 | 486.835 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | 8–15 bin |
| `Meshy_AI_Mud_Courtyard_House_1115204501_texture.glb` | 135.113.624 | Çevre duvarı ve avlusu olan kerpiç konut grubu; kiremitli çatı ve birleşik avlu ölçeği yerel referans ister | O16 | kesin | 3.149.762 | 2.735.966 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Şüpheli | 20–40 bin |
| `Meshy_AI_Nativity_Blacksmith_F_1115205852_texture.glb` | 62.386.988 | İnsan figürü, örs ve kütük içeren demirci dioraması; Nativity kökenli figür tekil örs işlevini karşılamıyor | A040 | aday | 1.190.502 | 636.888 | 3 görsel / 3 texture / 1 mat.; 1 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Şüpheli | 18–30 bin |
| `Meshy_AI_Ottoman_Mehmed_the_Co_1115211128_texture.glb` | 21.652.796 | Fatih Sultan Mehmed betimi, sarık ve kaftan; 15. yüzyıl Osmanlı | — | yok | 468.021 | 261.870 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun değil | 18–30 bin (teknik referans) |
| `Meshy_AI_Potter_s_Kiln_Pavilio_1115205756_texture.glb` | 122.075.664 | Saz örtülü çömlekçi fırını sundurması ve bir arada çömlekler | O78 | kesin | 3.077.942 | 1.625.293 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG (`material`) | Yok / yok | Uygun. Görünür düzenek ve malzemeler geleneksel köy zanaatına uyuyor. | 20–40 bin |
| `Meshy_AI_Pottery_Trio_1115205236_texture.glb` | 27.431.372 | Farklı boylarda üç pişmiş toprak kap; tekil küpün doğrudan karşılığı değil | A241 | kesin | 680.172 | 364.537 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 8–15 bin |
| `Meshy_AI_Primitive_Tannery_1115205808_texture.glb` | 55.108.040 | Deri germe çerçeveleri ve alçak iş düzenekleri olan debbağhane | O79 | kesin | 549.278 | 300.991 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG (`material`) | Yok / yok | Uygun. Görünür düzenek ve malzemeler geleneksel köy zanaatına uyuyor. | 12–25 bin |
| `Meshy_AI_Rock_Pile_1115072304_texture.glb` | 16.213.388 | Doğal, koyu renkli kaya ve taş kümesi | O18 | kesin | 5.220 | 5.578 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 PNG (`Material_0.001`) | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | — |
| `Meshy_AI_Sack_of_Flour_1115205245_texture.glb` | 15.464.448 | Ağzı açık, içinde beyaz un görünen dokuma çuval | A081 | kesin | 473.038 | 258.437 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Sack_of_Grain_1115205253_texture.glb` | 16.035.160 | İçi açık kahverengi tahılla dolu çuval | A190 | kesin | 477.522 | 262.831 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Screenshot_2025_09_30_1115123449_texture.glb` | 195.218.080 | Görselde ahşap sırığa asılmış kaba bez/deri benzeri parçalar; malzeme kesin değil, debbağhane veya dokuma kurutma dekoru | — | yok | 3.991.524 | 4.157.382 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Kaba kumaş veya deri ve ahşap sırık köy zanaatına uyuyor. | 8–15 bin |
| `Meshy_AI_Shepherd_and_Sheep_1115211530_texture.glb` | 42.053.532 | Asalı, kalın giysili çoban ve koyun konulu sabit figür; hareketli NPC için rig gerekli | B117 | kesin | 1.084.178 | 599.244 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Asa, iş giysisi ve sürü öğesi kırsal çoban temasıyla uyumlu. | 18–30 bin |
| `Meshy_AI_Sickle_Tool_1114224610_texture.glb` | 10.931.156 | Kısa saplı, hilal ağızlı el orağı | A211 | kesin | 105.180 | 68.862 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | 3–8 bin |
| `Meshy_AI_Stacked_Firewood_1115084315_texture.glb` | 2.968.520 | İki dikme arasında ahşap rafa dizilmiş odunlar | O23 | kesin | 2.954 | 4.217 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | — |
| `Meshy_AI_Stone_bench_1115204650_texture.glb` | 46.688.788 | İki ayak üzerinde düz taş oturak | O20 | kesin | 396.660 | 224.115 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | 8–15 bin |
| `Meshy_AI_Stone_Fortress_Wall_0_1115204244_texture.glb` | 3.894.712 | Örgü taş sur duvarının düz modülü | O90 | kesin | 51.117 | 48.793 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 12–25 bin |
| `Meshy_AI_Street_Canine_Watcher_20250830_animated_Walking.glb` | 30.023.156 | Siyah maskeli iri sokak köpeği, yürüyüş dışa aktarımı; Kangal tipi yakın, cins doğrulaması gerekli | B019 | aday | 594.113 | 372.132 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 27 eklem / `Armature&#124;Unreal Take&#124;baselayer` | Şüpheli | 12–25 bin |
| `Meshy_AI_Terraced_Adobe_House_1115204438_texture.glb` | 26.466.936 | Basamaklı terası ve düz damı olan iki katlı kerpiç konut | A116 | kesin | 575.656 | 315.620 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Toprak duvar ve sade konut biçimi kırsal yerleşime uyuyor. | 20–40 bin |
| `Meshy_AI_Terraced_Desert_Adobe_1115204428_texture.glb` | 35.715.660 | Düz damlı, sade kerpiç ev; dış kabuk açık toprak tonlu | A117 | kesin | 984.892 | 539.280 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Toprak duvar ve sade konut biçimi kırsal yerleşime uyuyor. | 20–40 bin |
| `Meshy_AI_Thatched_Farm_Pen_1115085019_texture.glb` | 109.900.632 | Saz örtülü barınak ve çitli hayvan ağılı; ağıla alternatif, yurt veya konut işlevi yok | — | yok | 1.470.878 | 1.202.459 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG (`material`) | Yok / yok | Uygun. Saz ve çitli barınak köy hayvancılığına uyuyor. | 20–40 bin |
| `Meshy_AI_Thatched_Mudbrick_Hou_1115204418_texture.glb` | 8.400.508 | Alçak kerpiç ev; önizlemede saçak/saz dokusu baskın, listedeki toprak dam görünümü ayrıca denetlenmeli | O26 | kesin | 7.890 | 8.432 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Şüpheli | — |
| `Meshy_AI_The_Stone_Well_1115204525_texture.glb` | 33.957.620 | Taş kuyu ağzı, ahşap payandalar ve asılı kova | O21 | kesin | 809.733 | 449.888 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | 12–25 bin |
| `Meshy_AI_The_tower_is_a_massiv_1115204308_texture.glb` | 11.413.608 | Üstü ahşap ve kiremit örtülü yüksek taş gözetleme kulesi | O72 | kesin | 320.119 | 190.653 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 20–40 bin |
| `Meshy_AI_Tribal_Spear_1115134156_texture.glb` | 7.843.468 | Uzun ahşap sırığa takılı yalın metal uçlu mızrak | A012 | kesin | 24.786 | 16.736 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Yalın ahşap ve metal işçiliği dönem donanımıyla uyumlu. | — |
| `Meshy_AI_Turkic_Kipchak_Cuma_1115211031_texture.glb` | 46.999.572 | Başlıklı, kalkanlı ve kılıçlı Kıpçak/Kuman tipli savaşçı; Selçuklu ucu için tarihsel temas makul | K02 | kesin | 1.257.156 | 682.045 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Kıpçak/Kuman etkili donanım Selçuklu ucu bağlamında makul bir yabancı savaşçı görünümü. | 18–30 bin |
| `Meshy_AI_Two_sets_of_weapons_r_1115210611_texture.glb` | 8.515.756 | Mızrak/sırık silahlar taşıyan ahşap sehpalar | A016 | kesin | 222.356 | 140.028 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Yalın ahşap ve metal işçiliği dönem donanımıyla uyumlu. | 12–25 bin |
| `Meshy_AI_Warlord_of_the_Iron_S_1115211151_texture.glb` | 66.356.312 | Abartılı kürklü, giysiden çıkan çıkıntıları ve büyük yayı olan fantastik savaş beyi | — | yok | 1.201.128 | 654.636 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG | Yok / yok | Uygun değil | 18–30 bin (teknik referans) |
| `Meshy_AI_Wicker_Basket_1115205156_texture.glb` | 30.129.944 | İki küçük kulplu, geniş açık hasır sepet | O01 | kesin | 229.763 | 297.622 | 2 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG, 1 × 4096×4096 PNG (`BakedMaterial`) | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | 3–8 bin |
| `Meshy_AI_Wicker_hand_basket_1115205217_texture.glb` | 9.215.164 | Tek yüksek taşıma saplı yuvarlak hasır el sepeti | O51 | kesin | 9.969 | 9.957 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Görünür malzeme ve yapım biçimi gündelik köy eşyasıyla uyumlu. | — |
| `Meshy_AI_Wooden_Fence_1115204119_texture.glb` | 33.589.668 | Sivri uçlu ahşap kazık çit modülü | O17 | kesin | 769.860 | 453.063 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 12–25 bin |
| `Meshy_AI_Wooden_Gate_1115204154_texture.glb` | 59.129.712 | Ahşap palisat kapısı, çit ve çevre öğeleriyle bütünleşik | O25 | kesin | 1.599.643 | 955.778 | 4 görsel / 4 texture / 1 mat.; 4 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 20–40 bin |
| `Meshy_AI_Wooden_Palisade_1115001013_texture.glb` | 9.536.020 | Düz ve düşük poligonlu sivri ahşap palisat | O37 | kesin | 2.990 | 4.568 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | — |
| `Meshy_AI_Wooden_Palisade_with__1115131226_texture.glb` | 58.428.512 | Yürüme platformu ve rampa içeren kazıklı ahşap sur | O81 | kesin | 650.912 | 363.782 | 4 görsel / 4 texture / 1 mat.; 2 × 2048×2048 JPEG, 2 × 4096×4096 JPEG (`material`) | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 20–40 bin |
| `Meshy_AI_Wooden_Trough_1115205713_texture.glb` | 12.813.400 | Uzun, dikdörtgen ahşap yem veya su yalağı | O30 | kesin | 179.416 | 111.161 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Biçim ve malzeme el emeğine dayalı kırsal üretime uyuyor. | 8–15 bin |
| `Meshy_AI_Wooden_Watchtower_at__1115151411_texture.glb` | 43.286.036 | Saz/ahşap örtülü, yüksek ahşap gözetleme kulesi; A113'ün biçimine uyuyor, ayrı dışa aktarım olabilir | A113 | aday | 1.013.142 | 600.029 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap, taş ve görünen demir işçiliği kırsal uç savunmasıyla uyumlu. | 20–40 bin |
| `Meshy_AI_Workshop_Camp_1115204837_texture.glb` | 42.610.440 | Kumaş örtü, yük ve taş çevre öğeleri içeren konaklama kampı | O49 | kesin | 951.487 | 692.853 | 3 görsel / 3 texture / 1 mat.; 3 × 2048×2048 JPEG | Yok / yok | Uygun. Ahşap taşıyıcı ile kumaş örtü veya yükler köy pazarı ve yol konaklamasına uyuyor. | 20–40 bin |
| `Meshy_AI_Woven_Wooden_Fence_1115204624_texture.glb` | 10.693.504 | Esnek dallarla örülmüş, direkli ahşap çeper | O64 | kesin | 307.734 | 178.069 | 1 görsel / 1 texture / 1 mat.; 1 × 2048×2048 JPEG | Yok / yok | Uygun. Malzeme ve sade işçilik köyün ortak alanına uyuyor. | 12–25 bin |
| `Meshy_AI_시장_한가운데_서_있는_듯한_활기찬_중세_상인_여성의_전신_3D_모델_20251018_animated_mixamo_All_animation.glb` | 9.182.268 | Bitki sepetli kadın pazar satıcısı; Korece başlık nesneyi tarif ediyor, giysi ve başlık Anadolu uyumu için ayrıca incelenmeli | — | yok | 88.592 | 60.700 | 1 görsel / 2 texture / 1 mat.; 1 × 2048×2048 PNG (`Material_1`) | 24 eklem / `Hand_on_Hip_Gesture`, `Idle_15`, `Running`, `Walking` | Şüpheli | 18–30 bin |

## B. Kod bazında ters kontrol

Adayı bulunan kodlar çıkarılacak listeye alınmadı. A040 ve A227 adayları, karşılık gelen özgül parçayı veya malzemeyi henüz doğrulamıyor.

| Kod | Ad | Dosya var mı | Hangi dosya |
|---|---|---|---|
| O37 | Ahşap palisat (kazık sur) | Evet | `Meshy_AI_Wooden_Palisade_1115001013_texture.glb` (kesin) |
| O17 | Sivri kazık çit | Evet | `Meshy_AI_Wooden_Fence_1115204119_texture.glb` (kesin) |
| O81 | Yürüme yollu ahşap palisat | Evet | `Meshy_AI_Wooden_Palisade_with__1115131226_texture.glb` (kesin) |
| O25 | Ahşap palisat kapısı | Evet | `Meshy_AI_Wooden_Gate_1115204154_texture.glb` (kesin) |
| A113 | Sazdan çatılı ahşap gözetleme kulesi | Yalnız aday | `Meshy_AI_Wooden_Watchtower_at__1115151411_texture.glb` (aday) |
| O90 | Taş sur duvarı | Evet | `Meshy_AI_Stone_Fortress_Wall_0_1115204244_texture.glb` (kesin) |
| O92 | Taş çerçeveli demir parmaklıklı kapı | Evet | `Meshy_AI_Iron_portcullis_gate__1115204258_texture.glb` (kesin) |
| O72 | Taş-ahşap kule | Evet | `Meshy_AI_The_tower_is_a_massiv_1115204308_texture.glb` (kesin) |
| O26 | Toprak damlı kerpiç ev | Evet | `Meshy_AI_Thatched_Mudbrick_Hou_1115204418_texture.glb` (kesin) |
| A117 | Düz damlı kerpiç ev | Evet | `Meshy_AI_Terraced_Desert_Adobe_1115204428_texture.glb` (kesin) |
| A116 | İki katlı düz damlı kerpiç ev | Evet | `Meshy_AI_Terraced_Adobe_House_1115204438_texture.glb` (kesin) |
| O16 | Avlulu kerpiç ev | Evet | `Meshy_AI_Mud_Courtyard_House_1115204501_texture.glb` (kesin) |
| O31 | Keçe yurt (topak ev) | Hayır | — |
| O67 | Yurt (hafif) | Hayır | — |
| B065 | Tepe taş kulübesi | Hayır | — |
| O21 | Taş kuyu (çıkrıklı) | Evet | `Meshy_AI_The_Stone_Well_1115204525_texture.glb` (kesin) |
| O05 | Demir mangal (nöbet ocağı) | Evet | `Meshy_AI_Ironwood_Brazier_1115204537_texture.glb` (kesin) |
| A060 | Taş halkalı ocak | Evet | `Meshy_AI_Campfire_Circle_1115204546_texture.glb` (kesin) |
| A228 | Sacayak üstünde kazan | Evet | `Meshy_AI_Campfire_Cauldron_1115204557_texture.glb` (kesin) |
| B071 | Kuru taş duvar köşesi | Evet | `Meshy_AI_A_robust_corner_modul_1115204612_texture.glb` (kesin) |
| O64 | Örme çubuk çit (çeper) | Evet | `Meshy_AI_Woven_Wooden_Fence_1115204624_texture.glb` (kesin) |
| O03 | Kuru taş yıkık duvar | Hayır | — |
| O20 | Taş oturak | Evet | `Meshy_AI_Stone_bench_1115204650_texture.glb` (kesin) |
| B021 | 13.–14. yy Anadolu kervansarayı | Hayır | — |
| A073 | Sazdan çatılı pazar tezgâhı (çuvallı) | Evet | `Meshy_AI_medieval_market_stall_1114234047_texture.glb` (kesin) |
| A077 | Örtülü pazar tezgâhı | Evet | `Meshy_AI_medieval_market_stall_1115204742_texture.glb` (kesin); `Meshy_AI_Market_Stall_with_Rug_1114232647_texture.glb` (aday) |
| O65 | Renkli çarşı tezgâhı | Evet | `Meshy_AI_Colorful_Bazaar_Displ_1115204828_texture.glb` (kesin) |
| O49 | Kervan konak yeri (örtü + yük) | Evet | `Meshy_AI_Workshop_Camp_1115204837_texture.glb` (kesin) |
| A242 | Çömlekçi tezgâhı (çömleklerle) | Hayır | — |
| O07 | Toprak çömlek | Evet | `Meshy_AI_a_clay_pot_1115205051_texture.glb` (kesin) |
| O48 | Toprak testi | Evet | `Meshy_AI_Clay_Jug_1115205101_texture.glb` (kesin) |
| O82 | Küp (amfora) | Hayır | — |
| O83 | Eski küp | Hayır | — |
| O84 | Kapaklı bakır tencere | Evet | `Meshy_AI_Copper_Pot_with_Lid_1115205120_texture.glb` (kesin) |
| A227 | Bakır kazan | Yalnız aday | `Meshy_AI_Iron_Cauldron_1114212203_texture.glb` (aday) |
| O32 | Toprak kandil | Evet | `Meshy_AI_Ancient_terracotta_oi_1115205137_texture.glb` (kesin) |
| O19 | Asma toprak kandil | Evet | `Meshy_AI_Hanging_Terracotta_Oi_1115205146_texture.glb` (kesin) |
| O01 | Hasır sepet | Evet | `Meshy_AI_Wicker_Basket_1115205156_texture.glb` (kesin) |
| O51 | Saplı sepet | Evet | `Meshy_AI_Wicker_hand_basket_1115205217_texture.glb` (kesin) |
| O14 | Yumurta sepeti | Evet | `Meshy_AI_Eggs_in_a_wicker_bask_1115205228_texture.glb` (kesin) |
| A241 | Çömlek takımı | Evet | `Meshy_AI_Pottery_Trio_1115205236_texture.glb` (kesin) |
| A081 | Ağzı açık un çuvalı | Evet | `Meshy_AI_Sack_of_Flour_1115205245_texture.glb` (kesin) |
| A190 | Tahıl çuvalı | Evet | `Meshy_AI_Sack_of_Grain_1115205253_texture.glb` (kesin) |
| A202 | Tınaz (saman yığını) | Evet | `Meshy_AI_Haystack1_1115205307_texture.glb` (kesin) |
| A220 | Karasaban | Evet | `Meshy_AI_Antique_Wooden_Plow_1115205317_texture.glb` (kesin) |
| A211 | Orak | Evet | `Meshy_AI_Sickle_Tool_1114224610_texture.glb` (kesin) |
| A209 | El değirmeni | Evet | `Meshy_AI_Moonlit_Stone_Mill_1115205335_texture.glb` (kesin) |
| A205 | Değirmen taşı | Evet | `Meshy_AI_medieval_millstone_h_1115205344_texture.glb` (kesin) |
| A186 | Saman kovan | Evet | `Meshy_AI_Medieval_Beehive_Cons_1115205353_texture.glb` (kesin) |
| O58 | Saman arabası | Yalnız aday | `Meshy_AI_A_realistic_old_woode_1115205403_texture.glb` (aday) |
| O93 | Öküzlü saman kağnısı (duran) | Hayır | — |
| O30 | Ahşap yalak | Evet | `Meshy_AI_Wooden_Trough_1115205713_texture.glb` (kesin) |
| A095 | Taş yalak | Hayır | — |
| O00 | Odun yığını + kütük | Evet | `Meshy_AI_Firewood_Stack_1115205728_texture.glb` (kesin) |
| O23 | Raflı odun istifi | Evet | `Meshy_AI_Stacked_Firewood_1115084315_texture.glb` (kesin) |
| O18 | Taş yığını | Evet | `Meshy_AI_Rock_Pile_1115072304_texture.glb` (kesin) |
| O78 | Çömlekçi fırını sundurması | Evet | `Meshy_AI_Potter_s_Kiln_Pavilio_1115205756_texture.glb` (kesin) |
| O79 | Debbağhane (deri gerdirme) | Evet | `Meshy_AI_Primitive_Tannery_1115205808_texture.glb` (kesin) |
| A040 | Kütük üstünde örs | Yalnız aday | `Meshy_AI_black_smith_kiln_sto_1115205934_texture.glb` (aday); `Meshy_AI_Nativity_Blacksmith_F_1115205852_texture.glb` (aday) |
| A042 | El körüğü | Evet | `Meshy_AI_Bellows_on_Wall_1115210112_texture.glb` (kesin) |
| A236 | Kilim dokuma tezgâhı | Yalnız aday | `Meshy_AI_Ancient_medieval_wood_1115210124_texture.glb` (aday) |
| A181 | Tandır | Evet | `Meshy_AI_Clay_Oven_Glow_1115210142_texture.glb` (kesin) |
| A177 | Kubbeli toprak fırın | Evet | `Meshy_AI_Clay_Oven_Structure_1115210151_texture.glb` (kesin) |
| O76 | Su değirmeni | Yalnız aday | `Meshy_AI_Forest_Watermill_by_t_1115210249_texture.glb` (aday) |
| A016 | Mızrak sehpası | Evet | `Meshy_AI_Two_sets_of_weapons_r_1115210611_texture.glb` (kesin) |
| A002 | Ahşap yuvarlak kalkan | Hayır | — |
| A012 | Mızrak | Evet | `Meshy_AI_Tribal_Spear_1115134156_texture.glb` (kesin) |
| K05 | At | Evet | `Meshy_AI_Horse_20260120_animated_Walking.glb` (kesin) |
| K13 | Koyun | Evet | `Meshy_AI_Lone_Sheep_20250805_animated_Walking.glb` (kesin) |
| K12 | Ortaçağ tüccarı | Evet | `Meshy_AI_Medieval_merchant_20251210_animated_mixamo_All_animation.glb` (kesin) |
| K04 | Tavuk | Evet | `Meshy_AI_Chicken_20260203_animated_mixamo_All_animation.glb` (kesin) |
| K09 | Okçu (Pers) | Evet | `Meshy_AI_Create_a_3D_model_of_an_ancient_Persian_20250219_animated_mixamo_All_animation.glb` (kesin) |
| K02 | Kıpçak / Kuman savaşçısı | Evet | `Meshy_AI_Turkic_Kipchak_Cuma_1115211031_texture.glb` (kesin) |
| K10 | Kışlık giysili tüccar (T-poz) | Hayır | — |
| K14 | Gezgin tüccar | Evet | `Meshy_AI_A_traveling_medieval__1115211230_texture.glb` (kesin) |
| K15 | Gezgin tüccar (sepetli) | Evet | `Meshy_AI_A_traveling_medieval__1115114934_texture.glb` (kesin) |
| B092 | Kapüşonlu köylü | Evet | `Meshy_AI_Hooded_Medieval_Peasa_1114225137_texture.glb` (kesin) |
| B104 | Savaşçı | Hayır | — |
| K07 | Ayı | Evet | `Meshy_AI_Bear_animated_1115211308_texture.glb` (kesin) |
| B019 | Kangal (Anadolu çoban köpeği) | Evet | `Meshy_AI_Anatolian_Shepherd_Do_1115211348_texture.glb` (kesin); `Meshy_AI_Street_Canine_Watcher_20250830_animated_Walking.glb` (aday) |
| A140 | Deve | Hayır | — |
| A157 | Eşek | Evet | `Meshy_AI_Donkey_Profile_1115211412_texture.glb` (kesin) |
| A163 | Keçi | Evet | `Meshy_AI_a_white_goat_1115211422_texture.glb` (kesin) |
| A172 | Öküz | Evet | `Meshy_AI_indian_ox_1115211438_texture.glb` (kesin) |
| A146 | Tavuk (gerçekçi) | Yalnız aday | `Meshy_AI_Amber_Feathered_Hen_1115125831_texture.glb` (aday); `Meshy_AI_Golden_Hen_Against_Bl_1115211518_texture.glb` (aday) |
| B117 | Çoban ve koyun (heykel) | Evet | `Meshy_AI_Shepherd_and_Sheep_1115211530_texture.glb` (kesin) |

### Sürüm ve ikame kararları

- **A113.** `Meshy_AI_Wooden_Watchtower_at__1115151411_texture.glb` doğru ahşap kule biçimini taşıyor. Kaynak 1.013.142 üçgen, seçim kaydı 25.449. Önce 20–40 bin hedefinin içinde silüet, merdiven ve seyir platformu korunarak değerlendirilir. Aynı yayın sürümü olduğu doğrulanmadı.
- **O58 / A236 / O76.** `Meshy_AI_A_realistic_old_woode_1115205403_texture.glb` saman arabasıdır ve fark 14 üçgendir. `Meshy_AI_Ancient_medieval_wood_1115210124_texture.glb` kilim tezgâhıdır ve fark 168 üçgendir. `Meshy_AI_Forest_Watermill_by_t_1115210249_texture.glb` çarklı su değirmenidir ama 1.927.250 üçgenli, çevresiyle birleşmiş ayrı bir modeldir. İlk ikisi güçlü teknik aday, sonuncusu görsel ikamedir.
- **A146 ve K04.** `Meshy_AI_Golden_Hen_Against_Bl_1115211518_texture.glb` 230.464 üçgenle statik A146 adayları içinde daha hafif. `Meshy_AI_Amber_Feathered_Hen_1115125831_texture.glb` 655.213 üçgen, benzer rolü tekrarlar. Hareket gerekiyorsa K04'ün skin ve üç klibi hazırdır.
- **B019.** Kangal kimliği için `Meshy_AI_Anatolian_Shepherd_Do_1115211348_texture.glb` tercih edilir. `Meshy_AI_Street_Canine_Watcher_20250830_animated_Walking.glb` yürüyüş klibi bulunan ikamedir. Kaynağı 594.113 üçgendir ve ırk silüeti doğrulanmalıdır.
- **A077.** Seçimdeki örtülü ürün tezgâhı için `Meshy_AI_medieval_market_stall_1115204742_texture.glb` kesin eşleşmedir. Kilimli bir tekstil tezgâhı aynı işlevde yeterliyse `Meshy_AI_Market_Stall_with_Rug_1114232647_texture.glb` kaynakta yaklaşık üçte bir üçgenle daha hafif.
- **A040.** `Meshy_AI_black_smith_kiln_sto_1115205934_texture.glb` daha hafif işyeri dekoru ve figürsüz kaynak. Tekil kütük üstü örs belirginleşmeden kodu doldurmuş sayılmaz. `Meshy_AI_Nativity_Blacksmith_F_1115205852_texture.glb` figürlü alternatif olup ancak örsü ayrı kullanılabilir durumdaysa incelenir.
- **A227.** `Meshy_AI_Iron_Cauldron_1114212203_texture.glb` üçgen sayısı tutmasına rağmen demir kazan görünümünde. Bakır şartsa kesin dosya olarak kullanılmaz.
- **A157 / B104.** `Meshy_AI_Donkey_Profile_1115211412_texture.glb` 9.999 üçgenle eşektir. B104 ayrıca bir insan savaşçı ister.
- **Sur palisatı.** Düz, sık tekrarlanan sur parçası için `Meshy_AI_Wooden_Palisade_1115001013_texture.glb` (O37, 2.990 üçgen) tercih edilir. Sivri çit O17 ve yürüme platformlu O81 farklı işlevler taşır.

## C. Dosyası bulunmayan kodlar

Çıkarma adayı olan aşağıdaki kodlar için yerel klasörde tekil, anlamca uyumlu bir dosya belirlenemedi.

- **O31** — Keçe yurt (topak ev)
- **O67** — Yurt (hafif)
- **B065** — Tepe taş kulübesi
- **O03** — Kuru taş yıkık duvar
- **B021** — 13.–14. yy Anadolu kervansarayı
- **A242** — Çömlekçi tezgâhı (çömleklerle)
- **O82** — Küp (amfora)
- **O83** — Eski küp
- **O93** — Öküzlü saman kağnısı (duran)
- **A095** — Taş yalak
- **A002** — Ahşap yuvarlak kalkan
- **K10** — Kışlık giysili tüccar (T-poz)
- **B104** — Savaşçı
- **A140** — Deve

A241 takımındaki kaplar O82 veya O83 için tekil ikame olarak sayılmadı. Kilimli tezgâhta A242'nin çömlekli teşhiri, öküz ve saman arabası dosyalarında da O93'ün birleşik kağnısı bulunmuyor.

## D. Ekstra dosyalar ve önerilen kullanım

| Dosya | Önerilen kullanım / eksik kod ikamesi |
|---|---|
| `Meshy_AI_Athens_An_Ancient_Man_Riding_On_The_20250502_animated_Walking.glb` | Atlı figür ve at aynı modelde. Antik Atina betimi nedeniyle oyun için önerilmez. K05'in ayrı atı zaten var. |
| `Meshy_AI_brahma_huhn_1115211507_texture.glb` | Brahma tavuğu çağ açısından önerilmez. Kümes için K04 veya A146'nın doğal görünümlü adaylarına bakılabilir. |
| `Meshy_AI_Dwarven_Windmill_1115210559_texture.glb` | Fantastik yel değirmeni, su değirmeni O76'yı karşılamaz. Oyun için önerilmez. |
| `Meshy_AI_Frostfur_Warlord_1115211203_texture.glb` | Fantastik savaş beyi ve hayvanı, B104 savaşçısı ya da K10 tüccarı için önerilmez. |
| `Meshy_AI_Ottoman_Mehmed_the_Co_1115211128_texture.glb` | 15. yüzyıl Osmanlı hükümdarı, bu dönemin figürü olarak önerilmez. |
| `Meshy_AI_Screenshot_2025_09_30_1115123449_texture.glb` | Debbağhane askısı veya dokuma kurutma alanı için çevre dekoru. O79'un germe çerçevesi yerine geçmez. Eksik bir kodu doldurmuyor. |
| `Meshy_AI_Thatched_Farm_Pen_1115085019_texture.glb` | Köyün mevcut açık ağılı veya kümes çevresi için dekor varyantı. Yurt, ev veya ahır olarak sayılmaz. |
| `Meshy_AI_Warlord_of_the_Iron_S_1115211151_texture.glb` | Fantastik kürklü okçu lider, B104 veya K10 ikamesi olarak önerilmez. |
| `Meshy_AI_시장_한가운데_서_있는_듯한_활기찬_중세_상인_여성의_전신_3D_모델_20251018_animated_mixamo_All_animation.glb` | Giysisi yerel referansa uyarsa köy pazarında hareketli kadın satıcı. K12'nin listelenen modeliyle aynı kişi değil, eksik bir kodu doldurmuyor. |

## E. Şüpheli veya döneme uygun olmayan modeller

| Dosya | Karar | Gerekçe |
|---|---|---|
| `Meshy_AI_Athens_An_Ancient_Man_Riding_On_The_20250502_animated_Walking.glb` | uygun değil | Antik Atina tipi atlı insan ve at, tek animasyonlu model; Antik Yunan donanımı oyunun döneminden eski |
| `Meshy_AI_black_smith_kiln_sto_1115205934_texture.glb` | şüpheli | Taş ocak ile dağınık demirci öğeleri; örsün biçimi küçük önizlemede belirsiz, tekil örs yerine bütün atölye parçası |
| `Meshy_AI_brahma_huhn_1115211507_texture.glb` | uygun değil | Tüylü paçalı Brahma tipi tavuk; Güney Asya kökenli, daha geç biçimlenmiş belirgin ırk görünümü |
| `Meshy_AI_Create_a_3D_model_of_an_ancient_Persian_20250219_animated_mixamo_All_animation.glb` | şüpheli | Antik Pers olarak adlandırılmış insan; başlık ve katlı giysi dönem doğrulaması ister, yay ayrı görünmüyor |
| `Meshy_AI_Dwarven_Windmill_1115210559_texture.glb` | uygun değil | Abartılı taş gövdeli, çapraz kanatlı cüce temalı fantastik yel değirmeni |
| `Meshy_AI_Forest_Watermill_by_t_1115210249_texture.glb` | şüpheli | Su çarklı değirmen binası, ağaç ve zeminle birlikte; çatısı ve birleşik diorama köy diline uyarlanmalı |
| `Meshy_AI_Frostfur_Warlord_1115211203_texture.glb` | uygun değil | Kürk ve abartılı donanımlı fantastik savaş beyi, yanında hayvan |
| `Meshy_AI_indian_ox_1115211438_texture.glb` | şüpheli | Uzun boynuzlu, hörgüçlü Hint tipi öküz; zebu silüeti yerel Anadolu öküzünden ayrılıyor |
| `Meshy_AI_Iron_Cauldron_1114212203_texture.glb` | şüpheli | Koyu, ayaklı demir kazan; mutfak kazanı olarak kullanılabilir, seçimdeki bakır yüzey görünmüyor |
| `Meshy_AI_Mud_Courtyard_House_1115204501_texture.glb` | şüpheli | Çevre duvarı ve avlusu olan kerpiç konut grubu; kiremitli çatı ve birleşik avlu ölçeği yerel referans ister |
| `Meshy_AI_Nativity_Blacksmith_F_1115205852_texture.glb` | şüpheli | İnsan figürü, örs ve kütük içeren demirci dioraması; Nativity kökenli figür tekil örs işlevini karşılamıyor |
| `Meshy_AI_Ottoman_Mehmed_the_Co_1115211128_texture.glb` | uygun değil | Fatih Sultan Mehmed betimi, sarık ve kaftan; 15. yüzyıl Osmanlı |
| `Meshy_AI_Street_Canine_Watcher_20250830_animated_Walking.glb` | şüpheli | Siyah maskeli iri sokak köpeği, yürüyüş dışa aktarımı; Kangal tipi yakın, cins doğrulaması gerekli |
| `Meshy_AI_Thatched_Mudbrick_Hou_1115204418_texture.glb` | şüpheli | Alçak kerpiç ev; önizlemede saçak/saz dokusu baskın, listedeki toprak dam görünümü ayrıca denetlenmeli |
| `Meshy_AI_Warlord_of_the_Iron_S_1115211151_texture.glb` | uygun değil | Abartılı kürklü, giysiden çıkan çıkıntıları ve büyük yayı olan fantastik savaş beyi |
| `Meshy_AI_시장_한가운데_서_있는_듯한_활기찬_중세_상인_여성의_전신_3D_모델_20251018_animated_mixamo_All_animation.glb` | şüpheli | Bitki sepetli kadın pazar satıcısı; Korece başlık nesneyi tarif ediyor, giysi ve başlık Anadolu uyumu için ayrıca incelenmeli |

Teknik kontrolde 8 GLB’de iskelet ve klip bulundu. Kapüşonlu köylünün gömülü renk görseli 8.192×8.192; üçgen sayısı düşük olsa da doku belleği ayrıca değerlendirilmeli.

## F. İnceltme ve bağlama sonuçları

16 Kasım 2026. Blender 4.2 Decimate (Collapse), üst uç, tavan 60.000 üçgen. 50.000 altındaki geometriye dokunulmadı; 1024 üstü dokular JPEG'e indirildi. İskelet ve klipler duruyor. 70 dosyanın 70'i inceldi, atlanan yok. Toplam 1501,9 MB → 83,8 MB. Bağlanan 12 kod `Dunya3B.TOPLULUK_YER` üzerinden mevcut yer tutucunun adını kullanır. 16 Kasım akşamı 39 model daha `ToplulukDekoru` ile köy ızgarasının dışına, her birinden bir kopya, statik dekor olarak kondu. Kapı yolu ve yürüme ızgarası boş. Görüş mesafesi 120 m; Godot LOD açık.

| Dosya | Önce/sonra üçgen | Önce/sonra MB | Oyunda nereye bağlandı | Not |
|---|---|---|---|---|
| `assets/meshy/animasyon_bekliyor/a146_tavuk_gercekci.glb` | 655.213 → 25.000 | 54,2 → 1,4 | Köyün batısı, ağıl yanı, tavuk | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/animasyon_bekliyor/a157_esek.glb` | 9.999 → 9.999 | 1,1 → 0,6 | Köyün batısı, ağıl yanı, eşek | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/animasyon_bekliyor/a163_keci.glb` | 19.452 → 19.452 | 1,5 → 0,6 | — | Keçi zaten hayvan/keci.glb |
| `assets/meshy/animasyon_bekliyor/a172_okuz.glb` | 19.401 → 19.401 | 1,5 → 0,6 | Köyün batısı, ağıl yanı, öküz | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/animasyon_bekliyor/b019_kangal_anadolu_coban_kopegi.glb` | 388.371 → 25.000 | 22,6 → 1,2 | — | Köpek zaten hayvan/kopek.glb |
| `assets/meshy/animasyon_bekliyor/b092_kapusonlu_koylu.glb` | 10.214 → 10.214 | 70,7 → 1,0 | — | Köylü iskeleti yok; figür zorlanmadı |
| `assets/meshy/animasyon_bekliyor/b117_coban_ve_koyun_heykel.glb` | 1.084.178 → 30.000 | 42,1 → 1,9 | Köyün doğusu, heykel | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/animasyon_bekliyor/k02_kipcak_kuman_savascisi.glb` | 1.257.156 → 30.000 | 47,0 → 1,5 | — | İskelet yok; asker yuvası ayrı, statik zorlanmadı |
| `assets/meshy/animasyon_bekliyor/k07_ayi.glb` | 1.546.078 → 24.999 | 52,7 → 1,7 | Köyün kuzeybatısı, ayı | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/animasyon_bekliyor/k14_gezgin_tuccar.glb` | 217.307 → 30.000 | 8,0 → 1,3 | — | İskelet yok; kervan figürü zorlanmadı |
| `assets/meshy/animasyon_bekliyor/k15_gezgin_tuccar_sepetli.glb` | 171.460 → 29.999 | 6,3 → 1,1 | — | İskelet yok; pazar figürü zorlanmadı |
| `assets/meshy/animasyonlu/k04_tavuk.glb` | 235.964 → 24.990 | 14,6 → 1,7 | Köyün batısı, ağıl yanı, tavuk | Statik dekor, tek kopya; klipler duruyor |
| `assets/meshy/animasyonlu/k05_at.glb` | 47.468 → 47.468 | 4,0 → 1,8 | — | At zaten hayvan/at.glb; statik klip sonra |
| `assets/meshy/animasyonlu/k09_okcu_pers.glb` | 257.376 → 29.989 | 15,6 → 2,5 | — | Okçu kıyafeti şüpheli; ayrı yuva yok, klip duruyor |
| `assets/meshy/animasyonlu/k12_ortacag_tuccari.glb` | 29.944 → 29.944 | 4,5 → 1,8 | — | Dolaşan tüccar yuvası yok; klip duruyor |
| `assets/meshy/animasyonlu/k13_koyun.glb` | 9.802 → 9.802 | 4,6 → 0,7 | — | Koyun hazır glTF ile duruyor; klip sonra |
| `assets/meshy/dogrudan/a012_mizrak.glb` | 24.786 → 24.786 | 7,8 → 1,0 | Muhafızın elinde mızrak | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a016_mizrak_sehpasi.glb` | 222.356 → 24.999 | 8,5 → 1,2 | Kapı, mızrak sehpası | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a040_kutuk_ustunde_ors.glb` | 172.837 → 39.999 | 6,8 → 1,6 | — | Örs yuvası tek parça; bu atölye dioraması değil |
| `assets/meshy/dogrudan/a042_el_korugu.glb` | 36.986 → 36.986 | 2,5 → 1,2 | Doğu mutfak avlusu, körük | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a060_tas_halkali_ocak.glb` | 3.000 → 3.000 | 1,2 → 0,3 | Köy meydanı, nöbet ocağı | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a073_sazdan_catili_pazar_tezgahi_cuvalli.glb` | 635.056 → 25.000 | 22,4 → 1,4 | — | Pazar 1 zaten pazar_tezgahi.glb; ikinci tezgâh yok |
| `assets/meshy/dogrudan/a077_ortulu_pazar_tezgahi.glb` | 566.952 → 25.000 | 20,3 → 1,4 | — | Pazar yuvası dolu; ikinci tezgâh yok |
| `assets/meshy/dogrudan/a081_agzi_acik_un_cuvali.glb` | 473.038 → 8.000 | 15,5 → 0,5 | Güney kenar, un çuvalı | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a113_sazdan_catili_ahsap_gozetleme_kulesi.glb` | 1.013.142 → 39.999 | 43,3 → 2,4 | Kuzeybatı dışı, saz çatılı kule | Statik dekor; mevcut gözetleme kulesinin yerine geçmez |
| `assets/meshy/dogrudan/a116_iki_katli_duz_damli_kerpic_ev.glb` | 575.656 → 40.000 | 26,5 → 1,7 | Kuzey kenar, iki katlı ev | Statik dekor; ev.glb duruyor |
| `assets/meshy/dogrudan/a117_duz_damli_kerpic_ev.glb` | 984.892 → 40.000 | 35,7 → 1,8 | Kuzey kenar, kerpiç ev | Statik dekor; ev.glb duruyor |
| `assets/meshy/dogrudan/a177_kubbeli_toprak_firin.glb` | 9.960 → 9.960 | 2,5 → 0,5 | Doğu mutfak avlusu, kubbeli fırın | Statik dekor; fırın ağzı A181 olarak duruyor |
| `assets/meshy/dogrudan/a181_tandir.glb` | 20.387 → 20.387 | 1,6 → 0,7 | Fırın, fırın ağzı | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a186_saman_kovan.glb` | 9.991 → 9.991 | 1,9 → 0,6 | Güney kenar, kovan | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a190_tahil_cuvali.glb` | 477.522 → 8.000 | 16,0 → 0,5 | Değirmen, çuval yığını | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a202_tinaz_saman_yigini.glb` | 33.259 → 33.259 | 13,0 → 2,5 | Batı tarla, saman yığını | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a205_degirmen_tasi.glb` | 158.967 → 15.000 | 5,7 → 0,6 | Güney kenar, değirmen taşı | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a209_el_degirmeni.glb` | 874.267 → 15.000 | 36,4 → 1,1 | Güney kenar, el değirmeni | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a211_orak.glb` | 105.180 → 8.000 | 10,9 → 0,8 | Elde orak | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a220_karasaban.glb` | 86.388 → 15.000 | 3,7 → 0,7 | Batı tarla, karasaban | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a227_bakir_kazan.glb` | 617.352 → 15.000 | 27,2 → 1,1 | Doğu mutfak avlusu, bakır kazan | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a228_sacayak_ustunde_kazan.glb` | 6.296 → 6.296 | 9,1 → 0,5 | Doğu, sacayak kazan | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/a236_kilim_dokuma_tezgahi.glb` | 583.794 → 15.000 | 84,8 → 1,3 | Atölye, dokuma tezgâhı | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/a241_comlek_takimi.glb` | 680.172 → 14.999 | 27,4 → 0,9 | Doğu mutfak avlusu, çömlek takımı | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o00_odun_yigini_kutuk.glb` | 30.415 → 30.415 | 24,6 → 2,2 | Güney kenar, odun yığını | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o01_hasir_sepet.glb` | 229.763 → 7.999 | 30,1 → 1,0 | Elde büyük sepet | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/o05_demir_mangal_nobet_ocagi.glb` | 4.254 → 4.254 | 9,0 → 0,5 | Doğu, mangal | Meydan ocağının üstüne konmadı |
| `assets/meshy/dogrudan/o07_toprak_comlek.glb` | 761.834 → 7.999 | 33,9 → 0,4 | Doğu mutfak avlusu, çömlek | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o14_yumurta_sepeti.glb` | 28.037 → 28.037 | 17,7 → 1,7 | Güney kenar, yumurta sepeti | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o17_sivri_kazik_cit.glb` | 769.860 → 25.000 | 33,6 → 1,6 | Batı kenar, tek sivri çit | Sur kazığının yerine geçmez; tek parça |
| `assets/meshy/dogrudan/o18_tas_yigini.glb` | 5.220 → 5.220 | 16,2 → 0,6 | Güney kenar, taş yığını | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o19_asma_toprak_kandil.glb` | 316.518 → 8.000 | 18,5 → 0,7 | Güney kenar, asma kandil | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o20_tas_oturak.glb` | 396.660 → 15.000 | 46,7 → 0,9 | Güney kenar, taş oturak | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o21_tas_kuyu_cikrikli.glb` | 809.733 → 24.999 | 34,0 → 1,5 | Köy meydanı, kuyu | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/o23_rafli_odun_istifi.glb` | 2.954 → 2.954 | 3,0 → 0,3 | Güney kenar, raflı odun | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o25_ahsap_palisat_kapisi.glb` | 1.599.643 → 39.999 | 59,1 → 2,5 | — | Kapı zaten kapi.glb; ikinci kanat yok |
| `assets/meshy/dogrudan/o26_toprak_damli_kerpic_ev.glb` | 7.890 → 7.890 | 8,4 → 0,6 | Kuzey kenar, toprak damlı ev | Statik dekor; ev.glb duruyor |
| `assets/meshy/dogrudan/o30_ahsap_yalak.glb` | 179.416 → 15.000 | 12,8 → 1,0 | Batı, yalak | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o32_toprak_kandil.glb` | 364.307 → 7.999 | 15,1 → 0,5 | Güney kenar, kandil | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o37_ahsap_palisat_kazik_sur.glb` | 2.990 → 2.990 | 9,5 → 0,7 | Sur 1 ve ana menü, kazık çit | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/o48_toprak_testi.glb` | 446.726 → 7.999 | 21,6 → 0,7 | Doğu mutfak avlusu, testi | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o49_kervan_konak_yeri_ortu_yuk.glb` | 951.487 → 40.000 | 42,6 → 2,3 | Doğu, kapı yolunun uzağı, kervan konağı | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o51_sapli_sepet.glb` | 9.969 → 9.969 | 9,2 → 0,8 | Elde sepet | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/o58_saman_arabasi.glb` | 24.866 → 24.866 | 4,1 → 0,9 | Kapı sahnesi, araba | Dunya3B.nesne; doku korundu, taban y=0 |
| `assets/meshy/dogrudan/o64_orme_cubuk_cit_ceper.glb` | 307.734 → 25.000 | 10,7 → 1,1 | Kuzeybatı kenar, tek örgü çit | Surun yerine geçmez; tek parça |
| `assets/meshy/dogrudan/o65_renkli_carsi_tezgahi.glb` | 184.169 → 25.000 | 8,3 → 1,4 | — | Pazar yuvası dolu; ikinci tezgâh yok |
| `assets/meshy/dogrudan/o72_tas_ahsap_kule.glb` | 320.119 → 40.000 | 11,4 → 1,7 | Kuzeydoğu dışı, kule | Statik dekor; mevcut kule duruyor |
| `assets/meshy/dogrudan/o76_su_degirmeni.glb` | 1.927.250 → 38.000 | 94,1 → 2,4 | Doğu, dere yanı, su değirmeni | Statik dekor; degirmen.glb duruyor |
| `assets/meshy/dogrudan/o79_debbaghane_deri_gerdirme.glb` | 549.278 → 24.999 | 55,1 → 1,2 | Doğu, debbaghane | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o81_yurume_yollu_ahsap_palisat.glb` | 650.912 → 40.000 | 58,4 → 1,8 | — | Sur 2 zaten sur_2_palisat.glb |
| `assets/meshy/dogrudan/o84_kapakli_bakir_tencere.glb` | 374.832 → 7.999 | 15,6 → 0,6 | Doğu mutfak avlusu, tencere | Statik dekor, tek kopya, ızgara dışı |
| `assets/meshy/dogrudan/o90_tas_sur_duvari.glb` | 51.117 → 24.999 | 3,9 → 1,4 | — | Sur 3 zaten sur_3_tas.glb |
| `assets/meshy/dogrudan/o92_tas_cerceveli_demir_parmaklikli_kapi.glb` | 75.028 → 25.000 | 3,8 → 1,1 | — | Kapı zaten kapi.glb; ikinci kanat yok |
| `assets/meshy/ekstra/Meshy_AI_시장_한가운데_서_있는_듯한_활기찬_중세_상인_여성의_전신_3D_모델_20251018_animated_mixamo_All_animation.glb` | 88.592 → 29.972 | 9,2 → 2,1 | — | Sahnede aynı adlı yer tutucu yok |
