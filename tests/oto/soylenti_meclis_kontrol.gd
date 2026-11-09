## SOY-29/30/33: kapıdan giren söylenti kamuoyu olunca gerçek köy HUD'unda tek satır olur, defterde görünür ve çınar meclisini açar;
## şikâyet satırı kararın adını ve haberi taşıyan köylünün adını taşır.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_soy33.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 3112)
		kayit = GuvenliKayit.new("user://test_soy33_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	o.gun = 5
	o.yonetim.gun = 5
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	var tasiyan := -1
	for i in 15:
		var r := o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
		if i == 0: tasiyan = int(r.get("koylu_id", -1))
	o.gece_sonu()
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	var b := e.hud.find_child("cinar_meclisi", true, false) as Button
	_kontrol(b == null or not b.visible, "Kamuoyu yokken meclis düğmesi görünmez")
	_kontrol(e.hud.find_child("kamuoyu_seridi", true, false) == null, "Kamuoyu yokken HUD satırı yok")
	o.gece_sonu()
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	var serit := e.hud.find_child("kamuoyu_seridi", true, false) as Button
	_kontrol(serit != null and serit.visible and serit.text.contains("Garip bir yolcunun"), "Kamuoyu HUD'da tek satır")
	_kontrol(e.hud.find_children("kamuoyu_seridi", "", true, false).size() == 1, "Satır bir kez")
	if serit != null: serit.pressed.emit()
	await get_tree().process_frame
	var defter := e.get_node_or_null("HafizaDefteriEkrani") as HafizaDefteriEkrani
	_kontrol(defter != null and defter._sayfalar[defter.sayfa] == "soylenti", "Satır defteri Söylenti sayfasında açar")
	if defter != null:
		var sayfa: Array = defter.defter.oku(defter.kaynak).soylenti
		_kontrol(sayfa.size() == SoylentiKoprusu.ag(o).ag_kayitlari.size() and sayfa.size() == 1, "Sayfa ağ kaydıyla eşit")
		_kontrol(_metin(defter).contains("Garip bir yolcunun") and _metin(defter).contains(o.yonetim.koylu(tasiyan).ad), "Satır olayı ve kaynağı gösterir")
		defter.kapat()
		await get_tree().process_frame
	b = e.hud.find_child("cinar_meclisi", true, false) as Button
	_kontrol(b != null and b.visible and not b.disabled, "Kamuoyu konusu meclisi açar")
	if b != null and not b.disabled: b.pressed.emit()
	await get_tree().process_frame
	var satir := e._ust_kart.find_child("meclis_soylenti_sikayeti", true, false) as Label if e._ust_kart != null else null
	var ad := o.yonetim.koylu(tasiyan).ad
	_kontrol(satir != null and satir.text.contains("ret kararı") and satir.text.begins_with(ad + ":"), "Şikâyet kararı ve taşıyanın adını taşır")
	print("SÖYLENTİ MECLİS UI: GEÇTİ" if hata == 0 else "SÖYLENTİ MECLİS UI: KALDI (%d hata)" % hata)
	ana.kayit.sil()
	await Ses.cik(hata)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _metin(n: Node) -> String:
	if n == null: return ""
	var r: String = n.text if n is Label or n is Button else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
