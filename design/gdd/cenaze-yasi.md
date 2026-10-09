# KRI-05 — Toplu mezar ve cenaze töreni

**Durum:** Codex uygulaması; Claude Code incelemesi/kapanışı bekleniyor. ROADMAP `[/]` korunur.

Tek ölüm yolu `KoyYonetimi._saglik_ve_moral`, tek ölü listesi `rapor.olenler` olarak kalır. Hastalık, açlık, MEV-02 donma ve diğer sağlık kayıpları aynı gece cenazesi açar. Yeni `CenazeYasi` ölüm öncesi kişi referanslarını yalnız salgın bağlamını korumak için kullanır; ölüleri ikinci kez silmez, yeni ölüm zarı çekmez. Enfeksiyon taşıyan bir kayıp varsa cenaze salgın bağlamında değerlendirilir; hastalık adı/gizli bayrak/fail rapora taşınmaz.

## Yas ve zaman

- Ölüm sayısı N için geçici kişi başı moral kesintisi `min(12, 3×N)`; moral 0–100 sınırındadır. Bir kesinti vardır, her gece yeniden kayıp eklenmez.
- D gecesinde ölüm → D+1 ve D+2 gündüzleri yas → D+2 gecesinin sağlık/moral aşamasında iade → D+3 sabahı normal moral. İlk rapor iki, sonraki rapor bir gün gösterir.
- Kişi başına **gerçekten kesilen** miktar optional kayıtta tutulur. Sonraki sağlık/moral aşamasından önce bu miktar kaldırılır, normal etkiler uygulanır, süre kaldıysa yeniden tek kesinti konur. Moral 2 olan kişiden 12 değil2 kesilir/iade edilir. Köyden çıkan/ölen kişiye ve sonradan gelen kişiye hayalet iade yoktur.
- Yas sürerken yeni ölüm süreyi son kayıptan iki güne yeniler; ceza eski ve yeni kaybın maksimumudur, toplamları değildir. Yeni tören önceki büyük yası silemez. Aralıksız ölümde yasın sürmesi bilinçli denge kararıdır.

## Mevcut gece raporunda karar

| Seçim | Bedel | Moral | İş/sağlık |
|---|---|---|---|
| Toplu mezar | Ücretsiz | Tam yeni yas | Hızlı defin, ek iş kaybı yok. Salgın bağlamında `KuyuKirliligi.kirlet()` tek kuyunun mevcut üç gecelik riskini yeniler. Normal kıtlık/donma cenazesi kuyu kirletmez. |
| Cenaze töreni | `min(6,2×N)` erzak ve aynı miktar **kamu** akçesi | Yeni yas yukarı yuvarlanarak yarıya iner; etkin önceki yas tabanı korunur | En fazla6 uygun yetişkinin sonraki gecede gerçek üretimi×0,9; bütün köy bir gün durmaz, ev/iş/nöbet atamaları korunur. Girdi tüketimi mevcut reçete yolunda kalır. |

Sabah düğmesi karar verilene kadar bekler. Yetersiz kaynakta tören düğmesi neden açıklamasıyla kapalıdır; ücretsiz mezar açıktır. Karar modelde de gün, bekleyen ölüm gecesi, oturum sonu, seçenek ve kaynakları doğrular. Bayat/çift tıklama ikinci ücret veya iade üretmez. Mevcut moral/akçe etiketleri, yas olay satırı, HUD, mezar ve devam sinyalindeki rapor/bilanço karar sonrası güncellenir; kişisel kasa kullanılmaz. Bilanço tören ücretini `cenaze` makbuzunda, mutabakat için mevcut `diger_net` içinde gösterir.

Karar bekleyen kayıt köye geri girildiğinde mevcut kartta yeniden açılır; UI'nin gece düğmesi de kararı atlayamaz. Doğrudan yönetim gecesi kullanan otomatik oyuncu için sonraki gece başında ücretsiz mezar varsayılanı uygulanır. Biten oturumda karar/bedel alınmaz. Cenaze ayrı rastgele olay kuyruğu oluşturmaz; normal gece olayı sabah düğmesinden sonra mevcut akışta gösterilir.

