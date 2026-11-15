## Tek görsel uyarlama noktası; mevcut modeller ve kısa isim etiketi.
extends RefCounted
static func kur(f: KarakterModel, k: Koylu) -> void:
	if not k.bayrak_var("kap17_aile") or k.yas_grubu == &"yetiskin" or f.has_meta(&"kap17_yas_etiketi"): return
	if k.yas_grubu == &"cocuk" and Dunya3B.model_var_mi("cocuk_yuru", "karakter"):
		f.set_meta(&"kap17_yas_etiketi", true)
		return
	f.set_meta(&"kap17_yas_etiketi", true)
	var etiket := Label3D.new()
	etiket.text = "Çocuk" if k.yas_grubu == &"cocuk" else "Yaşlı · yer tutucu"
	if k.yas_grubu == &"yasli": f.scale.y *= 0.92
	etiket.position.y = 2.0
	etiket.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	etiket.font_size = 28
	f.add_child(etiket)
