extends "res://tests/unit/kapi/kapi_kavgasi_ekran_test.gd"
const A = preload("res://src/soz/yemin_adaptoru.gd")
func _calistir() -> void:
	await get_tree().process_frame
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	if await _ekran() != true: hata += 1
	print("YEMIN EKRAN: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(1 if hata > 0 else 0)
func dene(v: bool, metin: String) -> void:
	if not v:
		hata += 1
		push_error(metin)
func _ekran() -> bool:
	var ana := TestAna.new()
	add_child(ana)
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	await get_tree().process_frame
	for sinif in ["ciftci", "esnaf", "asker", "dervis", "bos", "chr"]:
		var g := Gelen.new() if sinif != "chr" else ana.oturum._adli_gelen(&"chr_001")
		if sinif != "chr": g.sinif = &"ciftci" if sinif == "bos" else StringName(sinif)
		g.ad_anahtari = "sablon.esnaf.ad1"
		g.heybe = Heybe.new()
		g.secenekler = PackedStringArray(["kabul", "ret"])
		if sinif != "bos": A.veri_isle(g)
		e._gelen = g
		e._sohbet_goster()
		await get_tree().process_frame
		var b := e._eylemler.get_node_or_null("YeminEt") as Button
		if sinif == "bos":
			dene(b == null, "Boş inanç: sıfır düğme")
			continue
		dene(b != null and b.text == tr("arayuz.kapi.yemin_et"), "Gerçek kapıda yemin düğmesi: " + sinif)
		dene(e._eylemler.get_node_or_null("YeminNesnesi") != null, "Kutu+etiket oyunda")
		if b == null: return false
		var once := ana.oturum.soz_kaydi.yeminler.size()
		b.pressed.emit()
		b.pressed.emit()
		await get_tree().process_frame
		dene(ana.oturum.soz_kaydi.yeminler.size() == once + 1 and not A.uygun(g), "Çift tık tek yemin")
		dene(e._eylemler.get_node_or_null("YeminEt") == null, "Yenilenen ekranda düğme yok")
		var s = g.chr_sorgusu()
		dene(ana.oturum.soz_kaydi.motor.zar == -1 and (s == null or s.son_zar.is_empty()), "Ekrandan da zar açılmaz")
		if sinif == "chr":
			s.bayraklar["Flag_Sir_Tamamen_Cozuldu"] = true
			e._sohbet_goster()
			await get_tree().process_frame
			dene(e._kayit.get_parsed_text().contains(tr("anlati.yemin.sir_acik")) and not e._kayit.get_parsed_text().contains(tr("anlati.yemin.rahat")), "Sır açıldıktan sonra önceki yemin satırı değiştirilir")
	var yanlis := Gelen.new()
	yanlis.heybe = Heybe.new()
	A.veri_isle(yanlis)
	e._gelen = yanlis
	e._sohbet_goster()
	await get_tree().process_frame
	var secim := e._eylemler.find_child("YeminSekli", true, false) as OptionButton
	dene(secim != null, "Şekil seçimi gerçek ekranda")
	if secim != null:
		secim.select(A.TABLO.sekiller.keys().find("hristiyan"))
		var once := ana.oturum.grup_itibari.deger("koylu")
		(e._eylemler.get_node("YeminEt") as Button).pressed.emit()
		dene(ana.oturum.grup_itibari.deger("koylu") == once - 1 and e._kayit.get_parsed_text().contains(tr("anlati.yemin.hakaret")), "Yanlış şekil gerçek düğmeden hakaret cezasına gider")
	ana.queue_free()
	await get_tree().process_frame
	return true
