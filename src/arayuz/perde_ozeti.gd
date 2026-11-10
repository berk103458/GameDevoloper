# gdlint: disable=max-line-length
class_name PerdeOzeti
extends RefCounted

## OMR-10: Perde 1 geçiş kadrajında köyün özeti (6 satır, resimsiz, defterden).

static func ozet_satirlari_uret(defter_verisi: Dictionary) -> Array[String]:
	var satirlar: Array[String] = []

	var gun := int(defter_verisi.get("gun", 1))
	var gelen := int(defter_verisi.get("toplam_gelen", 0))
	var kabul := int(defter_verisi.get("kabul_edilen", 0))
	var ret := int(defter_verisi.get("reddedilen", 0))
	var olu := int(defter_verisi.get("olu_sayisi", 0))
	var en_cok_anilan := str(defter_verisi.get("en_cok_anilan_karar", "Henüz karar verilmedi"))

	satirlar.append("1. Perde Sonu: %d. Gün Geride Kaldı" % gun)
	satirlar.append("Kapıya Gelen Toplam Can: %d" % gelen)
	satirlar.append("Kabul Edilen Can: %d" % kabul)
	satirlar.append("Geri Çevrilen Can: %d" % ret)
	satirlar.append("Köyde Yaşanan Can Kaybı: %d" % olu)
	satirlar.append("En Çok Hatırlanan Karar: %s" % en_cok_anilan)

	return satirlar


const OLU_META := &"toplam_olen"


static func olum_say(y: KoyYonetimi, olenler: Array) -> void:
	y.set_meta(OLU_META, int(y.get_meta(OLU_META, 0)) + olenler.size())


## Söylenti ağında en çok kişinin duyduğu doğru kayıt; hükme bağlanmış kayıt da sayılır, bozuk kopya ve yalan sayılmaz.
static func en_cok_anilan(o: Oturum) -> String:
	if o == null or not o.has_meta(SoylentiKoprusu.META):
		return ""
	var a: RefCounted = o.get_meta(SoylentiKoprusu.META)
	var en := -1
	var metin := ""
	for id in a.ag_kayitlari:
		var k: Dictionary = a.ag_kayitlari[id]
		if not bool(k.get("dogru", false)):
			continue
		var n: int = (k.get("duyanlar", []) as Array).size()
		var m := SoylentiKoprusu.olay_metni(a, k)
		if n > en and m != "":
			en = n
			metin = m
	return metin


static func oturumdan(o: Oturum) -> Array[String]:
	var y := o.yonetim
	var veri := {"gun": y.gun, "toplam_gelen": y.kabul_sayisi + y.ret_sayisi, "kabul_edilen": y.kabul_sayisi, "reddedilen": y.ret_sayisi, "olu_sayisi": int(y.get_meta(OLU_META, 0))}
	var anilan := en_cok_anilan(o)
	if anilan != "":
		veri["en_cok_anilan_karar"] = anilan
	return ozet_satirlari_uret(veri)
