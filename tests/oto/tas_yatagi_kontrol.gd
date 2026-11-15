extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_stone.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 21)
		kayit = GuvenliKayit.new("user://test_stone_ui.json")
		theme = Tema.olustur(ayarlar)

var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var k := y.kabul({"ad": "Kazıcı", "sinif": "tasci", "stat": 5})
	ana._koye_git()
	var ekran: KoyEkrani = _ekran(ana)
	await get_tree().process_frame
	var kart: Node = ekran.hud._stok_etiketleri["tas"]
	var bilgi: HBoxContainer = kart.get_child(0).get_node("TasYatagiBilgisi")
	_kontrol(bilgi.get_node("Bilgi").text == "Taş yatağı: 20 taştan 20 kaldı", "Gerçek taş kartındaki bilgi CSV'den okunur")
	var obek: Node3D = _obek(ekran)
	_kontrol(obek != null and obek.get_node_or_null("tas_yatagi") != null and not obek.find_children("*", "MeshInstance3D", true, false).is_empty(), "Gerçek sahnede taş yatağı 3B modeli")
	var kazi: Button = bilgi.get_node("Kazi")
	_kontrol(not kazi.disabled, "İşçi ve taş varsa gerçek kazı düğmesi açık")
	kazi.pressed.emit()
	_kontrol(k.is_yeri == TasYatagi.IS_YERI, "Gerçek düğme işçi atar")
	await get_tree().process_frame
	var hareket := ekran.sahne3b.halk_hareketi
	hareket._planla(k.id)
	_kontrol(hareket._durum[k.id].bak.is_equal_approx(ekran.sahne3b.alan_merkezi(y.tas_yatagi.hucre, Vector2i.ONE)), "Kazıcının mevcut rota hedefi taş yatağıdır")
	bilgi.get_node("Birak").pressed.emit()
	_kontrol(k.is_yeri == KoyYonetimi.BOSTA, "Gerçek bırak düğmesi işçiyi boşa çıkarır")
	kazi.pressed.emit()
	for i in 5: y.gece()
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(kazi.disabled and bilgi.get_node("Bilgi").text == "Taş yatağı: 20 taştan 0 kaldı", "Tükenince gerçek kazı düğmesi kapanır ve bilgi 0")
	_kontrol(kart.get_child(0).get_node("TasYatagiBilgisi") == bilgi, "Yenilemeler ikinci kaynak/atama paneli oluşturmaz")
	y.kaynaklar.azalt("tas", 100)
	y.kaynaklar.azalt("odun", 100)
	ekran._geceye_gec()
	await get_tree().process_frame
	_kontrol(y.tas_yatagi.kalan == 10 and y.tas_yatagi.kurtarici_sayisi == 1, "Gerçek UI gece geçişi sabah kurtarıcıyı ekler")
	_kontrol(_satir_adedi(ekran._ust_kart, "Köy kenarında 10 taşlık yeni bir taş yatağı bulundu.") == 1, "Gerçek gece/sabah raporunda tek kurtarıcı satırı")
	_kontrol(bilgi.get_node("Bilgi").text == "Taş yatağı: 10 taştan 10 kaldı" and not kazi.disabled, "Kurtarıcı kartı günceller ve kazıyı açar")
	# Optional alan olmayan eski kayıt aynı gerçek ekranda görünmez.
	var v: Dictionary = ana.oturum.kaydet()
	v.koy_yonetimi.erase("tas_yatagi")
	ana.oturum = Oturum.kayittan(ana.katalog, JSON.parse_string(JSON.stringify(v)))
	ana._koye_git()
	await get_tree().process_frame
	ekran = _ekran(ana)
	kart = ekran.hud._stok_etiketleri["tas"]
	bilgi = kart.get_child(0).get_node("TasYatagiBilgisi")
	_kontrol(not bilgi.visible and _obek(ekran) == null, "Eski kayıt UI'sında yatak ve kazı görünmez")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("TAŞ YATAĞI UI: GEÇTİ" if hata == 0 else "TAŞ YATAĞI UI: KALDI")
	await Ses.cik(hata)

func _ekran(ana: Node) -> KoyEkrani:
	for c in ana.get_children():
		if c is KoyEkrani and not c.is_queued_for_deletion(): return c
	return null

func _obek(ekran: KoyEkrani) -> Node3D:
	for c in ekran.sahne3b._yapilar.get_children():
		if c.has_meta("tas_yatagi") and not c.is_queued_for_deletion(): return c
	return null

func _satir_adedi(n: Node, metin: String) -> int:
	if n == null: return 0
	var adet := 1 if n is Label and n.text == metin else 0
	for c in n.get_children():
		if not c.is_queued_for_deletion(): adet += _satir_adedi(c, metin)
	return adet

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
