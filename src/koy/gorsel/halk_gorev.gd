## LimboAI görevi. Ekonomi ve gece üretimine yazmaz; yalnız görünen davranışı seçer.
extends BTAction

@export var kip: String = ""


func _tick(_delta: float) -> Status:
	var halk := _halk()
	if halk == null:
		return FAILURE
	var id := int(_deger("id", -1))
	var tur := String(_deger("tur", "koylu"))
	match kip:
		"alarm":
			return SUCCESS if _alarm(halk) else FAILURE
		"alarm_tepki":
			_bayrak(halk, id, "alarm")
			var d: Dictionary = halk._durum.get(id, {})
			if not d.is_empty():
				d["yol"] = []
				d["adim"] = 0
				d["bekle"] = maxf(float(d.get("bekle", 0.0)), 3.0)
			return SUCCESS
		"gece":
			return SUCCESS if halk.faz_adi == &"gece" else FAILURE
		"eve":
			_bayrak(halk, id, "ev")
			return SUCCESS
		"aksam":
			return SUCCESS if halk.faz_adi == &"aksam" else FAILURE
		"bekle":
			_bayrak(halk, id, "bekle")
			return SUCCESS
		"gunduz":
			return SUCCESS if halk.faz_adi == &"gunduz" else FAILURE
		"is":
			_bayrak(halk, id, "is" if tur != "hayvan" else "otla")
			return SUCCESS
		"hayvan":
			return SUCCESS if tur == "hayvan" else FAILURE
		"dolas":
			_bayrak(halk, id, "dolas")
			return SUCCESS
		_:
			_bayrak(halk, id, "bekle")
			return SUCCESS


func _deger(anahtar: String, yedek: Variant) -> Variant:
	if blackboard != null and blackboard.has_var(anahtar):
		return blackboard.get_var(anahtar)
	return yedek


func _halk() -> KoyHalkHareketi:
	var bulunan = _deger("halk", null)
	return bulunan if bulunan is KoyHalkHareketi else null


func _alarm(halk: KoyHalkHareketi) -> bool:
	var y := halk.sahne.yonetim
	if y == null:
		return false
	if bool(y.get_meta(&"dm_tehlike", false)):
		return true
	return int(y.get_meta(KurtBaskini.META, -1)) == y.gun


func _bayrak(halk: KoyHalkHareketi, id: int, ad: String) -> void:
	var hedef: Node = agent.get_meta(&"govde") if agent != null and agent.has_meta(&"govde") else null
	if hedef != null:
		hedef.set_meta(&"limbo", ad)
	if id >= 0:
		var kisi := halk.sahne.yonetim.koylu(id)
		if kisi != null:
			kisi.set_meta(&"limbo", ad)
