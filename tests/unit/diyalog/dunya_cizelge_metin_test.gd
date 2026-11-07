extends SceneTree

const BEKLENEN_SIRALI_IDLER := [
	"mogol_ilerleyisi",
	"selcuklu_taht_kavgasi",
	"bizans_uc_baskisi",
	"kitlik_yili",
	"salgin_dalgasi",
	"ticaret_yolunun_kapanmasi"
]

const BEKLENEN_KAPILAR := {
	"mogol_ilerleyisi": "tehdit_kapisi",
	"selcuklu_taht_kavgasi": "gelen_akisi",
	"bizans_uc_baskisi": "harac",
	"kitlik_yili": "tuketim",
	"salgin_dalgasi": "saglik_yoneticisi",
	"ticaret_yolunun_kapanmasi": "fiyat"
}


func _init() -> void:
	var csv_metin := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	for yol in ["res://data/dunya/zaman_cizelgesi.json", "res://data/dunya/en/zaman_cizelgesi.json"]:
		var veri := _json_oku(yol)
		var olaylar: Variant = veri.get("olaylar", [])
		if not (olaylar is Array) or (olaylar as Array).size() != 6:
			push_error("DNY-01 6 olay olmali: %s" % yol)
			quit(1)
			return

		for i in range(6):
			var olay: Dictionary = (olaylar as Array)[i]
			var id := String(olay.get("id", ""))
			if id != BEKLENEN_SIRALI_IDLER[i]:
				push_error("DNY-01 olay sirasi hatali (%s): beklenen %s, gelen %s" % [yol, BEKLENEN_SIRALI_IDLER[i], id])
				quit(1)
				return
			if id == "mogol_ilerleyisi" and (olay.has("kalan_gun") or String(olay.get("gun_kaynagi", "")) != "har02_sayaci"):
				push_error("DNY-01 Mogol gunleri HAR-02 sayacindan okunmali, ikinci sayac olmamali: %s" % yol)
				quit(1)
				return
			for a in ["ad_anahtari", "kaynak_notu_anahtari"]:
				var anahtar := String(olay.get(a, ""))
				if not csv_metin.contains(anahtar + ","):
					push_error("DNY-01 CSV anahtari eksik: %s" % anahtar)
					quit(1)
					return

			var evreler: Dictionary = olay.get("evreler", {})
			for evre_adi in ["erken_soylenti", "kesin_haber"]:
				var evre: Dictionary = evreler.get(evre_adi, {})
				var replikler: Array = evre.get("replikler", [])
				if replikler.size() < 2:
					push_error("DNY-02 %s evresinde en az 2 replik olmali (%s)" % [evre_adi, id])
					quit(1)
					return
				var m0 := String((replikler[0] as Dictionary).get("metin", "")).strip_edges()
				var m1 := String((replikler[1] as Dictionary).get("metin", "")).strip_edges()
				if m0.is_empty() or m1.is_empty() or m0 == m1:
					push_error("DNY-02 replikler bos veya birebir ayni olamaz (%s - %s)" % [id, evre_adi])
					quit(1)
					return
				for r in replikler:
					var r_anahtar := String((r as Dictionary).get("anahtar", ""))
					if not csv_metin.contains(r_anahtar + ","):
						push_error("DNY-02 CSV anahtari eksik: %s" % r_anahtar)
						quit(1)
						return

			var etki: Dictionary = evreler.get("etki", {})
			if etki.has("ikinci_kapi") or String(etki.get("hedef_kapi", "")) != BEKLENEN_KAPILAR[id]:
				push_error("DNY-03 %s hedef kapisi hatali: %s" % [id, str(etki)])
				quit(1)
				return
			var rapor_anahtari := String(etki.get("rapor_anahtari", ""))
			if not csv_metin.contains(rapor_anahtari + ","):
				push_error("DNY-03 rapor anahtari CSV icinde eksik: %s" % rapor_anahtari)
				quit(1)
				return

		var kararlar: Dictionary = veri.get("geri_donen_kararlar", {})
		if kararlar.size() != 3:
			push_error("DNY-04 geri_donen_kararlar tam 3 karar olmali.")
			quit(1)
			return
		for k_id in ["tekfur_haraci", "mogol_elcisi", "turkmen_ittifaki"]:
			if not kararlar.has(k_id):
				push_error("DNY-04 eksik karar kaydi: %s" % k_id)
				quit(1)
				return
			var k_kayit: Dictionary = kararlar[k_id]
			if k_kayit.has("kalp") or String(k_kayit.get("varsayilan", "")) != "bekliyor":
				push_error("DNY-04 varsayilan bekliyor olmali ve kalp alani olmamali: %s" % k_id)
				quit(1)
				return
			for dal in ["kabul_anahtari", "ret_anahtari", "bekliyor_anahtari"]:
				var d_anahtar := String(k_kayit.get(dal, ""))
				if not csv_metin.contains(d_anahtar + ","):
					push_error("DNY-04 CSV anahtari eksik: %s" % d_anahtar)
					quit(1)
					return

	print("DNY-01..DNY-04 dunya zaman cizelgesi, haber, etki ve karar donusu metin testi gecti.")
	quit(0)


func _json_oku(yol: String) -> Dictionary:
	var ham := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(ham)
	return parsed if parsed is Dictionary else {}
