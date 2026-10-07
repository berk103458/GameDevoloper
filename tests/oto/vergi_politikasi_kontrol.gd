extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_tax.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_tax_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	for i in 2:
		var k := y.kabul({"ad": "Vergi mükellefi", "stat": 5})
		k.moral = 50
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	ekran._pazar_ac()
	await get_tree().process_frame
	for secim in [{"ad": "Düşük", "oran": "dusuk"}, {"ad": "Orta", "oran": "orta"}]:
		var d := _dugme(ekran, "Vergi · " + String(secim.ad))
		_kontrol(d != null and not d.disabled, "Diğer oran düğmesi kullanılabilir")
		if d != null: d.pressed.emit()
		await get_tree().process_frame
		_kontrol(y.vergi_orani == secim.oran, "Her düğme kendi oranını seçer")
	var agir := _dugme(ekran, "Vergi · Ağır")
	_kontrol(agir != null and not agir.disabled, "Pazar gerçek ağır vergi düğmesini sunar")
	var once := y.kaydet()
	if agir != null: agir.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.vergi_orani == "agir" and y.akce == int(once.akce) and y.gun == int(once.gun), "UI oranı kaydeder; günü veya kasayı ilerletmez")
	_kontrol(_metin(ekran).contains("Vergi: Ağır · haftalık 4 akçe · Moral -5"), "Pazar seçilen gerçek bedeli ve Moral etkisini gösterir")
	_kontrol(_metin(ekran).contains("Refah -5") and _metin(ekran).contains("Ekonomik Refah: 50/100"), "Pazar hazineden ayrı ekonomik Refahı ve vergi kaybını açıklar")
	var secili := _dugme(ekran, "Vergi · Ağır")
	_kontrol(secili != null and secili.disabled, "Seçili oran yeniden basılamaz")
	await get_tree().create_timer(0.5).timeout
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko08_vergi.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("VERGİ POLİTİKASI UI: GEÇTİ" if hata == 0 else "VERGİ POLİTİKASI UI: KALDI")
	await Ses.cik(hata)
func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children():
		if not c.is_queued_for_deletion(): r += " " + _metin(c)
	return r
func _dugme(n: Node, ad: String) -> Button:
	if n is Button and n.text == ad: return n
	for c in n.get_children():
		if c.is_queued_for_deletion(): continue
		var b := _dugme(c, ad)
		if b != null: return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
