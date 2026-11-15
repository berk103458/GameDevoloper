extends "res://tests/unit/kapi/kapi_kavgasi_oyun_test.gd"
const S = preload("res://src/kapi/siddet_korkusu_adaptoru.gd")

func _calistir() -> void:
	kat = Katalog.new()
	kat.yukle()
	if _sira() != true: hata += 1
	print("SIDDET KORKUSU OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(1 if hata > 0 else 0)

func _sira() -> bool:
	for secenek in KapiKavgasi.GECERLI_SECENEKLER:
		for bos in [false, true]:
			var o := _oturum(true)
			o.muhafiz_akce = 9
			var g := o._adli_gelen(&"chr_001")
			g.chr_sorgusu().tansiyon = 10
			var kuyruk: Array[Gelen] = []
			if not bos: kuyruk.append(g)
			A.tanik_hazirla(o, kuyruk)
			dene(o.karar_ver(_gelen(), &"ret").durum == "kavga_acik", "Gerçek CAT-02 ret yolu")
			var r: Dictionary = A.sec(o, secenek, {"zar_atis": 6})
			dene(r.get("olur", false), "Gerçek seçim işlendi")
			var sayi := 1 if secenek == "askerle_karsilik" and not bos else 0
			dene(r.get("ayrilan_sayisi", -1) == sayi, "Şiddet / sakin seçenek / boş sıra")
			dene(kuyruk.size() == (0 if bos else 1 - sayi), "Gerçek kuyruk yerinde değişir")
			if sayi > 0:
				dene(o.dedikodu.pusula_satirlari(o.gun + 1).size() > 0, "Ertesi gün mevcut Dedikodu")
	var o := _oturum(true)
	var g := o._adli_gelen(&"chr_001")
	g.chr_sorgusu().tansiyon = 4
	var kuyruk: Array[Gelen] = [g]
	A.tanik_hazirla(o, kuyruk)
	S.menu(o, true)
	var r := {}
	S.uygula(o, "olum", r, {"ayrilma_olasilik_tablosu": []})
	dene(g.chr_sorgusu().tansiyon == 4, "Menü açıkken gerçek CHR donar")
	S.menu(o, false)
	dene(g.chr_sorgusu().tansiyon == 7, "Kapanışta tek artış")
	S.menu(o, true)
	S.menu(o, false)
	dene(g.chr_sorgusu().tansiyon == 7, "Aç-kapa artışı çoğaltmaz")
	A.al(o).gelen = g
	g.set_meta(DiplomatikHeyet.META, {})
	g.chr_sorgusu().tansiyon = 10
	S.uygula(o, "olum", r)
	dene(r.ayrilan_sayisi == 0 and kuyruk.size() == 1, "Gerçek heyet engeli")
	for tansiyon in [1, 10]:
		o = _oturum(true)
		g = o._adli_gelen(&"chr_001")
		g.chr_sorgusu().tansiyon = tansiyon
		kuyruk = [g]
		A.tanik_hazirla(o, kuyruk)
		r = {}
		S.uygula(o, "olum", r, {"ayrilma_olasilik_tablosu": []})
		dene(r.ayrilan_sayisi == 0 and kuyruk.size() == 1, "Tablo olasılığı sıfır / eşik altı")
	return true
