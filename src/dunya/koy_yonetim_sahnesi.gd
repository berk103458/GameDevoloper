## Köy yönetimi sahnesi (3D, design/gdd/koy-yonetimi.md 6, 9, 14.2): akşam ışığında, ızgaraya oturan yapılar,
## meydana bağlı patikalar, çalışanlar yapılarının önünde, boştakiler meydan ateşinin başında. Yerleşim önizlemesi
## (hayalet) ve fareyle hücre seçimi buradadır; kararları `KoyEkrani` verir, sahne yalnız gösterir.
## Arazi, çimen ve orman kuşağı `KoyArazisi`, ışık ve gök `KoyAtmosferi` (görsel tasarım md, madde 1–5).
class_name KoyYonetimSahnesi
extends Node3D

## Bir ızgara hücresi (m).
const HUCRE := 2.0
## Mevsime göre çayırın kuruluğu (ilkbahar, yaz, sonbahar, kış).
const KURULUK: Array[float] = [0.08, 0.3, 0.62, 0.85]
const AZAMI_KOYLU := 30
const UYGUN := Color(0.35, 0.75, 0.4, 0.42)
const UYGUNSUZ := Color(0.85, 0.3, 0.25, 0.42)

var yonetim: KoyYonetimi
var kamera: Camera3D
var arazi: KoyArazisi
var atmosfer: KoyAtmosferi
## Kamera: hedef nokta, uzaklık, yön ve eğim (derece).
var hedef := Vector3(0, 0, 4)
var uzaklik := 38.0
var yon := 25.0
var egim := 52.0

var _yapilar := Node3D.new()
var _halk := Node3D.new()
var halk_hareketi: KoyHalkHareketi
var _hayalet: MeshInstance3D
var _hayalet_malzeme: StandardMaterial3D
var _secim: MeshInstance3D
var _ates_isigi: OmniLight3D
var _zaman := 0.0


func _ready() -> void:
	atmosfer = KoyAtmosferi.new()
	add_child(atmosfer)
	arazi = KoyArazisi.new()
	add_child(arazi)
	arazi.kur(self, kapi_noktasi())
	add_child(_yapilar)
	add_child(_halk)
	halk_hareketi = KoyHalkHareketi.new()
	halk_hareketi.sahne = self
	add_child(halk_hareketi)
	_hayalet = MeshInstance3D.new()
	_hayalet.mesh = BoxMesh.new()
	_hayalet_malzeme = StandardMaterial3D.new()
	_hayalet_malzeme.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_hayalet_malzeme.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_hayalet.material_override = _hayalet_malzeme
	_hayalet.visible = false
	add_child(_hayalet)
	_secim = MeshInstance3D.new()
	_secim.mesh = BoxMesh.new()
	var sm := StandardMaterial3D.new()
	sm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sm.albedo_color = Color(0.95, 0.8, 0.45, 0.22)
	_secim.material_override = sm
	_secim.visible = false
	add_child(_secim)
	kamera = Camera3D.new()
	kamera.fov = 45.0
	kamera.far = 600.0
	add_child(kamera)
	_kamera_yerlestir()
	yenile()
	faz(&"gunduz", 0.0)
	KameraSurukleme.kur(self)


func _process(delta: float) -> void:
	_zaman += delta
	if _ates_isigi != null:
		_ates_isigi.light_energy = atmosfer.ates_gucu * (0.85 + 0.15 * sin(_zaman * 9.0) * sin(_zaman * 3.1))
	# Strateji kamerası (18.5): WASD kaydırır, Q/E döndürür; tekerlek `yakinlas` ile.
	# Ana viewporttaki konsol/SpinBox metni yazılırken kamera tuşlarını alma.
	var odak := get_tree().root.gui_get_focus_owner()
	if odak is LineEdit or odak is TextEdit:
		return
	var ileri := Vector3(-sin(deg_to_rad(yon)), 0, -cos(deg_to_rad(yon)))
	var sag := Vector3(-ileri.z, 0, ileri.x)
	var hiz := uzaklik * 0.9 * delta
	var d := Vector3.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		d += ileri
	if Input.is_physical_key_pressed(KEY_S):
		d -= ileri
	if Input.is_physical_key_pressed(KEY_D):
		d += sag
	if Input.is_physical_key_pressed(KEY_A):
		d -= sag
	if Input.is_physical_key_pressed(KEY_Q):
		yon += 60.0 * delta
	if Input.is_physical_key_pressed(KEY_E):
		yon -= 60.0 * delta
	if d != Vector3.ZERO:
		hedef = KameraSurukleme.odak_sinirla(self, hedef + d.normalized() * hiz)
	_kamera_yerlestir()


