extends SceneTree
var hata := 0
func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	var y := o.yonetim
	var k := y.kabul({"ad": "Test", "sinif": "ciftci", "stat": 5})
	var b: KoyBinasi
	for cy in y.a.izgara_boyut.y:
		if b != null: break
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var d := y.bina_kur("tarla", h)
				b = y.bina(d["id"])
				b.insa_kalan = 0
				b.seviye = 2
				y.ata(k.id, b.id)
				break
	k.moral = 50
	var once := o.kaydet()
	var r := KoyluDenetcisi.satirlar(o)[0]
	_kontrol(r["stat"] == 5 and is_equal_approx(r["carpan"], 2.0) and is_equal_approx(r["uretim"]["gida"], 4.0), "Atanmış gerçek tarla + meslek + stat + seviye brüt verimi")
	_kontrol(o.kaydet() == once and r["eylem"] == "Sahne yok", "Gözlem model/ambar/RNG yazmaz; eksik sahnede eylem uydurulmaz")
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._uret(u, olaylar)
	_kontrol(is_equal_approx(float(u["gida"]) + float(y._artik["%d:gida" % b.id]), r["uretim"]["gida"]), "Denetçi gerçek üretim + kesir artığıyla eşleşir")
	k.ac = true
	k.bayrak_ekle("hasta")
	var dusuk := KoyluDenetcisi.satirlar(o)[0]
	_kontrol(dusuk["carpan"] < r["carpan"], "Açlık/hastalık ortak üretim çarpanından okunur")
	IklimDeneyi.degistir(o, 3, "normal")
	_kontrol(KoyluDenetcisi.satirlar(o)[0]["engel"] == "Kış / soğuk", "Kış engeli canlı modelden")
	k.is_yeri = KoyYonetimi.MUHAFIZ
	_kontrol(KoyluDenetcisi.satirlar(o)[0]["bina"] == "Muhafız", "Muhafız görevi bina gibi uydurulmaz")
	for i in 31: y.kabul({"ad": "Ek", "sinif": "ciftci"})
	_kontrol(KoyluDenetcisi.satirlar(o).size() == 32 and KoyluDenetcisi.satirlar(null).is_empty(), "Görsel 30 kişi sınırından bağımsız tüm köylüler")
	print("KÖYLÜ DENETÇİSİ: GEÇTİ" if hata == 0 else "KÖYLÜ DENETÇİSİ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
