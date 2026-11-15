## OGR-03: Ikinci gece (gece >= 1) gorunur zar (ZAR-01) ilk kez atildiginda
## "gerekli = değer + 1 + tansiyon eki" formulu tek satirlik ipucuyla bir kez gosterilir
## ve `ilk_saat` kaydina `zar_gosterildi` yazilir.
class_name ZarIpucu
extends RefCounted

const FORMUL_METNI := "gerekli = değer + 1 + tansiyon eki"
const KAYIT_ANAHTARI := "zar_gosterildi"
const IPUCU_KIMLIGI := "zar"


static func zar_gorunur_mu(guncel_gece: int) -> bool:
	return guncel_gece >= 1


## OGR-03 kanonik kural: IlkSaat nesnesi uzerinde tetik ve zar_gosterildi islemini uygular.
static func uygula(ilk_saat: Object, guncel_gece: int) -> Dictionary:
	if ilk_saat == null or not zar_gorunur_mu(guncel_gece) or bool(ilk_saat.get("zar_gosterildi")):
		var mevcut := bool(ilk_saat.get("zar_gosterildi")) if ilk_saat != null else false
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": mevcut}
	var sonuc: Dictionary = ilk_saat.call("tetikle", "ilk_zar_atisi", guncel_gece)
	if not bool(sonuc.get("gosterildi", false)):
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": bool(ilk_saat.get("zar_gosterildi"))}
	ilk_saat.set("zar_gosterildi", true)
	var metin := IlkSaat.ipucu_metni("ogretici.zar.formul")
	if metin.is_empty() or metin == "ogretici.zar.formul":
		metin = FORMUL_METNI
	return {
		"ipucu_sayisi": 1,
		"metin": metin,
		"zar_gosterildi": true,
	}


## Gercek kapida zar atildiginda Oturum + IpucuKaydi uzerinden bir kez ipucu uretir.
static func oturumda_goster(o: Oturum, ayarlar: Ayarlar = null) -> Dictionary:
	if o == null or o.perde != 1 or not zar_gorunur_mu(o.gun):
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": false}
	if o.ipucu_kaydi == null or o.ipucu_kaydi.goruldu_mu(IPUCU_KIMLIGI):
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": true}
	if ayarlar != null and not preload("res://src/sistemler/ipucu_anahtari.gd").gosterilir_mi(ayarlar, o.ipucu_kaydi, IPUCU_KIMLIGI):
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": false}
	o.ipucu_kaydi.ipucu_ekle(IPUCU_KIMLIGI)
	preload("res://src/debug/ilk_saat_kancasi.gd").ipucu(o, IPUCU_KIMLIGI)
	preload("res://src/debug/ilk_saat_kancasi.gd").arac(o, IPUCU_KIMLIGI)
	var metin := IlkSaat.ipucu_metni("ogretici.zar.formul")
	if metin.is_empty() or metin == "ogretici.zar.formul":
		metin = FORMUL_METNI
	return {
		"ipucu_sayisi": 1,
		"metin": metin,
		"zar_gosterildi": true,
	}


## Oyuncu zari attiginda ipucu metnini doner.
## Gece 0'da ya da `zar_gosterildi` zaten kayittaysa bos metin (`""`) ve `ipucu_sayisi: 0` doner.
static func ilk_atis_ipucu(ilk_saat: Variant, guncel_gece: int) -> Dictionary:
	if not zar_gorunur_mu(guncel_gece) or ilk_saat == null:
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": false}
	if ilk_saat is Dictionary:
		var d: Dictionary = ilk_saat
		if bool(d.get(KAYIT_ANAHTARI, false)):
			return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": true}
		d[KAYIT_ANAHTARI] = true
		return {"ipucu_sayisi": 1, "metin": FORMUL_METNI, "zar_gosterildi": true}
	if ilk_saat is Object:
		if ilk_saat.has_method("tetikle"):
			return uygula(ilk_saat, guncel_gece)
		if ilk_saat.has_method("zar_ipucu_kontrol"):
			return ilk_saat.zar_ipucu_kontrol(guncel_gece)
	return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": false}
