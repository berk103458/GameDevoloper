## AYR-41: gerçek köy ekranında gece raporu üç gece ortalaması 30 fps altındaysa bir kez "Düşük profil?" der; profil değişmez.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_ayr41.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 41)
		kayit = GuvenliKayit.new("user://test_ayr41.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(120.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	var profil: StringName = ana.ayarlar.al(&"grafik_profili")
	var satirlar: Array[bool] = []
	var gece_fps := [60.0, 20.0, 20.0, 20.0, 20.0]
	for gece in gece_fps.size():
		ana._koye_git()
		await get_tree().process_frame
		var koy: Node = ana._ekran
		var olcer := koy.get_node_or_null(NodePath(String(ProfilOnerisiBaglantisi.AD))) as ProfilOnerisiBaglantisi
		if gece == 0:
			for i in 3:
				await get_tree().process_frame
			_kontrol(olcer != null and olcer._sayi > 0, "Köy günü kare hızını kendisi örnekler")
		olcer.set_process(false)
		olcer._toplam = 0.0
		olcer._sayi = 0
		for i in 10:
			olcer.ornek_ekle(gece_fps[gece])
		koy._geceye_gec()
		await get_tree().process_frame
		var satir := koy.find_child(String(ProfilOnerisiBaglantisi.SATIR), true, false) as Label
		satirlar.append(satir != null)
		if satir != null:
			_kontrol(satir.text == "Düşük profil?", "Satır metni metinler.csv'den")
	_kontrol(satirlar == [false, false, false, true, false], "Öneri yalnız üç gece ortalaması 30 altına inince bir kez (%s)" % [satirlar])
	_kontrol(ana.ayarlar.al(&"grafik_profili") == profil, "grafik_profili kendiliğinden değişmez")
	get_tree().quit(1 if hata > 0 else 0)


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)
