extends SceneTree
## SOY-28: kaynak satırı gerçek olay kartından okunur. Çevrilmiş cümle karşılaştırılmaz.

var hata := 0


func dene(ok: bool, mesaj: String) -> void:
	if ok:
		return
	hata += 1
	push_error(mesaj)


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	create_timer(60.0).timeout.connect(func() -> void: quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var e: Node = await _ekran(kat)
	await _kaynakli(e, kat)
	await _kaynaksiz(e, kat)
	e.queue_free()
	if hata > 0:
		quit(1)
		return
	print("SOY-28 GECTI")
	quit(0)


## -s koşusunda KoyEkrani tipi Ses autoload'unu derleme anında görmez; ekran çalışma anında yüklenir.
func _ekran(kat: Katalog) -> Node:
	var e: Node = load("res://src/arayuz/koy_ekrani.gd").new()
	e.oturum = Oturum.new(kat, 2801)
	e.ayarlar = Ayarlar.new("user://pusula_kaynak_test.cfg")
	root.add_child(e)
	await process_frame
	return e


func _pusula(kat: Katalog, tohum: int) -> Oturum:
	var o := Oturum.new(kat, tohum)
	var y := o.yonetim
	var b := KoyBinasi.new()
	b.id = 17
	b.tur = "ambar"
	y.binalar.append(b)
	y.kabul({"ad": "Ali"})
	y.kabul({"ad": "Fatma"})
	FisiltiGazetesi.gece(y, [])
	return o


func _kaynakli(e: Node, kat: Katalog) -> void:
	var o := _pusula(kat, 2801)
	var y := o.yonetim
	var olay := FisiltiGazetesi.olay(o)
	dene(olay != null and FisiltiGazetesi.tanimli(olay) and not FisiltiGazetesi.HISTERI.tanimli(olay), "bekleyen pusula")
	if olay == null:
		return
	var konu := int(FisiltiGazetesi.durum(y).kisi)
	var fatma: Koylu = null
	for k in y.koylular:
		if k.ad == "Fatma":
			fatma = k
	dene(fatma != null and fatma.id != konu, "Fatma konu kişiden ayrı")
	if fatma == null:
		return
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	ag.ag_kayitlari["gece_fisilti"] = {
		"kaynak": str(fatma.id),
		"dogru": true,
		"duyanlar": [str(konu)],
		"gece": int(FisiltiGazetesi.durum(y).gun),
	}
	var ana := olay.metin_anahtari
	var secenekler := olay.secenek_anahtarlari.duplicate()
	e.oturum = o
	e._olay_goster(olay, {})
	var etiketler := _etiketler(e)
	dene(etiketler.size() == 1, "kaynakli kartta PusulaKaynak 1")
	if etiketler.is_empty():
		return
	dene(int(etiketler[0].get_meta(&"kaynak_kimligi", -1)) == fatma.id, "etiketteki kaynak Fatma")
	dene(PusulaKaynak.kaynak_kimligi(o, olay) == fatma.id, "kaynak kimligi Fatma")
	dene(String(etiketler[0].get_meta(&"metin_anahtari", "")) == PusulaKaynak.ANAHTAR, "metin anahtari")
	dene(etiketler[0].get_theme_font_size("font_size") == Tema.KUCUK_PX, "kucuk punto")
	dene(olay.metin_anahtari == ana and olay.secenek_anahtarlari == secenekler, "kalip degismedi")
	dene(_govde_duruyor(e, ana), "ana metin kartta")
	dene(_dugme_sayisi(e) == secenekler.size(), "secenek sayisi ayni")


func _kaynaksiz(e: Node, kat: Katalog) -> void:
	var o := _pusula(kat, 2802)
	var olay := FisiltiGazetesi.olay(o)
	dene(olay != null, "kaynaksiz senaryoda pusula")
	if olay == null:
		return
	e.oturum = o
	e._olay_goster(olay, {})
	dene(_etiketler(e).is_empty(), "ag yokken etiket 0")
	dene(not o.has_meta(SoylentiKoprusu.META), "ag kurulmadi")
	dene(PusulaKaynak.satir(o, olay).is_empty() and PusulaKaynak.kaynak_kimligi(o, olay) == -1, "ag yokken kimlik bos")
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	var gun := int(FisiltiGazetesi.durum(o.yonetim).gun)
	var konu := str(int(FisiltiGazetesi.durum(o.yonetim).kisi))
	ag.ag_kayitlari["bos"] = {"kaynak": "", "dogru": true, "duyanlar": [], "gece": gun}
	e._olay_goster(olay, {})
	dene(_etiketler(e).is_empty() and PusulaKaynak.kaynak_kimligi(o, olay) == -1, "kaynaksiz kayitta etiket 0")
	ag.ag_kayitlari.clear()
	ag.ag_kayitlari["yabanci"] = {"kaynak": "99999", "dogru": true, "duyanlar": [konu], "gece": gun}
	e._olay_goster(olay, {})
	dene(_etiketler(e).is_empty(), "koyde olmayan kaynak bos")
	var olu: Koylu = null
	for k in o.yonetim.koylular:
		if k.ad == "Fatma":
			olu = k
	if olu != null:
		olu.saglik = 0
		ag.ag_kayitlari.clear()
		ag.ag_kayitlari["olu"] = {"kaynak": str(olu.id), "dogru": false, "duyanlar": [konu], "gece": gun}
		e._olay_goster(olay, {})
		dene(_etiketler(e).is_empty() and PusulaKaynak.kaynak_kimligi(o, olay) == -1, "olu kaynak bos")


func _etiketler(e: Node) -> Array[Label]:
	var bulunan: Array[Label] = []
	if e._ust_kart == null:
		return bulunan
	for n in e._ust_kart.find_children("PusulaKaynak", "Label", true, false):
		if n is Label and not n.is_queued_for_deletion():
			bulunan.append(n)
	return bulunan


func _dugme_sayisi(e: Node) -> int:
	var n := 0
	if e._ust_kart == null:
		return 0
	for b in e._ust_kart.find_children("*", "Button", true, false):
		if not b.is_queued_for_deletion():
			n += 1
	return n


func _govde_duruyor(e: Node, ana: String) -> bool:
	if e._ust_kart == null:
		return false
	for l in e._ust_kart.find_children("*", "Label", true, false):
		if l.name == "PusulaKaynak" or l.is_queued_for_deletion():
			continue
		if l.text == ana:
			return true
	return false
