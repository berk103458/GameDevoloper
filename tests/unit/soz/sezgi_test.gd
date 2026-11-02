extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	if not FileAccess.file_exists("res://src/soz/muhafiz_sezgisi.gd"):
		dene(false, "Sezgi henüz yok")
		quit(hata)
		return
	var sezgi = load("res://src/soz/muhafiz_sezgisi.gd")
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1706)
	preload("res://src/sistemler/muhafiz_gecmisi.gd").sec(o, "eski_levent")
	var g := o._adli_gelen(&"chr_001")
	var s := g.chr_sorgusu()
	var rng_once: int = s._rng.state
	var zar_once: Dictionary = s.son_zar.duplicate(true)
	o.muhafiz_tecrubesi = sezgi.esik() - 1
	dene(sezgi.ac(o, g, {"isik":0.0}).is_empty() and s.ipuclari.is_empty(), "Eşik altında satır/ipucu yok")
	o.muhafiz_tecrubesi = sezgi.esik()
	dene(not sezgi.ac(o, g, {"isik":0.0}).is_empty() and s.ipuclari.has(s.karakter.gorsel_hata_ipucu), "Eşiğe eşitken mevcut Clue açılır")
	dene(sezgi.ac(o, g, {"isik":0.0}).is_empty(), "Bir ziyarette tek sezgi")
	dene(s._rng.state == rng_once and s.son_zar == zar_once and s._denemeler.is_empty(), "Sezgi zar atmaz/RNG değiştirmez")
	var geri := KapiAnlikGoruntusu.gelen_yukle(JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(g))), kat)
	dene(geri != null and sezgi.ac(o, geri, {"isik":0.0}).is_empty(), "Snapshot yüklemesi sezgiyi tekrarlamaz")
	var karanlik := o._adli_gelen(&"chr_001")
	dene(sezgi.ac(o, karanlik, {"isik":false}).is_empty() and karanlik.chr_sorgusu().ipuclari.is_empty(), "Işık kapalıysa görsel sezgi yok")
	dene(sezgi.ac(o, karanlik, {"isik":4.0,"tipi":true}).is_empty(), "Tipide ayrıntı sezgisi yok")
	var varyant: Array = [{"metin":"Özel sezgi", "gecmisler":["ahi_ciragi"], "kosullar":{}, "ipucu":""}]
	dene(sezgi.ac(o, karanlik, {"isik":true}, varyant).is_empty(), "Geçmiş uyuşmazsa satır gizli")
	varyant.append({"metin":"Genel sezgi", "gecmisler":[], "kosullar":{}, "ipucu":""})
	dene(sezgi.ac(o, karanlik, {"isik":true}, varyant) == "Genel sezgi", "Varsa genel sezgi gelir")
	var gizli_sayisi := 0
	for dosya in DirAccess.get_files_at("res://data/chr_runtime"):
		if not dosya.begins_with("CHR_") or not dosya.ends_with(".tres"): continue
		var k := load("res://data/chr_runtime/" + dosya) as KarakterVerisi
		if not k.gizlenen_gercek.is_empty():
			gizli_sayisi += 1
			dene(sezgi.AYAR.karakterler.has(dosya.get_basename().to_lower()), "Mevcut sır CHR sezgisi var")
	dene(gizli_sayisi > 0, "Kapsam gerçekten CHR kaynağı taradı")
	print("MUHAFIZ SEZGİSİ: GEÇTİ" if hata == 0 else "MUHAFIZ SEZGİSİ: KALDI")
	quit(hata)
