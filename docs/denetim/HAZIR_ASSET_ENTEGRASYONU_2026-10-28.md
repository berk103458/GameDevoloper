# Hazır asset entegrasyonu — 28 Ekim 2026 (Kalfa)

**HAE-01 … HAE-05 tamamlandı [x] (Kalfa); açık [/] yok.** Başlangıç festive e63875d, fetch/pull --ff-only eksiksiz yapıldı. project.godot ve assets/model altındaki MCP import değişiklikleri kullanıcı talimatıyla geri alındı. Yeni indirme, oyun mekaniği/diyalog/denge, UI/ikon/portre/harita/font değişikliği yok. Kapı konuşma sahnesi 3D kaldı. Mevcut öküz dosyası korundu.

## Yayınlanan gruplar ve İHT bağlantıları

- **HAE-01 / df552f11:** İHT-0372, 0397 — MegaKit yapı kabuğu ve yağmur saçağı. Konut 3×3×3 m; baca tepe noktası 3,20 m. Izgara/rota aynı. Özgül üretim yapısı yerine genel kabuk kullanılan yerler kısmi kabul edilir.
- **HAE-02 / 452bb671:** İHT-0357, 0431, 0444, 0445, 0452, 0453, 0524 — çocuk 1,15 m, adsız köy demircisi 1,80 m. UAL A01 idle/yürüme/konuşma, A02 hasat; yalnız eksik çekiç döngüsü A03 Hammering. Skin bind adları ve rest dönüşümleri birlikte uyarlandı. Meslek değişiminde görünüm aynı konumda yenilenir; kayıt/RNG değişmez. Adlı ustalar ve diğer mevcut CHR modelleri korunur. Bu bağlantı 44 Meshy karakterin yeniden retarget edildiği anlamına gelmez; özgül usta varyantları/orak aleti kısmi kalır.
- **HAE-03 / 562519f8:** İHT-0342, 0350, 0380, 0383, 0384, 0388, 0403, 0413, 0414 — örs/çekiç, oduncuda balta, elde kazma/odun, odun dekoru, oda masası/yatağı; sürüde koyun, satın alınmış inek, kapı yanında köpek. Mevcut sayılar/rota/üretim aynı. Koyun/inek statik; köpek Kangal değildir. Demir çubuğu dekoru İHT-0439 ham blok teslimi sayılmadı.
- **HAE-04 / b373744f:** İHT-0468, 0469, 0470, 0471, 0479, 0481, 0485 — mevcut Ses autoload anahtarları korunarak hazır kaynaklara yönlendirildi. Gerçek yer değiştirmede adım, mevcut dov duruşunda örs sesi; ortak havuzda sıklık sınırı. Dere 8 sn, 22.050 Hz mono Vorbis, 57.218 bayt, 1 sn çapraz birleşim; runtime OGG döngüsü. Kaynak WAV korundu. Lisans kaydında **ogg'a çevrildi (Kalfa)** bulunur.
- **HAE-05 / e6414923:** İHT-0150, 0157 — meşale/ocak alevi ve baca dumanı, mevcut izinli Kenney/Kronbits dokularıyla GPUParticles3D. Emitör başına azami 32, gölge yok; iş aktifliği/LOD/düşük grafik profili korunur. Yağmur/kar/özel kıvılcım/ışık maskesi bu grupta tamamlandı sayılmaz.

Toplam **27 farklı İHT'ye bağlantı**. Her satır aktif ana listede “bağlandı (Kalfa)” ile işaretlendi. Kısmi bağlantı tam ihtiyaç kapanışı değildir; kaynak teslimlerinin önceki atıf/lisans notları korunur.

## Yerel referans onayı ve lisans

Başlangıçta repodaki UAL kitaplıklarında referans Skeleton3D/rest verisi bulunmadı. Ahmet bu konuşmada önceden indirilmiş yerel referansın kullanımına açıkça onay verdi. `data/animasyon/ual_referans.json` yalnız A01/A02/A03 kemik/rest matrisleri ve kaynak SHA-256 içerir; ham modeller eklenmedi. CC0 kaynak lisansları ve yazar kayıtları [atıf belgesinde](../credits/HAZIR_ASSET_ATIFLARI.md), OGG/ref türevleri [dosya teslim kaydında](../asset_envanteri/UCRETSIZ_ASSET_TESLIM_2026-10-24.json).

## Doğrulama

16 ayrı hedefli test geçti; log adları/SHA-256 [makine kaydında](HAZIR_ASSET_ENTEGRASYONU_2026-10-28.json). Son toplu kontrol yalnız 5 yeni entegrasyon testi, atölye LOD/aktiflik ve köy ortamıydı; ardından Ses birim testi geçti. Diğer kapsam kontrolleri köy hareketi, CHR kapı/sıra sonucu, karakter hava, muhafız odası, zanaat, oduncu ve celep akışıdır. Tam sanity çalıştırılmadı.

İlk normal editor importu Cursor'ın yerel karşılaştırma önizlemesindeki `look_at`/tree hatasını tetikledi. Önizleme dosyasına dokunulmadı; kurtarma kipinde araçlar kapalı import hatasız, gerçek oyun testleri normal runtime kipinde hatasız koştu. Yeni karakter testindeki beden/sepet ölçümü ayrıldı; bütün Skin bind adları, beş klip, kök yatay hareketinin rota eklememesi ve rol değişiminde kayıt/RNG/konum korunması sınandı.

Kullanıcının görünür pencere açmama talimatından önce geçici 3D renderlarda ölçek/zemin, gece VFX ve idle/yürüme/çekiç pozları kontrol edildi. Talimattan sonra yalnız headless test çalıştırıldı. Render PNG'leri TEMP/kalfa_entegrasyon_20261028 altında, repoya eklenmedi.

## Kalanlar ve çalışma kopyası

Özgül fırın modeli/ağzı, koç/beygir, özgül usta varyantları, orak ve diğer kaynaklarda zaten kayıtlı eksikler açık. Eksik fırın/hayvan/yapı kutuları görünür isim etiketi taşır. Statik hayvanlar iskeletli/animasyonlu teslim sayılmaz. İki aktif envanterde kısmi kapsam ve yer tutucu notları korunur.

**project.godot temiz; MCP autoload/editor eklentisi eklenmedi.** Kullanıcı talimatındaki .import/geçici dosyalar hiçbir commite alınmadı. İlgisiz untracked dosyalar korunur. İki ds ayna yolu bulunmadığı için önceki kullanıcı istisnasıyla eşitleme atlandı; eşitlendi iddiası yok. Kota son ölçüm: kısa dönem %47, haftalık %92 kaldı.
