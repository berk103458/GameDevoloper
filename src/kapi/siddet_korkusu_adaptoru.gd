## CAT-04: tek oturum motoru, gerçek ziyaret nesneleri ve mevcut Dedikodu hattı.
extends RefCounted
const META := &"cat04_siddet_korkusu"
const A = preload("res://src/kapi/kapi_kavgasi_adaptoru.gd")
var motor := SiddetKorkusu.new()
var bekleyen: Array[Dictionary] = []

static func al(o: Oturum) -> RefCounted:
	if not o.has_meta(META): o.set_meta(META, new())
	return o.get_meta(META)

static func kimlik(g: Gelen) -> String:
	return String(g.id) if not String(g.id).is_empty() else "figur_%d" % g.get_instance_id()

static func menu(o: Oturum, acik: bool) -> void:
	if o == null: return
	var a = al(o)
	a.motor.menu_durumu_ayarla(acik)
	if not acik:
		a.motor.menu_kapat_ve_donmus_artisi_coz(0)
		var isler: Array = a.bekleyen.duplicate()
		a.bekleyen.clear()
		for islem: Dictionary in isler:
			uygula(o, islem.olay, islem.sonuc, islem.tablo)

static func uygula(o: Oturum, olay: String, sonuc: Dictionary, tablo: Dictionary = {}) -> void:
	var a = al(o)
	var kavga = A.al(o)
	if DiplomatikHeyet.kilitli(o, kavga._kuyruk) or (kavga.gelen != null and DiplomatikHeyet.ilgilenir(kavga.gelen)):
		sonuc["ayrilan_sayisi"] = 0
		return
	if a.motor.menu_acik_mi():
		a.bekleyen.append({"olay": olay, "sonuc": sonuc, "tablo": tablo})
		sonuc["ayrilan_sayisi"] = 0
		return
	var kisiler: Array = []
	for g: Gelen in kavga._kuyruk:
		var sorgu = g.chr_sorgusu()
		# Figür CHR taşımaz: mevcut sorgunun başlangıç değeri kullanılır.
		var bekleme: Dictionary = g.get_meta(KapiFirtinaKuyrugu.BEKLEME, {})
		var mevcut: int = sorgu.tansiyon if sorgu != null else KarakterVerisi.new().baslangic_tansiyonu + int(bekleme.get("toplam", 0))
		var yeni: int = a.motor.tansiyon_uygula(mevcut, olay, tablo)
		if sorgu != null: sorgu.tansiyon = yeni
		else:
			bekleme["toplam"] = yeni - KarakterVerisi.new().baslangic_tansiyonu
			g.set_meta(KapiFirtinaKuyrugu.BEKLEME, bekleme)
		kisiler.append({"id": kimlik(g), "tansiyon": yeni, "sabir": g.get_meta(&"sabir", g.azami_soru if g.azami_soru > 0 else o.ayarlar.azami_soru)})
	var r: Dictionary = a.motor.degerlendir(olay, kisiler,
		{"gun": o.gun, "ziyaret_konusu_id": kimlik(kavga.gelen) if kavga.gelen != null else ""}, o.dedikodu, o._rng, tablo)
	sonuc.merge(r, true)
	for i in range(kavga._kuyruk.size() - 1, -1, -1):
		if kimlik(kavga._kuyruk[i]) in r.ayrilanlar: kavga._kuyruk.remove_at(i)

static func ekran(e: Node, r: Dictionary) -> void:
	if int(r.get("ayrilan_sayisi", 0)) == 0: return
	var adlar: Array[String] = []
	for g: Gelen in e._kuyruk: adlar.append(e._model_adi(g))
	e.sahne.kuyruk_doldur(adlar)
	e._yaz(TranslationServer.translate("anlati.kavga.sira_ayrildi") % int(r.ayrilan_sayisi))
