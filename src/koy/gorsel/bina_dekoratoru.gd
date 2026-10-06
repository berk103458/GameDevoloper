## Yapıların çevresine kendiliğinden eşya serper (odun yığını, fıçı, kova, sandık...). Çarpışma yoktur;
## yerleşim tohumla belirlenir, köy her açılışta aynı görünür. Eşyalar Kenney "Survival Kit" (CC0).
class_name BinaDekoratoru
extends RefCounted

## Yapı türü -> [[eşya, boy (m)], ...]
const TAKIMLAR := {
	"ev": [["resource-wood", 0.55], ["barrel", 0.9], ["bucket", 0.35], ["box", 0.55]],
	"cadir": [["bedroll-packed", 0.35], ["bucket", 0.35], ["resource-wood", 0.45]],
	"tezgah": [["box", 0.6], ["chest", 0.6], ["barrel", 0.9]],
	"kervansaray": [["box", 0.7], ["box", 0.6], ["barrel", 1.0], ["bedroll", 0.25], ["chest", 0.6]],
}


## Yerleşimdeki yapıların çevresine eşya ve iş yerlerine iş takımı koyar.
static func suesle(kok: Node3D, y: KoyYerlesimi, tohum: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = tohum
	for e in y.evler:
		_cevre(kok, e["konum"], e["tur"], 2.2, 2, rng)
	for t in y.tezgahlar:
		_cevre(kok, t["konum"], "tezgah", 1.5, 2, rng)
	if y.kervansaray_seviye > 0:
		_cevre(kok, KoyYerlesimi.KERVANSARAY, "kervansaray", 3.4 + y.kervansaray_seviye * 0.4, 3 + y.kervansaray_seviye, rng)
	# İş yerleri
	for i in 4:
		_koy(kok, Dunya3B.esya("resource-wood", 0.7), KoyYerlesimi.ODUNLUK + Vector3(rng.randf_range(-3, 3), 0, rng.randf_range(-3, 3)), rng)
	_koy(kok, Dunya3B.esya("workbench", 0.9), KoyYerlesimi.ODUNLUK + Vector3(2.5, 0, -2.0), rng)
	for i in 4:
		_koy(kok, Dunya3B.esya("resource-stone", 0.6), KoyYerlesimi.TAS_OCAGI + Vector3(rng.randf_range(-3, 3), 0, rng.randf_range(-3, 3)), rng)
	_koy(kok, Dunya3B.esya("rock-b", 2.2), KoyYerlesimi.TAS_OCAGI + Vector3(2.5, 0, 1.5), rng)
	_koy(kok, Dunya3B.esya("rock-a", 1.8), KoyYerlesimi.TAS_OCAGI + Vector3(-2.8, 0, 2.2), rng)
	_koy(kok, Dunya3B.esya("workbench", 0.9), KoyYerlesimi.ATOLYE, rng)
	_koy(kok, Dunya3B.esya("box", 0.55), KoyYerlesimi.ATOLYE + Vector3(1.4, 0, 0.4), rng)
	# Ambar: çuvallar ve fıçılar.
	var c := Dunya3B.nesne("cuval_yigini", 1.0)
	_koy(kok, c, KoyYerlesimi.AMBAR, rng)
	_koy(kok, Dunya3B.esya("barrel", 0.95), KoyYerlesimi.AMBAR + Vector3(1.3, 0, 0.5), rng)
	_koy(kok, Dunya3B.esya("barrel", 0.95), KoyYerlesimi.AMBAR + Vector3(1.1, 0, -0.8), rng)
	# Tarla çiti ve tabelası.
	var t0 := KoyYerlesimi.TARLA
	for i in 7:
		var f := Dunya3B.esya("fence", 0.9)
		f.position = t0 + Vector3(-6.5 + i * 2.0, 0, -6.2)
		kok.add_child(f)
		var f2 := Dunya3B.esya("fence", 0.9)
		f2.position = t0 + Vector3(-6.5 + i * 2.0, 0, 6.2)
		kok.add_child(f2)
	_koy(kok, Dunya3B.esya("signpost-single", 1.4), t0 + Vector3(-7.2, 0, -5.0), rng)


static func _cevre(kok: Node3D, merkez: Vector3, tur: String, r: float, adet: int, rng: RandomNumberGenerator) -> void:
	var takim: Array = TAKIMLAR.get(tur, [])
	if takim.is_empty():
		return
	# Meydana bakan ön yüzü boş bırak (kapı ve yol); eşyalar yanlara ve arkaya.
	var on := atan2(KoyYerlesimi.MEYDAN.x - merkez.x, KoyYerlesimi.MEYDAN.z - merkez.z)
	for i in adet:
		var s: Array = takim[rng.randi_range(0, takim.size() - 1)]
		var a := on + PI * 0.5 + rng.randf_range(0.0, PI)
		var p := merkez + Vector3(sin(a), 0, cos(a)) * (r + rng.randf_range(0.0, 0.5))
		_koy(kok, Dunya3B.esya(s[0], s[1]), p, rng)


static func _koy(kok: Node3D, n: Node3D, p: Vector3, rng: RandomNumberGenerator) -> void:
	n.position = p
	n.rotation.y = rng.randf() * TAU
	kok.add_child(n)
