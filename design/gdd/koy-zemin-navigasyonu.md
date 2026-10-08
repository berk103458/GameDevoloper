# Köy zemin navigasyonu — ANI-13

## Overview
Mevcut KoyRotasi A* hedefleri ve patika ağırlıkları, aynı doluluk verisinden üretilen NavigationRegion3D koridorlarına bağlanır.

## Player Fantasy
Köylüler kapıya ve iş yerlerine patikalardan gider; bina içinden veya kaya/dere üzerinden geçmez.

## Detailed Rules
KoyHalkHareketi.yenile tek satırla bölgeyi yeniler; planlama tek satırla hücre dizisini dünya rotasına çevirir. Yeni mantık KoyZeminNavigasyonu içindedir. Açık hücrede merkez kare ve yalnız açık dört komşuya koridor kolu kurulur. Bina ve arazi hücrelerine polygon eklenmez; köşelerde boşluk karakterin köşeden kesmesini önler. Navmesh görsel asset değildir, çalışma anında hesaplanan navigasyon verisidir. A* sıra/atama seçiminden sonra her komşu segment NavigationServer3D.map_get_path ile sorgulanır; ekonomik model ve RNG ilerletilmez.

## Formulas
Hücre yarısı = HUCRE/2; merkez kare yarısı = hücre yarısı − kenar_bosluk. Mevcut durak sapması ±0.35m, varsayılan merkez yarısı 0.5m içinde kalır. Tüm polygonlar aynı yüksekliğe ve ortak kenarlara sahiptir. Haritanın cell_size/cell_height değerleri kullanılır.

## Edge Cases
Yeni doluluk geldiğinde eski navmesh sorgulanmaz; mevcut açık hücrelerden hesaplanan A* yolu kullanılır. Bölge ve harita iteration değişimi, sıfır olmayan iteration ve örnek polygonun gerçek harita sahibi birlikte hazır olmayı belirler. Hazır olunca sonraki mevcut planlama 3B sorgu kullanır; sürmekte olan güvenli rota veya tezgâh işi kesilmez. Boş/erişilemeyen A* hedefi boş kalır; eksik/kısmi nav sorgusu güvenli A* merkezlerine döner. Eski tezgâh, hava, sinsi, devriye, çoban hedefleri ve yürüme tweeni korunur. Ayrı HUD veya ikinci simülasyon yoktur.

## Dependencies
KoyYonetimSahnesi dünya koordinatları, Izgara doluluk/arazi, KoyRotasi, mevcut NavigationServer3D. API: https://docs.godotengine.org/en/stable/classes/class_navigationserver3d.html ; https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html .

## Tuning Knobs
data/koy_zemin_navigasyonu.json: kenar_bosluk, hedef_toleransi, navigation_layers. Mevcut hücre ölçeği ve durak farkıyla uyum korunur. Asset gerekmedi; yeni görünür kaynak, model veya animasyon yoktur.

## Acceptance Criteria
Bina/arazi polygon dışlama, tüm açık hücrelerin kapsanması, köşe tamponu, salt okunur ızgara; gerçek sahnede kapıya nav sorgusu (yedeksiz), sync sırasında güvenli A*, güncelleme sonrası hazır olma ve kayıt/RNG korunumu. Eski rutinler, açılış ve 20 gece regresyonu geçer.
