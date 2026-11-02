## ISG-02: kişi üstünde tek atama; havuz sırası yalnız dış veriden kurulur.
class_name GeciciIsler
extends RefCounted
const IS_YERI := -4
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/gecici_isler.json"))

static func tanim(id: String) -> Dictionary:
	for is_ in AYAR.isler:
		if is_.id == id: return is_
	return {}

static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or not v.get("id") is String or tanim(v.id).is_empty(): return {}
	for alan in ["atama_gecesi", "son_gece", "son_miktar"]:
		var n: Variant = v.get(alan, -1 if alan == "son_gece" else 0)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < (-1 if alan == "son_gece" else 0): return {}
	return {"id":String(v.id), "atama_gecesi":int(v.get("atama_gecesi",0)), "son_gece":int(v.get("son_gece",-1)), "son_miktar":int(v.get("son_miktar",0))}

static func secili(k: Koylu) -> String:
	return String(k.gecici_is.get("id", "")) if k != null else ""

static func ad(id: String) -> String:
	return TranslationServer.translate(String(tanim(id).get("ad_anahtari", "koy.gecici_is.bos")))

static func _bina_var(y: KoyYonetimi, turler: Array) -> bool:
	for b in y.binalar:
		if b.hazir() and b.tur in turler: return true
	return false

static func _temel(y: KoyYonetimi, k: Koylu) -> String:
	if k == null or y.son != "": return "koy.gecici_is.uygun_degil"
	if k.yas_grubu == &"cocuk" or YasamBarlari.oyuncu_mu(k) or k.bayrak_var("acl01_es"): return "koy.gecici_is.uygun_degil"
	if not CirakEgitimi.saglam(k) or not k.is_kazasi.is_empty() or SaglikYoneticisi.hasta(k) or KervanKorumasi.disarida(y,k.id) or ZanaatKazalari.durur(k): return "koy.gecici_is.uygun_degil"
	if KapiNobeti.yuva(y) == k.id or int(KapiNobeti.durum(y).eslik) == k.id or IsKazalari.nobet(k,y): return "koy.gecici_is.nobetci"
	return ""

static func neden(y: KoyYonetimi, k: Koylu, id: String, calisma: bool = false) -> String:
	var temel := _temel(y,k)
	if not temel.is_empty(): return temel
	var d := tanim(id)
	if d.is_empty() or String(k.yas_grubu) not in d.yas: return "koy.gecici_is.uygun_degil"
	if not calisma and not secili(k).is_empty(): return "koy.gecici_is.tek_is"
	if k.is_yeri != KoyYonetimi.BOSTA and not (calisma and ((k.is_yeri == IS_YERI) or (id == "tas_toplama" and k.is_yeri == TasYatagi.IS_YERI))): return "koy.gecici_is.bina_isi"
	if d.etki == "tas" and (y.tas_yatagi == null or y.tas_yatagi.kalan <= 0): return "koy.gecici_is.tas_yok"
	if d.has("binalar") and not _bina_var(y,d.binalar): return "koy.gecici_is.yer_yok"
	if d.get("ev",false):
		var ev := y.bina(k.ev)
		if ev == null or not ev.hazir(): return "koy.gecici_is.yer_yok"
	if d.has("uygun_kisiler") and k.yas_grubu != &"yasli" and String(k.adli_id) not in d.uygun_kisiler: return "koy.gecici_is.uygun_degil"
	if d.get("suruden",false) and not SamanBakimi.hayvanlar(y).any(func(h: Dictionary) -> bool: return h.tur == "koyun"): return "koy.gecici_is.yer_yok"
	if d.etki == "insaat" and not y.binalar.any(func(b: KoyBinasi) -> bool: return not b.hazir()): return "koy.gecici_is.insaat_yok"
	if d.etki == "guvenlik" and (not KapiNobeti.aday(y,KapiNobeti.yuva(y)) or bool(KapiNobeti.durum(y).uyku)): return "koy.gecici_is.nobet_yok"
	if d.etki == "bakim" and _bakim_adaylari(y,k).is_empty(): return "koy.gecici_is.bakim_yok"
	return ""

static func ata(y: KoyYonetimi, kisi: int, id: String) -> bool:
	var k := y.koylu(kisi)
	if not neden(y,k,id).is_empty(): return false
	if id == "tas_toplama" and not TasYatagi.ata(y,kisi): return false
	if id != "tas_toplama": k.is_yeri = IS_YERI
	k.gecici_is = {"id":id,"atama_gecesi":y.gun,"son_gece":-1,"son_miktar":0}
	return true

