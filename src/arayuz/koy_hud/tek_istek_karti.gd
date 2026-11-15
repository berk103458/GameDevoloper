## SEV-04: mevcut kart içinde tek cümle ve iki isteğe bağlı cevap.
extends RefCounted
const I = preload("res://src/koy/tek_istek.gd")

static func ekle(e: KoyEkrani, ic: VBoxContainer, k: Koylu) -> void:
	var s := I.konus(e.oturum, k)
	var v := I.tanim(k)
	if s.is_empty() or v.is_empty() or I.metin(s, v).is_empty(): return
	var satir := e._etiket(ic, I.metin(s, v), Tema.KUCUK_PX)
	satir.name = "tek_istek"
	satir.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	satir.set_meta("koylu", k.id)
	if s.durum != "acik": return
	for tut: bool in [true, false]:
		var dugme := e._dugme(TranslationServer.translate("koy.istek.tut" if tut else "koy.istek.birak"), ic)
		dugme.name = "istek_tut" if tut else "istek_birak"
		dugme.pressed.connect(func() -> void:
			I.yanit(e.oturum, k, tut)
			KoyluKarti.ac(e, k.id))

static func yenile(e: KoyEkrani) -> void:
	if not is_instance_valid(e._ust_kart): return
	var satir := e._ust_kart.find_child("tek_istek", true, false) as Label
	if satir == null: return
	I.ilerlet(e.oturum)
	var k := e.oturum.yonetim.koylu(int(satir.get_meta("koylu")))
	if k == null:
		satir.text = ""
	else:
		satir.text = I.metin(I.durum(e.oturum, k), I.tanim(k))
	for ad: String in ["istek_tut", "istek_birak"]:
		var b := e._ust_kart.find_child(ad, true, false) as Button
		if b != null: b.visible = k != null and I.durum(e.oturum, k).get("durum", "") == "acik"
