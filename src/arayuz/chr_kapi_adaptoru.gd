## Kapı ekranına eklenen küçük bağlantı; JSON ve eski heybe akışı korunur.
extends RefCounted

static func karar_kilidi(dugme: MenuSatiri, sorgu: RefCounted, karar: StringName) -> void:
	if sorgu == null:
		return
	dugme.disabled = not sorgu.karar_acik(karar)
	if dugme.disabled:
		dugme.alt_yazi = "Panik: barışçıl kabul kapalı"
		dugme.tooltip_text = dugme.alt_yazi

static func diyalog_goster(ekran: Control, gelen: Gelen, secenekler: VBoxContainer, eylemler: VBoxContainer) -> bool:
	var sorgu := gelen.chr_sorgusu()
	if sorgu == null:
		return false
	sorgu.tecrube = MuhafizOdaGelisimi.etkin_tecrube(ekran.oturum)
	var o: Oturum = ekran.get("oturum") as Oturum
	if o != null:
		var asker_var: bool = o.yonetim.etkin_muhafiz_sayisi() > 0 or o.yonetim.koylular.any(func(k: Koylu) -> bool: return k.sinif == &"asker" and k.saglik > 0)
		sorgu.zar_baglami = {
			"terazi": MuhafizTerazisi.durum(o),
			"itibar": o.grup_itibari.zar_etkisi(gelen.id),
			"asker": asker_var,
			"kanit": not sorgu.ipuclari.is_empty(),
		}
	preload("res://src/soz/muhafiz_sezgisi.gd").goster(ekran, gelen)
	ekran.call("_chr_tansiyon_degisti", sorgu.tansiyon)
	var animasyon := Callable(ekran, "_chr_tansiyon_degisti")
	if not sorgu.tansiyon_degisti.is_connected(animasyon):
		sorgu.tansiyon_degisti.connect(animasyon)
	var konusma := Callable(ekran, "_chr_replik_basladi")
	if not sorgu.replik_basladi.is_connected(konusma):
		sorgu.replik_basladi.connect(konusma)
	var panel := preload("res://src/arayuz/chr_diyalog_paneli.gd").new()
	panel.sorgu = sorgu
	panel.oturum = ekran.get("oturum") as Oturum
	panel.ayarlar = ekran.get("ayarlar") as Ayarlar
	panel.baglam = gelen.get_meta(&"zar06_baglam", {}).duplicate(true)
	panel.karar_istendi.connect(Callable(ekran, "_karar_goster"))
	secenekler.add_child(panel)
	inceleme_dugmesi(ekran, gelen, eylemler)
	beyan_defteri_dugmesi(ekran, gelen, eylemler, panel)
	return true

static func inceleme_dugmesi(ekran: Control, gelen: Gelen, eylemler: VBoxContainer) -> Button:
	var sorgu := gelen.chr_sorgusu()
	if sorgu == null:
		return null
	var dugme := Button.new()
	dugme.text = "Nişan ve yükü incele"
	dugme.custom_minimum_size.y = 64
	eylemler.add_child(dugme)
	dugme.pressed.connect(func() -> void:
		if ekran.has_node("ChrInceleme"):
			return
		var panel := preload("res://src/arayuz/chr_inceleme_paneli.gd").new()
		panel.name = "ChrInceleme"
		panel.sorgu = sorgu
		ekran.add_child(panel)
		var oturum := ekran.get("oturum") as Oturum
		preload("res://src/debug/ilk_saat_kancasi.gd").arac(oturum, "bakmak")
		MuhafizAdaletYetenekleri.chr_incele(oturum, panel)
		KapiGorusAdaptoru.bagla(panel, ekran)
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").chr_bagla(panel, ekran, gelen)
	)
	return dugme


static func beyan_defteri_dugmesi(ekran: Control, gelen: Gelen, eylemler: VBoxContainer, diyalog_paneli: Control = null) -> Button:
	var sorgu := gelen.chr_sorgusu() if gelen != null else null
	var oturum := ekran.get("oturum") as Oturum
	var motor: SozMotoru = oturum.soz_kaydi.motor if oturum != null and oturum.soz_kaydi != null else null
	var defter: BeyanDefteri = sorgu.beyan_defteri if sorgu != null else (oturum.soz_kaydi.beyanlar if oturum != null and oturum.soz_kaydi != null else null)
	var celiski: RefCounted = sorgu.celiski_durumu if sorgu != null else (motor.celiski() if motor != null else null)
	if sorgu == null and (motor == null or motor.beyan_defteri.is_empty()):
		return null
	if eylemler == null:
		return null
	for c in eylemler.get_children():
		if c.name == "BeyanDefteriDugmesi":
			if not c.is_queued_for_deletion():
				return c as Button
			eylemler.remove_child(c)
	var dugme := Button.new()
	dugme.name = "BeyanDefteriDugmesi"
	dugme.text = "Göster · Beyan Defteri"
	dugme.custom_minimum_size.y = 64
	eylemler.add_child(dugme)
	var defter_tanitimi := preload("res://src/kapi/defter_tanitimi.gd")
	var guncel := func() -> void:
		if not is_instance_valid(dugme):
			return
		var res: Dictionary = defter_tanitimi.oturumda_kontrol_et(oturum, ekran.get("ayarlar") as Ayarlar, celiski, motor, defter, sorgu, ekran)
		dugme.visible = bool(res.get("gorunur", false))
	guncel.call()
	if sorgu != null:
		var cb_ipucu := func(_ip: StringName) -> void: guncel.call()
		var cb_replik := func(_m: String) -> void: guncel.call()
		if sorgu.has_signal("ipucu_bulundu"):
			sorgu.ipucu_bulundu.connect(cb_ipucu)
			dugme.tree_exited.connect(func() -> void:
				if is_instance_valid(sorgu) and sorgu.ipucu_bulundu.is_connected(cb_ipucu):
					sorgu.ipucu_bulundu.disconnect(cb_ipucu)
			)
		if sorgu.has_signal("replik_basladi"):
			sorgu.replik_basladi.connect(cb_replik)
			dugme.tree_exited.connect(func() -> void:
				if is_instance_valid(sorgu) and sorgu.replik_basladi.is_connected(cb_replik):
					sorgu.replik_basladi.disconnect(cb_replik)
			)
	dugme.pressed.connect(func() -> void:
		if ekran.has_node("BeyanDefteriPaneli"):
			return
		var bpanel := preload("res://src/arayuz/kapi/beyan_defteri_paneli.gd").new()
		bpanel.kur({
			"celiski": celiski,
			"motor": motor,
			"defter": defter,
			"sorgu": sorgu,
			"oturum": oturum,
			"gelen_id": String(gelen.id) if gelen != null else "",
		})
		bpanel.yuzlesildi.connect(func(sonuc: Dictionary) -> void:
			guncel.call()
			if ekran.has_method("_yaz"):
				if bool(sonuc.get("basarili", false)):
					ekran.call("_yaz", "[color=#C4843A]%s[/color]" % String(sonuc.get("satir", "Çelişki ortaya çıkarıldı!")))
				else:
					ekran.call("_yaz", "[i]%s[/i]" % String(sonuc.get("tepki", "Ne alakası var bunun?")))
			if diyalog_paneli != null and is_instance_valid(diyalog_paneli) and diyalog_paneli.has_method("guncelle"):
				diyalog_paneli.call("guncelle")
		)
		ekran.add_child(bpanel)
	)
	return dugme
