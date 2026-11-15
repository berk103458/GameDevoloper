## DYL-03: kapı ziyareti, mevcut söz kaydı ve DYL-08 kuyruğu arasında ince bağ.
extends RefCounted
const AYAR = preload("res://src/soz/yemin.gd")
const META := &"dyl03_yemin"
static var TABLO: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/yemin_sekilleri.json"))

static func veri_isle(g: Gelen) -> void:
	# Açık karakter verisi korunur; yalnız tanımlı oyun figürleri tablodan doldurulur.
	var profil: Dictionary = TABLO.karakterler.get(String(g.id), {}) if g.adli else TABLO.figurler.get(String(g.sinif), {})
	if g.inanc.is_empty() and g.yemin.is_empty() and not profil.is_empty():
		g.inanc = String(profil.inanc)
		g.yemin = profil.yemin.duplicate(true)
		g.yemin_grubu = String(profil.grup)
		g.saygin = bool(profil.get("saygin", false))

static func ziyaret(o: Oturum, g: Gelen) -> void:
	if g.has_meta(META): return
	var id := "%s:%d:%d" % [String(g.id), o.gun, o.soz_kaydi.yeminler.size()]
	g.set_meta(META, {"motor": AYAR.new(), "id": id})

static func veri(g: Gelen) -> Dictionary:
	return {"inanc": g.inanc, "yemin": g.yemin, "saygin": g.saygin}

static func uygun(g: Gelen) -> bool:
	if not g.has_meta(META): return false
	var m: Yemin = g.get_meta(META).motor
	return m.yemin_uygun_mu(veri(g)) and not TABLO.inanclar.get(g.inanc, []).is_empty()

static func uygula(o: Oturum, g: Gelen, sekil: String = "") -> Dictionary:
	ziyaret(o, g)
	if not uygun(g): return {"basarili": false, "zar_atisi": false}
	var izinli: Array = TABLO.inanclar[g.inanc]
	if sekil.is_empty(): sekil = String(izinli[0])
	var m: Yemin = g.get_meta(META).motor
	var r := m.yemin_et(veri(g), {}, o.soz_kaydi.motor)
	var yanlis := sekil not in izinli
	if yanlis:
		o.soz_kaydi.motor.guven = maxi(0, o.soz_kaydi.motor.guven - 3)
		o.grup_itibari.uygula(g.yemin_grubu if not g.yemin_grubu.is_empty() else g.id, -1)
		r["ipucu"] = ""
		r["yalan_yemin"] = false
		r["metin"] = TranslationServer.translate("anlati.yemin.hakaret")
	else:
		var s: Array = g.yemin.get("satirlar", [])
		var sorgu = g.chr_sorgusu()
		var acik: bool = sorgu != null and bool(sorgu.bayraklar.get("Flag_Sir_Tamamen_Cozuldu", false))
		r["metin"] = TranslationServer.translate(String(s[1] if acik and s.size() > 1 else s[0])) if not s.is_empty() else ""
	if r.ipucu == "yemin_kacamak":
		if "yemin_kacamak" not in g.acik_bayraklar: g.acik_bayraklar.append("yemin_kacamak")
		var sorgu = g.chr_sorgusu()
		if sorgu != null and sorgu._ipucu_servisi.kaydet(&"Clue_Yemin_Kacamak"): sorgu.ipucu_bulundu.emit(&"Clue_Yemin_Kacamak")
	if r.yalan_yemin and "yalan_yemin" not in g.gizli_bayraklar: g.gizli_bayraklar.append("yalan_yemin")
	var chr = g.chr_sorgusu()
	if chr != null:
		chr.tansiyon = clampi(chr.tansiyon + 1, 0, 10)
		chr.tansiyon_degisti.emit(chr.tansiyon)
	else:
		var bekleme: Dictionary = g.get_meta(KapiFirtinaKuyrugu.BEKLEME, {})
		bekleme["toplam"] = int(bekleme.get("toplam", 0)) + 1
		g.set_meta(KapiFirtinaKuyrugu.BEKLEME, bekleme)
	if g.adli and o.kadro.durumlar.has(g.id): KisiHafizasi.guven_yaz(o.kadro, g.id, o.soz_kaydi.motor.guven)
	var kayit := r.duplicate(true)
	kayit.merge({"grup": g.yemin_grubu, "chr_id": String(g.id), "sekil": sekil, "kabul": false, "ceza": false})
	o.soz_kaydi.yeminler[String(g.get_meta(META).id)] = kayit
	return r

