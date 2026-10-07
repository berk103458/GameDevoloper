class_name MeslekUyumu
extends RefCounted
const UYGUN := {
	ZanaatTuru.Tur.CIFTCI: ["tarla", "tarla_dami", "harman_yeri"],
	ZanaatTuru.Tur.BOSTANCI: ["bostan"], ZanaatTuru.Tur.COBAN: ["agil", "ahir"],
	ZanaatTuru.Tur.DEGIRMENCI: ["degirmen"], ZanaatTuru.Tur.KALAYCI: ["demirhane", "atolye"],
	ZanaatTuru.Tur.CERRAH: ["sifahane"], ZanaatTuru.Tur.DEMIRCI: ["demir_ocagi", "demirhane", "atolye", "civi_ocagi", "tamir_sundurmasi"],
	ZanaatTuru.Tur.TELLAL: ["han", "koy_meydani"], ZanaatTuru.Tur.KATIP: ["muhafiz_kislasi", "koy_meydani"],
	ZanaatTuru.Tur.OTACI: ["sifahane"], ZanaatTuru.Tur.BAGCI: ["bag_evi"],
	ZanaatTuru.Tur.SU_USTASI: ["su_kuyusu", "su_arki", "koy_cesmesi"],
	ZanaatTuru.Tur.ASKER: ["muhafiz_kislasi", "sur", "hendek", "nobetci_kulesi"],
	ZanaatTuru.Tur.DAVULCU: ["tarla_dami", "harman_yeri", "muhafiz_kislasi"],
	ZanaatTuru.Tur.KESIF_ERI: ["hendek", "nobetci_kulesi", "muhafiz_kislasi"],
	ZanaatTuru.Tur.CEBECI: ["tamir_sundurmasi", "demirhane", "atolye"],
	ZanaatTuru.Tur.SU_TASIYICI: ["su_kuyusu", "koy_cesmesi", "ortak_sofra"],
	ZanaatTuru.Tur.SARAC: ["ahir"], ZanaatTuru.Tur.COMLEKCI: ["su_kuyusu"],
	ZanaatTuru.Tur.BEZCI: ["bez_evi"],
}
const ALET_RISKI := 0.10 # Denge varsayımı: uyumsuz üretimde kişi/gece %10, en çok 1 alet.
static func carpan(k: Koylu, tur: String) -> float:
	if not UYGUN.has(k.zanaat_turu): return 1.0 # Belirsiz/genel esnaf: uzmanlık uydurulmaz.
	# Haydar'ın kaynakta açıkça belirtilen ikinci uzmanlığı çelik dökümcülüğü.
	if k.adli_id == &"chr_003" and tur in ["demirhane", "atolye"]: return 1.6
	return 1.6 if tur in UYGUN[k.zanaat_turu] else 0.5
static func alet_riski(k: Koylu, tur: String) -> float:
	return ALET_RISKI if carpan(k, tur) < 1.0 else 0.0
static func alet_denetimi(y: KoyYonetimi, k: Koylu, b: KoyBinasi, olaylar: Array[Dictionary]) -> void:
	var risk := alet_riski(k, b.tur)
	if risk == 0.0 or y.kaynaklar.miktar("alet") == 0: return
	if y._rng.randf() < risk:
		y.kaynaklar.azalt("alet", 1)
		ZanaatKazalari.alet_kirildi(y, k)
		olaylar.append({"anahtar": "Uyumsuz işte alet kırıldı (köylü %d, bina %d).", "deger": [k.id, b.id]})
