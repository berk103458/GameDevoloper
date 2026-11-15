## SOY-28: sabah pusulasının altına tek küçük satır. Pusula cümlesi, satır sayısı ve seçenekler burada değişmez.
## Kaynak kuralı: ağ meta'sı yoksa boş dönülür; SoylentiKoprusu.ag çağrılmaz.
## Ağ varsa kayıtlar olay_id sırasında taranır. Kapanmış kayıt (hükme bağlandı veya susturuldu) atlanır.
## Önce pusula konusu kişiyle ilgili kayıt seçilir: kişi, kaydın kaynak'ı ya da duyanlar içindedir.
## Böyle kayıt yoksa, pusulanın gecesiyle (durum.gun) aynı geceye yazılmış ilk kayıt seçilir.
## Seçilen kaynak, köyde sağ olan bir köylünün kimliği değilse o kayıt atlanır (SOY-45). Hiçbiri kalmazsa boş.
class_name PusulaKaynak
extends RefCounted

const ANAHTAR := "pusula.kaynak.duyan"


static func kaynak_kimligi(o, olay: OlayVerisi) -> int:
	if o == null or olay == null or not FisiltiGazetesi.tanimli(olay) or FisiltiGazetesi.HISTERI.tanimli(olay):
		return -1
	if not o.has_meta(SoylentiKoprusu.META):
		return -1
	var ag: Object = o.get_meta(SoylentiKoprusu.META)
	var kayitlar: Variant = ag.get("ag_kayitlari")
	if not kayitlar is Dictionary:
		return -1
	var y: KoyYonetimi = o.yonetim
	var d := FisiltiGazetesi.durum(y)
	var kisi := str(int(d.get("kisi", -1)))
	var gun := int(d.get("gun", -1))
	var ilgili := ""
	var ayni_gece := ""
	var anahtarlar: Array = (kayitlar as Dictionary).keys()
	anahtarlar.sort()
	for id in anahtarlar:
		var ham: Variant = kayitlar[id]
		if not ham is Dictionary:
			continue
		var k: Dictionary = ham
		if bool(k.get("hukme_baglandi", false)) or bool(k.get("susturuldu", false)):
			continue
		var kaynak := str(k.get("kaynak", "")).strip_edges()
		if not _koyde_yasiyor(y, kaynak):
			continue
		if _ilgili(k, kaynak, kisi) and ilgili.is_empty():
			ilgili = kaynak
		elif int(k.get("gece", -999)) == gun and ayni_gece.is_empty():
			ayni_gece = kaynak
	var secilen := ilgili if not ilgili.is_empty() else ayni_gece
	if secilen.is_empty():
		return -1
	return int(secilen)


static func satir(o, olay) -> String:
	var id := kaynak_kimligi(o, olay)
	if id < 0 or o == null:
		return ""
	var k: Koylu = o.yonetim.koylu(id)
	if k == null or k.ad.is_empty():
		return ""
	return TranslationServer.translate(ANAHTAR) % k.ad


static func ekle(kart_kabi: Control, o, olay) -> Label:
	var id := kaynak_kimligi(o, olay)
	if kart_kabi == null or id < 0:
		return null
	var metin := satir(o, olay)
	if metin.is_empty():
		return null
	var etiket := Label.new()
	etiket.name = "PusulaKaynak"
	etiket.text = metin
	etiket.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	etiket.set_meta(&"metin_anahtari", ANAHTAR)
	etiket.set_meta(&"kaynak_kimligi", id)
	kart_kabi.add_child(etiket)
	return etiket


static func _ilgili(k: Dictionary, kaynak: String, kisi: String) -> bool:
	if kaynak == kisi:
		return true
	var duyanlar: Variant = k.get("duyanlar", [])
	if not duyanlar is Array:
		return false
	for x in duyanlar:
		if str(x) == kisi:
			return true
	return false


static func _koyde_yasiyor(y: KoyYonetimi, kaynak: String) -> bool:
	if not kaynak.is_valid_int():
		return false
	var k := y.koylu(int(kaynak))
	return k != null and k.saglik > 0
