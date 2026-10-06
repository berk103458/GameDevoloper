## Köylünün günlük programı (durum makinesi): işe gider, çalışır, meydanda oturur, evine döner, uyur.
## Kararlar `KoyluYoneticisi` tarafından dilimlenerek verilir (karede birkaç köylü); yürüme her karede
## hafiftir. Konum ve animasyon kaydedilmez: köy açılınca herkes saate uygun yerinden başlar.
class_name KoyluAI
extends Node

enum Durum { UYKUDA, ISE_GIDERKEN, CALISIYOR, DINLENMEDE, MEYDANDA }

## Kişi kaydı (`KoyNufusu.kisiler` öğesi) ve köydeki sırası.
var kisi: Dictionary = {}
var sira := 0
var govde: KarakterModel
var durum: Durum = Durum.ISE_GIDERKEN
## {tur, konum} — `KoyYerlesimi.is_yeri`.
var is_yeri: Dictionary = {}
var ev_kapisi := Vector3.ZERO
var hiz := 1.6
## Yumuşak ayrışma itmesi (yönetici hesaplar).
var itme := Vector3.ZERO

var _yol := PackedVector3Array()
var _yol_i := 0
var _bakis := Vector3.ZERO
var _is_bitis := 18.4
var _eve_donus := 20.0
var _nobetci_gece := false
var _meydan: MeydanAlani
var _nav: KoyNavigasyon
var _calisiyor_anim := false
## Kapıdan köye yeni giriyor (ilk yürüyüş bitene dek).
var _kapidan := false


## Köylüyü kurar. `rng` kişiye özgü sapmaları (hız, saatler) belirler.
func kur(govde_: KarakterModel, kisi_: Dictionary, sira_: int, y: KoyYerlesimi, nav: KoyNavigasyon,
		meydan: MeydanAlani, ayar: KoyGorunumAyarlari, ruh: float, rng: RandomNumberGenerator) -> void:
	govde = govde_
	kisi = kisi_
	sira = sira_
	_nav = nav
	_meydan = meydan
	is_yeri = y.is_yeri(kisi["sinif"], sira)
	ev_kapisi = y.ev_kapisi(sira)
	hiz = ayar.yurume_hizi * rng.randf_range(1.0 - ayar.hiz_sapmasi, 1.0 + ayar.hiz_sapmasi) * ruh
	_is_bitis = ayar.is_bitis_saati + rng.randf_range(-0.5, 0.5)
	_eve_donus = ayar.eve_donus_saati + rng.randf_range(-0.4, 0.6)
	_nobetci_gece = kisi["sinif"] == &"asker" and sira % 2 == 0
	govde.alet_tak(_alet())


## Saatin istediği durum (yürüyerek değil, doğrudan): köy açılışında yerleştirme için.
func yerlestir(saat: float) -> void:
	var d := _istenen(saat)
	durum = d
	match d:
		Durum.ISE_GIDERKEN, Durum.CALISIYOR:
			durum = Durum.CALISIYOR
			govde.position = is_yeri["konum"]
			_calis()
		Durum.MEYDANDA:
			govde.position = _meydan.yuva_al(self)
			_bakis = KoyYerlesimi.MEYDAN
			govde.bak(_bakis)
		Durum.DINLENMEDE, Durum.UYKUDA:
			durum = Durum.UYKUDA
			govde.position = ev_kapisi
			govde.visible = false


## Yeni gelen: kapıdan girer, önce evinin önüne yürür, sonra programına katılır.
func kapidan_gir(kapi: Vector3) -> void:
	govde.position = kapi
	durum = Durum.DINLENMEDE
	_kapidan = true
	_git(ev_kapisi)