## Işığı gündüz / akşam / gece fazına geçirir (KoyAtmosferi).
func ayak_zemini_yuksekligi(konum: Vector3) -> float:
	var nokta := to_local(konum)
	nokta.y = arazi.yukseklik_burada(nokta.x, nokta.z)
	return to_global(nokta).y


func faz(ad: StringName, sure: float = 2.0) -> void:
	var gercek_sure := preload("res://src/sistemler/hareket_azalt.gd").sure(sure)
	atmosfer.faz(ad, gercek_sure)
	halk_hareketi.faz(ad)
	_gece_isiklarini_guncelle(ad, gercek_sure)


## Kapının dünya konumu (x, z): kapı yolu ve arazi buradan güneye uzanır.
func kapi_noktasi() -> Vector2:
	var merkez := alan_merkezi(KapiNobeti.esik_hucresi(yonetim), Vector2i.ONE)
	return Vector2(merkez.x, merkez.z)


func yakinlas(adim: float) -> void:
	uzaklik = KameraSurukleme.uzaklik_sinirla(uzaklik * (1.0 - adim * 0.1))


## Kamerayı verilen konuma (ızgara ve arazi sınırları içinde) odaklar; HareketAzalt'a uyar.
func odaklan(konum: Vector3, sure: float = 0.35) -> void:
	var hedef_nokta := KameraSurukleme.odak_sinirla(self, konum)
	var gercek_sure := preload("res://src/sistemler/hareket_azalt.gd").sure(sure)
	if gercek_sure <= 0.0 or not is_inside_tree():
		hedef = hedef_nokta
		_kamera_yerlestir()
		return
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_method(func(v: Vector3) -> void:
		hedef = v
		_kamera_yerlestir()
	, hedef, hedef_nokta, gercek_sure)


func _kamera_yerlestir() -> void:
	if kamera == null:
		return
	var e := deg_to_rad(egim)
	var y := deg_to_rad(yon)
	kamera.position = hedef + Vector3(sin(y) * cos(e), sin(e), cos(y) * cos(e)) * uzaklik
	kamera.look_at(hedef)


# ── Izgara ↔ dünya ────────────────────────────────────────────────────────────────────────────────

## Hücrenin sol üst köşesinin dünya konumu (meydanın ortası dünyanın ortasıdır).
func hucre_kosesi(h: Vector2i) -> Vector3:
	var orta := Vector2(yonetim.a.meydan.position) + Vector2(yonetim.a.meydan.size) / 2.0
	return Vector3((h.x - orta.x) * HUCRE, 0, (h.y - orta.y) * HUCRE)


func alan_merkezi(h: Vector2i, boyut: Vector2i) -> Vector3:
	return hucre_kosesi(h) + Vector3(boyut.x, 0, boyut.y) * HUCRE * 0.5


## Ekrandaki noktanın altındaki hücre (zemin düzlemi); ızgara dışındaysa (-1, -1).
func isaret(ekran: Vector2) -> Vector2i:
	var bas := kamera.project_ray_origin(ekran)
	var yon_ := kamera.project_ray_normal(ekran)
	if absf(yon_.y) < 0.0001:
		return Vector2i(-1, -1)
	var t := -bas.y / yon_.y
	if t < 0:
		return Vector2i(-1, -1)
	var p := bas + yon_ * t
	var orta := Vector2(yonetim.a.meydan.position) + Vector2(yonetim.a.meydan.size) / 2.0
	var h := Vector2i(floori(p.x / HUCRE + orta.x), floori(p.z / HUCRE + orta.y))
	return h if yonetim.izgara.icinde(h) else Vector2i(-1, -1)


