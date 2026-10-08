# Karakter ekipman soketi — ANI-11

## Overview
Mevcut zanaat aletleri gerçek sağ el BoneAttachment3D soketinde taşınır; mola/gece/görev kalkışında aynı nesne gizli görsel stoka alınır.

## Player Fantasy
Çalışan elindeki aleti bırakır ve dönüşte tekrar alır; tezgâh ve karakter çoğaltılmaz.

## Detailed Rules
ZanaatTezgahi üretim/faz/atama kararının mevcut sahibi kalır. KarakterEkipmanYoneticisi yalnız bağlantı ve nesne ömrünü yönetir; halk hareketine yeni mantık veya çağrı eklenmez, önceki ZanaatTezgahi.esya adaptörü kullanılır. Her modelde tek yönetici ve gerçek RightHand için tek BoneAttachment3D; override_pose kapalı. Soket mevcut Skeleton3D yolunu kullanır, sahneye girdikten sonra çözülür. Avuç tutma noktası mevcut DurusDuzeltici ölçümünden; ölçüm yoksa bilek-önkol doğrultusu. Meshy el eksenleri farklı olduğundan aletin yönü mevcut karakter yaw'ı ve alet ucunun önceki vuruş hareketinde kalır. İskelet pozu ezilmez. Demirhane/atölye/çivi ocağı/tamir sundurması aynı çekiç türünü, fırın kürek türünü paylaşır. Mola/gece/yağmurda zanaat rutini kalkınca alet saklanır; sonraki görev aynı nesneyi kullanır. Eski görevin gecikmiş kapanışı yeni sahibin aletini gizlemez.

## Formulas
Avuç varsa dünya konumu = soket global dönüşümü × ölçülmüş yerel avuç noktası. Yoksa bilek + normalize(bilek − dirsek) × avuc. En çok eşleme tablosundaki benzersiz alet türü kadar görsel stok (şu an iki); ekonomik kaynaklar aynen kalır.

## Edge Cases
İskeletsiz veya el kemiği eksik fallback'a sahte kemik eklenmez. Aynı tip yeniden takılınca yeni geçici yer tutucu silinir; stoktaki tek nesne korunur. Farklı görev iki görünür alet oluşturmaz. Model kalkınca yönetici/soket/stok aynı ağaçla temizlenir. Bu görsel stok kalıcı envanter veya bina stoğu değildir; oturum kaydı ve RNG değiştirilmez. Mevcut muhafız/çoban/taşıma ElEsyasi API'leri korunur; zanaat dışı rutinler yeniden yazılmaz.

## Dependencies
KarakterEkipmanYoneticisi, ZanaatTezgahi, KarakterModel, mevcut Skeleton3D/DurusDuzeltici, BoneAttachment3D, ElEsyasi ve aynı A* halk rutini. API: https://docs.godotengine.org/en/stable/classes/class_boneattachment3d.html

## Tuning Knobs
data/karakter_ekipman.json: gerçek el/önkol adı, ölçüm yoksa avuç uzaklığı, bina→alet kimliği. Yer tutucu tek üretim noktası ZanaatTezgahi._kur; mevcut ANI-ALET eksikleri G tablosunda ANI11-ALET referansıyla kayıtlı. Yeni asset dosyası üretilmez/indirilmez.

## Acceptance Criteria
Birimde gerçek kemik pozu, tek soket/alet, gizli stok ve aynı nesne yeniden kullanımı, geç kapanan sahip, fallback ve yaşam sonu. Gerçek sahnede demirci/fırıncı, mola/gece saklama, tür değişimi, aynı nesne dönüşü, ekonomik kayıt/RNG korunumu. Eski zanaat/muhafız/sulama/oduncu/değirmen/hava/ateş/gece rutinleri, açılış/20 gece, native ve ds ayna hatasız geçer.
