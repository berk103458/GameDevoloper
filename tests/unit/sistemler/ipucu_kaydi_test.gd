extends SceneTree

const IpucuKaydiSinifi = preload("res://src/sistemler/ipucu_kaydi.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("IPUCU KAYDI TEST HATASI: " + mesaj)


func _initialize() -> void:
	# OGR-10: Ayni ipucu iki kez cikmaz
	var kayit := IpucuKaydiSinifi.new()
	_kontrol(kayit.ipucu_ekle("ipucu_kapi"), "Ilk ekleme basarili olmali")
	_kontrol(not kayit.ipucu_ekle("ipucu_kapi"), "Mukerrer ipucu eklenmemeli")
	_kontrol(kayit.gorulen_sayisi() == 1, "Gorulen sayisi 1 olmali")

	# OGR-10: 6 ipucu eklenince son 5 ipucu hafiza defteri not sayfasinda
	kayit.ipucu_ekle("ipucu_koy")
	kayit.ipucu_ekle("ipucu_gece")
	kayit.ipucu_ekle("ipucu_zar")
	kayit.ipucu_ekle("ipucu_bar")
	kayit.ipucu_ekle("ipucu_heybe") # toplam 6 oldu
	_kontrol(kayit.gorulen_sayisi() == 6, "Toplam 6 ipucu olmali")

	var son_5: Array[String] = kayit.defter_not_sayfasi(5)
	_kontrol(son_5.size() == 5, "Defter not sayfasinda en cok 5 satir olmali")
	_kontrol(not son_5.has("ipucu_kapi"), "Ilk eklenen ipucu (ipucu_kapi) 5 elemanlik listeden cikmali")
	_kontrol(son_5.has("ipucu_heybe"), "En son eklenen ipucu listede olmali")

	# OGR-51: Devam eden kayitta ipucu durumu kayittan gelir; ikisi celisirse kayit kazanir.
	var kayit_soz := {
		"ogretici": {
			"gorulen": ["ipucu_a", "ipucu_b", "ipucu_c"]
		}
	}
	var cozum := IpucuKaydiSinifi.durum_coz(kayit_soz, true) # ayar ilk_oyun_bitti = true olsa bile
	_kontrol(cozum.size() == 3, "Kayittaki 3 ipucu korunmali (kayit kazanir)")
	_kontrol(cozum.has("ipucu_a") and cozum.has("ipucu_c"), "Kayit alanindaki ogeler donmeli")

	# Kayitta alan yoksa ve eski kayitsa oyun cokmemeli
	var eski_kayit := {}
	var bos_cozum := IpucuKaydiSinifi.durum_coz(eski_kayit, false)
	_kontrol(bos_cozum.is_empty(), "Eski kayitta alan yoksa bos liste donmeli")

	var yeni_kayit_obj := IpucuKaydiSinifi.new()
	_kontrol(yeni_kayit_obj.kayittan_oku(eski_kayit), "Eski kayit yuklenirken cokmemeli")
	_kontrol(yeni_kayit_obj.gorulen_sayisi() == 0, "Eski kayit sonrasi gorulen 0 olmali")

	if _hata == 0:
		print("IPUCU KAYDI (OGR-10, OGR-51): GEÇTİ (0 hata)")
	else:
		print("IPUCU KAYDI: KALDI (%d hata)" % _hata)
	quit(_hata)