static func eylem(e: Node, g: Gelen, kap: Container) -> void:
	if g == null: return
	var o: Oturum = e.get("oturum")
	ziyaret(o, g)
	_satiri_yenile(e, o, g)
	if not uygun(g): return
	var secim := OptionButton.new()
	secim.name = "YeminSekli"
	var sekiller: Array = TABLO.sekiller.keys()
	for sekil_id: String in sekiller:
		secim.add_item(TranslationServer.translate(String(TABLO.sekiller[sekil_id].anahtar)))
	secim.select(sekiller.find(TABLO.inanclar[g.inanc][0]))
	var b := Button.new()
	b.name = "YeminEt"
	b.text = TranslationServer.translate("arayuz.kapi.yemin_et")
	b.custom_minimum_size.y = 58
	kap.add_child(b)
	b.pressed.connect(func() -> void:
		if e.get("_gelen") != g: return
		var r := uygula(o, g, String(sekiller[secim.selected]))
		if not r.get("basarili", false): return
		e.call("_yaz", String(r.metin))
		e.call("_sohbet_goster")
	)
	# Tek değişim noktası: gerçek nesne gelene kadar düz renk kutu + şekil etiketi.
	var kutu := PanelContainer.new()
	kutu.name = "YeminNesnesi"
	var stil := StyleBoxFlat.new()
	stil.bg_color = Color("61513d")
	kutu.add_theme_stylebox_override("panel", stil)
	var etiket := Label.new()
	var sekil: String = TABLO.inanclar[g.inanc][0]
	etiket.text = TranslationServer.translate(String(TABLO.sekiller[sekil].anahtar))
	var dikey := VBoxContainer.new()
	kutu.add_child(dikey)
	dikey.add_child(etiket)
	dikey.add_child(secim)
	secim.item_selected.connect(func(i: int) -> void: etiket.text = secim.get_item_text(i))
	kap.add_child(kutu)


## Sır açılınca aynı ziyaretin eski satırını yerinde değiştir; ikinci satır ekleme.
static func _satiri_yenile(e: Node, o: Oturum, g: Gelen) -> void:
	var id := String(g.get_meta(META).id)
	var r: Dictionary = o.soz_kaydi.yeminler.get(id, {})
	var sorgu = g.chr_sorgusu()
	if r.is_empty() or sorgu == null or not sorgu.bayraklar.get("Flag_Sir_Tamamen_Cozuldu", false): return
	if not r.get("yalan_yemin", false): return
	var satirlar: Array = g.yemin.get("satirlar", [])
	if satirlar.size() < 2: return
	var yeni := TranslationServer.translate(String(satirlar[1]))
	var eski := String(r.metin)
	if eski == yeni or eski.is_empty(): return
	var kayit: RichTextLabel = e.get("_kayit")
	if kayit != null: kayit.text = kayit.get_parsed_text().replace(eski, yeni)
	r.metin = yeni

static func karar(o: Oturum, g: Gelen, kaldi: bool) -> void:
	if not g.has_meta(META): return
	var id := String(g.get_meta(META).id)
	if not o.soz_kaydi.yeminler.has(id): return
	var r: Dictionary = o.soz_kaydi.yeminler[id]
	if r.kabul: return
	r.kabul = kaldi
	if not kaldi or not r.yalan_yemin: return
	# DYL-08: yalanın haberi üç gün sonra mevcut tek dönüş kuyruğundan gelir.
	o.gecikmeli_kuyruk.append({"yemin_id": id, "chr_id": String(g.id), "karar": "kabul", "hedef_gun": o.gun + 3, "hedef_sistem": "dedikodu", "alan": "yemin", "deger": 0, "tur_offset": 3, "olay_id": "yemin_" + id, "tanikli": true, "metin": TranslationServer.translate("anlati.yemin.bozuldu")})

static func bozuldu(o: Oturum, id: String) -> bool:
	var r: Dictionary = o.soz_kaydi.yeminler.get(id, {})
	if r.is_empty() or not r.get("kabul", false) or not r.get("yalan_yemin", false) or r.get("ceza", false): return false
	var m := AYAR.new()
	var terazi := {}
	if not m.bozulma_cezasi_uygula(terazi): return false
	r["ceza"] = true
	r["terazi"] = "anlati.yemin.bozuldu"
	o.grup_itibari.uygula(String(r.grup) if not String(r.grup).is_empty() else String(r.chr_id), int(TABLO.agir_itibar))
	o.yonetim.adalet = maxi(0, o.yonetim.adalet + int(TABLO.terazi_adalet))
	return true

static func terazi_kayitlari(o: Oturum) -> Array[String]:
	var satirlar: Array[String] = []
	for r: Dictionary in o.soz_kaydi.yeminler.values():
		if r.get("ceza", false): satirlar.append(TranslationServer.translate(String(r.terazi)))
	return satirlar
