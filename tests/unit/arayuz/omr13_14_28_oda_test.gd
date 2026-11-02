extends SceneTree

const OdaGidisatPaneliSinifi = preload("res://src/arayuz/oda_gidisat_paneli.gd")
const OdaYozlasmaUyarisiSinifi = preload("res://src/arayuz/oda_yozlasma_uyarisi.gd")
const NihaiSonSinifi = preload("res://src/sistemler/nihai_son.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OMR ODA TEST HATASI: " + mesaj)


func _initialize() -> void:
	var oturum := Oturum.new(Ayarlar.new())
	oturum.yeni_oyun()
	oturum.gun = 10
	oturum.yonetim.gun = 10

	# OMR-13: Perde 1'de gizlidir (0 satir), Perde 2'de 6 satir ve rakam icermez
	_kontrol(OdaGidisatPaneliSinifi.gosterge_satirlari(oturum).is_empty(), "OMR-13: Perde 1'de gosterge satirlari bos olmali")
	oturum.yonetim.agalik = true
	oturum.yonetim.set_meta(&"perde2_baslangic", 8)
	var satirlar := OdaGidisatPaneliSinifi.gosterge_satirlari(oturum)
	_kontrol(satirlar.size() == 6, "OMR-13: Perde 2'de 6 gosterge satiri olmali")
	for s in satirlar:
		_kontrol(s.contains("düşük") or s.contains("orta") or s.contains("yüksek"), "OMR-13: Satirda kademe sozcugu olmali: " + s)

	# OMR-14: Bes son icin bes cumle `nihai_sonlar.json sonlar[n].baslik` ile ayni adi tasir
	var sonlar: Dictionary = NihaiSonSinifi.AYAR.get("sonlar", {})
	_kontrol(sonlar.size() == 5, "OMR-14: nihai_sonlar.json icinde 5 son olmali")
	for son_id in sonlar.keys():
		var baslik := String(sonlar[son_id].get("baslik", ""))
		var cumle := OdaGidisatPaneliSinifi.gidisat_cumlesi_son_icin(String(son_id))
		_kontrol(cumle.contains(baslik) and cumle.begins_with("şu an gidişat: "), "OMR-14: cumle baslik ile ayni adi tasimali: " + cumle)

	# Dalga 1'de cumle bos, dalga 2'de (gece >= 4) dolu
	oturum.yonetim.set_meta(&"perde2_baslangic", 9) # gece = 1 (dalga 1)
	_kontrol(OdaGidisatPaneliSinifi.gidisat_cumlesi(oturum).is_empty(), "OMR-14: Perde 2 dalga 1'de gidisat cumlesi bos olmali")
	oturum.yonetim.set_meta(&"perde2_baslangic", 4) # gece = 6 (dalga 2)
	_kontrol(not OdaGidisatPaneliSinifi.gidisat_cumlesi(oturum).is_empty(), "OMR-14: Perde 2 dalga 2'de gidisat cumlesi gorunmeli")

	# OMR-28: Yozlasma esigine uc kademe kala uyari; esik degismez
	var esik_once := int(NihaiSonSinifi.AYAR.get("esik", {}).get("yozlasma", 60))
	_kontrol(OdaYozlasmaUyarisiSinifi.satir(20).is_empty(), "OMR-28: dusuk yozlasmada uyari bos olmali")
	_kontrol(not OdaYozlasmaUyarisiSinifi.satir(esik_once - 10).is_empty(), "OMR-28: esikten once (3 kademe icinde) uyari gorunmeli")
	_kontrol(int(NihaiSonSinifi.AYAR.get("esik", {}).get("yozlasma", 0)) == esik_once, "OMR-28: yozlasma esigi degismemeli")

	if _hata == 0:
		print("OMR ODA: GEÇTİ (0 hata)")
	else:
		print("OMR ODA: KALDI (%d hata)" % _hata)
	quit(_hata)
