extends SceneTree
## KAY-41 / KAY-52: göçmüş kayıtla mevcut duman. İkinci duman aracı yok.

const DUMAN = preload("res://tests/oto/duman_cekirdek.gd")

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var oturum := DUMAN.gocmus_oturum(kat)
	dene(oturum != null, "KAY-41 göçmüş kayıt açılır")
	if oturum == null:
		print("GÖÇMÜŞ DUMAN: KALDI")
		quit(1)
		return
	var yirmi: Dictionary = DUMAN.model_dongusu(oturum, kat, 20)
	print("KAY-41 RAPOR: ", JSON.stringify(yirmi))
	dene(yirmi.olur and int(yirmi.gece) == 20, "KAY-41 yirmi gece çökmez")
	var hedef := maxi(1, kat.koy_ayarlari.mevsim_gun) * 12
	var uc_yil: Dictionary = DUMAN.model_dongusu(DUMAN.gocmus_oturum(kat), kat, hedef)
	print("KAY-52 RAPOR: ", JSON.stringify(uc_yil))
	dene(uc_yil.olur and int(uc_yil.gece) == hedef, "KAY-52 üç yıl aç-kapa biter")
	print("GÖÇMÜŞ DUMAN: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)
