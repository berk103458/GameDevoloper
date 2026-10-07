# Su taşıma rutini — ANI-03

## Overview
Mevcut halk hareketine hazır tarla/bostan çalışanının kuyu → kova → su arkı → dinlenme döngüsü eklenir.

## Player Fantasy
Oyuncu gündüz tarımsal emeği ve sulama sırasında kovadan akan suyu sahnede görür.

## Detailed Rules
Yalnız gündüz, hazır tarla/bostan görevlisi; kışın duran yapıda rutine girilmez. Kuyu ve ark duraklarına mevcut A* yürüyüşü kullanılır, binaların içine girilmez. Kuyu beklemesinden sonra dolu kova taşınır, ark durağına varınca akış görünür. Sonra meydanda dinlenir, kova gizlenir; döngü başa döner. Akşam/gece veya görev değişince kova kaldırılır, özgün CHR eşyası önceki görünürlüğüyle geri gelir. Su arkları hazır tarlanın mevcut görsel köküne eklenir.

## Formulas
Aşama = (aşama + 1) modulo 3. Bekleme eşikleri JSON sureler[0..2]. Görsel hareket gerçek delta kullanır; gece üretimi veya stoklara su bonusu yazılmaz.

## Edge Cases
Eksik RightHand kemiğinde sahte soket oluşturulmaz; hareket devam eder. Kopuk hedefte bulunduğu yerde bekler, durumu yol kapalı diye gösterir ve sonraki aşamayı dener. Yapı yenilemesinde çift kova oluşturulmaz. Kuyunun görseli ve yaklaşım durağı aynı JSON ofsetinden türetilir. Akış görsel bir şerittir; sıvı fiziği simülasyonu yoktur.

## Dependencies
SulamaRutini, KoyHalkHareketi/KoyRotasi, mevcut ElEsyasi.kova, KarakterModel ve hazır tarla/bostan görseli. ANI-02 devriyesi aynen korunur; ikinci hareket/ekonomi/HUD veya kayıt alanı yoktur.

## Tuning Knobs
data/sulama_rutini.json: aşama süreleri, kuyunun ofseti/yaklaşım noktası, ark genişlik/aralığı/renkleri, kova su yüzeyi ve akış ölçüleri. Yürüme hızı/bütçe mevcut koy_hareket.json'dan gelir.

## Acceptance Criteria
Birim: tarla/bostan/gündüz, inşaat, farklı görev, kış filtresi. Gerçek iki çalışanla kuyu/ark/dinlenme, dolu kova ve yalnız varışta akış, çift donanım olmaması, gece temizliği, ekonomi/RNG/kayıt değişmezliği. Native görüntü; rota/üretim/muhafız/açılış regresyonları ve izole 20 gece geçer.
