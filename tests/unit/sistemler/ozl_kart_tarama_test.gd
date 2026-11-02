extends SceneTree

const OlayOnKosulu = preload("res://src/sistemler/olay_on_kosulu.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OZL KART TARAMA TEST HATASI: " + mesaj)


func _dosyalari_tara(klasor: String, aranan_ad: String) -> int:
	var sayac := 0
	var dir := DirAccess.open(klasor)
	if dir == null:
		return 0
	dir.list_dir_begin()
	var ad := dir.get_next()
	while not ad.is_empty():
		if ad != "." and ad != "..":
			var tam_yol := klasor.path_join(ad)
			if dir.current_is_dir():
				sayac += _dosyalari_tara(tam_yol, aranan_ad)
			elif ad.to_lower() == aranan_ad.to_lower():
				sayac += 1
		ad = dir.get_next()
	dir.list_dir_end()
	return sayac


func _initialize() -> void:
	# OZL-01: olay_secici adli ikinci dosya 0 olmali; mevcut Oturum.olay_sec BUG-16 ve KAP-19 ile calisir
	var ikinci_secici_sayisi := _dosyalari_tara("res://src", "olay_secici.gd")
	_kontrol(ikinci_secici_sayisi == 0, "src/ altinda olay_secici.gd adli ikinci dosya 0 olmali")

	var kat := Katalog.new()
	kat.yukle()
	var oturum := Oturum.new(kat, 42)
	_kontrol(not OlayOnKosulu.uygun(oturum, {"cocuk_var": true}), "Cocuksuz koyde cocuk_var kosulu BUG-16 ile false donmeli")
	_kontrol(not OlayOnKosulu.havuzda(oturum, &"dugun"), "Kucuk haneli koyde dugun KAP-19 havuzunda olmamali")

	if _hata == 0:
		print("OZL KART TARAMA: GEÇTİ (0 hata)")
	else:
		print("OZL KART TARAMA: KALDI (%d hata)" % _hata)
	quit(_hata)
