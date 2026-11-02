## OGR-07: Ipucu kaydi kayit dosyasindadir.
## Gosterilen her ipucunun kimligi oyun kaydina `ogretici.gorulen` dizisinde yazilir.
## Yeni oyunda sifirlanir; ayarlardan "ipuclarini sifirla" ile de sifirlanir.
## Eski kayitta alan yoksa bos sayilir, oyun cokmez.
class_name IpucuKaydi
extends RefCounted

const BOLUM_ANAHTARI := "ogretici"
const GORULEN_ANAHTARI := "gorulen"

var _gorulen: Array[String] = []
var _kume: Dictionary = {}


func sifirla() -> void:
	_gorulen.clear()
	_kume.clear()


func yeni_oyun() -> void:
	sifirla()


func ipucu_ekle(ipucu_id: String) -> bool:
	var temiz := ipucu_id.strip_edges()
	if temiz.is_empty():
		return false
	if _kume.has(temiz):
		return false
	_kume[temiz] = true
	_gorulen.append(temiz)
	return true


func goruldu_mu(ipucu_id: String) -> bool:
	var temiz := ipucu_id.strip_edges()
	if temiz.is_empty():
		return false
	return _kume.has(temiz)


func gorulen_listesi() -> Array[String]:
	return _gorulen.duplicate()


func gorulen_sayisi() -> int:
	return _gorulen.size()


func sozluge() -> Dictionary:
	return {
		GORULEN_ANAHTARI: _gorulen.duplicate(),
	}


func kayda_yaz(kayit_sozlugu: Dictionary) -> Dictionary:
	var mevcut: Variant = kayit_sozlugu.get(BOLUM_ANAHTARI, {})
	var ogretici_soz: Dictionary = mevcut.duplicate(true) if mevcut is Dictionary else {}
	ogretici_soz[GORULEN_ANAHTARI] = _gorulen.duplicate()
	kayit_sozlugu[BOLUM_ANAHTARI] = ogretici_soz
	return kayit_sozlugu


func kayittan_oku(kayit_sozlugu: Variant) -> bool:
	sifirla()
	if not (kayit_sozlugu is Dictionary):
		return true
	var d: Dictionary = kayit_sozlugu
	var ham_liste: Variant = null
	if d.has(BOLUM_ANAHTARI) and d[BOLUM_ANAHTARI] is Dictionary:
		var ogretici_soz: Dictionary = d[BOLUM_ANAHTARI]
		ham_liste = ogretici_soz.get(GORULEN_ANAHTARI, [])
	elif d.has(GORULEN_ANAHTARI):
		ham_liste = d.get(GORULEN_ANAHTARI, [])
	if ham_liste is Array:
		for oge in ham_liste:
			ipucu_ekle(String(oge))
	return true
