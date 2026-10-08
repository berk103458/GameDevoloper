# Atölye parçacıkları ve LOD — ANI-15

## Overview
Hazır demirhane/fırın ve tarla/bostan görünümüne düşük bütçeli CPU parçacıkları eklenir; çalışma varışı, gerçek reçete ve sulama aşamasıyla emisyon açılır.

## Player Fantasy
Demirci çalışırken kıvılcım, fırın çalışırken duman ve ark sulanırken su damlası köyde işin sürdüğünü gösterir.

## Detailed Rules
KoyYonetimSahnesi._bina_dugumu tek satırlık AtolyeParcaciklari.kur çağrısı kullanır. Desteklenmeyen/iskele binalarda efekt kurulmaz; her hazır binada bir helper vardır. Çalışanın mevcut görsel rotası bitmeli ve d.is doğru olmalıdır. ZanaatTezgahi.aday/aktif gerçek reçete girdisi, depo, grev/kaza/kan davasını korur; tarla/bostan yalnız SulamaRutini aşama 1'de, görünür gerçek kova akışının dünya konumundan damlatır. Mevcut grafik adaptörünün düşük profilde kapattığı katman asla tekrar açılmaz. Normal profile dönünce görünür çalışma koşulu yeniden hesaplanır. Görsel RNG sabit bina seed'idir; ekonomik RNG kullanılmaz.

## Formulas
LOD çarpanı = katman 0 veya mesafe ≥ uzak_mesafe ise 0; mesafe ≤ yakin_mesafe ise 1; arada orta_carpan. Parçacık adedi = max(1, ceil(taban adet × LOD)). Denetim kontrol_araligi saniyede bir; sabit CPU simülasyonu fixed_fps. Kameranın arkasındaki, çalışmayan veya uzak efekt emisyonu/çizimi kapatılır.

## Edge Cases
Gece, mola, yürüyüş, girdi kesilmesi, dolu depo veya çalışan kaybında efekt kapanır. İş bittiğinde kalan parçacıklar da gizlenir; uzun dekoratif kuyruk tutmayarak bütçe korunur. Binanın görünümü yeniden kurulunca eski helper/particles bina düğümüyle temizlenir. Duraklatma mevcut sahneyle birlikte durur. Üretim, stok, kayıt, navmesh veya atama değiştirilmez; ikinci sistem/HUD yoktur.

## Dependencies
KoyYonetimSahnesi mevcut bina görünümü; KoyHalkHareketi salt okunur varış durumu, ZanaatTezgahi, SulamaRutini, GrafikProfiliAdaptoru. CPUParticles3D mevcut eski cihaz/Compatibility yolu: https://docs.godotengine.org/en/stable/classes/class_cpuparticles3d.html .

## Tuning Knobs
data/atolye_parcaciklari.json: bina→efekt listesi, LOD mesafeleri, orta oran, denetim aralığı, fixed_fps; efekt bazında adet, yaşam süresi, hız, yayılım, yerçekimi, boyut, renk ve kaynak yüksekliği. Asset üretilmedi/indirilmedi. _yer_tutucu tek değişim noktası; şu an düz renk BoxMesh. Gerçek duman atlası/kıvılcım sprite/su damlası envanter G ANI15-DUMAN/KIVILCIM/SU'da.

## Acceptance Criteria
Gerçek üç bina/çalışan/durakta duman/kıvılcım/su CPU emisyonu, tam/yarım/kapalı uzaklık LOD'si ve eşik sınırları. Gerçek GrafikProfiliAdaptoru düşükte kapalı ve normale dönüşte aktif; girdi bitişi/gece kapanışı ve kayıt/RNG korunumu. Native üç görünüm, ayna import/UI ve eski zanaat/sulama/20 gece testleri geçer.
