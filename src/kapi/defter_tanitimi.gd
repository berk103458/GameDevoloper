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
	return bool(o.get_meta(META_CELISKI, false))


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
	if bool(o.get_meta(META_IPUCU_VERILDI, false)):
		return {"ipucu_goster": false, "metin": ""}
	o.set_meta(META_IPUCU_VERILDI, true)
	var metin := TranslationServer.translate(IPUCU_ID)
	if metin == IPUCU_ID or metin.is_empty():
		metin = "Ziyaretçinin sözlerinde çelişki yakalandı! Beyan defterinden önceki sözlerini inceleyebilirsin."
	return {
		"ipucu_goster": true,
		"anahtar": IPUCU_ID,
		"metin": metin,
	}
