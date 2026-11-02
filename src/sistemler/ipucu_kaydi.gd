## OGR-07, OGR-10, OGR-51: Ipucu kaydi, tekrar engelleme, hafiza defteri not sayfasi ve kayit onceligi.
## Gosterilen her ipucunun kimligi oyun kaydina `ogretici.gorulen` dizisinde yazilir.
## Yeni oyunda sifirlanir; ayarlardan "ipuclarini sifirla" ile de sifirlanir.
## OGR-10: Gorulen ipucu bir daha gelmez, hafiza defterinin "Not" sayfasinda son 5 ipucu durur.
## OGR-51: Devam kaydinda `ogretici.gorulen` kayittan, `ilk_oyun_bitti` ayardan okunur; celisirse kayit kazanir.
class_name IpucuKaydi
extends RefCounted

const BOLUM_ANAHTARI := "ogretici"
const GORULEN_ANAHTARI := "gorulen"
const DEFTER_NOT_LIMITI := 5

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


## OGR-10: Son gorulen ipuclarini dondurur (varsayilan 5).
func son_ipuclari(limit: int = DEFTER_NOT_LIMITI) -> Array[String]:
	var azami := maxi(0, limit)
	if azami == 0:
		return []
	if _gorulen.size() <= azami:
		return _gorulen.duplicate()
	return _gorulen.slice(_gorulen.size() - azami)


## OGR-10: Bolum 39 hafiza defterinin "Not" sayfasinda en cok 5 satir durur.
func defter_not_sayfasi(limit: int = DEFTER_NOT_LIMITI) -> Array[String]:
	return son_ipuclari(limit)


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
		ham_liste = ogretici_soz.get(GORULEN_ANAHTARI, null)
	elif d.has(GORULEN_ANAHTARI):
		ham_liste = d.get(GORULEN_ANAHTARI, null)
	if ham_liste is Array:
		for oge in ham_liste:
			ipucu_ekle(String(oge))
	return true


## OGR-51: Devam eden kayitta ipucu durumu kayittan gelir; ikisi celisirse kayit kazanir.
## Kayit alani dolu, ayar bos -> ipucu kayit kadar.
static func durum_coz(kayit_sozlugu: Dictionary, _ayar_ilk_oyun_bitti: bool = false) -> Array[String]:
	var ham_liste: Variant = null
	if kayit_sozlugu.has(BOLUM_ANAHTARI) and kayit_sozlugu[BOLUM_ANAHTARI] is Dictionary:
		var ogretici_soz: Dictionary = kayit_sozlugu[BOLUM_ANAHTARI]
		ham_liste = ogretici_soz.get(GORULEN_ANAHTARI, null)
	elif kayit_sozlugu.has(GORULEN_ANAHTARI):
		ham_liste = kayit_sozlugu.get(GORULEN_ANAHTARI, null)

	var sonuc: Array[String] = []
	if ham_liste is Array:
		# Kayit kazanir: kayit icindeki degerler aynen alinir.
		for oge in ham_liste as Array:
			var t := String(oge).strip_edges()
			if not t.is_empty() and not sonuc.has(t):
				sonuc.append(t)
	return sonuc
