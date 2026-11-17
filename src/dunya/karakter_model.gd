## Yürüyebilen karakter: Meshy iskeletli modeli, yürüme animasyonu ve durma animasyonu.
## Durma: dinlenme pozundan kurulan "bekle" animasyonu + DurusDuzeltici (nefes, ağırlık aktarma, bakış).
## DurusDuzeltici her iki durumda da kolları indirir, bileği düzeltir ve avucu bacağa çevirir.
## Meshy hareketleri: `<ad>_<hareket>.glb` varsa (bekle, konus, sevinc, ofke, panik, gergin) animasyonu kitaplığa
## eklenir ve prosedürel hareketin yerine o oynar; bekleme dışındaki kliplerde DurusDuzeltici susar (kolları klip belirler).
## Üretim: tools/model/meshy_uret.py (hareket adları tools/model/chr_istemleri.py).
class_name KarakterModel
extends Node3D

const YURUME_HIZI := 1.9  # m/s (oyun temposu için gerçekten biraz hızlı)
const BEKLE := "bekle"
## Bekleme ve diğer hareketlere geçiş süresi (s).
const GECIS := 0.3
const HAREKETLER := ["bekle", "konus", "sevinc", "ofke", "panik", "gergin"]
const DONGULU := ["bekle", "konus", "gergin"]
## Bir klip dosyasının izlerinin en az bu payı bu iskelette çözülmeli; yoksa klip alınmaz.
const IZ_ESIGI := 0.8
## Dönüş süresi (s): yürümeye başlarken ve bir şeye bakarken gövde bu sürede döner.
const DONUS_SURESI := 0.45

var _oynatici: AnimationPlayer
var _anim: String = ""
var _duzeltici: DurusDuzeltici
var _bekleme_hedef := 1.0
## Yüklenen Meshy hareketleri: hareket adı → kitaplıktaki animasyon adı (`m_<hareket>`).
var _klipler: Dictionary = {}
var _duzeltici_hedef := 1.0
var _klip_sirasi := 0
## Süren yürüyüş: yeni bir yürüyüş eskisini keser (iki hareket aynı anda konumu çekiştirmez).
var _yurume: Tween
var _hareket_bandi := "dur"
## Köyün gezinme aralığı için görsel kök adımını süzebilir.
var rota_adimi: Callable
var _rota_ilerlemesi := 0.0
## Görünürlük önbelleği (`gorunurluk`): boyanan parçalar ve fener ışıklarının taban güçleri.
var _parcalar: Array[GeometryInstance3D] = []
var _gorunurluk := 1.0

## Klip dosyalarından çıkarılan animasyonlar (yol → Animation); aynı karakterin kopyaları paylaşır.
static var _klip_onbellek: Dictionary = {}


## `ad`: model adı; `<ad>_<hareket>.glb` dosyaları bununla aranır.
func kur(model: Node3D, ad: String = "") -> void:
	if model == null:
		var m := MeshInstance3D.new()
		var c := CapsuleMesh.new()
		c.radius = 0.28
		c.height = 1.7
		m.mesh = c
		m.position.y = 0.85
		m.material_override = Dunya3B.duz_malzeme(Renkler.SOGUK_MAVI)
		add_child(m)
		return
	add_child(model)
	var ap := model.find_children("*", "AnimationPlayer", true, false)
	if ap.is_empty():
		return
	_oynatici = ap[0]
	_anim = preload("res://src/dunya/guvenli_karakter_animasyonu.gd").ilk(_oynatici)
	if _anim.is_empty():
		return
	_oynatici.get_animation(_anim).loop_mode = Animation.LOOP_LINEAR
	var sk := model.find_children("*", "Skeleton3D", true, false)
	if not sk.is_empty():
		var iskelet := sk[0] as Skeleton3D
		_bekle_animasyonu_kur(iskelet)
		_duzeltici = DurusDuzeltici.new()
		_duzeltici.faz = randf() * 20.0
		_duzeltici.bekleme = 1.0
		iskelet.add_child(_duzeltici)
		AyakZemini.kur(self, model, iskelet)
	if ad != "":
		_klipleri_yukle(ad)
	dur()


