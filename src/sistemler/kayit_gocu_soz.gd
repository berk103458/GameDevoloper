## KAY-03 ve KAY-04: SYS-14'ün tek-adım yürütücüsü ve içerik/kayıt sürümü ayrımı; dosya yazmaz.
extends RefCounted

const OYNANIS_GRUBU := &"kayit_gocu_oynanis_ekrani"

const ICERIK_YOLU := "res://data/ayarlar/icerik.tres"

## Adım listesi yalnız güvenilir kodun Callable'larından gelir; kayıt dosyasından kod yüklenmez.
static func uygula(kayit: Dictionary, hedef_surumu: int, adimlar: Dictionary) -> Dictionary:
	var surum := _surum(kayit.get("surum"))
	if surum < 0 or hedef_surumu < surum: return {}
	if surum < hedef_surumu and oynanis_acik():
		push_error("KAY71_GAMEPLAY_MIGRATION: sürüm göçü yalnız yükleme adımında çalışır")
		return {}
	var veri := kayit.duplicate(true)
	while surum < hedef_surumu:
		var adim: Variant = adimlar.get(surum)
		if not adim is Callable or not adim.is_valid(): return {}
		# Hatalı adım ne başlangıç sözlüğüne ne önceki sağlam adıma yazabilir.
		var sonuc: Variant = adim.call(veri.duplicate(true))
		if not sonuc is Dictionary or _surum(sonuc.get("surum")) != surum + 1: return {}
		veri = sonuc.duplicate(true)
		surum += 1
	return veri


## KAY-04: `data/ayarlar/icerik.tres` yalnız okunur; yazılmaz.
static func icerik_surumu_oku(yol: String = ICERIK_YOLU) -> int:
	if not ResourceLoader.exists(yol):
		return 1
	var res := load(yol)
	if res != null and "icerik_surumu" in res:
		return maxi(1, int(res.get("icerik_surumu")))
	return 1


## KAY-04: İçerik sürümü ile kayıt sürümü ayrıdır; eski kayıttaki eksik sabah/eylem/boş gün alanlarını
## varsayılanlarıyla tamamlar, kişi hafızasını silmez ve aynı kapı eylemini ikinci kez uygulamaz.
static func kay04_hazirla(kayit: Dictionary, guncel_icerik_surumu: int = -1) -> Dictionary:
	var veri := kayit.duplicate(true)
	var hedef_icerik := guncel_icerik_surumu if guncel_icerik_surumu > 0 else icerik_surumu_oku()
	veri["icerik_surumu"] = hedef_icerik
	# Kişi hafızası (`kisi_hafizasi` / `durumlar`) içerik sürümü artsa da silinmez; katalog yeniden kurulmaz.
	if not (veri.get("sabah_defteri_satiri", null) is String):
		veri["sabah_defteri_satiri"] = ""
	if not (veri.get("sabah_gun_sayaci", null) is int or veri.get("sabah_gun_sayaci", null) is float):
		veri["sabah_gun_sayaci"] = 0
	else:
		veri["sabah_gun_sayaci"] = maxi(0, int(veri["sabah_gun_sayaci"]))
	var ham_eylemler: Variant = veri.get("kapi_eylemleri", [])
	var tekil_eylemler: Array[String] = []
	if ham_eylemler is Array:
		for e in ham_eylemler:
			var s := String(e).strip_edges()
			if not s.is_empty() and not tekil_eylemler.has(s):
				tekil_eylemler.append(s)
	veri["kapi_eylemleri"] = tekil_eylemler
	var gun_turu := String(veri.get("gun_turu", "")).strip_edges()
	veri["gun_turu"] = "bos" if gun_turu == "bos" else ""
	return veri


static func _surum(v: Variant) -> int:
	if (v is int or v is float) and is_finite(float(v)) and float(v) >= 0 and float(v) == floor(float(v)) and float(v) <= 1000000000:
		return int(v)
	return -1


## KAY-71: UI sınıflarını içeri almadan mevcut Ana ekranının yaşam döngüsünü oku.
static func oynanis_isaretle(ekran: Node, acik: bool) -> void:
	if ekran == null: return
	if acik: ekran.add_to_group(OYNANIS_GRUBU)
	elif ekran.is_in_group(OYNANIS_GRUBU): ekran.remove_from_group(OYNANIS_GRUBU)

