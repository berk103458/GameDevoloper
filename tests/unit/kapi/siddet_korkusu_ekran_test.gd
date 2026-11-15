extends "res://tests/unit/kapi/kapi_kavgasi_ekran_test.gd"
const A = preload("res://src/kapi/kapi_kavgasi_adaptoru.gd")
const S = preload("res://src/kapi/siddet_korkusu_adaptoru.gd")

func _ekran() -> bool:
	var ana := TestAna.new()
	add_child(ana)
	ana.ayarlar.degerler[&"karar_onayi"] = false
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	await get_tree().process_frame
	var o := ana.oturum
	var k := o.yonetim.kabul({"ad": "nöbetçi", "sinif": "asker"})
	o.yonetim.muhafiz_ata(k.id)
	var tanik := o._adli_gelen(&"chr_001")
	tanik.chr_sorgusu().tansiyon = 10
	e._kuyruk.assign([tanik])
	e.sahne.kuyruk_doldur([e._model_adi(tanik)])
	var g := Gelen.new()
	g.kavga_tip = "genc_erkek"
	g.ad_anahtari = "sablon.esnaf.ad1"
	g.secenekler = PackedStringArray(["ret", "kabul"])
	e._gelen = g
	ana._duraklat()
	dene(S.al(o).motor.menu_acik_mi(), "Gerçek duraklat menüsü motoru dondurur")
	ana._ust_kapat()
	dene(not S.al(o).motor.menu_acik_mi(), "Gerçek menü kapanışı çözer")
	e._karar_ver("ret")
	await get_tree().process_frame
	for b in e._secenekler.get_children():
		if String(b.name) == "askerle_karsilik": b.pressed.emit()
	dene(e._kuyruk.is_empty(), "Gerçek panel seçimi gerçek ekran kuyruğunu boşaltır")
	dene(e.sahne.kuyruk_sayilari() == Vector2i.ZERO, "Görünür sıra da boşalır")
	dene(e._kayit.get_parsed_text().contains(tr("anlati.kavga.sira_ayrildi") % 1), "Ayrılma oyuncuya yazılır")
	ana.queue_free()
	await get_tree().process_frame
	return true

func dene(v: bool, metin: String) -> void:
	if not v:
		hata += 1
		push_error(metin)
