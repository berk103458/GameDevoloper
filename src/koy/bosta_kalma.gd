## ISG-03: mevcut moral alanına yazılan tek günlük boşta bedeli.
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/bosta_kalma.json"))

static func _tam(v: Variant, alt: int, ust: int) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= ust

static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or not _tam(v.get("gun"), 0, int(AYAR.terk_gun)) or not _tam(v.get("son_gece"), 0, 1000000000):
		return {}
	return {"gun": int(v.gun), "son_gece": int(v.son_gece)}

static func uygun(y: KoyYonetimi, k: Koylu) -> bool:
	if y == null or k == null or k.saglik <= 0 or k.yas_grubu != &"yetiskin":
		return false
	if YasamBarlari.oyuncu_mu(k) or k.bayrak_var("acl01_es"):
		return false
	if SaglikYoneticisi.hasta(k) or KisHastaligi.hasta(k) or KarantinaYoneticisi.aktif(k):
		return false
	if "hasta" in k.bayraklar + k.gizli_bayraklar or "agir_yarali" in k.bayraklar + k.gizli_bayraklar:
		return false
	if DivanHukmu.zindanda(k) or KervanKorumasi.disarida(y, k.id):
		return false
	var nobet := KapiNobeti.durum(y)
	if KapiNobeti.yuva(y) == k.id or int(nobet.eslik) == k.id:
		return false
	return k.is_yeri == KoyYonetimi.BOSTA and GeciciIsler.secili(k).is_empty()

static func sayi(y: KoyYonetimi) -> int:
	var n := 0
	for k in y.koylular:
		if uygun(y, k): n += 1
	return n

static func gunler(y: KoyYonetimi, k: Koylu) -> int:
	if not uygun(y, k): return 0
	var d := oku(k.bosta_kalma)
	if d.is_empty() or int(d.son_gece) not in [y.gun - 1, y.gun]:
		return 0
	return int(d.gun)

static func sifirla(y: KoyYonetimi, id: int) -> void:
	var k := y.koylu(id)
	if k != null and not k.bosta_kalma.is_empty():
		k.bosta_kalma["gun"] = 0

static func gece(y: KoyYonetimi, calismalar: Dictionary) -> void:
	if not y.son.is_empty(): return
	var mevsim := MevsimYoneticisi.durum(y)
	var bedel := roundi(float(AYAR.moral_kaybi) * float(mevsim.bosta_moral_carpani))
	for k in y.koylular:
		var once := oku(k.bosta_kalma)
		if int(once.get("son_gece", -1)) == y.gun:
			continue
		var gun := 0
		if uygun(y, k) and not calismalar.has(k.id):
			var eski := int(once.get("gun", 0)) if int(once.get("son_gece", -1)) == y.gun - 1 else 0
			gun = mini(int(AYAR.terk_gun), eski + 1)
			k.moral = maxi(0, k.moral - bedel)
		k.bosta_kalma = {"gun": gun, "son_gece": y.gun}

static func sohbet_satiri(y: KoyYonetimi, k: Koylu) -> String:
	if k == null or k.zanaat_turu == ZanaatTuru.Tur.BELIRSIZ or gunler(y, k) < int(AYAR.terk_gun):
		return ""
	return TranslationServer.translate("koy.bosta.terk")
