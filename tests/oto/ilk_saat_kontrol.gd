## OGR-57: Kapanış testi — altı gece tek koşuda dört ilk saat iddiası.
## 1) İpucu sırası OGR-01 listesine eşit, 2) Panel açılış geceleri OGR-25'e eşit,
## 3) Altı gecede son 0, 4) İkinci açılışta ipucu 0.
extends Node

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const HUD_KATMANI = preload("res://src/arayuz/koy_hud/hud_katmani.gd")
const NIHAI_SON = preload("res://src/sistemler/nihai_son.gd")
const TOHUM := 1401
const GECE_SAYISI := 6

var _hata := 0
var _katalog: Katalog
var _ayarlar := Ayarlar.new("user://unused_ogr57.cfg")
var _yuzey: Control


func _kontrol(kosul: bool, mesaj: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error("OGR-57 HATA: " + mesaj)


func _ready() -> void:
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	call_deferred("_dene")


func _dene() -> void:
	TranslationServer.set_locale("tr")
	_ayarlar.degerler[&"ipuclari"] = true
	_katalog = Katalog.new()
	_katalog.yukle()
	_yuzey = Control.new()
	_yuzey.theme = Tema.olustur(_ayarlar)
	add_child(_yuzey)

	var o := Oturum.new(_katalog, TOHUM)
	ACILIS.kur(o)
	var e := _koy_ekrani(o)
	IlkSaat.koy_hizi_ipucunu_goster(e, o, _ayarlar)
	_kontrol(o.ipucu_kaydi.goruldu_mu("koy_hizi"), "Gece 0 ilk acilista koy_hizi ipucu gorulmeli")

	# OGR-01 listesi (ilk_saat.json kavram sirasi)
	var ogr01_json: Variant = JSON.parse_string(FileAccess.get_file_as_string(IlkSaat.VERI_YOLU))
	var ogr01_listesi: Array[String] = []
	var ogr01_gece_min := {}
	var ogr01_tetik := {}
	if ogr01_json is Dictionary and ogr01_json.get("kavramlar", null) is Array:
		for k in ogr01_json["kavramlar"]:
			var id := String(k.get("id", ""))
			ogr01_listesi.append(id)
			ogr01_gece_min[id] = int(k.get("gece_min", 0))
			ogr01_tetik[id] = String(k.get("tetik", ""))

	var ilk := IlkSaat.new()
	var gorulen_sira: Array[String] = []
	var erken_tetik_hatasi := 0
	var erken_son_hatasi := 0
	var panel_acilis_hatasi := 0

	for gun in range(GECE_SAYISI):
		_kontrol(o.gun == gun, "Beklenen gece=%d, mevcut=%d" % [gun, o.gun])

		# İddia 2: OGR-25 HUD katmanlari panel acilis geceleri kontrolu.
		e.hud.guncelle()
		await get_tree().process_frame
		var gorunen_paneller := {}
		for n in e.find_children("*", "Control", true, false):
			if n.has_meta(&"hud_katmani") and n.is_visible_in_tree():
				gorunen_paneller[String(n.get_meta(&"hud_katmani"))] = true
		for dosya in HUD_KATMANI.AYAR:
			var parcalar: Dictionary = HUD_KATMANI.AYAR[dosya]
			for parca in parcalar:
				var kimlik := "%s:%s" % [dosya, parca]
				if not gorunen_paneller.has(kimlik):
					# Muhafiz/harita ozel tetikliyse atla; gece_min tabanlı her parca kontrol edilir.
					if dosya == "muhafiz_odasi_baglantisi.gd" or dosya == "harita_baglantisi.gd":
						continue
					# Sadece bu sahnede yerlesen katmanlarin gorunur olup olmadigini dogrula (eksik min gecede gorunmemeli).
					if gun >= int(parcalar[parca]):
						# Bosta/hud/kaynak/kese gibi yerlesik paneller acik olmali; kapali panel var mi diye kontrol:
						if e.hud._katman.acik(dosya, parca) == false:
							panel_acilis_hatasi += 1
				if gun < int(parcalar[parca]) and gorunen_paneller.has(kimlik):
					panel_acilis_hatasi += 1
		if gun == 0:
			_kontrol(not gorunen_paneller.has("kaynak_gostergesi.gd:kereste")
				and not gorunen_paneller.has("kese_gostergesi.gd:ana")
				and not gorunen_paneller.has("harita_baglantisi.gd:ana")
				and not gorunen_paneller.has("muhafiz_odasi_baglantisi.gd:ana"),
				"Gece 0 panelleri OGR-25 kisitina uymali")
		elif gun == 1:
			_kontrol(gorunen_paneller.has("kaynak_gostergesi.gd:kereste") and not gorunen_paneller.has("kese_gostergesi.gd:ana"),
				"Gece 1 kereste acik, kese kapali olmali")
		elif gun == 2:
			_kontrol(gorunen_paneller.has("kese_gostergesi.gd:ana") and not gorunen_paneller.has("kaynak_gostergesi.gd:afyon"),
				"Gece 2 kese acik, afyon kapali olmali")
		elif gun == 3:
			_kontrol(gorunen_paneller.has("kaynak_gostergesi.gd:afyon"), "Gece 3 afyon acik olmali")

		# İddia 1: İpucu sırası (OGR-01). Henüz gece_min gelmeyen kavram erken çıkmaz; bu gece açılanlar sırayla tetiklenir.
		for id in ogr01_listesi:
			var g_min := int(ogr01_gece_min[id])
			if gun < g_min:
				if bool(ilk.tetikle(String(ogr01_tetik[id]), gun).get("gosterildi", false)):
					erken_tetik_hatasi += 1
			elif gun == g_min:
				var sonuc: Dictionary = ilk.tetikle(String(ogr01_tetik[id]), gun)
				if bool(sonuc.get("gosterildi", false)):
					var g_id := String(sonuc.get("id", ""))
					gorulen_sira.append(g_id)
					o.ipucu_kaydi.ipucu_ekle(g_id)

		# Geceyi oyna (ilk gece zorunlu kapı kabulü dahil).
		if gun == 0:
			KAPI.baslat(o)
			KAPI.ulak_bitir(o)
			var kuyruk := KAPI.kuyruk(o)
			_kontrol(not kuyruk.is_empty(), "Gece 0 kapi kuyrugu bos olmamali")
			if not kuyruk.is_empty():
				o.karar_ver(kuyruk[0], &"kabul")
		if not NIHAI_SON.son(o, &"zafer").is_empty():
			erken_son_hatasi += 1
		var gece := o.gece_sonu()
		_kontrol(not gece.get("engellendi", false), "Gece %d engellenmemeli" % gun)
		if String(gece.get("son", "")) != "" or o.yonetim.son != "":
			erken_son_hatasi += 1

	# İddia 1, 2, 3 sonuç kontrolleri
	_kontrol(gorulen_sira == ogr01_listesi and erken_tetik_hatasi == 0,
		"Iddia 1: Ipucu sirasi OGR-01 listesine esit olmali (gorulen=%s, beklenen=%s, erken=%d)" % [gorulen_sira, ogr01_listesi, erken_tetik_hatasi])
	_kontrol(panel_acilis_hatasi == 0, "Iddia 2: OGR-25 panel acilis gecelerinde sapma olmamali (hata=%d)" % panel_acilis_hatasi)
	_kontrol(erken_son_hatasi == 0 and o.yonetim.son == "" and o.gun == GECE_SAYISI and o.ambar >= 0,
		"Iddia 3: Alti gece tek kosuda son=0 ve ambar>=0 olmali (gun=%d, son=%s, ambar=%d)" % [o.gun, o.yonetim.son, o.ambar])

	# İddia 4: İkinci açılışta ipucu 0.
	var kayit_json: Variant = JSON.parse_string(JSON.stringify(o.kaydet()))
	_kontrol(kayit_json is Dictionary, "Oturum kaydi gecerli JSON sozlugu olmali")
	e.free()
	await get_tree().process_frame

	var o2 := Oturum.kayittan(_katalog, kayit_json as Dictionary)
	_kontrol(o2 != null, "Ikinci acilista oturum kayittan yuklenmeli")
	var ikinci_ipucu := 0
	if o2 != null:
		var e2 := _koy_ekrani(o2)
		IlkSaat.koy_hizi_ipucunu_goster(e2, o2, _ayarlar)
		if e2.get_node_or_null("IpucuSeridi") != null:
			ikinci_ipucu += 1
		var ilk2 := IlkSaat.new()
		ilk2.yukle({"gorulen": o2.ipucu_kaydi.gorulen_listesi()})
		for id in ogr01_listesi:
			if bool(ilk2.tetikle(String(ogr01_tetik[id]), GECE_SAYISI).get("gosterildi", false)):
				ikinci_ipucu += 1
		e2.free()
		await get_tree().process_frame
	_kontrol(ikinci_ipucu == 0, "Iddia 4: Ikinci acilista ipucu 0 olmali (gelen=%d)" % ikinci_ipucu)

	_yuzey.free()
	await get_tree().process_frame
	print("ILK SAAT KAPANIS (OGR-57): %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	get_tree().quit(0 if _hata == 0 else 1)


func _koy_ekrani(o: Oturum) -> KoyEkrani:
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = _ayarlar
	_yuzey.add_child(e)
	return e
