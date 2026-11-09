extends SceneTree

const SozSemasi := preload("res://src/soz/soz_semasi.gd")
const SozMotoru := preload("res://src/soz/soz_motoru.gd")

var hata_sayisi: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		push_error("HATA: %s" % mesaj)
		hata_sayisi += 1


func _init() -> void:
	var ustalar_veri := _json_oku("res://data/ustalar.json")
	var ustalar: Variant = ustalar_veri.get("ustalar", [])
	_kontrol(ustalar is Array and (ustalar as Array).size() >= 4, "YAP-03 data/ustalar.json en az 4 adli usta icermeli.")

	var csv_metin := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	var k2_sayisi := 0

	if ustalar is Array:
		for u in ustalar:
			if not (u is Dictionary):
				_kontrol(false, "YAP-03 usta kaydi Dictionary olmali.")
				continue
			var kayit := u as Dictionary
			_kontrol(not kayit.has("kalp"), "YAP-03 usta kaydinda kalp alani olamaz: %s" % str(kayit.get("id", "")))
			var ad := String(kayit.get("ad", "")).strip_edges()
			_kontrol(ad != "" and not ad.to_lower().contains("şablon") and not ad.to_lower().contains("sablon"), "YAP-24 usta adsiz sablon olamaz: %s" % str(kayit))
			if int(kayit.get("kademe", 0)) >= 2:
				k2_sayisi += 1
			var pazarlik: Variant = kayit.get("pazarlik", {})
			_kontrol(pazarlik is Dictionary and int((pazarlik as Dictionary).get("ucret_koy_akce", 0)) > 0, "YAP-03 pazarlik ucret_koy_akce pozitif olmali: %s" % ad)
			if pazarlik is Dictionary:
				_kontrol(not (pazarlik as Dictionary).has("muhafiz_akce"), "YAP-03 usta ucreti kisisel keseden dusmez: %s" % ad)
			var soz_yolu := String(kayit.get("soz_dosyasi", ""))
			var en_yolu := soz_yolu.replace("res://data/soz/", "res://data/soz/en/")
			for yol in [soz_yolu, en_yolu]:
				var soz_veri := _json_oku(yol)
				var sema: Array[String] = SozSemasi.dogrula(soz_veri)
				_kontrol(sema.is_empty(), "YAP-03/YAP-24 sema hatasi (%s): %s" % [yol, str(sema)])
				_kontrol(String(soz_veri.get("adli_kisi", "")).strip_edges() != "", "YAP-24 soz dosyasinda adli_kisi bos olamaz: %s" % yol)
				var motor := SozMotoru.new()
				var yukle_sonuc := motor.yukle(soz_veri, {"tansiyon": 0})
				_kontrol(not yukle_sonuc.is_empty(), "YAP-03 SozMotoru yukle hatasi: %s" % yol)

			var anahtarlar: Variant = kayit.get("metin_anahtarlari", {})
			_kontrol(anahtarlar is Dictionary, "YAP-03 metin_anahtarlari eksik: %s" % ad)
			if anahtarlar is Dictionary:
				for k in (anahtarlar as Dictionary).values():
					var anahtar_str := String(k)
					_kontrol(csv_metin.contains(anahtar_str + ","), "YAP-03 CSV anahtari eksik: %s" % anahtar_str)

	_kontrol(k2_sayisi > 0, "YAP-03 en az bir K2 ustasi bulunmali.")

	for ek_anahtar in [
		"yap28.cirak.usta_cocugu_baslangic",
		"yap28.cirak.usta_cocugu_tamam",
		"yap29.usta.nobet_ret"
	]:
		_kontrol(csv_metin.contains(ek_anahtar + ","), "YAP-28/YAP-29 CSV anahtari eksik: %s" % ek_anahtar)

	if hata_sayisi > 0:
		push_error("YAP-03/24/28/29 testi BASARISIZ (Toplam hata: %d)" % hata_sayisi)
		quit(1)
	else:
		print("YAP-03, YAP-24, YAP-28, YAP-29 ustalar metin ve soz agaci testi gecti (0 hata).")
		quit(0)


func _json_oku(yol: String) -> Dictionary:
	var ham := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(ham)
	return parsed if parsed is Dictionary else {}
