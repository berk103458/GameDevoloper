## HFZ-03, HFZ-13, HFZ-14
## Koy HUD dugmesi ve duraklat girisi. Bu dosya hiz carpani yazmaz.
## Acilinca onceki hiz saklanir; kapaninca ayni deger durur. Kapida cagri yoktur.
class_name HafizaDefteriBaglantisi
extends RefCounted


static func dugme_gorunur(koyde: bool, evre: StringName) -> bool:
	if not koyde:
		return false
	if evre == &"sohbet" or evre == &"karar":
		return false
	return true


static func kur(e: Node, v: VBoxContainer) -> Button:
	var b := Button.new()
	b.name = "defter_ac"
	b.text = e.tr("koy.eylem.defter")
	b.custom_minimum_size.y = 42
	v.add_child(b)
	b.pressed.connect(func() -> void: ac(e))
	return b


static func ac(e: Node) -> HafizaDefteriEkrani:
	if e == null or not dugme_gorunur(true, &""):
		return null
	if e.has_node("HafizaDefteriEkrani"):
		return e.get_node("HafizaDefteriEkrani") as HafizaDefteriEkrani
	var kilit: Variant = e.get("_gece_kilidi")
	if kilit != null and kilit.has_method("kilitli") and kilit.kilitli():
		return null
	if e.get("_ust_kart") != null:
		return null
	var ayar: Ayarlar = e.get("ayarlar") as Ayarlar
	var ekran := _ekran_kur(ayar, kaynak_derle(e.get("oturum")))
	ekran.eski_hiz = int(e.get("_son_hiz"))
	if ayar != null and ayar.degerler.has("okunmus_isaret"):
		ekran.okunmus_isaret = bool(ayar.degerler["okunmus_isaret"])
	e.process_mode = Node.PROCESS_MODE_DISABLED
	e.add_child(ekran)
	ekran.kapandi.connect(func() -> void:
		if is_instance_valid(e) and not e.is_queued_for_deletion():
			e.process_mode = Node.PROCESS_MODE_INHERIT
	)
	return ekran


static func duraklatdan_ac(ana: Node) -> HafizaDefteriEkrani:
	if ana == null or ana.has_node("HafizaDefteriEkrani"):
		return null
	var ayar: Ayarlar = ana.get("ayarlar") as Ayarlar
	var oturum: Variant = ana.get("oturum")
	var ekran := _ekran_kur(ayar, kaynak_derle(oturum))
	ana.add_child(ekran)
	return ekran


static func kaynak_derle(oturum: Variant) -> Dictionary:
	var kaynak := {}
	if oturum == null:
		return kaynak
	if oturum is Oturum:
		kaynak["haberci_agi"] = oturum.haberci_agi.duplicate(true)
	var ipucu: Variant = oturum.get("ipucu_kaydi")
	if ipucu != null and ipucu.has_method("sozluge"):
		kaynak["ogretici"] = ipucu.sozluge()
	var kadro: Variant = oturum.get("kadro")
	if kadro != null and kadro.get("durumlar") is Dictionary:
		kaynak["durumlar"] = (kadro.durumlar as Dictionary).duplicate(true)
	var yonetim: Variant = oturum.get("yonetim")
	if yonetim != null:
		var hukum: Dictionary = DivanHukmu.durum(yonetim)
		var liste: Array = []
		for id in hukum:
			var h: Dictionary = hukum[id]
			var adli := String(h.get("adli_id", ""))
			var ad := ""
			if kadro != null and kadro.durumlar.has(StringName(adli)):
				var kayit: Dictionary = kadro.durumlar[StringName(adli)]
				if kayit.has("ad"):
					ad = String(kayit.get("ad", ""))
				elif kayit.has("ad_anahtari"):
					ad = String(kayit.get("ad_anahtari", ""))
			liste.append({
				"id": "cas07:%s" % str(id),
				"kisi": adli,
				"ad": ad,
				"gece": int(h.get("gun", -1)),
				"hukum": String(h.get("karar", "")),
			})
		if not liste.is_empty():
			kaynak["cas07"] = liste
	return kaynak


static func _ekran_kur(ayar: Ayarlar, kaynak: Dictionary) -> HafizaDefteriEkrani:
	var ekran := HafizaDefteriEkrani.new()
	ekran.name = "HafizaDefteriEkrani"
	ekran.ayarlar = ayar
	ekran.kaynak = kaynak
	ekran.defter = HafizaDefteri.new()
	return ekran
