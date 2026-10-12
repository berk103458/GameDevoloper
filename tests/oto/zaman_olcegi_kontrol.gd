## TEK-22: sahne çıkışı hızı sıfırlar (time_scale 1, paused false, fizik adımı geri).
## TEK-24: divan (divan_ekrani_kontrol ile ortak) ve Çınar meclisi paneli hızı geri verir.
extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_zaman_olcegi.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 641)
		kayit = GuvenliKayit.new("user://test_zaman_olcegi_ui.json")
		theme = Tema.olustur(ayarlar)

var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	await _sahne_cikisi()
	await _bos_gun_ve_defter()
	print("ZAMAN ÖLÇEĞİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await Ses.cik(hata)


## TEK-22: hız 3'te menüye dönünce time_scale 1, paused false ve fizik adımı geri.
func _sahne_cikisi() -> void:
	var onceki_adim := Engine.max_physics_steps_per_frame
	Engine.max_physics_steps_per_frame = 5
	var ana := TestAna.new()
	add_child(ana)
	for i in 3:
		ana.oturum.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci", "stat": 5})
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	_kontrol(Engine.max_physics_steps_per_frame == 8, "Köy ekranı kendi fizik adımını kurar")
	e._hiz_sec(3)
	_kontrol(Engine.time_scale == 3.0 and not get_tree().paused, "Köyde 3x hız seçildi")
	ana.ana_menu()
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(Engine.time_scale == 1.0 and not get_tree().paused, "Menüye dönünce hız 1, duraklama kapalı")
	_kontrol(Engine.max_physics_steps_per_frame == 5, "Çıkışta fizik adımı geri verilir")
	_kontrol(not (ana._ekran is KoyEkrani), "Köy ekranı ağaçtan çıktı")
	Engine.max_physics_steps_per_frame = onceki_adim
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame


## TEK-22 ek: boş günde hız köy ekranının seçimidir; sabah defteri yazılırken hız değişmez.
## TEK-24 ek: Çınar meclisi paneli açıkken hız değişmez, kapanınca kaldığı değere döner.
func _bos_gun_ve_defter() -> void:
	var ana := TestAna.new()
	add_child(ana)
	for i in 3:
		ana.oturum.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci", "stat": 5})
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	_kontrol(not e._gece_kilidi.kilitli(), "Yeni günde gece kilidi kapalı")
	e._hiz_sec(3)
	_kontrol(Engine.time_scale == 3.0 and not get_tree().paused, "Boş günde hız köy ekranının seçimidir; kapı kilidi uygulanmaz")
	_kontrol(KrizEnjektoru.uygula(ana, "kuyu")["ok"], "Gerçek krizle Çınar meclisi paneli açılabilir")
	e._hiz_sec(2)
	_kontrol(Engine.time_scale == 2.0, "Panel öncesi 2x seçildi")
	await _bas(e.hud, "cinar_meclisi")
	_kontrol(e._ust_kart != null and Engine.time_scale == 2.0 and not get_tree().paused, "Çınar paneli açıkken oyun hızı değişmedi")
	await _bas(e._ust_kart, "meclis_don")
	_kontrol(e._ust_kart == null and Engine.time_scale == 2.0 and not get_tree().paused, "Çınar paneli kapanınca hız kaldığı değere döndü")
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(e._ust_kart != null, "Gece/sabah defteri kartı açıldı")
	_kontrol(Engine.time_scale == 1.0 and not get_tree().paused, "Sabah defteri satırları yazılırken hız 1x'te sabit")
	_kontrol(e._ust_kart.find_child("gece_akce", true, false) != null, "Sabah defteri akçe satırı gerçekten yazıldı")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout


func _bas(n: Node, ad: String) -> void:
	var b := n.find_child(ad, true, false) as Button if n != null else null
	_kontrol(b != null and not b.disabled, "Gerçek düğme: " + ad)
	if b != null and not b.disabled:
		b.pressed.emit()
	await get_tree().process_frame


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)