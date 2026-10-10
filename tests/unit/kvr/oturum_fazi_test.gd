extends SceneTree
const FAZ = preload("res://src/sistemler/oturum_fazi.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1313)
	dene(FAZ.durum(o) == "kapi", "Yeni oyun kapıdan başlar")
	FAZ.ayarla(o, "koy")
	o._gemini_sira = 4
	var v: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat, v)
	dene(FAZ.durum(geri) == "koy" and geri._gemini_sira == 4 and geri.gun == o.gun, "JSON köy fazı ve sıra korunur")
	FAZ.ayarla(geri, "kapi")
	dene(Oturum.kayittan(kat, geri.kaydet()).kaydet().faz == "kapi", "Yeni gün kapı fazı kalıcı")
	v.erase("faz")
	dene(FAZ.durum(Oturum.kayittan(kat, v)) == "kapi", "Legacy alan yok: eski kapı davranışı")
	for bozuk in [null, 0, true, {}, [], "gece", "Koy"]:
		v.faz = bozuk
		dene(FAZ.durum(Oturum.kayittan(kat, v)) == "kapi", "Bozuk faz güvenli kapı varsayımı")
	print("OTURUM FAZI: GEÇTİ" if hata == 0 else "OTURUM FAZI: KALDI")
	quit(hata)
