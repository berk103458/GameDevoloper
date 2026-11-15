## ACL-04: muhafızın eşi ilk ailede yanında durur ve ipucunu kendi ağzından, ayrı satırda verir.
## Ziyaretçinin açılış repliği Gelen.acilis'tedir; eş ipucu oraya yazılmaz.
class_name IlkAileEsIpucu
extends RefCounted

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI_ACILISI = preload("res://src/sistemler/kapi_acilis_olayi.gd")


static func satirlar(o: Oturum, g: Gelen) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if g == null or g.id != KAPI_ACILISI.AILE or not KAPI_ACILISI.aile_bekliyor(o):
		return sonuc
	var es := o.yonetim.koylu(int(ACILIS.durum(o).get("es_id", -1)))
	if es == null or es.saglik <= 0:
		return sonuc
	sonuc.append("[color=#C8A477][b]%s:[/b][/color] [i]%s[/i]" % [
		TranslationServer.translate("arayuz.kapi.es_ipucu"),
		TranslationServer.translate(String(KAPI_ACILISI.AYAR.es_sozu))])
	return sonuc
