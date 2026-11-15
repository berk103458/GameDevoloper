# gdlint: disable=max-line-length
extends SceneTree

const Hane = preload("res://src/koy/hane.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var hane := Hane.new("dokumaci")

	# ----------------------------------------------------
	# İddia 1: Üç gün hane döngüsü
	# ----------------------------------------------------
	# Gün 1: Sabah satırı, iş çıktısı, misafir ve duyum
	var sabah1 := hane.sabah_satiri_al(1)
	if sabah1.is_empty():
		hatalar.append("Gün 1 sabah satırı boş geldi!")

	var cikti1 := hane.is_ciktisi_al()
	if cikti1.get("cikti") != "kumas":
		hatalar.append("Dokumacı eş kumas üretmedi!")

	var duyum1 := hane.duyum_dinle(1, "kervan_01")
	if not duyum1.has("ipucu_anahtari") or duyum1.get("ipucu_anahtari") != "clue_es_kervan_01":
		hatalar.append("Gün 1 duyumu ipucu anahtarı üretmedi!")

	var misafir_sonuc := hane.misafir_al("chr_022", "hediye")
	if not misafir_sonuc.get("kabul"):
		hatalar.append("Misafir haneye kabul edilmedi!")
	if hane.kasa_akce != 12: # Başlangıç 10 + 2 hediye
		hatalar.append("Hediye bırakan misafir hane kasasını 2 akçe artırmadı! (Mevcut: %d)" % hane.kasa_akce)

	# Gün 2: Maaş haneye girer, rüşvet girmez
	hane.maas_al(5)
	if hane.kasa_akce != 17:
		hatalar.append("Maaş hane kasasına eklenmedi! (Mevcut: %d)" % hane.kasa_akce)
	if hane.rusvet_engelle(10):
		hatalar.append("Rüşvet haneye kabul edildi, engellenmeliydi!")

	# Gün 3: Hafta başı sofra kurulur, moral artar
	var sofra3 := hane.sofra_kur(3)
	if not sofra3.get("sofra_acildi"):
		hatalar.append("Gün 3 sofrası açılamadı!")
	if hane.es_moral <= 50:
		hatalar.append("Sofra sonrası eş morali artmadı!")

	var eve_donus := hane.eve_donus_satiri("casus_kovuldu")
	if not eve_donus.contains("casus_kovuldu"):
		hatalar.append("Eve dönüş satırı en ağır kararı yansıtmadı!")

	# HAN-16: Yetim kapasitesi (en çok 2 yetim)
	if not hane.yetim_al("yetim_1"):
		hatalar.append("1. yetim haneye kabul edilmedi!")
	if not hane.yetim_al("yetim_2"):
		hatalar.append("2. yetim haneye kabul edilmedi!")
	if hane.yetim_al("yetim_3"):
		hatalar.append("3. yetim boş yatak olmamasına rağmen kabul edildi!")

	# ----------------------------------------------------
	# İddia 2: Eş ölümü sonrası dört kanca 0
	# ----------------------------------------------------
	hane.es_olumu()

	# Kanca 1: Sabah satırı 0
	if not hane.sabah_satiri_al(4).is_empty():
		hatalar.append("Eş ölümü sonrası sabah satırı boş dönmedi!")

	# Kanca 2: Sofra açılmaz (0)
	var sofra_olum := hane.sofra_kur(4)
	if sofra_olum.get("sofra_acildi"):
		hatalar.append("Eş ölümü sonrası sofra kuruldu!")

	# Kanca 3: Duyum dinlenmez (0)
	var duyum_olum := hane.duyum_dinle(4, "yeni_duyum")
	if not duyum_olum.is_empty():
		hatalar.append("Eş ölümü sonrası duyum açıldı!")

	# Kanca 4: Akşam sohbeti uygunluğu 0
	if hane.aksam_sohbeti_uygun_mu():
		hatalar.append("Eş ölümü sonrası akşam sohbeti kancası açık kaldı!")

	# ----------------------------------------------------
	# İddia 3: Kayıt KAY zincirinden geçer
	# ----------------------------------------------------
	var kayit_verisi := hane.kayit_verisi_al()
	if not kayit_verisi.has("kasa_akce") or not kayit_verisi.has("es_hayatta"):
		hatalar.append("KAY kayıt verisi eksik alanlar içeriyor!")

	var yeni_hane := Hane.new("firinci")
	yeni_hane.kayit_verisi_yukle(kayit_verisi)
	if yeni_hane.kasa_akce != hane.kasa_akce:
		hatalar.append("KAY yüklemesinde kasa_akce uyuşmadı!")
	if yeni_hane.es_hayatta != hane.es_hayatta:
		hatalar.append("KAY yüklemesinde es_hayatta uyuşmadı!")
	if yeni_hane.yetimler.size() != 2:
		hatalar.append("KAY yüklemesinde yetimler sayısı uyuşmadı!")

	# ----------------------------------------------------
	# İddia 4: Gerçek Oturum & KoyYonetimi.kaydet/kayittan içinde HAN-01 Hane kaydı + eski kayıt türetimi
	# ----------------------------------------------------
	var kat := Katalog.new()
	kat.yukle()
	var oturum := Oturum.new(kat, 5151)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(oturum)
	oturum.yonetim.hane.sofra_kur(3)
	oturum.yonetim.hane.maas_al(15)
	var tam_kayit := oturum.kaydet()
	var koy_kayit: Dictionary = tam_kayit.get("koy_yonetimi", {})
	if not koy_kayit.has("hane"):
		hatalar.append("KoyYonetimi.kaydet() içine 'hane' alanı yazılmadı!")
	var h_kayit: Dictionary = koy_kayit.get("hane", {})
	if int(h_kayit.get("ev_id", -1)) < 0 or (h_kayit.get("uyeler", []) as Array).size() < 2 or int(h_kayit.get("son_sofra_gunu", -1)) != 3:
		hatalar.append("KoyYonetimi 'hane' sözlüğü ev_id, uyeler veya son_sofra_gunu eksik!")

	var yuklenen := Oturum.kayittan(kat, tam_kayit)
	if yuklenen == null or yuklenen.yonetim.hane.kasa_akce != 25 or yuklenen.yonetim.hane.son_sofra_gunu != 3 or yuklenen.yonetim.hane.uyeler.size() < 2:
		hatalar.append("Oturum.kayittan KoyYonetimi.hane verisini geri yükleyemedi!")

	# Eski kayıtta 'hane' alanı yokken ACL-01 kuruluşundan türetilmeli
	var eski_kayit := tam_kayit.duplicate(true)
	(eski_kayit["koy_yonetimi"] as Dictionary).erase("hane")
	var eski_yuklenen := Oturum.kayittan(kat, eski_kayit)
	if eski_yuklenen == null or eski_yuklenen.yonetim.hane.ev_id < 0 or eski_yuklenen.yonetim.hane.uyeler.size() < 2:
		hatalar.append("Eski kayıtta 'hane' yokken ACL-01 kuruluşundan türetilmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("PASS: HAN-01..52 Muhafiz Hanesi testi basariyla tamamlandi.")
	quit(0)
