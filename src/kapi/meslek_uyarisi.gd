## ISG-01: yalnız karar paneli için salt okunur meslek/yapı uyarısı.
class_name MeslekUyarisi
extends RefCounted
const AYAR_YOLU := "res://data/meslek_binalari.json"
const ISARET := &"isg01_meslek_uyarisi"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(AYAR_YOLU))

static func meslekler(g: Gelen) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if g == null: return sonuc
	var es := preload("res://src/sistemler/acilis_senaryosu.gd").ES
	if String(g.id) == es or es in g.acik_bayraklar + g.gizli_bayraklar: return sonuc
	var anahtar := ZanaatTuru.anahtar(ZanaatTuru.coz(g.id if g.adli else &"",g.sinif))
	if AYAR.meslekler.has(anahtar): sonuc.append(anahtar)
	if not g.adli: return sonuc
	for ek in AYAR.ek_meslekler.get(String(g.id).to_lower(),[]):
		if AYAR.meslekler.has(ek) and not String(ek) in sonuc: sonuc.append(String(ek))
	return sonuc

static func satirlar(y: KoyYonetimi, g: Gelen) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if y == null: return sonuc
	var pay := float(TuketimDengesi.gerek(y).kisi_gida)
	var gida := str(int(pay)) if is_equal_approx(pay,floor(pay)) else String.num(pay,2)
	for meslek in meslekler(g):
		var d: Dictionary = AYAR.meslekler[meslek]
		var var_mi := false
		var adlar := PackedStringArray()
		for hedef in d.binalar:
			adlar.append(TranslationServer.translate(String(hedef.ad_anahtari)))
			for b in y.binalar:
				if b.tur == hedef.tur and b.hazir(): var_mi = true
		if var_mi: continue
		sonuc.append(TranslationServer.translate("koy.meslek_uyarisi.satir") % [TranslationServer.translate(String(d.ad_anahtari))," / ".join(adlar),gida,int(GeciciIsler.AYAR.verim_yuzde)])
	return sonuc

static func ekle(kap: Container, y: KoyYonetimi, g: Gelen, punto: int = Tema.KUCUK_PX) -> void:
	for c in kap.get_children():
		if c.has_meta(ISARET):
			kap.remove_child(c)
			if not c.is_queued_for_deletion(): c.queue_free()
	for satir in satirlar(y,g):
		var l := Label.new()
		l.set_meta(ISARET,true)
		l.text = satir
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.add_theme_font_size_override("font_size",punto)
		kap.add_child(l)
