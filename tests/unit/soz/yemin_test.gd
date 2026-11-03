# gdlint: disable=max-line-length
extends SceneTree

const Yemin = preload("res://src/soz/yemin.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var yemin_sistemi := Yemin.new()

	# 1. İnanç alanı boşken yemin düğmesi 0'dır (Kabul)
	if yemin_sistemi.yemin_uygun_mu({ "inanc": "" }):
		hatalar.append("İnanç alanı boşken yemin seçeneği uygun sayıldı! (Beklenen: 0)")

	# 2. Dört tutum dört ayrı sonuç verir (Kabul)
	# Tutum A: eder
	yemin_sistemi.temizle()
	var res_eder := yemin_sistemi.yemin_et({"inanc": "İslam", "yemin": {"tutum": "eder", "satirlar": ["Kuran hakkı için doğru söylerim."]}})
	if res_eder.get("tutum") != "eder" or not res_eder.get("ipucu").is_empty() or res_eder.get("yalan_yemin"):
		hatalar.append("'eder' tutumu hatalı sonuç verdi!")

	# Tutum B: kivranir
	yemin_sistemi.temizle()
	var res_kivranir := yemin_sistemi.yemin_et({"inanc": "İslam", "yemin": {"tutum": "kivranir", "satirlar": ["Yemin kolay iş değildir beyim..."]}})
	if res_kivranir.get("tutum") != "kivranir" or res_kivranir.get("ipucu") != "yemin_kacamak":
		hatalar.append("'kivranir' tutumu 'yemin_kacamak' ipucu üretmedi!")

	# Tutum C: rahat
	yemin_sistemi.temizle()
	var res_rahat := yemin_sistemi.yemin_et({"inanc": "İslam", "yemin": {"tutum": "rahat", "satirlar": ["El basarım, ne olacak!"]}})
	if res_rahat.get("tutum") != "rahat" or not res_rahat.get("yalan_yemin"):
		hatalar.append("'rahat' tutumu gizli yalan yemin bayrağını düşürmedi!")

	# Tutum D: reddeder
	yemin_sistemi.temizle()
	var res_reddeder := yemin_sistemi.yemin_et({"inanc": "Hristiyan", "yemin": {"tutum": "reddeder", "satirlar": ["İncil bize boş yere yemin etmeyi yasaklar."]}})
	if res_reddeder.get("tutum") != "reddeder" or not res_reddeder.get("ipucu").is_empty() or res_reddeder.get("yalan_yemin"):
		hatalar.append("'reddeder' tutumu haksız yalan/kaçamak üretti!")

	# 3. İkinci yemin seçeneği görünmez (Kabul)
	if yemin_sistemi.yemin_uygun_mu({"inanc": "İslam"}):
		hatalar.append("Aynı ziyarette ikinci yemin uygun sayıldı!")
	var res_ikinci := yemin_sistemi.yemin_et({"inanc": "İslam"})
	if res_ikinci.get("basarili", true):
		hatalar.append("İkinci yemin çağrısı başarılı oldu! (Beklenen: engellenmesi)")

	# 4. Yemin satırı zar atışı açmaz (Kabul)
	if res_eder.get("zar_atisi", true):
		hatalar.append("Yemin satırı zar atışı açtı!")

	# 5. Bozulan yemin ikinci ceza yazmaz (Kabul)
	var terazi := {}
	var ilk_ceza := yemin_sistemi.bozulma_cezasi_uygula(terazi)
	if not ilk_ceza or not terazi.get("yalan_yemin_edeni_aldi", false):
		hatalar.append("Bozulan yemin ilk cezayı yazmadı!")
	var ikinci_ceza := yemin_sistemi.bozulma_cezasi_uygula(terazi)
	if ikinci_ceza:
		hatalar.append("Bozulan yemin ikinci kez ceza yazdı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: yemin_test.gd")
	quit(0)
