extends Node
## ACL-04 ilk aile kapı sahnesi: eş ipucu ayrı konuşmacıdır, refakatçi gerçek modelle durur,
## oyuncu sürümünde yer tutucu etiketi görünmez, ilk aileye özel sorular listededir.
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_ilk_aile.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 71)
		kayit = GuvenliKayit.new("user://test_ilk_aile.json")
		theme = Tema.olustur(ayarlar)
const ACILIS = preload("res://src/sistemler/kapi_acilis_olayi.gd")
var hata := 0


func _ready() -> void:
	get_tree().create_timer(120.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(o)
	o.gun = 0
	ACILIS.baslat(o)
	ACILIS.ulak_bitir(o)
	_kontrol(ACILIS.aile_bekliyor(o), "İlk aile kapıda bekliyor")
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	await _kare(3)
	e._kuyruk = o.gece_kuyrugu()
	e.evre = &"bekle"
	e._siradaki()
	var bas := Time.get_ticks_msec()
	while e.evre != &"sohbet" and e.evre != &"karar" and Time.get_ticks_msec() - bas < 15000:
		await get_tree().process_frame
	await _kare(3)
	var metin := e._kayit.get_parsed_text()
	var aile_adi := tr(String(ACILIS.AYAR.aile_adi))
	var es := tr(String(ACILIS.AYAR.es_sozu))
	_kontrol(not metin.contains(aile_adi + ": " + es) and not metin.contains(aile_adi + ": Eşin"), "Eş ipucu ziyaretçi repliği olarak yazılmıyor")
	_kontrol(metin.contains(tr("arayuz.kapi.es_ipucu")) and metin.contains(es.trim_prefix("Eşin: ")), "Eş ipucu ayrı konuşmacıyla yazılıyor")
	_kontrol(metin.contains(aile_adi + ": " + tr(String(ACILIS.AYAR.acilis))), "Ziyaretçinin kendi açılış repliği yazılıyor")
	var grup := e.sahne._gelen.get_node_or_null("AileRefakatcileri")
	_kontrol(grup != null and grup.get_child_count() == 1, "Zeynep refakatçi olarak sahnede")
	if grup != null and grup.get_child_count() > 0:
		var z := grup.get_child(0)
		_kontrol(z is KarakterModel and z.find_children("*", "Skeleton3D", true, false).size() > 0, "Zeynep kutu değil, iskeletli kadın modeli")
	var etiketler := e.sahne.find_children("*", "Label3D", true, false)
	var yer_tutucu := etiketler.filter(func(l: Label3D) -> bool: return l.visible and l.text.contains("yer tutucu"))
	_kontrol(yer_tutucu.is_empty(), "Oyuncu sürümünde görünür yer tutucu etiketi yok")
	var sorular := PackedStringArray()
	for b in e._secenekler.find_children("*", "Button", true, false):
		sorular.append((b as Button).text)
	var hepsi := " | ".join(sorular)
	print("Sorular: ", hepsi)
	var ozel := 0
	for s: Array in [ACILIS.AYAR.selam] + ACILIS.AYAR.ek_sorular:
		if hepsi.contains(tr(String(s[0]))):
			ozel += 1
	_kontrol(ozel == 3, "Selam ve ilk aileye özel iki soru açılışta listede")
	var es_model := e.sahne.get_node_or_null("IlkAileEs") as Node3D
	var es_etiket := es_model.get_node_or_null("acilis_hane_etiketi") as Label3D if es_model != null else null
	_kontrol(es_etiket != null and es_etiket.has_node("EtiketEkranSiniri"), "Eş etiketi ekran sınırına bağlı")
	if es_etiket != null and es_etiket.has_node("EtiketEkranSiniri"):
		var kam: Camera3D = e.sahne.kamera
		es_model.global_position -= kam.global_transform.basis.x * 12.0
		var sinir := es_etiket.get_node("EtiketEkranSiniri") as EtiketEkranSiniri
		sinir.sinirla()
		var x := kam.unproject_position(es_etiket.global_position).x
		var yari := sinir.yari_genislik()
		_kontrol(x - yari >= 0.0 and x + yari <= e.get_viewport().get_visible_rect().size.x, "Sol kenara itilen eş etiketi ekran içinde kalır")
	get_tree().quit(1 if hata > 0 else 0)


func _kare(n: int) -> void:
	for i in n:
		await get_tree().process_frame


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)
