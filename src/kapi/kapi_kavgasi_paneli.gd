## CAT-02: mevcut karar listesinde dört seçenek; ziyaretçinin ayrılışı seçimi bekler.
extends RefCounted
signal tamamlandi
const A = preload("res://src/kapi/kapi_kavgasi_adaptoru.gd")
var _bitti := false
var _dugmeler: Dictionary = {}

static func ac(e: KapiEkrani) -> void:
	var p := new()
	await p._ac(e)

func _ac(e: KapiEkrani) -> void:
	e.evre = &"kavga"
	var a = A.al(e.oturum)
	a.panel_acik = true
	A.sonuc_yaz(e, a.son)
	# CAT02-KAVGA: yalnız mevcut UI üzerinde kısa sarsıntı, yeni asset yok.
	var baslangic := e._kayit.position
	var t := e.create_tween()
	t.tween_property(e._kayit, "position", baslangic + Vector2(6, 0), 0.06)
	t.tween_property(e._kayit, "position", baslangic - Vector2(6, 0), 0.06)
	t.tween_property(e._kayit, "position", baslangic, 0.06)
	for id in KapiKavgasi.GECERLI_SECENEKLER:
		var b := e._dugme(TranslationServer.translate("arayuz.kavga." + id))
		b.name = id
		_dugmeler[id] = b
		b.pressed.connect(_sec.bind(e, id))
	var yenile := func() -> void: _yenile(e)
	e.oturum.yonetim.nobet_degisti.connect(yenile)
	_yenile(e)
	for b: Button in _dugmeler.values():
		if b.visible and not b.disabled:
			b.grab_focus()
			break
	await tamamlandi
	e.oturum.yonetim.nobet_degisti.disconnect(yenile)
	e._temizle()
	e.evre = &"sonuc"

func _yenile(e: KapiEkrani) -> void:
	var durumlar: Dictionary = A.al(e.oturum).kavga.secenek_durumlari(A.baglam(e.oturum))
	for id in _dugmeler:
		var b: Button = _dugmeler[id]
		var d: Dictionary = durumlar[id]
		b.visible = d.gorunur
		b.disabled = _bitti or d.kilitli
		b.text = TranslationServer.translate("arayuz.kavga." + id)
		if not String(d.kilit_nedeni).is_empty():
			var neden := TranslationServer.translate("arayuz.kavga." + String(d.kilit_nedeni))
			b.text += " · " + neden
			b.tooltip_text = neden

func _sec(e: KapiEkrani, id: String) -> void:
	if _bitti: return
	var r := A.sec(e.oturum, id)
	if not r.get("olur", false):
		_yenile(e)
		return
	preload("res://src/kapi/siddet_korkusu_adaptoru.gd").ekran(e, r)
	_bitti = true
	_yenile(e)
	e._yaz(TranslationServer.translate("anlati.kavga." + String(r.sonuc_kimligi)))
	if r.has("zar"):
		var z_tur := StringName(r.zar.get("tur", "d6")) if r.zar is Dictionary else &"d6"
		await ZarAtisiAnimasyonu.oynat(e, z_tur, e.ayarlar if "ayarlar" in e else null, int(r.zar.zar) if r.zar is Dictionary else 0)
		e._yaz(TranslationServer.translate("anlati.kavga.zar") % [int(r.zar.zar), int(r.zar.gerekli)])
	e.hud.guncelle()
	tamamlandi.emit()
