extends SceneTree

var _hata := 0


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("CIL-06 HATA: " + mesaj)


var _s: KoyYonetimSahnesi


func _initialize() -> void:
	var kat := BinaKatalogu.new()
	_s = KoyYonetimSahnesi.new()
	_s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), kat, 42)
	get_root().add_child(_s)
	call_deferred("_calistir")


func _calistir() -> void:
	var s := _s

	# 1) Degirmen üstünde prosedürel ikinci kulübe yok ve O76 su değirmeni modeli yüklü.
	var deg_b := KoyBinasi.new()
	deg_b.id = 1
	deg_b.tur = "degirmen"
	deg_b.hucre = Vector2i(3, 3)
	deg_b.insa_kalan = 0
	s.yonetim.binalar.append(deg_b)
	s.yenile()
	var deg_node := _bina_bul(s, 1)
	_dogrula(deg_node != null, "degirmen düğümü oluştu")
	if deg_node != null:
		var parcalar: Array[String] = []
		for m in deg_node.find_children("*", "MeshInstance3D", true, false):
			var mesh_inst := m as MeshInstance3D
			if mesh_inst.mesh is BoxMesh:
				parcalar.append(String(mesh_inst.name))
		_dogrula(deg_node.get_node_or_null("degirmen_kulube") == null and deg_node.get_node_or_null("cati") == null, "degirmen üstünde ikinci prosedürel kulübe yok")
		_dogrula(deg_node.find_child("meshy_o76_su_degirmeni", true, false) != null, "degirmen O76 görseli aktif (prosedürel barakasız)")

	# 2) Agil üzerinde çakışan tam prosedürel iç çit yok, agil_kapisi var.
	var agil_b := KoyBinasi.new()
	agil_b.id = 2
	agil_b.tur = "agil"
	agil_b.hucre = Vector2i(8, 3)
	agil_b.insa_kalan = 0
	s.yonetim.binalar.append(agil_b)
	s.yenile()
	var agil_node := _bina_bul(s, 2)
	_dogrula(agil_node != null, "agil düğümü oluştu")
	if agil_node != null:
		_dogrula(agil_node.get_node_or_null("meshy_agil") != null, "meshy_agil yüklendi")
		_dogrula(agil_node.get_node_or_null("agil_kapisi") != null, "agil_kapisi korundu")

	# 3) Gozcu Kulesi S1 A113 -> S2 O72 -> S3 gozetleme_kulesi.
	var kule_b := KoyBinasi.new()
	kule_b.id = 3
	kule_b.tur = GozcuKulesi.TUR
	kule_b.hucre = Vector2i(14, 3)
	kule_b.insa_kalan = 0
	kule_b.seviye = 1
	s.yonetim.binalar.append(kule_b)
	s.yenile()
	var k1 := _bina_bul(s, 3)
	_dogrula(k1 != null and k1.get_node_or_null("meshy_td_a113") != null, "Gözcü kulesi S1 = td_a113")
	kule_b.seviye = 2
	s.yenile()
	var k2 := _bina_bul(s, 3)
	_dogrula(k2 != null and k2.get_node_or_null("meshy_td_o72") != null, "Gözcü kulesi S2 = td_o72")
	kule_b.seviye = 3
	s.yenile()
	var k3 := _bina_bul(s, 3)
	_dogrula(k3 != null and k3.get_node_or_null("meshy_gozetleme_kulesi") != null, "Gözcü kulesi S3 = gozetleme_kulesi")

	# 4) Han S1 pazar_tezgahi -> S2 kervansaray.
	var han_b := KoyBinasi.new()
	han_b.id = 4
	han_b.tur = "han"
	han_b.hucre = Vector2i(3, 10)
	han_b.insa_kalan = 0
	han_b.seviye = 1
	s.yonetim.binalar.append(han_b)
	s.yenile()
	var h1 := _bina_bul(s, 4)
	_dogrula(h1 != null and h1.get_node_or_null("meshy_pazar_tezgahi") != null, "Han S1 = pazar_tezgahi")
	han_b.seviye = 2
	s.yenile()
	var h2 := _bina_bul(s, 4)
	_dogrula(h2 != null and h2.get_node_or_null("meshy_kervansaray") != null, "Han S2 = kervansaray")

	# 5) Sur ve kapi S1 -> S2 -> S3 yükseltme modelleri.
	s.yonetim.sur_seviye = 1
	s.yenile()
	_dogrula(s._yapilar.find_child("sur_kapisi_td_o25", true, false) != null, "Sur S1 kapı = td_o25")
	_dogrula(s._yapilar.find_child("sur_kazik_cit", true, false) != null, "Sur S1 duvar = kazik_cit (O37)")
	s.yonetim.sur_seviye = 2
	s.yenile()
	_dogrula(s._yapilar.find_child("sur_kapisi_kapi", true, false) != null, "Sur S2 kapı = kapi")
	_dogrula(s._yapilar.find_child("sur_td_o81", true, false) != null, "Sur S2 duvar = td_o81")
	s.yonetim.sur_seviye = 3
	s.yenile()
	_dogrula(s._yapilar.find_child("sur_kapisi_td_o92", true, false) != null, "Sur S3 kapı = td_o92")
	_dogrula(s._yapilar.find_child("sur_td_o90", true, false) != null, "Sur S3 duvar = td_o90")

	# 6) Demirhanede beyaz MegaKit plaster sacak yok.
	var dem_b := KoyBinasi.new()
	dem_b.id = 5
	dem_b.tur = "demirhane"
	dem_b.hucre = Vector2i(14, 10)
	dem_b.insa_kalan = 0
	s.yonetim.binalar.append(dem_b)
	s.yenile()
	var dem_node := _bina_bul(s, 5)
	_dogrula(dem_node != null and dem_node.get_node_or_null("hava_sacagi_hazir") == null, "Demirhanede beyaz MegaKit saçağı konmadı")

	print("CIL-06 YAPI YÜKSELTME: GEÇTİ" if _hata == 0 else "CIL-06 YAPI YÜKSELTME: KALDI (%d hata)" % _hata)
	quit(0 if _hata == 0 else 1)


func _bina_bul(s: KoyYonetimSahnesi, id: int) -> Node3D:
	for c in s._yapilar.get_children():
		if int(c.get_meta("bina_id", -1)) == id and not c.is_queued_for_deletion():
			return c as Node3D
	return null