## Dilimlenmiş karar adımı.
func karar_ver(saat: float) -> void:
	var istenen := _istenen(saat)
	if durum == Durum.DINLENMEDE and not _yol_bitti():
		return  # eve ya da kapıdan evine yürüyor; varınca karar verir
	if istenen == durum and (istenen != Durum.ISE_GIDERKEN or not _yol_bitti()):
		return
	match istenen:
		Durum.ISE_GIDERKEN, Durum.CALISIYOR:
			if durum != Durum.ISE_GIDERKEN and durum != Durum.CALISIYOR:
				govde.visible = true
				durum = Durum.ISE_GIDERKEN
				_git(is_yeri["konum"])
			elif durum == Durum.ISE_GIDERKEN and _yol_bitti():
				durum = Durum.CALISIYOR
				_calis()
		Durum.MEYDANDA:
			if durum != Durum.MEYDANDA:
				_birak()
				govde.visible = true
				durum = Durum.MEYDANDA
				_bakis = KoyYerlesimi.MEYDAN
				_git(_meydan.yuva_al(self))
		Durum.DINLENMEDE, Durum.UYKUDA:
			if durum == Durum.UYKUDA:
				return
			if durum == Durum.DINLENMEDE and _yol_bitti():
				durum = Durum.UYKUDA
				govde.visible = false
				return
			_birak()
			_meydan.yuva_birak(self)
			durum = Durum.DINLENMEDE
			_git(ev_kapisi)


## Her karede: yol boyunca yürür, itmeyi uygular.
func ilerle(delta: float) -> void:
	if not govde.visible:
		return
	if _yol_bitti():
		if itme.length_squared() > 0.0001:
			govde.position += itme * delta
			itme = itme.move_toward(Vector3.ZERO, delta * 2.0)
		return
	var hedef := _yol[_yol_i]
	var fark := hedef - govde.position
	fark.y = 0.0
	var adim := hiz * delta
	if fark.length() <= adim:
		govde.position = Vector3(hedef.x, 0, hedef.z)
		_yol_i += 1
		if _yol_bitti():
			govde.dur()
			if _bakis != Vector3.ZERO:
				govde.bak(_bakis)
			if durum == Durum.ISE_GIDERKEN:
				durum = Durum.CALISIYOR
				_calis()
		return
	var yon := fark.normalized()
	govde.position += yon * adim + itme * delta
	itme = itme.move_toward(Vector3.ZERO, delta * 2.0)
	# Yumuşak dönüş.
	var hedef_aci := atan2(yon.x, yon.z)
	govde.rotation.y = lerp_angle(govde.rotation.y, hedef_aci, clampf(delta * 8.0, 0.0, 1.0))
	govde.yurume_oynat(hiz)


## Kartta gösterilecek iş adı anahtarı (`arayuz.koylu.is.<tur>`).
func is_anahtari() -> String:
	return "arayuz.koylu.is." + String(is_yeri["tur"])


## Kartta gösterilecek durum anahtarı (`arayuz.koylu.durum.<ad>`).
func durum_anahtari() -> String:
	if _kapidan and durum == Durum.DINLENMEDE and not _yol_bitti():
		return "arayuz.koylu.durum.geliyor"
	_kapidan = false
	return "arayuz.koylu.durum." + (Durum.keys()[durum] as String).to_lower()


func _istenen(saat: float) -> Durum:
	if _nobetci_gece:
		return Durum.CALISIYOR
	if saat < _is_bitis:
		return Durum.CALISIYOR
	if saat < _eve_donus:
		return Durum.MEYDANDA
	return Durum.UYKUDA


func _git(hedef: Vector3) -> void:
	_birak()
	_yol = _nav.yol(govde.position, hedef)
	_yol_i = 0


func _yol_bitti() -> bool:
	return _yol_i >= _yol.size()


func _calis() -> void:
	_bakis = Vector3.ZERO
	var tur: StringName = is_yeri["tur"]
	match tur:
		&"tarla": govde.bak(govde.position + Vector3(1, 0, 0))
		&"odun": govde.bak(KoyYerlesimi.ODUNLUK)
		&"tas": govde.bak(KoyYerlesimi.TAS_OCAGI)
		&"nobet": govde.bak(govde.position + Vector3(0, 0, -5))
		_: govde.bak(KoyYerlesimi.MEYDAN)
	if tur != &"nobet" and tur != &"pazar":
		govde.salla(true, 0.8 + (sira % 3) * 0.12)
		_calisiyor_anim = true


func _birak() -> void:
	if _calisiyor_anim:
		govde.salla(false)
		_calisiyor_anim = false


func _alet() -> String:
	match is_yeri["tur"]:
		&"tarla": return "tool-hoe"
		&"odun": return "tool-axe"
		&"tas": return "tool-pickaxe"
		&"atolye": return "tool-hammer"
	return ""
