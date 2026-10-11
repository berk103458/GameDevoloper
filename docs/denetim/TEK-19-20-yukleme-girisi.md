# TEK-19/20 — yükleme sonrası giriş kontrolü (Kalfa)

11 Ekim 2026. Sahiplik 6abfc33. Mevcut `giris_yukleme_kontrol` gerçek Ana akışı genişletildi; üretim kaynakları ve API imzaları değişmedi. Asset gerekmedi.

Menü yüklemesi bittiğinde VarlikYuklemePaneli sayısı sıfırdır. Görünür ayar düğmesinin merkezine gerçek InputEventMouseMotion ve MouseButton basma/bırakma olayları gönderilir; ilk tıklamanın gerçek AyarlarEkrani açtığı doğrulanır. Doğrudan ana_menu ile dönülür; ayar kapatma/yazma API'si çağrılmaz.

Art arda iki _kapiya_git çağrısında child_entered_tree üzerinden tam bir KapiEkrani kurulması ve ağaçta tek kapı ekranı bulunması birlikte doğrulanır. Yükleme tamamlanınca _kapi_yukleniyor false ve panel sayısı sıfırdır. Önceki gerçek kuyruk, global konsol ve oturum doğrulamaları korunur. Kullanıcı kayıt dosyasına yazılmaz; testlerde res://work yolu yok.

Hedefli gerçek sahne geçti; SCRIPT ERROR, ERROR ve KALDI yok. Kanıt `work/tek1920-target/giris.log`. Commit öncesi tek tam UTF-8 sanity `work/sanity-tek19-20-final` içinde sürüyor; sonuç tamamlanınca eklenecek.

İlk tam koşu başarısız sayıldı: giriş testi ve 20 gece geçti fakat kıtlık isyanı fikstürü çıkışta renderer RID/kaynak sızıntısı bildirdi. Ayrıntılı hedefli log, başarı işaretinden sonra kuyruk karakterlerinin hâlâ diskten yüklendiğini gösterdi. Fikstürün sabah geçişi yalnız Ana bayrağını bekliyordu; karakterlerin ayrı yükleme paneli bitmeden köye dönüyordu. Bu bekleme, tüm VarlikYuklemePaneli çocuklarını da kapsayacak şekilde düzeltildi. Oyun kaynakları ve hata bütçesi değişmedi; kıtlık fikstürünün üç tekrarı hatasız geçti (`work/tek1920-target/kitlik-fix-*.log`). Önceki başarısız loglar korundu. Nihai tam koşu `work/sanity-tek19-20-final-2` içinde.

Muharrir'in yeni yönü alındı: eldeki TEK-19/20 kapanınca Bölüm 41'den başka madde alınmadan ACL-01'e geçilecek. Faz 0 / ACL-01 bağımlılık döngüsü böyle çözüldü; diğer ajanların TEK sahiplikleri korunur.

Zorunlu ds çalışma kopyası ve yerel ayna erişilemiyor; eşitlenemedi. İlgisiz untracked dosyalar korunur.

Nihai tek tam UTF-8 sanity: **345 PASS / 0 beklenmeyen hata / 20 gece** (`work/sanity-tek19-20-final-2`). Genişletilmiş giriş, düzeltilmiş kıtlık, kriz/çınar, bellek geçişi ve negatif cfg/menü aynı koşuda geçti.
