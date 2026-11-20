## Dialogue Manager köprüsü. Söz motorunu ve Parley'i silmez.
## Karar, köyde iş notu, iş gücü düşüşü ve sıradaki kişiye bağlanır. Yeni evrak üretmez.
class_name DmKopru
extends RefCounted

static var _oturum: DmKopru
static var _kaynak: DialogueResource
static var _satir: DialogueLine
static var _anahtarlar: PackedStringArray = PackedStringArray()


static func kapi_satirlari(o: Oturum, g: Gelen) -> PackedStringArray:
	var yol := ""
	var anahtarlar := PackedStringArray()
	if TuccarKapiGecisi.ilgilenir(g):
		yol = _yol("tuccar")
		anahtarlar = PackedStringArray(["harc", "rusvet", "ret"])
	elif g.chr_sorgusu() == null and not DiplomatikHeyet.ilgilenir(g):
		yol = _yol("kapi_sorgu")
		anahtarlar = PackedStringArray(["kabul", "ret"])
	else:
		return PackedStringArray()
	var kaynak := _derle(yol)
	if kaynak == null:
		return PackedStringArray()
	var oturum := _al(o)
	var satir: DialogueLine = await _dm().get_next_dialogue_line(kaynak, "start", [oturum])
	if satir == null:
		return PackedStringArray()
	_kaynak = kaynak
	_satir = satir
	_anahtarlar = anahtarlar
	return PackedStringArray(["[b]%s:[/b] %s" % [satir.character, satir.text]])


static func kapi_uygula(o: Oturum, g: Gelen, anahtar: String) -> void:
	if _satir == null or _kaynak == null:
		return
	var sira := _anahtarlar.find(anahtar)
	if sira < 0 or sira >= _satir.responses.size():
		return
	var yanit: DialogueResponse = _satir.responses[sira]
	var oturum := _al(o)
	oturum.hedef = g
	await _dm().get_next_dialogue_line(_kaynak, yanit.next_id, [oturum])
	_satir = null


static func muhabbet_baslat(yonetici: KoyDiyalogYoneticisi, k: Koylu, y: KoyYonetimi) -> void:
	var kaynak := _derle(_yol("tuccar"))
	if kaynak == null or yonetici == null:
		return
	yonetici.calisiyor = true
	yonetici.koylu = k
	yonetici.yonetim = y
	var oturum := _al(null)
	oturum.yonetim = y
	oturum.koylu = k
	var satir: DialogueLine = await _dm().get_next_dialogue_line(kaynak, "start", [oturum])
	if satir == null:
		yonetici.bitir()
		return
	_kaynak = kaynak
	_satir = satir
	_anahtarlar = PackedStringArray(["harc", "rusvet", "ret"])
	var secenekler: Array = []
	for i in satir.responses.size():
		secenekler.append({"metin": satir.responses[i].text, "id": _anahtarlar[i] if i < _anahtarlar.size() else str(i)})
	yonetici.replik_geldi.emit(satir.character, satir.text, secenekler)


static func muhabbet_sec(yonetici: KoyDiyalogYoneticisi, id: String) -> void:
	if yonetici == null or yonetici.yonetim == null:
		return
	_al(null).yonetim = yonetici.yonetim
	_al(null).koylu = yonetici.koylu
	await kapi_uygula(null, null, id)
	var metin := "Pazar sırası bekler."
	if id == "rusvet":
		metin = "Bugün bir kişinin işi ağırladı."
	elif id == "ret":
		metin = "Konuşma kapandı. Sıradaki kişiye geçildi."
	yonetici.replik_geldi.emit("", metin, [])
	yonetici.bitir()


static func tuccar_muhabbeti(k: Koylu) -> bool:
	return k != null and (k.sinif == &"esnaf" or String(k.ad).to_lower().contains("tüccar") or String(k.ad).to_lower().contains("tuccar"))


var oturum: Oturum
var yonetim: KoyYonetimi
var koylu: Koylu
var hedef: Gelen


func kapi_etki(tur: String, ayrinti: String) -> void:
	var y := _yonetim()
	if y == null:
		return
	y.set_meta(&"dm_is", ayrinti if tur == "is" else tur)
	var kisi := _kisi(y, &"ciftci")
	if tur == "debuff" and kisi != null:
		kisi.is_gucu = minf(kisi.is_gucu, 0.7)
	if kisi != null:
		y.set_meta(&"dm_sonraki", kisi.id)


func tuccar_etki(tur: String) -> void:
	var y := _yonetim()
	if y == null:
		return
	y.set_meta(&"dm_is", tur)
	var esnaf := _kisi(y, &"esnaf")
	if tur == "rusvet":
		var agir := _kisi(y, &"ciftci")
		if agir != null:
			agir.is_gucu = minf(agir.is_gucu, 0.85)
	y.set_meta(&"dm_sonraki", esnaf.id if esnaf != null else -1)


func _yonetim() -> KoyYonetimi:
	if oturum != null:
		return oturum.yonetim
	return yonetim


func _kisi(y: KoyYonetimi, sinif: StringName) -> Koylu:
	if koylu != null and (sinif != &"esnaf" or koylu.sinif == &"esnaf"):
		return koylu
	for k in y.koylular:
		if k.sinif == sinif:
			return k
	return y.koylular[0] if not y.koylular.is_empty() else null


static func _al(o: Oturum) -> DmKopru:
	if _oturum == null:
		_oturum = DmKopru.new()
	if o != null:
		_oturum.oturum = o
		_oturum.yonetim = o.yonetim
	return _oturum


static func _yol(ad: String) -> String:
	var ek := ".en" if TranslationServer.get_locale().begins_with("en") else ""
	return "res://data/diyalog/%s%s.dialogue" % [ad, ek]


static func _dm() -> Node:
	return Engine.get_main_loop().root.get_node(^"/root/DialogueManager")


static func _derle(yol: String) -> DialogueResource:
	if not FileAccess.file_exists(yol):
		return null
	var metin := FileAccess.get_file_as_string(yol)
	var kaynak = _dm().create_resource_from_text(metin)
	return kaynak if kaynak is DialogueResource else null
