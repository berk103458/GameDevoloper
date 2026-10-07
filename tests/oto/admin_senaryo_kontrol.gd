extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_senaryo.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 84)
		kayit = GuvenliKayit.new("user://test_admin_senaryo.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	for i in 3:
		await _durum(i)
	print("ADMIN SENARYO: GEÇTİ" if hata == 0 else "ADMIN SENARYO: KALDI")
	await Ses.cik(hata)

func _durum(indeks: int) -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	for i in 3:
		y.kabul({"ad": "Test %d" % i, "sinif": "ciftci"})
	var a := y.a
	var h := Vector2i(a.meydan.position.x + a.meydan.size.x / 2 + 1, a.meydan.end.y + 1)
	var d := y.bina_kur("cadir", h)
	y.bina(d["id"]).insa_kalan = 0
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.senaryo_paneli
	p.secim.select(indeks)
	ana._ekran._hiz_sec(2)
	p.baslat.pressed.emit()
	var r := p.son_rapor
	_kontrol(r["ok"] and r["senaryo"] == SenaryoKosucusu.KIMLIKLER[indeks] and r["gecen"] == ana.oturum.gun and r["raporlar"].size() == r["gecen"], "Gerçek düğme/gece/rapor sayıları eşleşir")
	_kontrol(Engine.time_scale == 1.0 and not get_tree().paused and y.a == a and not y.has_meta(GeceDeneyi.META), "2x sonrası tek hesaplaşma, geçici deney/ayar temizliği")
	if r["son"] != "":
		_kontrol(not ana._ekran is KoyEkrani and not ana.kayit.var_mi() and r["gecen"] < r["istenen"], "Gerçek terminal sonuç erken durur ve normal son ekranına geçer")
	else:
		var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
		_kontrol(ana._ekran is KoyEkrani and geri.gun == ana.oturum.gun, "Sonuç normal köy/güvenli test slotunda")
		if indeks == 2:
			_kontrol("hasta" in geri.yonetim.koylular[0].bayraklar and geri.yonetim.koylular[0].saglik == y.koylular[0].saglik, "Salgın girdisi gerçek kayıtta")
		var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
		if indeks == 1 and not dizin.is_empty() and DisplayServer.get_name() != "headless":
			await get_tree().create_timer(0.5).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(dizin.path_join("adm09_senaryo.png"))
		ana._ekran._geceye_gec()
		p.yenile()
		var once := JSON.stringify(ana.oturum.kaydet())
		_kontrol(p.baslat.disabled, "Açık gece raporunda senaryo kilitli")
		p.baslat.pressed.emit()
		_kontrol(not p.son_rapor["ok"] and JSON.stringify(ana.oturum.kaydet()) == once, "Doğrudan sinyal rapor kilidini aşamaz")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