func _process(delta: float) -> void:
	if _duzeltici != null:
		_duzeltici.bekleme = move_toward(_duzeltici.bekleme, _bekleme_hedef, delta / GECIS)
		_duzeltici.influence = move_toward(_duzeltici.influence, _duzeltici_hedef, delta / GECIS)


## Hedefe yürür (dünya konumu), yüzünü yürüdüğü yöne çevirir.
func yuru(hedef: Vector3, hiz: float = YURUME_HIZI, durum: StringName = &"") -> void:
	hiz = absf(hiz)
	var band := HareketGecisi.tablo_bandi(hiz)
	if band == "dur":
		yurumeyi_durdur()
		return
	var fark := hedef - position
	fark.y = 0.0
	if fark.length() < 0.01:
		return
	if _yurume != null and _yurume.is_valid():
		_yurume.kill()
	_hareket_bandi = "kos" if band == "kos" and HareketGecisi.kosu_izni(durum) else "yuru"
	if is_instance_valid(_oynatici):
		var gercek_klip := HareketGecisi.tablo_klibi(_hareket_bandi)
		var guvenli := preload("res://src/dunya/guvenli_karakter_animasyonu.gd")
		if _hareket_bandi == "yuru" and not guvenli.var_mi(_oynatici, gercek_klip):
			gercek_klip = _anim
		if guvenli.var_mi(_oynatici, gercek_klip):
			var taban_hiz := HareketGecisi.kosu_taban_hizi() if _hareket_bandi == "kos" else _yuruyus_taban_hizi()
			# Klip temposu karışım süresini değiştirmesin.
			_oynatici.speed_scale = 1.0
			_oynatici.play(gercek_klip, HareketGecisi.yuruyus_gecisi_suresi(), hiz / taban_hiz)
		else:
			guvenli.dur(_oynatici, _anim, 0.0)
	_bekleme_hedef = 0.0
	_duzeltici_hedef = 1.0
	_klip_sirasi += 1
	# Gövde yürüyüş yönüne yumuşakça döner (yerinde fırıldak gibi değil); yürüyüşün ilk adımlarıyla birlikte.
	var t := create_tween().set_parallel()
	t.tween_property(self, "rotation:y", _hedef_aci(fark), DONUS_SURESI).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if rota_adimi.is_valid():
		_rota_ilerlemesi = 0.0
		var kok_hizi := _rotada_yatay_hiz(hedef, hiz)
		t.tween_method(_rota_ilerlet.bind(hedef), 0.0, fark.length(), fark.length() / kok_hizi)
	else:
		t.tween_property(self, "position", hedef, fark.length() / hiz)
	_yurume = t
	await t.finished
	if is_inside_tree() and _yurume == t:
		dur()


func hareket_bandi() -> String:
	return _hareket_bandi


func _rotada_yatay_hiz(hedef: Vector3, hiz: float) -> float:
	var ayak := get_node_or_null("AyakZemini") as AyakZemini
	var zemin := ayak.zemin_olcer() if ayak != null else Callable()
	if not zemin.is_valid():
		return hiz
	var ust := get_parent_node_3d()
	var bas := global_position
	var son := ust.to_global(hedef) if ust != null else hedef
	var yatay := Vector2(son.x - bas.x, son.z - bas.z).length()
	var yukselti := float(zemin.call(son)) - float(zemin.call(bas))
	return hiz * HareketGecisi.yokus_carpani(rad_to_deg(atan2(yukselti, yatay)))


func _rota_ilerlet(ilerleme: float, hedef: Vector3) -> void:
	var metre := ilerleme - _rota_ilerlemesi
	_rota_ilerlemesi = ilerleme
	if metre > 0.0:
		position = rota_adimi.call(hedef, metre)