## Hayalet önizleme (6.2): `boyut` hücrelik temel, uygunsa yeşil, değilse kırmızı. Boyut sıfırsa gizlenir.
func hayalet(h: Vector2i, boyut: Vector2i, uygun: bool) -> void:
	_hayalet.visible = boyut != Vector2i.ZERO and h.x >= 0
	if not _hayalet.visible:
		return
	(_hayalet.mesh as BoxMesh).size = Vector3(boyut.x * HUCRE - 0.15, 0.6, boyut.y * HUCRE - 0.15)
	_hayalet.position = alan_merkezi(h, boyut) + Vector3(0, 0.3, 0)
	_hayalet_malzeme.albedo_color = UYGUN if uygun else UYGUNSUZ


func secim_goster(b: KoyBinasi) -> void:
	_secim.visible = b != null
	if b == null:
		return
	var boy := b.boyut(yonetim.katalog)
	(_secim.mesh as BoxMesh).size = Vector3(boy.x * HUCRE + 0.3, 3.5, boy.y * HUCRE + 0.3)
	_secim.position = alan_merkezi(b.hucre, boy) + Vector3(0, 1.75, 0)


# ── Kurulum ───────────────────────────────────────────────────────────────────────────────────────

## Sahneyi köy yönetiminden yeniden kurar (yapı kurulunca, yıkılınca, atama değişince).
func yenile() -> void:
	for c in _yapilar.get_children():
		c.queue_free()
	_ates_isigi = null
	# Yollar ve meydan zemini arazinin splat maskesinde çizilir (organik kenar, tek zemin).
	arazi.maske_guncelle()
	arazi.kuruluk_ayarla(KURULUK[clampi(yonetim.mevsim(), 0, KURULUK.size() - 1)])
	_meydan_kur()
	CenazeMezari.kur(self, _yapilar)
	OlayYapilari.kur(self, _yapilar)
	ToplulukDekoru.kur(self, _yapilar)
	BinaAvluEsyalari.cevre_kur(self, _yapilar)
	TasYatagiGorseli.kur(self, _yapilar)
	for b in yonetim.binalar:
		var n := _bina_dugumu(b)
		var gorsel_yon := _yola_gore_yon(b)
		n.position = alan_merkezi(b.hucre, b.boyut(yonetim.katalog))
		n.rotation_degrees.y = 90.0 * gorsel_yon
		n.set_meta("bina_id", b.id)
		n.set_meta(&"gorsel_yon", gorsel_yon)
		_yapilar.add_child(n)
	var ek_hayvan := preload("res://src/koy/ticaret/ek_hayvan_pazari.gd")
	ek_hayvan.sahne_hayvanlarini_kur(self, _yapilar)
	var kopek_gerekli := ek_hayvan.toplam_ek(yonetim) > 0 or yonetim.lojistik.sayi() > 0 or yonetim.binalar.any(func(b: KoyBinasi) -> bool: return b.hazir() and b.tur in ["agil", "ahir", "muhafiz_kislasi"])
	if kopek_gerekli:
		HazirEsyaHayvan.kopek_kur(_yapilar, Vector3(kapi_noktasi().x + 2.0, 0, kapi_noktasi().y - 2.0))
	_sur_kur()
	OduncuRutini.orman_kur(self, _yapilar)
	MuhafizDevriyesi.kule_kur(self, _yapilar)
	halk_hareketi.yenile()
	DivanZindanGorseli.kur(self, _yapilar)
	IklimGorseli.uygula(self)
	_gece_isiklarini_guncelle(atmosfer.faz_adi, 0.0)


