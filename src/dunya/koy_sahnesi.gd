## Köy sahnesi (3D): ikindiden geceye bir köy günü. Arazi, orman halkası, yollar, yapılar ve eşyalar
## yerleşim planından kurulur; köylüler programlarıyla işe gider, akşam meydanda toplanır, gece evlerine çekilir.
## Bu gece içeri alınanlar kapıdan yürüyerek gelir. İkinci perdede sur ve yaklaşan Tekfur'un adamları.
## Saat `saat_hizi` ile ilerler (zaman denetimi Engine.time_scale'i değiştirir).
class_name KoySahnesi
extends Node3D

const KAPI := KoyYerlesimi.KAPI
const AZAMI_FIGUR := 32
const SUR_YARICAP := 28.0

var oturum: Oturum
var kamera: KoyKamerasi
var ayar: KoyGorunumAyarlari
## Köy saati (24 saatlik, ondalıklı).
var saat := 16.5
var yerlesim: KoyYerlesimi
var yonetici: KoyluYoneticisi

var _atmosfer: AtmosferYoneticisi
var _icerik: Node3D
var _isiklar: Array[OmniLight3D] = []
var _simgeler: Array[Sprite3D] = []
var _zaman := 0.0
var _onizleme: Node3D
var _cerceve_mat: ShaderMaterial
var _hayalet_mat: ShaderMaterial
var _vurgulu: KoyluAI
var _secili: KoyluAI


func _ready() -> void:
	ayar = KoyGorunumAyarlari.yukle()
	saat = ayar.baslangic_saati
	_cerceve_mat = ShaderMaterial.new()
	_cerceve_mat.shader = load("res://src/koy/gorsel/secim_outline.gdshader")
	_hayalet_mat = ShaderMaterial.new()
	_hayalet_mat.shader = load("res://src/koy/gorsel/kesikli_cizgi.gdshader")
	_atmosfer = AtmosferYoneticisi.new()
	add_child(_atmosfer)
	kamera = KoyKamerasi.new()
	kamera.ayar = ayar
	add_child(kamera)
	_kur(true)
	_atmosfer.saat_uygula(saat)


## Sahneyi oturumdan yeniden kurar (yapı kurulunca ya da olaydan sonra). Saat ve kamera korunur.
func yenile() -> void:
	_vurgulu = null
	_secili = null
	if _icerik != null:
		_icerik.queue_free()
	_isiklar.clear()
	_simgeler.clear()
	_onizleme = null
	_kur(false)


## Saati gece saatine atlatır: köylüler evlerine yürür, ışık geceye döner.
func geceye_gec() -> void:
	saat = maxf(saat, ayar.eve_donus_saati + 0.7)


func gece_mi() -> bool:
	return saat >= ayar.gece_saati


func _process(delta: float) -> void:
	_zaman += delta
	if saat < ayar.gece_saati + 0.5:
		saat += delta / ayar.saat_suresi_sn
		_atmosfer.saat_uygula(saat)
	if yonetici != null:
		yonetici.saat = saat
	for i in _isiklar.size():
		var l := _isiklar[i]
		var gece_payi := clampf(inverse_lerp(18.0, 19.5, saat), 0.15, 1.0)
		l.light_energy = float(l.get_meta("taban")) * gece_payi * (0.85 + 0.15 * sin(_zaman * 8.0 + i * 1.7) * sin(_zaman * 2.9 + i))
	for s in _simgeler:
		s.visible = kamera.global_position.distance_to(s.global_position) < ayar.simge_uzaklik


## Ekran noktasına en yakın görünür köylü (izdüşüm ile; fizik gövdesi gerekmez). Yoksa null.
func koylu_bul(ekran: Vector2) -> KoyluAI:
	if yonetici == null:
		return null
	var en_iyi: KoyluAI = null
	var en_d := 46.0
	for ai in yonetici.koyluler:
		if not ai.govde.visible:
			continue
		var p := ai.govde.global_position + Vector3(0, 1.0, 0)
		if kamera.is_position_behind(p):
			continue
		var d := kamera.unproject_position(p).distance_to(ekran)
		if d < en_d:
			en_d = d
			en_iyi = ai
	return en_iyi


