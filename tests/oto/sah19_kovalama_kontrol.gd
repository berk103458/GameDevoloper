## SAH-19 (Claude-Berk): koşu yalnız kovalama ve kaçışta açılır; günlük devriye yürür.
## Gerçek köy ekranı (Ana._koye_git) ve KoyHalkHareketi üzerinden: devriyede nöbetçinin koşu klibi 0;
## ANI-10 kaçışı başlayınca kaçan kişi ve yakındaki nöbetçi (kovalama) aynı anda koşar; nöbetçi
## uzaklaşınca ikisi de yürüyüşe döner. Yeni koşu hali yok: HareketGecisi.kosu_izni kullanılır.
extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_sah19.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_sah19.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.gizli_egilim = {"tur": "haydut"}
	k.portre = "farmer_01"
	k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
	var guard := y.kabul({"sinif": "asker", "stat": 5})
	guard.is_yeri = KoyYonetimi.MUHAFIZ
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	s.faz(&"gece", 0.0)
	for i in 3: h._process(0.0)
	var kosu_klibi := HareketGecisi.tablo_klibi("kos")
	var d: Dictionary = h._durum[k.id]
	var gd: Dictionary = h._durum[guard.id]
	var f: KarakterModel = h.modeller[k.id]
	var g: KarakterModel = h.modeller[guard.id]
	kontrol(gd.devriye and not gd.yol.is_empty(), "Nöbetçi gece devriyesinde")
	# Devriye: rota boyunca her adımda bağlam boş, bant yürüyüş, koşu klibi 0 kare.
	var devriye_kosu := 0
	var adimlar := 0
	while int(gd.adim) < gd.yol.size() and adimlar < 12:
		g.position = gd.yol[gd.adim]
		h._process(0.0)
		adimlar += 1
		if g.hareket_bandi() == "kos" or g._oynatici.current_animation == kosu_klibi or SinsiGeceRutini.hareket_baglami(h, guard.id) != &"":
			devriye_kosu += 1
	kontrol(adimlar > 0 and devriye_kosu == 0, "SAH-19: devriyede koşu klibi 0 (%d adım, %d koşu)" % [adimlar, devriye_kosu])
	# Kuytuya varış, sonra nöbetçi yaklaşır: ANI-10 kaçışı.
	for adim in range(d.yol.size() + 1):
		if int(d.adim) >= d.yol.size(): break
		f.position = d.yol[d.adim]
		h._process(0.0)
	f.yurumeyi_durdur()
	var ilk := f.position
	# Nöbetçiye yeni devriye turu (kovalama sonrası bir sonraki adım ölçülebilsin).
	g.yurumeyi_durdur()
	h._iste(guard.id)
	for i in 3: h._process(0.0)
	g.yurumeyi_durdur()
	g.position = ilk + Vector3(1, 0, 0)
	h._process(float(SinsiGeceRutini.AYAR.yeniden_planlama))
	for i in 3: h._process(0.0)
	kontrol(SinsiGeceRutini.hareket_baglami(h, k.id) == &"kacis" and f.hareket_bandi() == "kos" and f._oynatici.current_animation == kosu_klibi, "SAH-19: kaçışta kaçan kişi koşar")
	kontrol(SinsiGeceRutini.hareket_baglami(h, guard.id) == &"kovalama" and guard.id in SinsiGeceRutini.kovalayanlar(h, k.id), "SAH-19: yakındaki nöbetçi kovalama bağlamında")
	kontrol(g.hareket_bandi() == "kos", "SAH-19: kovalayan nöbetçi koşu bandında")
	kontrol(not g._oynatici.has_animation(kosu_klibi) or g._oynatici.current_animation == kosu_klibi, "SAH-19: nöbetçi modelinde koşu klibi varsa oynar")
	# Nöbetçi uzaklaşır: kaçış ve kovalama biter, bir sonraki adımda ikisi de yürür.
	g.position = ilk + Vector3(0, 0, 24)
	while int(d.adim) + 1 < d.yol.size() and f.hareket_bandi() == "kos":
		f.position = d.yol[d.adim]
		h._process(0.0)
	if int(gd.adim) < gd.yol.size():
		g.position = gd.yol[gd.adim]
		h._process(0.0)
	kontrol(f.hareket_bandi() == "yuru", "SAH-19: kaçış bitince kaçan yürüyüşe döner")
	kontrol(SinsiGeceRutini.hareket_baglami(h, guard.id) == &"" and g.hareket_bandi() != "kos", "SAH-19: kovalama bitince nöbetçi koşmaz")
	kontrol(not HareketGecisi.kosu_izni(&"devriye") and not HareketGecisi.kosu_izni(&""), "SAH-19: devriye/boş bağlamda koşu izni yok")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("SAH-19 KOVALAMA: GEÇTİ" if hata == 0 else "SAH-19 KOVALAMA: KALDI (%d hata)" % hata)
	await Ses.cik(hata)


func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
	else:
		print("  ok: " + ad)
