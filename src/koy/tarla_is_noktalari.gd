## BUG-23: tarla iş durakları; mevcut A*/ANI-13 ağına salt görsel adaptör.
class_name TarlaIsNoktalari
extends RefCounted

static func tarla(b: KoyBinasi) -> bool:
	return b != null and b.hazir() and b.tur in ["tarla", "bostan"]

static func tarlada(y: KoyYonetimi, cell: Vector2i) -> bool:
	for b in y.binalar:
		if tarla(b) and Rect2i(b.hucre, b.boyut(y.katalog)).has_point(cell): return true
	return false

## Açılan tarla eve bitişik olabilir; uyku durağı ev çevresinin tarla olmayan kısmıdır.
static func uyku_duragi(h: KoyHalkHareketi, k: Koylu, bas: Vector2i, son: Vector2i) -> Vector2i:
	var y := h.sahne.yonetim
	if not tarlada(y, son): return son
	var ev := y.bina(k.ev)
	if ev != null and ev.hazir():
		var alan := Rect2i(ev.hucre, ev.boyut(y.katalog))
		for i in (alan.size.x + 2) * (alan.size.y + 2):
			var cell := h.rotaci.bina_duragi(bas, alan, k.id + i)
			if cell.x >= 0 and not tarlada(y, cell): return cell
	return h.rotaci.yakin(y.a.meydan.position)

## Yerleşim doluluğu korunur. Yalnız hazır tarım hücreleri gezinme kopyasında açılır.
static func gezinme_izgarasi(y: KoyYonetimi) -> Izgara:
	var g := Izgara.new(y.izgara.boyut, y.izgara.meydan)
	g.dolu = y.izgara.dolu.duplicate()
	g.yollar = y.izgara.yollar.duplicate()
	g.engeller = y.izgara.engeller.duplicate()
	for b in y.binalar:
		if not tarla(b): continue
		for cell in b.hucreler(y.katalog):
			if g.dolu.get(cell, -1) == b.id: g.dolu.erase(cell)
	return g

## Kimlik sırası + bina kimliği: genel veya simülasyon RNG'sini tüketmez.
## Aynı hücreye sığması gereken ek çalışanlar merkez polygon içinde ayrılır.
static func nokta(s: KoyYonetimSahnesi, k: Koylu) -> Dictionary:
	var b := s.yonetim.bina(k.is_yeri)
	if not tarla(b): return {}
	var ids: Array[int] = []
	for kisi in s.yonetim.koylular:
		if kisi.is_yeri == b.id: ids.append(kisi.id)
	ids.sort()
	var sira := ids.find(k.id)
	if sira < 0: return {}
	var cells := b.hucreler(s.yonetim.katalog)
	if cells.is_empty(): return {}
	var cell := cells[posmod(sira + b.id, cells.size())]
	var grup := sira / cells.size()
	var adet := ceili(float(ids.size()) / cells.size())
	var sutun := ceili(sqrt(float(adet)))
	var kenar := maxf(0.0, s.HUCRE * 0.5 - float(KoyZeminNavigasyonu.AYAR.kenar_bosluk)) * 0.9
	var ofset := Vector3((float(grup % sutun) + 0.5) / sutun * 2.0 - 1.0, 0,
		(float(grup / sutun) + 0.5) / sutun * 2.0 - 1.0) * kenar
	return {"hucre": cell, "konum": s.alan_merkezi(cell, Vector2i.ONE) + ofset}

## Sulamanın yalnız çalışma durağı değiştirilir; kuyu, mola, uyku ve öncelikli işler korunur.
static func planla(h: KoyHalkHareketi, k: Koylu, d: Dictionary, bas: Vector2i, son: Vector2i) -> Vector2i:
	d.tarla_hedef = false
	if h.faz_adi == &"gece": return uyku_duragi(h, k, bas, son)
	if h.faz_adi != &"gunduz" or d.dinlen: return son
	if d.get("siginma", false) or d.get("karantina", false) or d.get("ates_basi", false) or d.get("devriye", false): return son
	var b := h.sahne.yonetim.bina(k.is_yeri)
	if b == null and (d.has("tarla_noktasi") or (k.sinif == &"ciftci" and k.is_yeri >= 0)):
		d.is = false
		if not d.get("tarla_uyarildi", false):
			push_warning("BUG-23: çiftçi %d için tarla yok; iş iptal edildi, eski iş noktası korunuyor." % k.id)
			d.tarla_uyarildi = true
		if not d.has("tarla_noktasi"):
			d.tarla_noktasi = h.modeller[k.id].position
			d.tarla_hucresi = bas
		var eski: Vector2i = d.get("tarla_hucresi", bas)
		if h.rotaci.yol(bas, eski).is_empty(): return bas
		d.tarla_hedef = d.has("tarla_noktasi")
		return eski
	if not tarla(b) or not d.is: return son
	if d.get("sulama", false) and int(d.get("sulama_i", 0)) != 1: return son
	if not SulamaRutini.aday(h.sahne.yonetim, k, h.faz_adi): return son
	var n := nokta(h.sahne, k)
	if n.is_empty() or h.rotaci.yol(bas, n.hucre).is_empty():
		d.is = false
		return bas
	d.tarla_noktasi = n.konum
	d.tarla_hucresi = n.hucre
	d.tarla_hedef = true
	d.tarla_uyarildi = false
	d.bak = h.sahne.alan_merkezi(b.hucre, b.boyut(h.sahne.yonetim.katalog))
	return n.hucre

## ANI-13 rotasının son noktası; eski dokuzlu durak sapmasını tarla içinde uygulatmaz.
static func bitir(d: Dictionary) -> void:
	if d.get("tarla_hedef", false) and not d.yol.is_empty():
		d.yol[-1] = d.tarla_noktasi