## Üzerine gelinen köylüyü çerçeveler.
func vurgula(ai: KoyluAI) -> void:
	if ai == _vurgulu:
		return
	if _vurgulu != null and is_instance_valid(_vurgulu) and _vurgulu != _secili:
		_vurgulu.govde.cerceve(null)
	_vurgulu = ai
	if ai != null:
		ai.govde.cerceve(_cerceve_mat)


## Seçili köylü (kart açıkken çerçevesi kalır); null bırakır.
func sec(ai: KoyluAI) -> void:
	if _secili != null and is_instance_valid(_secili) and _secili != ai:
		_secili.govde.cerceve(null)
	_secili = ai
	if ai != null:
		ai.govde.cerceve(_cerceve_mat)
		kamera.odaklan(ai.govde.position)


## İnşa önizlemesi: yapının bir sonraki seviyesi kesikli hayalet olarak yerinde görünür.
func onizleme_goster(yapi: StringName) -> void:
	onizleme_gizle()
	_onizleme = Node3D.new()
	_onizleme.name = "Onizleme"
	_icerik.add_child(_onizleme)
	var sonraki := int(oturum.yapilar[yapi]) + 1
	match yapi:
		&"pazar":
			for i in range(yerlesim.pazar_seviye * 2, sonraki * 2):
				var t := Dunya3B.nesne("pazar_tezgahi", 2.4, "yapi")
				t.position = Vector3(7.5 + (i % 2) * 3.0, 0, -3.0 + (i / 2) * 3.2)
				t.rotation_degrees.y = -70
				_onizleme.add_child(t)
		&"kervansaray":
			var k := Dunya3B.nesne("kervansaray", 3.2 + sonraki * 0.6, "yapi")
			k.position = KoyYerlesimi.KERVANSARAY
			k.rotation_degrees.y = 25
			_onizleme.add_child(k)
		&"sur":
			_sur_halkasi(_onizleme, sonraki, 2)
	for mi in _onizleme.find_children("*", "MeshInstance3D", true, false):
		(mi as MeshInstance3D).material_override = _hayalet_mat
		(mi as MeshInstance3D).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func onizleme_gizle() -> void:
	if _onizleme != null and is_instance_valid(_onizleme):
		_onizleme.queue_free()
	_onizleme = null


func _kur(animasyon: bool) -> void:
	_icerik = Node3D.new()
	_icerik.name = "Icerik"
	add_child(_icerik)
	yerlesim = KoyYerlesimi.kur(oturum)
	var maske := Arazi.zemin_kur(_icerik, yerlesim)
	Arazi.bitki_kur(_icerik, maske, oturum.tohum)
	var kapi := Dunya3B.nesne("kapi", 4.2, "yapi")
	kapi.position = KAPI
	kapi.rotation_degrees.y = 180
	_icerik.add_child(kapi)
	_mesale(KAPI + Vector3(-3.0, 0, 1.2), 2.0, 8.0)
	_mesale(KAPI + Vector3(3.0, 0, 1.2), 2.0, 8.0)
	_yapilari_kur()
	for i in yerlesim.evler.size():
		var e: Dictionary = yerlesim.evler[i]
		var ev := Dunya3B.nesne(e["tur"], 2.6 if e["tur"] == "ev" else 2.2, "yapi")
		ev.position = e["konum"]
		ev.rotation_degrees.y = e["aci"]
		_icerik.add_child(ev)
		if i % 2 == 0:
			_mesale(yerlesim.ev_kapisi(i) + (yerlesim.ev_kapisi(i) - e["konum"]).normalized().rotated(Vector3.UP, 1.2) * 1.2, 1.8, 7.0)
	var kuyu := Dunya3B.nesne("kuyu", 1.6)
	kuyu.position = KoyYerlesimi.KUYU
	_icerik.add_child(kuyu)
	var araba := Dunya3B.nesne("araba", 1.6)
	araba.position = KoyYerlesimi.AMBAR + Vector3(-2.6, 0, 1.2)
	araba.rotation_degrees.y = 70
	_icerik.add_child(araba)
	BinaDekoratoru.suesle(_icerik, yerlesim, oturum.tohum + 7)
	var meydan := MeydanAlani.new()
	meydan.name = "Meydan"
	_icerik.add_child(meydan)
	meydan.kur(yerlesim)
	_simge("campfire", KoyYerlesimi.MEYDAN + Vector3(0, 3.0, 0))
	_simge("barn", KoyYerlesimi.AMBAR + Vector3(0, 2.6, 0))
	_halki_kur(meydan, animasyon)
	_hayvanlari_kur()
	if oturum.perde == 2:
		_sur_kur()
		_tekfur_kur()


