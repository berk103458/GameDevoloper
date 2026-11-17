## CIL-05 hedefli testi: çok aşamalı inşaat kademesi (%0 / %50 / %85 / %100 / yanık) ve yapı kartı ilerlemesi.
extends SceneTree

var _hata := 0

func _initialize() -> void:
	var kat := BinaKatalogu.new()
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), kat, 42)
	var b := KoyBinasi.new()
	b.tur = "demirhane"
	var toplam := maxi(2, int(kat.veri("demirhane").get("insa_gun", 2)))
	# Aşama 0 (%0)
	b.insa_kalan = toplam
	b.insa_artik = 0.0
	var d0 := s._bina_dugumu(b)
	_kontrol(int(d0.get_meta(&"insaat_asama", -1)) == 0, "%%0 aşama 0 olmalı")
	_kontrol(d0.get_node_or_null("InsaatTemel") != null and d0.get_node_or_null("YukselenGovde") == null, "Aşama 0 yalnız temel/kazık")
	d0.free()
	# Aşama 1 (~%50)
	b.insa_kalan = maxi(1, toplam / 2)
	b.insa_artik = 0.0 if toplam % 2 == 0 else 0.5
	var d1 := s._bina_dugumu(b)
	_kontrol(int(d1.get_meta(&"insaat_asama", -1)) == 1, "%%50 aşama 1 olmalı")
	_kontrol(d1.get_node_or_null("YukselenGovde") != null and d1.get_node_or_null("InsaatIskele") != null, "Aşama 1 yükselen gövde + iskele")
	d1.free()
	# Aşama 2 (~%80)
	b.insa_kalan = 1
	b.insa_artik = 0.6
	var d2 := s._bina_dugumu(b)
	_kontrol(int(d2.get_meta(&"insaat_asama", -1)) == 2, "%%80 aşama 2 olmalı")
	_kontrol(d2.get_node_or_null("YukselenGovde") != null, "Aşama 2 neredeyse tamam gövde")
	d2.free()
	# Aşama 3 (%100 tamam)
	b.insa_kalan = 0
	b.insa_artik = 0.0
	var d3 := s._bina_dugumu(b)
	_kontrol(d3.get_node_or_null("InsaatIskele") == null and d3.get_node_or_null("meshy_demirhane") != null, "Tamamlanınca iskele kalkar, demirhane görünür")
	d3.free()
	# Yanık durum
	b.hucre = Vector2i(7, 7)
	s.yonetim.set_meta(&"yanik_ev_hucre", Vector2i(7, 7))
	var d4 := s._bina_dugumu(b)
	_kontrol(bool(d4.get_meta(&"yanik_durum", false)), "Yanık bina işaretlenmeli")
	d4.free()
	s.free()
	print("CIL-05 İNŞAAT KADEMELERİ: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	quit(1 if _hata > 0 else 0)

func _kontrol(ok: bool, msg: String) -> void:
	if not ok:
		_hata += 1
		push_error("CIL-05: " + msg)
