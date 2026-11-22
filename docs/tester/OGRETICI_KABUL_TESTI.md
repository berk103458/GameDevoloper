# İlk iki gün öğretici kabul testi

Uygulama Alpha'da, kabul testi Kalfa'da. Koşuya temiz bir test yuvasında Yeni Oyun ile başla. Dil Türkçe ve ipuçları açık olsun. Başlangıç tohumunu, oyun derlemesini ve test yuvasını rapora yaz. Bir adım için ekranda görünen sonucu ve gerekiyorsa ekran görüntüsünü sakla.

## 1. İlk köyde işçi, üretim ve barınma

1. Köy açılınca rehberi oku. Taş Yatağı'nı seç ve bir köylü ata. Rehberin atama hedefi, oyun çalışanı kaydettiğinde tamamlanır. Üretim ve boşta işçi göstergeleri atamaya karşılık verir.
2. Gıda stokuna, yatak kapasitesine ve nüfusa bak. Rehber stok miktarının, kaç günlük gıda kaldığının ve yatak/nüfus oranının nasıl okunacağını gösterir.
3. İnşa ve işçi yönetiminin farkını bir bina kartında göster. Maliyet mevcut stokla karşılaştırılabilir. Her aşamada oyuncu rehberi daraltıp normal köy kontrollerini kullanabilir.

## 2. Geceye geçiş, kapı sorgusu ve karar sonucu

1. Gündüzden akşama geç ve ilk aileyi karşıla. Rehber zamanı ilerletme komutunu ve ilk aileye soru sormayı öğretir. Oyuncu gerçek kapı düğmesiyle bir soru sorabilir ve konuşma cevabı görünür.
2. Karar öncesi kayıt al. Aynı kayıt üzerinden kabul ve geri çevirme dallarını ayrı ayrı dene. Kabulde aile köy nüfusuna katılır. Geri çevirmede nüfus bu ziyaret nedeniyle artmaz. Sonraki köy ekranı rehberde anlatılan iş gücü ve kaynak sonuçlarının okunmasına izin verir.
3. İnceleme destekleyen ilk ziyaretçiye gelince ekranda açılan incelemeyi kullan ve sorguya dön. Diyalog ağacındaki takip sorusu doğru dalda görünür. İlk aile için inceleme zorunlu değildir.

## 3. Kaydet, kapat ve sürdür

1. Bir öğretici adımını tamamla ve sonraki adım beklerken mevcut yuvasına kaydet. Godot sürecini kapatıp ana menüden aynı yuvaya devam et.
2. Nüfus, kaynaklar, iş ataması ve öğretici ilerlemesi kayıttaki durumla eşleşir. Tamamlanmış hedef yeniden istenmez. Bekleyen hedef normal oyun kontrolüyle tamamlanabilir.
3. İkinci gece sonu kaydına aynı işlemi uygula. Yeni bir sonraki güne geçişten sonra önceki öğretici adımları kendiliğinden açılmaz.

## 4. Atla ve temel döngüyü sürdür

1. Ayrı bir test yuvasında ilk rehberi atla. Köyde işçi ata, kapıya geç ve ilk aile için karar ver.
2. İlk aile kararı ve gece raporu çalışır. Gerekli oyun düğmeleri kullanılabilir. Sonraki köy ekranında kaynaklar ve nüfus seçilen kapı kararına göre güncellenir.
3. Rehberin yeniden açılması sunuluyorsa bunu oyuncu olarak dene. İpuçları kapalıyken atlanan yönlendirme kendiliğinden geri dönmez.

Her kontrolü GEÇTİ, KALDI veya BEKLİYOR olarak kaydet. Sorun varsa tohum, yuva, gün/gece, görünür düğme ve son adımı yaz. Mevcut dar otomatik kontrol `res://tests/oto/ilk_saat_kontrol.tscn` ilk saat kurallarını doğrular. Buradaki gerçek ekran ve kayıt akışını yeni Alpha sürümünde ayrıca uygula.
