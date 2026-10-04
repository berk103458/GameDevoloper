## Bir gelenin heybesi: söylediği (beyan) ve gerçekte taşıdığı. Astarda saklananlar yalan sayılır.
## Oyuncu eşyaları "alınacaklar"a koyar; rüşvet ya da el koyma kararında alınanlar uygulanır.
## Kurallar: design/gdd/heybe-ve-rusvet.md
class_name Heybe
extends RefCounted

## Her eşya: {id, tur ("akce"|"gida"|"mal"), deger (birim akçe), adet, gizli, kesfedildi, alinan}
var esyalar: Array[Dictionary] = []
## Gelenin rüşvet teklifi (akçe).
var teklif: int = 0
var astar_yoklandi := false
## Oyuncu "Heybende ne var?" diye sordu mu.
var soruldu := false


## Eşya ekler; aynı id ve gizlilikte olan varsa adedi artar.
func ekle(id: String, tur: String, deger: int, adet: int, gizli: bool) -> void:
	for e in esyalar:
		if e["id"] == id and e["gizli"] == gizli:
			e["adet"] += adet
			return
	esyalar.append({"id": id, "tur": tur, "deger": deger, "adet": adet, "gizli": gizli, "kesfedildi": false, "alinan": 0})


## Astarda saklı bir şey var mı.
func yalan_var() -> bool:
	for e in esyalar:
		if e["gizli"]:
			return true
	return false


## Astar yoklandı ve saklı bir şey çıktı.
func yakalandi() -> bool:
	return astar_yoklandi and yalan_var()


## Oyuncunun görebildikleri (beyan edilenler + astardan çıkanlar).
func gorunenler() -> Array[Dictionary]:
	var s: Array[Dictionary] = []
	for e in esyalar:
		if not e["gizli"] or e["kesfedildi"]:
			s.append(e)
	return s


## Beyan edilenler (söylenenler).
func beyan_edilenler() -> Array[Dictionary]:
	var s: Array[Dictionary] = []
	for e in esyalar:
		if not e["gizli"]:
			s.append(e)
	return s


func beyan_akce() -> int:
	var t := 0
	for e in beyan_edilenler():
		if e["tur"] == "akce":
			t += int(e["adet"])
	return t


## Astarı yoklar; çıkan saklı eşyaları döner.
func astar_yokla() -> Array[Dictionary]:
	astar_yoklandi = true
	var cikan: Array[Dictionary] = []
	for e in esyalar:
		if e["gizli"] and not e["kesfedildi"]:
			e["kesfedildi"] = true
			cikan.append(e)
	return cikan


## Alınacak adedi ayarlar (0..adet).
func al(e: Dictionary, adet: int) -> void:
	e["alinan"] = clampi(adet, 0, int(e["adet"]))


func alinan_var() -> bool:
	for e in esyalar:
		if int(e["alinan"]) > 0:
			return true
	return false


## Alınanların toplam değeri (akçe).
func alinan_deger() -> int:
	var t := 0
	for e in esyalar:
		t += int(e["alinan"]) * int(e["deger"])
	return t


## Alınanların kasaya (akçe) ve ambara (gıda) düşen payı: {akce, ambar}.
func alinan_dagilim() -> Dictionary:
	var d := {"akce": 0, "ambar": 0}
	for e in esyalar:
		var v := int(e["alinan"]) * int(e["deger"])
		if e["tur"] == "gida":
			d["ambar"] += v
		else:
			d["akce"] += v
	return d


## Gasp: beyan edilenlerden teklifin üstünde alınan değer. Yakalanan yalancının sakladığı sayılmaz.
func gasp() -> int:
	var t := 0
	for e in esyalar:
		if not e["gizli"]:
			t += int(e["alinan"]) * int(e["deger"])
	return maxi(0, t - teklif)


## Hiçbir şey seçilmeden rüşvet alınırsa: teklif kadar akçe beyan edilen keseden.
func teklifi_sec() -> void:
	var kalan := teklif
	for e in esyalar:
		if e["tur"] == "akce" and not e["gizli"] and kalan > 0:
			var n := mini(kalan, int(e["adet"]))
			e["alinan"] = n
			kalan -= n


## El koyma: astardan çıkanların hepsi alınır (tepsideki seçimlere eklenir).
func saklananlari_sec() -> void:
	for e in esyalar:
		if e["gizli"] and e["kesfedildi"]:
			e["alinan"] = e["adet"]
