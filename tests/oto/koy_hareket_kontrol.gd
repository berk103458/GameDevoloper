## İşe yürüyüş, yenilemede kimlik/konum, gece hedefi ve duraklama entegrasyonu.
extends Node

var _hata := 0

func _ready() -> void:
	call_deferred("_dene")

func _dene() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 21)
	var y := o.yonetim
	var k := y.kabul({"ad": "Test köylü", "sinif": "ciftci"})
	var m := y.a.meydan
	var b := KoyBinasi.new()
	b.id = 700
	b.tur = "tarla"
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

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		_hata += 1
		push_error(mesaj)
