# Çoban ve sürü döngüsü — ANI-05

## Overview
Mevcut CHR ağıl türü kurulabilir hale gelir; başlangıç sürüsü sabah çayırda otlar, akşam/gece kapıdan ağıla döner.

## Player Fantasy
Oyuncu çobanını ve dört koyunu açık kapıdan otlağa giderken, dönüş tamamlanınca kapıyı kapanırken görür.

## Detailed Rules
Ağıl kurulum bedeline dört koyunluk başlangıç sürüsü dahildir; ayrı satın alma/çoğalma/ölüm ekonomisi eklenmez. Hazır ağılın bir çoban slotu ve mevcut bina formülüne bağlı temel 1 erzak reçetesi vardır. Çobansız sürü ağılda kalır. Görsel bütçe en fazla dört ağıldır. Gündüz kapı açılır; çoban erişilebilir çayır durağına gider. Koyunlar mevcut aynı A* grafiğinde kendi geçerli konumlarından aynı hedefe yürür, varınca başlarını otlama döngüsüyle eğer. Akşam/gece ağıl kapısına döner, ardından içeri girer; kapı tüm sürü varınca kapanır. Atama değişimi tek sürüyü yeniden bağlar, bina yıkımı görseli temizler.

## Formulas
Gerçek gece üretimi mevcut KoyYonetimi bina üretim formülünden gelir; görsel hareket üretim/kayıt/RNG'ye yazmaz. Görsel koyun sayısı = ağıl başına JSON koyun_sayisi; görünür sürü üst sınırı JSON suruler_azami. İlerleme = move_toward(hedef, hız × delta).

## Edge Cases
İnşa halindeki ağıl sürü oluşturmaz. Ahır ve EKO-03 öküz/inek sahipliğiyle karışmaz. Kayıt restore sürüyü bina üzerinden tekrar kurar. Yoldayken faz değişimi aynı A* grafiğinde yeniden planlanır; kapalı/kopuk dönüşte koyun içeri kestirme yapmaz, kapı erken kapanmaz. Mevcut CSV değiştirilmez; CHR Ağıl → agil eşlemesi korunur. Prosedürel düşük poligon koyunlar kullanılır; Meshy model/kemikli yürüyüş iddiası yoktur.

## Dependencies
CobanSurusu, BinaKatalogu'nda tek katalog adaptörü, mevcut yapı ad zinciri ve KoyHalkHareketi/KoyRotasi. KoyYonetimSahnesi mevcut bina köküne kapılı çit ekler. Ayrı hayvan/üretim/RTS/HUD sistemi yoktur.

## Tuning Knobs
data/coban_surusu.json: kurulum bedeli/boyut/slot/reçete, başlangıç koyun sayısı/görsel bütçe, hareket/varış/otlak mesafesi, gövde/baş/bacak ve kapılı çit ölçü/renkleri. Denge varsayımı: 14 odun + 6 erzak, iki inşa günü; çoban başına temel 1 erzak.

## Acceptance Criteria
Gerçek CHR türü, katalog kurulum ve koyun parçaları birimi. Gerçek ağıl/çoban/sürüde gündüz varış, tek sürü, akşam dönüş/kapı, çobansız sürünün korunması, yıkım temizliği ve kayıt/RNG/ekonomi değişmezliği. Import/API, bütün sanity paketi/20 gece, native görüntü ve ayna sahne geçer.
