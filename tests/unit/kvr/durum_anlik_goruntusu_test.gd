extends SceneTree
var hata := 0
func _initialize() -> void:
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 123)
	o.yonetim.kabul({"ad": "Köylü", "sinif": "ciftci"})
	o.yonetim._rng.state = 723456789123456789
	o.yonetim.sur_seviye = 2
	o.yonetim.sur_hasar = 50
	o.muhafiz_akce = 19
	for cy in o.yonetim.a.izgara_boyut.y:
		if not o.yonetim.binalar.is_empty(): break
		for cx in o.yonetim.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if o.yonetim.yerlesim("tarla", h)["olur"]:
				var d := o.yonetim.bina_kur("tarla", h)
				var bina := o.yonetim.bina(d["id"])
				bina.insa_kalan = 0
				bina.seviye = 2
				o.yonetim.ata(o.yonetim.koylular[0].id, bina.id)
				break
	_kontrol(not o.yonetim.binalar.is_empty(), "Snapshot gerçek seviyeli/atanmış bina içerir")
	o._gemini = [{"metin": "Test", "sorular": []}]
	var arac := DurumAnlikGoruntusu.new()
	arac.slot = GuvenliKayit.new("user://test_snapshot_unit.json")
	arac.slot.sil()
	_kontrol(not arac.oku(k)["ok"], "Eksik snapshot sessiz reddedilir")
	_kontrol(arac.al(o)["ok"], "Geçici snapshot yazılır")
	var r := arac.oku(k)
	_kontrol(r["ok"], "Snapshot yeniden okunur")
	var geri: Oturum = r["oturum"]
	_kontrol(geri.yonetim._rng.state == o.yonetim._rng.state, "64-bit köy RNG JSON'da kayıpsız")
	_kontrol(geri.muhafiz_akce == 19 and geri.yonetim.sur_hasar == 50 and geri._gemini == o._gemini, "Model ve diyalog cache korunur")
	_kontrol(geri.kaydet() == o.kaydet(), "Tam model sözlüğü JSON sonrası eşleşir")
	var once := o.kaydet()
	for i in 4:
		var a := o.gece_sonu()
		var b := geri.gece_sonu()
		_kontrol(a["rapor"] == b["rapor"] and a["son"] == b["son"] and o.kaydet() == geri.kaydet(), "Sonraki gece/RNG tekrarları eşleşir")
	var dosya := FileAccess.open(arac.slot.yol, FileAccess.WRITE)
	dosya.store_string("{bozuk")
	dosya.close()
	_kontrol(not arac.oku(k)["ok"], "Bozuk slot mevcut modelden bağımsız reddedilir")
	# Gerçek yedek oluştur; ana bozulduğunda atomik kayıt geri dönebilmeli.
	_kontrol(arac.slot.yaz(once) and arac.al(Oturum.kayittan(k, once))["ok"], "Yedekli snapshot yazılır")
	dosya = FileAccess.open(arac.slot.yol, FileAccess.WRITE)
	dosya.store_string("{bozuk")
	dosya.close()
	# İlk yedek normal kayıt olduğundan snapshot değil: etiket kontrolü bunu reddeder.
	_kontrol(not arac.oku(k)["ok"], "Snapshot etiketi olmayan yedek reddedilir")
	_kontrol(arac.al(Oturum.kayittan(k, once))["ok"] and arac.al(Oturum.kayittan(k, once))["ok"], "İki geçerli snapshot yedek oluşturur")
	dosya = FileAccess.open(arac.slot.yol, FileAccess.WRITE)
	dosya.store_string("{bozuk")
	dosya.close()
	var yedek := arac.oku(k)
	_kontrol(yedek["ok"] and yedek["yedekten"] and yedek["oturum"].kaydet() == once, "Bozuk ana snapshot geçerli yedeğe döner")
	arac.slot.sil()
	var eski := once.duplicate(true)
	eski["koy_yonetimi"]["rng"] = 456
	_kontrol(Oturum.kayittan(k, eski).yonetim._rng.state == 456, "Eski sayısal RNG kaydı okunur")
	for g in [o._adli_gelen(&"chr_015"), o._adli_gelen(&"aydogdu")]:
		g.heybe = Heybe.new()
		g.heybe.ekle("test", "mal", 7, 3, true)
		g.heybe.astar_yokla()
		g.heybe.esyalar[0]["alinan"] = 2
		g.acik_bayraklar.append("hasta")
		var s := g.chr_sorgusu() as ChrSorgusu
		if s != null:
			s.tansiyon = 9
			s.bayraklar["Flag_Kilitlendi"] = true
			s._ipucu_servisi.kaydet(&"Clue_Test")
			s._denemeler["00:1"] = true
			s._rng.state = 723456789123456789
			s._son_konusulan = s.dugum_id
		var veri: Dictionary = JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(g)))
		var gelen := KapiAnlikGoruntusu.gelen_yukle(veri, k)
		_kontrol(gelen != null and gelen != g and KapiAnlikGoruntusu.gelen_kaydet(gelen) == KapiAnlikGoruntusu.gelen_kaydet(g), "CHR/legacy heybe ve sorgu alanları kayıpsız, ayrı nesnede")
		gelen.heybe.esyalar[0]["alinan"] = 0
		_kontrol(g.heybe.esyalar[0]["alinan"] == 2, "Restore heybesi eski ziyaretin verisini paylaşmaz")
		if s != null:
			var yeni := gelen.chr_sorgusu() as ChrSorgusu
			_kontrol(yeni._rng.randf() == s._rng.randf() and yeni.ipuclari.has(&"Clue_Test") and not yeni.replik_baslat(), "İpucu, zar ve tek replik koruması geri yüklenir")
	print("DURUM SNAPSHOT: GEÇTİ" if hata == 0 else "DURUM SNAPSHOT: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
