extends SceneTree
# KAY-23: aynı mutlak takvimden yüklenen iki oturumun dedikodu yaşı.
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var asil := Oturum.new(kat, 3123)
	asil.yonetim.gun = 8
	dene(asil.dedikodu.olay_kaydet("iki_gecelik", "rusvet", 6, "tanik_23", 3).olur, "Tanıklı iki gecelik fikstür")
	var veri: Dictionary = JSON.parse_string(JSON.stringify(asil.kaydet()))
	var a := Oturum.kayittan(kat, veri)
	var b := Oturum.kayittan(kat, veri)
	for o in [a, b]:
		var kayit: Dictionary = o.dedikodu.kayitlar()[0]
		dene(o.gun == 8 and o.gun - int(kayit.kayit_gecesi) == 2, "Yüklemede yaş tam iki gece")
		dene(int(kayit.yayilim_gecesi) == 9 and kayit.tanik_id == "tanik_23", "Tanık ve mutlak yayılma tarihi korunur")
		dene(not kayit.yayildi and not kayit.basildi, "Yüklemek yayın veya basım yapmaz")
		dene(o.dedikodu.pusula_satirlari(8).is_empty(), "İki gecelik haber erken basılmaz")
	dene(a.dedikodu.kaydet() == b.dedikodu.kaydet(), "JSON ikizlerinin kuyrukları aynı")
	for o in [asil, a, b]:
		o.gece_sonu()
		dene(o.gun == 9 and o.dedikodu.pusula_satirlari(9).size() == 1, "Gerçek üçüncü gecede tek yayın")
	# JSON sayıları float açar; karşılaştırmanın iki tarafını aynı sınırdan geçir.
	dene(JSON.parse_string(JSON.stringify(asil.dedikodu.kaydet())) == a.dedikodu.kaydet() and a.dedikodu.kaydet() == b.dedikodu.kaydet(), "Kayıtsız ve yüklenmiş zaman çizgileri aynı")
	print("KAY-23 DEDİKODU İKİZİ: GEÇTİ" if hata == 0 else "KAY-23 DEDİKODU İKİZİ: KALDI")
	quit(hata)
