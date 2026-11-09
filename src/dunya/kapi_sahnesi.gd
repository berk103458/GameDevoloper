## Kapı sahnesi (3D): muhafızın gözünden açık kapı, meşale, yol ve kuyruk. Gecenin kuyruğu yolda
## sıra hâlinde bekler: sırası gelen kuyruğun başından çıkıp kapıya yürür, arkadakiler birer adım ilerler (öndekinden
## başlayan bir dalga), sisin içinden yeni biri kuyruğun sonuna katılır. Kapının önünde duran sorgulanır; kabul edilen
## içeri (kameranın yanından), reddedilen kuyruğun yanından yola geri döner.
class_name KapiSahnesi
extends Node3D

const DURMA := Vector3(0.0, 0.0, -2.5)
## Kameranın görüş açısı (dikey, derece).
const GORUS := 46.0
## Kuyruk boşken (yalnız yedek) gelenin çıktığı yer: kuyruğun başının da gerisi, sisin içi.
const BASLANGIC := Vector3(0.0, 0.0, -14.0)
## Kuyruğun başından kapıya yürüyüş hızı (m/s): yorgun ama istekli bir adım (~3.5 s).
const YAKLASMA_HIZI := 1.6
## Arkadakilerin bir yer ilerleme hızı (m/s) ve her birinin öndekinden sonra kıpırdama gecikmesi (s).
const ILERLEME_HIZI := 1.15
const ILERLEME_GECIKMESI := 0.35
## Kuyrukta görünen en çok kişi; gerisi yolun uzağında bekler, sıra ilerledikçe sisten çıkıp gelir.
const KUYRUK_GORUNEN := 6
## Kuyruk yerlerinin yol üzerindeki başlangıcı ve aralığı (yol_noktasi parametresi; ~1.3 m aralık).
const KUYRUK_BAS := 0.06
const KUYRUK_ARA := 0.016
## Kuyruğa katılan yeni kişinin geldiği yer: son yerden bu kadar yer geride (sisin içinde, görünmez başlar).
const KATILMA_UZAKLIGI := 6
## Sisten çıkma / sise karışma süresi (s).
const BELIRME_SURESI := 1.6
const ICERI := Vector3(1.9, 0.0, 2.5)
## Reddedilen kuyruğun solundan yürür (kuyruğun içinden geçmez); bu yol parametresinde sise karışıp gider.
const DONUS_YANI := -1.9
const DONUS_SON := 0.22

## Kapıyı ve manzarayı belirleyen durum (KapiEkrani sahneyi eklemeden önce oturumdan doldurur).
var gece := 0
var perde := 1
var sur := 0
## 2. perde: Tekfur'un yakınlığı 0..1.
var yakinlik := 0.0
## Kapı nöbeti gündüz (Faz 1); gece görünümü gece olayları için kalır.
var gunduz := true

var kamera: Camera3D
var _kamera_gecisi: KapiKameraGecisi
var manzara: KapiManzarasi
var cerceve: KapiCercevesi
var _okuz: Node3D
var _gelen: KarakterModel
## Gelenin ayağının dibine konan heybe (arama sırasında).
var _heybe: Node3D
var _isiklar: Array[OmniLight3D] = []
## Kuyrukta bekleyen figürler ve yerleri (sıra olayları bunları canlandırır).
var _kuyruktakiler: Array[KarakterModel] = []
var _kuyruk_yerleri: Array[Vector3] = []
## Görünen kuyruğun gerisinde bekleyenlerin model adları (sırayla); sıra ilerledikçe kuyruğa katılırlar.
var _bekleyenler: Array[String] = []
## Görünenlerin model adları (`_kuyruktakiler` ile aynı sırada): sıradaki gelenle eşleşmezse model değiştirilir.
var _kuyruk_adlari: Array[String] = []
var _zaman := 0.0