func _yola_gore_yon(b: KoyBinasi) -> int:
	if b.yon != 0:
		return b.yon
	var boy := b.boyut(yonetim.katalog)
	var merkez := Vector2(b.hucre) + Vector2(boy) * 0.5
	var hedef_nokta := Vector2(yonetim.a.meydan.position) + Vector2(yonetim.a.meydan.size) * 0.5
	var en_yakin := INF
	for h in yonetim.izgara.yollar:
		var d := merkez.distance_squared_to(Vector2(h) + Vector2(0.5, 0.5))
		if d < en_yakin:
			en_yakin = d
			hedef_nokta = Vector2(h) + Vector2(0.5, 0.5)
	var fark := hedef_nokta - merkez
	if boy.x != boy.y:
		return 0 if fark.y >= 0.0 else 2
	if absf(fark.y) >= absf(fark.x):
		return 0 if fark.y >= 0.0 else 2
	return 1 if fark.x >= 0.0 else 3


func _gece_isiklarini_guncelle(ad: StringName, sure: float) -> void:
	var enerji := 0.0 if ad == &"gunduz" else (1.15 if ad == &"aksam" else 1.65)
	for n in _yapilar.find_children("*", "OmniLight3D", true, false):
		var isik := n as OmniLight3D
		if isik == null or not isik.has_meta(&"gece_isigi"):
			continue
		isik.light_color = Color("#FF9A40")
		if sure <= 0.0 or not is_inside_tree():
			isik.light_energy = enerji
			isik.visible = enerji > 0.0
		else:
			isik.visible = true
			var tw := create_tween()
			tw.tween_property(isik, "light_energy", enerji, sure)
			if enerji <= 0.0:
				tw.tween_callback(func() -> void:
					if is_instance_valid(isik):
						isik.visible = false
				)


func _meydan_kur() -> void:
	var m := yonetim.a.meydan
	var orta := alan_merkezi(m.position, m.size)
	var kuyu := KapiKuyuAyari.kuyu()
	kuyu.position = SulamaRutini.kuyu_konumu(self)
	_yapilar.add_child(kuyu)
	# Meydan ateşi (9.1: akşam köylüler kandil ve ateş başında).
	var ocak := Node3D.new()
	ocak.position = AtesBasiRutini.konum(self)
	if Dunya3B.model_var_mi("nobet_ocagi"):
		ocak.add_child(Dunya3B.nesne("nobet_ocagi", 0.9))
	else:
		for i in 7:
			var tas := MeshInstance3D.new()
			var s := SphereMesh.new()
			s.radius = 0.22
			s.height = 0.3
			tas.mesh = s
			var a := TAU * i / 7.0
			tas.position = Vector3(cos(a), 0.1, sin(a)) * 0.65
			tas.material_override = Pbr.malzeme("aerial_rocks_02", 1.0)
			ocak.add_child(tas)
	var alev: Node3D = HazirAtesEfektleri.olustur("ocak", 1.1, 24)
	if alev == null:
		alev = KapiManzarasi.alev(1.1, 1.0, 3)
	alev.position.y = 0.5
	ocak.add_child(alev)
	_ates_isigi = OmniLight3D.new()
	_ates_isigi.light_color = Color("#ff9a4a")
	_ates_isigi.light_energy = atmosfer.ates_gucu
	_ates_isigi.omni_range = float(preload("res://data/ayarlar/sahne.json").data.ates_isik.menzil)
	_ates_isigi.position = Vector3(0, 1.2, 0)
	_ates_isigi.shadow_enabled = true
	ocak.add_child(_ates_isigi)
	_yapilar.add_child(ocak)


