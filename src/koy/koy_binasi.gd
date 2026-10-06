## Köyde kurulmuş (ya da kurulmakta olan) bir yapı.
class_name KoyBinasi
extends RefCounted

var id: int = 0
var tur: String = ""
## Sol üst hücre.
var hucre: Vector2i = Vector2i.ZERO
## 0 ya da 1: 1 ise boyut yan çevrilir (90°).
var yon: int = 0
## Kalan inşa günü; 0 = çalışıyor.
var insa_kalan: int = 0
## Seçili reçete (çok amaçlı yapılarda).
var recete: String = ""
## Girdisi yok ya da ambar dolu: beklemede (arayüz uyarısı).
var bekliyor: String = ""
## Kurulurken harcanan malzeme (yıkımda yarısı geri gelir).
var harcanan: Dictionary = {}


func boyut(katalog: BinaKatalogu) -> Vector2i:
	var b := katalog.boyut(tur)
	return Vector2i(b.y, b.x) if yon == 1 else b


func hazir() -> bool:
	return insa_kalan <= 0


func hucreler(katalog: BinaKatalogu) -> Array[Vector2i]:
	var s: Array[Vector2i] = []
	var b := boyut(katalog)
	for y in b.y:
		for x in b.x:
			s.append(hucre + Vector2i(x, y))
	return s


func kaydet() -> Dictionary:
	return {"id": id, "tur": tur, "x": hucre.x, "y": hucre.y, "yon": yon, "insa": insa_kalan, "recete": recete, "harcanan": harcanan.duplicate()}


static func kayittan(v: Dictionary) -> KoyBinasi:
	var b := KoyBinasi.new()
	b.id = int(v.get("id", 0))
	b.tur = String(v.get("tur", ""))
	b.hucre = Vector2i(int(v.get("x", 0)), int(v.get("y", 0)))
	b.yon = int(v.get("yon", 0))
	b.insa_kalan = int(v.get("insa", 0))
	b.recete = String(v.get("recete", ""))
	b.harcanan = v.get("harcanan", {})
	return b
