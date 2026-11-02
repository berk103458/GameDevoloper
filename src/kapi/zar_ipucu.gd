## OGR-03: Ikinci gece (gece >= 1) gorunur zar (ZAR-01) ilk kez atildiginda
## "gerekli = değer + 1 + tansiyon eki" formulu tek satirlik ipucuyla bir kez gosterilir
## ve `ilk_saat` kaydina `zar_gosterildi` yazilir.
class_name ZarIpucu
extends RefCounted

const FORMUL_METNI := "gerekli = değer + 1 + tansiyon eki"
const KAYIT_ANAHTARI := "zar_gosterildi"


static func zar_gorunur_mu(guncel_gece: int) -> bool:
	return guncel_gece >= 1


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
	if ilk_saat is Object and ilk_saat.has_method("zar_ipucu_kontrol"):
		return ilk_saat.zar_ipucu_kontrol(guncel_gece)
	return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": false}
