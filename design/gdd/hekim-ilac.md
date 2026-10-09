# KRI-03 — Hekim yetkinliği ve ilaç üretimi

9 Ekim 2026 · Codex uygulaması; Claude Code incelemesi/kapanışı bekleniyor. ROADMAP `[/]` korunur.

## Hekim ve tek ölüm yolu

`HekimIlac.etkin(y, bina_id=-1)` hazır, kan davası engeli bulunmayan mevcut Şifahanelerde gerçekten atanmış ve `Sifahane.hekim_calismaya_uygun` koşullarını sağlayan yetkin hekimi arar. Köy isyanında hizmet durur. Sağlıksız, aç, ağır yaralı, kış hastası, karantinada, zindanda, dış görevde veya kaza nedeniyle çalışamayan hekim sayılmaz. Günlük tedavi kontenjanı dolmuş olsa bile çalışabilir hekimin koruyucu yetkinliği sürer.

- **Kimlik:** Gerçek `adli_id` eşlemesi `chr_008` / `chr_003`. İsim, persona veya gizli bayraktan tahmin yapılmaz. `adli_id` boş legacy/genel hekimlerde cerrah/otacı zanaatı ve mevcut `usta_mi()` kullanılır (beceri ≥7, açık usta bayrağı veya kazanılmış ustalık). Başka kimliği bilinen CHR için fallback yapılmaz.
- **Etki:** KRI-01 `SaglikYoneticisi.saglik_kaybi()` içindeki hastalık hasarı tek **×0,20** çarpanla azaltılır. Tam sayı sağlık köylü lehine aşağı yuvarlanır: veba 12→2, humma 8→1. Birden fazla hekim çarpanı üst üste koymaz; köydeki tüm bulaşıcı hastalara aynı hizmet uygulanır, karantinadaki hastada da hasar azalır.
- **Ölüm:** Aynı sağlık değeri ve mevcut `_saglik_ve_moral` ölüm taraması kullanılır. “Ölüm %80↓” ayrı ölüm zarı yerine hastalık hasarının %80 azaltılmasıyla temsil edilir; her başlangıç sağlık değeri için istatistiksel ölüm oranı garantisi değildir. Açlık, donma, zehir, kaza ve kış hastalığı hasarı değişmez. Diriltme ve ikinci ölüm sistemi yoktur.
- **RNG:** Yetkinlik, çarpan, reçete ve tedavi yeni zar çekmez. Bulaşma mevcut RNG yolunu korur. İlaç üretimi normal verim/çalışma/eğitim akışını kullanır; hekim uzmanlığıyla uyumlu olduğundan uyumsuz iş alet zarı açılmaz.

## Tek reçete ve ambar

`HekimIlac.receteler()` mevcut Şifahane kataloğuna iki reçete verir: `bakim` (girdi/çıktı yok, yeni binalarda varsayılan) ve `ilac` (çalışan başına **1 afyon + 1 su → temel 1 ilaç**). Son ürün miktarı mevcut beceri, meslek, bina seviyesi ve kesir devri formülünden gelir; her hekim kesin tek ürün üretmek zorunda değildir. Reçete mevcut `recete_sec()` ve Şifahane bilgi düğmeleriyle seçilir. Legacy boş reçete otomatik açılmaz.

Üretim `_uret`/`_ambara` içindedir; yalnız uygun cerrah/otacı üretir. Eksik girdide mevcut atomik `harca` ile hiçbir girdi tüketilmez. İlaç stok/ambar kapasitesi ve kapasite düşüşü taşma sırası mevcut kataloğa minimal eklenir. Yeni üretim/ambar/yatak türü yoktur.

**KRI-15 bağlantısı:** Ot toplama daha sonra tek `HekimIlac.receteler()` girdisini ot kaynağına genişletebilir; mevcut `ilac` kaynak/reçete kimliği, üretim ve tedavi API'leri korunur. Bu paket ot kaynağı veya toplama mekaniği eklemez.

## Tedavi ve görünür bilgi

Bulaşıcı hastalık tedavisi stokta ilaç varsa **1 ilaç**, **+25 sağlık** (tavan100) kullanır. İlaç yoksa eski **2 erzak**, **+10 sağlık** tedavisi sürer. Her iki yol aynı enfeksiyonu iyileştirir ve yanık/kış/salgın ortak `SifahaneKontenjani` kotasından bir yer tüketir. İlaç tek başına kota açmaz; başarısız bedel/kota ve tekrar çağrı ek tüketim yapmaz. KRI-02 izolasyonundaki hastaya bu tedavi uygulanmaz; karantina iyileştirme değildir. Yanık ve kış tedavisi mevcut bedellerini korur.

Köylü kartı ve Şifahane bilgisinde etkin hekim, hastalık sağlık kaybı azalması, ilaç stoğu ve reçete/tedavi bedeli bulunur. Şifahane bilgisi yalnız seçilen binanın hekiminin etkinliğini gösterir, kart köy hizmetini gösterir. CHR kimliği, gerçek ad, sır veya gizli kuluçka teşhisi üretilmez. Gece raporunda gerçek ilaç tüketimi açıklanır.

İlaç ikonunun tek yer tutucu noktası `GezginStokIkonu.ikon`: mevcut düz renk `ColorRect`. Eksik ikon `docs/EKSIK_ASSET_ENVANTERI.md` KRI03-ILAC satırında; asset üretimi/indirme yapılmadı.

## Kayıt ve doğrulama

Yeni köylü/yönetim kaydı veya kayıt sürümü yoktur. Mevcut stok ve bina reçetesi ilaç bilgisini saklar; legacy stokta ilaç eksikse0, bozuk miktar mevcut kaynak yükleyicisiyle güvenli0 olur. Hekim etkisi yüklenen gerçek atamadan yeniden türetilir; kalıcı gizli bonus bayrağı yoktur. Hastalık/karantina/ortak kontenjan optional kayıtları korunur.

`tests/unit/kvr/hekim_ilac_test.gd`: gerçek CHR kabulü/ataması, legacy ustalık, çalışamayan hekim, tek hasar makbuzu/ölüm yolu, üretim, ortak kota, ilaç/erzak tedavisi, yetersiz kaynak, gizlilik, kapasite düşüşü ve JSON gece/RNG eşitliği.

`tests/oto/hekim_ilac_kontrol.tscn`: gerçek CHR kabulü → kart ataması → Şifahane reçete düğmesi → gece üretim/tedavi/kritik hasta koruması → sabah → GuvenliKayit → karttan hekim karantinası → sonraki gece hizmetin durması ve mevcut ölüm yolu. Sahne `tools/sanity_check.py` listesinde. İlgili headless sonuçları ve son durum `codex.md/Codex.md`; `.import` yasağı nedeniyle editor import ve tam sanity çalıştırılmadı.
