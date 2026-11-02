extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	var d: Variant = o.get("dedikodu")
	if d == null:
		dene(false, "Dedikodu oturum kaydına henüz bağlı değil")
		quit(hata)
		return
	dene(d.olay_kaydet("olay_1", "rusvet", 4, "tanik_1", 2).olur, "Tanıklı kayıt doğar")
	dene(not d.olay_kaydet("taniksiz", "rusvet", 4, "", 2).olur, "Tanıksız kayıt doğmaz")
	var veri := JSON.parse_string(JSON.stringify(o.kaydet())) as Dictionary
	var geri := Oturum.kayittan(kat, veri)
	var ikiz := Oturum.kayittan(kat, veri)
	dene(geri.gun == 5 and ikiz.gun == 5, "Yükleme geceyi ilerletmez")
	var yuklu: Variant = geri.get("dedikodu")
	dene(yuklu.kayitlar().size() == 1 and yuklu.kayitlar()[0].kayit_gecesi == 4 and yuklu.kayitlar()[0].yayilim_gecesi == 6, "Doğum ve yayılma gecesi aynı kalır")
	dene(yuklu.kayitlar()[0].tanik_id == "tanik_1" and yuklu.kayitlar() == ikiz.get("dedikodu").kayitlar(), "Tanık kimliği ve ikiz yükleme eşit")
	dene(yuklu.pusula_satirlari(5).is_empty(), "Yüklemede erken yayın yok")
	geri.gece_sonu()
	dene(geri.gun == 6 and yuklu.pusula_satirlari(6).size() == 1, "Gerçek takvim gününde bir satır")
	veri.dedikodu.kayitlar[0].tanik_id = ""
	veri.dedikodu.kayitlar[0].yayildi = true
	var taniksiz := Oturum.kayittan(kat, veri)
	taniksiz.get("dedikodu").gece_ilerlet(6)
	dene(taniksiz.get("dedikodu").pusula_satirlari(6).is_empty(), "Tanıksız yüklenen satır da yayılmaz")
	veri.erase("dedikodu")
	var eski := Oturum.kayittan(kat, veri)
	dene(eski.get("dedikodu").kayitlar().is_empty(), "Eski kayıtta eksik kuyruk boş")
	dene(o.get("dedikodu").kayitlar()[0].kayit_gecesi == 4, "Kaynak oturum değişmez")
	print("DEDİKODU KAYIT: GEÇTİ" if hata == 0 else "DEDİKODU KAYIT: KALDI")
	quit(hata)
