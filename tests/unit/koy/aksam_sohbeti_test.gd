# gdlint: disable=max-line-length
extends SceneTree

const AksamSohbeti = preload("res://src/koy/aksam_sohbeti.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	AksamSohbeti.sifirla()

	# 1. Ağır kararlı gecede rapor öncesi sohbet 1 kez açılır
	var kararlar := [
		{"konu_id": "aileyi_bolmek", "ziyaret_sirasi": 1}
	]
	var secim := AksamSohbeti.konu_sec(kararlar, 1, {"es_meslegi": "ebe", "es_hayatta": true})
	if secim.is_empty():
		hatalar.append("Ağır kararlı gecede sohbet açılmadı!")
	elif secim.get("konu_id") != "aileyi_bolmek":
		hatalar.append("Ağır karar 'aileyi_bolmek' seçilmedi; seçilen: %s" % secim.get("konu_id"))

	# 2. Aynı kararla ertesi gece 0 kez açılır (aynı karar tekrar seçilmez)
	var ertesi_secim := AksamSohbeti.konu_sec(kararlar, 1, {"es_meslegi": "ebe", "es_hayatta": true})
	if not ertesi_secim.is_empty():
		hatalar.append("Aynı kararla ertesi gece sohbet açıldı! (Beklenen: 0)")

	# 3. Atlama barı değiştirmez
	var atlama_sonuc := AksamSohbeti.atla()
	if not atlama_sonuc.get("atlandi", false):
		hatalar.append("Atla çağrısı 'atlandi: true' döndürmedi!")
	if atlama_sonuc.get("moral_etkisi", 1) != 0:
		hatalar.append("Atlama çağrısı moral etkiledi! (Beklenen: 0)")

	# 4. Eş ölmüşken tetik 0'dır
	var olu_es_secim := AksamSohbeti.konu_sec([{"konu_id": "rusvet_almak", "ziyaret_sirasi": 2}], 2, {"es_oldu": true})
	if not olu_es_secim.is_empty():
		hatalar.append("Eş ölmüşken akşam sohbeti açıldı!")

	# 5. Meclis gecesinde sohbet 0'dır
	var meclis_secim := AksamSohbeti.konu_sec([{"konu_id": "rusvet_almak", "ziyaret_sirasi": 3}], 3, {"meclis_gecesi": true, "es_hayatta": true})
	if not meclis_secim.is_empty():
		hatalar.append("Meclis gecesinde akşam sohbeti açıldı!")

	# 6. Sohbet metni kalp anahtarı yazmaz ve yeni ses dosyası eklemez
	var veri := AksamSohbeti.veri_al()
	var json_str := JSON.stringify(veri)
	if "kalp" in json_str.to_lower() or "heart" in json_str.to_lower():
		hatalar.append("Sohbet metninde yasaklı kalp/romans anahtarı bulundu!")
	if ".ogg" in json_str.to_lower() or ".wav" in json_str.to_lower() or ".mp3" in json_str.to_lower():
		hatalar.append("Sohbet verisinde ses dosyası referansı bulundu!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: aksam_sohbeti_test.gd")
	quit(0)
