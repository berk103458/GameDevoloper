# ACL-04 — İlk akşam ulak ve ilk aile (Kalfa)

14 Ekim 2026. Sahiplik d72107c; envanter ayrımı 8020ec4.

Yeni oyun mevcut ACL-01 köyünde başlar. İlk Geceye geç çağrısı ekonomi hesabından önce zorunlu ulak sunumunu açar. HAR-04'teki adsız Sancak Beyi kullanılır; yeni bey veya siyasi sistem eklenmez. Sekiz saniyelik sunum bitince ulak gider, mevcut kapı ekranında iki yetişkinlik ilk aile belirir. Ulak karar kuyruğuna girmez; doğrudan kabul API'si de onu reddeder.

Aile selam/konu sorularını, heybe panelini ve iki basışlı normal kabul/ret kararını kullanır. Öğretici ipuçları atlanabilir; bu yalnız ipucu kutusunu kaldırır. Ailenin kararı verilmeden Oturum.gece_sonu hiçbir gün/kaynak/RNG değiştirmez. Kabul iki mevcut Koylu kaydı, ret sıfır kayıt ekler. Tek seferlik bayraklar mevcut kayıt formatıyla korunur; ulak sonrasında yükleme aileye döner, tamamlanan aile kararı ikinci kez uygulanmaz. Ertesi normal gece hesabından sonra HUD Kapı açık yazar.

Bu sabit iki yetişkinlik sahne genel aile üretimi değildir. KAP-17'nin çocuk/yaşlı, ayrılma ve aile kataloğu burada yeniden kurulmaz. Parça B motoru hazır olana kadar geçici sahne data/gecis.json içinde işaretlidir; aynı normal kapı sohbet arayüzüne bağlanır. Sunum OlayVerisi rastgele havuzdan seçilemez (hiç verilmeyen sunum bayrağı ve sıfır ağırlık); sahne doğrudan gösterilir.

Asset ACL04-ARASAHNE için mevcut assets/art/env/acilis_ulak.png 1920×1080 opak gece_kapisi promptu kullanılır. Yer tutucu koyu ColorRect ve kısa isim etiketidir. Yeni resim/model/ses üretilmedi veya eklenmedi; entegrasyon üretim sonunda. Mevcut yetişkin modeli tekrar kullanılır.

Hedefli doğrulama: yeni açılış birim testi (kabul/ret/kayıt/tekrar/gece kilidi), eski kuruluş testi, barınak testi, beş sıra × 20 gece açılış dengesi ve gerçek oyun köprüsü UI akışı geçti. İlk gerçek köprü koşusundaki varsayım (gün hemen artmalı) açılış bekleme durumuyla düzeltildi; meclis/cenaze kilitleri korunur. Önceki başarısız loglar work/acl04_* içinde saklanır. Tam sanity sonucu kapanışta eklenecektir.

İlk tam koşu Python olay-kartı testinde durduruldu: yeni OlayVerisi anahtarlarının olay. önekli olması gerekiyor. Eklenen dört olay anahtarı bu şemaya taşındı, test kuralı gevşetilmedi. İlk koşu logları work/sanity_acl04_20261014 altında korunur.

Yönetici uç durumu: yeni ilk-gece kilidi varken ZamanMakinesi ve SenaryoKosucusu eski rapor şeklini varsayıyordu; yeni regresyon testi hatayı yeniden üretti. İki araç erken ve yan etkisiz döner; gözcü öngörüsü de ilk aileden önce gün ilerlemiş gibi rapor vermez. Açılış, zaman makinesi, senaryo ve gözcü testleri yeniden geçti. Regresyon testi sürmekte olan tam koşuya yetiştiğinden o koşu durduruldu; sabit kaynaklarla son koşu work/sanity_acl04_20261015_final altında başlatılır. Artık bu koşu sırasında kaynak/test dosyası düzenlenmez.

Antigravity’nin 3cf07e2 DEN-03 paketi ortak kopyaya geldi; kendi dosyaları korunur. Yeni denge denetimi ve 11 Python testi ayrıca geçti; son tam koşu bunları da içerir.
