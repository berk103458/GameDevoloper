extends SceneTree

const SozSemasi := preload("res://src/soz/soz_semasi.gd")
const SozMotoru := preload("res://src/soz/soz_motoru.gd")
const BaglamSorgusu := preload("res://src/soz/baglam_sorgusu.gd")


func _init() -> void:
	var ustalar_veri := _json_oku("res://data/ustalar.json")
	var ustalar: Variant = ustalar_veri.get("ustalar", [])
	if not (ustalar is Array) or (ustalar as Array).size() < 4:
		push_error("YAP-03 data/ustalar.json en az 4 adli usta icermeli.")
		quit(1)
		return

	var csv_metin := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	var k2_sayisi := 0

	for u in ustalar:
		if not (u is Dictionary):
			push_error("YAP-03 usta kaydi Dictionary olmali.")
			quit(1)
			return
		var kayit := u as Dictionary
		if kayit.has("kalp"):
			push_error("YAP-03 usta kaydinda kalp alani olamaz: %s" % str(kayit.get("id", "")))
			quit(1)
			return
		var ad := String(kayit.get("ad", "")).strip_edges()
		if ad == "" or ad.to_lower().contains("şablon") or ad.to_lower().contains("sablon"):
			push_error("YAP-24 usta adsiz sablon olamaz: %s" % str(kayit))
			quit(1)
			return
		if int(kayit.get("kademe", 0)) >= 2:
			k2_sayisi += 1
		var pazarlik: Variant = kayit.get("pazarlik", {})
		if not (pazarlik is Dictionary) or int((pazarlik as Dictionary).get("ucret_koy_akce", 0)) <= 0:
			push_error("YAP-03 pazarlik ucret_koy_akce pozitif olmali: %s" % ad)
			quit(1)
			return
		if (pazarlik as Dictionary).has("muhafiz_akce"):
			push_error("YAP-03 usta ucreti kisisel keseden dusmez: %s" % ad)
			quit(1)
			return
		var soz_yolu := String(kayit.get("soz_dosyasi", ""))
		var en_yolu := soz_yolu.replace("res://data/soz/", "res://data/soz/en/")
		for yol in [soz_yolu, en_yolu]:
			var soz_veri := _json_oku(yol)
			var sema := SozSemasi.dogrula(soz_veri)
			if not bool(sema.get("gecerli", false)):
				push_error("YAP-03/YAP-24 sema hatasi (%s): %s" % [yol, str(sema.get("hatalar", []))])
				quit(1)
				return
			if String(soz_veri.get("adli_kisi", "")).strip_edges() == "":
				push_error("YAP-24 soz dosyasinda adli_kisi bos olamaz: %s" % yol)
				quit(1)
				return
			var motor := SozMotoru.new()
			if not motor.yukle(soz_veri, BaglamSorgusu.olustur({"tansiyon": 0})):
				push_error("YAP-03 SozMotoru yukle hatasi: %s" % yol)
				quit(1)
				return

		var anahtarlar: Variant = kayit.get("metin_anahtarlari", {})
		if not (anahtarlar is Dictionary):
			push_error("YAP-03 metin_anahtarlari eksik: %s" % ad)
			quit(1)
			return
		for k in (anahtarlar as Dictionary).values():
			var anahtar_str := String(k)
			if not csv_metin.contains(anahtar_str + ","):
				push_error("YAP-03 CSV anahtari eksik: %s" % anahtar_str)
				quit(1)
				return

	if k2_sayisi == 0:
		push_error("YAP-03 en az bir K2 ustasi bulunmali.")
		quit(1)
		return

	for ek_anahtar in [
		"yap28.cirak.usta_cocugu_baslangic",
		"yap28.cirak.usta_cocugu_tamam",
		"yap29.usta.nobet_ret"
	]:
		if not csv_metin.contains(ek_anahtar + ","):
			push_error("YAP-28/YAP-29 CSV anahtari eksik: %s" % ek_anahtar)
			quit(1)
			return

	print("YAP-03, YAP-24, YAP-28, YAP-29 ustalar metin ve soz agaci testi gecti.")
	quit(0)


func _json_oku(yol: String) -> Dictionary:
	var ham := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(ham)
	return parsed if parsed is Dictionary else {}
