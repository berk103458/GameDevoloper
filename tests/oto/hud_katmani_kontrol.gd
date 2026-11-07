## OGR-30: Gerçek köy ekranında aynı tohum, iki açılış ve bir kayıt dönüşü.
extends Node

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const TOHUM := 1401
const GECE_SAYISI := 6
var _katalog: Katalog
var _ayarlar := Ayarlar.new()
var _yuzey: Control

func _ready() -> void:
	call_deferred("_dene")

func _dene() -> void:
	TranslationServer.set_locale("tr")
	_katalog = Katalog.new()
	_katalog.yukle()
	_yuzey = Control.new()
	_yuzey.theme = Tema.olustur(_ayarlar)
	add_child(_yuzey)
	var ilk := await _kos(false)
	var ikiz := await _kos(true)
	var tamam := ilk.size() == GECE_SAYISI + 1 and ilk == ikiz
	if tamam:
		tamam = ("kaynak_gostergesi.gd:kereste" not in ilk[0]
			and "kaynak_gostergesi.gd:kereste" in ilk[1]
			and "kese_gostergesi.gd:ana" not in ilk[1]
			and "kese_gostergesi.gd:ana" in ilk[2]
			and "kaynak_gostergesi.gd:afyon" not in ilk[2]
			and "kaynak_gostergesi.gd:afyon" in ilk[3]
			and "harita_baglantisi.gd:ana" not in ilk[2]
			and "harita_baglantisi.gd:ana" in ilk[3]
			and "muhafiz_odasi_baglantisi.gd:ana" not in ilk[5]
			and "muhafiz_odasi_baglantisi.gd:ana" in ilk[6])
	if not tamam: push_error("HUD katmanı kayıt ikizi ayrıştı: %s / %s" % [ilk, ikiz])
	print("HUD KATMANI KAYIT İKİZİ: %s" % ("GEÇTİ" if tamam else "KALDI"))
	get_tree().quit(0 if tamam else 1)

func _kos(yuklemeli: bool) -> Array[PackedStringArray]:
	var o := Oturum.new(_katalog, TOHUM)
	ACILIS.kur(o)
	var e := _ekran(o)
	var gunluk: Array[PackedStringArray] = []
	for gun in range(GECE_SAYISI + 1):
		if e.hud == null or o.gun != gun: break
		var panel_kaydi := PackedStringArray()
		for n in e.find_children("*", "Control", true, false):
			if n.has_meta(&"hud_katmani") and n.is_visible_in_tree():
				panel_kaydi.append(String(n.get_meta(&"hud_katmani")))
		gunluk.append(panel_kaydi)
		if gun == GECE_SAYISI: break
		if gun == 0:
			KAPI.baslat(o)
			KAPI.ulak_bitir(o)
			var kuyruk := KAPI.kuyruk(o)
			if kuyruk.is_empty(): break
			o.karar_ver(kuyruk[0], &"kabul")
		var gece := o.gece_sonu()
		if gece.get("engellendi", false): break
		var ziyaretciler: Array[Gelen] = []
		TuccarKapiGecisi.ekle(o, ziyaretciler)
		if yuklemeli and gun == 1:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			e.free()
			e = null
			o = Oturum.kayittan(_katalog, veri)
			if o == null: break
			e = _ekran(o)
		else:
			e.hud.guncelle()
		await get_tree().process_frame
	if is_instance_valid(e): e.free()
	await get_tree().process_frame
	return gunluk

func _ekran(o: Oturum) -> KoyEkrani:
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = _ayarlar
	_yuzey.add_child(e)
	return e
