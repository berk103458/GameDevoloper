extends Node
const D = preload("res://src/koy/bos_gun_durusu.gd")
const A = preload("res://src/koy/bos_gun_durusu_adaptoru.gd")
var hata := 0
var kontrol := 0
func _ready() -> void:
	call_deferred("calistir")
func dene(v: bool, ad: String) -> void:
	kontrol += 1
	if not v:
		hata += 1
		push_error(ad)
func calistir() -> void:
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	if await oyun() != true: hata += 1
	print("TANIDIK YUZ OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	get_tree().quit(1 if hata > 0 else 0)
func oyun() -> bool:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 42)
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = Ayarlar.new()
	add_child(e)
	await get_tree().process_frame
	e._hiz_sec(0) # Test görsel hareketi sabitler; mekanik barları yazmaz.
	var s := e.sahne3b
	var h := s.halk_hareketi
	var k := o.yonetim.kabul({"ad": "Test Çiftçi", "sinif": "ciftci", "stat": 4})
	k.zanaat_turu = ZanaatTuru.Tur.CIFTCI
	var f := Node3D.new()
	s._halk.add_child(f)
	h.modeller[k.id] = f
	h._durum[k.id] = {"yol": [], "adim": 0}
	var ates := AtesBasiRutini.konum(s)
	f.position = ates + Vector3(2.5, 0, 0)
	# Dünya tıklaması gerçek _tikla kancasından aynı bilgi alanına gider.
	var m := o.yonetim.a.meydan
	e._imlec = m.position + m.size / 2
	# Grid koordinatını gerçek ateş konumundan bul.
	var en_iyi := INF
	for y in range(m.position.y - 2, m.end.y + 2):
		for x in range(m.position.x - 2, m.end.x + 2):
			var cell := Vector2i(x, y)
			var uzak := s.alan_merkezi(cell, Vector2i.ONE).distance_to(ates)
			if uzak < en_iyi:
				en_iyi = uzak
				e._imlec = cell
	var once := o.yonetim.kaydet().duplicate(true)
	var rng := o._rng.state
	dene(not D.acik(o) and A.kisi(e, e._imlec) == null, "Dolu günde etkileşim kapalı")
	o.set_meta(&"bos_gun", true) # KAP-16 çıktısı; ikinci zar yok.
	dene(A.kisi(e, e._imlec) == k, "Boş gün: gerçek ateş kadrajındaki kişi")
	e._tikla()
	dene(e._bilgi.visible and e._bilgi_icerik.get_child_count() == 2, "Gerçek ekran tıklaması mevcut bilgi alanında satır gösterir")
	var ilk: String = o.get_meta(D.META).son
	e._tikla()
	dene(o.get_meta(D.META).adet == 2, "Günde en çok iki satır")
	dene(not A.tikla(e), "Günün sınırında sessiz")
	dene(o.yonetim.kaydet() == once and o._rng.state == rng, "Köy barları kaynaklar ve RNG değişmedi")
	o.yonetim.gun += 1
	dene(not A.tikla(e), "Bitmiş meslek havuzu sessiz")
	o.remove_meta(D.META)
	o.yonetim.gun += 1
	var yeni := D.satir(o, k)
	o.yonetim.gun += 1
	dene(D.satir(o, k) != yeni, "Art arda boş gün aynı satırı tekrarlamaz")
	dene(not ilk.is_empty(), "İlk satır gerçek havuzdan")
	h.modeller.erase(k.id)
	dene(A.kisi(e, e._imlec) == null and not A.tikla(e), "Kişi yoksa satır yok")
	h.modeller[k.id] = f
	o.remove_meta(D.META)
	o.set_meta(&"bos_gun", false)
	o.yonetim.gun = 0
	o.set_meta(&"acl01_acilis_hanesi", {"kuruldu": true})
	dene(D.acik(o) and A.tikla(e), "Kapı kapalıyken ateş satırı gelir")
	dene(e.find_children("*", "KoyDiyalogPaneli", true, false).is_empty() and e.sahne3b == s, "Yeni panel/harita yok; köy kadrajı aynı")
	# SEV-02 gerçek _tikla yolu; aynı sahne ve köylü, kapı üreticisi çağrılmaz.
	o.yonetim.gun = 10
	o.set_meta(&"bos_gun", true)
	k.adli_id = &"chr_004"
	o.kadro.durumlar[k.adli_id]["durum"] = &"koyde"
	KisiHafizasi.kaydet_olay(o.kadro, k.adli_id, {"son_karar": "kabul", "yapilan_yardim": "ekmek"})
	dene(AtesBasiRutini.aday(o.yonetim, k, &"aksam"), "Gerçek ANI-07 yürüyüş adayı hafızalı köylüdür")
	h.faz_adi = &"aksam"
	var bas := h.rotaci.yakin(o.yonetim.a.meydan.position)
	dene(not AtesBasiRutini.hedef(h, k, bas).is_empty(), "Gerçek rotacı mevcut ANI-07 ateşine ulaşılabilir hedef verir")
	var kuyruk_once := o.gecikmeli_kuyruk.duplicate(true)
	e._tikla()
	dene(e._bilgi_icerik.get_child_count() == 2 and e._bilgi_icerik.get_child(1).text == TranslationServer.translate("anlati.ates_selam.ekmek"), "Son karar ve gerçek ekmek anısı mevcut bilgi alanında")
	dene(not A.tikla(e), "Aynı günde ikinci selam yok")
	var kayit := o.kadro.kaydet()
	dene(kayit[String(k.adli_id)].get("ates_son_gun") == o.gun and o.kadro.yukle(kayit), "Selam günü mevcut kadro kayıt yolunda korunur")
	dene(not A.tikla(e), "Kadro yüklemesi günlük sınırı sıfırlamaz")
	o.yonetim.gun += 1
	dene(not A.tikla(e), "Verideki aralık dolmadan aynı kişi yok")
	o.yonetim.gun += 1
	o.kadro.durumlar[k.adli_id]["son_karar"] = &""
	dene(not A.tikla(e), "Anı silinince genel selam yok")
	dene(not AtesBasiRutini.aday(o.yonetim, k, &"aksam"), "Anı silinince gerçek yürüyüş adayı da olmaz")
	KisiHafizasi.kaydet_olay(o.kadro, k.adli_id, {"son_karar": "kabul"})
	k.yas_grubu = &"cocuk"
	dene(not A.tikla(e), "Çocuk yalnızken çağrılmaz")
	k.yas_grubu = &"yetiskin"
	o.aksam_sohbeti_gece = o.gun
	dene(not A.tikla(e), "Eş sohbeti hazırlanmışken selam yok")
	o.aksam_sohbeti_gece = -1
	e._ust_kart = PanelContainer.new()
	e.add_child(e._ust_kart)
	e._ust_kart.set_meta(&"aksam_sohbeti", true)
	dene(not A.tikla(e), "Eş sohbeti paneli açıkken selam yok")
	e._ust_kart.free()
	e._ust_kart = null
	for durum in [&"oldu", &"kalici_ayrildi", &"donebilir"]:
		o.kadro.durumlar[k.adli_id]["durum"] = durum
		dene(not A.tikla(e), "Köyde olmayan kişi selam vermez: " + String(durum))
	o.kadro.durumlar[k.adli_id]["durum"] = &"koyde"
	dene(A.tikla(e), "Aralık sonrası yaşayan köylü yeniden konuşur")
	dene(o.gecikmeli_kuyruk == kuyruk_once, "Kapı kuyruğu değişmedi")
	dene(e.sahne3b == s and e._ust_kart == null and e._bilgi_icerik.get_child_count() == 2, "Yeni sahne veya panel açılmaz")
	k.adli_id = &""
	# Tezgâh: gerçek bina kaydı, atama ve sahnede önünde duran çalışan.
	o.remove_meta(D.META)
	o.set_meta(&"bos_gun", true)
	var b := KoyBinasi.new()
	b.id = 991
	b.tur = "atolye"
	b.hucre = Vector2i(2, 2)
	o.yonetim.binalar.append(b)
	o.yonetim.izgara.yerlestir(b.id, b.hucreler(o.yonetim.katalog))
	k.is_yeri = b.id
	k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
	h.faz_adi = &"gunduz"
	var boy := b.boyut(o.yonetim.katalog)
	f.position = s.alan_merkezi(b.hucre, boy) + Vector3((boy.x - 1) * s.HUCRE / 2, 0, boy.y * s.HUCRE / 2)
	e._imlec = b.hucre
	var tezgah_once := o.yonetim.kaydet().duplicate(true)
	dene(A.kisi(e, e._imlec) == k and A.tikla(e), "Tezgâh önündeki atanmış demirci iş satırı söyler")
	dene(o.yonetim.kaydet() == tezgah_once, "Tezgâh bar veya mal vermez")
	f.position += Vector3(20, 0, 0)
	dene(A.kisi(e, e._imlec) == null, "Atanmış ama tezgâhta bulunmayan kişi konuşmaz")
	f.position -= Vector3(20, 0, 0)
	h._durum[k.id] = {"yol": [Vector2i.ZERO], "adim": 0}
	dene(A.kisi(e, e._imlec) == null, "Tezgâha henüz yürüyen kişi konuşmaz")
	o.set_meta(&"bos_gun", false)
	o.yonetim.gun = 5
	dene(not A.tikla(e), "Dolu günde tezgâh da kapalı")
	e.queue_free()
	await get_tree().process_frame
	return true
