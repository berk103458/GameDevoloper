# BUG-25 — kapı meşaleleri ve kuyu (Kalfa)

Sahiplik: 9d51959, festive. Yeni asset gerekmedi; mevcut kuyu GLB ve kapı alevi kullanıldı.

İki kapı meşalesinin ışığı önce alev kökünden 0,736546 m uzaktaydı. `KapiKuyuAyari` JSON'daki soket yüksekliğini okur; mevcut alev ve ışık aynı Marker3D konumuna bağlanır. Enerji, menzil, gölge, titreşim ve MEV-09 sistemi değişmedi. Dört sur seviyesinde, taşınmış/döndürülmüş kapıda, ışık/efekt gizliyken fark sıfırdır.

Mevcut kuyu Dunya3B'nin tabanı sıfıra oturtan yükleyicisinden 1,20 m yüksekliğinde gelir; tek sahne ayarında nötr taş rengi vardır. Sulama merkezinin X/Z/Y konumu korunur. Gerçek köyde taban 0,00 m, tepe 1,200000 m ve mevcut çiftçinin baş kemiği 1,448824 m. İskeletli modelin ham AABB değeri kemik dönüşünü temsil etmediğinden boy referansı olarak kullanılmadı. Görünür OpenGL sahnesindeki ekran görüntüsü de köylünün kuyudan yüksek olduğunu gösterdi.

Kanıt: `work/bug25-visible/visible.log`, `bug25_kuyu.png`, `bug25_kapi.png`. Görseller oyun görüntüsüdür; yeni oyun asseti değildir. Test çıktıları dış dosya dizinine yazılır; `res://work` test yolu yok. Su kirlenmesi, sulama, ekonomi, kayıt/RNG değiştirilmedi.

Doğrulama: yeni birim ve gerçek sahne, mevcut gölge, grafik profili, sulama, kuyu kirlenmesi/zehirlenmesi ve kapı görüşü hedefli kontrolleri. Tam sanity sonucu koşu tamamlanınca aşağıya eklenecek.

Yerel ds çalışma kopyası ve GitHub aynası bu bilgisayarda yok; eşitlenemedi. İlgisiz untracked `_tmp_*` dosyaları korundu.

İlk tam koşu `work/sanity-bug25-final`: yalnız çınar sahnesi renderer malzeme RID hatası verdi; 20 gece geçti. Başarı sayılmadı. Adaptörün ikinci malzeme ataması kaldırıldı; mevcut nesne yükleyicisine geriye uyumlu isteğe bağlı renk parametresi eklendi, malzeme tek kez atanır. Yeni önbellek veya renderer hata istisnası eklenmedi. Hedefli tekrar ve yeni nihai tam koşu gereklidir.

Nihai tam UTF-8 sanity: **342 PASS / 0 hata / 20 gece**, `work/sanity-bug25-final-2`. Malzeme düzeltmesi sonrası çınar üç hedefli tekrar + nihai tam koşuda geçti; 5 ek hedefli kontrol geçti.

Uygulama commit 06cb592 sonrası festive merge çakışmasız alındı. testx yetim import temizliği ve Codex sahiplikleri korundu. Merge sonrası 9 hedefli kontrol geçti: yetim import unittest, headless import, yeni birim/gerçek sahne, animasyon fallback, çınar, sulama, gerçek CHR kapı ve açılış bağımlılıkları. Kanıt `work/bug25-merge-target`. Tam sanity birleşimden önceki uygulamaya aittir.

## Aralıklı malzeme RID takibi — 11 Ekim 2026 (Kalfa)

TEK-18 tam koşusunda kriz sahnesinin oyun iddiaları geçti ancak kuyu malzemesi RID/null hatası tekrarlandı. Önceki tek atama düzeltmesi aralıklı sorunu tamamen gidermemiş; BUG-25 kendi sahipliği 962dd34 ile yeniden açıldı. TEK-18 koşusu başarısız sayıldı, kapanmadı; hata regex istisnası eklenmedi.

Yeni ömür testi önce 200 yenilemede 200 ayrı material bulup kırmızı oldu. Kuyu rengi mevcut Pbr._onbellek içine tek renk anahtarıyla konur; yeni statik önbellek açılmaz. Dunya3B.nesne geriye uyumlu isteğe bağlı Material alır ve mevcut mesh üzerine tek kez atar. Sonuç 200 yenilemede 1 material; memory_free yine beş cachei temizler, aktif kuyu kendi güçlü referansıyla malzemesini korur, sonraki kuyu temizlenmiş cachete yeni malzeme alır. Kuyu taban/tepe ve diğer model renkleri korundu. Hedefli ömür/ölçü/düşük bellek/gerçek geçiş kontrolleri geçti; kriz ve çınar tekrarları sürüyor.

Takip hedefli sonuç: ömür/ölçü/düşük bellek/gerçek geçiş 4 kontrol; kriz 3 ve çınar 3 tekrarı; korumalı API, bozuk cfg/menü ve headless import geçti. Kanıt work/bug25-rid-target. Yeni nihai tam koşu gerekirdi ve başlatılıyor. Önceki aralıklı hata genellenerek istisna sayılmadı.

Nihai tam UTF-8 sanity **345 PASS / 0 beklenmeyen hata / 20 gece**, `work/sanity-tek18-bug25-final-2`. Kuyu ömür testi, çınar ve kriz gerçek sahneleri, düşük bellek geçişi ve negatif cfg/menü testi aynı koşuda geçti. Negatif fikstürün iki kasıtlı config kaydı ayrıca `work/tek18-negative-final-2/expected-config-errors.log` içinde; script hatası yok. Genel hata regex/istisnaları değişmedi.
