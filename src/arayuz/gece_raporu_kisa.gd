## OGR-05: mevcut gece raporunun açılış gövdesi.
extends RefCounted

static func ekle(e: KoyEkrani, v: VBoxContainer, bilanco: Dictionary) -> bool:
	if not bilanco.has("kapi_ozeti"): return false
	var ozet: Dictionary = bilanco.kapi_ozeti
	var gida: Dictionary = bilanco.stok.gida
	_satir(e, v, "gelenler", [_adlar(ozet.gelenler)])
	_satir(e, v, "kalanlar", [_adlar(ozet.kalanlar)])
	_satir(e, v, "ambar", [int(gida.once), int(gida.sonra)])
	return true

static func _adlar(liste: Array) -> String:
	return "—" if liste.is_empty() else ", ".join(PackedStringArray(liste))

static func _satir(e: KoyEkrani, v: VBoxContainer, ad: String, degerler: Array) -> void:
	var anahtar := "koy.rapor.kisa." + ad
	var metin := TranslationServer.translate(anahtar)
	if metin == anahtar or metin.is_empty(): metin = GuvenliMetin.metin(anahtar)
	var l := e._etiket(v, metin % degerler, Tema.KUCUK_PX)
	l.name = "kisa_" + ad
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 900
