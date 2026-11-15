## DYL-01 gercek KapiEkrani + BeyanDefteriPaneli UI kabul testi.
extends Node

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(15.0).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	o.gun = 4
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	var sorgu := g.chr_sorgusu()
	_dene(sorgu != null, "celiski_goster_kontrol: chr_001 ChrSorgusu null")

	var ayarlar := Ayarlar.new()
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.theme = Tema.olustur(ayarlar)
	add_child(kok)
	var ekran := KapiEkrani.new()
	ekran.oturum = o
	ekran.ayarlar = ayarlar
	kok.add_child(ekran)
	ekran._gelen = g
	ekran._ad.text = "Rüstem oğlu Hamza"
	ekran._sohbet_goster()
	await get_tree().process_frame

	var dpanel := ekran._secenekler.get_child(0)
	_dene(not dpanel.has_node("Secenek2"), "celiski_goster_kontrol: Gun 4 hazir Secenek2 gizlenmeli")
	var b_dugme := ekran._eylemler.get_node_or_null("BeyanDefteriDugmesi") as Button
	_dene(b_dugme != null, "celiski_goster_kontrol: BeyanDefteriDugmesi yok")
	_dene(b_dugme != null and not b_dugme.visible, "celiski_goster_kontrol: OGR-14 ilk celiski oncesi BeyanDefteriDugmesi gizli olmali")
	sorgu.gorsel_incele()
	await get_tree().process_frame
	_dene(b_dugme != null and b_dugme.visible, "celiski_goster_kontrol: OGR-14 ilk celiskiden sonra BeyanDefteriDugmesi acilmali")
	_dene(DefterTanitimi.celiski_goruldu_mu(o), "celiski_goster_kontrol: OGR-14 oturumda ilk celiski isaretlenmeli")
	_dene(not bool(DefterTanitimi.ipucu_ver(o).get("ipucu_goster", true)), "celiski_goster_kontrol: OGR-14 ipucu yalniz bir kez verilmeli")
	if b_dugme != null:
		b_dugme.pressed.emit()
		await get_tree().process_frame
		var bpanel := ekran.get_node_or_null("BeyanDefteriPaneli") as BeyanDefteriPaneli
		_dene(bpanel != null, "celiski_goster_kontrol: BeyanDefteriPaneli acilmadi")
		if bpanel != null:
			var ip_id := String(sorgu.karakter.gorsel_hata_ipucu)
			bpanel.kayit_sec_kimlikle("beyan_00")
			bpanel.kayit_sec_kimlikle(ip_id)
			var sonuc := bpanel.goster_bas()
			await get_tree().process_frame
			_dene(bool(sonuc.get("basarili", false)) and sorgu.dugum_id == &"3.1", "celiski_goster_kontrol: 3.1 dalina gecmedi")
	kok.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.4).timeout
	print("CELISKI GOSTER UI: GEÇTİ" if _hata == 0 else "CELISKI GOSTER UI: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
