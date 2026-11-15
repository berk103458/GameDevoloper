## Mevcut köy kadrajında ateş/tezgâh tıklaması → mevcut bilgi alanı.
extends RefCounted
const DURUS = preload("res://src/koy/bos_gun_durusu.gd")

static func kisi(e: KoyEkrani, hucre: Vector2i) -> Koylu:
	if not DURUS.acik(e.oturum): return null
	var s := e.sahne3b
	var h := s.halk_hareketi
	var ates := AtesBasiRutini.konum(s)
	var tik := s.alan_merkezi(hucre, Vector2i.ONE)
	var ateste := Vector2(tik.x - ates.x, tik.z - ates.z).length() <= s.HUCRE
	var b := e._bina_altinda(hucre)
	for id in h.modeller:
		var k := s.yonetim.koylu(int(id))
		var f: Node3D = h.modeller[id]
		if k == null or not is_instance_valid(f): continue
		var d: Dictionary = h._durum.get(id, {})
		if int(d.get("adim", 0)) < d.get("yol", []).size(): continue
		if ateste and f.position.distance_to(ates) <= float(AtesBasiRutini.AYAR.en_uzak) + 0.5:
			return k
		if b != null and k.is_yeri == b.id and ZanaatTezgahi.aday(s.yonetim, k, h.faz_adi):
			var boy := b.boyut(s.yonetim.katalog)
			var hedef := s.alan_merkezi(b.hucre, boy) + Vector3((boy.x - 1) * s.HUCRE / 2, 0, boy.y * s.HUCRE / 2)
			if f.position.distance_to(hedef) <= s.HUCRE: return k
	return null

static func atestekiler(e: KoyEkrani) -> Array[Koylu]:
	var sonuc: Array[Koylu] = []
	var s := e.sahne3b
	var ates := AtesBasiRutini.konum(s)
	var tik := s.alan_merkezi(e._imlec, Vector2i.ONE)
	if Vector2(tik.x - ates.x, tik.z - ates.z).length() > s.HUCRE: return sonuc
	for id in s.halk_hareketi.modeller:
		var k := s.yonetim.koylu(int(id))
		var f: Node3D = s.halk_hareketi.modeller[id]
		var d: Dictionary = s.halk_hareketi._durum.get(id, {})
		if k == null or not is_instance_valid(f): continue
		if int(d.get("adim", 0)) < d.get("yol", []).size(): continue
		if f.position.distance_to(ates) <= float(AtesBasiRutini.AYAR.en_uzak) + 0.5: sonuc.append(k)
	return sonuc

static func tikla(e: KoyEkrani) -> bool:
	var k := kisi(e, e._imlec)
	var anahtar := ""
	var adaylar := atestekiler(e)
	if not adaylar.is_empty():
		if e.oturum.aksam_sohbeti_gece == e.oturum.gun: return false
		if e._ust_kart != null and e._ust_kart.has_meta(&"aksam_sohbeti"): return false
		var secim := DURUS.ates_selami(e.oturum, adaylar)
		if not secim.is_empty():
			k = secim.koylu
			anahtar = secim.ates_sozu
		else:
			var bag_satiri := KoyluBagi.ates_satiri(e.oturum.yonetim, adaylar)
			if not bag_satiri.is_empty():
				anahtar = bag_satiri
			else:
				# Adlı kişinin hafızası yoksa genel iş satırıyla selam uydurma.
				for aday in adaylar:
					if aday.adli_id != &"": return false
	if anahtar.is_empty(): anahtar = KoyluBagi.ates_satiri(e.oturum.yonetim, [k])
	if anahtar.is_empty(): anahtar = DURUS.satir(e.oturum, k)
	if anahtar.is_empty(): return false
	# Yeni panel/sahne yok; YAZ-08 sohbetinin yanındaki salt metin adaptörü.
	for c in e._bilgi_icerik.get_children():
		e._bilgi_icerik.remove_child(c)
		c.queue_free()
	e._bilgi.show()
	e._etiket(e._bilgi_icerik, TranslationServer.translate(k.ad), Tema.BASLIK_PX)
	var l := e._etiket(e._bilgi_icerik, TranslationServer.translate(anahtar), Tema.GOVDE_PX)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return true
