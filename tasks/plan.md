# Kalfa — YAP-01 uygulama planı

6 Kasım 2026. ROADMAP_2.md YAP-01 asıl kabul kaynağıdır. Bu plan yalnız Kalfa sahipliğindeki mevcut maddeyi dilimler; genel ROADMAP hedefini daraltmaz. Yeni görev veya başka ajan sahipliği alınmaz.

## Mevcut durum

İlk veri dilimi: data/koy/yapi_kademeleri.json, YapiKilidi veri sorguları ve hedefli test.22 mevcut kurulabilir bina dışında kimlik yoktur. K0 çadır/tarla/odunluk/bostan; K1 temel marangozluk/depo/taş yapıları; K2 taş ev/değirmen/şifahane/demirhane/savunma; K3 atölye/demir ocağı. Sur1–3 ayrı dizidedir, yeni bina türü değildir. Taş yatağı mevcut TasYatagi doğal kaynağıdır; yeni bina olarak eklenmez. Tablo dışı tür K0, eksik_turler uyarı listesi üretir. İnşaat mevsim çarpanları ilk üç mevsim1, kış0.5 rutin başlangıç seçimidir; henüz oyun hesabına bağlanmadı.

## Bağımlılıklar ve sınırlar

ADM-08 BinaSeviyesi ve KoyBinasi.seviye korunur. YAP kademesi yapı türünün bilgisidir. Bedel BinaKatalogu maliyet verisinden gelir; yeni bedel sabiti yoktur. KoyYonetimi.yerlesim/bina_kur, YapiKarti ve mevcut KoyEkrani menüsü genişletilir. Harita, bina kimliği, ikon/asset veya ikinci inşaat motoru oluşturulmaz.

YAP-02 bilgi kaynakları ayrı sonraki maddedir. YAP-01 içinde üst kademe için gerekli bilginin tek okuma/kayıt sözleşmesi kurulmalı; gelecekteki işlevi varmış gibi çağıran stub yazılmamalı. Koylu optional bilgi alanı ve ACL-06 kaynağı incelenip tek temsil seçilecek. Bilgi uyduran eski-kayıt açma istisnası yapılmaz. YAP-02 tamamlandı sayılmaz.

## Dilim sırası

1. Veri/sorgu/doğrulama: mevcut22 kimlik, K0 fallback, sur ayrımı, ADM seviyesine yazmama. Hedefli model testi. Bu dilim oyuncu akışını henüz değiştirmez.
2. Kilitli kurulumun uçtan uca reddi: gerçek yerlesim/bina_kur ve mevcut menü/ghost. Optional bilgi tek kaynaktan okunur; K0 geçer, K1+ bilgi gerektirir, K3 önce hazır K2 ister. Oyuncu kartında gereken bilgi CSV anahtarıyla görünür, yeni ikon üretilmez.
3. İnşaat/kayıt: sağlıklı yetişkin işçi olmadan ilerleme0, mevsim çarpanı mevcut MevsimYoneticisi.durum kaydından okunur. ADM seviye ve mevcut sur taksit tutarı/akışı korunur. Yarım yapının gerçek JSON yükleme ikizi doğrulanır.
4. Gerçek başsız UI ve ilgili regresyonlar: yetersiz bedel düğmeyi kapatır, borçla kurulum yok, uzun bilgi kartı kayar, hayalet kilitliyken gizlidir; kapı/divan/olay işlemleri bilgi veya bina yaratmaz.
5. Tüm kabul kanıtları tamamlanınca ROADMAP[x], rapor, Türkçe(Kalfa) commit/push; Ahmet masaüstü güvenli FF. Tam sanity çalıştırılmaz. ds yolları yoksa önceki istisna açık raporlanır.

## Riskler

Yeni kilitler eski hedefli testlerin kurulumsuz varsayımlarını kırabilir. Kabulü gevşetmek yerine ilgili fixture gerekli gerçek bilgi/işçi durumuyla kurulmalı; bağımsız başka ajan değişiklikleri korunmalı. Korunan çekirdeğe yalnız gereken adaptör eklenmeli, yeniden yazılmamalı. Her dilimden sonra hedefli test ve headless parse/import sonucu kaydedilir. Mevcut296 kaynak editör kapanış sızıntısı temiz import diye raporlanmaz.

Rutin uygulama kararları Ahmet yetkisiyle sürer. Sadece gerçek çakışma/karar gereğinde Ahmet sorulur; bu plan yeni rutin onay bekleme adımı oluşturmaz. kota görünmüyor.
