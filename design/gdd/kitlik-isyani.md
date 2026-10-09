# KRI-06 — Kıtlık isyanı ve ambar kapısı

Codex uygulaması; Claude Code incelemesi ve ROADMAP kapanışı bekleniyor.

## Tetik ve mevcut isyan

Gece tüketimi, sağlık, cenaze yası, bordro ve asayiş çözüldükten sonra mevcut `KoyYonetimi._isyan()` içinde `KitlikIsyani.gece()` çağrılır. Yaşayan nüfus varken gece sonunda erzak (`gida`) sıfırsa sayaç ilerler. İkinci ardışık sıfır gecede ambar kapısı kırılır. Tüketim/açlık dağıtımı (`TuketimDengesi`, `k.ac`) değiştirilmez; bu sayaç kişi başına açlık sayacı değildir.

Yeni bir isyan sistemi yoktur: `isyan_kalan` yalnız isyan yoksa mevcut `a.isyan_gun` değerine çekilir. Zaten süren isyanın süresi uzatılmaz. Tetik gecesinde eski isyanın firar/erzak çalma zarı ayrıca çalışmaz. Sonraki gecelerde mevcut huzur eşiği, üretim durması, firar ve isyan sonu kuralları uygulanır. UZM-06 kişisel iş reddi ve sabotaj mantığı korunur.

Her kıtlık serisinde tek tetik vardır. Gerçek `Kaynaklar.ekle("gida", adet)` ile pozitif miktar ambara girince sayaç ve tetik kilidi anında sıfırlanır. Kapasite doluysa sıfır miktarlı ekleme sıfırlama yapmaz. Gece kalan erzak pozitifse de seri sıfırlanır. Yeni gelen erzak aynı gece tüketilirse o gece yeni serinin ilk sıfır gecesidir. Onarım seriyi sıfırlamaz, erzak gelişinin kapıyı onarma etkisi yoktur. Boş nüfus veya sona ermiş oyunda kıtlık baskını üretilmez.

## Deterministik yağma ve etkiler

Yağma, `Kaynaklar.TURLER` sabit sırasındaki yiyecek dışı stoktan yapılır. Erzak, buğday, un, su ve hayvan yemi saman yağmalanmaz. Her tür için `floor(stok × 0.20 × (1 − ambar_korumasi/100))`, tür başına en çok 5, toplam en çok 20 birim kayıp uygulanır. Kesirler birikmez; küçük stokta sıfır kayıp geçerlidir. Eksik stok negatif olmaz. Kamu/kişisel akçe ve kişisel envanter yağmalanmaz.

Tek Güvenlik kaynağı `KervanKorumasi.guvenlik(y)` kullanılır. Etkin muhafızların gece asayiş payı ve HAR-15 `SavunmaGuvenligi` katkısı zaten bu değerdedir; kişi sayısı tekrar eklenmez. Kırık kapı ambarın yerel korumasını 20 puan azaltır (`max(0, Güvenlik − 20)`); köyün genel Güvenlik değerini ayrıca düşürmez. Tetik gecesindeki yağma kırılmış kapının korumasıyla hesaplanır.

Yaşayan her köylünün morali bir kez 8 düşer (0 sınırı), dolayısıyla mevcut ortalama huzur düşer. Cenaze yasının ayrı moral makbuzu değiştirilmez; yasın geri iadesi yalnız kendi kesintisini iade eder. Kıtlık fonksiyonu, bilgi okuma ve onarım RNG çekmez. Sonraki gecelerde mevcut oyun sistemleri kendi RNG sözleşmelerini korur.

## Kapasite ve onarım

Hasar, ortak ambar kapısına aittir; yeni bina hasar sistemi kurulmaz. Ambar binası bulunmasa da taban ortak ambarın kapısı vardır. Sağlam kapasite mevcut taban + hazır depo katkılarıyla hesaplanır; kırık kapıda bunun aşağı yuvarlanmış %80'i kullanılır. İnşaat, yıkım, seviye ve yükleme sırasında aynı adaptör çalışır; bu yollar onarım yerine geçmez.

