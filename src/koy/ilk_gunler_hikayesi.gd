## İlk günler hikaye akışı ve otomatik akşam sohbeti yönlendiricisi.
class_name IlkGunlerHikayesi
extends RefCounted


static func otomatik_kararlar(o: Oturum) -> Array:
	if o == null:
		return []
	if o.gun == 0:
		return [{"konu_id": "ilk_gece_ocak_ve_aile", "ziyaret_sirasi": 0}]
	if o.gun == 1:
		return [{"konu_id": "ikinci_gun_karaca_giris", "ziyaret_sirasi": 0}]
	if o.gun == 2:
		return [{"konu_id": "ucuncu_gun_ayse_ve_pazar", "ziyaret_sirasi": 0}]
	if o.yonetim != null and o.yonetim.kervan_gunu():
		return [{"konu_id": "tuccar_konaklama_sohbeti", "ziyaret_sirasi": 0}]
	var siradakiler: Array[String] = ["gundelik_sessizlik", "es_yangin_ve_goc", "es_yetim_ve_cocuk", "es_gece_sifasi"]
	var secilen: String = siradakiler[posmod(o.gun, siradakiler.size())]
	return [{"konu_id": secilen, "ziyaret_sirasi": 0}]


static func katilimci_basligi(o: Oturum, konu_id: String) -> String:
	match konu_id:
		"ilk_gece_ocak_ve_aile":
			if o != null and str(o.bayraklar.get(&"acl04_aile_karari", "")) == "kabul":
				return "Katılanlar: Eşin ile Yeni Köylüler (Ali ve Zeynep)"
			return "Katılanlar: Eşin"
		"ikinci_gun_karaca_giris":
			return "Katılanlar: Eşin ile Karaca Usta"
		"ucuncu_gun_ayse_ve_pazar":
			return "Katılanlar: Eşin ile Ayşe Bacı"
		"tuccar_konaklama_sohbeti":
			if o != null and o.yonetim != null:
				var d := GezginTuccarTakvimi.durum(o.yonetim.gun, o.yonetim.a.kervan_araligi)
				if d.aktif:
					return "Katılanlar: Eşin (%s Konaklaması)" % String(d.tuccar.get("ad", "Tüccar"))
			return "Katılanlar: Eşin ve Tüccar Kervanı"
		"misafir_agirlama":
			return "Katılanlar: Eşin ve Hane Misafiri"
		_:
			return "Katılanlar: Eşin"
