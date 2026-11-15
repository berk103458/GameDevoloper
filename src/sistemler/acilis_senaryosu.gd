## ACL-01: yalnız açıkça başlatılan yeni oyunun köy kuruluşu.
extends RefCounted

const META := &"acl01_acilis_hanesi"
const MUHAFIZ := "acl01_muhafiz"
const ES := "acl01_es"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/acilis.json"))

static func kur(o: Oturum, zorluk: Variant = "olagan") -> void:
	var y := o.yonetim
	# Devam/legacy üzerinde kurucu çalışmaz; yıkılmış ev de yeniden kurulmaz.
	if not durum(o).is_empty() or y.gun != 0 or not y.binalar.is_empty() or not y.koylular.is_empty(): return
	var ev := KoyBinasi.new()
	ev.tur = String(AYAR.ev_turu)
	var bulundu := false
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			ev.hucre = Vector2i(cx, cy)
			if y.izgara.yerlesebilir(ev.hucreler(y.katalog)).olur:
				bulundu = true
				break
		if bulundu: break
	if not bulundu:
		push_error("Açılış evi için uygun yer bulunamadı")
		return
	y.set_meta(&"zorluk", preload("res://src/sistemler/zorluk_secimi.gd").oku(zorluk))
	ev.id = y._sonraki_id
	y._sonraki_id += 1
	# Hazır kuruluş malı: bedeli/harcanan boş, yıkım para/malzeme yaratmaz.
	y.binalar.append(ev)
	y.izgara.yerlestir(ev.id, ev.hucreler(y.katalog))
	var h := {"kuruldu": true, "ev_id": ev.id}
	var kapidan_kabul := y.kabul_sayisi
	for rol in ["muhafiz", "es"]:
		var veri: Dictionary = AYAR[rol].duplicate(true)
		# Mevcut nüfus/kart arayüzleri kişi adını doğrudan gösterir.
		veri["ad"] = TranslationServer.translate(String(veri.ad))
		veri["bayraklar"] = [MUHAFIZ if rol == "muhafiz" else ES]
		var k := y.kabul(veri)
		k.ev = ev.id
		k.hane_id = int(h.get("muhafiz_id", k.id))
		h[rol + "_id"] = k.id
	# Kuruluş sakinleri kapıda verilmiş iki kabul kararı sayılmaz.
	y.kabul_sayisi = kapidan_kabul
	o.set_meta(META, h)
	Hane.acilis_hanesinden_turet(y, y.hane, h)
	HaneEsi.yukle(y, {}, o)
	preload("res://src/koy/yapi_bilgisi.gd").gecmis(o)
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(o, "koy")
	o._koy_esitle()

static func durum(o: Oturum) -> Dictionary:
	return o.get_meta(META, {}).duplicate(true)

static func yukle(o: Oturum, v: Variant) -> void:
	var h: Dictionary = {}
	if v is Dictionary and v.get("kuruldu") is bool and v.kuruldu:
		h = {"kuruldu": true}
		for alan in ["ev_id", "muhafiz_id", "es_id"]:
			var id := _kimlik(v.get(alan))
			if id >= 0: h[alan] = id
	# Eksik kimlikler yalnız mevcut kuruluş bayraklarından türetilir.
	for k in o.yonetim.koylular:
		for rol in ["muhafiz", "es"]:
			if k.bayrak_var(MUHAFIZ if rol == "muhafiz" else ES):
				h["kuruldu"] = true
				h[rol + "_id"] = k.id
				if not h.has("ev_id"): h["ev_id"] = k.ev
	if not h.is_empty():
		o.set_meta(META, h)
		if o.yonetim.hane.ev_id < 0 or o.yonetim.hane.uyeler.is_empty():
			Hane.acilis_hanesinden_turet(o.yonetim, o.yonetim.hane, h)

static func _kimlik(v: Variant) -> int:
	if (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= 0 and float(v) <= 1000000000:
		return int(v)
	return -1

static func kapi_kapali(o: Oturum) -> bool:
	return durum(o).get("kuruldu", false) and o.gun == 0 and not (o.bayraklar.has(&"acl04_ulak_gecti") and not o.bayraklar.has(&"acl04_aile_karari"))