func _mesale(p: Vector3, guc: float, menzil: float) -> void:
	_isiklar.append(Dunya3B.mesale_kur(_icerik, p, guc, menzil, false))


func _simge(ikon: String, p: Vector3) -> void:
	var yol := "res://assets/arayuz/ikon/%s.svg" % ikon
	if not ResourceLoader.exists(yol):
		return
	var s := Sprite3D.new()
	s.texture = load(yol)
	s.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	s.pixel_size = 0.0011
	s.modulate = Color(0.85, 0.68, 0.38, 0.92)
	s.no_depth_test = true
	s.shaded = false
	s.position = p
	_icerik.add_child(s)
	_simgeler.append(s)


func _yapilari_kur() -> void:
	var kerv := yerlesim.kervansaray_seviye
	if kerv > 0:
		var k := Dunya3B.nesne("kervansaray", 3.2 + kerv * 0.6, "yapi")
		k.position = KoyYerlesimi.KERVANSARAY
		k.rotation_degrees.y = 25
		_icerik.add_child(k)
		_mesale(KoyYerlesimi.KERVANSARAY + Vector3(3.0, 0, 2.7), 2.4, 8.0)
		_simge("camel", KoyYerlesimi.KERVANSARAY + Vector3(0, 4.6 + kerv * 0.6, 0))
	for t in yerlesim.tezgahlar:
		var n := Dunya3B.nesne("pazar_tezgahi", 2.4, "yapi")
		n.position = t["konum"]
		n.rotation_degrees.y = t["aci"]
		_icerik.add_child(n)
	if yerlesim.pazar_seviye > 0:
		_mesale(Vector3(6.0, 0, -0.5), 2.2, 7.5)
		_simge("two-coins", yerlesim.tezgahlar[0]["konum"] + Vector3(0, 3.4, 0))


func _halki_kur(meydan: MeydanAlani, animasyon: bool) -> void:
	yonetici = KoyluYoneticisi.new()
	yonetici.name = "Koyluler"
	yonetici.ayar = ayar
	yonetici.kamera = kamera
	yonetici.saat = saat
	_icerik.add_child(yonetici)
	oturum.koy.kisileri_esitle()
	var kisiler := oturum.koy.kisiler
	var bas := maxi(0, kisiler.size() - AZAMI_FIGUR)
	var yeni_sayi := mini(oturum.koy.bu_gece_girenler.size(), kisiler.size() - bas) if animasyon else 0
	var ruh := ayar.yorgun_hiz_carpani if int(oturum.barlar.degerler[0]) < ayar.yorgun_esik else 1.0
	var rng := RandomNumberGenerator.new()
	rng.seed = oturum.tohum + 11
	var koyluler: Array[KoyluAI] = []
	for i in range(bas, kisiler.size()):
		var k: Dictionary = kisiler[i]
		var sira := i - bas
		var model := Dunya3B.karakter_adi(k["adli_id"], k["portre"], k["sinif"])
		if model == "ciftci" and k["adli_id"] == &"" and k["portre"] == "" and sira % 4 == 3:
			model = "ciftci_kadin"
		var govde := Dunya3B.karakter(model)
		_icerik.add_child(govde)
		var ai := KoyluAI.new()
		ai.kur(govde, k, sira, yerlesim, _nav(), meydan, ayar, ruh, rng)
		yonetici.ekle(ai)
		koyluler.append(ai)
		var yeni := i >= kisiler.size() - yeni_sayi
		if yeni:
			govde.visible = false
			_gir(ai, i - (kisiler.size() - yeni_sayi))
		else:
			ai.yerlestir(saat)
	_koylu_listesi = koyluler


