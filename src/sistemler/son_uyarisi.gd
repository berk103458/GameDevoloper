# gdlint: disable=max-line-length
class_name SonUyarisi
extends RefCounted

## OMR-16: Kayıp sonları (isyan, tekfur, halk_kirildi, azil, idam) eşiğe 2 gece kala uyarır.

const UYARI_ANAHTARLARI := {
	"isyan": "uyari.kayip_son.isyan_yaklasti",
	"tekfur": "uyari.kayip_son.tekfur_baskisi_yaklasti",
	"halk_kirildi": "uyari.kayip_son.halk_kirilma_esiginde",
	"azil": "uyari.kayip_son.azil_mufettisi_yolda",
	"idam": "uyari.kayip_son.idam_fermani_yaklasti"
}

const UYARI_METINLERI := {
	"isyan": "Köylüler meydanda fısıldaşıyor, öfke taşmak üzere. İki geceye kalmaz isyan patlak verebilir.",
	"tekfur": "Tekfurun akıncıları sınır boyunda at koşturuyor. Haraç ödenmezse iki geceye köy sarılacak.",
	"halk_kirildi": "Açlık ve sefalet kapıya dayandı. Ambar dolmazsa iki geceye köyde kimse kalmayacak.",
	"azil": "Sancak müfettişinin atlıları uç boyuna yöneldi. Şüpheler yatışmazsa azil kararı çıkacak.",
	"idam": "Hıyanet ve yolsuzluk dedikoduları divana ulaştı. Fermanın çıkması an meselesi."
}

static func erken_uyari_al(kayip_sonu: String, esige_kalan_gece: int) -> Dictionary:
	if esige_kalan_gece > 2 or esige_kalan_gece <= 0:
		return {}

	if not UYARI_ANAHTARLARI.has(kayip_sonu):
		return {}

	return {
		"son": kayip_sonu,
		"anahtar": UYARI_ANAHTARLARI[kayip_sonu],
		"metin": UYARI_METINLERI[kayip_sonu],
		"kalan_gece": esige_kalan_gece
	}
