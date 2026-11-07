## OGR-05: mevcut gece raporunun açılış gövdesi.
extends RefCounted

static func ekle(e: KoyEkrani, v: VBoxContainer, bilanco: Dictionary) -> bool:
	if not bilanco.has("kapi_ozeti"): return false
	var ozet: Dictionary = bilanco.kapi_ozeti
	var gida: Dictionary = bilanco.stok.gida
	_satir(e, v, "gelenler", [_adlar(ozet.gelenler)])
	_satir(e, v, "kalanlar", [_adlar(ozet.kalanlar)])
	_satir(e, v, "ambar", [int(gida.once), int(gida.sonra)])
	if IlkSaat.ulak_hatirlatmasi_var(e.oturum, int(bilanco.gun)):
		_satir(e, v, "ulak_berat", [])
	return true

static func ilk_saat_ozetini_ekle(e: KoyEkrani, v: VBoxContainer, bilanco: Dictionary) -> void:
	if not bilanco.has("ilk_saat_ozeti"): return
	var ozet: Dictionary = bilanco.ilk_saat_ozeti
	var gelen := str(ozet.gelen) if int(ozet.gelen) >= 0 else "—"
	_satir(e, v, "ilk_saat_ozeti", [gelen, int(ozet.kabul), int(ozet.ret), int(ozet.nufus)])

static func _adlar(liste: Array) -> String:
	return "—" if liste.is_empty() else ", ".join(PackedStringArray(liste))

static func _satir(e: KoyEkrani, v: VBoxContainer, ad: String, degerler: Array) -> void:
	var anahtar := "koy.rapor.kisa." + ad
	var metin := TranslationServer.translate(anahtar)
	if metin == anahtar or metin.is_empty(): metin = GuvenliMetin.metin(anahtar)
	var l := e._etiket(v, metin if degerler.is_empty() else metin % degerler, Tema.KUCUK_PX)
	l.name = "kisa_" + ad
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 900