var _koylu_listesi: Array[KoyluAI] = []
var _navigasyon: KoyNavigasyon


func _nav() -> KoyNavigasyon:
	if _navigasyon == null or _navigasyon_yerlesim != yerlesim:
		_navigasyon = KoyNavigasyon.new(yerlesim)
		_navigasyon_yerlesim = yerlesim
	return _navigasyon


var _navigasyon_yerlesim: KoyYerlesimi


func _gir(ai: KoyluAI, sira: int) -> void:
	await get_tree().create_timer(0.4 + sira * 1.1).timeout
	if not is_instance_valid(ai) or not is_instance_valid(ai.govde):
		return
	ai.govde.visible = true
	ai.kapidan_gir(KAPI + Vector3(0, 0, 1.5))


func _hayvanlari_kur() -> void:
	var yuva := KoyYerlesimi.AMBAR + Vector3(2.5, 0, -2.0)
	for i in ayar.tavuk_sayisi:
		var h := HayvanAI.new()
		h.yaricap = 3.5
		h.hiz = 0.7
		_icerik.add_child(h)
		h.kur("chick", 0.32, yuva, oturum.tohum + 100 + i)
	for i in ayar.kopek_sayisi:
		var h := HayvanAI.new()
		h.yaricap = 8.0
		h.hiz = 1.3
		h.koyluler = _koylu_listesi
		_icerik.add_child(h)
		h.kur("dog", 0.62, KoyYerlesimi.MEYDAN + Vector3(-3, 0, 4), oturum.tohum + 200 + i)


func _sur_kur() -> void:
	if yerlesim.sur_seviye <= 0:
		return
	_sur_halkasi(_icerik, yerlesim.sur_seviye, 1)
	_simge("stone-tower", KAPI + Vector3(0, 6.5, 0))


func _sur_halkasi(kok: Node3D, seviye: int, atla: int) -> void:
	var boy := 2.4 + seviye * 0.9
	var adet := 48
	for i in range(0, adet, atla):
		var a := TAU * i / adet
		var p := Vector3(sin(a) * SUR_YARICAP, 0, cos(a) * SUR_YARICAP)
		if absf(p.x) < 4.0 and p.z < 0.0:
			continue  # kapıdan gelen yol
		var c := Dunya3B.nesne("kazik_cit", boy)
		c.position = p
		c.rotation.y = a + PI / 2.0
		kok.add_child(c)


func _tekfur_kur() -> void:
	var yakinlik := clampf(float(oturum.perde2_gece) / oturum.ayarlar.perde2_hedef_gece, 0.0, 1.0)
	var adet := mini(4 + oturum.perde2_gece, 16)
	var uzak := 62.0 - yakinlik * 26.0
	var mat := Dunya3B.duz_malzeme(Renkler.DERIN_MAVI)
	for i in adet:
		var f := Dunya3B.karakter("asker")
		f.position = Vector3(-10.5 + (i % 8) * 3.0, 0, -uzak - (i / 8) * 3.0)
		for mi in f.find_children("*", "MeshInstance3D", true, false):
			(mi as MeshInstance3D).material_override = mat
		_icerik.add_child(f)
		f.bak(Vector3.ZERO)
	_mesale(Vector3(-12.0, 0, -uzak + 2.0), 1.6, 9.0)
