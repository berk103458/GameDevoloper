## GIR-06: menüdeki odak komşusu kalıbı. Oklar düğmeler arasında sarar.
class_name OdakHalkasi
extends RefCounted


## Etkin düğmelere üst ve alt komşu yazar. Dönen sayı halkadaki düğme sayısıdır.
static func bagla(liste: Array) -> int:
	var etkin: Array[Button] = []
	for oge in liste:
		if oge is Button and not (oge as Button).disabled and (oge as CanvasItem).visible:
			etkin.append(oge)
	for i in etkin.size():
		var b: Button = etkin[i]
		var ust: Button = etkin[(i - 1 + etkin.size()) % etkin.size()]
		var alt: Button = etkin[(i + 1) % etkin.size()]
		b.focus_neighbor_top = b.get_path_to(ust)
		b.focus_neighbor_bottom = b.get_path_to(alt)
	return etkin.size()


## Komşusu boş kalan etkin düğme sayısı.
static func kopuk(liste: Array) -> int:
	var n := 0
	for oge in liste:
		if oge is Button and not (oge as Button).disabled and (oge as CanvasItem).visible:
			var b := oge as Button
			if b.focus_neighbor_top == NodePath() or b.focus_neighbor_bottom == NodePath():
				n += 1
	return n
