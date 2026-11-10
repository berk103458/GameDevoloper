## SOY-32: söylenti ağının debug görünümü — her kayıt: tür, gece, kaynak ve duyanlar (sırayla), kopyada asıl ve biçim.
## Oyuncu arayüzüne girmez; debug kapalıyken (`not AdminHud.arac_acik()`) kurulmaz. Okuma ağı kurmaz.
class_name SoylentiPaneli
extends Label

var baglam: Node
var _sure := 0.0


static func kur(ust: Node, p_baglam: Node, debug_acik: bool = AdminHud.arac_acik()) -> SoylentiPaneli:
	if not debug_acik:
		return null
	var p := SoylentiPaneli.new()
	p.name = "SoylentiPaneli"
	p.baglam = p_baglam
	p.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ust.add_child(p)
	p.yenile()
	return p


static func satirlar(o: Object) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if o == null or not o.has_meta(SoylentiKoprusu.META):
		return sonuc
	var a: RefCounted = o.get_meta(SoylentiKoprusu.META)
	var anahtarlar: Array = a.ag_kayitlari.keys()
	anahtarlar.sort()
	for id in anahtarlar:
		var k: Dictionary = a.ag_kayitlari[id]
		var ek := ""
		if k.has("asil"):
			ek = " · kopya(%s, %s)" % [k.asil, k.get("bicim", "")]
		sonuc.append("%s · %s · gece %d · %s → %s%s%s" % [id, k.get("tur", ""), int(k.get("gece", 0)), k.get("kaynak", ""),
			", ".join(PackedStringArray(k.get("duyanlar", []))), " · KAMUOYU" if bool(k.get("kamuoyu_oldu", false)) else "", ek])
	return sonuc


func _process(delta: float) -> void:
	_sure += delta
	if _sure >= 1.0:
		_sure = 0.0
		yenile()


func yenile() -> void:
	var o: Object = baglam.get("oturum") if is_instance_valid(baglam) else null
	var s := satirlar(o)
	text = "Söylenti ağı: (boş)" if s.is_empty() else "Söylenti ağı\n" + "\n".join(s)
