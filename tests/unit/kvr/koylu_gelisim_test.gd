extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 61)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	var b := _kur(y, "tarla")
	var k := y.kabul({"ad": "Çırak Ali", "sinif": "ciftci", "stat": 5})
	k.moral = 50
	y.ata(k.id, b.id)
	var eski := k.kaydet()
	_kontrol(Koylu.kayittan(eski).gelisim.is_empty() and KoyluGelisimYoneticisi.carpan(k, "tarla") == 1.0, "Eski kayıt ve ilk gün dengesi korunur")
	for gece in range(4):
		y.gece()
		k.moral = 50
	_kontrol(KoyluGelisimYoneticisi.durum(k).xp == 4 and KoyluGelisimYoneticisi.carpan(k, "tarla") == 1.0, "İlk dört gerçek gecede yalnız XP")
	y.gece()
	k.moral = 50
	_kontrol(KoyluGelisimYoneticisi.durum(k).kademe == 1 and is_equal_approx(KoyluGelisimYoneticisi.carpan(k, "tarla"), 1.1), "Beşinci fiili gece Kalfa ve %10 kazanılmış bonus")
	var artik_anahtari := "%d:gida" % b.id
	var onceki_artik := float(y._artik.get(artik_anahtari, 0.0))
	var sonraki := y.gece()
	k.moral = 50
	_kontrol(is_equal_approx(float(sonraki["uretim"]["gida"]) + float(y._artik.get(artik_anahtari, 0.0)) - onceki_artik, 3.52), "Kalfa bonusu sonraki gerçek üretimde kullanılır")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	for n in range(4):
		y.gece()
		geri.yonetim.gece()
		k.moral = 50
		geri.yonetim.koylu(k.id).moral = 50
	_kontrol(k.gelisim == geri.yonetim.koylu(k.id).gelisim and y._rng.state == geri.yonetim._rng.state, "XP ve sonraki geceler JSON/RNG ile aynen sürer")
	_kontrol(KoyluGelisimYoneticisi.usta(k) and k.usta_mi() and k.stat == 5 and is_equal_approx(KoyluGelisimYoneticisi.carpan(k, "tarla"), 1.2), "Onuncu çalışma gecesi Usta; beceri kaynağı ezilmez")
	var once := k.gelisim.duplicate(true)
	KoyluGelisimYoneticisi.gece(y, {k.id: b.id}, [])
	_kontrol(k.gelisim == once, "Usta sınırı ve aynı gece tekrar çağrısı bonus katlamaz")
	var kalfa := y.kabul({"sinif": "ciftci", "stat": 5})
	y.ata(kalfa.id, b.id)
	kalfa.bayrak_ac("hasta")
	KoyluGelisimYoneticisi.gece(y, {kalfa.id: b.id}, [])
	_kontrol(kalfa.gelisim.is_empty(), "Hasta çalışma kaydı XP vermez")
	kalfa.bayraklar.clear()
	KoyluGelisimYoneticisi.gece(y, {}, [])
	_kontrol(kalfa.gelisim.is_empty(), "Fiili üretim olmadan XP yok")
	var h := _kur(y, "hizarhane")
	y.ata(kalfa.id, h.id)
	KoyluGelisimYoneticisi.gece(y, {kalfa.id: h.id}, [])
	_kontrol(kalfa.gelisim.is_empty() and KoyluGelisimYoneticisi.carpan(k, "hizarhane") == 1.0, "Uyumsuz iş XP kazanmaz; usta bonusu başka işe taşınmaz")
	y.ata(kalfa.id, b.id)
	y.kaynaklar.kapasite = y.kaynaklar.toplam()
	y.gece()
	_kontrol(kalfa.gelisim.is_empty(), "Gerçek dolu ambarda XP kazanılmaz")
	y.kaynaklar.kapasite = 10000
	var demirhane := _kur(y, "demirhane")
	var demirci := y.kabul({"sinif": "esnaf", "stat": 5})
	demirci.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
	y.ata(demirci.id, demirhane.id)
	y.kaynaklar.stok["demir"] = 0
	y.gece()
	_kontrol(demirci.gelisim.is_empty(), "Gerçek eksik girdili demirhanede XP yok")
	var d := y.kabul({"sinif": "ciftci", "stat": 5})
	var ikinci := _kur(y, "tarla")
	y.ata(d.id, ikinci.id)
	KoyluGelisimYoneticisi.gece(y, {d.id: ikinci.id}, [])
	var tekrar := d.gelisim.duplicate(true)
	KoyluGelisimYoneticisi.gece(y, {d.id: ikinci.id}, [])
	_kontrol(d.gelisim == tekrar and KoyluGelisimYoneticisi.durum(d).xp == 1, "Aynı gece tekrar çağrısı çırakta da XP katlamaz")
	var temiz := KoyluGelisimYoneticisi.oku({"CIFTCI": {"xp": 4, "kademe": 1, "son_gece": 3, "bonus": true}})
	_kontrol(temiz.CIFTCI.xp == 4, "Geçerli JSON sayıları")
	for bozuk in [null, {"CIFTCI": {"xp": 5, "kademe": 1, "son_gece": 3, "bonus": true}}, {"CIFTCI": {"xp": 1.5, "kademe": 1, "son_gece": 3, "bonus": true}}, {"YOK": {}}]:
		_kontrol(KoyluGelisimYoneticisi.oku(bozuk).is_empty(), "Bozuk XP kaydı güvenle temizlenir")
	print("KÖYLÜ GELİŞİMİ: GEÇTİ" if hata == 0 else "KÖYLÜ GELİŞİMİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	# XP fixture, YAP kilidini mevcut kişiye açıkça verilen gerçek bilgiyle karşılar.
	if not y.koylular.is_empty():
		preload("res://src/koy/yapi_bilgisi.gd").ekle(y.koylular[0], PackedStringArray([tur]))
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
