## İşe yürüyüş, yenilemede kimlik/konum, gece hedefi ve duraklama entegrasyonu.
extends Node

var _hata := 0

func _ready() -> void:
	call_deferred("_dene")

func _dene() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 21)
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(o, "koy")
	var y := o.yonetim
	# ANI-10 (sinsi gece): uyumsuz meslek sabotaj riski doğurup gece hedefini değiştirir. Bu test
	# yalnız genel iş/dinlenme/gece-eve-dönüş döngüsünü sınadığı için zanaat türü nötr (belirsiz) seçilir.
	var k := y.kabul({"ad": "Test köylü", "sinif": "ciftci", "zanaat_turu": "BELIRSIZ"})
	var m := y.a.meydan
	var b := KoyBinasi.new()
	b.id = 700
	# ANI-03 (8 Ekim): tarla işçisi gündüz sulama rutinine girer ve iş/dinlenme döngüsünü sulama
	# yönetir. Genel döngü yalnız özel rutini olmayan işyerinde işler; bu yüzden işyeri "ambar".
	b.tur = "ambar"
	b.hucre = m.end + Vector2i(2, 0)
	y.binalar.append(b)
	y.izgara.yerlestir(b.id, b.hucreler(y.katalog))
	var ev := KoyBinasi.new()
	ev.id = 701
	ev.tur = "cadir"
	ev.hucre = m.position - Vector2i(3, 2)
	y.binalar.append(ev)
	y.izgara.yerlestir(ev.id, ev.hucreler(y.katalog))
	k.is_yeri = b.id
	k.ev = ev.id
	# ANI-10 (gizli eğilim): eğilimi olan köylü gece eve değil tenha bir noktaya gider. Bu test genel
	# gündüz iş/dinlenme ve gece eve dönüş döngüsünü sınar; sinsi rutininin kendi testi var.
	k.gizli_egilim = {"tur": "yok"}
	var durum_once := JSON.stringify(y.kaydet())
	var s := KoyYonetimSahnesi.new()
	s.yonetim = y
	add_child(s)
	var h := s.halk_hareketi
	await get_tree().process_frame
	var f: KarakterModel = h.modeller[k.id]
	var bas := f.position
	await get_tree().create_timer(0.5).timeout
	_kontrol(f.position.distance_to(bas) > 0.1, "Köylü işyerine yürüyor")
	_kontrol(f.hareket_bandi() == "yuru", "SAH-31: Kayıt sırasında gerçek yürüyüş var")
	await _karisim_kaydini_dene(o, katalog, k.id)
	var kimlik := f.get_instance_id()
	var konum := f.position
	s.yenile()
	_kontrol(h.modeller[k.id].get_instance_id() == kimlik, "Yenilemede model korunuyor")
	_kontrol(f.position == konum, "Yenilemede konum korunuyor")
	h._ayar.yurume_hizi = 100.0
	h._ayar.calisma_suresi = 0.2
	h._ayar.dinlenme_suresi = 100.0
	await get_tree().create_timer(2.0).timeout
	_kontrol(h._durum[k.id].dinlen, "İş süresi dolunca dinlenmeye geçiyor")
	_kontrol(not h._durum[k.id].is, "Dinlenmede iş hareketi kapanıyor")
	s.faz(&"gece", 0.0)
	await get_tree().create_timer(2.0).timeout
	var d: Dictionary = h._durum[k.id]
	_kontrol(not d.is, "Gece iş animasyonu kapanıyor")
	_kontrol(d.adim == d.yol.size(), "Gece hedefe varıyor")
	_kontrol(d.bak == s.alan_merkezi(ev.hucre, ev.boyut(y.katalog)), "İşyerinden farklı ev çevresine dönüyor")
	_kontrol(JSON.stringify(y.kaydet()) == durum_once, "Görsel hareket ekonomiyi ve kaydı değiştirmiyor")
	s.faz(&"gunduz", 0.0)
	await get_tree().process_frame
	get_tree().paused = true
	var durak := f.position
	await get_tree().create_timer(0.2, true).timeout
	_kontrol(f.position == durak, "Duraklamada yürüyüş duruyor")
	get_tree().paused = false
	s.queue_free()
	await get_tree().process_frame
	print("KÖY HAREKET TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(_hata)

func _karisim_kaydini_dene(oturum: Oturum, katalog: Katalog, id: int) -> void:
	var dosya := GuvenliKayit.new("user://test_sah31_%d.json" % Time.get_ticks_usec())
	var yazildi := dosya.yaz(oturum.kaydet())
	var eski := dosya.oku()
	_kontrol(yazildi and not eski.is_empty() and _karisim_alanlari_yok(eski), "SAH-31: Gerçek diskte hareket/karışım alanı yok")
	if not yazildi or eski.is_empty():
		dosya.sil()
		return
	eski["surum"] = 2
	eski.erase("muhafiz_esyalari")
	eski.erase("muhafiz_tecrubesi")
	eski["klip_agirligi"] = {"kos": 1.0}
	var kisi: Dictionary = eski["koy_yonetimi"]["koylular"][0]
	kisi["karisim_katmani"] = {"kos": 1.0}
	kisi["hareket_bandi"] = "kos"
	var eski_yazildi := dosya.yaz(eski)
	var okunan := dosya.oku()
	var yeniden := Oturum.kayittan(katalog, okunan) if eski_yazildi else null
	_kontrol(yeniden != null and int(okunan.get("surum", 0)) == 2 and dosya.oku() == okunan, "SAH-31: Gerçek v2 dosyası yerinde kalır ve göç yüklemede yapılır")
	dosya.sil()
	if yeniden == null:
		return
	var kayit := yeniden.kaydet()
	var goc: Dictionary = kayit["kayit_gocu_bildirimi"]
	_kontrol(goc.get("kaynak") == 2 and goc.get("hedef") == Oturum.KAYIT_SURUMU and kayit.faz == "koy", "SAH-31: KAY-03 bildirimi ve köy fazı")
	_kontrol(_karisim_alanlari_yok(kayit), "SAH-31: Yeniden yazılan kayıtta eski görsel alanlar yok")
	var sahne := KoyYonetimSahnesi.new()
	sahne.yonetim = yeniden.yonetim
	add_child(sahne)
	var halk := sahne.halk_hareketi
	halk.set_process(false)
	var figur: KarakterModel = halk.modeller.get(id)
	_kontrol(figur != null and figur.hareket_bandi() == "dur", "SAH-31: Yeni aktör eski kayıttaki koşu bandını almaz")
	if figur != null:
		for i in 3:
			halk._process(0.0)
		var bas := figur.position
		_kontrol(figur.hareket_bandi() == "yuru" and figur._oynatici.current_animation == figur._anim, "SAH-31: Gerçek rota bandı ve klibi hızdan kurar")
		_kontrol(_karisim_alanlari_yok(yeniden.kaydet()), "SAH-31: Yeni yürüyüşe giriş de kayıttan ayrı")
		if figur._yurume != null:
			figur._yurume.pause()
			figur._yurume.custom_step(0.15)
		var ilerleme := figur.position.distance_to(bas)
		_kontrol(ilerleme > 0.05, "SAH-31: Yüklenen köylü gerçek rotada ilerler")
		print("SAH-31 v%d→v%d, yüklenen bant=%s, kök ilerlemesi=%.5f m" % [goc.get("kaynak", 0), goc.get("hedef", 0), figur.hareket_bandi(), ilerleme])
	sahne.queue_free()
	await get_tree().process_frame


func _karisim_alanlari_yok(deger: Variant) -> bool:
	if deger is Dictionary:
		for anahtar in deger:
			if str(anahtar) in ["klip_agirligi", "karisim_katmani", "hareket_bandi"] or not _karisim_alanlari_yok(deger[anahtar]):
				return false
	elif deger is Array:
		for oge in deger:
			if not _karisim_alanlari_yok(oge):
				return false
	return true


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		_hata += 1
		push_error(mesaj)
