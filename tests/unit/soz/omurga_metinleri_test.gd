# gdlint: disable=max-line-length
extends SceneTree

const PerdeMetni = preload("res://src/sistemler/perde_metni.gd")
const GecisGecesi = preload("res://src/sistemler/gecis_gecesi.gd")
const PerdeOzeti = preload("res://src/arayuz/perde_ozeti.gd")
const SonUyarisi = preload("res://src/sistemler/son_uyarisi.gd")
const SozSemasi = preload("res://src/soz/soz_semasi.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	# ----------------------------------------------------
	# 1. KOP-07: data/soz/sonlar.json doğrulama
	# ----------------------------------------------------
	var dosya := FileAccess.open("res://data/soz/sonlar.json", FileAccess.READ)
	if not dosya:
		hatalar.append("data/soz/sonlar.json dosyası açılamadı!")
	else:
		var parsed = JSON.parse_string(dosya.get_as_text())
		if not parsed is Dictionary:
			hatalar.append("sonlar.json sözlük biçiminde değil!")
		else:
			var sonlar: Dictionary = parsed.get("sonlar", {})
			# KOP-07: Tam olarak 5 nihai son kimliği olmalı
			if sonlar.size() != 5:
				hatalar.append("KOP-07: sonlar.json içinde tam 5 son olmalı! (Mevcut: %d)" % sonlar.size())
			for beklenen in ["tekfur_haraccisi", "ertugrul_obasi", "beyin_uc_koyu", "ahi_kasabasi", "uc_tutundu"]:
				if not sonlar.has(beklenen):
					hatalar.append("KOP-07: Beklenen son eksik: %s" % beklenen)

			var epilog: Dictionary = parsed.get("epilog", {})
			for gosterge in ["huzur", "adalet", "refah", "guvenlik", "nufus", "yozlasma"]:
				if not epilog.has(gosterge):
					hatalar.append("KOP-07: Epilog göstergesi eksik: %s" % gosterge)

	# ----------------------------------------------------
	# 2. OMR-07: Perde geçişi metin anahtarı
	# ----------------------------------------------------
	var gecis_metni := PerdeMetni.metin_al("basladi", 12, 1)
	if not gecis_metni.contains("Köy oturdu"):
		hatalar.append("OMR-07: PerdeMetni beklenen metni üretmedi! (%s)" % gecis_metni)

	# ----------------------------------------------------
	# 3. OMR-08: Geçiş gecesinde gelen sayısı 0
	# ----------------------------------------------------
	# Sahte bir KoyYonetimi temsili
	var sahte_yonetim := RefCounted.new()
	sahte_yonetim.set_meta(&"perde2_baslangic", 5)
	sahte_yonetim.set("gun", 5)
	sahte_yonetim.set("agalik", true)
	var gelen := GecisGecesi.gelen_sayisi_filtrele(sahte_yonetim, 4)
	if gelen != 0:
		hatalar.append("OMR-08: Geçiş gecesinde gelen sayısı 0 filtrelenmedi! (%d)" % gelen)

	# ----------------------------------------------------
	# 4. OMR-10: Geçiş kadrajında 6 satırlık özet
	# ----------------------------------------------------
	var ozet := PerdeOzeti.ozet_satirlari_uret({
		"gun": 12,
		"toplam_gelen": 30,
		"kabul_edilen": 18,
		"reddedilen": 12,
		"olu_sayisi": 1,
		"en_cok_anilan_karar": "Casus yakalandı"
	})
	if ozet.size() != 6:
		hatalar.append("OMR-10: Perde özeti 6 satır üretmedi! (Mevcut: %d)" % ozet.size())

	# ----------------------------------------------------
	# 5. OMR-16: Kayıp sonları erken uyarısı
	# ----------------------------------------------------
	var uyari := SonUyarisi.erken_uyari_al("isyan", 2)
	if not uyari.has("anahtar") or uyari.get("anahtar") != "uyari.kayip_son.isyan_yaklasti":
		hatalar.append("OMR-16: İsyan erken uyarısı doğru üretilemedi!")
	var uzak_uyari := SonUyarisi.erken_uyari_al("isyan", 5)
	if not uzak_uyari.is_empty():
		hatalar.append("OMR-16: 2 geceden uzakken uyarı verildi, boş dönmeliydi!")

	# ----------------------------------------------------
	# 6. KOP-01, KOP-02, KOP-08: Söz dosyaları doğrulaması
	# ----------------------------------------------------
	var sema := SozSemasi.new()
	for soz_dosyasi in ["res://data/soz/divan_sanik.json", "res://data/soz/heyet_elci.json", "res://data/soz/tuccar_kapi.json"]:
		var d := FileAccess.open(soz_dosyasi, FileAccess.READ)
		if not d:
			hatalar.append("Söz dosyası açılamadı: %s" % soz_dosyasi)
			continue
		var soz_json = JSON.parse_string(d.get_as_text())
		var dogrulama := sema.dogrula(soz_json)
		if not dogrulama.get("gecerli", false):
			hatalar.append("Söz şeması hatası (%s): %s" % [soz_dosyasi, str(dogrulama.get("hatalar", []))])

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("PASS: OMR-07..18 ve KOP-01..08 metin ve omurga testleri basariyla tamamlandi.")
	quit(0)
