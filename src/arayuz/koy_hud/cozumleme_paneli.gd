## YAP-05: mevcut yapı bilgi kartında tek araştırma/kuyruk; yeni ekran yok.
extends RefCounted
const C = preload("res://src/koy/cozumleme.gd")
const D = preload("res://src/koy/usta_defterleri.gd")
const KAPI = preload("res://src/arayuz/koy_atama_kapisi.gd")
const IKON_DEFTER := "res://assets/art/icons/icon_usta_defteri.png"
static func _t(anahtar: String, degerler: Array = []) -> String:
	var key := "koy.cozumleme." + anahtar
	var metin := TranslationServer.translate(key)
	if metin == key or metin.strip_edges().is_empty(): metin = GuvenliMetin.metin(key)
	if metin.begins_with(GuvenliMetin.YOK): return GuvenliMetin.metin("koy.cozumleme.neden.bozuk_veri")
	return metin if degerler.is_empty() else metin % degerler
static func ekle(e: KoyEkrani, b: KoyBinasi) -> void:
	if b.tur != String(D.AYAR.cozumleme.oda_turu): return
	var v := e._bilgi_icerik
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	v.add_child(h)
	if ResourceLoader.exists(IKON_DEFTER):
		var tr := TextureRect.new()
		tr.texture = load(IKON_DEFTER)
		tr.modulate = Kabuk.BAR_DOLU
		tr.custom_minimum_size = Vector2(22, 22)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(tr)
	e._etiket(h,_t("baslik"),Tema.KUCUK_PX)
	if not b.hazir():
		e._etiket(v,_t("hazir_degil"),Tema.KUCUK_PX)
		return
	var s := C.durum(e._y)
	var isci := -1
	for k in e._y.calisanlar(b.id):
		isci = k.id
		break
	if isci < 0: e._etiket(v,_t("isci_yok"),Tema.KUCUK_PX)
	e._etiket(v,_t("bedel",[int(D.AYAR.cozumleme.kamu_bedel)]),Tema.KUCUK_PX)
	var metin := _t("bos")
	if not s.aktif.is_empty():
		var a: Dictionary = D.AYAR.defterler[s.aktif.defter]
		metin = _t("ilerleme",[String(a.ad),String.num(float(s.aktif.ilerleme),2),int(a.arastirma.sure_gun)])
	var durum := e._etiket(v,metin,Tema.KUCUK_PX)
	durum.name = "cozumleme_durum"
	var kuyruk := e._etiket(v,_t("kuyruk",[s.kuyruk.size()]),Tema.KUCUK_PX)
	kuyruk.name = "cozumleme_kuyruk"
	if not s.aktif.is_empty():
		var neden := C.gorev_nedeni(e.oturum,s.aktif)
		if not neden.is_empty(): e._etiket(v,_t("durdu",[_t("neden." + neden)]),Tema.KUCUK_PX)
		_baglama(e,b,isci,s.aktif,"cozumleme_devam")
	for d in s.kuyruk:
		e._etiket(v,_t("siradaki",[String(D.AYAR.defterler[d.defter].ad)]),Tema.KUCUK_PX)
		_baglama(e,b,isci,d,"cozumleme_bagla_" + String(d.defter))
	var sayi := 0
	for esya in e.oturum.muhafiz_esyalari:
		var id := String(esya.get("id",""))
		if not D.AYAR.defterler.has(id) or int(esya.get("adet",0)) <= 0: continue
		sayi += 1
		e._etiket(v,String(D.AYAR.defterler[id].ad),Tema.KUCUK_PX)
		var r := C.istek_durumu(e.oturum,id,b.id,isci)
		var baslik := "cozuldu" if id in s.tamamlanan else ("sirala" if r.kuyrukta else "baslat")
		var dugme := e._dugme(_t(baslik),v)
		dugme.name = "cozumleme_baslat_" + id
		var ozel_ik := "res://assets/art/icons/%s.png" % id
		var defter_ik := ozel_ik if ResourceLoader.exists(ozel_ik) else IKON_DEFTER
		if ResourceLoader.exists(defter_ik):
			dugme.icon = load(defter_ik)
			dugme.expand_icon = true
		dugme.disabled = not KAPI.acik(e) or (not r.ok and not r.kuyrukta)
		if not String(r.neden).is_empty(): dugme.tooltip_text = _t("neden." + String(r.neden))
		dugme.pressed.connect(func() -> void:
			if not KAPI.acik(e): return
			C.baslat(e.oturum,id,b.id,isci)
			e._bilgi_goster())
	if sayi == 0: e._etiket(v,_t("defter_yok"),Tema.KUCUK_PX)

static func _baglama(e: KoyEkrani, b: KoyBinasi, isci: int, d: Dictionary, ad: String) -> void:
	if int(d.oda) == b.id and int(d.isci) == isci: return
	var dugme := e._dugme(_t("devam"),e._bilgi_icerik)
	dugme.name = ad
	var neden := C.gorev_nedeni(e.oturum,{"defter":String(d.defter),"oda":b.id,"isci":isci})
	dugme.disabled = not KAPI.acik(e) or not neden.is_empty()
	if not neden.is_empty(): dugme.tooltip_text = _t("neden." + neden)
	dugme.pressed.connect(func() -> void:
		if not KAPI.acik(e): return
		C.isci_degistir(e.oturum,String(d.defter),b.id,isci)
		e._bilgi_goster())
