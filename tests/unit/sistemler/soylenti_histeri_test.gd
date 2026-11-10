extends SceneTree
## SOY-15: kamuoyuna dönen yanlış söylenti açık histeri vakasını +1 artırır; doğru söylenti ve vakasız köy artırmaz.

const H = preload("res://src/koy/batil_inanc_histerisi.gd")
var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _koy(kat: Katalog, vaka: bool) -> Oturum:
	var o := Oturum.new(kat, 808)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(10000, {"gida": 2000, "su": 100})
	y.gun = 6
	o.gun = 6
	for i in 10:
		y.kabul({"ad": "Komşu %d" % i}).moral = 60
	y.kabul({"ad": "Otacı Dudu Hatun", "adli_id": "chr_008", "sinif": "esnaf"})
	if vaka:
		KuyuKirliligi.kirlet(y)
		FisiltiGazetesi.gece(y, [])
	return o


func _kamuoyu(o: Oturum, dogru: bool) -> Dictionary:
	var a: RefCounted = SoylentiKoprusu.ag(o)
	a.soylenti_ekle("kapi_test", "haksiz_ret", "1", dogru, {"gece": o.gun})
	for id in o.yonetim.koylular.slice(0, 6):
		a.ag_kayitlari["kapi_test"].duyanlar.append(str(id.id))
	var r := {"olaylar": []}
	SoylentiKoprusu.gece(o, r)
	return r


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := _koy(kat, true)
	dene(H.bekliyor(o.yonetim) and H.durum(o.yonetim).vaka.seviye == 1, "Kirli kuyuda vaka 1/3 açık")
	var r := _kamuoyu(o, false)
	dene(H.durum(o.yonetim).vaka.seviye == 2, "Yanlış kamuoyu histeriyi 2/3 yapar")
	dene(r.olaylar.any(func(x: Dictionary) -> bool: return String(x.anahtar).contains("histeri")), "Sabah raporunda histeri satırı")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(H.durum(geri.yonetim).vaka.seviye == 2, "Artış kayıttan döner")
	var d := _koy(kat, true)
	_kamuoyu(d, true)
	dene(H.durum(d.yonetim).vaka.seviye == 1, "Doğru kamuoyu histeriyi artırmaz")
	var bos := _koy(kat, false)
	_kamuoyu(bos, false)
	dene(H.durum(bos.yonetim).vaka.is_empty(), "Vaka yokken yanlış kamuoyu hedef seçmez")
	print("SÖYLENTİ HİSTERİ: GEÇTİ" if hata == 0 else "SÖYLENTİ HİSTERİ: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
