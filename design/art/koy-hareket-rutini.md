# Köylü hareketi — görsel plan madde 3, ilk uygulama

Gündüz hazır işyerine veya muhafız kapı durağına yürüyüş; iş süresi sonunda meydanda kısa dinlenme; gece atanmış evin çevresine dönüş. Evsiz ve işsiz köylüler meydanda kalır. Akşam fazı meydanda toplanmayı seçer. Bu görünüm üretim, kabul, konut ataması ve kayıt kurallarını değiştirmez.

`data/koy_hareket.json` görsel hız ve süreleri belirler: 1.6 m/s, kimliğe göre ±%15 hız farkı, 45 saniye iş ve 12 saniye dinlenme. Bunlar denge değerleri değil, sahne ritmi için ilk ayarlardır. Oyun hızı ve duraklama mevcut Godot zaman ölçeğini kullanır.

Izgara dört komşuyla AStar3D grafiğine çevrilir. Yapı ve arazi engelleri kapalıdır; yollar ve meydan 1, açık zemin 2.5 maliyetlidir. Bina merkezine rota kurulmaz, erişilebilir çevre hücresi seçilir. Kopuk hedefte karakter bulunduğu alanda bekler. Her karede en fazla beş yeni rota hesaplanır. Yenilemede köylü kimliği ve konumu korunur; yeni yapı karakterin hücresini kapatmışsa en yakın açık hücreye alınır.

API kaynağı: [Godot AStar3D](https://docs.godotengine.org/en/stable/classes/class_astar3d.html). Kabul kanıtı: `production/qa/evidence/koy-hud/README.md`.

Sonraki kapsam: kalabalık kaçınması, meydana ait mobilyaların engel maskesi, mesleğe özgü aletler ve hareketler; uzak köylüler için animasyon güncelleme bütçesi. Mevcut uygulamada durak farkları üst üste binmeyi azaltır, tam kalabalık çarpışması sağlamaz.
