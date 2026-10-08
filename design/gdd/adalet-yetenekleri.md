# Adalet yetenek ağacı — ODA-06

## Overview
Keskin Bakış → Gönül Bağı aynı optional MuhafizYetenekleri kaydında ve tek oda listesinde açılır. İkinci keşif, terazi, HUD veya isyan motoru yoktur.

## Player Fantasy
Adil muhafız mevcut nişan/heybe ayrıntısını hızlı görür; halk güveni ağır mutsuzluğun isyana dönüşmesini geciktirir.

## Detailed Rules
Keskin Bakış: 10 kişisel akçe, en az4 tecrübe,70 adalet, en çok20 yozlaşma. CHR inceleme düğmesiyle panel açıldığında mevcut nişan eylemi ve detay kartı otomatik çalışır. Yük ve fiziksel iz elle incelenir; diyalog/karar/tansiyon değişmez. Eski heybe açılırken mevcut astar_yokla çağrılır; eşya alınacak miktarı sıfır kalır, keşif tekrarlanmaz. Her iki kaynak aynı eski keşif kaydını kullanır.

Gönül Bağı: önce Keskin Bakış, 20 kişisel akçe, en az8 tecrübe,80 adalet, en çok20 yozlaşma. Sahiplik kalıcıdır; etkisi mevcut adalet en az60, yozlaşma en çok20 kaldığında çalışır. Oyun RNG olasılığı yerine moral eşiği/sayaç kullanır: eşik1 olur, normal eşik daha düşükse yükseltilmez. Devam eden isyanda da aynı karşılaştırma ve bitiş olayı kullanılır. Adalet düşerse veya yeni rüşvet/haraç yozlaşmayı yükseltirse eski eşik geri gelir.

## Formulas
Alım bedeli yalnız Oturum.muhafiz_akce'den bir kez. Etkin isyan eşiği = min(taban,1); etkisizse taban. Gösterge moral ortalamasıdır, rastgele olasılık değildir. 1 veya0 moral krizi hâlâ isyan/firar/idam zincirini yürütür. Eşikler ve bedeller veri ayarlı denge varsayımlarıdır.

## Edge Cases
Eski kayıtta iki seçim yoktur; önkoşulsuz/bilinmeyen seçimler elenir. JSON sahipliği korur; türetilmiş köy işareti yükleme/alım ve gerçek gece başlangıcında yenilenir, ikinci kalıcı kayıt değildir. Gece içindeki adalet düşüşü isyan anında tekrar okunur. Açlık, ölüm, asayiş ve diğer yenilgi sonuçlarına bağışıklık verilmez. CHR Resource readonly, başka ipucu bulunmaz, aynı panel tekrarında tek ipucu. KAP-01/02/03 mekaniği ve CSV değişmez.

## Dependencies
MuhafizAdaletYetenekleri helper; MuhafizYetenekleri/OdaYetenekPaneli mevcut dört seçim listesi. ChrKapiAdaptoru ve KapiEkrani birer ince çağrı. Oturum gece/yükleme türetilmiş bağlantı; KoyYonetimi._isyan tek eşik adaptörü. koy_halk_hareketi değiştirilmedi.

## Tuning Knobs
data/muhafiz_yetenekleri.json: keskin_bakis/gonul_bagi bedel/tecrube/adalet/yozlaşma/önkoşul; gonul_adalet/gonul_yozlasma_azami/gonul_isyan_esigi. Asset gerekmedi, envanter G kontrol edildi; mevcut düğme/detay kartı ve oda kutuları kullanılır.

## Acceptance Criteria
Gerçek kişisel ödeme ve bağlı alım; yüksek yozlaşma/düşük adalet/tekrar/legacy JSON. Gerçek CHR panelinde nişan keşfi, yalnız bir ipucu, readonly kaynak/tansiyon/para/RNG; eski heybe astarı ve el koymasız tekrar. Aynı isyan sayacında önleme/bitiş/adalet düşüşü/yozlaşma ve aşırı kriz firarı; eski bağımsız köy aynı davranış. Native oda/inceleme ve ayna import/UI.