func _yuruyus_taban_hizi() -> float:
	return 1.35


## Yeni rota veya iptal için konum tween'ini durdurur ve bekleme pozuna geçer.
func yurumeyi_durdur(karisimi_kes: bool = false) -> void:
	if _yurume != null and _yurume.is_valid():
		_yurume.kill()
	_yurume = null
	if karisimi_kes and is_instance_valid(_oynatici):
		_oynatici.stop()
	dur()


## Durur: "bekle" animasyonuna yumuşak geçiş; nefes ve kıpırtıyı DurusDuzeltici verir.
func dur() -> void:
	_hareket_bandi = "dur"
	_bekleme_hedef = 1.0
	if not is_instance_valid(_oynatici):
		return
	_oynatici.speed_scale = 1.0
	var bekle := HareketGecisi.tablo_klibi("dur")
	if hareket_var(bekle):
		_klip_oynat(bekle)
		return
	_duzeltici_hedef = 1.0
	if _oynatici.has_animation(bekle):
		_oynatici.play(bekle, GECIS)
	else:
		preload("res://src/dunya/guvenli_karakter_animasyonu.gd").dur(_oynatici, _anim, GECIS)


## Sürekli iş hareketini açar/kapatır (&"calis" ya da &"").
func calis(ad: StringName) -> void:
	if _duzeltici != null:
		_duzeltici.surekli = ad
		if ad == &"":
			_duzeltici.duygu = &""


## Anlık duygu hareketi (&"sevinc" / &"ofke" / &"panik"); süresi kadar bekler.
## Meshy klibi varsa o oynar. Eksik klipte çağıran beklemeyi seçebilir, varsayılan prosedürel tepkidir.
func duygu(ad: StringName, eksikte_bekle: bool = false) -> void:
	if hareket_var(String(ad)):
		var sira := _klip_oynat(String(ad))
		var uzunluk := _oynatici.get_animation(_klipler[String(ad)]).length
		await get_tree().create_timer(clampf(uzunluk * 0.9, 0.6, 3.0)).timeout
		if is_inside_tree() and sira == _klip_sirasi:
			dur()
		return
	if _duzeltici == null:
		dur()
		return
	if eksikte_bekle:
		_duzeltici.duygu = &""
		dur()
	else:
		_duzeltici.duygu_baslat(&"ofke" if ad == &"panik" else ad)
	await get_tree().create_timer(_duzeltici.duygu_suresi * 0.8).timeout


## Konuşma hareketi `sure` saniye (klip yoksa bir şey yapmaz); sonra beklemeye döner.
func konus(sure: float) -> void:
	if not hareket_var("konus"):
		dur()
		return
	var sira := _klip_oynat("konus")
	await get_tree().create_timer(sure).timeout
	if is_inside_tree() and sira == _klip_sirasi:
		dur()


## Gerginlik (sorgu sıkıştıkça): döngülü klip; yoksa bir şey yapmaz. Bekleme yerine geçer.
func gergin() -> void:
	if hareket_var("gergin"):
		_klip_oynat("gergin")
	else:
		dur()


## Bu hareketin Meshy klibi yüklü mü.
func hareket_var(ad: String) -> bool:
	return is_instance_valid(_oynatici) and _klipler.has(ad) and preload("res://src/dunya/guvenli_karakter_animasyonu.gd").var_mi(_oynatici, _klipler[ad])


func _klip_oynat(ad: String) -> int:
	_klip_sirasi += 1
	if not hareket_var(ad):
		dur()
		return _klip_sirasi
	# Meshy'nin bekleme klibi kolları A-pozundan açık bırakır: DurusDuzeltici kolları indirip eli düzeltir.
	# Diğer kliplerde (konuşma, eğilme, öfke, diz çökme) kolları klip belirler.
	_duzeltici_hedef = 1.0 if ad == "bekle" else 0.0
	_oynatici.speed_scale = 1.0
	_oynatici.play(_klipler[ad], GECIS)
	return _klip_sirasi