func _ready() -> void:
	Dunya3B.ortam_kur(self, 0.012)
	manzara = KapiManzarasi.new()
	manzara.gece = gece
	manzara.perde = perde
	manzara.yakinlik = yakinlik
	manzara.gunduz = gunduz
	add_child(manzara)
	cerceve = KapiCercevesi.new()
	cerceve.seviye = sur
	add_child(cerceve)
	_isiklar.append_array(cerceve.isiklar)
	var golge_profili := preload("res://src/dunya/kapi_golge_profili.gd").new()
	golge_profili.isiklar = _isiklar
	add_child(golge_profili)
	_kagni_kur()
	kamera = Camera3D.new()
	# Bekçinin yeri: kapının biraz gerisinde; iki direk ve meşaleler kadrajın kenarlarında (arayüzün solunda) kalır.
	kamera.position = Vector3(0.0, 1.62, 3.0)
	kamera.fov = GORUS
	add_child(kamera)
	kamera.look_at(Vector3(0.0, 1.35, -6.0))
	_kamera_gecisi = KapiKameraGecisi.new()
	_kamera_gecisi.kamera = kamera
	_kamera_gecisi.taban_konum = kamera.position
	add_child(_kamera_gecisi)
	_ortam_ayarla()


func ayak_zemini_yuksekligi(konum: Vector3) -> float:
	var nokta := to_local(konum)
	nokta.y = KapiManzarasi.yukseklik(nokta.x, nokta.z)
	var taban := to_global(nokta).y
	# Manzaradaki figürler, kapı çerçevesinden önce kurulabilir.
	return maxf(taban, cerceve.esik_yuksekligi(konum)) if is_instance_valid(cerceve) else taban


func _process(delta: float) -> void:
	_zaman += delta
	# Öküz: arada başını sallar gibi hafifçe öne eğilip kalkar.
	if _okuz != null:
		_okuz.rotation.x = 0.03 * maxf(0.0, sin(_zaman * 0.7)) * sin(_zaman * 3.1)
	for i in _isiklar.size():
		var l := _isiklar[i]
		var taban: float = l.get_meta("taban")
		# Meşale titremesi: sert adımlar, yumuşak değil (ışık alanı canlı kalır).
		l.light_energy = taban * (0.88 + 0.12 * sin(_zaman * 9.0 + i * 2.1) * sin(_zaman * 3.3 + i))


## Sıradaki kişi kuyruğun başından çıkıp kapıya yürür; arkadakiler birer yer ilerler. `model_adi`: gelenin modeli
## (kuyruğun başındakiyle aynı olmalı; değilse — kuyruk kurulmadıysa — sisten yeni biri gelir).
func gelen_yaklas(model_adi: String) -> void:
	if _gelen != null:
		_gelen.queue_free()
		_gelen = null
	var bastaki: KarakterModel = null
	if not _kuyruktakiler.is_empty() and _kuyruk_adlari[0] != model_adi:
		# Kuyruk gecenin listesiyle kayışmışsa baştaki, gelecek kişinin modeliyle yerinde değiştirilir.
		var yeni := Dunya3B.karakter(model_adi)
		yeni.transform = _kuyruktakiler[0].transform
		add_child(yeni)
		_kuyruktakiler[0].queue_free()
		_kuyruktakiler[0] = yeni
		_kuyruk_adlari[0] = model_adi
	if not _kuyruktakiler.is_empty():
		bastaki = _kuyruktakiler.pop_front()
		_kuyruk_adlari.pop_front()
		_kuyruk_yerleri.pop_back()
	if bastaki == null:
		KapiFirtinaKuyrugu.uzaktakini_al(self)
		bastaki = Dunya3B.karakter(model_adi)
		bastaki.position = BASLANGIC + Vector3(0, KapiManzarasi.yukseklik(BASLANGIC.x, BASLANGIC.z), 0)
		add_child(bastaki)
		bastaki.gorunurluk(0.0)
		_belir(bastaki, 1.0)
	_gelen = bastaki
	# Bastaki yerinden ayrılır ayrılmaz arkası kıpırdar; gelen yürürken kuyruk da ilerler.
	_kuyruk_ilerle()
	await _gelen.yuru(DURMA, YAKLASMA_HIZI)
	if _gelen == bastaki:
		await _gelen.don(kamera.position)


