## CHR konum adları → katalog türleri. Hedef kaydı, inşa/üretim uygulaması değildir.
extends RefCounted

const ADLAR := {
	"Ahır": "ahir", "Ağıl": "agil", "Ağıl ve Ahır": ["agil", "ahir"],
	"Bağ": "bag_evi", "Bağ Evi": "bag_evi", "Bez Evi": "bez_evi",
	"Bostan": "bostan", "Demirhane": "demirhane", "Değirmen": "degirmen",
	"Erzak Ambarı": "ambar", "ambar": "ambar", "Han": "han",
	"Harman Yeri": "harman_yeri", "Hendek": "hendek", "Kuyu": "su_kuyusu",
	"Kuyu Evi": "su_kuyusu", "Su Kuyusu": "su_kuyusu", "Köy Meydanı": "koy_meydani",
	"Köy Çeşmesi": "koy_cesmesi", "Muhafız Kışlası": "muhafiz_kislasi",
	"Odunluk": "odunluk", "Ortak Sofra": "ortak_sofra", "Su Arkı": "su_arki",
	"Sur": "sur", "Tamir Sundurması": "tamir_sundurmasi", "Tarla Damı": "tarla_dami",
	"batı kapısı": "bati_kapisi", "dere": "dere", "köy": "koy", "nöbetçi kulesi": "nobetci_kulesi",
	"tarla": "tarla", "zindan": "zindan", "Çivi Ocağı": "civi_ocagi", "Şifahane": "sifahane",
	# Derleyicinin koruduğu kaynak tamlamaları; kişi adı bina türünü değiştirmez.
	"Hayri Bostan": "bostan", "Nazım Harman Yeri": "harman_yeri",
	"alacaklı Bağ Evi": "bag_evi", "anbar emini Tamir Sundurması": "tamir_sundurmasi",
	"davul emini Tarla Damı": "tarla_dami", "lonca adamı Bez Evi": "bez_evi", "müşteri Ahır": "ahir"
}

static func turler(ad: String) -> PackedStringArray:
	var hedef: Variant = ADLAR.get(ad.strip_edges())
	if hedef is String:
		return PackedStringArray([hedef])
	if hedef is Array:
		return PackedStringArray(hedef)
	return PackedStringArray()

## Yeni türler yalnız olay hedefi olarak kaydolur; bedelsiz bina kurulmasına izin verilmez.
static func katalog_ekleri() -> Dictionary:
	var ekler := {}
	for ad in ADLAR:
		for tur in turler(ad):
			if tur in ["ambar", "tarla"] or ekler.has(tur):
				continue
			ekler[tur] = {"kategori": "chr_hedef", "chr_hedef": true, "kurulabilir": false}
	return ekler
