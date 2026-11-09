## Gerçek köy UI'sında 2x hız ve yinelenen gece girdisi; kayıt dosyalarına yazmaz.
extends Node

var _hata := 0

func _ready() -> void:
	get_tree().create_timer(20.0).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()
	var ekran := KoyEkrani.new()
	ekran.oturum = Oturum.new(katalog, 55)
	for i in 3:
		ekran.oturum.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci", "stat": 5})
	ekran.ayarlar = Ayarlar.new()
	ekran.theme = Tema.olustur(ekran.ayarlar)
	add_child(ekran)
	var gun_once := ekran.oturum.gun
	ekran._hiz_sec(2)
	_dene(Engine.time_scale == 2.0, "gece_gecis_kontrol.gd:17")
	ekran._gece_dugmesi.pressed.emit()
	_dene(ekran.oturum.gun == gun_once + 1 and ekran._gece_dugmesi.disabled, "gece_gecis_kontrol.gd:19")
	_dene(Engine.time_scale == 1.0 and not get_tree().paused, "gece_gecis_kontrol.gd:20")
	var ilk_kayit := JSON.stringify(ekran.oturum.kaydet())
	var ilk_kart := ekran._ust_kart
	_dene(ilk_kart.find_child("kisa_ilk_saat_ozeti", true, false) == null, "gece_gecis_kontrol.gd:23")
	# Fiziksel disabled düğmenin dışında, sinyal/metot çağrısı da ikinci tüketim yapamaz.
	ekran._gece_dugmesi.pressed.emit()
	ekran._geceye_gec()
	_dene(JSON.stringify(ekran.oturum.kaydet()) == ilk_kayit and ekran._ust_kart == ilk_kart, "gece_gecis_kontrol.gd:27")
	ekran._hiz_sec(3)
	ekran._hiz_sec(0)
	_dene(Engine.time_scale == 1.0 and not get_tree().paused, "gece_gecis_kontrol.gd:30")
	var yeni_kilit := preload("res://src/sistemler/gece_gecis_kilidi.gd").new()
	_dene(yeni_kilit.al() and not yeni_kilit.al(), "gece_gecis_kontrol.gd:32")
	ekran.queue_free()
	await get_tree().process_frame
	var ozet_ekrani := KoyEkrani.new()
	ozet_ekrani.oturum = Oturum.new(katalog, 55)
	ozet_ekrani.oturum.gun = 5
	ozet_ekrani.oturum.ziyaret_basladi(Gelen.new())
	ozet_ekrani.ayarlar = Ayarlar.new()
	ozet_ekrani.theme = Tema.olustur(ozet_ekrani.ayarlar)
	add_child(ozet_ekrani)
	ozet_ekrani._gece_dugmesi.pressed.emit()
	var ozetler := ozet_ekrani._ust_kart.find_children("kisa_ilk_saat_ozeti", "Label", true, false)
	_dene(ozetler.size() == 1, "gece_gecis_kontrol.gd:44")
	var beklenen := tr("koy.rapor.kisa.ilk_saat_ozeti") % ["1", 0, 0, ozet_ekrani.oturum.yonetim.nufus()]
	_dene(ozetler[0].text == beklenen, "gece_gecis_kontrol.gd:46")
	ozet_ekrani.queue_free()
	await get_tree().process_frame
	await Ses.sustur()
	print("GECE GEÇİŞİ: GEÇTİ" if _hata == 0 else "GECE GEÇİŞİ: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