static func oynanis_acik() -> bool:
	var agac := Engine.get_main_loop() as SceneTree
	if agac == null: return false
	for ekran in agac.get_nodes_in_group(OYNANIS_GRUBU):
		if not ekran.is_queued_for_deletion(): return true
	return false


static var gunluk: PackedStringArray = PackedStringArray()


static func gunluk_temizle() -> void:
	gunluk = PackedStringArray()


## KAY-13…18, KAY-25, KAY-61…63: bozuk söz alanını onarır. Temiz kayıtta anahtar eklemez.
## Tipi yanlış alan false döner; çağıran göçü durdurur ve yedeğe bırakır.
static func soz_denetle(veri: Dictionary) -> bool:
	if not veri.has("soz"):
		return true
	var blok: Variant = veri.get("soz")
	if not blok is Dictionary:
		_not("KAY17_SOZ_TIP")
		return false
	var soz: Dictionary = blok
	if not _sayi_alani(soz, "guven", 0, 10):
		return false
	if not _sayi_alani(soz, "korku", 0, 10):
		return false
	if not _sayi_alani(soz, "sure", 0, 1000000):
		return false
	if not _hafiza_denetle(veri, soz):
		return false
	if not _beyan_denetle(soz):
		return false
	if not _soz_listesi_denetle(soz):
		return false
	if not _bayrak_denetle(soz):
		return false
	_kuyruk_denetle(soz)
	return true


## KAY-57: eski okuyucu güven alanını görmez, dosya sözlüğünden silmez.
static func eski_surum_gorunumu(kayit: Dictionary) -> Dictionary:
	var gorunum := kayit.duplicate(true)
	if gorunum.get("soz") is Dictionary:
		var soz: Dictionary = (gorunum["soz"] as Dictionary).duplicate(true)
		soz.erase("guven")
		soz.erase("korku")
		if soz.get("hafiza") is Array:
			var temiz: Array = []
			for satir in soz["hafiza"]:
				if satir is Dictionary:
					var kopya := (satir as Dictionary).duplicate(true)
					kopya.erase("guven")
					kopya.erase("korku")
					temiz.append(kopya)
			soz["hafiza"] = temiz
		gorunum["soz"] = soz
	return gorunum


## KAY-17: göç olmazsa sağlam yedek açılır. Ana dosya bu çağrıda yazılmaz.
static func oturum_veya_yedek(katalog, kayit: GuvenliKayit):
	var oturum_sinifi = load("res://src/sistemler/oturum.gd")
	var ana := kayit.oku()
	var oturum = null
	if not ana.is_empty():
		oturum = oturum_sinifi.kayittan(katalog, ana)
	if oturum != null:
		return oturum
	var yedek := GuvenliKayit._oku_dosya(kayit.yol + ".bak")
	if yedek.is_empty():
		return null
	_not("KAY17_YEDEK")
	return oturum_sinifi.kayittan(katalog, yedek)


static func _not(satir: String) -> void:
	gunluk.append(satir)
	push_warning(satir)


static func _sayi_alani(hedef: Dictionary, anahtar: String, alt: int, ust: int) -> bool:
	if not hedef.has(anahtar):
		return true
	var deger: Variant = hedef[anahtar]
	if not (deger is int or deger is float) or not is_finite(float(deger)):
		_not("KAY17_%s" % anahtar)
		return false
	var n := int(deger)
	if n < alt or n > ust:
		hedef[anahtar] = clampi(n, alt, ust)
		_not("KAY14_%s" % anahtar)
	return true


