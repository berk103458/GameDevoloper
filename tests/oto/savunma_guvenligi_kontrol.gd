extends Node
const FORMUL = preload("res://src/koy/savunma_guvenligi.gd")

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_har15.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 1916)
		kayit = GuvenliKayit.new("user://test_har15_ui.json")
		theme = Tema.olustur(ayarlar)

func sec(e: KoyEkrani, rol: String) -> Button:
	for b in e.find_children("*", "Button", true, false):
		if not b.is_queued_for_deletion() and b.has_meta("konuslanma") and b.get_meta("konuslanma") == rol: return b
	return null

func bilgi(e: KoyEkrani) -> String:
	for n in e.find_children("savunma_guvenligi_bilgisi", "Label", true, false):
		if not n.is_queued_for_deletion() and n.is_visible_in_tree(): return n.text
	return ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(55).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.agalik = true
	y.sur_seviye = 1
	y.asayis_riski = 24
	var k := y.kabul({"ad": "HAR15 nöbetçisi", "sinif": "asker", "stat": 5})
	k.saglik = 100
	k.moral = 100
	assert(y.muhafiz_ata(k.id))
	var once := JSON.stringify(o.kaydet().merged({"faz": "koy"}, true))
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	KoyluKarti.ac(e, k.id)
	assert(bilgi(e).contains("Güvenlik 77/100") and bilgi(e).contains("+1"))
	assert(o.gosterge(3) == 7 and GuvenlikKafileDengesi.sinif_agirliklar(o)[1] == 1.0)
	assert(sec(e, "kapi") != null and not sec(e, "kapi").disabled)
	sec(e, "kapi").pressed.emit()
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 79/100") and FORMUL.katkisi(y) == 3)
	sec(e, "sur").pressed.emit()
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 80/100") and bilgi(e).contains("+4"))
	assert(o.gosterge(3) == 8 and GuvenlikKafileDengesi.sinif_agirliklar(o)[1] == 2.0)
	# Aynı gerçek UI modeli/rotası surda; yeni NPC veya paralel HUD yok.
	var h := e.sahne3b.halk_hareketi
	h.set_process(false)
	h._process(0.0)
	assert(h._durum[k.id].devriye_ad == "Sur okçusu" and h.modeller.size() == y.koylular.size())
	assert(ana.kayit.yaz(o.kaydet()))
	var yuk := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	assert(yuk.gosterge(3) == 8 and FORMUL.katkisi(yuk.yonetim) == 4)
	sec(e, "").pressed.emit()
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 77/100") and o.gosterge(3) == 7)
	assert(JSON.stringify(o.kaydet()) == once)
	# Sağlık ve zindan değişiminde kartı yeniden açınca canlı skor görülür.
	sec(e, "sur").pressed.emit()
	await get_tree().process_frame
	k.saglik = 75
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 77/100") and FORMUL.katkisi(y) == 1)
	k.saglik = 100
	k.bayraklar.append("agir_yarali")
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 76/100") and FORMUL.katkisi(y) == 0)
	k.bayraklar.erase("agir_yarali")
	k.bayraklar.append("zindanda")
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 76/100"))
	k.bayraklar.erase("zindanda")
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 80/100"))
	# Gerçek pazar kiralama düğmesi de aynı Güvenlik hesabını gösterir.
	y.akce = 1000
	y.kaynaklar.kapasite = 10000
	for tur in ["odun", "tas", "kereste", "gida", "alet"]: y.kaynaklar.ekle(tur, 100)
	var kisla := kur(y)
	assert(y.ata(k.id, kisla.id))
	y.gun = 3
	e._pazar_ac()
	await get_tree().process_frame
	var kirala := e.find_child("kervan_koruma_" + str(k.id), true, false) as Button
	assert(kirala != null and not kirala.disabled)
	kirala.pressed.emit()
	await get_tree().process_frame
	assert(FORMUL.katkisi(y) == 0 and KervanKorumasi.guvenlik(y) == 71)
	var pazar := false
	for n in e.find_children("*", "Label", true, false):
		if n.is_visible_in_tree() and n.text.contains("Güvenlik 71."): pazar = true
	assert(pazar)
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 71/100"))
	y.gun = 6
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	assert(bilgi(e).contains("Güvenlik 80/100"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("SAVUNMA GUVENLIGI UI: GEÇTİ")
	await Ses.cik(0)

func kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("muhafiz_kislasi", h).olur:
				var b := y.bina(y.bina_kur("muhafiz_kislasi", h).id)
				b.insa_kalan = 0
				return b
	assert(false)
	return null
