# YAP-05 kabul listesi — Kalfa

- [x] K1 oda katalogda; yoksa başlatma0.
- [x] Odanın gerçek inşa/bilgi/işçi/etiket erişimi çalışır.
- [x] Süre ve sonuç data/usta_defterleri.json içindedir; süre0 hatadır.
- [x] Sonuç mevcut tek hedef sistemde tek çarpandır.
- [x] Aynı anda tek etkin çözümleme; ikinci defter kuyrukta.
- [x] İkinci aynı gün başlatılamaz.
- [x] Bedel tek kaynak/kamu; başlatmada tek tahsilat, tekrar tahsilat0.
- [x] Kış çarpanı mevcut mevsim kaydından; ayrı kış sabiti yok.
- [x] İşçi ölünce durur, defter ve ilerleme korunur.
- [x] Oda yıkılınca durur; ilerleme silinmez.
- [x] İşçi görevden alınınca durur, dönünce aynı ilerlemeden sürer.
- [x] Kayıt yüklemesi aynı iş/kuyruk/ilerleme/etkiyi korur, ikinci ödül üretmez.
- [x] Süre dolunca defter çözüldü, sonuç bir kez uygulanır.
- [x] Bitiş bildirimi tek satır; ikinci sahne yok.
- [x] Mevcut UI gerçek oyuncu yoluyla başlat/durum/kuyruk gösterir.
- [x] YAP05-ODA asset envanterinde; yeni asset üretilmez/indirilmez.
- [ ] Hedefli testler/import/parse, raporlar ve commit/push/masaüstü FF tamam.

Madde tamamlanmadan[x] yapılmaz. kota görünmüyor.

Veri dilimi kanıtı: K1 oda katalog kaydı ve tek iş yuvası, süre/tek sonuç/bedel verisi ve bozuk veri doğrulaması hedefli testte geçti. Oda kurulabilir=false; gerçek iş/UI/kayıt tamamlanınca açılacak. Yukarıdaki tam kabul kutuları henüz işaretlenmedi.

İş/gece dilimi: tek aktif iş/kuyruk, tek kamu bedeli, yetişkin/sağlık/atama, gerçek ölüm/yıkım/dönüş, gece başı çalışma fotoğrafı, mevsim, JSON ve mevcut üretim etkisi9 hedefle geçti. Oda hâlâ kurulabilir=false. Gerçek oyuncu UI/inşa erişimi ve tam son kabul bekleniyor.

UI dilimi: oda açıldı; gerçek oyuncu inşa/atama/tek bedel/kuyruk/yıkım/yeniden inşa/etkin ve sıradaki işi yeniden bağlama geçti. Önceki kurulabilir=false açıklaması tarihsel dilimdir. Commitli önbelleksiz kabul beklenir; madde henüz kapanmadı. kota görünmüyor.
