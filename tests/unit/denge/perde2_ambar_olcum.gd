## OMR-43: altı gerçek Perde 2 gecesinin erzak bilançosu.
extends SceneTree


func _initialize() -> void:
	var katalog := Katalog.new()
	if katalog.yukle() != Katalog.Durum.HAZIR:
		quit(1)
		return
	var o := Oturum.new(katalog, int(OS.get_environment("TOHUM")))
	var y := o.yonetim
	# Kontrollü barınak ve ambarla gecelik erzak değişimini ölç.
	for tur in ["kulube", "ambar"]:
		var bina := KoyBinasi.new()
		bina.id = y._sonraki_id
		y._sonraki_id += 1
		bina.tur = tur
		bina.seviye = 40
		y.binalar.append(bina)
	y._ambar_kapasitesi()
	y.kaynaklar.ekle("gida", 400)
	y.kaynaklar.ekle("su", 180)
	for i in y.a.agalik_nufus:
		y.kabul({"ad": "Köylü %d" % i})
	var gecis := o.gece_sonu()
	if not gecis.perde_degisti or DengeOlcumu.olustur(o, gecis).has("perde2_ambar"):
		push_error("Geçiş gecesi Perde 2 ambar ölçümüne katılamaz")
		quit(1)
		return
	var geceler: Array[Dictionary] = []
	for i in 6:
		var rapor := o.gece_sonu()
		var once := JSON.stringify(o.kaydet())
		var olcum := DengeOlcumu.olustur(o, rapor)
		var satir: Dictionary = olcum.get("perde2_ambar", {})
		if satir.get("gece") != o.gun or satir.get("sonra") != o.ambar or JSON.stringify(o.kaydet()) != once:
			push_error("Perde 2 ambar ölçümü kaynağıyla uyuşmuyor")
			quit(1)
			return
		geceler.append(satir)
	print("PERDE2_AMBAR ", JSON.stringify({"tohum": str(o.tohum), "geceler": geceler}))
	quit(0)