func _sur_kur() -> void:
	var b := yonetim.a.izgara_boyut
	var kose := hucre_kosesi(Vector2i.ZERO)
	var uc := hucre_kosesi(b)
	var kp := kapi_noktasi()
	var kapi_x := kp.x
	var kapi_ad := "kapi"
	var kapi_kat := "yapi"
	var kapi_boy := 3.6 + yonetim.sur_seviye * 0.5
	if yonetim.sur_seviye <= 1 and Dunya3B.model_var_mi("td_o25"):
		kapi_ad = "td_o25"
		kapi_kat = ""
		kapi_boy = 3.4
	elif yonetim.sur_seviye >= 3 and Dunya3B.model_var_mi("td_o92"):
		kapi_ad = "td_o92"
		kapi_kat = ""
		kapi_boy = 3.8
	var kapi := Dunya3B.nesne(kapi_ad, kapi_boy, kapi_kat)
	kapi.name = "sur_kapisi_" + kapi_ad
	SurHasarGorseli.uygula(kapi, yonetim.sur_hasar)
	kapi.add_to_group(&"koy_kapisi")
	kapi.position = Vector3(kapi_x, arazi.yukseklik_burada(kapi_x, kp.y), kp.y)
	_yapilar.add_child(kapi)
	Dunya3B.mesale_kur(_yapilar, kapi.position + Vector3(-2.6, 0, 0.4), 2.0, 8.0)
	if yonetim.sur_seviye <= 0:
		return
	# Sur: S1 O37 kazık → S2 O81/sur_2_palisat → S3 O90/sur_3_tas.
	var sur_ad := "kazik_cit"
	var sur_kat := ""
	var boy := 2.4
	if yonetim.sur_seviye == 2:
		if Dunya3B.model_var_mi("td_o81"):
			sur_ad = "td_o81"
			boy = 2.8
		elif Dunya3B.model_var_mi("sur_2_palisat", "yapi"):
			sur_ad = "sur_2_palisat"
			sur_kat = "yapi"
			boy = 2.8
	elif yonetim.sur_seviye >= 3:
		if Dunya3B.model_var_mi("td_o90"):
			sur_ad = "td_o90"
			boy = 3.1
		elif Dunya3B.model_var_mi("sur_3_tas", "yapi"):
			sur_ad = "sur_3_tas"
			sur_kat = "yapi"
			boy = 3.2
	var aralik := 4.0
	var kenarlar := [[Vector3(kose.x, 0, kose.z), Vector3(uc.x, 0, kose.z)], [Vector3(uc.x, 0, kose.z), Vector3(uc.x, 0, uc.z)],
		[Vector3(uc.x, 0, uc.z), Vector3(kose.x, 0, uc.z)], [Vector3(kose.x, 0, uc.z), Vector3(kose.x, 0, kose.z)]]
	for k in kenarlar:
		var a: Vector3 = k[0]
		var c: Vector3 = k[1]
		var n := int(a.distance_to(c) / aralik)
		for i in n:
			var p := a.lerp(c, (i + 0.5) / n)
			if absf(p.x - kapi_x) < 3.0 and absf(p.z - uc.z) < 0.5:
				continue
			var parca := Dunya3B.nesne(sur_ad, boy, sur_kat)
			parca.name = "sur_" + sur_ad
			SurHasarGorseli.uygula(parca, yonetim.sur_hasar)
			parca.position = p
			var d := (c - a).normalized()
			parca.rotation.y = atan2(d.x, d.z) + PI * 0.5
			OrnekYigini.duragan_kil(parca)
			_yapilar.add_child(parca)


## Bir yapının görünümü (seçili Meshy GLB / açık ahır yer tutucusu / inşaat kademesi); MegaKit GLB'yi gizlemez.
func _bina_dugumu(b: KoyBinasi) -> Node3D:
	var boy := b.boyut(yonetim.katalog)
	var en := boy.x * HUCRE
	var derin := boy.y * HUCRE
	var n := Node3D.new()
	if not b.hazir():
		InsaatKademesiGorseli.insa_kur(n, b, yonetim.katalog, en, derin, func(govde: Node3D) -> void:
			_tam_bina_govdesi(govde, b, en, derin)
		)
		return n
	_tam_bina_govdesi(n, b, en, derin)
	InsaatKademesiGorseli.hasar_uygula(n, yonetim, b)
	HazirEsyaHayvan.bina(n, b.tur, en, derin)
	ZanaatTezgahi.kur(n, b.tur, en, derin)
	AtolyeParcaciklari.kur(self, n, b)
	CelepHayvanGorseli.kur(self, n, b)
	KarakterHavaTepkisi.sacak_kur(self, n, b)
	BinaAvluEsyalari.bina_ekle(n, b.tur, en, derin)
	return n


