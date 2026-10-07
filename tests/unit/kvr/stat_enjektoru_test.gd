extends SceneTree
var hata := 0
func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 43)
	_kontrol(not StatEnjektoru.degistir(o, "Moral", 5)["ok"], "Boş köye sahte moral yazılmaz")
	o.yonetim.kabul({"ad": "A", "sinif": "ciftci"})
	o.yonetim.kabul({"ad": "B", "sinif": "esnaf"})
	var a := o.yonetim.koylular[0]
	var b := o.yonetim.koylular[1]
	a.moral = 95
	b.moral = 20
	a.saglik = 5
	b.saglik = 80
	StatEnjektoru.degistir(o, "Moral", 10)
	_kontrol(a.moral == 100 and b.moral == 30 and StatEnjektoru.oku(o, "Moral") == 65, "Delta her köylüye sınırla uygulanır; ortalama doğru")
	StatEnjektoru.degistir(o, "Saglik", -10)
	_kontrol(a.saglik == 0 and b.saglik == 70 and StatEnjektoru.oku(o, "Saglik") == 35, "Sağlık sınırı gerçek köylülerde korunur; anında ölüm uydurulmaz")
	o.yonetim.asayis_riski = 40
	StatEnjektoru.degistir(o, "Guvenlik", 10)
	_kontrol(o.yonetim.asayis_riski == 30 and StatEnjektoru.oku(o, "Guvenlik") == 70, "Güvenlik artışı riski azaltır")
	StatEnjektoru.degistir(o, "Guvenlik", -999)
	_kontrol(o.yonetim.asayis_riski == 100, "Güvenlik alt sınırı")
	o.koy_akce = 12
	StatEnjektoru.degistir(o, "Refah", 4)
	_kontrol(o.koy_akce == 16 and StatEnjektoru.oku(o, "Refah") == 16, "Refah kamu kasasının görünümüdür")
	var erzak := o.ambar
	StatEnjektoru.degistir(o, "Erzak", -4)
	_kontrol(o.ambar == erzak - 4, "Erzak ayrı hayali stat değil gerçek gıdadır")
	var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
	for alan in StatEnjektoru.ALANLAR:
		_kontrol(StatEnjektoru.oku(geri, alan) == StatEnjektoru.oku(o, alan), "Beş gösterge normal kayıtla korunur")
	var once := JSON.stringify(o.kaydet())
	_kontrol(not StatEnjektoru.degistir(o, "Refah", 1000001)["ok"] and JSON.stringify(o.kaydet()) == once, "Geçersiz delta yan etkisiz")
	print("STAT ENJEKTÖRÜ: GEÇTİ" if hata == 0 else "STAT ENJEKTÖRÜ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
