extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	for iklim in [[0, "normal", 3, 0], [3, "normal", 3, 3], [1, "kar_firtinasi", 3, 6], [1, "kuraklik", 5, 0]]:
		var o := Oturum.new(kat, 104)
		var y := o.yonetim
		for yas in ["cocuk", "yetiskin", "yasli"]:
			y.kabul({"ad": yas, "yas_grubu": yas, "stat": 5})
		IklimDeneyi.degistir(o, iklim[0], iklim[1])
		var once := y.kaydet()
		var hesap := TuketimDengesi.gerek(y)
		_kontrol(hesap.gida == iklim[2] and hesap.odun == iklim[3], "Her yaş canlı nüfusta sayılır; iklim gerçek gece ihtiyacını çarpar")
		_kontrol(y.kaydet() == once, "Tüketim önizlemesi gün/RNG/stok değiştirmez")
		_kontrol(is_equal_approx(y.gida_gunu(), float(y.kaynaklar.miktar("gida")) / iklim[2]), "HUD gıda süresi gerçek iklim hesabını kullanır")
		var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
		var r := y.gece()
		_kontrol(r.tuketim.gida == iklim[2] and int(r.tuketim.get("odun", 0)) == iklim[3], "Gerçek gece nüfus/iklim ihtiyacını tüketir")
		_kontrol(geri.yonetim.gece() == r, "Restore sonrası aynı tüketim/gece sonucu")
	var bos := Oturum.new(kat, 105).yonetim
	_kontrol(TuketimDengesi.gerek(bos).gida == 0 and TuketimDengesi.gerek(bos).odun == 0, "Boş köy kaynak tüketmez")
	var o := Oturum.new(kat, 106)
	var y := o.yonetim
	for i in 3: y.kabul({"ad": "Aynı evde %d" % i})
	var ev := _kur(y)
	_kontrol(ev != null, "Gerçek kulübe kurulabilir")
	if ev != null:
		y._barindir()
		_kontrol(y.koylular.all(func(k: Koylu) -> bool: return k.ev == ev.id), "Üç köylü aynı gerçek kulübeye yerleşir")
		IklimDeneyi.degistir(o, 3, "normal")
		y.kaynaklar.azalt("odun", 999)
		y.kaynaklar.ekle("odun", 3)
		var r := y.gece()
		_kontrol(r.tuketim.odun == 3 and y.kaynaklar.miktar("odun") == 0, "Aynı evde üç canlı kişi üç yakacak tüketir; hane indirimi yok")
	print("TÜKETİM DENGESİ: GEÇTİ" if hata == 0 else "TÜKETİM DENGESİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("kulube", h)["olur"]:
				var b := y.bina(y.bina_kur("kulube", h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