func _tam_bina_govdesi(n: Node3D, b: KoyBinasi, en: float, derin: float) -> void:
	var max_en := en * 0.80
	var max_derin := derin * 0.80
	if b.tur == "cozumleme_odasi":
		preload("res://src/koy/gorsel/cozumleme_oda_yer_tutucu.gd").kur(n, en, derin)
		return
	if b.tur == GozcuKulesi.TUR:
		GozcuKulesiGorseli.kur(n, b.seviye)
		return
	if b.tur == "ahir":
		InsaatKademesiGorseli.ahir_yer_tutucu(n, en, derin)
		return
	var yapi_ad := OlayYapilari.yapi_adi_seviyeli(b.tur, b.seviye)
	if b.tur != "kulube" and b.tur not in ["tarla", "bostan", "degirmen", "agil"] and Dunya3B.model_var_mi(yapi_ad, "yapi"):
		var glb := Dunya3B.sigdir(yapi_ad, OlayYapilari.yukseklik(yapi_ad, 2.8), "yapi", max_en, max_derin)
		glb.name = "meshy_" + yapi_ad
		n.add_child(glb)
		return
	if HazirKoyYapilari.kur(n, b.tur, en, derin):
		return
	match b.tur:
		"cadir":
			n.add_child(Dunya3B.sigdir("cadir", 2.3, "yapi", max_en, max_derin))
		"kulube":
			n.add_child(Dunya3B.sigdir("ev", 2.9, "yapi", max_en, max_derin))
		"tarla", "bostan":
			_tarla(n, en, derin)
			if Dunya3B.model_var_mi(b.tur):
				var tb := Dunya3B.sigdir(b.tur, 0.45 if b.tur == "bostan" else 0.3, "", max_en, max_derin)
				tb.position.y = 0.04
				n.add_child(tb)
			SulamaRutini.ark_kur(n, en, derin)
		"hizarhane", "odunluk":
			_sundurma(n, en * 0.8, derin * 0.7, 2.6)
			var kutuk := Pbr.model("dead_tree_trunk_02")
			if kutuk != null:
				kutuk.scale = Vector3.ONE * 0.6
				kutuk.position = Vector3(en * 0.25, 0, derin * 0.3)
				n.add_child(kutuk)
		"tas_ocagi":
			for i in 3:
				var kaya := Pbr.model("boulder_01" if i < 2 else "rock_moss_set_01")
				if kaya != null:
					kaya.scale = Vector3.ONE * (1.1 - i * 0.25)
					kaya.position = Vector3((i - 1) * 1.2, 0, (i % 2) * 0.8 - 0.4)
					n.add_child(kaya)
			for i in 4:
				_kutu(n, Vector3(0.6, 0.4, 0.45), Vector3(-en * 0.3 + i * 0.65, 0.2, derin * 0.35), Pbr.malzeme("castle_wall_varriation", 1.5))
		"avci":
			n.add_child(Dunya3B.sigdir("cadir", 2.0, "yapi", max_en, max_derin))
			_kutu(n, Vector3(0.08, 1.6, 0.08), Vector3(en * 0.35, 0.8, -derin * 0.3), Pbr.malzeme("bark_willow", 1.0))
			_kutu(n, Vector3(0.08, 1.6, 0.08), Vector3(en * 0.35, 0.8, derin * 0.3), Pbr.malzeme("bark_willow", 1.0))
			_kutu(n, Vector3(0.06, 0.06, derin * 0.6), Vector3(en * 0.35, 1.5, 0), Pbr.malzeme("bark_willow", 1.0))
		"atolye", "demirhane":
			_sundurma(n, en * 0.85, derin * 0.75, 2.4)
			var sandik := Pbr.model("wooden_crate_01")
			if sandik != null:
				sandik.position = Vector3(-en * 0.3, 0, derin * 0.32)
				n.add_child(sandik)
		"degirmen":
			var d := DegirmenHareketi.new()
			d.sahne = self
			d.bina_id = b.id
			n.add_child(d)
			d.kur(en, derin)
		"agil":
			if Dunya3B.model_var_mi("agil", "yapi"):
				var ag := Dunya3B.sigdir("agil", 1.8, "yapi", max_en, max_derin)
				ag.name = "meshy_agil"
				n.add_child(ag)
				CobanSurusu.agil_kapi_kur(n, en, derin)
			else:
				CobanSurusu.agil_kur(n, en, derin)
		_:
			_kutu(n, Vector3(en * 0.8, 1.5, derin * 0.8), Vector3(0, 0.75, 0), Pbr.malzeme("medieval_wood", 2.0))
			HazirSahneModeli.etiket(n, b.tur.replace("_", " ").capitalize(), 1.8)


