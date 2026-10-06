## Köylülerin görsel iş/dinlenme/ev rutini. Kalıcı simülasyonu değiştirmez.
class_name KoyHalkHareketi
extends Node

var sahne: KoyYonetimSahnesi
var modeller: Dictionary = {}
var rotaci := KoyRotasi.new()
var faz_adi: StringName = &"gunduz"
var _ayar: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy_hareket.json"))
var _durum: Dictionary = {}
var _bekleyen: Array[int] = []

## Mevcut modelleri korur, ayrılan köylüleri siler, değişen atama ve engellere yeni rota kurar.
func yenile() -> void:
	rotaci.kur(sahne.yonetim.izgara, float(_ayar.zemin_maliyeti))
	var kalan := {}
	for k in sahne.yonetim.koylular.slice(0, KoyYonetimSahnesi.AZAMI_KOYLU):
		kalan[k.id] = true
		if not modeller.has(k.id):
			var f := Dunya3B.karakter(Dunya3B.karakter_adi(k.adli_id, k.portre, k.sinif))
			sahne._halk.add_child(f)
			f.set_meta("koylu_id", k.id)
			var m := sahne.yonetim.a.meydan
			var h := rotaci.yakin(m.position + Vector2i(k.id % m.size.x, (k.id / m.size.x) % m.size.y))
			f.position = _konum(h)
			modeller[k.id] = f
			_durum[k.id] = {"yol": [], "adim": 0, "bekle": 0.0, "dinlen": false, "is": false, "bak": f.position}
		_iste(k.id)
	for id in modeller.keys():
		if not kalan.has(id):
			modeller[id].queue_free()
			modeller.erase(id)
			_durum.erase(id)

## Gece eve; akşam meydana; gündüz iş ve kısa dinlenme döngüsüne geçer.
func faz(ad: StringName) -> void:
	faz_adi = ad
	for id in modeller:
		_durum[id].dinlen = false
		_iste(id)

func _iste(id: int) -> void:
	if not _bekleyen.has(id):
		_bekleyen.append(id)
	var f: KarakterModel = modeller[id]
	f.yurumeyi_durdur()
	f.calis(&"")
	_durum[id].yol = []
	_durum[id].bekle = 0.0

func _process(delta: float) -> void:
	for i in mini(int(_ayar.kare_basina_rota), _bekleyen.size()):
		var id: int = _bekleyen.pop_front()
		if modeller.has(id):
			_planla(id)
	for id in modeller:
		if _bekleyen.has(id):
			continue
		var d: Dictionary = _durum[id]
		var f: KarakterModel = modeller[id]
		if d.adim < d.yol.size():
			var hedef: Vector3 = d.yol[d.adim]
			if f.position.distance_to(hedef) <= float(_ayar.varis_mesafesi):
				d.adim += 1
				if d.adim < d.yol.size():
					_adim(id)
				else:
					f.bak(d.bak)
					f.calis(&"calis" if d.is else &"")
		elif faz_adi == &"gunduz":
			d.bekle += delta
			var sure := float(_ayar.dinlenme_suresi if d.dinlen else _ayar.calisma_suresi)
			if d.bekle >= sure:
				d.dinlen = not d.dinlen
				_iste(id)

func _planla(id: int) -> void:
	var f: KarakterModel = modeller[id]
	var d: Dictionary = _durum[id]
	var k: Koylu
	for aday in sahne.yonetim.koylular:
		if aday.id == id:
			k = aday
			break
	if k == null:
		return
	var orta := Vector2(sahne.yonetim.a.meydan.position) + Vector2(sahne.yonetim.a.meydan.size) / 2.0
	var ham := Vector2i(floori(f.position.x / sahne.HUCRE + orta.x), floori(f.position.z / sahne.HUCRE + orta.y))
	var bas := rotaci.yakin(ham)
	if bas.x < 0:
		return
	if not rotaci.gecilir(ham):
		f.position = _konum(bas)
	var m := sahne.yonetim.a.meydan
	var son := rotaci.yakin(m.position + Vector2i(id % m.size.x, (id / m.size.x) % m.size.y))
	var b := sahne.yonetim.bina(k.ev if faz_adi == &"gece" else k.is_yeri)
	d.is = false
	d.bak = sahne.alan_merkezi(m.position, m.size)
	if b != null and b.hazir() and (faz_adi == &"gece" or (faz_adi == &"gunduz" and not d.dinlen)):
		son = rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(sahne.yonetim.katalog)), id)
		d.bak = sahne.alan_merkezi(b.hucre, b.boyut(sahne.yonetim.katalog))
		d.is = faz_adi == &"gunduz"
	elif k.is_yeri == KoyYonetimi.MUHAFIZ and faz_adi == &"gunduz" and not d.dinlen:
		son = rotaci.yakin(Vector2i(m.position.x + m.size.x / 2, sahne.yonetim.a.izgara_boyut.y - 1))
		d.bak = _konum(son) + Vector3.FORWARD * -sahne.HUCRE
	var hucreler := rotaci.yol(bas, son)
	if hucreler.is_empty():
		d.is = false
	d.yol = []
	for h in hucreler:
		d.yol.append(_konum(h))
	if not d.yol.is_empty():
		# Küçük, hücre içinde kalan durak farkı: aynı durakta üst üste binmeyi azaltır.
		d.yol[-1] += Vector3((id % 3 - 1) * float(_ayar.durak_araligi), 0, ((id / 3) % 3 - 1) * float(_ayar.durak_araligi))
	d.adim = 0
	if not d.yol.is_empty():
		_adim(id)

func _adim(id: int) -> void:
	var fark := sin(float(id) * 2.4) * float(_ayar.hiz_farki)
	modeller[id].yuru(_durum[id].yol[_durum[id].adim], float(_ayar.yurume_hizi) * (1.0 + fark))

func _konum(h: Vector2i) -> Vector3:
	return sahne.alan_merkezi(h, Vector2i.ONE)
