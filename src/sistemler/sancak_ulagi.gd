## OMR-22: açılış ulağı mevcut fermanı ve teftiş sonucunu kapıda iletir.
extends RefCounted

const ACILIS = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const ID := &"sancak_ulagi"
const META := &"sancak_ulagi_gunu"
const DINLE := "ulak_dinle"
const FERMAN := ["ulak_levent", "ulak_asi", "ulak_ret"]


static func kapida(o: Oturum) -> bool:
	return o.bayraklar.has(ACILIS.ULAK) and o.yonetim.son == ""


static func ekle(o: Oturum, kuyruk: Array[Gelen]) -> void:
	if not kapida(o): return
	SancakAskerTalebi.ferman_ac(o, o.gosterilen_gece())
	var ferman := SancakAskerTalebi.olay(o)
	var teftis := _teftis(o)
	if ferman == null and teftis.is_empty(): return
	var g := Gelen.new()
	g.id = ID
	g.ad_anahtari = String(ACILIS.AYAR.ulak)
	g.sinif = &"asker"
	g.giris_anahtari = "koy.sancak.ulak_giris"
	var sozler := PackedStringArray()
	if not teftis.is_empty(): sozler.append(SancakTeftisi.olay_metin(teftis))
	if ferman != null: sozler.append(ferman.metin_anahtari)
	g.acilis = "\n".join(sozler)
	g.secenekler = PackedStringArray(FERMAN if ferman != null else [DINLE])
	g.set_meta(META, o.gun)
	kuyruk.push_front(g)


static func ilgilenir(g: Gelen) -> bool:
	return g != null and g.id == ID


static func etiket(karar: String) -> String:
	var i := FERMAN.find(karar)
	if i >= 0: return TranslationServer.translate(SancakAskerTalebi.AYAR.secenekler[i])
	return TranslationServer.translate("koy.sancak.ulak_dinle")


static func uygun(o: Oturum, g: Gelen, secim: String) -> bool:
	if not kapida(o) or g.get_meta(META, -1) != o.gun or not g.secenekler.has(secim):
		return false
	if secim == DINLE: return not _teftis(o).is_empty()
	return SancakAskerTalebi.uygun(o, SancakAskerTalebi.olay(o), FERMAN.find(secim))


static func karar(o: Oturum, g: Gelen, secim: StringName) -> Dictionary:
	var sonuc := {"engellendi": true, "kaldi": false, "kirilan": -1}
	if not uygun(o, g, String(secim)): return sonuc
	var teftis := _teftis(o)
	if secim == DINLE:
		sonuc.sonuc_anahtari = "koy.sancak.ulak_sonuc"
	else:
		var ferman := SancakAskerTalebi.olay(o)
		sonuc.merge(SancakAskerTalebi.uygula(o, ferman, FERMAN.find(String(secim))), true)
		if not sonuc.ok: return sonuc
	if not teftis.is_empty():
		teftis.ulak_bildirdi = true
		o.sancak_teftisi = teftis
	sonuc.engellendi = false
	sonuc.ulak_ziyareti = true
	return sonuc


static func _teftis(o: Oturum) -> Dictionary:
	var d := SancakTeftisi.oku(o.sancak_teftisi)
	if d.son_gece != o.gun or d.get("ulak_bildirdi", false) or not d.sonuc in ["temiz", "bulunamadi"]:
		return {}
	return d