func _iskele(n: Node3D, en: float, derin: float) -> void:
	var ahsap := Pbr.malzeme("medieval_wood", 2.0, Color(0.85, 0.8, 0.7))
	_kutu(n, Vector3(en * 0.85, 0.25, derin * 0.85), Vector3(0, 0.125, 0), Pbr.malzeme("castle_wall_varriation", 2.0))
	for x in [-1, 1]:
		for z in [-1, 1]:
			_kutu(n, Vector3(0.12, 2.6, 0.12), Vector3(x * en * 0.4, 1.3, z * derin * 0.4), ahsap)
	for y in [1.2, 2.4]:
		_kutu(n, Vector3(en * 0.82, 0.08, 0.1), Vector3(0, y, derin * 0.4), ahsap)
		_kutu(n, Vector3(en * 0.82, 0.08, 0.1), Vector3(0, y, -derin * 0.4), ahsap)
		_kutu(n, Vector3(0.1, 0.08, derin * 0.82), Vector3(en * 0.4, y, 0), ahsap)
		_kutu(n, Vector3(0.1, 0.08, derin * 0.82), Vector3(-en * 0.4, y, 0), ahsap)


func _sundurma(n: Node3D, en: float, derin: float, boy: float) -> void:
	var ahsap := Pbr.malzeme("medieval_wood", 2.0)
	for x in [-1, 1]:
		for z in [-1, 1]:
			_kutu(n, Vector3(0.18, boy, 0.18), Vector3(x * en * 0.45, boy * 0.5, z * derin * 0.45), ahsap)
	var dam := _kutu(n, Vector3(en, 0.14, derin), Vector3(0, boy, 0), Pbr.malzeme("bark_willow", 2.0))
	dam.rotation_degrees.x = 8.0


## Tarla: sürülmüş toprak ve sıra sıra ekin; kışın çıplak ve kırağılı (mevsim, 4.3).
func _tarla(n: Node3D, en: float, derin: float) -> void:
	var toprak := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(en - 0.3, derin - 0.3)
	toprak.mesh = p
	toprak.material_override = Pbr.malzeme("brown_mud_leaves_01", 2.0, Color(0.75, 0.68, 0.6))
	toprak.position.y = 0.04
	n.add_child(toprak)
	if yonetim.kis_mi():
		return
	# Ekin sapları: tek MultiMesh (tek çizim çağrısı).
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var sap := BoxMesh.new()
	sap.size = Vector3(0.05, 0.7 if yonetim.mevsim() >= 1 else 0.35, 0.05)
	mm.mesh = sap
	var sira := int((derin - 0.6) / 0.45)
	var sutun := int((en - 0.6) / 0.22)
	mm.instance_count = sira * sutun
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	var i := 0
	for r in sira:
		for c in sutun:
			var t := Transform3D(Basis(Vector3.UP, rng.randf() * TAU).rotated(Vector3.RIGHT, rng.randf_range(-0.15, 0.15)),
				Vector3(-en * 0.5 + 0.3 + c * 0.22 + rng.randf() * 0.08, sap.size.y * 0.5 + 0.04, -derin * 0.5 + 0.3 + r * 0.45))
			mm.set_instance_transform(i, t)
			i += 1
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	mi.material_override = Dunya3B.duz_malzeme(Color("#b89a4a") if yonetim.mevsim() >= 1 else Color("#6f7a3a"))
	n.add_child(mi)


func _kutu(kok: Node3D, boyut: Vector3, konum: Vector3, mat: Material) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.material_override = mat
	m.position = konum
	kok.add_child(m)
	return m


