## Köyde yaşayan bir kişi (design/gdd/koy-yonetimi.md, 1, 8, 11).
## Bayraklar kapıdaki sorguda açığa çıkanlardır; `gizli_bayraklar` bilinmeyen gerçeklerdir (casus, hasta …),
## köyde olay olarak ortaya çıkar ya da köy içi sorguyla açılır.
class_name Koylu
extends RefCounted

var id: int = 0
## Ad metni ya da çeviri anahtarı.
var ad: String = ""
## Adlı karakterse kimliği (`chr_007`); figürse boş.
var adli_id: StringName = &""
## `ciftci`, `esnaf`, `asker`.
var sinif: StringName = &"ciftci"
var portre: String = ""
## Zanaat yeteneği 1–10 (formül F4).
var stat: int = 5
## Açık bayraklar: `usta_ciftci`, `somurulmus`, `tembel` …
var bayraklar: PackedStringArray = []
var gizli_bayraklar: PackedStringArray = []
var moral: int = 60
var saglik: int = 100
var sadakat: int = 60
## Çalıştığı yapının kimliği (-1 = boşta); `muhafiz` görevindeyse -2.
var is_yeri: int = -1
## Kışın donan yapıdan kaydırıldıysa eski iş yeri; baharda geri döner (-1 = yok).
var kis_oncesi_is: int = -1
## Kaldığı barınağın kimliği (-1 = evsiz).
var ev: int = -1
## Dün aç kaldı mı (bugünkü verim düşer).
var ac: bool = false
## Kabul edildiği gün.
var giris_gunu: int = 0


func bayrak_var(b: String) -> bool:
	return b in bayraklar


func bayrak_ekle(b: String) -> void:
	if not bayrak_var(b):
		bayraklar.append(b)


## Gizli bir gerçeği açığa çıkarır (gizliyse taşır, değilse ekler).
func bayrak_ac(b: String) -> void:
	var i := gizli_bayraklar.find(b)
	if i >= 0:
		gizli_bayraklar.remove_at(i)
	bayrak_ekle(b)


## Usta mı: açık bir `usta_*` bayrağı var ya da yeteneği 7 ve üstü.
func usta_mi() -> bool:
	if stat >= 7:
		return true
	for b in bayraklar:
		if b.begins_with("usta_"):
			return true
	return false


func kaydet() -> Dictionary:
	return {"id": id, "ad": ad, "adli_id": String(adli_id), "sinif": String(sinif), "portre": portre, "stat": stat,
		"bayraklar": Array(bayraklar), "gizli": Array(gizli_bayraklar), "moral": moral, "saglik": saglik,
		"sadakat": sadakat, "is_yeri": is_yeri, "kis_oncesi": kis_oncesi_is, "ev": ev, "ac": ac, "giris": giris_gunu}


static func kayittan(v: Dictionary) -> Koylu:
	var k := Koylu.new()
	k.id = int(v.get("id", 0))
	k.ad = String(v.get("ad", ""))
	k.adli_id = StringName(v.get("adli_id", ""))
	k.sinif = StringName(v.get("sinif", "ciftci"))
	k.portre = String(v.get("portre", ""))
	k.stat = int(v.get("stat", 5))
	k.bayraklar = PackedStringArray(v.get("bayraklar", []))
	k.gizli_bayraklar = PackedStringArray(v.get("gizli", []))
	k.moral = int(v.get("moral", 60))
	k.saglik = int(v.get("saglik", 100))
	k.sadakat = int(v.get("sadakat", 60))
	k.is_yeri = int(v.get("is_yeri", -1))
	k.kis_oncesi_is = int(v.get("kis_oncesi", -1))
	k.ev = int(v.get("ev", -1))
	k.ac = bool(v.get("ac", false))
	k.giris_gunu = int(v.get("giris", 0))
	return k
