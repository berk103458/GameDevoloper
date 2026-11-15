## Ret havuzu ve husumet (design/gdd/koy-yonetimi.md, 3): reddedilenler kayda geçer; gerekçesiz ret husumeti
## daha çok artırır. Husumet her gece söner; eşikleri geçince sızma ve baskın zarı atılır.
class_name Husumet
extends RefCounted

var puan: int = 0
## Reddedilenler: {ad, gun, haksiz, usta}.
var reddedilenler: Array[Dictionary] = []
## Haksız reddedilip Tekfur'un hizmetine geçen ustalar (uzmanlık adları).
var tekfura_gecenler: PackedStringArray = []
## SOY-35: iki köylü arasındaki yanlış söylenti kaynaklı ikili husumet.
var kisi_husumeti: Dictionary = {}


static func _ikili_anahtar(a: Variant, b: Variant) -> String:
	var sa := str(a).strip_edges()
	var sb := str(b).strip_edges()
	if sa.is_empty() or sb.is_empty() or sa == sb:
		return ""
	return "%s|%s" % ([sa, sb] if sa < sb else [sb, sa])


func soylenti_husumeti_ekle(kaynak: Variant, hedef: Variant, artis: int = 1) -> int:
	var anahtar := _ikili_anahtar(kaynak, hedef)
	if anahtar.is_empty() or artis <= 0:
		return 0
	var yeni := int(kisi_husumeti.get(anahtar, 0)) + artis
	kisi_husumeti[anahtar] = yeni
	return yeni


func kisi_husumeti_oku(kisi_a: Variant, kisi_b: Variant) -> int:
	var anahtar := _ikili_anahtar(kisi_a, kisi_b)
	return int(kisi_husumeti.get(anahtar, 0)) if not anahtar.is_empty() else 0


## Bir ret kaydeder. `haksiz`: masum köylü ya da usta reddedildi.
func ret(ad: String, gun: int, haksiz: bool, usta_uzmanlik: String, a: KoyAyarlari) -> void:
	puan += a.husumet_haksiz if haksiz else a.husumet_gerekceli
	reddedilenler.append({"ad": ad, "gun": gun, "haksiz": haksiz, "usta": usta_uzmanlik})
	if haksiz and usta_uzmanlik != "" and not usta_uzmanlik in tekfura_gecenler:
		tekfura_gecenler.append(usta_uzmanlik)


## Gece: önce söner, sonra eşik zarları. Döner: `baskin`, `sizma` ya da boş.
func gece(a: KoyAyarlari, muhafiz: int, rng: RandomNumberGenerator) -> String:
	puan = maxi(0, puan - a.husumet_sonum)
	var indirim := muhafiz * a.muhafiz_zar_indirimi
	if puan >= a.baskin_esigi:
		if rng.randf() < maxf(0.0, a.baskin_zar - indirim):
			return "baskin"
	elif puan >= a.sizma_esigi:
		if rng.randf() < maxf(0.0, a.sizma_zar - indirim):
			return "sizma"
	return ""


func kaydet() -> Dictionary:
	var d := {"puan": puan, "reddedilenler": reddedilenler.duplicate(true), "tekfur": Array(tekfura_gecenler)}
	if not kisi_husumeti.is_empty():
		d["kisi_husumeti"] = kisi_husumeti.duplicate()
	return d


static func kayittan(v: Dictionary) -> Husumet:
	var h := Husumet.new()
	h.puan = int(v.get("puan", 0))
	for r in v.get("reddedilenler", []):
		h.reddedilenler.append(r)
	h.tekfura_gecenler = PackedStringArray(v.get("tekfur", []))
	var kh: Variant = v.get("kisi_husumeti", {})
	if kh is Dictionary:
		for anahtar in kh:
			var val: Variant = kh[anahtar]
			if (val is int or val is float) and int(val) > 0:
				h.kisi_husumeti[String(anahtar)] = int(val)
	return h
