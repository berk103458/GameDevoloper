## CAT-02: gerçek ekran düğmeleri, karar bekleme, kilitler ve seçim.
extends "res://tests/unit/kapi/kapi_kavgasi_ekran_test.gd"
const A = preload("res://src/kapi/kapi_kavgasi_adaptoru.gd")

func _ekran() -> bool:
	for id in KapiKavgasi.GECERLI_SECENEKLER:
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
		o.muhafiz_akce = 0
		var k := o.yonetim.kabul({"ad": "nöbetçi", "sinif": "asker"})
		o.yonetim.muhafiz_ata(k.id)
		var g := Gelen.new()
		g.kavga_tip = "genc_erkek"
		g.ad_anahtari = "sablon.esnaf.ad1"
		g.secenekler = PackedStringArray(["ret", "kabul"])
		e._gelen = g
		e._kuyruk.clear()
		e._karar_ver("ret")
		await get_tree().process_frame
		var dugmeler := {}
		for b in e._secenekler.get_children():
			if String(b.name) in KapiKavgasi.GECERLI_SECENEKLER: dugmeler[String(b.name)] = b
		dene(dugmeler.size() == 4 and e.evre == &"kavga", "Dört düğme açık; ziyaretçi gönderilmedi")
		if dugmeler.size() != 4: return false
		dene(dugmeler.akceyle_erteleme.disabled and dugmeler.akceyle_erteleme.text.contains(tr("arayuz.kavga.akce_yetersiz")), "Akçe kilidinin nedeni ekranda")
		dene(e.get_viewport().gui_get_focus_owner() != null, "Panelde klavye/gamepad odağı var")
		o.muhafiz_akce = 9
		o.yonetim.nobet_degisti.emit()
		dene(not dugmeler.akceyle_erteleme.disabled, "Güncel oturum bakiyesi okunur")
		if id == "reddetme":
			o.yonetim.bosalt(k.id)
			dene(not dugmeler.askerle_karsilik.visible and not dugmeler.reddetme.disabled, "Asker ayrılınca diğer üç yol kalır")
		dugmeler[id].pressed.emit()
		dugmeler[id].pressed.emit()
		dene(A.al(o).son.get("secenek", "") == id and e.evre != &"kavga", "Gerçek düğme oturum sonucuna bağlandı: " + id)
		if id == "akceyle_erteleme":
			dene(o.muhafiz_akce == 7 and o.soz_kaydi.sozler.acik_sayisi() == 1, "İki tık tek ödeme ve söz")
		ana.queue_free()
		await get_tree().process_frame
	return true

func dene(v: bool, metin: String) -> void:
	if not v:
		hata += 1
		push_error(metin)
