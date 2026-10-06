## Görev adaptörü: kabul sayacı, erzak eşiği, usta_ciftci, JSON kayıt, eksik tekil.
##   godot --headless --path . -s tests/unit/gorev/gorev_adaptoru_test.gd
extends SceneTree

var _hata := 0
var _k: Katalog


func _initialize() -> void:
	_k = Katalog.new()
	if _k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", _k.hatalar)
		quit(1)
		return
	_esit("tekil yokken paket boş", GorevAdaptoru._paketle(null).is_empty(), true)
	_esit("KAYIT_SURUMU 2", Oturum.KAYIT_SURUMU, 2)
	_kabul()
	_erzak()
	_bayrak()
	print("GOREV ADAPTOR TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _kabul() -> void:
	GorevAdaptoru.sifirla()
	var o := Oturum.new(_k, 11)
	o.karar_ver(_gelen(), &"kabul")
	o.karar_ver(_gelen(), &"kabul")
	_esit("iki kabul bitirmez", _bitti("quest_gate_admit_three"), false)
	o.karar_ver(_gelen(), &"kabul")
	_esit("üç kabul bitirir", _bitti("quest_gate_admit_three"), true)
	_esit("erzak henüz bitmedi", _bitti("quest_granary_food_36"), false)
	_esit("bayrak henüz bitmedi", _bitti("quest_zeynep_usta_ciftci"), false)
	_esit("kabul sayacı", o.yonetim.kabul_sayisi, 3)


func _erzak() -> void:
	GorevAdaptoru.sifirla()
	var o := Oturum.new(_k, 12)
	var y := o.yonetim
	y.kaynaklar.stok["gida"] = 36 + y.nufus() * y.a.gida_kisi
	o.gece_sonu()
	_esit("gece sonrası erzak eşiği", y.kaynaklar.miktar("gida") >= 36, true)
	_esit("erzak görevi bitti", _bitti("quest_granary_food_36"), true)
	_esit("erzak kabul görevini bitirmez", _bitti("quest_gate_admit_three"), false)
	var kayit := o.kaydet()
	_esit("kayıtta koy_akce yok", kayit.has("koy_akce"), false)
	_esit("kayıtta muhafiz_akce yok", kayit.has("muhafiz_akce"), false)
	_esit("sürüm hâlâ 2", int(kayit["surum"]), 2)


func _bayrak() -> void:
	GorevAdaptoru.sifirla()
	var o := Oturum.new(_k, 13)
	var g := _gelen()
	g.acik_bayraklar = PackedStringArray(["usta_ciftci"])
	o.karar_ver(g, &"ret")
	_esit("sorulan bayrak görevi bitirir", _bitti("quest_zeynep_usta_ciftci"), true)
	_esit("ret köylü yazmaz", o.yonetim.nufus(), 0)
	_esit("oturum bayrağı yazılmadı", o.bayraklar.has(StringName("usta_ciftci")), false)
	for yasak in ["baci_tezgah", "dervis", "miraen_sadik", "turkmen_kin", "thessra_kirgin"]:
		_esit("SYS-18 yazılmadı: " + yasak, o.bayraklar.has(StringName(yasak)), false)
	var ham: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	_esit("json gorev anahtarı", ham.has("gorev"), true)
	var z := Oturum.kayittan(_k, ham)
	_esit("yükleme sonrası bayrak görevi durur", _bitti("quest_zeynep_usta_ciftci"), true)
	_esit("yükleme nüfusu", z.yonetim.nufus(), o.yonetim.nufus())
	ham.erase("gorev")
	Oturum.kayittan(_k, ham)
	_esit("gorevsiz kayıt denemeleri açar", _bitti("quest_zeynep_usta_ciftci"), false)
	_esit("gorevsiz kayıt kabul görevini açar", _aktif("quest_gate_admit_three"), true)
	var yine := _gelen()
	o.karar_ver(yine, &"ret")
	_esit("çıplak ret bitmiş görevi silmez", _bitti("quest_zeynep_usta_ciftci"), false)
	g.acik_bayraklar = PackedStringArray(["usta_ciftci"])
	o.karar_ver(g, &"ret")
	_esit("yeniden açılan bayrak yine biter", _bitti("quest_zeynep_usta_ciftci"), true)
	o.karar_ver(_gelen(), &"ret")
	_esit("sonraki ret havuzu silmez", _bitti("quest_zeynep_usta_ciftci"), true)


func _gelen() -> Gelen:
	var g := Gelen.new()
	g.ad_anahtari = "deneme"
	g.sinif = &"ciftci"
	g.stat = 5
	g.secenekler = PackedStringArray(["kabul", "ret"])
	return g


func _bul(slug: String) -> GorevKaydi:
	var s := _sistem()
	if s == null:
		return null
	var hepsi: Array = []
	hepsi.append_array(s.get_active_quests())
	hepsi.append_array(s.get("completed").get_all_quests())
	hepsi.append_array(s.get_available_quests())
	for q in hepsi:
		if q is GorevKaydi and (q as GorevKaydi).slug == slug:
			return q
	return null


func _bitti(slug: String) -> bool:
	var s := _sistem()
	if s == null:
		return false
	var g := _bul(slug)
	return g != null and s.is_quest_completed(g)


func _aktif(slug: String) -> bool:
	var s := _sistem()
	if s == null:
		return false
	var g := _bul(slug)
	return g != null and s.is_quest_active(g)


func _sistem() -> Node:
	if root == null:
		return null
	return root.get_node_or_null("QuestSystem")


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