static func _hafiza_denetle(veri: Dictionary, soz: Dictionary) -> bool:
	if not soz.has("hafiza"):
		return true
	var ham: Variant = soz.get("hafiza")
	if not ham is Array:
		_not("KAY17_HAFIZA")
		return false
	var bilinen := {}
	if veri.get("kadro") is Dictionary:
		for id in (veri["kadro"] as Dictionary).keys():
			bilinen[String(id)] = true
	var birlesik := {}
	var sira: Array[String] = []
	for satir in ham:
		if not satir is Dictionary:
			_not("KAY17_HAFIZA_SATIR")
			return false
		var d: Dictionary = satir
		var id := String(d.get("id", "")).strip_edges()
		if id.is_empty() or not bilinen.has(id):
			_not("KAY15_%s" % id)
			continue
		if not _sayi_alani(d, "guven", 0, 10) or not _sayi_alani(d, "korku", 0, 10):
			return false
		if d.has("Flag_Sir_Tamamen_Cozuldu") and not (d["Flag_Sir_Tamamen_Cozuldu"] is bool):
			d["Flag_Sir_Tamamen_Cozuldu"] = false
			_not("KAY63_BAYRAK")
		if birlesik.has(id):
			var once: Dictionary = birlesik[id]
			if int(d.get("ziyaret", 0)) >= int(once.get("ziyaret", 0)):
				birlesik[id] = d
			_not("KAY61_%s" % id)
		else:
			birlesik[id] = d
			sira.append(id)
	var temiz: Array = []
	for id in sira:
		temiz.append(birlesik[id])
	soz["hafiza"] = temiz
	return true


static func _beyan_denetle(soz: Dictionary) -> bool:
	if not soz.has("beyanlar"):
		return true
	var ham: Variant = soz.get("beyanlar")
	if not ham is Array:
		_not("KAY17_BEYAN")
		return false
	var gruplar := {}
	var sira: Array[String] = []
	for satir in ham:
		if not satir is Dictionary:
			_not("KAY17_BEYAN_SATIR")
			return false
		var kim := String(satir.get("id", "")).strip_edges()
		if kim.is_empty():
			_not("KAY62_BEYAN")
			continue
		var kisi := String(satir.get("kisi", ""))
		if not gruplar.has(kisi):
			gruplar[kisi] = []
			sira.append(kisi)
		(gruplar[kisi] as Array).append(satir)
	var temiz: Array = []
	for kisi in sira:
		var sinirli: Array = KisiHafizasi.beyan_tavanina_sigdir(gruplar[kisi])
		for satir in sinirli:
			temiz.append(satir)
	soz["beyanlar"] = temiz
	return true


static func _soz_listesi_denetle(soz: Dictionary) -> bool:
	if not soz.has("sozler"):
		return true
	var ham: Variant = soz.get("sozler")
	if ham is Dictionary:
		soz["sozler"] = []
		_not("KAY18_SOZ_LISTESI")
		return true
	if not ham is Array:
		_not("KAY17_SOZLER")
		return false
	var acik := 0
	for satir in ham:
		if not satir is Dictionary:
			_not("KAY17_SOZ_SATIR")
			return false
		if not _sayi_alani(satir, "sure", 0, 1000000):
			return false
		if not bool(satir.get("tutuldu", false)):
			acik += 1
	if acik > 5:
		_not("KAY09_YUKLEME_DUSURMEDI")
	return true


static func _bayrak_denetle(soz: Dictionary) -> bool:
	if not soz.has("bayraklar"):
		return true
	var ham: Variant = soz.get("bayraklar")
	if not ham is Dictionary:
		_not("KAY17_BAYRAK")
		return false
	var bayraklar: Dictionary = ham
	if bayraklar.has("Flag_Sir_Tamamen_Cozuldu") and not (bayraklar["Flag_Sir_Tamamen_Cozuldu"] is bool):
		bayraklar["Flag_Sir_Tamamen_Cozuldu"] = false
		_not("KAY63_BAYRAK")
	return true


static func _kuyruk_denetle(soz: Dictionary) -> void:
	if not soz.has("kapi_kuyrugu"):
		return
	var ham: Variant = soz.get("kapi_kuyrugu")
	var yarim := not (ham is Dictionary)
	if ham is Dictionary:
		var kuyruk: Dictionary = ham
		yarim = yarim or bool(kuyruk.get("yarim", false))
		var kimlikler: Variant = kuyruk.get("ids", [])
		if not kimlikler is Array:
			yarim = true
		else:
			for id in kimlikler:
				if String(id).strip_edges().is_empty():
					yarim = true
	if yarim:
		soz["kapi_kuyrugu"] = {"yarim": false, "yeniden": true, "ids": []}
		_not("KAY25_YARIM_KUYRUK")
