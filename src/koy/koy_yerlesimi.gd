## Köyün yerleşim planı: yapıların, iş yerlerinin, meydanın ve yolların konumu.
## Oturumdan hesaplanır, saf veridir (düğüm kurmaz). Arazi maskesi, yol bulma, köylü yapay zekâsı ve
## süsleyici hep bu tek plandan okur; böylece yol nereye çizildiyse köylü de oradan yürür.
## Yerleşim sabit yuvalıdır: oyuncu yapı yeri seçmez (kapi-konsept: "bina yerleştirme yok").
class_name KoyYerlesimi
extends RefCounted

const KAPI := Vector3(0, 0, -19)
const MEYDAN := Vector3(0, 0, 0)
const KUYU := Vector3(3.6, 0, 2.8)
const KERVANSARAY := Vector3(-8.5, 0, -6.5)
const AMBAR := Vector3(4.5, 0, -7.0)
## İş yerlerinin merkezleri.
const TARLA := Vector3(15.0, 0, 15.0)
const ODUNLUK := Vector3(-22.0, 0, 8.0)
const TAS_OCAGI := Vector3(21.0, 0, -12.0)
const ATOLYE := Vector3(-5.0, 0, 5.5)
const NOBET: Array[Vector3] = [Vector3(-3.2, 0, -16.5), Vector3(3.2, 0, -16.5), Vector3(-12.0, 0, -12.0), Vector3(12.0, 0, -11.0)]
const AZAMI_EV := 14

## {konum: Vector3, aci: float (derece), tur: "ev"|"cadir"}
var evler: Array[Dictionary] = []
## Pazar tezgâhları: {konum, aci}
var tezgahlar: Array[Dictionary] = []
var kervansaray_seviye := 0
var pazar_seviye := 0
var sur_seviye := 0
## Yol parçaları: [a, b, genişlik]
var yollar: Array[Array] = []
## Yürünemez daireler: [merkez: Vector3, yarıçap: float]
var engeller: Array[Array] = []
## Meydandaki sohbet yuvaları (ateşin çevresi).
var meydan_yuvalari: Array[Vector3] = []


## Oturumdaki nüfus ve yapı seviyelerinden planı kurar.
static func kur(oturum: Oturum) -> KoyYerlesimi:
	var y := KoyYerlesimi.new()
	y.kervansaray_seviye = int(oturum.yapilar[&"kervansaray"])
	y.pazar_seviye = int(oturum.yapilar[&"pazar"])
	y.sur_seviye = int(oturum.yapilar[&"sur"]) if oturum.perde == 2 else 0
	var ev_sayisi := clampi(1 + oturum.koy.toplam() / 3, 1, AZAMI_EV)
	for i in ev_sayisi:
		var p := ev_konumu(i)
		y.evler.append({"konum": p, "aci": rad_to_deg(atan2(-p.x, -p.z)) + 180.0, "tur": "ev" if i % 3 != 2 else "cadir"})
	for i in y.pazar_seviye * 2:
		y.tezgahlar.append({"konum": Vector3(7.5 + (i % 2) * 3.0, 0, -3.0 + (i / 2) * 3.2), "aci": -70.0})
	y._yollari_kur()
	y._engelleri_kur()
	for i in 10:
		var a := TAU * i / 10.0
		y.meydan_yuvalari.append(MEYDAN + Vector3(sin(a), 0, cos(a)) * (2.6 + (i % 2) * 0.9))
	return y


## i'inci evin konumu: meydanın çevresinde iki halka; kapıdan gelen yol (kuzey) boş kalır.
static func ev_konumu(i: int) -> Vector3:
	var halka := 0 if i < 7 else 1
	var sira := i if halka == 0 else i - 7
	var r := 9.5 + halka * 5.5
	var a := deg_to_rad(30.0 + sira * 50.0 + halka * 25.0)
	return Vector3(sin(a) * r, 0, -cos(a) * r)


## Bir evin kapı önü (köylünün girip çıktığı nokta): evden meydana doğru 2 m.
func ev_kapisi(i: int) -> Vector3:
	var p: Vector3 = evler[i % evler.size()]["konum"]
	return p + (MEYDAN - p).normalized() * 2.4


## Sınıfa ve sıraya göre iş yeri: {tur: &"tarla"|&"odun"|&"tas"|&"pazar"|&"atolye"|&"nobet", konum: Vector3}
func is_yeri(sinif: StringName, sira: int) -> Dictionary:
	var kay := Vector3(((sira * 37) % 7 - 3) * 0.9, 0, ((sira * 53) % 5 - 2) * 0.9)
	match sinif:
		&"ciftci":
			match sira % 3:
				0, 1: return {"tur": &"tarla", "konum": TARLA + kay}
				_: return {"tur": &"odun", "konum": ODUNLUK + kay}
		&"esnaf":
			if pazar_seviye > 0 and sira % 2 == 0:
				var t: Dictionary = tezgahlar[sira % tezgahlar.size()]
				return {"tur": &"pazar", "konum": t["konum"] + Vector3(-1.4, 0, 0.6)}
			if sira % 3 == 1:
				return {"tur": &"tas", "konum": TAS_OCAGI + kay}
			return {"tur": &"atolye", "konum": ATOLYE + kay * 0.5}
		_:
			return {"tur": &"nobet", "konum": NOBET[sira % NOBET.size()] + kay * 0.3}


func _yollari_kur() -> void:
	yollar.append([KAPI + Vector3(0, 0, 2.0), MEYDAN, 3.2])
	yollar.append([MEYDAN, TARLA + Vector3(-4, 0, -4), 2.0])
	yollar.append([MEYDAN, ODUNLUK + Vector3(4, 0, -1), 2.0])
	yollar.append([MEYDAN, TAS_OCAGI + Vector3(-3, 0, 2), 1.8])
	yollar.append([MEYDAN, AMBAR, 1.8])
	if kervansaray_seviye > 0:
		yollar.append([MEYDAN, KERVANSARAY + Vector3(2.2, 0, 2.0), 2.4])
	if pazar_seviye > 0:
		yollar.append([MEYDAN, Vector3(7.0, 0, -1.5), 2.4])
	for i in evler.size():
		yollar.append([MEYDAN.lerp(evler[i]["konum"], 0.45), ev_kapisi(i), 1.3])


func _engelleri_kur() -> void:
	for e in evler:
		engeller.append([e["konum"], 1.9])
	for t in tezgahlar:
		engeller.append([t["konum"], 1.1])
	if kervansaray_seviye > 0:
		engeller.append([KERVANSARAY, 3.0 + kervansaray_seviye * 0.4])
	engeller.append([KUYU, 1.0])
	engeller.append([MEYDAN, 1.2])
	engeller.append([AMBAR, 1.2])
