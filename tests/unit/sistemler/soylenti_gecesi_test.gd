extends SceneTree
## SOY-02/06/12/13/16/40: kapıdan giren söylenti gerçek gece sonunda köyün gerçek kişilerine yayılır,
## kamuoyu olunca halkın moralini bir kez düşürür, söner ve düşer; küçük köyde susar.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _koy(kat: Katalog, nufus: int) -> Oturum:
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in nufus:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	return o


func _kayit(o: Oturum) -> Dictionary:
	return SoylentiKoprusu.ag(o).ag_kayitlari.get("kapi_haksiz_ret_5_yolcu_a", {})


func _koyde(o: Oturum, duyanlar: Array) -> bool:
	for d in duyanlar:
		if not String(d).is_valid_int() or o.yonetim.koylu(int(d)) == null:
			return false
	return true


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := _koy(kat, 15)
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	dene(_kayit(o).get("duyanlar", []).size() == 1, "Başta yalnız taşıyan duyar")

	o.gece_sonu()
	var d1: Array = _kayit(o).get("duyanlar", [])
	dene(d1.size() == 5 and _koyde(o, d1), "1. gece en çok 4 yeni duyan, hepsi köyde")
	dene(not bool(_kayit(o).get("kamuoyu_oldu", false)) and ag.bar_degisimi_toplam == 0, "Eşik altında kamuoyu ve bar yok")

	var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	var moral_once: Array = ikiz.yonetim.koylular.map(func(k: Koylu) -> int: return k.moral)
	var r_ikiz := {"olaylar": []}
	SoylentiKoprusu.gece(ikiz, r_ikiz)
	var moral_sonra: Array = ikiz.yonetim.koylular.map(func(k: Koylu) -> int: return k.moral)
	var dustu := true
	for i in moral_once.size():
		if int(moral_sonra[i]) != maxi(0, int(moral_once[i]) - Oturum.KOPRU_MORAL):
			dustu = false
	dene(dustu, "Kamuoyu olunca halkın morali bir kez düşer")
	dene(r_ikiz.olaylar.size() == 1 and r_ikiz.olaylar[0].get("soylenti") == "kapi_haksiz_ret_5_yolcu_a", "Kamuoyu gece raporunda görünür")

	var sonuc := o.gece_sonu()
	var d2: Array = _kayit(o).get("duyanlar", [])
	dene(d2.size() == 9 and _koyde(o, d2), "2. gece 4 yeni duyan daha")
	dene(bool(_kayit(o).get("kamuoyu_oldu", false)) and ag.bar_degisimi_toplam == -1, "%40 eşiğinde kamuoyu, bar bir kez")
	dene((sonuc.olaylar as Array).any(func(x: Dictionary) -> bool: return x.get("soylenti", "") != ""), "Gerçek gece raporunda kamuoyu satırı")
	dene(not ag.meclis_sikayeti_sec().is_empty(), "Kamuoyu meclis adayıdır")
	for i in 4:
		o.gece_sonu()
	dene(ag.bar_degisimi_toplam == -1, "Bar ikinci kez oynamaz")
	dene(not ag.meclis_sikayeti_sec().is_empty(), "Kamuoyu 5 gece dolmadan sürer")
	o.gece_sonu()
	dene(ag.meclis_sikayeti_sec().is_empty() and not _kayit(o).is_empty(), "5 gece sonra söner, kayıt durur")
	o.gece_sonu()
	dene(_kayit(o).is_empty(), "8. gece ağ kaydı düşer")

	var kucuk := _koy(kat, 4)
	for i in 3:
		kucuk.gece_sonu()
	dene(_kayit(kucuk).get("duyanlar", []).size() == 1 and not bool(_kayit(kucuk).get("kamuoyu_oldu", false)), "Nüfus 4'te ağ susar")
	print("SÖYLENTİ GECESİ: GEÇTİ" if hata == 0 else "SÖYLENTİ GECESİ: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
