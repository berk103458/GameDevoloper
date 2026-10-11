## TEK-13/14/15: mevcut Ana geçişi, beş cache ve sabit ses havuzu.
extends Node
class CacheYoklama extends RefCounted:
	var sayac: Dictionary
	func _init(s: Dictionary) -> void: sayac = s
	func _notification(olay: int) -> void:
		if olay == NOTIFICATION_PREDELETE: sayac.adet += 1
var hata := 0
func _ready() -> void:
	get_tree().create_timer(70.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana: Ana = load("res://src/arayuz/ana.tscn").instantiate()
	add_child(ana)
	while ana.katalog == null or ana._ekran == null:
		await get_tree().process_frame
	ana.oturum = Oturum.new(ana.katalog, 131415)
	ana.ayarlar.degerler[&"grafik_profili"] = &"dusuk"
	var once := JSON.stringify(ana.oturum.kaydet())
	var ses := get_tree().root.get_node("Ses")
	var havuz: Array = ses._efektler.duplicate()
	var sayac := {"adet": 0}
	for i in 3:
		var ekran := Control.new()
		var kisi := Dunya3B.karakter("chr_001")
		ekran.add_child(kisi)
		var klip_adet := kisi._oynatici.get_animation_list().size()
		_yoklama_koy(sayac)
		kontrol(ses.oynat(&"sfx_onay"), "Mevcut havuzda geçiş öncesi gerçek efekt")
		ana._goster(ekran)
		kontrol(sayac.adet == i + 1, "Düşük sahne geçişi cache referansını bir kez bırakır")
		kontrol(Dunya3B._onbellek.is_empty() and Pbr._onbellek.is_empty(), "Geçiş sonunda cache boş")
		var ara := {"adet": 0}
		_yoklama_koy(ara)
		await get_tree().process_frame
		await get_tree().process_frame
		kontrol(ara.adet == 0, "Ertelenmiş efekt taraması ikinci memory_free çağırmaz")
		Sanat._onbellek.erase("tek_yoklama")
		kontrol(kisi._oynatici.get_animation_list().size() == klip_adet, "Aktif karakter klipleri güçlü referanslarıyla korunur")
		kontrol(ses._efektler == havuz and ses._sira == 0, "Geçişte aynı havuz ve temiz sıra, ikinci havuz yok")
		for o in ses._efektler:
			kontrol(not o.playing and o.stream == null, "Geçiş önceki sahnenin efektini bırakır")
		for p in ana.find_children("*", "PerformansSeridi", true, false):
			kontrol(not p.visible and not p.is_processing(), "Düşük profil performans şeridini açmaz")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Sahne temizliği ekonomi/RNG/kayıt değiştirmez")
	ana.queue_free()
	await get_tree().process_frame
	print("BELLEK SAHNE GEÇİŞİ: GEÇTİ" if hata == 0 else "BELLEK SAHNE GEÇİŞİ: KALDI")
	await Ses.cik(hata)
func _yoklama_koy(s: Dictionary) -> void:
	Sanat._onbellek["tek_yoklama"] = CacheYoklama.new(s)
func kontrol(ok: bool, ad: String) -> void:
	if not ok:
		hata += 1
		push_error(ad)
