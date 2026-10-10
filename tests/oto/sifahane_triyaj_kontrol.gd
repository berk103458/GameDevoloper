## KRI-13 gerçek akış: hekimli Şifahane → yataklar dolu → açıkta hastalar → gerçek gece raporu, triyaj, moral çöküşü → kayıt.
extends Node
const TRIYAJ = preload("res://src/koy/sifahane_triyaj.gd")
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri13.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 1313)
		kayit = GuvenliKayit.new("user://test_kri13_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 200, "odun": 200, "tas": 200, "kereste": 200, "su": 100})
	y.akce = 200
	var hekim := y.koylu(o.karar_ver(o._adli_gelen(&"chr_008"), &"kabul").koylu_id)
	var sif := _kur(y, "sifahane")
	y.ata(hekim.id, sif.id)
	for i in TRIYAJ.yatak(y): KarantinaYoneticisi.al(y, y.kabul({"ad": "Yatakta %d" % i}).id)
	var hastalar: Array[Koylu] = []
	for s in [75, 35, 55]:
		var k := y.kabul({"ad": "Hasta %d" % s})
		k.saglik = s
		k.moral = 60
		SaglikYoneticisi.enfekte(y, k, "humma")
		k.enfeksiyon.bitis = y.gun + 4
		k.bayrak_ac("hasta")
		hastalar.append(k)
	ana._koye_git()
	await get_tree().process_frame
	var e: Node = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	var metin := _metin(e._ust_kart)
	_kontrol(metin.contains("Şifahane dolu") and metin.contains("Hasta 75"), "Gerçek gece raporunda yatak çöküşü satırı")
	_kontrol(not SaglikYoneticisi.hasta(hastalar[1]), "Triyaj: en ağır hasta (35) tedavi edildi")
	_kontrol(SaglikYoneticisi.hasta(hastalar[0]) and hastalar[0].moral < 60, "Bekleyen hasta + moral çöküşü")
	_kontrol(not metin.contains("chr_") and not metin.contains("Clue_"), "Sızıntı yok")
	_kontrol(ana.kayit.yaz(o.kaydet()), "GuvenliKayit yazımı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri != null and geri.yonetim.koylu(hastalar[0].id).saglik == hastalar[0].saglik, "Kayıt sağlığı taşır")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("SIFAHANE TRIYAJ UI: GEÇTİ" if hata == 0 else "SIFAHANE TRIYAJ UI: KALDI")
	await Ses.cik(hata)

func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null

func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
