extends SceneTree

const KayitGocuSozSinifi = preload("res://src/sistemler/kayit_gocu_soz.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("KAY-04 TEST HATASI: " + mesaj)


func _initialize() -> void:
	# 1. data/ayarlar/icerik.tres okunur
	var okunan_icerik := KayitGocuSozSinifi.icerik_surumu_oku()
	_kontrol(okunan_icerik >= 1, "icerik.tres icinden icerik_surumu okunmali")

	# 2. icerik_surumu artinca kisi hafizasi silinmez; kayit surumu artinca katalog bastan kurulmaz
	var eski_kayit := {
		"surum": 3,
		"icerik_surumu": 1,
		"kisi_hafizasi": {"chr_yusuf": {"ziyaret": 2, "guven": 4}},
		"katalog_kuruldu": true,
		"kapi_eylemleri": ["muhur_bak", "heybe_ara", "muhur_bak"],
		"gun_turu": "bos",
	}
	var hazir := KayitGocuSozSinifi.kay04_hazirla(eski_kayit, 2)
	_kontrol(int(hazir.get("surum", 0)) == 3 and int(hazir.get("icerik_surumu", 0)) == 2, "Iki sayac (surum ve icerik_surumu) bagimsiz olmali")
	_kontrol(hazir.get("kisi_hafizasi", {}).has("chr_yusuf"), "icerik_surumu artinca kisi hafizasi silinmemeli")
	_kontrol(bool(hazir.get("katalog_kuruldu", false)), "Katalog bastan kurulmamali")

	# 3. Ek sartlar: sabah defteri satiri, sabah gun sayaci, eylem listesi, tekil eylem, bos gun
	_kontrol(String(hazir.get("sabah_defteri_satiri", "x")) == "", "Eski kayitta sabah defteri satiri yoksa bos sayilmali")
	_kontrol(int(hazir.get("sabah_gun_sayaci", -1)) == 0, "Eski kayitta sabah gun sayaci yoksa 0 sayilmali ve yukleme artirmamali")
	var eylemler: Array = hazir.get("kapi_eylemleri", [])
	_kontrol(eylemler.size() == 2, "Ayni kapi eylemi ikinci kez uygulanmamali (tekillestirilmeli)")
	_kontrol(String(hazir.get("gun_turu", "")) == "bos", "Bos gun kayitta bos turuyle durmali")

	var alansiz := KayitGocuSozSinifi.kay04_hazirla({"surum": 3})
	_kontrol((alansiz.get("kapi_eylemleri", null) is Array) and (alansiz["kapi_eylemleri"] as Array).is_empty(), "Eski kayitta eylem listesi yoksa bos liste sayilmali")
	_kontrol(String(alansiz.get("gun_turu", "x")) == "", "Bos gun alani yoksa o gun yok sayilmali")

	if _hata == 0:
		print("KAY-04: GEÇTİ (0 hata)")
	else:
		print("KAY-04: KALDI (%d hata)" % _hata)
	quit(_hata)
