## KRI-12 gerçek akış: köy ekranı → erzak eşik altı gece → rapor satırı + sağlık kaybı → kayıt → sabah → tok gece etkisiz.
extends Node
const ACLIK = preload("res://src/koy/aclik_saglik.gd")
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri12.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 1212)
		kayit = GuvenliKayit.new("user://test_kri12_ui.json")
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
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 2, "odun": 100, "su": 100})
	y.akce = 200
	var k := y.kabul({"ad": "Aç komşu"})
	k.saglik = 80
	ana._koye_git()
	await get_tree().process_frame
	var e: Node = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	var metin := _metin(e._ust_kart)
	_kontrol(metin.contains("Açlık ve hastalık") and metin.contains("2 erzak") and metin.contains("×2"), "Gerçek gece raporunda açlık–sağlık satırı")
	_kontrol(k.saglik < 80, "Gerçek gecede sağlık düştü")
	_kontrol(ana.kayit.yaz(o.kaydet()), "GuvenliKayit yazımı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri != null and geri.yonetim.koylu(k.id).saglik == k.saglik and not ACLIK.aktif(geri.yonetim), "Kayıt sağlığı taşır, gece fotoğrafını taşımaz")
	await _sabah(ana, e)
	e = ana._ekran
	y.kaynaklar.ekle("gida", 50)
	var once := k.saglik
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(not _metin(e._ust_kart).contains("Açlık ve hastalık") and k.saglik >= once, "Erzak dolunca etki ve rapor satırı yok")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("ACLIK SAGLIK UI: GEÇTİ" if hata == 0 else "ACLIK SAGLIK UI: KALDI")
	await Ses.cik(hata)

func _sabah(ana: Node, e: Node) -> void:
	var b := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(b != null and not b.disabled, "Gerçek sabah düğmesi")
	if b == null: return
	b.pressed.emit()
	await get_tree().process_frame
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame

func _dugme(n: Node, metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null

func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
