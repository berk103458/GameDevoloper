## OMR-03: 100 gece örneğinde gerçek kapı kuyruğunun dönem dağılımı.
extends SceneTree

const SUZGEC = preload("res://src/sistemler/omurga_suzgeci.gd")
const TEHDIT = preload("res://src/sistemler/tehdit_takvimi.gd")
const ORNEK := 100
var _hata := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 303)
	o.gun = 14
	var adaylar := TEHDIT.adaylar(o.gun, o.kadro.uygunlar(o.gun))
	var paylar := _rol_paylari(o, adaylar)
	_dene(is_equal_approx(float(paylar.get("asker", 0.0)), 0.1), "Kuruluş asker payı tam 0,10")
	var askerler: Array[StringName] = adaylar.filter(func(id: StringName) -> bool: return SUZGEC.rol(kat.karakter(id)) == "asker")
	var agirlik := SUZGEC.agirliklar(o, askerler)
	_dene(not askerler.is_empty() and agirlik.size() == askerler.size() + 1 and is_equal_approx(agirlik.back(), 0.9), "Eksik rollerin payı askere aktarılmaz")
	o.yonetim.agalik = true
	_dene(SUZGEC.agirliklar(o, adaylar) == GuvenlikKafileDengesi.adli_agirliklar(o, adaylar), "Perde 2 mevcut güvenlik seçimini kullanır")
	var kurulus := _dagilim(kat, 0)
	var oturma := _dagilim(kat, 14)
	print("OMR-03 100 gece: kuruluş %s | oturma %s" % [kurulus, oturma])
	_dene(kurulus.koylu + kurulus.zanaat > oturma.koylu + oturma.zanaat, "Kuruluşta köylü ve zanaatkâr daha sık")
	_dene(oturma.tuccar > kurulus.tuccar and oturma.asker > kurulus.asker, "Oturmada tüccar ve asker daha sık")
	print("OMURGA KADRO: %s" % ("GEÇTİ" if _hata == 0 else "KALDI"))
	quit(0 if _hata == 0 else 1)

func _rol_paylari(o: Oturum, ids: Array[StringName]) -> Dictionary:
	var w := SUZGEC.agirliklar(o, ids)
	var sonuc := {}
	for i in ids.size():
		var rol := SUZGEC.rol(o.katalog.karakter(ids[i]))
		sonuc[rol] = float(sonuc.get(rol, 0.0)) + w[i]
	return sonuc

func _dagilim(kat: Katalog, nufus: int) -> Dictionary:
	var sonuc := {"koylu": 0, "zanaat": 0, "tuccar": 0, "asker": 0, "adsiz": 0}
	for i in ORNEK:
		var o := Oturum.new(kat, 303 + i)
		o.gun = 14 + i
		o.ayarlar = o.ayarlar.duplicate(true)
		o.ayarlar.gece_basina_gelen = 1
		o.ayarlar.adli_olasiligi = 1.0
		for kisi in nufus:
			o.yonetim.kabul({"ad": "Köylü %d" % kisi})
		var adaylar := TEHDIT.adaylar(o.gun, o.kadro.uygunlar(o.gun))
		var secilen := "adsiz"
		for g in o.gece_kuyrugu():
			if not g.adli: continue
			_dene(g.id in adaylar, "Yalnız gerçek takvim ve kadro adayları seçilir")
			secilen = SUZGEC.rol(kat.karakter(g.id))
		sonuc[secilen] += 1
	return sonuc

func _dene(kosul: bool, mesaj: String) -> void:
	if kosul: return
	_hata += 1
	push_error(mesaj)