**Denge kararı:** kapasite düşüşü mevcut EKO-12 stok üst sınırını korur. Ambar doluysa kapasiteyi aşan stok mevcut taşma sırasıyla ziyan olabilir. Bu kayıp, 20 birim yağma tavanından ayrı bir kapasite kaybıdır; `kapasite_ziyani` makbuzunda ve aynı gece ayrı ambar ziyan satırında görünür, sonraki gece tekrar raporlanmaz. Yağma sonrası kalan stok yeni kapasiteye sığıyorsa ek ziyan yoktur. Onarım önceki kayıpları geri üretmez.

Onarım atomik olarak 4 taş + 6 kereste tüketir; erzak veya akçe gerekmez. Yetersiz malzeme, sağlam kapı ve bitmiş oyun işlemi reddeder. İkinci tıklama yeniden bedel kesmez. Kapasite ve yerel koruma hemen normale döner; kesintisiz kıtlığın tetik kilidi korunur. UI onarımı açık rapor/karar tamamlanana kadar kilitlidir; bayat sinyal de bedel kesemez. Böylece gece raporu/bilançosu gündüz işlemiyle değişmez. HUD üzerinden onarım açık bina bilgisini de yeniler.

## Oyuncuya bilgi ve kayıt

Mevcut gece raporunda kırılan kapı, yağma tür/miktarları, moral, koruma ve kapasite kaybı görünür. `rapor.kitlik` gece sayacı/hasar anlık durumudur; olayın `kitlik_isyani` alanı yağma/taşma makbuzudur. Kapasite kaybı `rapor.ziyan.tasma` alanına da eklenerek EKO-15 bilançosunda taşma olarak mutabık kalır; yağma mevcut diğer net stok kaybında ve olay makbuzunda görünür. Mevcut HUD ambar ipucu sayaç ve kapı durumunu gösterir; hasarda aynı çubuğun yanında onarım düğmesi açılır. Mevcut ambar bina bilgi kartı aynı ortak kapının durumu ve onarımını gösterir. Yeni panel/ambar envanteri kurulmaz; CSV değişmez.

`koy_yonetimi.kitlik_isyani` optional kayıt alanıdır: `kitlik_gece_sayisi`, `tetiklendi`, `kapi_kirik`, `son_gece`. Eski kayıtta varsayılan sağlam kapı/sıfır geçmiş; bozuk tip, kesir, NaN/Inf ve gelecek gece doğrulanır. `KAYIT_SURUMU` değişmez. JSON ve `GuvenliKayit` dönüşü aynı sonraki geceyi üretir.

KRI-14 bağlantısı: `y.kitlik_tetiklendi(rapor: Dictionary)` yalnız gerçek baskında bir kez yayımlanır. Dinleyici nöbetçiyi ambara yönlendirebilir; gece hesabını/yağmayı yeniden çağırmaz. `KitlikIsyani.durum(y).kitlik_gece_sayisi` salt okunur sayaç yüzeyidir. Bu pakette KRI-14 hareketi uygulanmaz.

Asset gerekmedi. Kırık kapı mevcut ambar/HUD metniyle temsil edilir; model, ses, görsel veya kutu mesh üretilmedi.

## Doğrulama

`tests/unit/kvr/kitlik_isyani_test.gd`: sayaç/seri/aynı gece, tavanlar, yiyecek dışı stok, tek Güvenlik, mevcut isyan, onarım, erzak gelişinde sıfırlama, optional/legacy, dolu ambar taşması ve RNG.

`tests/oto/kitlik_isyani_kontrol.tscn`: gerçek iki gece düğmesi ve sabah geçişleri, `k.ac`, rapor, HUD/bina kartı, onarım ve güvenli kayıt/restore. Sahne sanity listesinde; birim testi otomatik keşfedilir.
