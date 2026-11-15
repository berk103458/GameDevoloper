## SEV-03: mevcut Clue eşyasını kadro kaydı ve gerçek köy kadrajına bağlar.
extends RefCounted

static func karar(o: Oturum, g: Gelen, karar_adi: StringName) -> void:
	if not g.adli: return
	var d: Dictionary = o.kadro.durumlar.get(g.id, {})
	d.erase("kisisel_iz")
	if karar_adi == &"rusvet": return
	var s := g.chr_sorgusu()
	if s != null and karar_adi in [&"kabul", &"harc"]:
		for esya in s.karakter.karar_verisi(&"kabul").get("esyalar", []):
			if String(esya).begins_with("Clue_"): continue
			o.muhafiz_esyalari.append({"kaynak": String(esya), "adet": 1, "edinim": "gonullu"})
	if karar_adi not in [&"kabul", &"harc"] or s == null or not s.bayraklar.get("Flag_Sir_Tamamen_Cozuldu", false): return
	var clue := String(s.karakter.obje_1.get("uretilen_ipucu", ""))
	if clue.begins_with("Clue_") and not odada(o, clue):
		var yuz := SevilenYuz.new()
		yuz.kisisel_iz_birak(String(g.id), clue)
		d["kisisel_iz"] = yuz.kisisel_izler[String(g.id)]

static func odada(o: Oturum, clue: String) -> bool:
	for esya in o.muhafiz_esyalari:
		if int(esya.get("adet", 0)) > 0 and String(esya.get("id", esya.get("kaynak", ""))) == clue: return true
	return false

static func kelime(clue: String) -> String:
	return TranslationServer.translate("arayuz.koy.iz_kurdele" if clue == "Clue_CHR017_Kurdele" else "arayuz.koy.iz_hatira")

static func raf_etiketi(esya: Dictionary) -> String:
	match String(esya.get("edinim", "")):
		"rusvet": return TranslationServer.translate("arayuz.oda.etiket_eksi")
		"gonullu": return TranslationServer.translate("arayuz.oda.etiket_sicak")
	return ""

static func yer(o: Oturum, k: Koylu) -> KoyBinasi:
	var y := o.yonetim
	var b := y.bina(k.is_yeri)
	if b != null: return b
	for aday in y.binalar:
		if aday.hazir() and aday.tur in MeslekUyumu.UYGUN.get(k.zanaat_turu, []): return aday
	return y.bina(k.ev)

static func iz(o: Oturum, k: Koylu) -> String:
	var d: Dictionary = o.kadro.durumlar.get(k.adli_id, {})
	if k.saglik <= 0 or String(d.get("durum", "")) != "koyde":
		d.erase("kisisel_iz")
		return ""
	var clue := String(d.get("kisisel_iz", ""))
	if odada(o, clue):
		d.erase("kisisel_iz")
		return ""
	return clue

static func yenile(e: Node) -> void:
	if e.sahne3b == null: return
	var grup := e.sahne3b.get_node_or_null("kisisel_izler") as Node3D
	if grup == null:
		grup = Node3D.new()
		grup.name = "kisisel_izler"
		e.sahne3b.add_child(grup)
	# Köy listesinden düşmüş kişi de kadroda artık iz taşımaz.
	for id in e.oturum.kadro.durumlar:
		var d: Dictionary = e.oturum.kadro.durumlar[id]
		if not d.has("kisisel_iz"): continue
		var mevcut := false
		for k in e.oturum.yonetim.koylular:
			if k.adli_id == id and k.saglik > 0: mevcut = true
		if not mevcut: d.erase("kisisel_iz")
	var kalan: Array[String] = []
	for k in e.oturum.yonetim.koylular:
		var clue := iz(e.oturum, k)
		var b := yer(e.oturum, k)
		if clue.is_empty() or b == null: continue
		var ad := "iz_%d" % k.id
		kalan.append(ad)
		var n := grup.get_node_or_null(ad) as MeshInstance3D
		if n == null:
			n = MeshInstance3D.new()
			n.name = ad
			var kutu := BoxMesh.new()
			kutu.size = Vector3(0.3, 0.3, 0.3)
			n.mesh = kutu
			var renk := StandardMaterial3D.new()
			renk.albedo_color = Color(0.65, 0.3, 0.35)
			n.material_override = renk
			grup.add_child(n)
			var etiket := Label3D.new()
			etiket.name = "etiket"
			etiket.position.y = 0.45
			etiket.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			n.add_child(etiket)
		(n.get_node("etiket") as Label3D).text = kelime(clue)
		n.set_meta("clue", clue)
		n.set_meta("bina", b.id)
		# Yapı modelinin içine gömülmesin: sağ dış kenardaki hücrede, zemin üstünde.
		var boyut := b.boyut(e.oturum.yonetim.katalog)
		n.position = e.sahne3b.alan_merkezi(b.hucre + Vector2i(boyut.x, 0), Vector2i.ONE) + Vector3(0, 0.2, 0)
	for n in grup.get_children():
		if String(n.name) not in kalan:
			grup.remove_child(n)
			n.queue_free()
