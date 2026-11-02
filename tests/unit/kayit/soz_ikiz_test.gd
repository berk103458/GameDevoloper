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
	_kasalar(kat)
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
	print("KAYIT İKİZİ (KAY-23/45): GEÇTİ" if hata == 0 else "KAYIT İKİZİ (KAY-23/45): KALDI")
	quit(hata)

func _kasalar(kat: Katalog) -> void:
	# KAY-45: farklı tutarlar aktarımı ve birbirine karışmayı yakalar.
	for tutarlar in [[17, 71], [0, 83], [29, 0]]:
		var o := Oturum.new(kat, 3145)
		o.muhafiz_akce = tutarlar[0]
		o.koy_akce = tutarlar[1]
		for surum in [2, 3]:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			veri.surum = surum
			var once := veri.duplicate(true)
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Kasa fikstürü açılır")
			if geri == null: continue
			dene(geri.muhafiz_akce == tutarlar[0] and geri.koy_akce == tutarlar[1], "Kişisel kese ve köy akçesi göçte ayrı korunur")
			dene(geri.muhafiz_akce + geri.koy_akce == o.muhafiz_akce + o.koy_akce, "Göç para üretmez veya kaybetmez")
			dene(veri == once, "Kasa göçü kaynak veriyi değiştirmez")
			var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
			dene(ikiz.muhafiz_akce == tutarlar[0] and ikiz.koy_akce == tutarlar[1], "Tekrar yüklemede transfer yok")
		dene(o.muhafiz_akce == tutarlar[0] and o.koy_akce == tutarlar[1], "Kaynak oturum kasaları aynı")
