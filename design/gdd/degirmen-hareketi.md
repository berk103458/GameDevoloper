# Değirmen çarkı ve çuval — ANI-06

## Overview
Mevcut değirmen görseli ahşap gövde, dönen çark ve sundurmayla genişler; değirmenci çuval taşır.

## Player Fantasy
Oyuncu çalışan değirmenin çarkını ve iş/çuval/dinlenme döngüsündeki çalışanını görür.

## Detailed Rules
Çark yalnız gündüz hazır değirmende, gerçek fiziksel çalışan ve seçili reçetenin yeterli girdisi varsa döner. Kan davası, grev, kaza, kişisel iş reddi ve dolu ambar görsel etkinliği durdurur. Yaşlı danışman çarkı tek başına çalıştırmaz ve çuval taşımaz. Değirmenci mevcut A* üzerinde iş durağı, sundurma çevresi ve meydan dinlenme noktası arasında döner. Çuval mevcut ElEsyasi.olustur/bagla akışında gerçek sağ el kemiğini izler; yalnız taşıma aşamasında görünür. Akşam/gece veya görev değişiminde özgün CHR el eşyası eski görünürlüğüne döner.

## Formulas
Çark açısı = wrap(açı + delta × JSON cark_hizi). Aşama = (aşama + 1) modulo 3; JSON bekleme süreleri. Görsel hareket üretim, reçete girdisi veya gece stoklarını ikinci kez hesaplamaz.

## Edge Cases
Çalışansız/girdisiz/inşa halindeki değirmen durur; boş/geçersiz reçete güvenlidir. Eksik el kemiğinde sahte soket yoktur. Kapalı rota bekleme durumunu gösterir. Yenileme çuvalı çoğaltmaz; bina yıkımı çarkı da kaldırır. Mevcut ücretsiz ahşap PBR dokusu ve çuval yığını kullanılır.

## Dependencies
DegirmenHareketi, mevcut KoyHalkHareketi/KoyRotasi, ElEsyasi, DegirmenUretimi/TahilZinciri, YasRolleri ve mevcut iş engelleri. Sahne yalnız değirmen türüne dekoratör ekler; ikinci öğütme veya HUD sistemi yoktur.

## Tuning Knobs
data/degirmen_hareketi.json: aşama süreleri, çark hız/yarıçap/kenar/yükseklik, ahşap renk ve sundurma yüksekliği. Mevcut yürüyüş hızı/bütçe korunur; reçete ve denge değiştirilmez.

## Acceptance Criteria
Gerçek çalışan/girdi/faz/inşaat ve yaşlı danışman birimi. Gerçek un reçetesinde çark dönme/durma, üç aşama, gerçek el çuvalı, yenileme ve gece temizliği. Kayıt/RNG/stok aynı; native çark ve çuval görüntüleri, ilgili üretim/rota/önceki rutin/açılış regresyonları, ayna import/sahne ve 20 gece geçer.
