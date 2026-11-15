## OGR-14: Beyan defteri ilk çelişkide tanıtılır.
## Beyan defteri (DIY-07) ilk kez bir karakter kendi sözüyle çelişince açılır;
## o ana kadar HUD'da düğmesi görünmez. İlk çelişki öncesi düğme 0; sonrası 1 ve ipucu bir kez.
class_name DefterTanitimi
extends RefCounted

const IPUCU_ID := "ogretici.kapi.beyan_defteri"
const META_CELISKI := &"ilk_celiski_goruldu"
const META_IPUCU_VERILDI := &"beyan_defteri_ipucu_verildi"


static func celiski_goruldu_mu(o: Oturum) -> bool:
	if o == null:
		return false
	if bool(o.get_meta(META_CELISKI, false)):
		return true
	return o.ipucu_kaydi != null and o.ipucu_kaydi.goruldu_mu(IPUCU_ID)


static func celiski_kaydet(o: Oturum) -> void:
	if o != null:
		o.set_meta(META_CELISKI, true)


static func dugme_gorunur_mu(o: Oturum, kademeli_hud: bool = true) -> bool:
	if o == null:
		return false
	# Deneyimli oyuncu modu açık ve kademeli HUD kapalıysa doğrudan görünür
	if not kademeli_hud:
		return true
	return celiski_goruldu_mu(o)


static func ipucu_ver(o: Oturum) -> Dictionary:
	if o == null or not celiski_goruldu_mu(o):
		return {"ipucu_goster": false, "metin": ""}
	if bool(o.get_meta(META_IPUCU_VERILDI, false)) or (o.ipucu_kaydi != null and o.ipucu_kaydi.goruldu_mu(IPUCU_ID)):
		return {"ipucu_goster": false, "metin": ""}
	o.set_meta(META_IPUCU_VERILDI, true)
	if o.ipucu_kaydi != null:
		o.ipucu_kaydi.ipucu_ekle(IPUCU_ID)
	var metin := TranslationServer.translate(IPUCU_ID)
	if metin == IPUCU_ID or metin.is_empty():
		metin = "Ziyaretçinin sözlerinde çelişki yakalandı! Beyan defterinden önceki sözlerini inceleyebilirsin."
	return {
		"ipucu_goster": true,
		"anahtar": IPUCU_ID,
		"metin": metin,
	}


static func celiski_yakalandi_mi(celiski: RefCounted, motor: SozMotoru = null, defter: BeyanDefteri = null, sorgu: RefCounted = null) -> bool:
	var c := celiski
	if c == null and motor != null and motor.has_method("celiski"):
		c = motor.celiski()
	if c == null:
		return false
	var cozulen: Variant = c.get("cozulen_celiskiler")
	if cozulen is Dictionary and not (cozulen as Dictionary).is_empty():
		return true
	var kayitlar: Array[Dictionary] = c.call("kayitlari_al", motor, defter, sorgu)
	if kayitlar.size() < 2:
		return false
	var id_set: Dictionary = {}
	for k in kayitlar:
		var kid := String(k.get("id", "")).strip_edges()
		if not kid.is_empty():
			id_set[kid] = true
		var iid := String(k.get("ipucu_id", "")).strip_edges()
		if not iid.is_empty():
			id_set[iid] = true
	var c_list: Variant = c.get("celiskiler")
	if c_list is Array:
		for cift in c_list:
			if cift is Dictionary and id_set.has(String(cift.get("a", ""))) and id_set.has(String(cift.get("b", ""))):
				return true
	if motor != null:
		for cift in motor.celiskiler:
			if cift is Dictionary and id_set.has(String(cift.get("a", ""))) and id_set.has(String(cift.get("b", ""))):
				return true
	for i in range(kayitlar.size()):
		for j in range(i + 1, kayitlar.size()):
			var alt := CeliskiYuzlesme.eslestir(kayitlar[i], kayitlar[j], null)
			if bool(alt.get("basarili", false)):
				return true
	return false


static func oturumda_kontrol_et(o: Oturum, ayarlar: Ayarlar, celiski: RefCounted, motor: SozMotoru = null, defter: BeyanDefteri = null, sorgu: RefCounted = null, ekran: Node = null) -> Dictionary:
	var kademeli := preload("res://src/sistemler/ipucu_anahtari.gd").kademeli_mi(ayarlar)
	if o != null and not celiski_goruldu_mu(o) and celiski_yakalandi_mi(celiski, motor, defter, sorgu):
		celiski_kaydet(o)
	var gorunur := dugme_gorunur_mu(o, kademeli)
	var ipucu := {}
	if o != null and celiski_goruldu_mu(o):
		var ipucu_acik := true if ayarlar == null else preload("res://src/sistemler/ipucu_anahtari.gd").gosterim_acik(ayarlar)
		if ipucu_acik:
			ipucu = ipucu_ver(o)
			if bool(ipucu.get("ipucu_goster", false)):
				preload("res://src/debug/ilk_saat_kancasi.gd").ipucu(o, String(ipucu.get("anahtar", IPUCU_ID)))
				if ekran != null and is_instance_valid(ekran) and ekran.has_method("_yaz"):
					ekran.call("_yaz", "[color=#C4843A]İpucu:[/color] %s" % String(ipucu.get("metin", "")))
	return {
		"gorunur": gorunur,
		"celiski_goruldu": celiski_goruldu_mu(o),
		"ipucu": ipucu,
	}
