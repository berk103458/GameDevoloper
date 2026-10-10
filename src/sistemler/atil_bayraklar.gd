## SYS-18: olay kartlarında konan ama hiçbir yerde okunmayan Oturum.bayraklar'ı gece/diplomasi
## sonuçlarına bağlar. Mevcut bayrak sözlüğü ve göstergeler kullanılır (KVR-06 Flag_* sözlüğüne
## dokunulmaz, yeni sözlük yok). RNG yok; etkiler haftalık/gecelik ve aynı gece tekrarlanmaz.
extends RefCounted

const META := &"atil_bayrak_son_gece"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/atil_bayraklar.json"))

static func _var(o: RefCounted, b: StringName) -> bool:
	return o.bayraklar.has(b) and o.bayraklar[b] != null and o.bayraklar[b] != false

## Oturum.gece_sonu içinde köy gecesinden sonra (gün ilerlemiş) çağrılır.
static func gece(o: RefCounted, r: Dictionary) -> void:
	var y: KoyYonetimi = o.get("yonetim")
	if y.son != &"" or int(y.get_meta(META, -1)) == y.gun: return
	y.set_meta(META, y.gun)
	var satirlar: Array[String] = []
	# Gecelik: Miraen çavuş sadık kaldı → gece devriyesi asayiş riskini düşürür.
	if _var(o, &"miraen_sadik") and y.asayis_riski > 0:
		y.asayis_riski = maxi(0, y.asayis_riski - int(AYAR.miraen_asayis))
		satirlar.append("Miraen çavuşun devriyesi asayiş riskini −%d düşürdü." % int(AYAR.miraen_asayis))
	# Gecelik: dervişi doyurdun → açık hastalık gecelerinde hastaların moralini dua tutar.
	if _var(o, &"dervis"):
		var n := 0
		for k in y.koylular:
			if SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar:
				k.moral = mini(100, k.moral + int(AYAR.dervis_moral))
				n += 1
		if n > 0: satirlar.append("Derviş duası: %d hastanın morali +%d." % [n, int(AYAR.dervis_moral)])
	if Takvim.hafta_basi(y.gun, y.a.mevsim_gun):
		# Haftalık: Ayşe bacının tezgâhı kiradan köy kasasına akçe getirir.
		if _var(o, &"baci_tezgah"):
			y.akce += int(AYAR.baci_tezgah_akce)
			satirlar.append("Ayşe bacının tezgâhı haftalık %d akçe kira getirdi." % int(AYAR.baci_tezgah_akce))
		# Haftalık diplomasi: Türkmen damgası kini oba husumetini besler.
		if _var(o, &"turkmen_kin"):
			y.husumet.puan += int(AYAR.turkmen_husumet)
			satirlar.append("Türkmen obası damgayı unutmadı: husumet +%d." % int(AYAR.turkmen_husumet))
		# Haftalık: kırgın Thessra'nın dedikodusu adaleti aşındırır.
		if _var(o, &"thessra_kirgin"):
			y.adalet = maxi(0, y.adalet - int(AYAR.thessra_adalet))
			satirlar.append("Kırgın Thessra'nın sözleri dolaşıyor: adalet −%d." % int(AYAR.thessra_adalet))
		# Haftalık: rüşvet adı çıkmış muhafız → asayiş riski (3 rüşvette bir, tavanlı).
		var rusvet := int(o.bayraklar.get(&"rusvet_sayisi", 0))
		if rusvet >= int(AYAR.rusvet_esik):
			var artis := mini(int(AYAR.rusvet_asayis_tavan), rusvet / int(AYAR.rusvet_esik))
			y.asayis_riski = mini(100, y.asayis_riski + artis)
			satirlar.append("Kapıda %d rüşvetin adı çıktı: asayiş riski +%d." % [rusvet, artis])
	if not satirlar.is_empty():
		r.olaylar.append({"anahtar": "atil_bayrak", "atil_bayrak": {"satirlar": satirlar}})
	# BUG-0011: geç etkilerden sonra mevcut raporun kapanışını güncelle.
	r["akce"] = y.akce
	r["huzur"] = y.huzur()

static func olay_metin(e: Dictionary) -> String:
	return "Eski kararların izi · " + " ".join(e.atil_bayrak.satirlar)
