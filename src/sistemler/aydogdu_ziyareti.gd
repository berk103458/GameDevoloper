## OMR-21: Aydoğdu'nun ikinci kapı ziyareti mevcut oba kararını taşır.
extends RefCounted

const ID := &"aydogdu"
const META := &"aydogdu_ittifak_gunu"
const ASGARI_ARA := 4
const OLAY = preload("res://data/olaylar/aydogdu_oba.tres")
const DIS_HAT = preload("res://src/sistemler/dis_hat_kapisi.gd")
const KARARLAR := [&"kabul", &"kisla", &"ret"]

static func ekle(o: Oturum, kuyruk: Array[Gelen]) -> void:
	if not _acik(o): return
	var d: Dictionary = o.kadro.durumlar.get(ID, {})
	if d.get("ziyaret", 0) != 1 or d.get("istendi", false): return
	var son_gece := int(d.get("son_gece", -1))
	if son_gece < 0 or o.gun - son_gece < ASGARI_ARA: return
	var durum: StringName = d.get("durum", &"")
	if durum == &"koyde":
		if not o.yonetim.koylular.any(func(k: Koylu) -> bool: return k.adli_id == ID and k.saglik > 0): return
	elif durum != &"kalici_ayrildi":
		return
	var g := o._adli_gelen(ID)
	g.secenekler = PackedStringArray(KARARLAR)
	g.sorular.clear()
	g.soru_ust.clear()
	g.soru_bayraklari.clear()
	g.set_meta(META, o.gun)
	d.istendi = true
	kuyruk.push_front(g)

static func _acik(o: Oturum) -> bool:
	return o.yonetim.son == &"" and not o.gorulen_olaylar.has(OLAY.id) and DIS_HAT.izin(o.yonetim, DIS_HAT.TALEP)

static func ilgilenir(g: Gelen) -> bool:
	return g != null and g.adli and g.id == ID and g.has_meta(META)

static func etiket(karar: StringName) -> String:
	var i := KARARLAR.find(karar)
	return TranslationServer.translate(OLAY.secenek_anahtarlari[i]) if i >= 0 else ""

static func karar(o: Oturum, g: Gelen, secim: StringName) -> Dictionary:
	var sonuc := {"engellendi": true, "kaldi": false, "kirilan": -1, "koylu_id": -1}
	var d: Dictionary = o.kadro.durumlar.get(ID, {})
	var i := KARARLAR.find(secim)
	if not _acik(o) or g.get_meta(META, -1) != o.gun or d.get("ziyaret", 0) != 2 or d.get("son_gece", -1) != o.gun or i < 0:
		return sonuc
	o.gorulen_olaylar[OLAY.id] = true
	sonuc.merge(o.olay_uygula(OLAY, i), true)
	if secim != &"ret": ObaIttifaki.ittifak_kur(o)
	sonuc.engellendi = false
	sonuc.oba_ziyareti = true
	return sonuc