## `<ad>_<hareket>.glb` dosyalarındaki animasyonu bu oynatıcının kitaplığına ekler. İzleri bu iskelette
## çözülmeyen klip alınmaz (başka bir iskeletten gelmiş olabilir).
func _klipleri_yukle(ad: String) -> void:
	if _oynatici == null:
		return
	var kok := _oynatici.get_node_or_null(_oynatici.root_node)
	if kok == null:
		return
	var kitap: AnimationLibrary = _oynatici.get_animation_library(&"") if _oynatici.has_animation_library(&"") else null
	if kitap == null:
		kitap = AnimationLibrary.new()
		_oynatici.add_animation_library(&"", kitap)
	for h: String in HAREKETLER:
		var yol := Dunya3B.hareket_yolu(ad, h)
		if yol == "":
			continue
		var adi := "m_" + h
		if not kitap.has_animation(adi):
			var anim := _klip_al(yol)
			if anim == null or not _izler_cozulur(anim, kok):
				continue
			anim = anim.duplicate()
			if h == "bekle":
				_sakin_bekle_yatistir(anim)
			anim.loop_mode = Animation.LOOP_LINEAR if h in DONGULU else Animation.LOOP_NONE
			kitap.add_animation(adi, anim)
		_klipler[h] = adi


## CIL-23: Boşta kalça/kök salınımını bastırır (`<= 2 cm / sn`), canlı nefes ve yavaş bakışı DurusDuzeltici'ya bırakır.
static func _sakin_bekle_yatistir(anim: Animation) -> void:
	for i in anim.get_track_count():
		var tur := anim.track_get_type(i)
		var sub := String(anim.track_get_path(i).get_concatenated_subnames())
		var k_say := anim.track_get_key_count(i)
		if k_say <= 1:
			continue
		if tur == Animation.TYPE_POSITION_3D and sub in ["Hips", "Pelvis", "Root"]:
			var p0: Vector3 = anim.track_get_key_value(i, 0)
			for k in k_say:
				anim.track_set_key_value(i, k, p0)
		elif tur == Animation.TYPE_ROTATION_3D and sub in ["Hips", "Spine", "Spine01", "Spine02", "neck", "Head", "LeftUpLeg", "RightUpLeg"]:
			var r0: Quaternion = anim.track_get_key_value(i, 0)
			for k in k_say:
				var rk: Quaternion = anim.track_get_key_value(i, k)
				anim.track_set_key_value(i, k, rk.slerp(r0, 0.92))


static func _klip_al(yol: String) -> Animation:
	if _klip_onbellek.has(yol):
		var kayit: Variant = _klip_onbellek[yol]
		return kayit if kayit is Animation else null
	if not ResourceLoader.exists(yol):
		_klip_onbellek[yol] = null
		return null
	var anim: Animation = null
	var kaynak := load(yol)
	if kaynak is Animation:
		_klip_onbellek[yol] = kaynak
		return kaynak
	var sahne := kaynak as PackedScene
	if sahne != null:
		var n := sahne.instantiate()
		var ap := n.find_children("*", "AnimationPlayer", true, false)
		if not ap.is_empty():
			var o := ap[0] as AnimationPlayer
			var liste := o.get_animation_list()
			if not liste.is_empty():
				anim = o.get_animation(liste[0])
		n.free()
	_klip_onbellek[yol] = anim
	return anim


func _izler_cozulur(anim: Animation, kok: Node) -> bool:
	var toplam := 0
	var cozulen := 0
	for i in anim.get_track_count():
		var yol := anim.track_get_path(i)
		toplam += 1
		var dugum := kok.get_node_or_null(NodePath(String(yol.get_concatenated_names())))
		if dugum is Skeleton3D:
			if (dugum as Skeleton3D).find_bone(String(yol.get_concatenated_subnames())) >= 0:
				cozulen += 1
		elif dugum != null:
			cozulen += 1
	return toplam > 0 and float(cozulen) / toplam >= IZ_ESIGI


