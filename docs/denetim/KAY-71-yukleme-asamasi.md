## 2 Kasım 2026 — KAY-71 tamamlandı (Kalfa)

Mevcut Ana ekran geçişi kapı/köy ekranını tek node grubunda işaretler; eski ekranın işareti geçişte kaldırılır. Göç yürütücüsü UI sınıfı import etmeden bu grubu okur. Gerçek sürüm dönüşümü aktif oyun ekranında hiçbir ara adımı çağırmadan geliştirme hatasıyla reddedilir. Güncel sürümün adımsız doğrulaması göç değildir ve eski kayıt ikizi API'si korunur. Açık Ana.devam_et isteği önce yükleme aşamasına geçer, sonra göç eder; oyuncu yüklemesi engellenmez. Yeni motor, zamanlayıcı veya kare başı tarama yok.

Kanıt: work/kay71_unit_son.log menüde göç/güncel doğrulama/grup yaşam döngüsü; izole negatif alt süreç gerçek geliştirme hatasını ve sıfır adım çağrısını doğrular, kasıtlı hata yalnız user pid negative.log içinde. kay71_acilis_goc.log gerçek Ana köy/kapı işareti, açık v2 Devam et ve menüye dönüş; kay71_menu.log başarısız göç ekranı; kay71_ikiz.log mevcut kayıt ikizleri. Dört hedefli kontrol ve kay71_import_son.log temiz recovery import geçti. İlk testte SceneTree kurulmadan grup sorgusu yapılmıştı, test deferred çalışmaya taşındı. İlk 300 kare sınırıyla yarım kalan açılış kabul sayılmadı; kendi 90 saniye sınırıyla gerçek test tamamlandı, son loglarda sızıntı yok. İlk cache MD5 logu korunur.

İnceleme: Ana'da yalnız ekran/yükleme sınırına ince adaptör, kayıt/göç API imzaları aynı; grup denetimi yalnız göç çağrısında çalışır. Asset gerekmedi. kota görünmüyor. Tam sanity/görünür pencere yok. ds yolları yok, eşitlenmedi. Söz motoru beklemede; diğer ajan işleri korunur.

