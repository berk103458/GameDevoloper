# Köylü takip kamerası — ANI-14

## Overview
Mevcut köylü kartı seçimi mevcut strateji kamerasını seçilen figüre odaklar; tek Label3D adı, zanaatı ve görsel eylemi gösterir.

## Player Fantasy
Seçilen köylünün işine yürüyüşünü izleyip kim olduğunu ve ne yaptığını kolayca okuruz.

## Detailed Rules
KoyluKarti.ac tek satırla KoyluTakibi.sec çağırır; mevcut ray/küre seçimi, kart, atama düğmeleri ve nüfus listesi korunur. Helper sahnede yalnız bir kere oluşur ve aynı etiketi seçimler arasında taşır. Yeni kamera veya HUD yoktur. Seçilen figürün konumu hedef olur; zoom, yön ve eğim mevcut kamera API'sindedir. WASD/Q/E/Escape takibi bırakır, sağ tık etiketi de kapatır. İnşa/yol/yık kipine girince takip temizlenir. Metin alanına yazarken kamera tuşları alınmaz.

## Formulas
Kamera hedefi = figürün mevcut sahne konumu. Etiket dünya konumu = figürün dünya konumu + UP × etiket_yukseklik. İlk seçimin uzaklığı min(mevcut uzaklık, kamera_uzaklik); sonraki karelerde zoom yeniden dayatılmaz.

## Edge Cases
Silinen/ölmüş veya 30 figür sınırı dışındaki kişi için sahte model kurulmaz. Etiket iki taraflı billboard, sabit ekran ölçeği ve normal derinlik testiyle kullanılır; bina arkasında duvarı delerek gösterilmez. Yalnız açık ad/zanaat ve görünür hareket okunur, gizli bayraklar yazılmaz. Kayıt/RNG/atama salt okunur; mevcut kartın gerçek iş işlemleri korunur. Duraklama mevcut sahne process_mode'u ile birlikte durur.

## Dependencies
KoyluSecimi, KoyluKarti, KoyYonetimSahnesi mevcut kamerası, KoyHalkHareketi. Tema.font var olan Alegreya dosyasını kullanır. Label3D API: https://docs.godotengine.org/en/stable/classes/class_label3d.html .

## Tuning Knobs
data/koylu_takibi.json: ilk kamera uzaklığı, etiket yüksekliği, yazı/pixel/outline boyutu. Asset gerekmedi; var olan font ve figürler kullanıldı.

## Acceptance Criteria
Gerçek figür tıklaması kart/takip açar; figür yürüyünce kamera/etiket taşınır. WASD iptali, seçim değişiminde tek etiket, tekerlek zoomu, sağ tık ve yapı kipi iptali, kaldırılmış/sahne dışı kişinin temizlenmesi. Gizli bilgi yok, kayıt/RNG korunur; native görüntü, eski kart/sürükle-atama ve navigasyon testleri geçer.
