extends SceneTree

const OlayOnKosulu = preload("res://src/sistemler/olay_on_kosulu.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OZL KART TARAMA TEST HATASI: " + mesaj)


func _dosyalari_tara(klasor: String, aranan_ad: String) -> int:
	var sayac := 0
	var dir := DirAccess.open(klasor)
	if dir == null:
		return 0
	dir.list_dir_begin()
	var ad := dir.get_next()
	while not ad.is_empty():
		if ad != "." and ad != "..":
			var tam_yol := klasor.path_join(ad)
			if dir.current_is_dir():
				sayac += _dosyalari_tara(tam_yol, aranan_ad)
			elif ad.to_lower() == aranan_ad.to_lower():
				sayac += 1
		ad = dir.get_next()
	dir.list_dir_end()
	return sayac


func _initialize() -> void:
	# OZL-01: olay_secici adli ikinci dosya 0 olmali; mevcut Oturum.olay_sec BUG-16 ve KAP-19 ile calisir
	var ikinci_secici_sayisi := _dosyalari_tara("res://src", "olay_secici.gd")
	_kontrol(ikinci_secici_sayisi == 0, "src/ altinda olay_secici.gd adli ikinci dosya 0 olmali")

	var kat := Katalog.new()
	kat.yukle()
	var oturum := Oturum.new(kat, 42)
	_kontrol(not OlayOnKosulu.uygun(oturum, {"cocuk_var": true}), "Cocuksuz koyde cocuk_var kosulu BUG-16 ile false donmeli")
	_kontrol(not OlayOnKosulu.havuzda(oturum, &"dugun"), "Kucuk haneli koyde dugun KAP-19 havuzunda olmamali")

	# OZL-04: tek_sefer karti (dervis, dugun) 30 gecede en cok 1 kez gelir
	oturum.ayarlar.olay_olasiligi = 1.0
	for i in range(8):
		var k := oturum.yonetim.kabul({"ad": "Koylu_%d" % i})
		k.yas_grubu = &"yetiskin"
		k.hane_id = i + 1
	var dervis_sayisi := 0
	var dugun_sayisi := 0
	for g in range(1, 31):
		oturum.yonetim.gun = g
		var secilen := oturum.olay_sec()
		if secilen != null:
			if secilen.id == &"dervis":
				dervis_sayisi += 1
			elif secilen.id == &"dugun":
				dugun_sayisi += 1
	_kontrol(dervis_sayisi <= 1, "dervis tek_sefer ise 30 gecede en cok 1 kez gelmeli (gelen=%d)" % dervis_sayisi)
	_kontrol(dugun_sayisi <= 1, "dugun tek_sefer ise 30 gecede en cok 1 kez gelmeli (gelen=%d)" % dugun_sayisi)

	# OZL-05: Havuz bos + olay_olasiligi 1 olsa bile kart 0, rapor "bu gece köy sessiz" yazar ve faz gecer
	var bos_kat := Katalog.new()
	bos_kat.yukle()
	bos_kat._olaylar.clear()
	var bos_oturum := Oturum.new(bos_kat, 77)
	bos_oturum.ayarlar.olay_olasiligi = 1.0
	var bos_kart := bos_oturum.olay_sec()
	var bos_rapor := {"olaylar": []}
	GeceBilancosu.sessiz_gece_kontrol(bos_kart, bos_rapor)
	_kontrol(bos_kart == null and bos_rapor.olaylar.size() == 1 and bos_rapor.olaylar[0].get("anahtar") == "bu gece köy sessiz", "Havuz bosken kart 0 olmali ve 'bu gece köy sessiz' satiri yazilmali")

	# OZL-12: Tarla kartlari dort mevsimde Takvim (mevsim, kis_mi) okur; kista tarla_yagmur 0
	var tarla_bina := KoyBinasi.new()
	tarla_bina.tur = "tarla"
	oturum.yonetim.binalar.append(tarla_bina)
	var yagmur_kart := kat.olay(&"tarla_yagmur")
	var m_gun := oturum.yonetim.a.mevsim_gun
	for mevsim_idx in range(4):
		oturum.yonetim.gun = mevsim_idx * m_gun
		var uygun_mu := oturum._kosul_tutar(yagmur_kart.kosullar)
		if mevsim_idx == 3:
			_kontrol(not uygun_mu, "Kista (mevsim 3) tarla_yagmur 0 olmali")
		else:
			_kontrol(uygun_mu, "Kis disindaki mevsimlerde tarla_yagmur uygun olmali")

	# OZL-13: 7 gece boyunca harman ve pazar_gunu hafta basi olmayan gecede taban, hafta basinda carpan alir
	var harman_kart := kat.olay(&"harman")
	var pazar_kart := kat.olay(&"pazar_gunu")
	for gun_idx in range(1, 8):
		oturum.yonetim.gun = gun_idx
		var hb := Takvim.hafta_basi(gun_idx, m_gun)
		var h_agirlik := OlayOnKosulu.agirlik(oturum, harman_kart)
		var p_agirlik := OlayOnKosulu.agirlik(oturum, pazar_kart)
		if hb:
			_kontrol(h_agirlik > harman_kart.agirlik and p_agirlik > pazar_kart.agirlik, "Hafta basinda harman ve pazar_gunu agirligi carpan almali")
		else:
			_kontrol(is_equal_approx(h_agirlik, harman_kart.agirlik) and is_equal_approx(p_agirlik, pazar_kart.agirlik), "Hafta basi olmayan gecede agirlik taban kalmali")

	if _hata == 0:
		print("OZL KART TARAMA: GEÇTİ (0 hata)")
	else:
		print("OZL KART TARAMA: KALDI (%d hata)" % _hata)
	quit(_hata)
