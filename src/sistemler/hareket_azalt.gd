## AYR-18: Hareket azaltma açıkken kamera ve panel süreleri 0 olur.
## 12 fps adımlı yürüyüş (`adim.gd`) bu dosyada kısaltılmaz.
extends RefCounted

static var acik := false


static func guncelle(a: Ayarlar) -> void:
	acik = a != null and bool(a.degerler.get(&"hareket_azalt", false))


static func sure(taban: float) -> float:
	return 0.0 if acik else taban
