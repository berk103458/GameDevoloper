## EKO-09: gece tüketimi ve oyuncu önizlemesinin ortak salt okunur hesabı.
class_name TuketimDengesi
extends RefCounted
## Her yaş grubundaki yaşayan köylü için gerçek iklim ihtiyacını hesaplar.
static func gerek(y: KoyYonetimi) -> Dictionary:
	var tablo = preload("res://src/sistemler/denge_tablosu.gd")
	var zorluk := String(y.get_meta(&"zorluk", "olagan"))
	var kisi_gida := y.a.gida_kisi * IklimDeneyi.gida_carpani(y) * tablo.zorluk_carpani(tablo.oku(), zorluk) * DunyaEtkisi.y_carpani(y, "tuketim")
	return {"gida": ceili(y.nufus() * kisi_gida), "odun": MevsimTuketimAdaptoru.odun(y), "kisi_gida": kisi_gida}
## Gerçek HUD kaynak kartının gecelik ihtiyaç ve eksik kaynak açıklaması.
static func tip(y: KoyYonetimi, tur: String) -> String:
	var ihtiyac := int(gerek(y).get(tur, 0))
	var ad := "Erzak" if tur == "gida" else "Odun"
	return ("%s · Gecelik ihtiyaç: %d (nüfus: %d)\n%s" % [ad, ihtiyac, y.nufus(), "Karşılanamayan ihtiyaç sağlık kaybı ve ölüme yol açabilir." if ihtiyac > 0 else ("Canlı nüfus olmadığı için tüketim yok." if y.nufus() == 0 else "Mevcut iklimde yakacak ihtiyacı yok.")]) + DonmaYoneticisi.tip(y, tur)