## Duruş düzelticisi (avuç ölçüsü için); iskeletsiz modelde null.
func duzeltici() -> DurusDuzeltici:
	return _duzeltici


## Bir noktaya döner (Y ekseninde).
func bak(nokta: Vector3) -> void:
	var f := nokta - position
	f.y = 0.0
	if f.length() > 0.01:
		look_at(position + f, Vector3.UP, true)


## Bir noktaya yumuşakça döner (Y ekseninde, `DONUS_SURESI` içinde). Sahne kurulurken `bak`, oyun sırasında bu.
func don(nokta: Vector3) -> void:
	var f := nokta - position
	f.y = 0.0
	if f.length() <= 0.01:
		return
	var t := create_tween()
	t.tween_property(self, "rotation:y", _hedef_aci(f), DONUS_SURESI).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await t.finished


## `yon` doğrultusuna bakan Y açısı; şimdiki açıdan kısa yoldan (en çok yarım tur).
func _hedef_aci(yon: Vector3) -> float:
	var aci := atan2(yon.x, yon.z)
	return rotation.y + wrapf(aci - rotation.y, -PI, PI)


## Görünürlük 0..1: uzakta sise karışan ya da sisten çıkan kişi ani belirmez, yavaşça görünür olur.
func gorunurluk(deger: float) -> void:
	deger = clampf(deger, 0.0, 1.0)
	if is_equal_approx(deger, _gorunurluk):
		return
	_gorunurluk = deger
	if _parcalar.is_empty():
		for n in find_children("*", "GeometryInstance3D", true, false):
			_parcalar.append(n as GeometryInstance3D)
		for n in find_children("*", "OmniLight3D", true, false):
			n.set_meta("taban", (n as OmniLight3D).light_energy)
	for p in _parcalar:
		if is_instance_valid(p):
			p.transparency = 1.0 - deger
			p.visible = deger > 0.01
	for n in find_children("*", "OmniLight3D", true, false):
		(n as OmniLight3D).light_energy = float(n.get_meta("taban", 1.0)) * deger


## Yürüme animasyonunun izlerini kullanarak dinlenme pozunda duran döngülü "bekle" animasyonu kurar.
## Aynı modelin kopyaları kitaplığı paylaşır; bir kez kurulur.
func _bekle_animasyonu_kur(sk: Skeleton3D) -> void:
	if _oynatici.has_animation(BEKLE):
		return
	var yuru_anim := _oynatici.get_animation(_anim)
	var a := Animation.new()
	a.length = 2.0
	a.loop_mode = Animation.LOOP_LINEAR
	for i in yuru_anim.get_track_count():
		var tur := yuru_anim.track_get_type(i)
		if tur != Animation.TYPE_ROTATION_3D and tur != Animation.TYPE_POSITION_3D:
			continue
		var yol := yuru_anim.track_get_path(i)
		var kemik := sk.find_bone(String(yol.get_concatenated_subnames()))
		if kemik < 0:
			continue
		var dinlenme := sk.get_bone_rest(kemik)
		var iz := a.add_track(tur)
		a.track_set_path(iz, yol)
		if tur == Animation.TYPE_ROTATION_3D:
			a.rotation_track_insert_key(iz, 0.0, dinlenme.basis.get_rotation_quaternion())
		else:
			a.position_track_insert_key(iz, 0.0, dinlenme.origin)
	var kitap: AnimationLibrary = _oynatici.get_animation_library(&"") if _oynatici.has_animation_library(&"") else null
	if kitap == null:
		kitap = AnimationLibrary.new()
		_oynatici.add_animation_library(&"", kitap)
	kitap.add_animation(BEKLE, a)