static func birak(y: KoyYonetimi, k: Koylu) -> void:
	if k == null: return
	if not secili(k).is_empty() and k.is_yeri in [IS_YERI,TasYatagi.IS_YERI]: k.is_yeri = KoyYonetimi.BOSTA
	k.gecici_is.clear()

static func _miktar(d: Dictionary) -> int:
	return maxi(0, int(floor(float(d.miktar) * float(AYAR.verim_yuzde) / 100.0)))

static func tas_verimi(k: Koylu, y: KoyYonetimi, varsayilan: int) -> int:
	if secili(k) != "tas_toplama": return varsayilan
	return _miktar(tanim("tas_toplama")) if neden(y,k,"tas_toplama",true).is_empty() else 0

static func tas_makbuzu(y: KoyYonetimi, k: Koylu, giren: int) -> void:
	if secili(k) != "tas_toplama": return
	k.gecici_is.son_gece = y.gun
	k.gecici_is.son_miktar = giren

static func _bakim_adaylari(y: KoyYonetimi, bakici: Koylu) -> Array[Koylu]:
	var adaylar: Array[Koylu] = []
	for k in y.koylular:
		if k.id != bakici.id and k.saglik > 0 and (k.yas_grubu == &"cocuk" or SaglikYoneticisi.hasta(k)): adaylar.append(k)
	return adaylar

## Kaynaklar, mevcut sağlık/moral ve tek inşaat hesabına ince katkı; ikinci tüketim yok.
static func gece(y: KoyYonetimi, rapor: Dictionary, calismalar: Dictionary) -> void:
	if rapor.has("gecici_isler"): return
	var satirlar := {}
	if y.isyan_kalan >= 0:
		rapor["gecici_isler"] = []
		return
	for k in y.koylular:
		var id := secili(k)
		if id.is_empty(): continue
		var d := tanim(id)
		var tas_tamam := id == "tas_toplama" and int(k.gecici_is.son_gece) == y.gun
		if not tas_tamam and not neden(y,k,id,true).is_empty():
			if id == "tas_toplama" and (y.tas_yatagi == null or y.tas_yatagi.kalan <= 0): birak(y,k)
			continue
		if not tas_tamam and int(k.gecici_is.son_gece) == y.gun: continue
		var miktar := int(k.gecici_is.son_miktar) if tas_tamam else _miktar(d)
		if not tas_tamam:
			if d.has("mevsimler") and not d.mevsimler.any(func(m: Variant) -> bool: return int(m) == y.mevsim()): miktar = 0
			match String(d.etki):
				"stok":
					miktar = y.kaynaklar.ekle(d.kaynak,miktar)
					if miktar > 0: rapor.uretim[d.kaynak] = int(rapor.uretim.get(d.kaynak,0)) + miktar
				"guvenlik": y.asayis_riski = maxi(0,y.asayis_riski-miktar)
				"bakim":
					for hasta in _bakim_adaylari(y,k): hasta.moral = mini(100,hasta.moral+miktar)
			k.gecici_is.son_gece = y.gun
			k.gecici_is.son_miktar = miktar
		if int(d.yorgunluk) > 0 and miktar > 0: k.yorgunluk = {"son_gece":y.gun}
		if miktar > 0: calismalar[k.id] = k.is_yeri
		if not satirlar.has(id): satirlar[id] = {"is_id":id,"kisi":0,"miktar":0}
		satirlar[id].kisi += 1
		satirlar[id].miktar += miktar
		if tas_tamam and k.is_yeri == KoyYonetimi.BOSTA: k.gecici_is.clear()
	rapor["gecici_isler"] = satirlar.values()
	for id in satirlar:
		rapor.olaylar.append({"anahtar":"koy.gecici_is.rapor","deger":[ad(id),satirlar[id].miktar],"gecici_is":id})

static func insaat_yardimi(y: KoyYonetimi) -> int:
	var yardim := 0
	for k in y.koylular:
		if tanim(secili(k)).get("etki") == "insaat" and int(k.gecici_is.get("son_gece",-1)) == y.gun: yardim += int(k.gecici_is.son_miktar)
	return yardim
