## SAH-55 (Claude-Berk): ZAR-03 kaçışında kamera ışınlanmaz; kaçan kişi kadrajdan yürür (en az 1 sn).
## Gerçek yol: KapiEkrani + KapiSahnesi.gelen_yaklas → TansiyonKacisAkisi.ekranda (CHR panelinin
## kacis_istendi sinyalinin çağırdığı fonksiyon) → sahne.gelen_git → kişi geri yürür. Kare kare ölçülür.
extends Node

const DT := 0.05
const SURE := 3.0
const ISINLANMA := 0.4 # 0.05 sn'de kameranın bundan fazla yer değiştirmesi ışınlanmadır.

var hata := 0


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 641)
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var a := Ayarlar.new("user://sah55_unused.cfg")
	kok.theme = Tema.olustur(a)
	add_child(kok)
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = a
	kok.add_child(e)
	await get_tree().process_frame
	var g := o._adli_gelen(&"chr_001")
	e._gelen = g
	e.evre = &"sohbet"
	await e.sahne.gelen_yaklas(e._model_adi(g))
	var model: KarakterModel = e.sahne._gelen
	var kamera: Camera3D = e.sahne.kamera
	_kontrol(model != null and KapiKameraVurgu.kadrajda_mi(kamera, model.global_position), "Gelen kapıda ve kadrajda")
	if model == null:
		get_tree().quit(1)
		return
	var bas_konum := model.global_position
	var ret_once := o.yonetim.ret_sayisi
	_kacis(e)
	var kadraj_sure := 0.0
	var kadrajda_yurudu := false
	var en_buyuk_adim := 0.0
	var onceki := kamera.global_position
	var t := 0.0
	while t < SURE:
		await get_tree().create_timer(DT).timeout
		t += DT
		en_buyuk_adim = maxf(en_buyuk_adim, kamera.global_position.distance_to(onceki))
		onceki = kamera.global_position
		if not is_instance_valid(model) or not model.visible:
			break
		if not KapiKameraVurgu.kadrajda_mi(kamera, model.global_position):
			break
		kadraj_sure += DT
		if model.global_position.distance_to(bas_konum) > 0.5:
			kadrajda_yurudu = true
	_kontrol(e.get_meta(&"sonuclanan_gelen", null) == g and o.yonetim.ret_sayisi == ret_once, "Kaçış ziyareti kapattı, ret yazmadı")
	_kontrol(kadraj_sure >= 1.0, "SAH-55: kaçan kişi kadrajda %.2f sn (>= 1)" % kadraj_sure)
	_kontrol(kadrajda_yurudu, "SAH-55: kişi kadrajın içinde yürüyerek uzaklaşıyor")
	_kontrol(en_buyuk_adim < ISINLANMA, "SAH-55: kamera ışınlanmıyor (en büyük adım %.3f m / %.2f sn)" % [en_buyuk_adim, DT])
	print("SAH-55 KAÇIŞ KADRAJ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(1 if hata > 0 else 0)


func _kacis(e: KapiEkrani) -> void:
	preload("res://src/kapi/tansiyon_kacis_akisi.gd").ekranda(e)
