# TEK-18 — bozuk ayar dosyası menüyü kilitlemez (Kalfa)

11 Ekim 2026. Sahiplik 63b1bbe. Oyun src/data kaynakları değişmedi; mevcut Ayarlar.yukle, GuvenliMetin, Katalog ve Ana.ana_menu davranışı testle korunur. Asset gerekmedi.

Negatif fikstür yalnız `user://tek18_<pid>_<ticks>.cfg` dosyasına bozuk bölüm başlığı yazar. Kontrollü Ana kurulumunda gerçek Ayarlar.yukle çağrılır; tüm değerlerin Ayarlar.VARSAYILAN'a eşit olduğu, gerçek MenuEkrani'nın açık ve en az bir düğmesinin görünür/etkin olduğu, gerçek katalogun hatasız yüklendiği doğrulanır. Oyuncunun ayarlar.cfg veya kayıt dosyasına yazılmaz. Test dosyası çıkışta kaldırılır.

Beklenen hata enjeksiyonu ayrı Godot çocuk sürecindedir. Python kontrolü exit 0, gerçek menü başarı işareti ve tam iki hata kaydını birlikte şart koşar: pid adlı fikstürün ConfigFile EOF hatası ve mevcut “Ayar dosyası okunamadı; varsayılanlar kullanılıyor” kaydı. Ek hata, SCRIPT ERROR, yükleme hatası veya KALDI varsa çocuk çıktısı aynen gösterilir ve kontrol exit 1 verir. Engine hata yazımı kapatılmaz, genel sanity ERROR regex'i/istisnaları değiştirilmez. Tam log `work/tek18-target/expected-config-errors.log` içindedir; kasıtlı iki config hatası ile sıfır script hatası ayrıdır.

Fikstür Node sahnesi olarak çalışır: autoloadların kurulmasından sonra gerçek menü sözleşmesini kullanır. İlk SceneTree prototipindeki autoload derleme sırası sorunu bu test düzeniyle giderildi; üretim kaynağına müdahale edilmedi.

Hedefli sonuç **4 PASS / 0 beklenmeyen hata**: negatif bozuk cfg/gerçek menü, GuvenliMetin birimi, gerçek açılış bağımlılıkları, headless import. Kanıt `work/tek18-target`. Yeni kontrol sanity listesine eklendi; tek nihai tam UTF-8 sonucu koşu sonunda yazılacak. Testlerde res://work yolu yok.

Zorunlu ds yerel ayna bu bilgisayarda erişilemiyor; eşitlenemedi. İlgisiz untracked dosyalar korundu.

İlk TEK-18 tam koşusu `work/sanity-tek18-final`: negatif cfg/menü kontrolü ve 20 gece geçti; mevcut kriz sahnesi kuyu malzemesi RID hatası verdi. Başarısız sayıldı. Bu, ayrı BUG-25 takip düzeltmesi gerektirdi; BUG-25 yeniden sahiplenildi (962dd34). TEK-18 testi mevcut ayar/metin üretim kaynaklarını değiştirmez; birlikte doğrulanan BUG-25 takip paketi kuyu Material yaşam süresini mevcut Pbr cache içinde düzeltir. Sonraki nihai tam koşu beklenir.

Nihai tam UTF-8 sanity **345 PASS / 0 beklenmeyen hata / 20 gece**, `work/sanity-tek18-bug25-final-2`. Kuyu ömür testi, çınar ve kriz gerçek sahneleri, düşük bellek geçişi ve negatif cfg/menü testi aynı koşuda geçti. Negatif fikstürün iki kasıtlı config kaydı ayrıca `work/tek18-negative-final-2/expected-config-errors.log` içinde; script hatası yok. Genel hata regex/istisnaları değişmedi.
