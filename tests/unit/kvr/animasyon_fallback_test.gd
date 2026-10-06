extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var model := KarakterModel.new()
	root.add_child(model)
	var govde := Node3D.new()
	var oynatici := AnimationPlayer.new()
	govde.add_child(oynatici)
	# Boş oynatıcı kurulumda indeks hatası üretmez.
	model.kur(govde)
	model._klip_oynat("eksik")
	model.dur()
	var kitap := AnimationLibrary.new()
	kitap.add_animation(&"idle", Animation.new())
	kitap.add_animation(&"walk", Animation.new())
	oynatici.add_animation_library(&"", kitap)
	model._anim = "walk"
	model._klipler["bekle"] = "silinmis_bekle"
	model._klipler["ofke"] = "silinmis_ofke"
	_kontrol(not model.hareket_var("ofke"), "Bozuk klip eşlemesi var sayılmaz")
	model._klip_oynat("ofke")
	_kontrol(oynatici.current_animation == "idle", "Eksik hareket gerçek idle'a döner")
	model._klipler["konus"] = "walk"
	model._klip_oynat("konus")
	_kontrol(oynatici.current_animation == "walk" and oynatici.speed_scale == 1.0, "Geçerli hareket aynen oynar")
	model.gergin()
	_kontrol(oynatici.current_animation == "idle", "Eksik gerginlik idle'a döner")
	kitap.remove_animation(&"idle")
	model.dur()
	_kontrol(oynatici.current_animation == "walk" and oynatici.speed_scale == 0.0, "Idle yoksa ilk pozda güvenli duruş")
	var ek_kitap := AnimationLibrary.new()
	ek_kitap.add_animation(&"Idle", Animation.new())
	oynatici.add_animation_library(&"diger", ek_kitap)
	model.dur()
	_kontrol(oynatici.current_animation == "diger/Idle", "Adlı kitaplıktaki idle da bulunur")
	var yol := "res://assets/model/karakter/olmayan_animasyon.res"
	_kontrol(KarakterModel._klip_al(yol) == null and KarakterModel._klip_onbellek.has(yol), "Eksik dosya güvenli negatif önbellek")
	KarakterModel._klip_onbellek[yol] = "bozuk"
	_kontrol(KarakterModel._klip_al(yol) == null, "Bozuk önbellek Animation diye dönmez")
	KarakterModel._klip_onbellek.erase(yol)
	oynatici.free()
	model._klip_oynat("konus")
	_kontrol(not model.hareket_var("konus"), "Silinen oynatıcı güvenle atlanır")
	model.free()
	await process_frame
	print("ANİMASYON FALLBACK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
