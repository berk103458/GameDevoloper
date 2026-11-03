## TEK-06 / TEK-34: portsuz açılışta dinleyen soket yoktur.
extends RefCounted


static func oku(argumanlar: PackedStringArray, ortam: String) -> int:
	var deger := ortam
	for i in argumanlar.size():
		if argumanlar[i] == "--bridge-port":
			deger = argumanlar[i + 1] if i + 1 < argumanlar.size() else ""
			break
	if not deger.is_valid_int():
		return 0
	var p := int(deger)
	return p if p > 0 and p <= 65535 else 0
