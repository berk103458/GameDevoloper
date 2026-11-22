## ACL-03: Gece raporundan önce ocak başı akşam sohbeti kartı.
class_name AksamSohbetiPaneli
extends RefCounted

const SECENEKLER: Array[Array] = [
	["savunmak", "Savun"],
	["kabul_etmek", "Hak ver"],
	["susmak", "Sus"],
]


## Gece raporundan önce gerekiyorsa en çok bir akşam sohbeti açar; açıldıysa true döner.
static func ac(koy: KoyEkrani, devam_cb: Callable) -> bool:
	if koy == null or koy.oturum == null:
		return false
	if koy._ust_kart != null and koy._ust_kart.has_meta(&"aksam_sohbeti"):
		return true
	var meclis := CinarMeclisPaneli._bekliyor(koy) or CinarAltiMeclisi.haftalik_bekliyor(koy.oturum.yonetim)
	var sohbet: Dictionary = koy.oturum.aksam_sohbeti_hazirla({"meclis_gecesi": meclis, "otomatik_hikaye": true})
	if sohbet.is_empty():
		return false
	var konu_id := String(sohbet.get("konu_id", ""))
	var baslik := "Ocak Başı — %s" % String(sohbet.get("baslik", "Akşam Sohbeti"))
	var v: VBoxContainer = koy._kart_ac(baslik)
	if koy._ust_kart != null:
		koy._ust_kart.name = "AksamSohbetiKart"
		koy._ust_kart.set_meta(&"aksam_sohbeti", true)
		koy._ust_kart.set_meta(&"katilimci_sayisi", (sohbet.get("katilimcilar", []) as Array).size())
	var yer := Label.new()
	yer.text = "[Ocak Başı — Yer Tutucu]"
	yer.add_theme_font_size_override("font_size", Kabuk.KUCUK)
	yer.add_theme_color_override("font_color", Kabuk.SOLUK)
	yer.visible = OyuncuSurumu.debug_acik()
	v.add_child(yer)
	var katilim := koy._etiket(v, preload("res://src/koy/ilk_gunler_hikayesi.gd").katilimci_basligi(koy.oturum, konu_id), Tema.KUCUK_PX)
	katilim.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	for satir in sohbet.get("es_replikleri", []):
		var l := koy._etiket(v, String(satir), Tema.GOVDE_PX)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = 860
	var ilk: Button = null
	var cevaplar: Dictionary = sohbet.get("cevaplar", {})
	for c in SECENEKLER:
		var cid := String(c[0])
		if not cevaplar.has(cid):
			continue
		var d: Button = koy._dugme("— %s: %s" % [String(c[1]), String(cevaplar[cid].get("metin", cid))], v)
		d.alignment = HORIZONTAL_ALIGNMENT_LEFT
		d.pressed.connect(func() -> void:
			koy.oturum.aksam_sohbeti_uygula(konu_id, cid)
			koy._kart_kapat()
			if devam_cb.is_valid():
				devam_cb.call()
		)
		if ilk == null:
			ilk = d
	var atla_d: Button = koy._dugme("Atla (sessiz kal)", v)
	atla_d.name = &"AksamAtla"
	atla_d.pressed.connect(func() -> void:
		koy.oturum.aksam_sohbeti_atla()
		koy._kart_kapat()
		if devam_cb.is_valid():
			devam_cb.call()
	)
	if ilk != null:
		ilk.grab_focus.call_deferred()
	else:
		atla_d.grab_focus.call_deferred()
	return true
