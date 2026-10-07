extends SceneTree
var hata := 0
func _initialize() -> void:
	var k := Katalog.new()
	k.yukle()
	var o := _oturum(k)
	var once := o.kaydet()
	var ayarlar := o.yonetim.a
	for m in 4:
		_kontrol(IklimDeneyi.degistir(o, m, "normal")["ok"] and o.yonetim.mevsim() == m, "Dört mevsim anında zorlanır")
		var sonra := o.kaydet()
		sonra["koy_yonetimi"]["iklim_deneyi"] = {}
		sonra["mevsim"] = once["mevsim"]
		_kontrol(sonra == once and o.yonetim.a == ayarlar, "Mevsim seçimi gün/RNG/kaynak/denge Resource'unu değiştirmez")
	for p in [[-1, "normal", 2, 0], [3, "normal", 2, k.koy_ayarlari.kis_odun_hane], [3, "kar_firtinasi", 2, 2 * k.koy_ayarlari.kis_odun_hane], [1, "kuraklik", 3, 0]]:
		o = _oturum(k)
		IklimDeneyi.degistir(o, p[0], p[1])
		var geri := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
		_kontrol(geri.kaydet() == o.kaydet(), "İklim ayarı gerçek kayıt/snapshot roundtrip ile korunur")
		var r := o.yonetim.gece()
		_kontrol(r["tuketim"]["gida"] == p[2] and int(r["tuketim"].get("odun", 0)) == p[3], "Gerçek gece gıda/odun tüketimi deney çarpanını kullanır")
		_kontrol(geri.yonetim.gece() == r, "Restore sonrası aynı gerçek gece/RNG sonucu")
	o = _oturum(k)
	IklimDeneyi.degistir(o, 1, "kar_firtinasi")
	_kontrol(o.yonetim.mevsim() == 1 and o.yonetim.kis_mi(), "Yazdaki fırtına da gerçek soğuk etkisi yaratır")
	o.yonetim.kaynaklar.azalt("odun", 999)
	var r := o.yonetim.gece()
	_kontrol(r["olaylar"].any(func(x: Dictionary) -> bool: return x["anahtar"] == "koy.olay.soguk"), "Eksik yakacak gerçek soğuk/sağlık olayını tetikler")
	IklimDeneyi.degistir(o, -1, "normal")
	_kontrol(not o.yonetim.has_meta(IklimDeneyi.META) and o.yonetim.mevsim() == Takvim.mevsim(o.gun, ayarlar.mevsim_gun), "Sıfırlama o günün doğal takvimine döner")
	var sabit := o.kaydet()
	_kontrol(not IklimDeneyi.degistir(o, 4, "normal")["ok"] and not IklimDeneyi.degistir(o, 1, "yok")["ok"] and o.kaydet() == sabit, "Geçersiz seçim yan etkisiz reddedilir")
	var eski := sabit.duplicate(true)
	eski["koy_yonetimi"].erase("iklim_deneyi")
	_kontrol(IklimDeneyi.ayar(Oturum.kayittan(k, eski).yonetim).is_empty(), "Eski kayıtta doğal iklim korunur")
	# Aynı gerçek tarla/çalışan: normal ilkbaharda üretim, fırtınada mevcut soğuk kaydırması.
	o = _oturum(k)
	var tarla: KoyBinasi
	for cy in o.yonetim.a.izgara_boyut.y:
		if tarla != null: break
		for cx in o.yonetim.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if o.yonetim.yerlesim("tarla", h)["olur"]:
				var d := o.yonetim.bina_kur("tarla", h)
				tarla = o.yonetim.bina(d["id"])
				tarla.insa_kalan = 0
				o.yonetim.ata(o.yonetim.koylular[0].id, tarla.id)
				break
	_kontrol(tarla != null, "Gerçek tarla ve çalışan kurulur")
	var soguk := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
	IklimDeneyi.degistir(soguk, 0, "kar_firtinasi")
	var sicak_rapor := o.yonetim.gece()
	var soguk_rapor := soguk.yonetim.gece()
	_kontrol(int(sicak_rapor["uretim"].get("gida", 0)) > 0 and int(soguk_rapor["uretim"].get("gida", 0)) == 0, "Fırtına gerçek tarla üretimini mevcut soğuk iş kaydırmasıyla durdurur")
	print("İKLİM DENEYİ: GEÇTİ" if hata == 0 else "İKLİM DENEYİ: KALDI")
	quit(hata)
func _oturum(k: Katalog) -> Oturum:
	var o := Oturum.new(k, 84)
	for i in 2: o.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci"})
	return o
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
