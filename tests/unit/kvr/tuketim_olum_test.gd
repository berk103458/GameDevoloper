## EKO-09 ön doğrulama: gerçek gece açlık/donma ölümleri ve restore tutarlılığı.
extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	for soguk in [false, true]:
		var o := Oturum.new(kat, 91)
		var y := o.yonetim
		var k := y.kabul({"ad": "Tüketim sınırı", "stat": 5})
		k.saglik = 5
		k.moral = 80
		if soguk:
			IklimDeneyi.degistir(o, 3, "normal")
			y.kaynaklar.azalt("odun", 999)
		else:
			y.kaynaklar.azalt("gida", 999)
		var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
		var r := y.gece()
		var anahtar := "koy.olay.soguk" if soguk else "koy.olay.aclik"
		_kontrol(r.olaylar.any(func(v: Dictionary) -> bool: return v.get("anahtar", "") == anahtar), "Eksik kaynak doğru gerçek gece olayını üretir")
		_kontrol(y.nufus() == 0 and r.olenler == ["Tüketim sınırı"], "Kaynak yokluğunda sağlık eşiği gerçek köylüyü öldürür")
		_kontrol(geri.yonetim.gece() == r and geri.yonetim.kaydet() == y.kaydet(), "Restore aynı ölüm/tüketim/RNG sonucunu üretir")
	var y := Oturum.new(kat, 92).yonetim
	for i in 3: y.kabul({"ad": "Tok köylü %d" % i, "stat": 5})
	var r := y.gece()
	_kontrol(r.tuketim.gida == 3 and y.nufus() == 3 and r.olenler.is_empty(), "Normal iklimde üç canlı köylü üç erzak tüketir ve yaşar")
	print("TÜKETİM ÖLÜM: GEÇTİ" if hata == 0 else "TÜKETİM ÖLÜM: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
