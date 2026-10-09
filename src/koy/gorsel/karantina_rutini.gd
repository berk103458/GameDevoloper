## Mevcut figür Şifahane durağında bekler; yeni asset/koğuş yok.
class_name KarantinaRutini
extends RefCounted
static func hedef(h: KoyHalkHareketi, k: Koylu, d: Dictionary, bas: Vector2i, normal: Vector2i) -> Vector2i:
	d.karantina = KarantinaYoneticisi.aktif(k)
	if not d.karantina: return normal
	for alan in ["is", "dinlen", "devriye", "siginma", "sinsi", "ates_basi", "coban", "zanaat", "sulama", "oduncu", "degirmenci"]: d[alan] = false
	var f: KarakterModel = h.modeller[k.id]
	OduncuRutini.esya(f, h.sahne.yonetim, k.id, false, 0)
	SulamaRutini.esya(f, false, 0)
	DegirmenHareketi.esya(f, false, false)
	ZanaatTezgahi.esya(f, "")
	var b := h.sahne.yonetim.bina(int(k.karantina.bina))
	if b == null: return bas
	d.bak = h.sahne.alan_merkezi(b.hucre, b.boyut(h.sahne.yonetim.katalog))
	return h.rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(h.sahne.yonetim.katalog)), k.id)
