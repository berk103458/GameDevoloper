extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 98)
	var y := o.yonetim
	_kontrol(not EkonomikRefah.degistir(y, -5), "Boş köye sahte ekonomik değer yazılmaz")
	var a := y.kabul({"ad": "Ekonomik durum A"})
	var b := y.kabul({"ad": "Ekonomik durum B"})
	a.refah = 95
	b.refah = 20
	var kasa := y.akce
	EkonomikRefah.degistir(y, 10)
	_kontrol(a.refah == 100 and b.refah == 30 and EkonomikRefah.oku(y) == 65 and y.akce == kasa, "Gerçek köylü ekonomik durumu sınırla değişir; hazine korunur")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(EkonomikRefah.oku(geri.yonetim) == 65, "Ekonomik Refah JSON'da korunur")
	var eski := a.kaydet()
	eski.erase("refah")
	_kontrol(Koylu.kayittan(eski).refah == 50, "Eski kişi kaydı dış denge varsayılanıyla açılır")
	for v in [-1, 101, 2.5, "80", null]:
		eski.refah = v
		_kontrol(Koylu.kayittan(eski).refah == 50, "Bozuk ekonomik değer hazineye veya puana sızmaz")
	print("EKONOMİK REFAH: GEÇTİ" if hata == 0 else "EKONOMİK REFAH: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
