extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 22)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	kat.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "gida"]: y.kaynaklar.ekle(t, 100)
	var b := kur(y)
	y.kabul({"ad":"Nöbetçi", "sinif":"ciftci", "stat":5})
	y.gun = 21
	var risk: int = KurtBaskini.AYAR.risk_yuzde
	KurtBaskini.AYAR.risk_yuzde = 100
	var once := JSON.stringify(o.kaydet())
	dene(KurtBaskini.agillar(y) == [b] and KurtBaskini.duraklar(y).size() == 1 and JSON.stringify(o.kaydet()) == once, "Gerçek hazır ağıl ve salt okunur nöbet")
	var geri := Oturum.kayittan(kat, JSON.parse_string(once))
	var gida := y.kaynaklar.miktar("gida")
	var olaylar: Array[Dictionary] = []
	dene(KurtBaskini.gece(y, olaylar) == 4 and y.kaynaklar.miktar("gida") == gida - 4, "Korunmayan ağıl aynı ambardan dört yem")
	once = JSON.stringify(o.kaydet())
	dene(KurtBaskini.gece(y, olaylar) == 0 and olaylar.size() == 1 and JSON.stringify(o.kaydet()) == once, "Aynı gece çift RNG/kayıp/olay yok")
	dene(KurtBaskini.gece(geri.yonetim, []) == 4 and geri.kaydet() == o.kaydet(), "Restore aynı risk ve kayıt sonucu")
	y.gun += 1
	var k := y.koylular[0]
	dene(y.muhafiz_ata(k.id), "Mevcut muhafız ataması")
	dene(KurtBaskini.korunan(y, b), "Etkin muhafız ağılı korur")
	var rng := y._rng.state
	dene(KurtBaskini.gece(y, []) == 0 and y._rng.state == rng, "Korunan ağılda erzak ve zar kaybı yok")
	y.bosalt(k.id)
	y.gun += 1
	geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	gida = y.kaynaklar.miktar("gida")
	var rapor := y.gece()
	dene(int(rapor.tuketim.gida) >= 4 and gida - y.kaynaklar.miktar("gida") == int(rapor.tuketim.gida) + int(rapor.ziyan.bozulma.get("gida", 0)), "Gerçek gece yemi normal tüketimle raporlar")
	dene(geri.yonetim.gece() == rapor, "Gerçek gece restore eşitliği")
	y.gun = 0
	rng = y._rng.state
	dene(KurtBaskini.agillar(y).is_empty() and KurtBaskini.gece(y, []) == 0 and rng == y._rng.state, "Sıcak havada baskın veya RNG yok")
	dene(KurtBaskini.oku(2.5) == -1 and KurtBaskini.oku("4") == -1 and KurtBaskini.oku(2.0) == 2, "Bozuk/eski optional makbuz")
	KurtBaskini.AYAR.risk_yuzde = risk
	print("KURT BASKINI: GEÇTİ" if hata == 0 else "KURT BASKINI: KALDI")
	quit(hata)
func kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("agil", h).olur:
				var b := y.bina(y.bina_kur("agil", h).id)
				b.insa_kalan = 0
				return b
	return null
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