## KRI-01/02/04 ile tek bulaşma yolu

Tören katılımcıları kimliğe göre ilk en fazla6 yaşayan, yetişkin, temas edebilen kişidir; gizli hastalığa göre seçilmez. Salgın bağlamında, yalnız törenin ertesi gece sağlık aşamasında bu kişiler ortak temas grubu sayılır. **Yaşayan** veba/humma kaynağı mevcut `SaglikYoneticisi.gece` döngüsünde risk üretir. Karantina/zindan/dış görev kapısı hem kaynak hem hedefte tekrar doğrulanır; sonradan karantinaya alınan katılımcı temas etmez.

Mevcut kaynak başına3 temas, gecede toplam2 yeni vaka, başlangıç fotoğrafı/zincirleme yasağı, veba%30/humma%20 ve aynı yönetim RNG'si korunur. Tören vakaları su kaynaklı vakalarla aynı iki vaka kotasını paylaşır. Tifo kişiler arasında bulaşmaz. Ölü kaynak hastalık saçmaz; yaşayan bulaşıcı kaynak/uygun hedef yoksa tören yeni RNG çekmez. Tören mevcut kuyu kirini temizlemez; kireçleme KRI-04'ün hizmetidir. Yeni ceset enfeksiyonu/RNG/tedavi sistemi yoktur.

## Görsel ve kayıt

`src/koy/gorsel/cenaze_mezari.gd` tek değişim noktasıdır: mevcut meydanda düz kahverengi `BoxMesh` ve kısa etiket. Geçici yas bitince kaldırılır; ızgara/yapı/rota verisi değişmez. Yeni mezarlık binası veya ateş oluşturulmaz; ANI-07'nin mevcut ocak, ısınma, boşta halk ve muhafız rutinleri korunur. Gerçek mezar işareti ihtiyacı `docs/EKSIK_ASSET_ENVANTERI.md` G tablosunda **KRI05-MEZAR**; asset üretimi/indirme yok.

`KoyYonetimi.kaydet().cenaze_yasi` optional sözlüğü başlangıç/bitiş/ölüm gecesi, sayı, ceza/eski ceza, salgın bağlamı, seçim, tek gecelik katılımcılar ve gerçek moral makbuzlarını tutar. Sonlu tam sayılar, iki günlük süre, ceza denklemi, geçerli karar, benzersiz en fazla6 kimlik ve tavanlı makbuz doğrulanır. Legacy eksik alan boş yastır; bozuk/gelecek/süresi geçmiş kayıt etkisizdir, kaynak/RNG üretmez. `KAYIT_SURUMU`, Oturum ve GuvenliKayit API'leri değişmez. JSON ambar kesirlerinin mevcut kayan nokta yuvarlaması dışında gece/karar/vaka/RNG devamı aynıdır.

## Doğrulama

`tests/unit/kvr/cenaze_yasi_test.gd`: gerçek ölüm nedenleri, tavan/yenileme, iki gün/iade/alt sınır/yeni kişi, bedel/atomik ret/çift seçim, ortak temas-su kotası/kaynak kapısı/üç temas/tifo/ölü kaynak, gerçek üretim ve optional/legacy/bozuk JSON.

`tests/oto/cenaze_yasi_kontrol.tscn`: gerçek gece düğmesiyle salgın ve donma ölümü → aynı raporun iki seçeneği → sabah kapısı/çift tıklama → iki gün moral → gerçek GuvenliKayit; ayrıca pending kayıtla köye giriş, yetersiz tören, ücretsiz salgın mezarı, güncellenmiş rapor/olay/bilanço ve tek kutu görsel. Sahne `tools/sanity_check.py` listesinde, birim otomatik keşiftedir.

İlgili regresyon ve son kanıt: `codex.md/Codex.md`, `work/kri05/final_results.json`. Kullanıcının `.import` yasağı nedeniyle editor import çalıştırılmaz; mevcut önbellekle headless parse/test ve `.import` SHA-256 denetimi yapılır.
