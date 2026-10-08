## MEV-12: mevcut HUD takvim etiketi; ikinci HUD veya oyun saati yok.
class_name MevsimTakvim
extends RefCounted
const HAVALAR := {"normal":"Açık", "kar_firtinasi":"Tipi", "kuraklik":"Kuraklık", "yagmur":"Yağmur", "sis":"Sis"}
## Tek mevsim/yıl kaynağı salt okunur; Admin önayarı gerçek takvimden ayrılır.
static func metin(y: KoyYonetimi) -> String:
	var d := MevsimYoneticisi.durum(y)
	var ad := TranslationServer.translate("koy.mevsim." + String(d.ad))
	return "%s · %d/%d · %s\n%d. yıl · %d/%d" % [ad, d.mevsim_gunu, d.mevsim_suresi, HAVALAR.get(d.hava, "Açık"), d.yil, d.yil_gunu, d.yil_uzunlugu]
## Mevcut etiketi yerinde günceller; sinyal, kare döngüsü veya düğüm eklemez.
static func guncelle(etiket: Label, y: KoyYonetimi) -> void:
	etiket.text = metin(y)
	var d := MevsimYoneticisi.durum(y)
	etiket.tooltip_text = "Yılın %d. günü / %d · Sonraki mevsime %d gün.\nHava: %s%s" % [d.yil_gunu, d.yil_uzunlugu, d.sonraki_mevsime, HAVALAR.get(d.hava, "Açık"), " · Deney mevsimi; takvim ilerlemedi." if d.zorlanmis else ""]
