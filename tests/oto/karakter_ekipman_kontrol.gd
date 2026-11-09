extends Node

const YAPI_BILGISI = preload("res://src/koy/yapi_bilgisi.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_equipment.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_equipment_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas", "kereste", "demir", "un"]: y.kaynaklar.ekle(t, 100)
	var bilgi_sahibi := y.kabul({"sinif": "ciftci", "stat": 5})
	YAPI_BILGISI.ekle(bilgi_sahibi, PackedStringArray(["kulube", "demirhane", "firin"]))
	var onceki_kademe := _kur(y, "kulube")
	kontrol(onceki_kademe != null, "K2 demirhane için hazır K1 kulübe")
	if onceki_kademe == null:
		await Ses.cik(1)
		return
	var bs: Array[KoyBinasi] = []
	var ids: Array[int] = []
	for tur in ["demirhane", "firin"]:
		var b := _kur(y, tur)
		kontrol(b != null, "Gerçek zanaat binası")
		if b == null:
			await Ses.cik(1)
			return
		var k := y.kabul({"sinif": "ciftci", "stat": 5})
		k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI if tur == "demirhane" else ZanaatTuru.Tur.ESNAF
		kontrol(y.ata(k.id, b.id), "Gerçek zanaat ataması")
		kontrol(y.recete_sec(b.id, "alet" if tur == "demirhane" else "ekmek"), "Gerçek reçete")
		bs.append(b)
		ids.append(k.id)
	var ilk_aletler: Dictionary = {}
	var once := JSON.stringify(ana.oturum.kaydet().merged({"faz": "koy"}, true))
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	for i in 3: h._process(0.0)
	for id in ids:
		var f: KarakterModel = h.modeller[id]
		var d: Dictionary = h._durum[id]
		kontrol(d.zanaat and d.is, "Çalışan/girdili tezgâh aktif")
		kontrol(f.get_node_or_null("zanaat_tezgahi") != null, "Gerçek el bağlantısı")
		var e := f.get_node("karakter_ekipman_yoneticisi") as KarakterEkipmanYoneticisi
		var z := f.get_node("zanaat_tezgahi") as ZanaatTezgahi
		ilk_aletler[id] = z.alet
		kontrol(e.soket.get_skeleton() != null and e.soket.bone_name == "RightHand" and not e.soket.override_pose, "Gerçek iskelette tek salt okunur soket")
		kontrol(z.alet.get_parent() == e.soket and e.stok.size() == 1, "Mevcut yer tutucu tek sokette")
		for adim in range(d.yol.size() + 1):
			if int(d.adim) >= d.yol.size(): break
			f.position = d.yol[d.adim]
			h._process(0.0)
		f.yurumeyi_durdur()
		kontrol(f.duzeltici().surekli == StringName(d.zanaat_hareket), "Varınca çekiç/kürek döngüsü")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		for i in ids.size():
			var f: KarakterModel = h.modeller[ids[i]]
			var merkez := s.alan_merkezi(bs[i].hucre, bs[i].boyut(y.katalog))
			var disari := f.position - merkez
			disari.y = 0
			s.kamera.position = f.position + Vector3(5, 2.5, 3)
			s.kamera.look_at(f.position + Vector3(0, 0.9, 0))
			await get_tree().create_timer(0.4).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(dizin.path_join("ani11_%s.png" % bs[i].tur))
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Görsel zanaat kayıt/RNG/stok değiştirmez")
	h._process(float(h._ayar.calisma_suresi) + 0.1)
	for i in 3: h._process(0.0)
	await get_tree().process_frame
	for id in ids:
		kontrol(h._durum[id].dinlen and not h._durum[id].is and h.modeller[id].get_node_or_null("zanaat_tezgahi") == null, "Dinlenmede alet/motion kapanır")
	for id in ids:
		var e := h.modeller[id].get_node("karakter_ekipman_yoneticisi") as KarakterEkipmanYoneticisi
		var a: ElEsyasi = ilk_aletler[id]
		kontrol(not a.visible and a.get_parent() == e.depo, "Molada ekonomik stoğu değiştirmeden saklandı")
		ZanaatTezgahi.esya(h.modeller[id], bs[ids.find(id)].tur)
		kontrol((h.modeller[id].get_node("zanaat_tezgahi") as ZanaatTezgahi).alet == a, "Moladan dönüşte aynı nesne yeniden kullanılır")
	# Aynı karakter farklı zanaata geçtiğinde eski çekiç kalmaz.
	var f: KarakterModel = h.modeller[ids[0]]
	ZanaatTezgahi.esya(f, "demirhane")
	ZanaatTezgahi.esya(f, "firin")
	kontrol((f.get_node("zanaat_tezgahi") as ZanaatTezgahi)._tur == "firin", "Görev değişiminde doğru alet")
	s.faz(&"gece", 0.0)
	for i in 3: h._process(0.0)
	await get_tree().process_frame
	for id in ids: kontrol(h.modeller[id].get_node_or_null("zanaat_tezgahi") == null, "Gece iş eşyası temizlenir")
	for id in ids:
		var e := h.modeller[id].get_node("karakter_ekipman_yoneticisi") as KarakterEkipmanYoneticisi
		kontrol(e._aktif == null and e.stok.values().all(func(v: ElEsyasi) -> bool: return not v.visible and v.get_parent() == e.depo), "Gece bütün iş aletleri stokta, ikinci soket yok")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Mola ve gece soketi stok/kayıt/RNG değiştirmez")
	var un := y.kaynaklar.miktar("un")
	y.kaynaklar.harca({"un": un})
	s.faz(&"gunduz", 0.0)
	for i in 3: h._process(0.0)
	kontrol(not h._durum[ids[1]].is, "Unsuz fırın küreği çalışmaz")
	y.kaynaklar.ekle("un", un)
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("KARAKTER EKİPMAN UI: GEÇTİ" if hata == 0 else "KARAKTER EKİPMAN UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
