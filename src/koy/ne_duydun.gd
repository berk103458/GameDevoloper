## SOY-09: köylü kartında "Ne duydun?" — köylü ağda duyduğu söylentiyi kendi ağzından söyler.
## En son duyduğu sürümü söyler (bozan kendi bozuk kopyasını); sistem doğru mu yanlış mı olduğunu söylemez.
## Duymayan köylüde dal yoktur; kart okuması ağı kurmaz.
## SOY-20: ikinci seçenek "Bunu konuşma" — güvenilir köylü susar, güvenilmez olan daha çok yayar; oyuncuya sonuç söylenmez.
## SOY-23: aynı kart, duyan köylüde "duydum ki" dalını DIY-09 satır seçicisiyle açar. Ağ kurulmaz.
class_name NeDuydun
extends RefCounted

const SOYLENTI_BAGLAMI = preload("res://src/soz/soylenti_baglami.gd")
const DUYDUM_YOLU := "res://data/soz/soylenti_duydum.json"

static var _duydum_dallar: Array = []


static func kayit(o: Object, k: Koylu) -> Dictionary:
	if o == null or k == null or not o.has_meta(SoylentiKoprusu.META):
		return {}
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var id := str(k.id)
	var secilen := {}
	var en_iyi := -1
	var anahtarlar: Array = a.ag_kayitlari.keys()
	anahtarlar.sort()
	for olay_id in anahtarlar:
		var r: Dictionary = a.ag_kayitlari[olay_id]
		if bool(r.get("hukme_baglandi", false)) or not id in (r.get("duyanlar", []) as Array):
			continue
		var puan := int(r.get("gece", 0))
		if puan > en_iyi:
			en_iyi = puan
			secilen = r
	return secilen


static func metin(o: Object, k: Koylu) -> String:
	var r := kayit(o, k)
	if r.is_empty():
		return ""
	var soz := SoylentiKoprusu.olay_metni(SoylentiKoprusu.ag(o), r)
	return "" if soz.is_empty() else "%s: «%s»" % [k.ad, soz]


## Konuşan karakterin DIY-09 bağlamı. Ağ yoksa kurulmaz; özet false kalır.
static func sohbet_baglami(o: Object, karakter_id: String) -> Dictionary:
	if o == null or not o.has_meta(SoylentiKoprusu.META):
		return {SOYLENTI_BAGLAMI.OZET: false}
	return SOYLENTI_BAGLAMI.baglama_yaz({}, SoylentiKoprusu.ag(o), karakter_id)


## Duyan karakterde "duydum ki" dalı; duymayanda boş.
static func duydum_ki_sec(o: Object, k: Koylu) -> Dictionary:
	if o == null or k == null:
		return {}
	var dallar := _duydum_dallari()
	if dallar.is_empty():
		return {}
	return SatirSecici.new().sec(dallar, sohbet_baglami(o, str(k.id)))


static func duydum_ki_metin(o: Object, k: Koylu) -> String:
	var dal := duydum_ki_sec(o, k)
	if String(dal.get("id", "")) != "duydum_ki":
		return ""
	return _cumle(String(dal.get("metin_anahtari", "")))


static func ekle(ekran: Control, ust: Control, k: Koylu) -> void:
	var soz := metin(ekran.oturum, k)
	if soz.is_empty():
		return
	var sor: Button = ekran._dugme("Ne duydun?", ust)
	sor.name = "ne_duydun"
	sor.pressed.connect(func() -> void:
		sor.disabled = true
		var giris := duydum_ki_metin(ekran.oturum, k)
		var goster := soz if giris.is_empty() else "%s\n%s" % [giris, soz]
		var cevap: Label = ekran._etiket(ust, goster, Tema.KUCUK_PX)
		cevap.name = "ne_duydun_cevabi"
		cevap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ust.move_child(cevap, sor.get_index() + 1)
		var sustur: Button = ekran._dugme("Bunu konuşma", ust)
		sustur.name = "bunu_konusma"
		ust.move_child(sustur, cevap.get_index() + 1)
		sustur.pressed.connect(func() -> void:
			sustur.disabled = true
			sustur.text = susturma_cevabi(ekran.oturum, k)
		)
	)


static func susturma_cevabi(o: Object, k: Koylu) -> String:
	var r := kayit(o, k)
	if not r.is_empty():
		SoylentiKoprusu.ag(o).sustur(str(k.id), String(r.olay_id))
	return "%s başını salladı." % k.ad


static func _duydum_dallari() -> Array:
	if not _duydum_dallar.is_empty():
		return _duydum_dallar
	if not FileAccess.file_exists(DUYDUM_YOLU):
		return []
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(DUYDUM_YOLU))
	if okunan is Dictionary and (okunan as Dictionary).get("dallar") is Array:
		_duydum_dallar = (okunan as Dictionary).get("dallar")
	return _duydum_dallar


static func _cumle(anahtar: String) -> String:
	if anahtar.is_empty() or not GuvenliMetin.anahtar_gibi_mi(anahtar):
		return ""
	var ceviri := String(TranslationServer.translate(anahtar)).strip_edges()
	if ceviri.is_empty() or ceviri == anahtar:
		ceviri = GuvenliMetin.metin(anahtar).strip_edges()
	if ceviri.is_empty() or ceviri == anahtar or ceviri.begins_with(GuvenliMetin.YOK):
		return ""
	return ceviri