## Gecenin kuyruğunu kurar: `adlar` sıradaki gelenlerin model adları (önden arkaya). İlk `KUYRUK_GORUNEN` kişi
## yolda sıra hâlinde durur, gerisi uzakta bekler. Önceki kuyruk varsa kaldırılır.
func kuyruk_doldur(adlar: Array) -> void:
	for k in _kuyruktakiler:
		k.queue_free()
	_kuyruktakiler.clear()
	_kuyruk_yerleri.clear()
	_kuyruk_adlari.clear()
	_bekleyenler.clear()
	for i in adlar.size():
		var ad := String(adlar[i])
		if i >= KapiFirtinaKuyrugu.kapasite(self):
			_bekleyenler.append(ad)
			continue
		var k := Dunya3B.karakter(ad)
		k.position = kuyruk_yeri(i)
		add_child(k)
		k.bak(kuyruk_yeri(i - 1) + _sapma(i))
		_kuyruktakiler.append(k)
		_kuyruk_adlari.append(ad)
		_kuyruk_yerleri.append(k.position)


## Kuyruğun `i`. yeri (0: en ön). Yolun üstünde, ikişer hafif yana kayık (düz bir çizgi değil, insan sırası).
static func kuyruk_yeri(i: int) -> Vector3:
	var p := KapiManzarasi.yol_noktasi(KUYRUK_BAS + i * KUYRUK_ARA)
	var x := p.x - 0.35 + posmod(i, 2) * 0.55 + sin(i * 2.3) * 0.12
	return Vector3(x, KapiManzarasi.yukseklik(x, p.z - 3.0), p.z - 3.0)


## Kuyrukta bekleyenin baktığı yere küçük bir sapma: herkes aynı noktaya kilitlenmiş gibi durmaz.
func _sapma(i: int) -> Vector3:
	return Vector3(sin(i * 1.7) * 0.9, 0, 0)


## Kuyrukta görünen kişi sayısı (x) ve uzakta bekleyen sayısı (y).
func kuyruk_sayilari() -> Vector2i:
	return Vector2i(_kuyruktakiler.size(), _bekleyenler.size())


## Kuyruğu ilerletir: her kişi kendi yerine yürür, öndekinden biraz sonra (dalga). Eksik yer varsa uzakta bekleyen
## biri sisin içinden çıkıp sonuna katılır.
func _kuyruk_ilerle() -> void:
	while _kuyruktakiler.size() < KapiFirtinaKuyrugu.kapasite(self) and not _bekleyenler.is_empty():
		var ad: String = _bekleyenler.pop_front()
		var k := Dunya3B.karakter(ad)
		k.position = kuyruk_yeri(_kuyruktakiler.size() + KATILMA_UZAKLIGI)
		add_child(k)
		k.gorunurluk(0.0)
		_kuyruktakiler.append(k)
		_kuyruk_adlari.append(ad)
		_kuyruk_yerleri.append(k.position)
	for i in _kuyruktakiler.size():
		_kuyruk_yerleri[i] = kuyruk_yeri(i)
		_yerine_yuru(_kuyruktakiler[i], i * ILERLEME_GECIKMESI)


