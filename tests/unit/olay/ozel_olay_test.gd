## OZL-03, OZL-08…11, OZL-19…22, OZL-24, OZL-25, OZL-27, OZL-29, OZL-34, OZL-35.
extends SceneTree

var hata := 0
var kat: Katalog
var tumu: Dictionary = {}


func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	tumu = kat._olaylar.duplicate()
	_kapanis()
	_defter_ve_bos()
	_dis_ve_haber()
	_kayit_ve_sinir()
	print("ÖZEL OLAY: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(0 if hata == 0 else 1)


func _kapanis() -> void:
	var bos := _oturum()
	bos.katalog._olaylar = {}
	bos.ayarlar.olay_olasiligi = 1.0
	dene(bos.olay_sec() == null, "OZL-35: boş havuzda kart 0")
	var kucuk := _oturum()
	var dugun := _kart("dugun")
	kucuk.katalog._olaylar = {dugun.id: dugun}
	kucuk.ayarlar.olay_olasiligi = 1.0
	dene(kucuk.yonetim.nufus() < 6 and kucuk.olay_sec() == null, "OZL-35: küçük köyde düğün 0")
	var n5 := _oturum()
	_doldur(n5, 5)
	var asik := _kart("asik")
	n5.katalog._olaylar = {asik.id: asik}
	n5.ayarlar.olay_olasiligi = 1.0
	n5.set_meta(&"bos_gun", true)
	dene(n5.olay_sec() == null and OzelOlay.kapi_kuyrugu(n5) == 0, "OZL-35: boş günde nüfus 5 âşık 0")
	var n6 := _oturum()
	_doldur(n6, 6)
	n6.katalog._olaylar = {asik.id: asik}
	n6.ayarlar.olay_olasiligi = 1.0
	n6.set_meta(&"bos_gun", true)
	var secilen := n6.olay_sec()
	dene(secilen != null and String(secilen.id) == "asik", "OZL-35: boş günde nüfus 6 âşık")
	var kadi_o := _oturum()
	_doldur(kadi_o, 10)
	kadi_o.gun = OzelOlay.tehdit_gunu()
	kadi_o.yonetim.gun = kadi_o.gun
	var kadi := _kart("kadi")
	kadi_o.katalog._olaylar = {kadi.id: kadi}
	kadi_o.ayarlar.olay_olasiligi = 1.0
	var kart := kadi_o.olay_sec()
	dene(kart != null and String(kart.id) == "kadi", "OZL-24: kadı seçilir")
	kadi_o.olay_uygula(kart, 0)
	dene(int(DivanOturumu.durum(kadi_o.yonetim).inceleme_gunu) == kadi_o.yonetim.gun, "OZL-35: kadı divan oturumu 1")
	var yuz := _oturum()
	var elci := _kart("tekfur_elcisi")
	yuz.katalog._olaylar = {elci.id: elci}
	yuz.ayarlar.olay_olasiligi = 1.0
	yuz.set_meta(&"kapi_yuzu", "tekfur_elcisi")
	dene(yuz.olay_sec() == null, "OZL-35: yüz ile kart aynı gece 0")
	dene(not FileAccess.file_exists("res://data/olaylar/cenaze.tres"), "OZL-35: ölüm yolu yeni cenaze kartı açmaz")


func _defter_ve_bos() -> void:
	var o := _oturum()
	var asik := _kart("asik")
	o.olay_uygula(asik, 0)
	var satirlar := OzelOlay.defter(o)
	dene(satirlar.size() == 1 and str(satirlar[0].tur) == "olay" and str(satirlar[0].olay) == "asik", "OZL-03: seçim deftere bir satır")
	o.set_meta(&"bos_gun", true)
	dene(o.sira_olayi_sec(4) == null, "OZL-08: boş günde sıra olayı 0")
	dene(OzelOlay.defter(o).any(func(s): return s is Dictionary and str(s.tur) == "bos_gun"), "OZL-11: boş gün satırı 1")
	var once := OzelOlay.defter(o).size()
	OzelOlay.bos_gun_yaz(o)
	dene(OzelOlay.defter(o).size() == once, "OZL-11: aynı gece ikinci satır yok")


func _dis_ve_haber() -> void:
	var o := _oturum()
	o.set_meta(&"haber_satirlari", ["mogol_duman"])
	var haber := _kart("mogol_duman")
	dene(not OzelOlay.aday(o, haber), "OZL-20: haber satırı varken kart 0")
	o.set_meta(&"oyuncu_nobette", true)
	o.katalog._olaylar = {_kart("asik").id: _kart("asik")}
	_doldur(o, 6)
	o.ayarlar.olay_olasiligi = 1.0
	dene(o.olay_sec() == null and str(o.get_meta(&"ertelenen_olay", "")) == "asik", "OZL-22: nöbet gecesi kart ertelenir")
	o.set_meta(&"oyuncu_nobette", false)
	var gelen := o.olay_sec()
	dene(gelen != null and String(gelen.id) == "asik", "OZL-22: ertesi seçim ertelenen kart")
	dene(OzelOlay.fazlar().size() == 2 and not FileAccess.get_file_as_string("res://src/sistemler/oturum_fazi.gd").contains("gece_devriye"), "OZL-21: üçüncü faz yok")


func _kayit_ve_sinir() -> void:
	kat._olaylar = tumu
	var bilinen := OzelOlay.bilinen_idler(kat)
	var süzülmüş := OzelOlay.kayit_kartlari(bilinen, ["dervis", "olmayan_kart", "asik"])
	dene(süzülmüş.has("dervis") and süzülmüş.has("asik") and not süzülmüş.has("olmayan_kart"), "OZL-34: eski kayıt bilinmeyen kartı seçmez")
	var yeni := 0
	for id in bilinen:
		if id in OzelOlay.YENI_KARTLAR:
			yeni += 1
	dene(yeni == 2, "OZL-25: yeni kart tavanı 2")
	var ayar := FileAccess.get_file_as_string("res://src/veri/oyun_ayarlari.gd")
	dene(not ayar.contains("olay_olasiligi: float = 0.75") and not ayar.contains("sira_olay_olasiligi: float = 0.35"), "OZL-29: olasılık sabiti kodda yok")
	var sayi := OzelOlay.olasiliklar()
	dene(is_equal_approx(float(sayi.olay), 0.75) and is_equal_approx(float(sayi.sira), 0.35), "OZL-29: sayılar denge dosyasında")
	var csv := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	var ihlal := false
	for satir in csv.split("\n"):
		if (satir.begins_with("olay.asik.") or satir.begins_with("olay.kadi.")) and (satir.contains("köyünüzün geleceği") or satir.contains("çünkü") or satir.contains("aslında")):
			ihlal = true
	dene(not ihlal, "OZL-27: yer tutucu metin yapaylık kalıbı taşımaz")
	var etkiler: Array = _kart("asik").secenek_etkileri
	dene(etkiler.size() == 2 and etkiler[0] is Dictionary and etkiler[1] is Dictionary, "OZL-10: âşık iki etki sözlüğü")
	var kadi := _kart("kadi")
	dene(kadi.tek_sefer and kadi.secenek_etkileri.size() == 2, "OZL-24: kadı tek sefer ve iki seçenek")


func _oturum() -> Oturum:
	return Oturum.new(kat, 3801)


func _doldur(o: Oturum, hedef: int) -> void:
	while o.yonetim.nufus() < hedef:
		o.yonetim.kabul({"ad": "Köylü", "sinif": "ciftci"})


func _kart(id: String) -> OlayVerisi:
	for anahtar in tumu:
		var olay: OlayVerisi = tumu[anahtar]
		if String(olay.id) == id:
			return olay
	return null


func dene(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error("FAIL " + metin)
