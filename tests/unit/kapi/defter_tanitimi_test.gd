## OGR-14: Beyan defteri ilk çelişkide tanıtılır — gerçek KapiEkrani + ChrKapiAdaptoru kabul testi.
extends Node

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(15.0).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	o.gun = 4
	var ayarlar := Ayarlar.new()
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.theme = Tema.olustur(ayarlar)
	add_child(kok)

	var ekran := KapiEkrani.new()
	ekran.oturum = o
	ekran.ayarlar = ayarlar
	kok.add_child(ekran)

	# 1) Çelişkisiz 3 ziyaret sonrası düğme 0 ve ipucu 0
	for ziyaret in range(3):
		var g_temiz := o._adli_gelen(&"chr_001")
		g_temiz.heybe = Heybe.new()
		ekran._gelen = g_temiz
		ekran._ad.text = "Ziyaret %d" % (ziyaret + 1)
		ekran._sohbet_goster()
		await get_tree().process_frame
		_dene(
			ekran._eylemler.get_node_or_null("BeyanDefteriDugmesi") == null,
			"OGR-14: celiskisiz ziyaret %d dugme 0 olmali" % (ziyaret + 1)
		)
		_dene(
			ekran.get_node_or_null("IpucuSeridi") == null,
			"OGR-14: celiskisiz ziyaret %d ipucu 0 olmali" % (ziyaret + 1)
		)

	# 2) İlk çelişki oluşunca düğme 1 ve ipucu 1 kez
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	var sorgu := g.chr_sorgusu()
	_dene(sorgu != null, "OGR-14: chr_001 sorgusu null olmamali")
	ekran._gelen = g
	ekran._ad.text = "Rüstem oğlu Hamza"
	ekran._sohbet_goster()
	await get_tree().process_frame
	_dene(ekran._eylemler.get_node_or_null("BeyanDefteriDugmesi") == null, "OGR-14: ilk celiski oncesi dugme 0 olmali")

	sorgu.gorsel_incele()
	await get_tree().process_frame
	_dene(ekran._eylemler.get_node_or_null("BeyanDefteriDugmesi") != null, "OGR-14: ilk celiski sonrasi dugme 1 olmali")
	_dene(ekran.get_node_or_null("IpucuSeridi") != null, "OGR-14: ilk celiskide ipucu seridi gosterilmeli")
	_dene(o.ipucu_kaydi.goruldu_mu("beyan_defteri"), "OGR-14: ipucu_kaydi beyan_defteri isaretli olmali")
	_dene(not bool(DefterTanitimi.ipucu_ver(o).get("ipucu_goster", true)), "OGR-14: ipucu ikinci kez verilmemeli")

	# 3) Sonraki ziyarette düğme görünür kalır, yeni ipucu çıkmaz
	var eski_serit := ekran.get_node_or_null("IpucuSeridi")
	if eski_serit != null:
		eski_serit.queue_free()
		await get_tree().process_frame
	var g2 := o._adli_gelen(&"chr_001")
	g2.heybe = Heybe.new()
	ekran._gelen = g2
	ekran._sohbet_goster()
	await get_tree().process_frame
	_dene(ekran._eylemler.get_node_or_null("BeyanDefteriDugmesi") != null, "OGR-14: sonraki ziyarette dugme gorunur kalmali")
	_dene(ekran.get_node_or_null("IpucuSeridi") == null, "OGR-14: sonraki ziyarette ipucu tekrar cikmamali")

	# 4) Kademeli HUD kapalıyken çelişkisiz yeni oturumda düğme doğrudan açık
	var o_deneyimli := Oturum.new(katalog, 85)
	o_deneyimli.gun = 4
	AyarlarEk.ayarla(ayarlar, &"kademeli_hud", false)
	ekran.oturum = o_deneyimli
	var g3 := o_deneyimli._adli_gelen(&"chr_001")
	g3.heybe = Heybe.new()
	ekran._gelen = g3
	ekran._sohbet_goster()
	await get_tree().process_frame
	_dene(ekran._eylemler.get_node_or_null("BeyanDefteriDugmesi") != null, "OGR-14: kademeli_hud kapaliyken dugme gorunmeli")

	if _hata == 0:
		print("DEFTER TANITIMI TESTI: GEÇTİ (0 hata)")
	else:
		print("DEFTER TANITIMI TESTI: KALDI (%d hata)" % _hata)
	get_tree().quit(_hata)


func _dene(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error(mesaj)
