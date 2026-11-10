## OGR-24: gerçek köy ekranında pazar ve divan düğmesi ilk görüşte işaretli ve tek satırlı; basınca işaret kalkar; ikinci açılışta tekrar yanmaz.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_ogr24.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 2404)
		kayit = GuvenliKayit.new("user://test_ogr24_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana._koye_git()
	await get_tree().process_frame
	var e: Control = ana._ekran
	for id in ["pazar", "divan"]:
		var satir := e.find_child("yeni_dugme_satiri_" + id, true, false) as Label
		_kontrol(satir != null and satir.text.length() > 0, "%s: ilk görüşte tek satır" % id)
		_kontrol(e.find_children("yeni_dugme_satiri_" + id, "", true, false).size() == 1, "%s: satır bir kez" % id)
	var divan := e.find_child("divan_ac", true, false) as Button
	var isaret := divan.get_node_or_null("yeni_dugme_isareti") if divan != null else null
	_kontrol(isaret != null and isaret.isaret_sayisi("divan") == 1, "divan: işaret düğmede")
	divan.pressed.emit()
	await get_tree().process_frame
	for n in e.get_tree().root.find_children("DivanEkrani", "", true, false):
		n.queue_free()
	await get_tree().process_frame
	_kontrol(isaret.isaret_sayisi("divan") == 0, "divan: basınca işaret kalkar")
	_kontrol(e.find_child("yeni_dugme_satiri_divan", true, false) == null, "divan: basınca satır kalkar")
	_kontrol(ana.oturum.ipucu_kaydi.goruldu_mu("yeni_dugme_pazar") and ana.oturum.ipucu_kaydi.goruldu_mu("yeni_dugme_divan"), "görüldü bilgisi oturum ipucu kaydında")
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	_kontrol(e.find_child("yeni_dugme_satiri_pazar", true, false) == null, "pazar: ikinci açılışta satır yok")
	var pazar_isaretleri := 0
	for i in e.find_children("yeni_dugme_isareti", "", true, false):
		pazar_isaretleri += i.isaret_sayisi("pazar") + i.isaret_sayisi("divan")
	_kontrol(pazar_isaretleri == 0, "ikinci açılışta işaret 0")
	print("OGR-24 YENİ DÜĞME: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(1 if hata > 0 else 0)


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
