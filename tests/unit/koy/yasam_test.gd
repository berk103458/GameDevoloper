extends SceneTree

func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 202)
	var koy := oturum.yonetim
	var kisi := koy.kabul({"ad": "Ali"})
	var taban := Uretim.koylu_carpani(kisi, "", koy.a)
	var beklenen := [1.0, 0.8, 0.5, 0.0]
	for gun in beklenen.size():
		kisi.aclik = gun
		if not is_equal_approx(Uretim.koylu_carpani(kisi, "", koy.a), taban * beklenen[gun]):
			push_error("YSM-02: üretim çarpanı yanlış")
			quit(1)
			return
	if GeciciIsler.neden(koy, kisi, "dal_toplama") != "koy.gecici_is.uygun_degil":
		push_error("YSM-02: bitkin köylü geçici işe uygun olmamalı")
		quit(1)
		return
	var tarla := KoyBinasi.new()
	tarla.id = 90
	tarla.tur = "tarla"
	tarla.recete = "bugday"
	koy.binalar.append(tarla)
	kisi.is_yeri = tarla.id
	var rapor := koy.gece()
	if int(rapor.uretim.get("bugday", 0)) != 0:
		push_error("YSM-02: bitkin işçi buğday üretmemeli")
		quit(1)
		return
	koy.kaynaklar.ekle("gida", 20)
	koy.gece()
	if kisi.aclik != 0 or not is_equal_approx(Uretim.koylu_carpani(kisi, "", koy.a), taban):
		push_error("YSM-02: erzak payı açlığı sıfırlamalı")
		quit(1)
		return
	kisi.ac = false
	kisi.aclik = 0
	kisi.ev = tarla.id
	kisi.saglik = 60
	koy._saglik_ve_moral([], [], {kisi.id: koy.a.iyilesme + 1})
	if kisi.saglik != 60:
		push_error("YSM-02: büyük tedavi katkısına doğal iyileşme eklenmemeli")
		quit(1)
		return
	kisi.saglik = 0
	var carpani := Uretim.koylu_carpani(kisi, "", koy.a)
	var son_rapor := koy.gece()
	if carpani != 0.0 or int(son_rapor.uretim.get("bugday", 0)) != 0:
		push_error("ISG-40: sağlık sıfırken üretim olmamalı")
		quit(1)
		return
	var ev := KoyBinasi.new()
	ev.id = 91
	ev.tur = "cadir"
	koy.binalar.append(ev)
	var yatakli := koy.kabul({"ad": "Yataklı"})
	var acikta := koy.kabul({"ad": "Açıkta"})
	yatakli.ev = ev.id
	acikta.ev = -1
	for uyuyan in [yatakli, acikta]:
		uyuyan.yorgunluk = {"son_gece": koy.gun - 1}
	NobetYorgunlugu.gece(koy, [])
	if not yatakli.yorgunluk.is_empty() or acikta.yorgunluk.get("miktar", 0) != 1:
		push_error("YSM-03: yataklı uyku açıkta uykunun iki katı")
		quit(1)
		return
	for i in ev.yatak(koy.katalog) - 1:
		koy.kabul({"ad": "Ev sakini"}).ev = ev.id
	var fazla := koy.kabul({"ad": "Fazla"})
	fazla.ev = ev.id
	fazla.yorgunluk = {"son_gece": koy.gun - 1}
	var nobetci := koy.kabul({"ad": "Nöbetçi"})
	NobetYorgunlugu.gece(koy, [nobetci.id])
	var geri := Koylu.kayittan(JSON.parse_string(JSON.stringify(fazla.kaydet())))
	if fazla.yorgunluk.get("miktar", 0) != 1 or geri.yorgunluk != fazla.yorgunluk or nobetci.yorgunluk.get("son_gece") != koy.gun:
		push_error("YSM-03: dolu yatak, kayıt veya gece vardiyası")
		quit(1)
		return
	print("YSM-02, YSM-03 ve ISG-40: GEÇTİ")
	quit()
