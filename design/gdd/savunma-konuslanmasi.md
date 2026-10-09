# Savunma taktik konuşlanması — HAR-10

## Overview
İkinci perdede mevcut gerçek muhafız, köylü kartından Devriye / Kapıda mızraklı / Sur okçu olarak atanır. Aynı halk modeli, A* ve görev donanımı kullanılır.

## Player Fantasy
Kapı hattını mızraklılarla ve sur iç köşe duraklarını okçularla tutmak. Muhafız seçimi görev yerini belirler; yeni kişi veya paralel savaş motoru üretmez.

## Detailed Rules
Yetişkin, sağlıklı, çalışan gerçek muhafız gerekir. Mevcut kışla görevlisi de uygundur. Zindan, hasta/aç/yaralı, borçlu, dış görev, uyuklayan ve iş isyanı etkin katılımı engeller. Kapı iki; sur dört slot. Sur için işlevli sur gerekir. Geçici pasif kayıt saklanır; dönüşte ID sırası kontenjanı süzer. Devriye seçimi pasif veya terminal kaydı da temizler.

## Formulas
HAR-10 kendi içinde savunma_gucu / asayiş / kasa / RNG değiştirmez. HAR-15'in Güvenlik katkısı [savunma-guvenligi.md](savunma-guvenligi.md) belgesindeki tek mevcut Güvenlik adaptöründe hesaplanır; burada ikinci bonus yok. Kapı mevcut meydan x merkezi + slot, son ızgara y; sur mevcut dört köşe. Aynı A* en yakın geçilir hücre ve gerçek yol doğrulaması; kopuk hedef eski devriye politikasına düşer. Zemindeki iç kule durakları kullanılır; dikey sur tırmanışı veya teleport eklenmez.

## Edge Cases
İlk perde, dolu slot, bilinmeyen/ölü ID, bozuk rol ve terminal yeni atama atomik ret. Optional defter en çok64 kanonik pozitif ID; legacy boş, JSON rol korunur. Aşırı kayıt deterministik kesilir, ghost NPC yaratılmaz. Hasarlı sur okçuyu pasifleştirir, kapı sürer. Rol değişimi eski taktik çocuğunu hemen ayırır; ikinci silah/HUD yok. Gerçek el kemiği yoksa sahte kemiğe donanım takılmaz.

## Dependencies
SavunmaKonuslanmasi + dış JSON. KoyYonetimi optional kayıt iki ince bağlantı; MuhafizDevriyesi eski çağrıları koruyan optional kişi argümanı. KoyluKarti tek panel helper çağrısı; koy_halk_hareketi yalnız kişi argümanı ve mevcut yenile/fazdan tek donanım helper çağrıları. KarakterModel/Ses/Oturum/CSV değişmez.

## Tuning Knobs
Kontenjan2/4, sağlık50 ve kayıt64 denge varsayımları dış JSON. Yay/mızrak boyutu/renk/ad aynı JSON; yalnız düz kutu yer tutucu, asset üretimi/indirme yok. HAR10-YAY/HAR10-MIZRAK envanter G.

## Acceptance Criteria
Canlı atama/kısıtlar, kapı/sur kapasite, deterministik hedef, aynı A*, legacy/JSON/bozuk/terminal, kasa/RNG/iş/formül korunması. Gerçek köylü kartı click, mevcut model/rotanın rol değişimi, tek gerçek el donanımı/temizleme; headless/native/ds ayna ve muhafız/kapı/kayıt regresyonları.