func _yerine_yuru(k: KarakterModel, gecikme: float) -> void:
	if gecikme > 0.0:
		await get_tree().create_timer(gecikme).timeout
	if not is_instance_valid(k) or not _kuyruktakiler.has(k):
		return
	if absf(k.rotation.x) > 0.01:
		# Bayılıp yerde kalan: önce doğrulur.
		var t := create_tween()
		t.tween_property(k, "rotation:x", 0.0, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await t.finished
	var hedef := kuyruk_yeri(_kuyruktakiler.find(k))
	if k.position.distance_to(hedef) > 2.5:
		_belir(k, 1.0)
	await k.yuru(hedef, ILERLEME_HIZI)
	var j := _kuyruktakiler.find(k)
	if j >= 0 and k.position.distance_to(kuyruk_yeri(j)) < 0.05:
		k.don(kuyruk_yeri(j - 1) + _sapma(j))


## Görünürlüğü `hedef`e `BELIRME_SURESI` içinde götürür (sisten çıkma / sise karışma).
func _belir(k: KarakterModel, hedef: float) -> void:
	var t := k.create_tween()
	t.tween_method(k.gorunurluk, 1.0 - hedef, hedef, BELIRME_SURESI)
	await t.finished


## Gelen konuşuyor (cevap verirken): Meshy konuşma klibi varsa `sure` saniye oynar.
func gelen_konus(sure: float) -> void:
	if _gelen != null:
		_gelen.konus(sure)


## Gelenin bu Meshy hareketi var mı.
func gelen_hareket_var(ad: String) -> bool:
	return _gelen != null and _gelen.hareket_var(ad)


## Sorgu sıkıştı: gelen gerginleşir (klip varsa).
func gelen_gergin() -> void:
	if _gelen != null:
		_gelen.gergin()

## CHR panik adaptörü; mevcut duygu/klip önbelleği kullanılır.
func gelen_panik() -> void:
	if _gelen != null:
		_gelen.duygu(&"ofke")


## Karar sonrası: kaldıysa içeri, gittiyse yola. `tehlikeli`: retde öfke, değilse yıkılma.
func gelen_git(kaldi: bool, tehlikeli: bool = true) -> void:
	if is_instance_valid(_heybe):
		_heybe.queue_free()
	_heybe = null
	if _gelen == null:
		return
	var g := _gelen
	_gelen = null
	# Giden kişi yürümeye devam eder; sahne onu beklemez, kısa bir süre sonra sıradaki gelir.
	_ayril(g, kaldi, tehlikeli)
	await get_tree().create_timer(2.6).timeout


func _ayril(g: KarakterModel, kaldi: bool, tehlikeli: bool = true) -> void:
	# Önce tepki: kabulde şükran; retde kötü niyetli öfkelenir, masum diz çöker. Sonra yürür.
	await g.duygu(&"sevinc" if kaldi else (&"ofke" if tehlikeli else &"panik"))
	if not is_instance_valid(g):
		return
	if kaldi:
		await g.yuru(Vector3(1.6, 0, -0.5))
		if is_instance_valid(g):
			await g.yuru(ICERI)
	else:
		# Kuyruğun yanından geri döner; kuyruğun içinden geçmez, uzakta sise karışır.
		var noktalar: Array[Vector3] = []
		for t: float in [KUYRUK_BAS, KUYRUK_BAS + 0.05, KUYRUK_BAS + 0.1, DONUS_SON]:
			var p := KapiManzarasi.yol_noktasi(t)
			noktalar.append(Vector3(p.x + DONUS_YANI, 0, p.z - 3.0))
		for i in noktalar.size():
			if not is_instance_valid(g):
				return
			if i == noktalar.size() - 1:
				_belir(g, 0.0)
			await g.yuru(noktalar[i])
	if is_instance_valid(g):
		g.queue_free()


## Kameranın bakış noktası ve görüş açısı (sıra olayında kuyruğa döner).
const BAKIS_KAPI := Vector3(0.0, 1.35, -6.0)
const BAKIS_KUYRUK := Vector3(-0.1, 1.1, -14.0)
var _bakis := BAKIS_KAPI


## Kamerayı kuyruğa çevirip yakınlaştırır (true) ya da kapıya döndürür (false).
func kuyruga_bak(evet: bool) -> void:
	await _kamera_gecisi.kuyruk(_bakis_ayarla, _bakis, BAKIS_KUYRUK if evet else BAKIS_KAPI, 28.0 if evet else GORUS)


func _bakis_ayarla(v: Vector3) -> void:
	_bakis = v
	kamera.look_at(v)


## Sıra olayı canlandırması (ilk aşama): olay oynar. `anahtar`: atlama, kavga, bayilma, vazgecme, panik.
func sira_olayi_baslat(anahtar: String) -> void:
	var n := _kuyruktakiler.size()
	var kisi_i := SiraOlayiKisisi.indeks(anahtar, n)
	if kisi_i < 0:
		return
	await kuyruga_bak(true)
	match anahtar:
		"atlama":
			var k := _kuyruktakiler[kisi_i]
			await k.yuru(Vector3(0.9, 0, -9.6), 3.4)
			k.bak(kamera.position)
		"kavga":
			var a := _kuyruktakiler[kisi_i]
			var b := _kuyruktakiler[1]
			a.bak(b.position)
			b.bak(a.position)
			for tur in 2:
				a.duygu(&"ofke")
				b.duygu(&"ofke")
				var t := create_tween().set_parallel()
				t.tween_property(a, "position", a.position + (b.position - a.position).normalized() * 0.35, 0.18)
				t.tween_property(b, "position", b.position + (a.position - b.position).normalized() * 0.2, 0.18)
				t.chain().tween_property(a, "position", _kuyruk_yerleri[0], 0.25)
				await get_tree().create_timer(0.9).timeout
		"bayilma":
			var k := _kuyruktakiler[kisi_i]
			var t := create_tween()
			t.tween_property(k, "rotation:x", deg_to_rad(-82.0), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			await t.finished
		"vazgecme":
			var k := _kuyruktakiler[kisi_i]
			await k.yuru(k.position + Vector3(0.3, 0, -4.5), 2.4)
		"panik":
			_kuyruktakiler[kisi_i].duygu(&"ofke")
			for k in _kuyruktakiler:
				k.bak(k.position + Vector3(0, 0, -10))
			await get_tree().create_timer(1.2).timeout


## Sıra olayının ikinci aşaması: seçilen seçeneğe göre biter. `etki`: seçeneğin etki sözlüğü.
func sira_olayi_bitir(anahtar: String, etki: Dictionary) -> void:
	var n := _kuyruktakiler.size()
	var kisi_i := SiraOlayiKisisi.indeks(anahtar, n)
	if kisi_i < 0:
		return
	var geri: bool = etki.get("geri", false)
	match anahtar:
		"atlama":
			if geri:
				await _kuyruktakiler[kisi_i].yuru(_kuyruk_yerleri[kisi_i], 2.0)
				_kuyruktakiler[kisi_i].bak(Vector3(0, 0, 10))
		"kavga":
			_kuyruktakiler[0].bak(Vector3(0, 0, 10))
			_kuyruktakiler[1].bak(Vector3(0, 0, 10))
		"bayilma":
			await SiraOlayiSonucu.canlandir(self, kisi_i, etki)
		"vazgecme":
			var k := _kuyruktakiler[kisi_i]
			if geri:
				await k.yuru(_kuyruk_yerleri[kisi_i], 1.6)
				k.bak(Vector3(0, 0, 10))
			else:
				_kuyruktakiler.remove_at(kisi_i)
				_kuyruk_yerleri.remove_at(kisi_i)
				_kuyruk_adlari.remove_at(kisi_i)
				# Boşalan yere uzakta bekleyen biri gelir; vazgeçen yola dönüp sise karışır.
				_kuyruk_ilerle()
				_belir(k, 0.0)
				await k.yuru(k.position + Vector3(0, 0, -16.0), 1.6)
				if is_instance_valid(k):
					k.queue_free()
		"panik":
			for k in _kuyruktakiler:
				k.bak(Vector3(0, 0, 10))
	await kuyruga_bak(false)


## Gelen heybesini önüne koyar: deri torba ve kapağı, yere konur gibi belirir.
func heybe_koy() -> void:
	if _gelen == null or is_instance_valid(_heybe):
		return
	_heybe = Node3D.new()
	# Torba: basık küre gövde, üstte devrik kapak ve askı.
	var govde := MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 0.16
	k.height = 0.26
	govde.mesh = k
	govde.scale = Vector3(1.0, 0.85, 0.7)
	govde.position.y = 0.11
	govde.material_override = Dunya3B.duz_malzeme(Color("#6b4630"))
	_heybe.add_child(govde)
	var kapak := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(0.24, 0.02, 0.16)
	kapak.mesh = b
	kapak.position = Vector3(0, 0.2, -0.1)
	kapak.rotation_degrees.x = -60
	kapak.material_override = Dunya3B.duz_malzeme(Color("#4a2f1f"))
	_heybe.add_child(kapak)
	_heybe.position = _gelen.position + Vector3(0.42, 0, 0.12)
	_heybe.scale = Vector3.ONE * 0.2
	add_child(_heybe)
	create_tween().tween_property(_heybe, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Karar panelinde kamera geri durur, sorgu/ayrılışta taban konumuna döner.
func daralt(icerden: bool) -> void:
	await _kamera_gecisi.karar(icerden, GORUS, _bakis_ayarla, _bakis, BAKIS_KAPI)


## Sinematik gece ışığı (Forward+): HDRI gökyüzü, ay ışığı, hacimsel sis (meşale ışığı sisin içinde huzme yapar),
## ortam gölgesi (SSAO), dolaylı ışık (SSIL), AgX ton eşleme, soğuk-sıcak renk ayarı ve uzak alan bulanıklığı.
## Compatibility çiziciyle açılırsa desteklenmeyen ayarlar yok sayılır; sahne yine düzgün görünür.
func _ortam_ayarla() -> void:
	for n in get_children():
		if n is WorldEnvironment:
			var env := (n as WorldEnvironment).environment
			if gunduz:
				_gunduz_ortami(env)
				continue
			var hdri := Pbr.gok(KapiManzarasi.GOK)
			if hdri != null:
				var gok := PanoramaSkyMaterial.new()
				gok.panorama = hdri
				gok.energy_multiplier = 0.7
				var sky := Sky.new()
				sky.sky_material = gok
				sky.radiance_size = Sky.RADIANCE_SIZE_256
				env.background_mode = Environment.BG_SKY
				env.sky = sky
				env.sky_rotation = Vector3(0, deg_to_rad(200.0), 0)
				env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
				env.ambient_light_sky_contribution = 0.85
				env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
			env.ambient_light_color = Color("#2c3c5c")
			env.ambient_light_energy = 0.5
			env.tonemap_mode = Environment.TONE_MAPPER_AGX
			env.tonemap_exposure = 1.5
			# Uzak sis: tepeler ve ufuk soğuk maviye karışır.
			env.fog_enabled = true
			env.fog_mode = Environment.FOG_MODE_EXPONENTIAL
			env.fog_light_color = Color("#16213a")
			env.fog_light_energy = 0.9
			env.fog_density = 0.006
			env.fog_sky_affect = 0.25
			env.fog_aerial_perspective = 0.4
			# Hacimsel sis: meşalelerin çevresinde sıcak ışık hüzmesi, yakın planda nem.
			env.volumetric_fog_enabled = true
			env.volumetric_fog_density = 0.018
			env.volumetric_fog_albedo = Color("#8796b8")
			env.volumetric_fog_length = 48.0
			env.volumetric_fog_anisotropy = 0.35
			env.volumetric_fog_ambient_inject = 0.15
			env.ssao_enabled = true
			env.ssao_radius = 1.2
			env.ssao_intensity = 2.2
			env.ssil_enabled = true
			env.ssil_intensity = 0.8
			env.glow_enabled = true
			env.glow_intensity = 0.45
			env.glow_bloom = 0.0
			env.glow_hdr_threshold = 1.3
			# Yalnız küçük yarıçaplı ışıma katmanları: alevin çevresinde dar hale, ekranı kaplayan pus yok.
			for k in range(1, 8):
				env.set("glow_levels/%d" % k, 1.0 if k <= 3 else 0.0)
			# Renk ayarı: hafif kontrast, doygunluk biraz düşük (savaş sonrası, soğuk gece).
			env.adjustment_enabled = true
			env.adjustment_contrast = 1.08
			env.adjustment_saturation = 0.88
		elif n is DirectionalLight3D and gunduz:
			var gunes := n as DirectionalLight3D
			gunes.light_color = Color("#fff0da")
			gunes.light_energy = 2.0
			gunes.light_volumetric_fog_energy = 0.3
			gunes.rotation_degrees = Vector3(-38, 140, 0)
			gunes.shadow_enabled = true
			gunes.directional_shadow_max_distance = 80.0
			gunes.shadow_blur = 1.2
		elif n is DirectionalLight3D:
			var ay := n as DirectionalLight3D
			ay.light_color = Color("#9fb4e6")
			ay.light_energy = 0.32
			ay.light_volumetric_fog_energy = 0.6
			ay.rotation_degrees = Vector3(-24, 155, 0)
			ay.shadow_enabled = true
			ay.directional_shadow_max_distance = 60.0
			ay.shadow_blur = 1.5
	# Kamera: uzak alan çok hafif bulanık (gözü gelene çeker), sabit pozlama.
	var nitelik := CameraAttributesPractical.new()
	nitelik.dof_blur_far_enabled = true
	nitelik.dof_blur_far_distance = 45.0
	nitelik.dof_blur_far_transition = 40.0
	nitelik.dof_blur_amount = 0.04
	kamera.attributes = nitelik


## Gündüz ortamı: bulutlu öğle göğü, ılık güneş, hafif pus; meşaleler gündüz sönük yanar.
func _gunduz_ortami(env: Environment) -> void:
	var hdri := Pbr.gok(KapiManzarasi.GOK_GUNDUZ)
	if hdri != null:
		var gok := PanoramaSkyMaterial.new()
		gok.panorama = hdri
		gok.energy_multiplier = 1.0
		var sky := Sky.new()
		sky.sky_material = gok
		sky.radiance_size = Sky.RADIANCE_SIZE_256
		env.background_mode = Environment.BG_SKY
		env.sky = sky
		env.sky_rotation = Vector3(0, deg_to_rad(120.0), 0)
		env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
		env.ambient_light_sky_contribution = 1.0
		env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	env.ambient_light_energy = 0.9
	env.tonemap_mode = Environment.TONE_MAPPER_AGX
	env.tonemap_exposure = 1.0
	env.fog_enabled = true
	env.fog_mode = Environment.FOG_MODE_EXPONENTIAL
	env.fog_light_color = Color("#a9b6c4")
	env.fog_light_energy = 1.0
	env.fog_density = 0.004
	env.fog_sky_affect = 0.15
	env.fog_aerial_perspective = 0.6
	env.volumetric_fog_enabled = true
	env.volumetric_fog_density = 0.005
	env.volumetric_fog_albedo = Color("#d8dde4")
	env.volumetric_fog_length = 64.0
	env.ssao_enabled = true
	env.ssao_radius = 1.2
	env.ssao_intensity = 1.6
	env.ssil_enabled = true
	env.ssil_intensity = 0.6
	env.glow_enabled = true
	env.glow_intensity = 0.25
	env.glow_hdr_threshold = 1.6
	env.adjustment_enabled = true
	env.adjustment_contrast = 1.06
	env.adjustment_saturation = 0.92
	for l in _isiklar:
		l.set_meta("taban", float(l.get_meta("taban")) * 0.3)


## Sağ orta planda öküzlü kağnı: yükü bir ailenin bütün evi (çuval, sandık, testi, yorgan).
func _kagni_kur() -> void:
	var araba := Dunya3B.nesne("araba", 1.7)
	araba.position = Vector3(1.9, 0, -12.5)
	araba.rotation.y = deg_to_rad(-100)
	add_child(araba)
	var yuk := Node3D.new()
	yuk.position = araba.position + Vector3(0, 1.0, 0)
	yuk.rotation.y = araba.rotation.y
	add_child(yuk)
	var renkler := [Color("#6b5a40"), Color("#4a3a2c"), Color("#5c4a5a"), Color("#7a6a4a")]
	for i in 5:
		var m := MeshInstance3D.new()
		if i % 2 == 0:
			var k := SphereMesh.new()
			k.radius = 0.35
			k.height = 0.55
			m.mesh = k
		else:
			var b := BoxMesh.new()
			b.size = Vector3(0.6, 0.45, 0.5)
			m.mesh = b
		m.position = Vector3(-0.7 + i * 0.35, 0.25 + (i % 2) * 0.15, (i % 3 - 1) * 0.3)
		m.material_override = Dunya3B.duz_malzeme(renkler[i % renkler.size()])
		yuk.add_child(m)
	if Dunya3B.model_var_mi("okuz"):
		_okuz = Dunya3B.nesne("okuz", 1.55)
		_okuz.position = araba.position + Vector3(-0.6, 0, 2.6)
		_okuz.rotation.y = araba.rotation.y + PI
		add_child(_okuz)


func _kutu(boyut: Vector3, konum: Vector3, mat: Material) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.position = konum
	m.material_override = mat
	add_child(m)
	return m
